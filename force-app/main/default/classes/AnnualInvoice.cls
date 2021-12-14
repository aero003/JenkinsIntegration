@isTest
private Class AnnualInvoice {
    
    @isTest static void AnnualInvoice()
         {
             // record typ is set to KIS NL -> 012320000005P4IAAU
            Account accParentKIS = new Account(Name='TestAccount', RecordTypeId='012320000005P4IAAU', Support_Level__c ='Regular');
            insert accParentKIS;
            Account tempParentKIS = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='TestAccount'];
           
            Invoice__c a = new Invoice__c( 
                                        Billing_Period__c = 'Annual',
                                        Account__c = tempParentKIS.Id,                                    
                                        Amount__c = 100.52,                    
                                        Sign_Up_Date__c = system.TODAY());                                                        
       insert a;
       update a;                 
        }
    }