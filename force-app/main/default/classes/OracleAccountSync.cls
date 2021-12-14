public with sharing class OracleAccountSync {

    /*public static Boolean integrateWithOracle(Account a) {
        Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Account', 'LiveVault: Account');
        return  (a.Account_Status__c == 'Active'
            && rtInfo.getRecordTypeId() == a.RecordTypeId);
    }*/

    public static Boolean integrateWithOracle(Account a, Id recordTypeId) {
        return  (a.Account_Status__c == 'Active'
            && recordTypeId == a.RecordTypeId);
    }  

    public static Boolean isActivated(Account a, Account oldAccount) {
        return (oldAccount.Account_Status__c != 'Active' && a.Account_Status__c == 'Active');
    }

    public static Boolean isInActivated(Account a, Account oldAccount) {
        System.debug('isInActivated():oldAccount.Account_Status__c = ' + oldAccount.Account_Status__c);
        System.debug('isInActivated():a.Account_Status__c = ' + a.Account_Status__c);
        return (oldAccount.Account_Status__c == 'Active' && a.Account_Status__c != 'Active');
    }

    public static void sync(Map<Id, Account> accounts, Boolean isUpdate, Boolean isActivated, Boolean isInactivated) {
        if (System.isBatch() || System.isFuture()) {
            syncWithOracle(accounts.values(), isUpdate, isActivated, isInactivated);
        } else {
            syncWithOracleFuture(new List<Id>(accounts.keySet()), isUpdate, isActivated, isInactivated);
        }
    }

    @future(callout=true)
    public static void syncWithOracleFuture(List<Id> accountIds, Boolean isUpdate, Boolean isActivated, Boolean isInactivated) {
        syncWithOracle(accountIds, isUpdate, isActivated, isInactivated);
    }

    public static void syncWithOracle(List<Id> accountIds, Boolean isUpdate, Boolean isActivated, Boolean isInactivated) {
        List<Account> accounts = OracleSyncDAO.getAccounts(accountIds);
        syncWithOracle(accounts, isUpdate, isActivated, isInactivated);
    }

    public static void syncWithOracle(List<Account> accounts, Boolean isUpdate, Boolean isActivated, Boolean isInactivated) {

    	List<Account> updatedAccounts = new List<Account>();
    	List<Oracle_Error__c> errors = new List<Oracle_Error__c>();

        Map<Id, String> activatedAccountIds = new Map<Id, String>();

    	for (Account a : accounts) {
            Account updatedAccount = new Account(Id = a.Id);
            updatedAccounts.add(updatedAccount);

        	OracleOrganization oOrg = createOracleOrganization(a);
	        HttpRequest req = null;

	        if (String.isNotEmpty(a.Oracle_Service_Cloud_ID__c)) {
	        	req = OracleService.createHttpRequest('/organizations/' + a.Oracle_Service_Cloud_ID__c , 'POST');
	        	req.setHeader('X-HTTP-Method-Override','PATCH');
	        } else {
	        	req = OracleService.createHttpRequest('/organizations', 'POST');
	        } 

	        req.setBody(JSON.serializePretty(oOrg));

	        try {

	        	String response = OracleService.send(req);
	        	System.debug('response = ' + response);

                updatedAccount.Synced_With_Oracle__c = true;

	        	if (String.isEmpty(a.Oracle_Service_Cloud_ID__c)) {
		        	Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(response);
		        	Integer id = m.get('id') == null ? null : (Integer) m.get('id');
                    updatedAccount.Oracle_Service_Cloud_ID__c = String.valueOf(id);
	        	}

                if (isActivated) {
                    activatedAccountIds.put(a.Id, updatedAccount.Oracle_Service_Cloud_ID__c);
                }

                if (isInactivated) {
                    updatedAccount.Synced_With_Oracle__c = false;
                }

	        } catch(OracleService.OracleException e) {
                updatedAccount.Synced_With_Oracle__c = false;
	        	errors.add(OracleSyncUtil.createErrorLog(e, 'Account__c', a.id));
	        } catch(Exception e) {
                updatedAccount.Synced_With_Oracle__c = false;
	        	errors.add(OracleSyncUtil.createErrorLog(e, 'Account__c', a.id));
	        }

    	}

        if (isActivated & errors.isEmpty()) {
            syncContactsForActivatedAccountsWithOracle(activatedAccountIds);
        }
        /* IMP: update after syncing contacts otherwise will get uncommitted work error***/

        if (!updatedAccounts.isEmpty()) {
            update updatedAccounts;
        }

    	if (!errors.isEmpty()) {
    		insert errors;
    	}

    }

    public static OracleOrganization createOracleOrganization(Account a) {
        OracleOrganization.c x = new OracleOrganization.c();
        x.account_name = a.Name;
        x.alt_phone = a.Alt_Phone_Number__c;
        x.fax = a.Fax;
        x.livevault_product = a.Livevault_Product__c;
        x.owner_name = a.Owner.Name;
        x.parent_id = a.ParentId;
        x.phone = a.phone;
        x.primary_contact = a.Primary_Contact__c;
        x.record_type_name = a.RecordType.Name;
        x.salesforce_date_created = a.CreatedDate;  //String.valueOf(a.CreatedDate.getTime()/1000);	// a.CreatedDate.format();	//.format('MM/DD/YYYY'); //.format('YYYY-MM-DD')
        x.salesforce_id = a.Id;
        x.salesforce_source = a.AccountSource;
        x.secondary_partner_contact = a.Secondary_Partner_Contact__r.Name;
        x.status = a.Account_Status__c;
        x.website = a.Website;
        x.brand = a.Brand__c;
        x.customer_id = a.Customer_Id__c;

        OracleOrganization.CustomFields cf = new OracleOrganization.CustomFields();
        cf.c = x;

        OracleOrganization oOrg = new OracleOrganization();
        oOrg.name = a.Id;
        oOrg.customFields = cf;

        return oOrg;
    }

    public static void syncContactsForActivatedAccountsWithOracle(Map<Id, String> activatedAccountIds) {
        Map<Id, Contact> contacts = new Map<Id, Contact>(OracleSyncDAO.getContactsForAccounts(activatedAccountIds.keySet()));
        /*for (Contact c : contacts.values()) {
            if (c.Account.Oracle_Service_Cloud_ID__c == null) {
                c.Account.Oracle_Service_Cloud_ID__c = activatedAccountIds.get(c.AccountId);
            }
        }*/
        OracleContactSync.sync(contacts, true, true, false, activatedAccountIds);

    }
}