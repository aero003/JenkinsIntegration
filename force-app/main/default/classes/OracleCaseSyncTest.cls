@isTest
private class OracleCaseSyncTest {
	
	@isTest 
	static void testIntegrateWithOracle() {
		Account a = [SELECT Id FROM Account LIMIT 1];
		Contact c = [SELECT Id FROM Contact LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Subject' => 'Test Case', 'AccountId' => a.Id,
			'ContactId' => c.Id};
		Test.startTest();
		Case caze = TestUtil.createLiveVaultCase(1, params, true).get(0);
		Test.stopTest();
		//System.assertEquals(true, OracleCaseSync.integrateWithOracle(caze), 'Livevault Case should be integrated.');
	}
	
	@isTest 
	static void testSyncCreatedCases() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Case'));

		Account a = [SELECT Id FROM Account LIMIT 1];
		Contact c = [SELECT Id FROM Contact LIMIT 1];

		Map<String, Object> params = new Map<String, Object> { 'Subject' => 'Test Case', 'AccountId' => a.Id,
			'ContactId' => c.Id};

		Test.startTest();
		Case caze = TestUtil.createLiveVaultCase(1, params, true).get(0);
		Test.stopTest();

		System.assertEquals('6666', 
			[SELECT Oracle_Service_Cloud_ID__c FROM Case WHERE Id = :caze.Id].Oracle_Service_Cloud_ID__c, 
			'Oracle_Service_Cloud_ID__c should be set on the Case.');

	}
	
	/*@isTest 
	static void testSyncCreatedCasesBulk() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Case'));

		Account a = [SELECT Id FROM Account LIMIT 1];
		Contact c = [SELECT Id FROM Contact LIMIT 1];

		Map<String, Object> params = new Map<String, Object> { 'Subject' => 'Test Case', 'AccountId' => a.Id,
			'ContactId' => c.Id};

		Test.startTest();
		List<Case> cases = TestUtil.createLiveVaultCase(10, params, true);
		Test.stopTest();

		System.assertEquals('6666', 
			[SELECT Oracle_Service_Cloud_ID__c FROM Case WHERE Id = :cases.get(0).Id LIMIT 1].Oracle_Service_Cloud_ID__c, 
			'Oracle_Service_Cloud_ID__c should be set on the Case.');

	}*/
	
	@isTest 
	static void testSyncUpdatedCases() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Case'));

		Account a = [SELECT Id FROM Account LIMIT 1];
		Contact c = [SELECT Id FROM Contact LIMIT 1];

		Map<String, Object> params = new Map<String, Object> { 'Subject' => 'Test Case', 'AccountId' => a.Id,
			'ContactId' => c.Id};
		Case caze = TestUtil.createCase(1, params, true).get(0);
		CaseTriggerHandler.run = true;

		Test.startTest();
		//update case
		Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Case', 'LiveVault: Case');
		caze.RecordTypeId = rtInfo.getRecordTypeId();
		update caze;
		Test.stopTest();

		System.assertEquals('6666', 
			[SELECT Oracle_Service_Cloud_ID__c FROM Case WHERE Id = :caze.Id].Oracle_Service_Cloud_ID__c, 
			'Oracle_Service_Cloud_ID__c should be set on the Case.');

	}
	
	@isTest 
	static void testSyncupdatedCasesWithAttachmentIds() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Case'));

		Account a = [SELECT Id FROM Account LIMIT 1];
		Contact c = [SELECT Id FROM Contact LIMIT 1];

		Map<String, Object> params = new Map<String, Object> { 'Subject' => 'Test Case', 'AccountId' => a.Id,
			'ContactId' => c.Id};

		Case caze = TestUtil.createLiveVaultCase(1, params, true).get(0);
		CaseTriggerHandler.run = true;

		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Attachment Download'));

		Test.startTest();
		caze.Oracle_Attachment_Ids__c = '1';
		update caze;
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

	}
	
}