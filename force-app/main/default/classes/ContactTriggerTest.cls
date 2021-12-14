@isTest()
public with sharing class ContactTriggerTest {


    @isTest static void ContactTriggerTest() {

        // create Contact
       Contact testCont = new Contact(LastName='MarkoLukaContact', Access_role__c='Customer Billing/Invoice' );
       insert testCont;

        Contact addedCont = [SELECT Id, LastName, Invoice_Contact__c from Contact WHERE LastName ='MarkoLukaContact'];
        
        // verify if Contact 'Invoice_Contact__c' (Billing address) property was set on TRUE
        System.assertEquals(true, addedCont.Invoice_Contact__c, 'Contact was not flaged for Billing (Contact.Invoice_Contact__c)');

       Account testAcc = new Account(Name='MarkoLukaBilling');
       insert testAcc;
       
       // Assighn Account ID to Contact
       Account accId = [SELECT Id, Name, Invoice_Contact__c FROM Account WHERE Name='MarkoLukaBilling'];
       testCont.AccountId = accId.Id;
       update testCont;

       Account accId1 = [SELECT Id, Name, Invoice_Contact__c FROM Account WHERE Name='MarkoLukaBilling'];
        
       // Verify if 'Invoice_Contact__c' on Acount was assigned Contact Id
       System.assertEquals(testCont.Id, accId1.Invoice_Contact__c, 'Unexpected Contact or Contact not set on account (Account.Invoice_Contact__c)');

       
    }
    
    @isTest static void Ticket_NLP15_problem_test()
    {
        Contact contact = new Contact(LastName='NLP15-ticket', Email='random@email.com');
        insert contact;

        Contact removeEmailContact = [SELECT Id, LastName, Email FROM Contact WHERE LastName='NLP15-ticket'];
        removeEmailContact.Email = '';
        update removeEmailContact;

    }
}