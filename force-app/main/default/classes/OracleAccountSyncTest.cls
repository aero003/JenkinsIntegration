@isTest
private class OracleAccountSyncTest {
	
	@isTest 
	static void testIntegrateWithOracle() {
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'Active'};
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);
        Schema.RecordTypeInfo rtInfo = OracleSyncUtil.getRecordTypeByName('Account', 'LiveVault: Account');
		Id rtId = rtInfo.getRecordTypeId();
        
		System.assertEquals(true, OracleAccountSync.integrateWithOracle(a, rtId), 'Active Livevault Account should be integrated.');
	}
	
	@isTest 
	static void testIsActivated() {
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'InActive'};
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);
		//update to active
		params = new Map<String, Object> { 'Account_Status__c' => 'Active'};
		Account a1 = TestUtil.createLiveVaultAccount(1, params, true).get(0);
		System.assertEquals(true, OracleAccountSync.isActivated(a1, a), 'Account is activated.');
	}
	
	@isTest 
	static void testIsInactivated() {
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'Active'};
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);
		//update to active
		params = new Map<String, Object> { 'Account_Status__c' => 'InActive'};
		Account a1 = TestUtil.createLiveVaultAccount(1, params, true).get(0);
		System.assertEquals(true, OracleAccountSync.isInactivated(a1, a), 'Account is Inctivated.');
	}
	
	@isTest 
	static void testSyncCreatedAccounts() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Account'));
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'Active'};
		

		Test.startTest();
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);
		Test.stopTest();
		System.assertEquals('1234', 
			[SELECT Oracle_Service_Cloud_ID__c FROM Account WHERE Id = :a.Id].Oracle_Service_Cloud_ID__c, 
			'Oracle_Service_Cloud_ID__c should be set on the Account.');

	}
	
	@isTest 
	static void testSyncUpdatedAccounts() {
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Account'));
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'Active'};
		

		Test.startTest();
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);
		a.Name = 'Updated Name';
		a.Synced_With_Oracle__c = false;
		update a;
		Test.stopTest();
		System.assertEquals(true, 
			[SELECT Synced_With_Oracle__c FROM Account WHERE Id = :a.Id].Synced_With_Oracle__c, 
			'Synced_With_Oracle__c should be true.');
	}
	
	@isTest 
	static void testSyncActivatedAccounts() {
		//set the mock
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Account'));

		//set params for account
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'Inactive'};

		Test.startTest();
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);
		System.assertEquals(false, 
			[SELECT Synced_With_Oracle__c FROM Account WHERE Id = :a.Id].Synced_With_Oracle__c, 
			'Synced_With_Oracle__c should be false.');

		//for testing
		//AccountTriggerHandler.run = true;

		//update the account to make it active
		a.Account_Status__c = 'Active';
		update a;
		Test.stopTest();

		//assertions
		System.assertEquals(true, 
			[SELECT Synced_With_Oracle__c FROM Account WHERE Id = :a.Id].Synced_With_Oracle__c, 
			'Synced_With_Oracle__c should be true.');
		System.assertEquals('1234', 
			[SELECT Oracle_Service_Cloud_ID__c FROM Account WHERE Id = :a.Id].Oracle_Service_Cloud_ID__c, 
			'Oracle_Service_Cloud_ID__c should be set on the Account.');
	}
	
	//@isTest 
	static void testSyncInactivatedAccounts() {
		//set the mock
		Test.setMock(HttpCalloutMock.class, new OracleHttpCalloutMock('Account'));

		//set params for account
		Map<String, Object> params = new Map<String, Object> { 'Account_Status__c' => 'Active'};

		Test.startTest();
		Account a = TestUtil.createLiveVaultAccount(1, params, true).get(0);

		//for testing
		//AccountTriggerHandler.run = true;

		//update the account to make it inactive
		System.debug('Now Inactivating Account.');
		a.Account_Status__c = 'Inactive';
		update a;
		Test.stopTest();

		//assertions
		System.assertEquals(false, 
			[SELECT Synced_With_Oracle__c FROM Account WHERE Id = :a.Id].Synced_With_Oracle__c, 
			'Synced_With_Oracle__c should be false.');
		System.assertEquals('1234', 
			[SELECT Oracle_Service_Cloud_ID__c FROM Account WHERE Id = :a.Id].Oracle_Service_Cloud_ID__c, 
			'Oracle_Service_Cloud_ID__c should be set on the Account.');
	}
	
}