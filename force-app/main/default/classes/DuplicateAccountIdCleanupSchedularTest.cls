@isTest
public class DuplicateAccountIdCleanupSchedularTest{
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

     static  testmethod void duplicateAccountMethod(){

        String KUS_RecordTypeId =[SELECT Id FROM RecordType where Name='KeepItSafeUS' And SObjectType='Account' Limit 1].Id;
        system.debug(KUS_RecordTypeId);
        String KIE_RecordTypeId =[SELECT Id FROM RecordType where Name='KeepItSafe' And SObjectType='Account' Limit 1].Id;
        String KCA_RecordTypeId =[SELECT Id FROM RecordType where Name='KeepItSafeCA' And SObjectType='Account' Limit 1].Id;
        String KUK_RecordTypeId =[SELECT Id FROM RecordType where Name='KeepItSafeUK' And SObjectType='Account' Limit 1].Id;
        String KIC_RecordTypeId =[SELECT Id FROM RecordType where Name='KeepItSafeIC' And SObjectType='Account' Limit 1].Id;

        List<Account> lstAccount = new List<Account>();
        

        /* KUS RecordType */
        Account a = new Account ();
        a.Name = 'Test Account';
        a.Phone = '123123';
        a.Customer_ID2__c = 'KUS-12345';
        a.RecordTypeId = KUS_RecordTypeId;
        lstAccount.add(a);
        //insert a;

        Account a1 = new Account ();
        a1.Name = 'Test Account';
        a1.Phone = '123123';
        a1.Customer_ID2__c = 'KUS-123456';
        a1.RecordTypeId = KUS_RecordTypeId;
        lstAccount.add(a1);
        //insert a1;

        /* KIE RecordType */
        Account a2 = new Account ();
        a2.Name = 'Test Account';
        a2.Phone = '123123';
        a2.Customer_ID2__c = 'KIE-123456';
        a2.RecordTypeId = KIE_RecordTypeId;
        lstAccount.add(a2);
        //insert a2;

        Account a3 = new Account ();
        a3.Name = 'Test Account';
        a3.Phone = '123123';
        a3.Customer_ID2__c = 'KIE-33333';
        a3.RecordTypeId = KIE_RecordTypeId;
        lstAccount.add(a3);
        //insert a3;

        /* KCA RecordType */
        Account a4 = new Account ();
        a4.Name = 'Test Account';
        a4.Phone = '123123';
        a4.Customer_ID2__c = 'KCA-33333';
        a4.RecordTypeId = KCA_RecordTypeId;
        lstAccount.add(a4);
        //insert a4;

        Account a5 = new Account ();
        a5.Name = 'Test Account';
        a5.Phone = '123123';
        a5.Customer_ID2__c = 'KCA-12345';
        a5.RecordTypeId = KCA_RecordTypeId;
        lstAccount.add(a5);
        //insert a5;
        
        /* KUK RecordType */
        Account a6 = new Account ();
        a6.Name = 'Test Account';
        a6.Phone = '123123';
        a6.Customer_ID2__c = 'KUK-33333';
        a6.RecordTypeId = KUK_RecordTypeId;
        lstAccount.add(a6);
        
        Account a7 = new Account ();
        a7.Name = 'Test Account';
        a7.Phone = '123123';
        a7.Customer_ID2__c = 'KUK-12345';
        a7.RecordTypeId = KUK_RecordTypeId;
        lstAccount.add(a7);

        /* KIC RecordType */
        Account a8 = new Account ();
        a8.Name = 'Test Account';
        a8.Phone = '123123';
        a8.Customer_ID2__c = 'KIC-33333';
        a8.RecordTypeId = KIC_RecordTypeId;
        lstAccount.add(a8);
        

        Account a9 = new Account ();
        a9.Name = 'Test Account';
        a9.Phone = '123123';
        a9.Customer_ID2__c = 'KIC-12345';
        a9.RecordTypeId = KIC_RecordTypeId;
        lstAccount.add(a9);

        insert lstAccount;

        System.schedule('DuplicateAccountIdCleanupSchedular 1', '0 0 * * * ?', new DuplicateAccountIdCleanupSchedular());
    }
}