@isTest
public class InvoiceInactiveSchedularTest{
    
    public static String CRON_EXP = '0 0 0 3 9 ? 2022';
    
    public static  testmethod void InvoiceSchedularTest(){
    
        Account a = new Account();
        a.Name = 'Test Account';
        a.Deactivate_Invoice__c = true;
        insert a;
        
       Invoice__c i = new Invoice__c();
       i.Account__c = a.Id;
       i.Sign_Up_Date__c = system.today();
       i.Status__c = 'Active';
       insert i;
       
       InvoiceInactiveSchedular inv= new InvoiceInactiveSchedular ();
       
       
       
       String jobId = System.schedule('testSchedular',CRON_EXP, inv);
    }
}