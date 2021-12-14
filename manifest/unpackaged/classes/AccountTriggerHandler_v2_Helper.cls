public with sharing class AccountTriggerHandler_v2_Helper {

    public static final Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId();
    public static final Id RECORD_TYPE_KIS_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafe').getRecordTypeId();
    
    public static void FormatAccBillingStreet(List<Account> accounts)
    {
        String formatedBillingAddress='';
        List<String> FormatBilligAddress_List= new List<String>();
    
        for (Account acc : accounts)
        {
            if(acc.BillingStreet!=null && acc.BillingStreet!='')
            {
                FormatBilligAddress_List= acc.BillingStreet.split('\r\n',0);
                if(FormatBilligAddress_List.size()>3)
                {
                    formatedBillingAddress=FormatBilligAddress_List[0]+'\r\n'+FormatBilligAddress_List[1]+'\r\n';
                    integer i = 0;
                        for (i=2; i<FormatBilligAddress_List.size(); i++)
                        { 
                        
                                if(i!=FormatBilligAddress_List.size()-1)
                                {
                                formatedBillingAddress+=FormatBilligAddress_List[i]+' / ';
                                } else 
                                
                                formatedBillingAddress+=FormatBilligAddress_List[i];
                        }
                    acc.BillingStreet=formatedBillingAddress;
                }
            }
        }
    }

   /* public static List<Account> Hierarchy_KeepItSafe_LiveVault(List<Account> newAccounts, Map<Id, Account> newAccountsMap, Map<Id,Account> oldAccountsMap, Boolean isUpdate)
    {        

        // Need to create variables (lists, maps) to mimic the trigger.new / trigger.newMap etc.
        // Those variables will be function inputs
        List<Account> updaterecords = new List<Account>();
        List<Account> acclist = newAccounts;
        
        //initialize three list, i) for special attention, ii) high revenue, iii) Support Level and iV) when parent account is updated
        list <Account> updatechildrecords_sa = new list <Account> ();
        list <Account> updatechildrecords_hr = new list <Account> ();
        list <Account> updatechildrecords_sl = new list <Account> ();
        list <Account> updateFromParentRecords_hr = new list <Account> ();
        
        //List <RecordType> rIdlist = [Select Name,Id,sobjecttype From RecordType where (Name like '%KeepItSafe%' or Name like '%LiveVault%' ) and sobjecttype='Account'];
        //new map of record type with ID
        Map<ID, RecordType> rIdMap = new Map<Id, RecordType>([Select Name,Id,sobjecttype From RecordType where (Name like '%KeepItSafe%' or Name like '%LiveVault%' ) and sobjecttype='Account']);
        
        //grab children of all account (done before hand to avoid query in for loop)
        List<Account> globalChildAccount = new List<Account>();
        if(isUpdate){
            globalChildAccount = [Select Id, Name, ParentId, Customer_ID2__c, RecordTypeId, Special_Attention__c, High_Revenue__c, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c from Account where Id in :newAccountsMap.keyset()];
            system.debug('globalChildAccount------>'+globalChildAccount);    
        }
        List<ID> allParentID = new List<ID>();
        
        

        for(Account a: acclist)
        {
            if( string.isNotEmpty(a.ParentId) )
            {
                allParentID.add(a.ParentID);
            }
        }
        
        //grab all parent account(will be useful if parent account is updated)
        List<Account> globalParentAccount = [Select Id, Name, ParentId, Customer_ID2__c, Special_Attention__c, RecordTypeId, High_Revenue__c, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c from Account where ID in :allParentID];
        
        // for loop of inserted/updated account 
        if(isUpdate){
            Boolean needsUpdate = false;

            for(Account a : acclist){
                system.debug('account id is ' + a.Id);
                
                
                //condition to check if special attention field is updated or not
                //if(oldAccountsMap.get(a.ID) != null)
                //{

                    if(rIdMap.containsKey(a.RecordTypeId) ){// && (oldAccountsMap.get(a.ID).Special_Attention__c != a.Special_Attention__c )){
                        //looping through list of globalchildAccount to get child accounts of this particular account
                        for(Account cldAcc: globalChildAccount){
                            if(cldAcc.ParentId == a.Id){
                                cldAcc.Special_Attention__c = a.Special_Attention__c;
                                //add to special attention list, which we will update at the end
                                if(!updaterecords.contains(cldAcc))
                                {
                                    updaterecords.add(cldAcc);
                                }
                                needsUpdate = true;
                            }
                        }
                    }
                
                    //check if high revenue field is udpated
                    if(rIdMap.containsKey(a.RecordTypeId) ){// && (oldAccountsMap.get(a.ID).High_Revenue__c != a.High_Revenue__c )){
                        //looping through list of globalchildAccount to get child accounts of this particular account
                        for(Account cldAcc: globalChildAccount){
                            if(cldAcc.ParentId == a.Id){
                                cldAcc.High_Revenue__c = a.High_Revenue__c;
                                //add to high revenue list, which we will update at the end
                                if(!updaterecords.contains(cldAcc))
                                {
                                    updaterecords.add(cldAcc);
                                }
                                needsUpdate = true;
                            }
                        }
                    }
                    //check if Support Level field is udpated or not
                    if(rIdMap.containsKey(a.RecordTypeId) ){// //&& (oldAccountsMap.get(a.ID).Support_Level__c != a.Support_Level__c )){
                        //looping through list of globalchildAccount to get child accounts of this particular account
                        for(Account cldAcc: globalChildAccount){
                            if(cldAcc.ParentId == a.Id){
                                cldAcc.Support_Level__c = a.Support_Level__c;
                                //add to high revenue list, which we will update at the end
                                if(!updaterecords.contains(cldAcc))
                                {
                                    updaterecords.add(cldAcc);
                                }
                                needsUpdate = true;
                            }
                        }
                    }
                    //check condition if parent id is updated or not
                    if(rIdMap.containsKey(a.RecordTypeId) ){// && (oldAccountsMap.get(a.ID).ParentId != a.ParentId )){
                        //Account parentAcc = [Select ID,High_Revenue__c, Special_Attention__c,Support_Level__c from Account where ID = : a.ParentId][0];
                        Account parentAcc = new Account();
                        for(Account prntAcc : globalParentAccount){
                            if(prntAcc.ID == a.ParentId){
                                parentAcc = prntAcc;
                            }
                        }
                        //if parent is not null then add add parent to list, which we will update later.
                        if(parentAcc != null)
                        {
                            a.High_Revenue__c = parentAcc.High_Revenue__c;
                            a.Special_Attention__c = parentAcc.Special_Attention__c;
                            a.Support_Level__c = parentAcc.Support_Level__c;
                            if(!updaterecords.contains(a))
                            {
                                updaterecords.add(a);
                            }
                            needsUpdate = true; 
                        }
                    }
                //}
            }
            // Update statement ran only upon update events - if it is needed
            if(needsUpdate)
            {
                //update updaterecords;
                return updaterecords;
            }
            else 
            {
                return null;
            }
        }
        else {
            for(Account a : newAccounts){
                //if trigger is insert -> which means there cannot be any child of it, we will only check condition of parent
                if(rIdMap.containsKey(a.RecordTypeId)  && ( string.isNotEmpty(a.ParentId) )){
                    system.debug('parent id is :: ' + a.ParentId);
                    
                    //get parent account id
                    Account parentAcc = new Account();
                    for(Account prntAcc : globalParentAccount){
                        if(prntAcc.ID == a.ParentId){
                            parentAcc = prntAcc;
                        }
                    }
                    if(parentAcc != null){
                        if(a.High_Revenue__c == false){
                            a.High_Revenue__c = parentAcc.High_Revenue__c; 
                        }
                        if(a.Special_Attention__c == false){
                            a.Special_Attention__c = parentAcc.Special_Attention__c;
                        }
                        if(a.Support_Level__c == null){
                            a.Support_Level__c = parentAcc.Support_Level__c;
                        }
                        //updateFromParentRecords_hr.add(a);
                    }
                }
            }
            return null;
        }
    }*/

    
    public static void syncWithOracle(Map<Id, Account> oldAccounts, Map<Id, Account> newAccounts, Boolean isUpdate) 
    {
        
        Map<Id, Account> recordsToSync = new Map<Id, Account>();
        Map<Id, Account> activatedRecords = new Map<Id, Account>();
        Map<Id, Account> inActivatedRecords = new Map<Id, Account>();
        
        Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Account', 'LiveVault: Account');
		Id rtId = rtInfo.getRecordTypeId();

        for (Account a : newAccounts.values()) {
            //check if fields changed
            Account oldAccount = (isUpdate) ? oldAccounts.get(a.Id) : null;

            Boolean integrate = OracleAccountSync.integrateWithOracle(a, rtId);

            //if account is being inactivated we still need to call oracle to set the inactive state.
            integrate = integrate || (isUpdate && OracleAccountSync.integrateWithOracle(oldAccount, rtId));
            System.debug('integrate Account: = ' + a.Id + ' : ' + integrate);

            if (! integrate) {
                continue;
            }

            if (isUpdate && (! OracleSyncUtil.isChanged(oldAccount, a, OracleSyncConstants.ACCOUNT_FIELD_NAMES))) {
                continue;
            }

            if (isUpdate &&  OracleAccountSync.isActivated(a, oldAccount)) {
                activatedRecords.put(a.Id, a);
                continue;
            }

            if (isUpdate &&  OracleAccountSync.isInactivated(a, oldAccount)) {
                inActivatedRecords.put(a.Id, a);
                continue;
            }

            recordsToSync.put(a.Id, a);
        }

        System.debug('activatedRecords = ' + activatedRecords);
        System.debug('inActivatedRecords = ' + inActivatedRecords);
        System.debug('recordsToSync = ' + recordsToSync);

        syncWithOracle(activatedRecords, isUpdate, true, false);
        syncWithOracle(inActivatedRecords, isUpdate, true, true);
        syncWithOracle(recordsToSync, isUpdate, false, false);
    }

    public static void syncWithOracle(Map<Id, Account> accounts, Boolean isUpdate, Boolean isActivated, Boolean isInactivated) 
    {

        Map<Id, Account> temp = new Map<Id, Account>();
        Map<Id, Account> accountsToSync = new Map<Id, Account>();
        Integer batchSize = (isActivated) ? 10 : 50;

        for (Account a : accounts.values()) {
            accountsToSync.put(a.Id, a);
            if (accountsToSync.size() == batchSize) { //smaller number as there be contacts/cases to sync.
                temp.clear();
                temp.putAll(accountsToSync);
                OracleAccountSync.sync(temp, isUpdate, isActivated, isInactivated);
                accountsToSync.clear();
            }

        }

        if ( ! accountsToSync.isEmpty()) {
            OracleAccountSync.sync(accountsToSync, isUpdate, isActivated, isInactivated);
        }
    } 

    public static void KeepItSafeNLUpdateContacOwners(Map<Id, Account> oldAccounts, List<Account> newAccounts)
    {

        List<Contact> listOfUpdatedContacts = new List<Contact>();
        Map<Id, Account> accountChangedOwnerMap = new Map <Id, Account>();    

        //check if account was updated (new added or existing changed)  
        if (newAccounts!=null) 
        {
            for (Account newAcc : newAccounts)
            {
                accountChangedOwnerMap.put(newAcc.Id, newAcc);
            }
        }

        Set<Id> AccId = accountChangedOwnerMap.keySet();
        // get the list of Contacts for the account that owner has changed
        List<Contact> contacts = [SELECT Id, OwnerId, AccountId, MailingCountry FROM Contact WHERE AccountId IN :AccId];
        for(Contact con : contacts)
        {
            Account acc = accountChangedOwnerMap.get(con.AccountId);
            // Check if Sales owner on Account has changed?
            if ( acc!=null && con.OwnerID != acc.Sales_Owner__c)
            {
                // set new Sales onwer to Contact (OwnerID)
                if(acc.Sales_Owner__c != null)
                {
                   con.OwnerID = acc.Sales_Owner__c;
                }
                if (con.MailingCountry == null ||  String.isEmpty(con.MailingCountry))
                {
                    // cannot be null because validation rule does not allow empty MailingCountry
                    if(acc.RecordTypeId==RECORD_TYPE_KIS_NL_ID)
                    {
                       con.MailingCountry='NL';
                    }
                    else 
                    {
                       con.MailingCountry='IE';
                    }                    
                }
                listOfUpdatedContacts.add(con);
            }
        }
        if (listOfUpdatedContacts.size() > 0)
        {
            update listOfUpdatedContacts;
        }
    } 
    
}