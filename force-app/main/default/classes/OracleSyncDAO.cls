public with sharing class OracleSyncDAO {

	/*********Accounts *************************/


    public static List<Account> getAccounts(List<Id> accountIds) {

        String query = 'SELECT Id, Oracle_Service_Cloud_ID__c';
        for (String fieldName : OracleSyncConstants.ACCOUNT_FIELD_NAMES) {
            fieldName = (OracleSyncConstants.ACCOUNT_FIELD_MAPPING.containsKey(fieldName))
                ? OracleSyncConstants.ACCOUNT_FIELD_MAPPING.get(fieldName) : fieldName;

            query += ', ' + fieldName;
        }

        for (String fieldName : OracleSyncConstants.ACCOUNT_OTHER_FIELD_NAMES) {
            query += ', ' + fieldName;
        }

        query += ' FROM Account WHERE Id IN :accountIds';
        return Database.query(query);           
    }

	/*********Contacts *************************/



    public static List<Contact> getContacts(List<Id> contactIds) {
       String query = 'SELECT Id, Oracle_Service_Cloud_ID__c';
        for (String fieldName : OracleSyncConstants.CONTACT_FIELD_NAMES) {
            fieldName = (OracleSyncConstants.CONTACT_FIELD_MAPPING.containsKey(fieldName))
                ? OracleSyncConstants.CONTACT_FIELD_MAPPING.get(fieldName) : fieldName;

            query += ', ' + fieldName;
        }

        for (String fieldName : OracleSyncConstants.CONTACT_OTHER_FIELD_NAMES) {
            query += ', ' + fieldName;
        }

        query += ' FROM Contact WHERE Id IN :contactIds';
        return Database.query(query);           

    }

    public static List<Contact> getContactsForAccounts(Set<Id> accountIds) {
        Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Contact', 'LiveVault: Contact');
        Id recordTypeId = rtInfo.getRecordTypeId();

        String query = 'SELECT Id, Oracle_Service_Cloud_ID__c';
        for (String fieldName : OracleSyncConstants.CONTACT_FIELD_NAMES) {
            fieldName = (OracleSyncConstants.CONTACT_FIELD_MAPPING.containsKey(fieldName))
                ? OracleSyncConstants.CONTACT_FIELD_MAPPING.get(fieldName) : fieldName;

            query += ', ' + fieldName;
        }

        for (String fieldName : OracleSyncConstants.CONTACT_OTHER_FIELD_NAMES) {
            query += ', ' + fieldName;
        }

        query += ' FROM Contact WHERE AccountId IN :accountIds AND RecordTypeId = :recordTypeId';

        System.debug('query = ' + query);
        return Database.query(query);           

    }


	/*********Cases *************************/



    public static List<Case> getCases(List<Id> caseIds) {
        String query = 'SELECT Id, Oracle_Service_Cloud_ID__c';
        for (String fieldName : OracleSyncConstants.CASE_FIELD_NAMES) {
            fieldName = (OracleSyncConstants.CASE_FIELD_MAPPING.containsKey(fieldName))
                ? OracleSyncConstants.CASE_FIELD_MAPPING.get(fieldName) : fieldName;

            query += ', ' + fieldName;
        }

        for (String fieldName : OracleSyncConstants.CASE_OTHER_FIELD_NAMES) {
            query += ', ' + fieldName;
        }

        query += ' FROM Case WHERE Id IN :caseIds';
        return Database.query(query);           

    }

    public static List<Case> getCasesForContacts(Set<Id> contactIds) {
        Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Case', 'LiveVault: Case');
        Id recordTypeId = rtInfo.getRecordTypeId();

        String query = 'SELECT Id, Oracle_Service_Cloud_ID__c';
        for (String fieldName : OracleSyncConstants.CASE_FIELD_NAMES) {
            fieldName = (OracleSyncConstants.CASE_FIELD_MAPPING.containsKey(fieldName))
                ? OracleSyncConstants.CASE_FIELD_MAPPING.get(fieldName) : fieldName;

            query += ', ' + fieldName;
        }

        for (String fieldName : OracleSyncConstants.CASE_OTHER_FIELD_NAMES) {
            query += ', ' + fieldName;
        }

        query += ' FROM Case WHERE ContactId IN :contactIds AND IsClosed = false AND RecordTypeId = :recordTypeId';
        return Database.query(query);           

    }

    public static List<Case> getBasicCaseInfo(Set<Id> caseIds) {
        return [SELECT Id, Oracle_Service_Cloud_ID__c, Oracle_Attachment_Ids__c, Contact.Oracle_Service_Cloud_ID__c 
                FROM Case WHERE Id IN :caseIds]; 
    }


	/*********Emails *************************/

    public static List<EmailMessage> getMessages(List<Id> messageIds) {

        return [SELECT Id, ParentId, TextBody, HtmlBody, Incoming, Headers, HasAttachment FROM EmailMessage WHERE Id IN :messageIds];
    }


    public static Map<Id, List<EmailMessage>> getMessagesFromCases(List<Case> cases) {

        Map<Id, List<EmailMessage>> m = new Map<Id, List<EmailMessage>>();
        //List<EmailMessage> messages = [SELECT Id, ParentId, TextBody, Incoming, Headers FROM EmailMessage WHERE ParentId IN :cases];

        for (EmailMessage em : [SELECT Id, ParentId, TextBody, HtmlBody, Incoming, Headers, HasAttachment FROM EmailMessage WHERE ParentId IN :cases]) {
            Id parentId = em.ParentId;
            List<EmailMessage> messages = m.containsKey(parentId) ? m.get(parentId) : new List<EmailMessage>();
            m.put(parentId, messages);
            messages.add(em);
        }
        return m;
    }

	/*********ATTAchments *************************/

    public static List<Attachment> getAttachments(List<Id> attachmentIds) {
    	return [SELECT Id, Name, ParentId, Description, Body, ContentType, BodyLength FROM Attachment WHERE Id IN :attachmentIds];
    } 

    public static List<Attachment> getAttachmentsFromEmails(Map<Id, EmailMessage> messagesWithAttachments) {
    	return [SELECT Id, Name, ParentId, Description, Body, ContentType, BodyLength 
    			FROM Attachment WHERE ParentId IN :messagesWithAttachments.keySet()];
    }

    public static List<Attachment> getAttachmentsFromCases(Set<Id> caseIds) {
        return [SELECT Id, Name, ParentId, Description, Body, ContentType, BodyLength FROM Attachment WHERE ParentId IN :caseIds];
    }
}