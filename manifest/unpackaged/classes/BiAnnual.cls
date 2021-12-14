@isTest
Public Class BiAnnual {
    @testSetup static void BiAnnual_All_Setup(){
        //Id rid = [Select Name,Id From RecordType where Name ='KeepItSafe'].Id;
        List<Account> testAcc = new List<Account>();
        
        //Three account for KUS.
        Account aUS = new Account ();
        aUS.Name = '521';
        aUS.Account_Status__c = 'Open';
        aUS.customer_id2__c = 'KIE';
        aUS.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aUS);
        
        Account aUS2 = new Account ();
        aUS2.Name = '5482';
        aUS2.Account_Status__c = 'Open';
        aUS2.customer_id2__c = 'KIE';
        aUS2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';		
        testAcc.add(aUS2);
        
        Account aUS3 = new Account ();
        aUS3.Name = 'Test Account 112';
        aUS3.Account_Status__c = 'Open';
        aUS3.customer_id2__c = 'KIE';
        aUS3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';	
        testAcc.add(aUS3);
        
        //Three account for KNL
        Account aNL = new Account ();
        aNL.Name = 'Test Account';
        aNL.Account_Status__c = 'Open';
        aNL.customer_id2__c = 'KNL';
        aNL.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aNL);
        
        Account aNL2 = new Account ();
        aNL2.Name = 'Test Account 123';
        aNL2.Account_Status__c = 'Open';
        aNL2.customer_id2__c = 'KIE';
        aNL2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aNL2);
        
        Account aNL3 = new Account ();
        aNL3.Name = 'Test Account 321';
        aNL3.Account_Status__c = 'Open';
        aNL3.customer_id2__c = 'KIE';
        aNL3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aNL3);
        
        
        //Three account for KCA
        Account aCA = new Account ();
        aCA.Name = 'Test Account 987';
        aCA.Account_Status__c = 'Open';
        aCA.customer_id2__c = 'KIE';
        aCA.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aCA);
        
        insert testAcc;
    }
    
    
    @istest
    public static void BiAnnualInvoice()
    {
        Account acc = [Select ID from account where name = '521'];
        Invoice__c a = new Invoice__c( 
            Billing_Period__c = 'Bi-Annual',
            //Account__c = '0016000000gwyKpAAI',
            Account__c = acc.Id,
            Amount__c = 100.52,
            Comments__c = 'This is a test',                    
            Sign_Up_Date__c = system.TODAY());     
        Test.startTest();
        insert a;
        update a;       
        Test.stopTest();
    }
    
    public static testmethod void BiAnnualInvoice_2()
    {
        Account acc = [Select ID from account where name = '5482'];
        Invoice__c b = new Invoice__c( 
            Billing_Period__c = 'Bi-Annual',
            //Account__c = '0016000000gwyKpAAI',
            Account__c = acc.Id,
            Amount__c = 180.76,                    
            Sign_Up_Date__c = system.TODAY()+30);    
        Test.startTest();
        insert b;
        update b;
        Test.stopTest();
    }
    public static testmethod void BiAnnualInvoice_3()
    {
        Account acc = [Select ID from account where name = '5482'];
        Invoice__c c = new Invoice__c( 
            Billing_Period__c = 'Bi-Annual',
            //Account__c = '0016000000gwyZLAAY',                                  
            Account__c = acc.Id,
            Amount__c = 103.23,                    
            Sign_Up_Date__c = system.TODAY()-30);   
        Test.startTest();
        insert c;
        update c;
        Test.stopTest();
    }
    
    public static testmethod void BiAnnualInvoice_4()
    {
        Account acc = [Select ID from account where name = '5482'];
        Invoice__c d = new Invoice__c( 
            Billing_Period__c = 'Bi-Annual',
            //Account__c = '0016000000gwyLsAAI',                                    
            Account__c = acc.Id,
            Amount__c = 154.23,                    
            Sign_Up_Date__c = system.TODAY()-60);   
        Test.startTest();
        insert d;
        update d;
        Test.stopTest();
    }
    
    public static testmethod void BiAnnualInvoice_5()
    {
        Account acc = [Select ID from account where name = '5482'];
        Invoice__c e = new Invoice__c( 
            Billing_Period__c = 'Bi-Annual',
            //Account__c = '0016000000gwyb6AAA',                                    
            Account__c = acc.Id,
            Amount__c = 145.63,                    
            Sign_Up_Date__c = system.TODAY()+60);  
        Test.startTest();
        insert e;
        update e;   
        Test.stopTest();
    }
    
}