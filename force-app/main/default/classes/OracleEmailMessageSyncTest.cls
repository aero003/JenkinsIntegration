@isTest
private class OracleEmailMessageSyncTest {
	
	@isTest 
	static void testIntegrateWithOracle() {
		Map<Id, Case> cases = new Map<Id, Case>([SELECT Id, Oracle_Service_Cloud_ID__c FROM Case LIMIT 1]);
		Map<String, Object> params = new Map<String, Object> { 'HtmlBody' => 'Test Email', 
			'ParentId' => cases.values().get(0).Id,
			'Incoming' => true};

		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Email'));
		Test.startTest();
		EmailMessage em = TestUtil.createEmailMessage(1, params, true).get(0);
		Test.stopTest();
		Boolean integrateWithOracle = OracleEmailMessageSync.integrateWithOracle(em, cases);
		System.assertEquals(true, 
			integrateWithOracle, 
			'integrateWithOracle should be true.');

	}
	
	@isTest 
	static void testIntegrateWithOracleWithAttachment() {
		Map<Id, Case> cases = new Map<Id, Case>([SELECT Id, Oracle_Service_Cloud_ID__c, Contact.Oracle_Service_Cloud_ID__c FROM Case LIMIT 1]);
		Map<String, Object> params = new Map<String, Object> { 'HtmlBody' => 'Test Email', 
			'ParentId' => cases.values().get(0).Id,
			'Incoming' => true};

		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Email'));
		List<EmailMessage> l = TestUtil.createEmailMessage(1, params, true);
		EmailMessage em = l.get(0);

		params = new Map<String, Object> { 'Name' => 'Test Attachment', 'ParentId' => em.Id, 
			'Body' => Blob.valueOf('XYZ')};

		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Attachment'));
		Attachment att = TestUtil.createAttachment(1, params, true).get(0);

		Test.startTest();
		OracleEmailMessageSync.syncWithOracle(l, cases, false);
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

	}
	
}