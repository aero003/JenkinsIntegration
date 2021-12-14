public class AccountTriggerHandler 
{

    public static Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafe').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_UK_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeUK').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_US_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeUS').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_CA_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeCA').getRecordTypeId();

    public static Boolean run = true;

    public static Boolean runOnce() {
        if (run) {
            run = false;
            return true;
        }
        return run;
    }

    public static void doAfterInsert(Map<Id, Account> newAccounts) {

        Boolean updatedAccount = false; 
        List<Account> accountsToUpdateSalesOwner = new List<Account>();

        if (runOnce()) 
        {
            syncWithOracle(null, newAccounts, false);
        }

        Set<Id> accountIds = newAccounts.keySet();

        List<Account> accounts = [Select Id, Name, Sales_owner__c, RecordTypeId, ParentId, Support_Level__c FROM Account WHERE Id IN :accountIds];

            for(Account acc : accounts)
            {

                // Temp workaround for KIS IE Record Type - Zeus for IE TESTING PURPOSES
                /*acc.RecordTypeId = RECORD_TYPE_KIS_ID;
                if(!accountsToUpdateSalesOwner.contains(acc))
                {
                    accountsToUpdateSalesOwner.add(acc);
                }*/


                // After insert trigger can't modify the sObject directly - cloning the account
                // Check the record types
                if(acc.RecordTypeId == RECORD_TYPE_KIS_NL_ID ||
                    acc.RecordTypeId == RECORD_TYPE_KIS_ID ||
                    acc.RecordTypeId == RECORD_TYPE_KIS_UK_ID ||
                    acc.RecordTypeId == RECORD_TYPE_KIS_US_ID ||
                    acc.RecordTypeId == RECORD_TYPE_KIS_CA_ID)
                {
                    // Check for parent account
                    if(acc.ParentId != null)
                    {
                        Account Parent = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Id =: acc.ParentId];
                        // Update sales owner field if needed
                        if(acc.Sales_owner__c != Parent.Sales_owner__c)
                        {
                            acc.Sales_owner__c = Parent.Sales_owner__c;
                            updatedAccount = true;
                           
                        }
                        // update accout support level to match with Parrent
                        if (acc.Support_Level__c != Parent.Support_Level__c) 
                        {
                            acc.Support_Level__c= Parent.Support_Level__c;
                            updatedAccount = true;
                            
                        }
                        if (updatedAccount == true)
                        {
                            if(!accountsToUpdateSalesOwner.contains(acc))
                            {
                                accountsToUpdateSalesOwner.add(acc);
                            }
                            updatedAccount= false;
                        }
                    }
                }
            }
        System.Debug('Insert function : Accs for update : ' + accountsToUpdateSalesOwner);
        update accountsToUpdateSalesOwner;
    }

    public static void doAfterUpdate(Map<Id, Account> oldAccounts, Map<Id, Account> newAccounts) {

        List<Account> accountsToUpdateSalesOwner = new List<Account>();
        Boolean updatedAccount = false; 

        if (runOnce()) 
        {
            syncWithOracle(oldAccounts, newAccounts, true);
        }
            Set<Id> accountIds = newAccounts.keySet();

            List<Account> accounts = [SELECT Id, Name, Sales_owner__c, RecordTypeId, ParentId, Support_Level__c FROM Account WHERE Id IN :accountIds];

            // QUICK FIX - 101 QUERIES FOR ACCOUNT WORKFLOW
            // Get account that have updated sales owner / support level => don't use querry for parent where those values didn't change
            List<Account> changedAccounts = new List<Account>();
            List<Id> changedAccountIds = new List<Id>();
            for(Account old : oldAccounts.Values())
            {
                for(Account newAcc : newAccounts.Values())
                {
                    if(old.Id == newAcc.Id)
                    {
                        // Checck if 
                        if(old.Sales_Owner__c != newAcc.Sales_Owner__c)
                        {
                            if(!changedAccountIds.contains(newAcc.Id))
                            {
                                changedAccountIds.add(newAcc.Id);
                            }
                        }
                        if(old.Support_Level__c != newAcc.Support_Level__c)
                        {
                            if(!changedAccountIds.contains(newAcc.Id))
                            {
                                changedAccountIds.add(newAcc.id);
                            }
                        }
                    }
                }
            }

            changedAccounts =[SELECT Id, Sales_Owner__c,ParentId, RecordTypeId, Support_Level__c  FROM Account Where Id IN :changedAccountIds];
            //for(Account acc : accounts)

            //QUICK FIX 101 QUERIES - ACCOUNT WORKFLOW
            for(Account acc : changedAccounts)
            {
                // Check the record types
                if(acc.RecordTypeId == RECORD_TYPE_KIS_NL_ID ||
                    acc.RecordTypeId == RECORD_TYPE_KIS_ID ||
                    acc.RecordTypeId == RECORD_TYPE_KIS_UK_ID ||
                    acc.RecordTypeId == RECORD_TYPE_KIS_US_ID ||
                    acc.RecordTypeId == RECORD_TYPE_KIS_CA_ID)
                {
                    // Verify sales owner if child gets updated
    
                    // Check for parent account
                    if(acc.ParentId != null)
                    {
                        Account Parent = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Id =: acc.ParentId];
                        // Update sales owner field if needed
                        if(acc.Sales_owner__c != Parent.Sales_owner__c)
                        {
                            acc.Sales_owner__c = Parent.Sales_owner__c;
                            updatedAccount = true;
                        }
                         // update accout support level to match with Parrent
                         if (acc.Support_Level__c != Parent.Support_Level__c) 
                         {
                             acc.Support_Level__c= Parent.Support_Level__c;
                             updatedAccount = true;
                             
                         }
                         if (updatedAccount == true)
                         {
                            if(!accountsToUpdateSalesOwner.contains(acc))
                            {
                                accountsToUpdateSalesOwner.add(acc);
                            }
                             updatedAccount= false;
                         }
                    }
    
                    // Verify sales owner if parent gets updated          
                    
                    // Check for children accounts
                    List<Account> children = [SELECT Id, Sales_owner__c, Support_Level__c FROM Account WHERE ParentId=: acc.Id];
                    for(Account child : children)
                    {
                        if(acc.Sales_owner__c != child.Sales_owner__c)
                        {
                            child.Sales_owner__c = acc.Sales_owner__c;
                            updatedAccount = true;
                        }
                        if (acc.Support_Level__c != child.Support_Level__c) 
                        {
                            child.Support_Level__c= acc.Support_Level__c;
                            updatedAccount = true;
                            
                        }
                        if (updatedAccount == true)
                        {
                            if(!accountsToUpdateSalesOwner.contains(acc))
                            {
                                accountsToUpdateSalesOwner.add(acc);
                            }
                            updatedAccount= false;
                        }
                    }
                }
            }
    
        update accountsToUpdateSalesOwner;
    }

    private static void syncWithOracle(Map<Id, Account> oldAccounts, Map<Id, Account> newAccounts, Boolean isUpdate) {
        
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

    private static void syncWithOracle(Map<Id, Account> accounts, Boolean isUpdate, Boolean isActivated, Boolean isInactivated) {

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
}