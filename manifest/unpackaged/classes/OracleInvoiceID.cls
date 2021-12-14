Public Class OracleInvoiceID {
@istest    
    public static void OracleInvoiceID()     
    {        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        
        
        Invoice__c i = new Invoice__c(                                     
            Billing_Period__c = 'Annual',                                    
            Account__c = a.Id,                                                                        
            Amount__c = 100.52,                                                       
            Sign_Up_Date__c = system.TODAY(),
            Invoice_Reason__c = 'Closed Down');   
                                                                    
    insert i;   
    update i;                     
    }
   }