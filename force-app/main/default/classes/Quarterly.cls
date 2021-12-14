Public Class Quarterly {
@istest
    public static void QuarterlyInvoice()
     {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Invoice__c a = new Invoice__c( 
                                    Billing_Period__c = 'Quarterly',
                                    Account__c = acc.Id,                                  
                                    Amount__c = 100.52,                    
                                    Sign_Up_Date__c = system.TODAY(),
                                    Invoice_Reason__c = 'Closed Down'); 
                                                                                          
   insert a;
   update a;
       Invoice__c b = new Invoice__c( 
                                    Billing_Period__c = 'Quarterly',
                                    Account__c = acc.Id,                                     
                                    Amount__c = 52,                    
                                    Sign_Up_Date__c = system.TODAY()-30,
                                    Invoice_Reason__c = 'Closed Down');  
                                                                                            
   insert b;
   update b;
       Invoice__c c = new Invoice__c( 
                                    Billing_Period__c = 'Quarterly',
                                    Account__c = acc.Id,                                    
                                    Amount__c = 152,                    
                                    Sign_Up_Date__c = system.TODAY()+30,
                                    Invoice_Reason__c = 'Closed Down'); 
                                                                                               
   insert c;
   update c;                 
    }
}