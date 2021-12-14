@isTest
private class UpdateLeadAddressTest {

static testmethod void test() {

// Create test leads to be updated
// by the batch job.

List<Lead> leadList = new List<Lead>();
for (Integer i=0;i<200;i++) {
Lead m = new Lead(LastName = 'LName ' + i, Company = 'Account' + i, Email = 'test'+i+'@gmail.com', State = 'CA', Country = 'US', Industry ='Healthcare' );
leadList.add(m);
}
insert leadList;

Test.startTest();
UpdateLeadAddress c = new UpdateLeadAddress('CA','California','US','United States');
Database.executeBatch(c);
Test.stopTest();

// Verify accounts updated
List<Lead> leadUpdatedList = [SELECT Id,LastName,Company, Country FROM Lead WHERE State = 'California' AND Country='United States'];
system.assertEquals(leadUpdatedList.size(), 200);
}
}