@isTest
private class OracleSObjectSyncExtTest {
	
	@isTest 
	static void testSyncAccount() {
		Account record = [SELECT Id, Oracle_Service_Cloud_ID__c FROM Account LIMIT 1];

		Test.startTest();
		OracleSObjectSyncExt ctrl = new OracleSObjectSyncExt(new ApexPages.StandardController(record));
		ctrl.sync();

		Test.stopTest();
	}
	
	@isTest 
	static void testSyncContact() {
		Contact record = [SELECT Id, Oracle_Service_Cloud_ID__c FROM Contact LIMIT 1];

		Test.startTest();
		OracleSObjectSyncExt ctrl = new OracleSObjectSyncExt(new ApexPages.StandardController(record));
		ctrl.sync();

		Test.stopTest();
	}
	
	@isTest 
	static void testSyncCase() {
		Case record = [SELECT Id, Oracle_Service_Cloud_ID__c FROM Case LIMIT 1];

		Test.startTest();
		OracleSObjectSyncExt ctrl = new OracleSObjectSyncExt(new ApexPages.StandardController(record));
		ctrl.sync();

		Test.stopTest();
	}
	
	@testSetup 
	static void setup() {
		/*PartnerPortalSettings__c settings = new PartnerPortalSettings__c(Name = 'PortalSettings', 
			SalesforceAPIUserId__c = UserInfo.getUserId());
		insert settings;*/

		OracleSettings__c oracleSettings = new OracleSettings__c(Salesforce_API_User__c = 'test@testing.com');
		insert oracleSettings;

		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Account'));

		//active account
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'Active', 
			'Oracle_Service_Cloud_ID__c' => '123', 'Synced_With_Oracle__c' => true};
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);


		//Account a = [SELECT Id FROM Account LIMIT 1];
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Contact'));

		params = new Map<String, Object> { 'Contact_Status__c' => 'Active', 'AccountId' => a.Id};
		Contact c = TestUtil.createLiveVaultContact(1, params, true).get(0);

		params = new Map<String, Object> { 'Subject' => 'Test Case', 'AccountId' => a.Id,
			'ContactId' => c.Id};
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Contact'));
		Case caze = TestUtil.createLiveVaultCase(1, params, true).get(0);

		params = new Map<String, Object> { 'Name' => 'Test Att', 'ParentId' => caze.Id,
			'Body' => Blob.valueOf('123')};
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Attachment'));
		Attachment att = TestUtil.createAttachment(1, params, true).get(0);

		params = new Map<String, Object> { 'HtmlBody' => 'Test Email', 
			'ParentId' => caze.Id,
			'Incoming' => true};
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Email'));
		EmailMessage e = TestUtil.createEmailMessage(1, params, true).get(0);
	}
	
}