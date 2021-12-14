public with sharing class OracleSyncConstants {

/*************ACCOUNT FIELD MAPPING ***************************************/

	public static final List<String> ACCOUNT_FIELD_NAMES = new List<String> {
		'Name', 'Alt_Phone_Number__c', 'Fax', 'Livevault_Product__c', 
        'OwnerId', 'ParentId', 'phone', 'Primary_Contact__c', 'RecordTypeId', 'AccountSource', 'Secondary_Partner_Contact__c',
        'Account_Status__c', 'Website', 'Brand__c', 'Customer_Id__c', 'CreatedDate'
    };

	public static final List<String> ACCOUNT_OTHER_FIELD_NAMES = new List<String> {
	};

    public static final Map<String, String> ACCOUNT_FIELD_MAPPING = new Map<String, String> {
    	'OwnerId' => 'Owner.Name', 'RecordTypeId' => 'RecordType.Name',
    	'Secondary_Partner_Contact__c' => 'Secondary_Partner_Contact__r.Name'
    };

/*************CONTACT FIELD MAPPING ***************************************/

	public static final List<String> CONTACT_FIELD_NAMES = new List<String> {
		'Title', 'FirstName', 'LastName', 'Email', 'AssistantPhone', 'MailingStreet', 'MailingCity', 'MailingState', 
		'MailingCountry', 'MailingPostalCode', 'Fax', 'HomePhone', 'MobilePhone', 'Phone', 'OwnerId', 
		'RecordTypeId', 'Contact_Status__c', 'AccountId'
    };

	public static final List<String> CONTACT_OTHER_FIELD_NAMES = new List<String> {
		'Account.Oracle_Service_Cloud_ID__c', 'LastModifiedDate', 'CreatedDate'
	};

    public static final Map<String, String> CONTACT_FIELD_MAPPING = new Map<String, String> {
    	'OwnerId' => 'Owner.Name', 'RecordTypeId' => 'RecordType.Name'
    };   

/*************CASE FIELD MAPPING ***************************************/

	public static final List<String> CASE_FIELD_NAMES = new List<String> {
		'Subject', 'Description', 'AccountId', 'ContactId',
		'RecordTypeId', 'OwnerId', 'Reason', 'Origin', 'Priority', 'Status','Product__c', 'CaseNumber'
    };

	public static final List<String> CASE_OTHER_FIELD_NAMES = new List<String> {
		'Account.Oracle_Service_Cloud_ID__c', 'Contact.Oracle_Service_Cloud_ID__c',  'LastModifiedDate', 'CreatedDate'
	};

    public static final Map<String, String> CASE_FIELD_MAPPING = new Map<String, String> {
    	'OwnerId' => 'Owner.Name', 'RecordTypeId' => 'RecordType.Name'
    };  
}