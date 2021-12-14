@isTest
public with sharing class j2_KeepitSafe_Account_TestClass {
    @testSetup static void accountTriggerTestMethod_setup(){
		List<Account> accounts = new List<Account>();
		List<Invoice__c> invoices = new List<Invoice__c>();

		Id rid = [Select Name,Id From RecordType where Name ='KeepItSafe'].Id;
		Account a = new Account ();
		a.Name = 'OpenAccount';
		a.Account_Status__c = 'Open';
		a.RecordTypeId = rid;
		//insert a;
		accounts.add(a);
		
        Account a1 = new Account ();
		a1.Name = 'ActiveAccount';
		a1.Account_Status__c = 'Active';
		a1.RecordTypeId = rid;
		//insert a1;
		accounts.add(a1);
    
		
        Account a2 = new Account ();
		a2.Name = 'InactiveAccount';
		a2.Account_Status__c = 'InActive';
		a2.RecordTypeId = rid;
		//insert a2;
		accounts.add(a2);
        
		
       	Account a3 = new Account ();
		a3.Name = 'PendingAccount';
		a3.Account_Status__c = 'Pending';
		a3.RecordTypeId = rid;
		//insert a3;
		accounts.add(a3);

		insert accounts;


		Invoice__c i = new Invoice__c ();
		i.Billing_Run_Date__c = system.today();
		i.Sign_Up_Date__c = system.today();
		i.Account__c = a.Id;
		//insert i;
		invoices.add(i);
			
		Invoice__c i1 = new Invoice__c ();
		i1.Billing_Run_Date__c = system.today();
		i1.Sign_Up_Date__c = system.today();
		i1.Account__c = a1.Id;
		//insert i1;
		invoices.add(i1);

		Invoice__c i2 = new Invoice__c ();
		i2.Billing_Run_Date__c = system.today();
		i2.Sign_Up_Date__c = system.today();
		i2.Account__c = a2.Id;
		//insert i2;
		invoices.add(i2);

        Invoice__c i3 = new Invoice__c ();
		i3.Billing_Run_Date__c = system.today();
		i3.Sign_Up_Date__c = system.today();
		i3.Account__c = a3.Id;
		//insert i3;
		invoices.add(i3);


		insert invoices;
	} 
	
	public static testmethod void accountTriggerTestMethod(){
        
		Id rid = [Select Name,Id From RecordType where Name ='KeepItSafe'].Id;
		Account a = new Account ();
		a.Name = 'Test Account';
		a.Account_Status__c = 'Open';
		a.RecordTypeId = rid;
        
        Test.startTest();
		insert a;
        test.stopTest();
	}
    public static testmethod void accountTriggerTestMethod_2(){
		Account a = [Select ID,Type, name,Account_Status__c,Reason__c from account where name='InactiveAccount'];
		
		a.Type = 'Former Customer';
		a.Account_Status__c = 'Closed';
		a.Reason__c = 'Other';
        
        Test.startTest();
		update a;
		Test.stopTest();
	}
    
    public static testmethod void accountTriggerTestMethod_3(){
		Account a = [Select ID,Type, name,Account_Status__c,Reason__c from account where name='ActiveAccount'];
		
		a.Type = 'Customer';
		a.Account_Status__c = 'Active';
		a.Reason__c = '';
        
        Test.startTest();
		update a;
		Test.stopTest();
	}
    
    public static testmethod void accountTriggerTestMethod_4(){
		Account a = [Select ID,Type, name,Account_Status__c,Reason__c from account where name='PendingAccount'];
		
		a.Type = 'Customer';
		a.Account_Status__c = 'Pending';
		a.Reason__c = '';
        
        Test.startTest();
		update a;
		Test.stopTest();
	}
}