public with sharing class ContactTriggerHandler {

    private static final Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KeepItSafeNL').getRecordTypeId();
    public static final Id RECORD_TYPE_KIS_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KeepItSafe').getRecordTypeId();
    public static Boolean run = true;
    //Check for Contact Trigger (//If update on Contact is called  we should prevent to call Contact update on Account Trigger again)
    public static Boolean hasFiredContactTrigger = false;
    
    public static Boolean runOnce() {
        if (run) {
            run = false;
            return true;
        }
        return run;
    }
    

    public ContactTriggerHandler() {
        
    }
    public void doBeforeInsrtUpdt(List<Contact> list_Contacts){
        for(Contact con: list_Contacts){
            if(con.Access_role__c != null)
            {
                if(con.Access_role__c.contains('Billing'))
                {
                    con.Invoice_Contact__c = true;
                }
            }
        }
    }

    public static void doAfterInsrtUpdt(Map<Id, Contact> newContacts){

        List<Account> accToUpdate = new List<Account>();        
        Map<Id, Id> map_accId_InvoiceContactID = new Map<Id, Id>();
        
        for(Contact con: newContacts.values()){ 
            if(con.AccountId != null){
                if(con.Access_role__c != null && con.Invoice_Contact__c == true){
                    map_accId_InvoiceContactID.put(con.AccountId, con.Id);
                }
            }
        } 
        List<Account> accs = [Select Id, Invoice_Contact__c from Account where Id IN : map_accId_InvoiceContactID.keySet()];
        for(Account acc : accs){
            acc.Invoice_Contact__c = map_accId_InvoiceContactID.get(acc.Id);
            accToUpdate.add(acc);
        } 
        if (accToUpdate.size() > 0)
        {   //If update on Contact is called  we should prevent to call Contact update on Account Trigger again
            ContactTriggerHandler.hasFiredContactTrigger = true;
            update accToUpdate;
        }
    }
    
    public void doAfterInsert(Map<Id, Contact> newContacts) {
        
        if (runOnce()) {
            syncWithOracle(null, newContacts, false);
        }
    }
    
    public void doAfterUpdate(Map<Id, Contact> oldContacts, Map<Id, Contact> newContacts) {
        
        if (runOnce()) {
            syncWithOracle(oldContacts, newContacts, true);
        }
    }
    
    private void syncWithOracle(Map<Id, Contact> oldContacts, Map<Id, Contact> newContacts, Boolean isUpdate) {
        
        Map<Id, Contact> recordsToSync = new Map<Id, Contact>();
        Map<Id, Contact> activatedRecords = new Map<Id, Contact>();
        Map<Id, Contact> inActivatedRecords = new Map<Id, Contact>();
        
        Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Contact', 'LiveVault: Contact');
        Id rtId = rtInfo.getRecordTypeId();        
        
        for (Contact c : newContacts.values()) {
            
            //check if fields changed
            Contact oldContact = (isUpdate) ? oldContacts.get(c.Id) : null;
            
            Boolean integrate = OracleContactSync.integrateWithOracle(c, rtId);
            System.debug('integrate = ' + integrate);
            integrate = integrate || (isUpdate && OracleContactSync.integrateWithOracle(oldContact, rtId));
            System.debug('integrate = ' + integrate);
            
            if (! integrate) {
                System.debug('integrateWithOracle = false');
                continue;
            }
            
            System.debug('integrateWithOracle = true');
            
            if (isUpdate && (! OracleSyncUtil.isChanged(oldContact, c, OracleSyncConstants.CONTACT_FIELD_NAMES))) {
                System.debug('isUpdate and no change.');
                continue;
            }
            
            if (isUpdate &&  OracleContactSync.isActivated(c, oldContact)) {
                System.debug('record activated.');
                activatedRecords.put(c.Id, c);
                continue;
            }
            
            if (isUpdate &&  OracleContactSync.isInactivated(c, oldContact)) {
                System.debug('record Inactivated.');
                inActivatedRecords.put(c.Id, c);
                continue;
            }
            
            recordsToSync.put(c.Id, c);
        }
        
        System.debug('activatedRecords = ' + activatedRecords);
        System.debug('inActivatedRecords = ' + inActivatedRecords);
        System.debug('recordsToSync = ' + recordsToSync);
        
        syncWithOracle(activatedRecords, isUpdate, true, false);
        syncWithOracle(inActivatedRecords, isUpdate, true, true);
        syncWithOracle(recordsToSync, isUpdate, false, false);
        
    }
    
    private void syncWithOracle(Map<Id, Contact> contacts, Boolean isUpdate, Boolean isActivated, Boolean isInactivated) {
        
        Map<Id, Contact> temp = new Map<Id, Contact>();
        Map<Id, Contact> recordsToSync = new Map<Id, Contact>();
        Integer batchSize = (isActivated) ? 10 : 50;
        
        for (Contact c : contacts.values()) {
            recordsToSync.put(c.Id, c);
            if (recordsToSync.size() == batchSize) { //smaller number as there be cases to sync.
                temp.clear();
                temp.putAll(recordsToSync);
                OracleContactSync.sync(temp, isUpdate, isActivated, isInactivated);
                recordsToSync.clear();
            }
            
        }
        
        if ( ! recordsToSync.isEmpty()) {
            OracleContactSync.sync(recordsToSync, isUpdate, isActivated, isInactivated);
        }
    }

    public void updateKISNLContactSalesOwners(List<Contact> newContacts) {

        // retrieve all accounts' Ids to check for account owners
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : newContacts) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
        List<Account> accounts = [SELECT Id, Name, Sales_Owner__c FROM Account WHERE (RecordTypeId = :RECORD_TYPE_KIS_NL_ID OR RecordTypeId = : RECORD_TYPE_KIS_ID) AND Id IN :accountIds];
        // converting to a Map for faster access
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for (Account a : accounts) {
            accountMap.put(a.Id, a);
        }

        // for every contact update the sales owner if needed
        for (Contact c : newContacts) {
            Account acc = accountMap.get(c.AccountId);
            if (acc != null && acc.Sales_Owner__c != null)
             { // TODO: assuming we do not want to have ownerless contacts 
                c.OwnerId = acc.Sales_Owner__c;
             }
        }
    }
}