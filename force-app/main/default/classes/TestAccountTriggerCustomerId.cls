@isTest
public with sharing class TestAccountTriggerCustomerId {
    
    @testSetup static void AccountTriggerCustomerId_All(){
		//Id rid = [Select Name,Id From RecordType where Name ='KeepItSafe'].Id;
		List<Account> testAcc = new List<Account>();
        
        //Three account for KUS.
        Account aUS = new Account ();
        aUS.Phone = '123123';
		aUS.Name = 'Test Account';
		aUS.Account_Status__c = 'Open';
        aUS.customer_id2__c = 'KUS';
        aUS.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
		testAcc.add(aUS);
        
        Account aUS2 = new Account ();
        aUS2.Phone = '123123';
		aUS2.Name = 'Test Account 2';
		aUS2.Account_Status__c = 'Open';
        aUS2.customer_id2__c = 'KUS';
        aUS2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';		
		testAcc.add(aUS2);
        
        Account aUS3 = new Account ();
        aUS3.Phone = '123123';
		aUS3.Name = 'Test Account 2';
		aUS3.Account_Status__c = 'Open';
        aUS3.customer_id2__c = 'KUS';
        aUS3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';	
        testAcc.add(aUS3);
        
        //Three account for KNL
        Account aNL = new Account ();
        aNL.Phone = '123123';
		aNL.Name = 'Test Account';
		aNL.Account_Status__c = 'Open';
        aNL.customer_id2__c = 'KNL';
        aNL.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aNL);

        Account aNL2 = new Account ();
        aNL2.Phone = '123123';
		aNL2.Name = 'Test Account';
		aNL2.Account_Status__c = 'Open';
        aNL2.customer_id2__c = 'KNL';
        aNL2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aNL2);

        Account aNL3 = new Account ();
        aNL3.Phone = '123123';
		aNL3.Name = 'Test Account';
		aNL3.Account_Status__c = 'Open';
        aNL3.customer_id2__c = 'KNL';
        aNL3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aNL3);


        //Three account for KCA
        Account aCA = new Account ();
        aCA.Phone = '123123';
		aCA.Name = 'Test Account';
		aCA.Account_Status__c = 'Open';
        aCA.customer_id2__c = 'KCA';
        aCA.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aCA);

         Account aCA2 = new Account ();
         aCA2.Phone = '123123';
		aCA2.Name = 'Test Account';
		aCA2.Account_Status__c = 'Open';
        aCA2.customer_id2__c = 'KCA';
        aCA2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aCA2);

        Account aCA3 = new Account ();
        aCA3.Phone = '123123';
		aCA3.Name = 'Test Account';
		aCA3.Account_Status__c = 'Open';
        aCA3.customer_id2__c = 'KCA';
        aCA3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aCA3);


        //Three account for KUK
        Account aUK = new Account ();
        aUK.Phone = '123123';
		aUK.Name = 'Test Account';
		aUK.Account_Status__c = 'Open';
        aUK.customer_id2__c = 'KUK';
        aUK.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aUK);

        Account aUK2 = new Account ();
        aUK2.Phone = '123123';
		aUK2.Name = 'Test Account';
		aUK2.Account_Status__c = 'Open';
        aUK2.customer_id2__c = 'KUK';
        aUK2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aUK2);
        

        Account aUK3 = new Account ();
        aUK3.Phone = '123123';
		aUK3.Name = 'Test Account';
		aUK3.Account_Status__c = 'Open';
        aUK3.customer_id2__c = 'KUK';
        aUK3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aUK3);

        //KIC
        Account aIC = new Account ();
        aIC.Phone = '123123';
		aIC.Name = 'Test Account';
		aIC.Account_Status__c = 'Open';
        aIC.customer_id2__c = 'KIC';
        aIC.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aIC);

        Account aIC2 = new Account ();
        aIC2.Phone = '123123';
		aIC2.Name = 'Test Account';
		aIC2.Account_Status__c = 'Open';
        aIC2.customer_id2__c = 'KIC';
        aIC2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aIC2);

        Account aIC3 = new Account ();
        aIC3.Phone = '123123';
		aIC3.Name = 'Test Account';
		aIC3.Account_Status__c = 'Open';
        aIC3.customer_id2__c = 'KIC';
        aIC3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aIC3);

        //KIE
        Account aIE = new Account ();
        aIE.Phone = '123123';
		aIE.Name = 'Test Account';
		aIE.Account_Status__c = 'Open';
        aIE.customer_id2__c = 'KIE';
        aIE.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aIE);

        Account aIE2 = new Account ();
        aIE2.Phone = '123123';
		aIE2.Name = 'Test Account';
		aIE2.Account_Status__c = 'Open';
        aIE2.customer_id2__c = 'KIE';
        aIE2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aIE2);

        Account aIE3 = new Account ();
        aIE3.Phone = '123123';
		aIE3.Name = 'Test Account';
		aIE3.Account_Status__c = 'Open';
        aIE3.customer_id2__c = 'KIE';
        aIE3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aIE3);

        //KDK
        Account aDK = new Account ();
        aDK.Phone = '123123';
		aDK.Name = 'Test Account';
		aDK.Account_Status__c = 'Open';
        aDK.customer_id2__c = 'KDK';
        aDK.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aDK);

        Account aDK2 = new Account ();
        aDK2.Phone = '123123';
		aDK2.Name = 'Test Account';
		aDK2.Account_Status__c = 'Open';
        aDK2.customer_id2__c = 'KDK';
        aDK2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aDK2);

        Account aDK3 = new Account ();
        aDK3.Phone = '123123';
		aDK3.Name = 'Test Account';
		aDK3.Account_Status__c = 'Open';
        aDK3.customer_id2__c = 'KDK';
        aDK3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aDK3);

        //KNZ
        Account aNZ = new Account ();
        aNZ.Phone = '123123';
		aNZ.Name = 'Test Account';
		aNZ.Account_Status__c = 'Open';
        aNZ.customer_id2__c = 'KNZ';
        aNZ.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aNZ);

        Account aNZ2 = new Account ();
        aNZ2.Phone = '123123';
		aNZ2.Name = 'Test Account';
		aNZ2.Account_Status__c = 'Open';
        aNZ2.customer_id2__c = 'KNZ';
        aNZ2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aNZ2);

        Account aNZ3 = new Account ();
        aNZ3.Phone = '123123';
		aNZ3.Name = 'Test Account';
		aNZ3.Account_Status__c = 'Open';
        aNZ3.customer_id2__c = 'KNZ';
        aNZ3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';
        testAcc.add(aNZ3);

        insert testAcc;
        
	}
    
    
     
    public static testmethod void AccountTriggerCustomerId_KUS(){
		Id rid_KUS = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeUS' Limit 1].Id;
		
		
        Account a = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_KUS][0];
        a.Phone = '123123';
        a.Customer_ID2__c = '';
        a.RecordTypeID = rid_KUS;
        
        update a;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Phone = '123123';
		a2.Name = 'Test Account 21';
		a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KUS';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';		
		testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Phone = '123123';
		a3.Name = 'Test Account 22';
		a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KUS';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';	
        testAcc.add(a3);

        test.startTest();
        insert testAcc;
        test.stopTest();
        
	}
    public static testmethod void AccountTriggerCustomerId_KUS_2(){
		Id rid_KUS = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeUS' Limit 1].Id;
		
		
        List<Account> ListAcc = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_KUS];
        For(Account a: ListAcc){
        	a.Customer_ID2__c = '';
        	a.RecordTypeID = rid_KUS;    
        }
        
        update ListAcc;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Phone = '123123';
		a2.Name = 'Test Account 21';
		a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KUS';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';		
		testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Phone = '123123';
		a3.Name = 'Test Account 22';
		a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KUS';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';	
        testAcc.add(a3);

        test.startTest();
        insert testAcc;
        test.stopTest();
        
	}

    public static testmethod void AccountTriggerCustomerId_KNL(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeNL' Limit 1].Id;
		
		
        Account a = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K][0];
        a.Customer_ID2__c = '';
        a.RecordTypeID = rid_K;
        
        update a;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Phone = '123123';
		a2.Name = 'Test Account 21';
		a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KNL';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';		
		testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Phone = '123123';
		a3.Name = 'Test Account 22';
		a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KNL';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';	
        testAcc.add(a3);
       
        test.startTest();
        insert testAcc;
        test.stopTest();
        
        
    }

    public static testmethod void AccountTriggerCustomerId_KNL_2(){
		Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeNL' Limit 1].Id;
		
		
        List<Account> ListAcc = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K];
        For(Account a: ListAcc){
        	a.Customer_ID2__c = '';
        	a.RecordTypeID = rid_K;    
        }
        
        update ListAcc;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Phone = '123123';
		a2.Name = 'Test Account 21';
		a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KNL';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';		
		testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Phone = '123123';
		a3.Name = 'Test Account 22';
		a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KNL';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';	
        testAcc.add(a3);
       
       test.startTest();
        insert testAcc;
        test.stopTest();
        
	}

	public static testmethod void AccountTriggerCustomerId_KCA(){
		Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeCA' Limit 1].Id;
		
		
        Account a = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K LIMIT 1][0];
        a.Customer_ID2__c = '';
        a.RecordTypeID = rid_K;
        
        update a;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Phone = '123123';
		a2.Name = 'Test Account 21';
		a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KCA';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';		
		testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Phone = '123123';
		a3.Name = 'Test Account 22';
		a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KCA';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';	
        testAcc.add(a3);
       
       test.startTest();
        insert testAcc;
        test.stopTest();
	}

    public static testmethod void AccountTriggerCustomerId_KCA_2(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeCA' Limit 1].Id;
        
        
        List<Account> ListAcc = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K];
        For(Account a: ListAcc){
            a.Customer_ID2__c = '';
            a.Phone = '123123'; 
            a.RecordTypeID = rid_K;    
        }
       
        update ListAcc;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Name = 'Test Account 21';
        a2.Phone = '123123'; 
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KCA';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Name = 'Test Account 22';
        a3.Phone = '123123'; 
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KCA';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);
       
        test.startTest();
        insert testAcc;
        test.stopTest();
    }

    public static testmethod void AccountTriggerCustomerId_KUK(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeUK' Limit 1].Id;
        
        
        Account a = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K][0];
        a.Customer_ID2__c = '';
        a.Phone = '123123'; 
        a.RecordTypeID = rid_K;
        update a;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Name = 'Test Account 21';
        a2.Phone = '123123'; 
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KUK';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Name = 'Test Account 22';
        a3.Phone = '123123'; 
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KUK';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);

       test.startTest();
        insert testAcc;
        test.stopTest();
    }

    public static testmethod void AccountTriggerCustomerId_KUK_2(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeUK' Limit 1].Id;
        
        
        List<Account> ListAcc = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K];
        For(Account a: ListAcc){
            a.Customer_ID2__c = '';
            a.Phone = '123123'; 
            a.RecordTypeID = rid_K;    
        }
        
        update ListAcc;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Name = 'Test Account 21';
        a2.Phone = '123123'; 
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KUK';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Name = 'Test Account 22';
        a3.Phone = '123123'; 
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KUK';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);
       
       test.startTest();
        insert testAcc;
        test.stopTest();
    }
   
    public static testmethod void AccountTriggerCustomerId_KIC(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeIC' Limit 1].Id;
        
        
        Account a = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K][0];
        a.Customer_ID2__c = '';
        a.Phone = '123123'; 
        a.RecordTypeID = rid_K;
        
        update a;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Name = 'Test Account 21';
        a2.Phone = '123123'; 
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KIC';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Name = 'Test Account 22';
        a3.Phone = '123123'; 
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KIC';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);

       test.startTest();
        insert testAcc;
        test.stopTest();
    }

    public static testmethod void AccountTriggerCustomerId_KIC_2(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeIC' Limit 1].Id;
        
        
        List<Account> ListAcc = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K];
        For(Account a: ListAcc){
            a.Customer_ID2__c = '';
            a.Phone = '123123'; 
            a.RecordTypeID = rid_K;    
        }
        
        update ListAcc;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Name = 'Test Account 21';
        a2.Phone = '123123'; 
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KIC';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Name = 'Test Account 22';
        a3.Phone = '123123'; 
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KIC';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);
       
       test.startTest();
        insert testAcc;
        test.stopTest();
    }

     public static testmethod void AccountTriggerCustomerId_KIE(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafe' Limit 1].Id;
        
        
        Account a = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K][0];
        a.Customer_ID2__c = '';
        a.Phone = '123123'; 
        a.RecordTypeID = rid_K;
       
        update a;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Name = 'Test Account 21';
        a2.Phone = '123123'; 
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KIE';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Name = 'Test Account 22';
        a3.Phone = '123123'; 
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KIE';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);

        test.startTest();
        insert testAcc;
        test.stopTest();
    }

    public static testmethod void AccountTriggerCustomerId_KIE_2(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafe' Limit 1].Id;
        
        
        List<Account> ListAcc = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K];
        For(Account a: ListAcc){
            a.Customer_ID2__c = '';
            a.Phone = '123123'; 
            a.RecordTypeID = rid_K;    
        }
        update ListAcc;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Name = 'Test Account 21';
        a2.Phone = '123123'; 
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KIE';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Name = 'Test Account 22';
        a3.Phone = '123123'; 
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KIE';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);

       test.startTest();
        insert testAcc;
        test.stopTest();
    }
    
 public static testmethod void AccountTriggerCustomerId_KDK(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeDK' Limit 1].Id;
        
        
        Account a = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K][0];
        a.Customer_ID2__c = '';
        a.Phone = '123123'; 
        a.RecordTypeID = rid_K;
        
        update a;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Name = 'Test Account 21';
        a2.Phone = '123123'; 
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KDK';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Name = 'Test Account 22';
        a3.Phone = '123123'; 
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KDK';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);

       test.startTest();
        insert testAcc;
        test.stopTest();
    }

    public static testmethod void AccountTriggerCustomerId_KDK_2(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeDK' Limit 1].Id;
        
        
        List<Account> ListAcc = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K];
        For(Account a: ListAcc){
            a.Customer_ID2__c = '';
            a.Phone = '123123'; 
            a.RecordTypeID = rid_K;    
        }
       
        update ListAcc;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Name = 'Test Account 21';
        a2.Phone = '123123'; 
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KDK';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Name = 'Test Account 22';
        a3.Phone = '123123'; 
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KDK';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);
       
        test.startTest();
        insert testAcc;
        test.stopTest();
    }

     public static testmethod void AccountTriggerCustomerId_KNZ(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeNZ' Limit 1].Id;
        
        
        Account a = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K][0];
        a.Customer_ID2__c = '';
        a.Phone = '123123'; 
        a.RecordTypeID = rid_K;
        
        update a;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Name = 'Test Account 21';
        a2.Phone = '123123'; 
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KNZ';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Name = 'Test Account 22';
        a3.Phone = '123123'; 
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KNZ';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);
       
       test.startTest();
        insert testAcc;
        test.stopTest();
    }

    public static testmethod void AccountTriggerCustomerId_KNZ_2(){
        Id rid_K = [Select Name,Id From RecordType where SobjectType='Account' and Name ='KeepItSafeNZ' Limit 1].Id;
        
        
        List<Account> ListAcc = [Select Id, Customer_id2__c, RecordTypeId from account where RecordTypeId=:rid_K];
        For(Account a: ListAcc){
            a.Customer_ID2__c = '';
            a.Phone = '123123'; 
            a.RecordTypeID = rid_K;    
        }
        
        update ListAcc;
        
        List<Account> testAcc = new List<Account>();
        Account a2 = new Account ();
        a2.Phone = '123123'; 
        a2.Name = 'Test Account 21';
        a2.Account_Status__c = 'Open';
        a2.customer_id2__c = 'KNZ';
        a2.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';      
        testAcc.add(a2);
        
        Account a3 = new Account ();
        a3.Phone = '123123'; 
        a3.Name = 'Test Account 22';
        a3.Account_Status__c = 'Open';
        a3.customer_id2__c = 'KNZ';
        a3.Account_Record_Type_Hidden__c = 'KeepItSafe: Lead';  
        testAcc.add(a3);
       
       test.startTest();
        insert testAcc;
        test.stopTest();
    }
}