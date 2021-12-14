public with sharing class OracleContactSync {
    public OracleContactSync() {
        
    } 

    /*public static Boolean integrateWithOracle(Contact c) {
        Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Contact', 'LiveVault: Contact');
        return (c.Contact_Status__c == 'Active' && c.Integrate_With_Oracle__c && rtInfo.getRecordTypeId() == c.RecordTypeId);
    }*/  

    public static Boolean integrateWithOracle(Contact c, Id recordTypeId) {
        //Account a = [SELECT Id, RecordType.Name, Oracle_Service_Cloud_ID__c,Account_Status__c FROM Account LIMIT 1];
        return (c.Contact_Status__c == 'Active' && c.Integrate_With_Oracle__c && recordTypeId == c.RecordTypeId);
    } 

    public static Boolean isActivated(Contact c, Contact oldContact) {
        return (c.Contact_Status__c == 'Active' && oldContact.Contact_Status__c != 'Active');
    }

    public static Boolean isInactivated(Contact c, Contact oldContact) {
        System.debug('oldContact.Contact_Status__c = ' + (oldContact.Contact_Status__c == 'Active'));
        System.debug('c.Contact_Status__c = ' + (c.Contact_Status__c));
        return (oldContact.Contact_Status__c == 'Active' && c.Contact_Status__c != 'Active');
    } 

    public static void sync(Map<Id, Contact> contacts, Boolean isUpdate, Boolean isActivated, Boolean isInactivated) {
        sync(contacts, isUpdate, isActivated, isInactivated, null);
    }  

    public static void sync(Map<Id, Contact> contacts, Boolean isUpdate, Boolean isActivated, Boolean isInactivated,
        Map<Id, String> activatedAccountIds) 
    {
        if (System.isBatch() || System.isFuture()) {
            OracleContactSync.syncWithOracle(new List<Id>(contacts.keySet()), isUpdate, isActivated, isInactivated, activatedAccountIds);
        } else {
            OracleContactSync.syncWithOracleFuture(new List<Id>(contacts.keySet()), isUpdate, isActivated, isInactivated, activatedAccountIds);
        }
    } 


    @future(callout=true)
    public static void syncWithOracleFuture(List<Id> contactIds, Boolean isUpdate, Boolean isActivated, Boolean isInactivated,
        Map<Id, String> activatedAccountIds) 
    {
        syncWithOracle(contactIds, isUpdate, isActivated, isInactivated, activatedAccountIds);
    }

    public static void syncWithOracle(List<Id> contactIds, Boolean isUpdate, Boolean isActivated, Boolean isInactivated,
        Map<Id, String> activatedAccountIds) 
    {
        List<Contact> contacts = new List<Contact>();

        if (activatedAccountIds != null) {
            contacts = OracleSyncDAO.getContactsForAccounts(activatedAccountIds.keySet());
            for (Contact c : contacts) {
                if (c.Account.Oracle_Service_Cloud_ID__c == null) {
                    c.Account.Oracle_Service_Cloud_ID__c = activatedAccountIds.get(c.AccountId);
                }
            }
        } else {
            contacts = OracleSyncDAO.getContacts(contactIds);
        }

        syncWithOracle(contacts, isUpdate, isActivated, isInactivated);
    }

    public static void syncWithOracle(List<Contact> contacts, Boolean isUpdate, Boolean isActivated, Boolean isInactivated) {

        List<Contact> updatedContacts = new List<Contact>();
        List<Oracle_Error__c> errors = new List<Oracle_Error__c>();

        Map<Id, String> activatedContactIds = new Map<Id, String>();

        for (Contact c : contacts) {
            OracleContact oContact = createOracleContact(c);
            HttpRequest req = null;

            if (c.Oracle_Service_Cloud_ID__c != null) {
                req = OracleService.createHttpRequest('/contacts/' + c.Oracle_Service_Cloud_ID__c , 'POST');
                req.setHeader('X-HTTP-Method-Override','PATCH');
                //+ '?_HttpMethod=PATCH'
            } else {
                req = OracleService.createHttpRequest('/contacts', 'POST');
            }

            req.setHeader('prefer', 'exclude-null-properties');
            req.setBody(JSON.serializePretty(oContact));

            Contact updatedContact = new Contact(Id = c.Id);
            updatedContacts.add(updatedContact);

            try {
                String response = OracleService.send(req);
                System.debug('response = ' + response);

                updatedContact.Synced_With_Oracle__c = true;

                if (c.Oracle_Service_Cloud_ID__c == null) {
                    Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(response);
                    Integer id = m.get('id') == null ? null : (Integer) m.get('id');
                    updatedContact.Oracle_Service_Cloud_ID__c = String.valueOf(id);
                }

                if (isActivated) {
                    activatedContactIds.put(c.Id, updatedContact.Oracle_Service_Cloud_ID__c);
                }

                if (isInactivated) {
                    updatedContact.Synced_With_Oracle__c = false;
                }

            } catch(OracleService.OracleException e) {
                updatedContact.Synced_With_Oracle__c = false;
                errors.add(OracleSyncUtil.createErrorLog(e, 'Contact__c', c.id));
            } catch(Exception e) {
                updatedContact.Synced_With_Oracle__c = false;
                errors.add(OracleSyncUtil.createErrorLog(e, 'Contact__c', c.id));
            }

        }

        if (isActivated & errors.isEmpty()) {
            syncCasesForActivatedContactsWithOracle(activatedContactIds);
        }
        /* IMP: update after syncing contacts otherwise will get uncommitted work error***/


        if (!updatedContacts.isEmpty()) {
            update updatedContacts;
        }

        if (!errors.isEmpty()) {
            insert errors;
        }

    }

    public static OracleContact createOracleContact(Contact c) {

        OracleContact oContact = new OracleContact();
        
        //set address
        OracleContact.Address address = new OracleContact.Address();
        address.street = c.MailingStreet;
        address.city = c.MailingCity;
        address.postalCode = c.MailingPostalCode;

        OracleObject.LookupByName country = new OracleObject.LookupByName();
        country.lookupName = c.MailingCountry;
        if (String.isNotEmpty(c.MailingCountry)) {
            address.country = country;
        }
        

        OracleObject.LookupByName state = new OracleObject.LookupByName();
        state.lookupName = c.MailingState;
        if (String.isNotEmpty(c.MailingState)) {
            address.stateOrProvince = state;
        }
        

        oContact.address = address;

        //custom fields
        OracleContact.c x = new OracleContact.c();
        x.salesforce_id = c.Id;
        x.record_type_name = c.RecordType.Name;
        x.phone = c.Phone;
        x.salesforce_last_modified_date = c.LastModifiedDate;
        x.salesforce_date_created = c.CreatedDate;
        x.contact_owner = c.Owner.Name;

        OracleObject.LookupByName salesforce_status = new OracleObject.LookupByName();
        salesforce_status.lookupName = c.Contact_Status__c;
        x.salesforce_status = salesforce_status;

        //set the custom fields
        OracleContact.CustomFields customFields = new OracleContact.CustomFields();
        customFields.c = x;
        oContact.customFields = customFields;

        //name
        OracleContact.Name name = new OracleContact.Name();
        name.first = c.FirstName;
        name.last = c.LastName;
        oContact.name = name;

        //NameFurigana
        OracleContact.NameFurigana nameFurigana = new OracleContact.NameFurigana();
        nameFurigana.first = c.FirstName;
        nameFurigana.last = c.LastName;
        oContact.nameFurigana = nameFurigana;

        //organization
        OracleObject.LookupById org = new OracleObject.LookupById();
        org.Id = Integer.valueOf(c.Account.Oracle_Service_Cloud_ID__c);
        oContact.organization = org;

        //login
        oContact.login = c.Email;

        //email
        OracleObject.LookupByName addressType = new OracleObject.LookupByName();
        addressType.lookupName = 'Email - Primary';
        OracleContact.Emails emails = new OracleContact.Emails();
        emails.address = c.Email;
        emails.addressType = addressType;
        oContact.emails = emails;

        //title
        oContact.title = c.title;

        return oContact;
    }

    public static void syncCasesForActivatedContactsWithOracle(Map<Id, String> activatedContactIds) {
        Map<Id, Case> cases = new Map<Id, Case>(OracleSyncDAO.getCasesForContacts(activatedContactIds.keySet()));
        OracleCaseSync.sync(cases, false);

    }
}