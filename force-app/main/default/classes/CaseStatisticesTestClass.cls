@isTest
public class CaseStatisticesTestClass{
    public static testmethod void   caseMethod(){
        
        Account a= new Account ();
        a.Name =  'Test Account';
        insert a;
        
        //ApexPages.StandardController stdLead = new ApexPages.StandardController(a);
        CaseStatisticesClass csc = new CaseStatisticesClass();
        csc.openCaseCount();
        csc.myopenCaseCount();
    }
}