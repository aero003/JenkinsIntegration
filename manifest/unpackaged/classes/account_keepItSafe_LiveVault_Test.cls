@isTest
private class account_keepItSafe_LiveVault_Test {
  /*  @testSetup static void testSetup(){
          //Query recordtype id for KeepItSafe to use as a reference while inserting accounts
		Id recordTypeId = [Select Name,Id From RecordType where Name ='KeepItSafe'].Id;
        
        //List of accounts to insert accounts
		List<Account> listOfAccounts = new List<Account>();
        //List of accounts to insert accounts with parent id 
        List<Account> listOfAccountsWithParentIds = new List<Account>();
        
        //Insert accounts with necessary fields such as Support_Level__c, High_Revenue__c, Special_Attention__c
        Account a1 = new Account(Name='testAccount', Support_Level__c = '', High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId);
        Account a2 = new Account(Name='testAccount1', Support_Level__c = '', High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId);
        Account a3 = new Account(Name='testAccount2', Support_Level__c = '', High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId);
        Account a4 = new Account(Name='testAccount3', Support_Level__c = '', High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId);
        listOfAccounts.add(a1);
        listOfAccounts.add(a2);
        listOfAccounts.add(a3);
        listOfAccounts.add(a4);
		insert listOfAccounts;
        
         //Insert accounts with parentid 
        Account a5 = new Account(Name='testAccount5', Support_Level__c = '', High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId,ParentId=a1.id);
        Account a6 = new Account(Name='testAccount6', Support_Level__c = '', High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId,ParentId=a2.id);
        Account a7 = new Account(Name='testAccount7', Support_Level__c = '', High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId,ParentId=a3.id);
        Account a8 = new Account(Name='testAccount8', Support_Level__c = '', High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId,ParentId=a4.id);
        listOfAccountsWithParentIds.add(a5);
        listOfAccountsWithParentIds.add(a6);
        listOfAccountsWithParentIds.add(a7);
        listOfAccountsWithParentIds.add(a8);
        insert listOfAccountsWithParentIds;
    }*/
	/*@isTest static void account_keepItSafe_LiveVault_Test_1(){
        // Update test

        Id recordTypeId = [Select Name,Id From RecordType where Name ='KeepItSafe'].Id;

        Account parent = new Account(Name='Parent 2 test', Support_Level__c = null, High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId);
        insert parent;

        Account child = new Account(Name='Child 2 test', Support_Level__c = null, High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId, ParentId=parent.Id);
        insert child;

        Account parentToChange = [SELECT Id, Support_Level__c, High_Revenue__c, Special_Attention__c FROM Account WHERE Name='Parent 2 test'];
        parentToChange.Support_Level__c = 'Gold';
        parentToChange.High_Revenue__c = true;
        parentToChange.Special_Attention__c = true;
        update parentToChange;

        Account queriedParent = [SELECT Id, Support_Level__c, High_Revenue__c, Special_Attention__c FROM Account WHERE Name='Parent 2 test'];
        Account queriedChild = [SELECT Id, Support_Level__c, High_Revenue__c, Special_Attention__c FROM Account WHERE Name='Child 2 test'];

        System.assertEquals(queriedParent.Support_Level__c, queriedChild.Support_Level__c, '[Update event] Support level is not mapped correctly.');
        System.assertEquals(queriedParent.High_Revenue__c, queriedChild.High_Revenue__c, '[Update event] High revenue is not mapped correctly.');
        System.assertEquals(queriedParent.Special_Attention__c, queriedChild.Special_Attention__c, '[Update event] Special attention is not mapped correctly.');
        
    }
    @isTest static void account_keepItSafe_LiveVault_Test_2(){  
        // Insert test      

        Id recordTypeId = [Select Name,Id From RecordType where Name ='KeepItSafe'].Id;

        Account parent = new Account(Name='Parent 1 test', Support_Level__c = 'Gold', High_Revenue__c = true, Special_Attention__c = true, RecordTypeId=recordTypeId);
        insert parent;

        Account child = new Account(Name='Child 1 test', Support_Level__c = null, High_Revenue__c = false, Special_Attention__c = false, RecordTypeId=recordTypeId, ParentId=parent.Id);
        insert child;

        Account queriedParent = [SELECT Id, Support_Level__c, High_Revenue__c, Special_Attention__c FROM Account WHERE Name='Parent 1 test'];
        Account queriedChild = [SELECT Id, Support_Level__c, High_Revenue__c, Special_Attention__c FROM Account WHERE Name='Child 1 test'];

        System.assertEquals(queriedParent.Support_Level__c, queriedChild.Support_Level__c, '[Insert event] Support level is not mapped correctly.');
        System.assertEquals(queriedParent.High_Revenue__c, queriedChild.High_Revenue__c, '[Insert event] High revenue is not mapped correctly.');
        System.assertEquals(queriedParent.Special_Attention__c, queriedChild.Special_Attention__c, '[Insert event] Special attention is not mapped correctly.');
    }
  */
}