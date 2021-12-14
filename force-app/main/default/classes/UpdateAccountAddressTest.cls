@isTest
private class UpdateAccountAddressTest {

static testmethod void test() {

// Create test accounts to be updated
// by the batch job.
//Deployed



List<Account> accList = new List<Account>();
for (Integer i=0;i<200;i++) {
Account m = new Account(Name = 'Account ' + i, BillingState = 'CA',BillingCountry = 'US' );
accList.add(m);
}
insert accList;

Test.startTest();
UpdateAccountAddress c = new UpdateAccountAddress('CA','California','US','United States');
Database.executeBatch(c);
Test.stopTest();

// Verify accounts updated
List<Account> accUpdatedList = [SELECT Id,Name,BillingCountry FROM Account WHERE BillingState = 'California' AND BillingCountry='United States'];
system.assertEquals(accUpdatedList.size(), 200);
}
}