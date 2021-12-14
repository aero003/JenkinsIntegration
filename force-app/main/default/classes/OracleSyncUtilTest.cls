@isTest
private class OracleSyncUtilTest {
	
	@isTest 
	static void testSyncAccountError() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Error'));
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'Active'};
		

		Test.startTest();
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);
		Test.stopTest();

	}
	
	@isTest 
	static void testSyncAccountUnhandledError() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Account Error'));
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'Active'};
		

		Test.startTest();
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);
		Test.stopTest();

	}
	
	@isTest 
	static void testSyncAttachmentError() {
		Map<Id, Case> cases = new Map<Id, Case>([SELECT Id FROM Case LIMIT 1]);
		Map<String, Object> params = new Map<String, Object> { 'Name' => 'Test Attachment', 'ParentId' => cases.values().get(0).Id, 
			'Body' => Blob.valueOf('XYZ')};

		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Account Error'));
		Test.startTest();
		Attachment att = TestUtil.createAttachment(1, params, true).get(0);
		Test.stopTest();

	}
	
	@isTest 
	static void testSyncAttachmentUnhandledError() {
		Map<Id, Case> cases = new Map<Id, Case>([SELECT Id FROM Case LIMIT 1]);
		Map<String, Object> params = new Map<String, Object> { 'Name' => 'Test Attachment', 'ParentId' => cases.values().get(0).Id, 
			'Body' => Blob.valueOf('XYZ')};

		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Error'));
		Test.startTest();
		Attachment att = TestUtil.createAttachment(1, params, true).get(0);
		Test.stopTest();

	}
	
	@isTest 
	static void testIsChanged() {
		Account a1 = new Account(Name = 'Test1');
		Account a2 = new Account(Name = 'Test2');
		Test.startTest();
		OracleSyncUtil.isChanged(a1, a2, new List<String>{'Name'});
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

	}
	
}