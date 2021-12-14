@isTest
private class OracleSyncExtTest {
	
	@isTest 
	static void testSyncWithAccount() {
		Account a = [SELECT Id FROM Account LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Account__c' => a.Id};

		Oracle_Error__c error = TestUtil.createOracleException(1, params, true).get(0);
		
		Test.startTest();
		OracleSyncExt ctrl = new OracleSyncExt(new ApexPages.StandardController(error));
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Account'));
		ctrl.sync();

		Test.stopTest();
	}
	
	@isTest 
	static void testSyncWithContact() {
		Contact c = [SELECT Id FROM Contact LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Contact__c' => c.Id};

		Oracle_Error__c error = TestUtil.createOracleException(1, params, true).get(0);
		
		Test.startTest();
		OracleSyncExt ctrl = new OracleSyncExt(new ApexPages.StandardController(error));
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Contact'));
		ctrl.sync();

		Test.stopTest();
	}
	
	@isTest 
	static void testSyncWithCase() {
		Case c = [SELECT Id FROM Case LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Case__c' => c.Id};

		Oracle_Error__c error = TestUtil.createOracleException(1, params, true).get(0);
		
		Test.startTest();
		OracleSyncExt ctrl = new OracleSyncExt(new ApexPages.StandardController(error));
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Case'));
		ctrl.sync();

		Test.stopTest();
	}
	
	@isTest 
	static void testSyncWithAttachment() {
		Case c = [SELECT Id FROM Case LIMIT 1];
		Attachment att = [SELECT Id FROM Attachment LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Case__c' => c.Id, 'Attachment__c' => att.Id};

		Oracle_Error__c error = TestUtil.createOracleException(1, params, true).get(0);
		
		Test.startTest();
		OracleSyncExt ctrl = new OracleSyncExt(new ApexPages.StandardController(error));
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Case'));
		ctrl.sync();

		Test.stopTest();
	}
	
	@isTest 
	static void testSyncWithEmailMessage() {
		Case c = [SELECT Id FROM Case LIMIT 1];
		EmailMessage e = [SELECT Id FROM EmailMessage LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Case__c' => c.Id, 'Email_Message__c' => e.Id};

		Oracle_Error__c error = TestUtil.createOracleException(1, params, true).get(0);
		
		Test.startTest();
		OracleSyncExt ctrl = new OracleSyncExt(new ApexPages.StandardController(error));
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Case'));
		ctrl.sync();

		Test.stopTest();
	}
	
	@testSetup 
	static void setup() {
		/*PartnerPortalSettings__c settings = new PartnerPortalSettings__c(Name = 'PortalSettings', 
			SalesforceAPIUserId__c = UserInfo.getUserId());
		insert settings; */

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