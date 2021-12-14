@isTest
private class OracleAttachmentSyncTest {
	
	@isTest 
	static void testIntegrateWithOracle() {
		Map<Id, Case> cases = new Map<Id, Case>([SELECT Id FROM Case LIMIT 1]);
		Map<String, Object> params = new Map<String, Object> { 'Name' => 'Test Attachment', 'ParentId' => cases.values().get(0).Id, 
			'Body' => Blob.valueOf('XYZ')};

		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Attachment'));
		Test.startTest();
		Attachment att = TestUtil.createAttachment(1, params, true).get(0);
		Test.stopTest();
		Boolean integrateWithOracle = OracleAttachmentSync.integrateWithOracle(att, cases);
		System.assertEquals(true, 
			integrateWithOracle, 
			'integrateWithOracle should be true.');

	}
	
	@isTest 
	static void testIntegrateWithOracleBulk() {
		Map<Id, Case> cases = new Map<Id, Case>([SELECT Id FROM Case LIMIT 1]);
		Map<String, Object> params = new Map<String, Object> { 'Name' => 'Test Attachment', 'ParentId' => cases.values().get(0).Id, 
			'Body' => Blob.valueOf('XYZ')};

		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Attachment'));
		Test.startTest();
		List<Attachment> att = TestUtil.createAttachment(10, params, true);
		Test.stopTest();
		Boolean integrateWithOracle = OracleAttachmentSync.integrateWithOracle(att.get(0), cases);
		System.assertEquals(true, 
			integrateWithOracle, 
			'integrateWithOracle should be true.');

	}
	
	@isTest 
	static void testDownload() {
		Case c = [SELECT Id FROM Case LIMIT 1];
		Map<Id, String> caseIdsWithAttachmentIds = new Map<Id, String>{c.Id => '1,2'};

		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Attachment Download'));
		Test.startTest();
		OracleAttachmentSync.download(caseIdsWithAttachmentIds);
		Test.stopTest();
		List<Attachment> l = [SELECT Name, Description, Body FROM Attachment WHERE ParentId = :c.Id];
		System.assertEquals(2, 
			l.size(), 
			'There should be 2 attachments created.');
		System.assertEquals('X Files', 
			l.get(0).Name, 
			'Name of Attachment should be X Files.');

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