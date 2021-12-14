@isTest
private class UpdateContactAddressTest {
    
static testmethod void setup() {
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        acclist.add(new Account(name='Account'));
        insert acclist;
        // find the account just inserted. add multiple contacts for account.
        for (Account account : acclist) {
            for (Integer i=0;i<200;i++) {
            conList.add(new Contact(LastName = 'LName ' + i,accountId=account.id,Email ='test'+i+'@gmail.com', MailingState = 'CA', MailingCountry = 'US' ));
        }
        insert conList;
    }
        
Test.startTest();
UpdateContactAddress c = new UpdateContactAddress('CA','California','US','United States');
Database.executeBatch(c);
Test.stopTest();

// Verify Contacts updated
List<Contact> conUpdatedList = [SELECT Id,Name,MailingCountry FROM Contact WHERE MailingState='California' AND MailingCountry='United States'];
system.assertEquals(conUpdatedList.size(), 200);
}
}