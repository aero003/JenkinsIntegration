@isTest
private class OracleContactSyncTest {
	
	@isTest 
	static void testIntegrateWithOracle() {
		Account a = [SELECT Id FROM Account LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Contact_Status__c' => 'Active', 'AccountId' => a.Id};
		Test.startTest();
		Contact c = TestUtil.createLiveVaultContact(1, params, true).get(0);
		Test.stopTest();
		//System.assertEquals(true, OracleContactSync.integrateWithOracle(c), 'Active Livevault Contact should be integrated.');
	}
	
	@isTest 
	static void testIsActivated() {
		Account a = [SELECT Id FROM Account LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Contact_Status__c' => 'Inactive', 'AccountId' => a.Id};
		Contact c = TestUtil.createLiveVaultContact(1, params, true).get(0);

		params = new Map<String, Object> { 'Contact_Status__c' => 'Active', 'AccountId' => a.Id};
		Contact c1 = TestUtil.createLiveVaultContact(1, params, true).get(0);
		System.assertEquals(true, OracleContactSync.isActivated(c1, c), 'Active Livevault Contact should  be activated.');
	}
	
	@isTest 
	static void testIsInactivated() {
		Account a = [SELECT Id FROM Account LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Contact_Status__c' => 'Active', 'AccountId' => a.Id};
		Contact c = TestUtil.createLiveVaultContact(1, params, true).get(0);

		params = new Map<String, Object> { 'Contact_Status__c' => 'Inactive', 'AccountId' => a.Id};
		Contact c1 = TestUtil.createLiveVaultContact(1, params, true).get(0);
		System.assertEquals(true, OracleContactSync.isInactivated(c1, c), 'Active Livevault Contact should  be inactivated.');
	}
	
	@isTest 
	static void testSyncCreatedContacts() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Contact'));

		Account a = [SELECT Id FROM Account LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Contact_Status__c' => 'Active', 'AccountId' => a.Id};
		

		Test.startTest();
		Contact c = TestUtil.createLiveVaultContact(1, params, true).get(0);
		Test.stopTest();
		System.assertEquals('5555', 
			[SELECT Oracle_Service_Cloud_ID__c FROM Contact WHERE Id = :c.Id].Oracle_Service_Cloud_ID__c, 
			'Oracle_Service_Cloud_ID__c should be set on the Contact.');

	}
	
	@isTest 
	static void testSyncUpdatedContacts() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Contact'));

		Account a = [SELECT Id FROM Account LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Contact_Status__c' => 'Active', 'AccountId' => a.Id};
		

		Test.startTest();
		Contact c = TestUtil.createLiveVaultContact(1, params, true).get(0);
		c.FirstName = 'Updated Name';
		c.Synced_With_Oracle__c = false;
		update c;
		Test.stopTest();
		System.assertEquals(true, 
			[SELECT Synced_With_Oracle__c FROM Contact WHERE Id = :c.Id].Synced_With_Oracle__c, 
			'Synced_With_Oracle__c should be true.');
	}
	
	@isTest 
	static void testSyncActivatedContacts() {
		//set the mock
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Contact'));

		Account a = [SELECT Id FROM Account LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Contact_Status__c' => 'Inactive', 'AccountId' => a.Id};

		Test.startTest();
		Contact c = TestUtil.createLiveVaultContact(1, params, true).get(0);
		System.assertEquals(false, 
			[SELECT Synced_With_Oracle__c FROM Contact WHERE Id = :c.Id].Synced_With_Oracle__c, 
			'Synced_With_Oracle__c should be false.');

		//for testing
		ContactTriggerHandler.run = true;

		//update the account to make it active
		c.Contact_Status__c = 'Active';
		update c;
		Test.stopTest();

		//assertions
		System.assertEquals(true, 
			[SELECT Synced_With_Oracle__c FROM Contact WHERE Id = :c.Id].Synced_With_Oracle__c, 
			'Synced_With_Oracle__c should be true.');
		System.assertEquals('5555', 
			[SELECT Oracle_Service_Cloud_ID__c FROM Contact WHERE Id = :c.Id].Oracle_Service_Cloud_ID__c, 
			'Oracle_Service_Cloud_ID__c should be set on the Contact.');
	}
	
	@isTest 
	static void testSyncInactivatedContacts() {
		//set the mock
		//set the mock
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Contact'));

		Account a = [SELECT Id FROM Account LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'Contact_Status__c' => 'Active', 'AccountId' => a.Id};

		Test.startTest();
		Contact c = TestUtil.createLiveVaultContact(1, params, true).get(0);

		//for testing
		ContactTriggerHandler.run = true;

		//update the account to make it inactive
		System.debug('Now Inactivating Contact.');
		c.Contact_Status__c = 'Inactive';
		update c;
		Test.stopTest();

		//assertions
		System.assertEquals(false, 
			[SELECT Synced_With_Oracle__c FROM Contact WHERE Id = :c.Id].Synced_With_Oracle__c, 
			'Synced_With_Oracle__c should be false.');
		System.assertEquals('5555', 
			[SELECT Oracle_Service_Cloud_ID__c FROM Contact WHERE Id = :c.Id].Oracle_Service_Cloud_ID__c, 
			'Oracle_Service_Cloud_ID__c should be set on the Contact.');
	}
	
	@testSetup 
	static void setup() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Account'));

		//active account
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'Active', 
			'Oracle_Service_Cloud_ID__c' => '123', 'Synced_With_Oracle__c' => true};
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);

		/*PartnerPortalSettings__c settings = new PartnerPortalSettings__c(Name = 'PortalSettings', 
			SalesforceAPIUserId__c = UserInfo.getUserId());
		insert settings;*/

	}

}