public with sharing class TestUtil {

	/********************************************* Account ****************************************/

	public static List<Account> createAccount(Integer noOfRecords, Map<String, Object> params, Boolean create) {
		List<Account> l = new List<Account>();
		for (Integer i = 0; i < noOfRecords; i++) {
			Account record = new Account(Name = 'test' + i);
			l.add(record);
			setParams(record, params);
		}
		if (create) {
			insert l;
		}
		return l;
	}

	public static List<Account> createLiveVaultAccount(Integer noOfRecords, Map<String, Object> params, Boolean create) {
		Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Account', 'LiveVault: Account');
		params.put('RecordTypeId', rtInfo.getRecordTypeId());
		return createAccount(noOfRecords, params, create);
	}

/********************************************* Contact ****************************************/

	public static List<Contact> createContact(Integer noOfRecords, Map<String, Object> params, Boolean create) {
		List<Contact> l = new List<Contact>();
		for (Integer i = 0; i < noOfRecords; i++) {
			Contact record = new Contact(FirstName = 'test' + i, LastName = 'Tester' + i);
			l.add(record);
			setParams(record, params);
		}
		if (create) {
			insert l;
		}
		return l;
	}

	public static List<Contact> createLiveVaultContact(Integer noOfRecords, Map<String, Object> params, Boolean create) {
		Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Contact', 'LiveVault: Contact');
		params.put('RecordTypeId', rtInfo.getRecordTypeId());
		return createContact(noOfRecords, params, create);
	}

/********************************************* Case ****************************************/

	public static List<Case> createCase(Integer noOfRecords, Map<String, Object> params, Boolean create) {
		List<Case> l = new List<Case>();
		for (Integer i = 0; i < noOfRecords; i++) {
			Case record = new Case();
			l.add(record);
			setParams(record, params);
		}
		if (create) {
			insert l;
		}
		return l;
	}

	public static List<Case> createLiveVaultCase(Integer noOfRecords, Map<String, Object> params, Boolean create) {
		Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Case', 'LiveVault: Case');
		params.put('RecordTypeId', rtInfo.getRecordTypeId());
		return createCase(noOfRecords, params, create);
	}

/********************************************* Attachment ****************************************/

	public static List<Attachment> createAttachment(Integer noOfRecords, Map<String, Object> params, Boolean create) {
		List<Attachment> l = new List<Attachment>();
		for (Integer i = 0; i < noOfRecords; i++) {
			Attachment record = new Attachment();
			l.add(record);
			setParams(record, params);
		}
		if (create) {
			insert l;
		}
		return l;
	}

/********************************************* EmailMessage ****************************************/

	public static List<EmailMessage> createEmailMessage(Integer noOfRecords, Map<String, Object> params, Boolean create) {
		List<EmailMessage> l = new List<EmailMessage>();
		for (Integer i = 0; i < noOfRecords; i++) {
			EmailMessage record = new EmailMessage();
			l.add(record);
			setParams(record, params);
		}
		if (create) {
			insert l;
		}
		return l;
	}

/********************************************* Oracle_Error__c ****************************************/

	public static List<Oracle_Error__c> createOracleException(Integer noOfRecords, Map<String, Object> params, Boolean create) {
		List<Oracle_Error__c> l = new List<Oracle_Error__c>();
		for (Integer i = 0; i < noOfRecords; i++) {
			Oracle_Error__c record = new Oracle_Error__c(Error_Code__c = '111',
				Instance__c = '222', Status__c = 100, Title__c = 'ERROR', Type__c = 'Test Error');
			l.add(record);
			setParams(record, params);
		}
		if (create) {
			insert l;
		}
		return l;
	}


/********************************************* Common ****************************************/

	public static void setParams(SObject obj, Map<String, Object> params) {
		for (String fieldName : params.keySet()) {
			obj.put(fieldName, params.get(fieldName));
		}
	}

}