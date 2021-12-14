Public Class Monthly {
@istest
    public static void MonthlyInvoice()
     {

        Account acc = new Account(Name='TestAccount', RecordTypeId='012320000005P4IAAU', Support_Level__c ='Regular');
        insert acc;
        Account insertedAcc = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='TestAccount'];

        Invoice__c a = new Invoice__c( 
                                    Billing_Period__c = 'Monthly',
                                    Account__c = insertedAcc.Id,                                    
                                    Amount__c = 100.52,                    
                                    Sign_Up_Date__c = system.TODAY());                                                        
   insert a;
   update a;                 
    }
}