@isTest
private class AccountTrigger_v2_test {     
 

    private static final Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafe').getRecordTypeId();
    public static Id RECORD_TYPE_MyFax= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('MyFax_Account').getRecordTypeId();
    private static final Id USER_PROFILE_ID = [SELECT Id FROM Profile WHERE Name='KIS - LV US profile' LIMIT 1].Id;

    /*
     * Test scenario:
     * 1) creates a parent NL account with contact and an owner
     * 2) expect parent contact to have the same sales owner as the parent account
     * 3) create a child NL account
     * 4) expect child account to have the same sales owner as the parrent account
     * 5) create a contact for the child account
     * 6) expect child account contact to have the same sales owner as the child account and the perent account
     * 7) create a new user that will take ownership of the parent account as Sales_Owner__c
     * 8) expect that parent account contact, child account and child account contact all get this new owner
     */
    @isTest static void test_SalesOwner_fromParentAccount() {

        // 1) creates a parent NL account with contact and an owner
        User parentAccountSalesOwner = new User(FirstName='parentAccountSalesOwner', LastName='parentAccountSalesOwner', 
                Username='parentAccountSalesOwner1@j2.com', Email='parentAccountSalesOwner@j2.com', 
                Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', 
                ProfileId=USER_PROFILE_ID, TimeZoneSidKey='Europe/Berlin');
        insert parentAccountSalesOwner;
        parentAccountSalesOwner =[Select Id, FirstName, LastName from User Where FirstName='parentAccountSalesOwner'];

        Account parentAccount = new Account(Name='parentAccount', Sales_Owner__c=parentAccountSalesOwner.Id, Type='Partner', 
                RecordTypeId=RECORD_TYPE_KIS_NL_ID, BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
        insert parentAccount;
        parentAccount = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='parentAccount'];

        Contact parentAccountContact = new Contact(LastName='parentAccountContact', AccountId=parentAccount.Id, Contact_Roles__c='Accounting/Invoice role');
        insert parentAccountContact;


        // 2) expect parent contact to have the same sales owner as the parent account
        parentAccountContact = [Select Id, OwnerId, Name FROM Contact WHERE LastName='parentAccountContact'];
        System.assertEquals(parentAccountContact.OwnerId, parentAccount.Sales_Owner__c, 
                'Error: Parrent contact Sales_Owner__c was not populated with the value the parrent account Sales_Owner__c!');


        // 3) create a child NL account
        Account childAccount =  new Account(Name='childAccount',  Type='Customer', ParentId=parentAccount.Id, 
                RecordTypeId=RECORD_TYPE_KIS_NL_ID,BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Gold',Veeam_License_Subscription__c='Yes');
        insert childAccount;


        // 4) expect child account to have the same sales owner as the parrent account
        childAccount = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='childAccount'];
        System.assertEquals(childAccount.Sales_Owner__c, parentAccount.Sales_Owner__c, 
                'Error: Child account Sales_Owner__c was not populated with the value the parrent account Sales_Owner__c!');


        // 5) create a contact for the child account
        Contact childAccountContact = new Contact(LastName='childAccountContact', AccountId=childAccount.Id, 
                Contact_Roles__c='Accounting/Invoice role');
        insert childAccountContact;


        // 6) expect child account contact to have the same sales owner as the child account and the perent account
        childAccountContact = [Select Id, OwnerId, Name FROM Contact WHERE LastName='childAccountContact'];
        System.assertEquals(childAccountContact.OwnerId, childAccount.Sales_Owner__c, 
                'Error: Sales_Owner__c of Contact of the child account was not populated with the value the child account Sales_Owner__c!');
        System.assertEquals(childAccountContact.OwnerId, parentAccount.Sales_Owner__c, 
                'Error: Sales_Owner__c of Contact of the child account was not populated with the value the parrent account Sales_Owner__c!');


        // 7) create a new user that will take ownership of the parent account as Sales_Owner__c
        User newParentAccountSalesOwner = new User(FirstName='newParentAccountSalesOwner', LastName='newParentAccountSalesOwner', 
                Username='newParentAccountSalesOwner1@j2.com', Email='newParentAccountSalesOwner@j2.com', Alias='usr', 
                LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', 
                ProfileId=USER_PROFILE_ID, TimeZoneSidKey='Europe/Berlin');
        insert newParentAccountSalesOwner;
        newParentAccountSalesOwner = [Select Id, FirstName, LastName from User Where FirstName='newParentAccountSalesOwner'];
        parentAccount.Sales_Owner__c = newParentAccountSalesOwner.Id;
        update parentAccount;


        // 8) expect that parent account contact, child account and child account contact all get this new owner
        parentAccount =  [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='parentAccount'];
        parentAccountContact = [Select Id, OwnerId, Name FROM Contact WHERE Name='parentAccountContact'];
        System.assertEquals(parentAccountContact.OwnerId, parentAccount.Sales_Owner__c, 
                'Error: Parrent contact Sales_Owner__c was not updated with the new value the parrent account Sales_Owner__c!');

        childAccount = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='childAccount'];
        System.assertEquals(childAccount.Sales_Owner__c, parentAccount.Sales_Owner__c, 'Child Account Sales owner was not updated with the new owner!');

        childAccountContact = [Select Id, OwnerId, Name FROM Contact WHERE Name='childAccountContact'];
        System.assertEquals(childAccountContact.OwnerId, parentAccount.Sales_Owner__c, 
                'Error: Sales_Owner__c of Contact of the child account was not updated with the new value the parrent account Sales_Owner__c!');
    }




    @isTest static void test_SalesOwner_ChangeParentAccount() 
    {
        // 1. Create first user that will be Sales Owner
        User user_SalesOwnerTest = new User(FirstName='TestUserLukaMarko', LastName='TestUserLuka', Username='LukaOwnerMarko@sads.cm', Email='LUKAMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest;

        // 2. Get user from database (Id)
        User salesOwner1=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserLukaMarko'];

        // 3. Create first parent account with inserted user as Sales Owner
        Account parent = new Account(Name='Parent Acc12', Sales_Owner__c=salesOwner1.Id, Type='Partner', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
        insert parent;
        Account par1 = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='Parent Acc12'];

        // 4. Create contact associated with first parent account
        Contact contactChild = new Contact(LastName='Child Contact Sales Owner', AccountId=par1.Id, Contact_Roles__c='Accounting/Invoice role');
        insert contactChild;

        //Add new child account
        Account child =  new Account(Name='Child Acc', ParentId=par1.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Silver', Veeam_License_Subscription__c='Yes');
        insert child;


          // 5. Create second user to change the Sales Owner Id field on Accounts
          User user_SalesOwnerTest2 = new User(FirstName='TestUserSimonMarko', LastName='TestSimonMarko', Username='SimonMarko@neki.com', Email='simonamrko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
          insert user_SalesOwnerTest2;
          User salesOwner2=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserSimonMarko'];     
          
        // Update Parrent Account with new Record Type
        par1.RecordTypeId =RECORD_TYPE_KIS_ID;
        par1.Support_Level__c ='Gold';
        par1.Sales_Owner__c=salesOwner2.Id;
        Update par1;

        Account par = [Select Id, Sales_Owner__c, RecordTypeId, Name FROM Account WHERE Name='Parent Acc12'];

      

        // 6. Create child account associated with first parent account
        Account child1 =  new Account(Name='Child Acc1', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child1;

        Account insertedChild = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc1'];

        // 7. Get updated records from database to check if trigger logic is correct
        Account updatedChild = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc1'];
        Contact updatedContact = [Select Id, OwnerID, LastName FROM Contact WHERE Name='Child Contact Sales Owner'];

        // Expect that inserted child account has the same Sales owner as Parent Account
        System.assertEquals(par.Sales_Owner__c, insertedChild.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 1');
        System.assertEquals(par.Sales_Owner__c, updatedContact.OwnerID,'Error: Contact Sales Owner does not match with Account Sales Owner');

        
        // 8. Create second parent to change the ParentId field on Account
        Account parent2 = new Account(Name='Parent AccSimon', Sales_Owner__c=salesOwner2.Id, Type='Partner', RecordTypeId='012320000005P4IAAU'/*, BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular'/*,Veeam_License_Subscription__c='Yes'*/);
        insert parent2;
        Account par2 = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='Parent AccSimon'];   

        // 9. Get updated record from database to perform parent change
        Account childChangedParent = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc'];

        // 10. Change the parent on child account 
        childChangedParent.ParentId = par2.Id;
        update childChangedParent;

        // 9. Get updated record after update
        Account childChangedParentAfterUpdate = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc'];

        // 11. Check if Sales owner on Child account has updated after changed Parent Account 
        System.assertEquals(parent2.Sales_Owner__c, childChangedParentAfterUpdate.Sales_Owner__c, 'Child Account Sales owner does not math with parrent account Sales Owner 2');
    }


    
  /*  @isTest static void test_SalesOwner_ChangeChildAccount() 
    {

          // 1. Create first user that will be Sales Owner
          User user_SalesOwnerTest = new User(FirstName='TestUserLukaMarko', LastName='TestUserLuka', Username='LukaOwnerMarko@sads.cm', Email='LUKAMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
          insert user_SalesOwnerTest;
  
          // 2. Get user from database (Id)
          User salesOwner1=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserLukaMarko'];
  
          // 3. Create first parent account with inserted user as Sales Owner
          Account parent = new Account(Name='Parent Acc12', Sales_Owner__c=salesOwner1.Id, Type='Partner', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
          insert parent;
          Account insertedparent = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='Parent Acc12'];
  
          // 4. Create contact associated with first parent account
          Contact contactChild = new Contact(LastName='Child Contact Sales Owner', AccountId=insertedparent.Id, Contact_Roles__c='Accounting/Invoice role');
          insert contactChild;
  
          //Add new child account
          Account child =  new Account(Name='Child Acc', ParentId=insertedparent.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
          insert child;

          Account insertedChild = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc'];

          insertedChild.RecordTypeId =RECORD_TYPE_KIS_ID;
          insertedChild.Support_Level__c ='Gold';
          Update insertedChild;

        Account updatedChild = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc'];
        Contact updatedContact = [Select Id, OwnerID, LastName FROM Contact WHERE Name='Child Contact Sales Owner'];

        // Expect that inserted child account has the same Sales owner as Parent Account
        System.assertEquals(insertedparent.Sales_Owner__c, updatedChild.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 1');
        System.assertEquals(insertedparent.Sales_Owner__c, updatedContact.OwnerID,'Error: Contact Sales Owner does not match with Account Sales Owner');

    }*/

    @isTest static void ChangeParrentAccount_RecordType_test()
    {
        // 1. Create first user that will be Sales Owner
        User user_SalesOwnerTest = new User(FirstName='TestUserLukaMarko', LastName='TestUserLuka', Username='LukaOwnerMarko@sads.cm', Email='LUKAMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest;

        User user_SalesOwner2 = new User(FirstName='TestUser2', LastName='TestUser2', Username='TestUser2@sads.cm', Email='TestUser2@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwner2;

        // 2. Get user from database (Id)
        User salesOwner1=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserLukaMarko'];
        User salesOwner2=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUser2'];
    
        // 3. Create first parent account with inserted user as Sales Owner
        Account parent = new Account(Name='Parent Acc12', Sales_Owner__c=salesOwner1.Id, Type='Partner', RecordTypeId=RECORD_TYPE_KIS_ID, BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular' ,Veeam_License_Subscription__c='Yes');
        insert parent;
        Account par = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='Parent Acc12'];

          // 4. Create contact associated with first parent account
          Contact contactChild = new Contact(LastName='Child Contact Sales Owner', AccountId=par.Id, Contact_Roles__c='Accounting/Invoice role');
          insert contactChild;

          // 5. Update Parrent Account RecordType
          par.RecordTypeId =RECORD_TYPE_KIS_NL_ID;
          par.Support_Level__c ='Gold';
          par.Sales_Owner__c =salesOwner2.Id;
          Update par;
  
          Account updatedParrent = [Select Id, Sales_Owner__c, RecordTypeId, Name FROM Account WHERE Name='Parent Acc12'];
  
          //Add new child account
          Account child =  new Account(Name='Child Acc', ParentId=updatedParrent.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
          insert child;

          Account insertedChild = [Select Id, Sales_Owner__c, RecordTypeId, Name, Country_Code__c FROM Account WHERE Name='Child Acc'];
        // 6. Check child accounts records for Sales Owner field value
        System.assertEquals(par.RecordTypeId, insertedChild.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type');
        System.assertEquals('NL', insertedChild.Country_Code__c, 'Error: Child Account Country Code does not math with parrent account Country Code');
   

    }   

    @isTest static void MultipleChildren_SalesOwner_test()
    {
        // 1. Create first user that will be Sales Owner
        User user_SalesOwnerTest = new User(FirstName='TestUserLukaMarko', LastName='TestUserLuka', Username='LukaOwnerMarko@sads.cm', Email='LUKAMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest;

        // 2. Get user from database (Id)
        User salesOwner1=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserLukaMarko'];
    
        // 3. Create first parent account with inserted user as Sales Owner
        Account parent = new Account(Name='Parent Acc12', Sales_Owner__c=salesOwner1.Id, Type='Partner', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular' ,Veeam_License_Subscription__c='Yes');
        insert parent;
        Account par = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='Parent Acc12'];

        // 4. Create second user to change the Sales Owner Id field on Accounts
        User user_SalesOwnerTest2 = new User(FirstName='TestUserSimonMarko', LastName='TestSimonMarko', Username='SimonMarko@neki.com', Email='simonamrko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest2;
        User salesOwner2=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserSimonMarko'];     

        // 5. Create child accounts associated with first parent account
        Account child1 =  new Account(Name='Child Acc1', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        
        Account child2 =  new Account(Name='Child Acc2', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');

        Account child3 =  new Account(Name='Child Acc3', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');

        Account child4 =  new Account(Name='Child Acc4', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');

        Account child5 =  new Account(Name='Child Acc5', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');

        // put child accounts on the list and then insert them once
        List<Account> insertAccounts = new List<Account>();
        insertAccounts.add(child1);
        insertAccounts.add(child2);
        insertAccounts.add(child3);
        insertAccounts.add(child4);
        insertAccounts.add(child5);
        insert insertAccounts;
        //get all inserted accounts
        Account insertedChild1 = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc1'];
        Account insertedChild2 = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc2'];
        Account insertedChild3 = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc3'];
        Account insertedChild4 = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc4'];
        Account insertedChild5 = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc5'];

        // 6. Check child accounts records for Sales Owner field value
        System.assertEquals(par.Sales_Owner__c, insertedChild1.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 1');
        System.assertEquals(par.Sales_Owner__c, insertedChild2.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 2');
        System.assertEquals(par.Sales_Owner__c, insertedChild3.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 3');
        System.assertEquals(par.Sales_Owner__c, insertedChild4.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 4');
        System.assertEquals(par.Sales_Owner__c, insertedChild5.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 5');

    }   

    @isTest static void ParentChangedFromPartnerToCustomer()
    {
        // 1. Create first user that will be Sales Owner
        User user_SalesOwnerTest = new User(FirstName='TestUserLukaMarko', LastName='TestUserLuka', Username='LukaOwnerMarko@sads.cm', Email='LUKAMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest;

        // 2. Get user from database (Id)
        User salesOwner1=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserLukaMarko'];
    
        // 3. Create first parent account with inserted user as Sales Owner
        Account parent = new Account(Name='Parent Acc12', Sales_Owner__c=salesOwner1.Id, Type='Partner', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
        insert parent;
        Account par = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='Parent Acc12'];

        // 4. Create child accounts associated with first parent account
        Account child1 =  new Account(Name='Child Acc1', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child1;
        Account insertedChild1 = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc1'];

        // 5. Create first parent account with inserted user as Sales Owner
        Account parentCustomer = new Account(Name='Parent Acc customer', Sales_Owner__c=salesOwner1.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
        insert parentCustomer;
        Account parCustomer = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='Parent Acc customer'];

        // Parent account changed from Partner to Customer (Partnership canceled / wrong insertion of Parent account)
        // Business logic discussion with Christine (Sales_Owner__c).
        // What will happened with Child Acconts?
    }

    @isTest static void MultipleChildren_Update_RecordType_To_KeepItSafeNL_test()
    {
        // 1. Create first user that will be Sales Owner
        User user_SalesOwnerTest = new User(FirstName='TestUserLukaMarko', LastName='TestUserLuka', Username='LukaOwnerMarko@sads.cm', Email='LUKAMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        User user_SalesOwnerTest2 = new User(FirstName='TestUserSimonMarko', LastName='TestSimonMarko', Username='SimonMarko@neki.com', Email='simonamrko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        //insert user_SalesOwnerTest;
        List<User> insertUsers = new List<User>();
        insertUsers.add(user_SalesOwnerTest);
        insertUsers.add(user_SalesOwnerTest2);
        insert insertUsers;

        // 2. Get user from database (Id)
        User salesOwner1=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserLukaMarko'];
        User salesOwner2=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserSimonMarko']; 

        // 3. Create first parent account with inserted user as Sales Owner
        Account parent = new Account(Name='Parent Acc RecordType', Sales_Owner__c=salesOwner1.Id, Type='Partner', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
        insert parent;
        Account par = [Select Id, Sales_Owner__c, Name, RecordTypeId FROM Account WHERE Name='Parent Acc RecordType'];

        // 4. Create second user to change the Sales Owner Id field on Accounts
        //User user_SalesOwnerTest2 = new User(FirstName='TestUserSimonMarko', LastName='TestSimonMarko', Username='SimonMarko@neki.com', Email='simonamrko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        //insert user_SalesOwnerTest2;
        //User salesOwner2=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserSimonMarko'];     

        // 5. Create child accounts associated with first parent account but have 'recordType=> KeepItSafe' (ID='012600000009VEgAAM')
        Account child1 =  new Account(Name='Child Acc1', ParentId=par.Id, Type='Customer', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        Account child2 =  new Account(Name='Child Acc2', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        Account child3 =  new Account(Name='Child Acc3', ParentId=par.Id, Type='Customer', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        Account child4 =  new Account(Name='Child Acc4', ParentId=par.Id, Type='Customer', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        Account child5 =  new Account(Name='Child Acc5', ParentId=par.Id, Type='Customer', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        List<Account> insertAccounts = new List<Account>();
        insertAccounts.add(child1);
        insertAccounts.add(child2);
        insertAccounts.add(child3);
        insertAccounts.add(child4);
        insertAccounts.add(child5);
        insert insertAccounts;
        Account insertedChild1 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId FROM Account WHERE Name='Child Acc1'];
        Account insertedChild2 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId FROM Account WHERE Name='Child Acc2'];
        Account insertedChild3 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId FROM Account WHERE Name='Child Acc3'];
        Account insertedChild4 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId FROM Account WHERE Name='Child Acc4'];
        Account insertedChild5 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId FROM Account WHERE Name='Child Acc5'];
        /*
        Account child3 =  new Account(Name='Child Acc3', ParentId=par.Id, Type='Customer', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        //insert child3;
        Account insertedChild3 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId FROM Account WHERE Name='Child Acc3'];

        Account child4 =  new Account(Name='Child Acc4', ParentId=par.Id, Type='Customer', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        //insert child4;
        Account insertedChild4 = [Select Id, Sales_Owner__c, OwnerID, RecordTypeId, Name FROM Account WHERE Name='Child Acc4'];

        Account child5 =  new Account(Name='Child Acc5', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        //insert child5;
        Account insertedChild5 = [Select Id, Sales_Owner__c, OwnerID, RecordTypeId, Name FROM Account WHERE Name='Child Acc5'];
        */


        // 6. Check child accounts records for  'recordType=> KeepItSafeNL'
        System.assertEquals(par.RecordTypeId, insertedChild1.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type 1');
        System.assertEquals(par.RecordTypeId, insertedChild2.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type 2');
        System.assertEquals(par.RecordTypeId, insertedChild3.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type 3');
        System.assertEquals(par.RecordTypeId, insertedChild4.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type 4');
        System.assertEquals(par.RecordTypeId, insertedChild5.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type 4');
        System.assertEquals(par.Sales_Owner__c, insertedChild1.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 4');
        System.assertEquals(par.Sales_Owner__c, insertedChild2.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 5'); 
    }   


    @isTest static void MultipleChildren_Update_Country_Code_To_NL_test()
    {
        // 1. Create first user that will be Sales Owner
        User user_SalesOwnerTest = new User(FirstName='TestUserLukaMarko', LastName='TestUserLuka', Username='LukaOwnerMarko@sads.cm', Email='LUKAMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest;

        // 2. Get user from database (Id)
        User salesOwner1=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserLukaMarko'];
    
        // 3. Create first parent account with inserted user as Sales Owner
        Account parent = new Account(Name='Parent Acc CountryCode', Sales_Owner__c=salesOwner1.Id, Type='Partner', Country_Code__c='SI', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
        insert parent;
        Account par = [Select Id, Sales_Owner__c, Name, Country_Code__c FROM Account WHERE Name='Parent Acc CountryCode'];

        // 4. Create second user to change the Sales Owner Id field on Accounts
        User user_SalesOwnerTest2 = new User(FirstName='TestUserSimonMarko', LastName='TestSimonMarko', Username='SimonMarko@neki.com', Email='simonamrko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest2;
        User salesOwner2=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserSimonMarko'];     

        // 5. Create child accounts associated with first parent account but have record Type KeepItSafe (ID='012600000009VEgAAM') and differenct Country Code which is not NL
        Account child1 =  new Account(Name='Child Acc1', ParentId=par.Id, Type='Customer', Country_Code__c='SI', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child1;
        Account insertedChild1 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId, Country_Code__c FROM Account WHERE Name='Child Acc1'];
        
        Account child2 =  new Account(Name='Child Acc2', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child2;
        Account insertedChild2 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId, Country_Code__c FROM Account WHERE Name='Child Acc2'];

        Account child3 =  new Account(Name='Child Acc3', ParentId=par.Id, Type='Customer', Country_Code__c='NL', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child3;
        Account insertedChild3 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId, Country_Code__c FROM Account WHERE Name='Child Acc3'];

        
        // 6. Check child accounts records for 'Country_Code' Set to 'NL'
        System.assertEquals(par.Country_Code__c, insertedChild1.Country_Code__c, 'Error: Child Account Country Code does not math with parrent account Country Code  1');
        System.assertEquals(par.Country_Code__c, insertedChild2.Country_Code__c, 'Error: Child Account Country Code does not math with parrent account Country Code  2');
        System.assertEquals(par.Country_Code__c, insertedChild3.Country_Code__c, 'Error: Child Account Country Code does not math with parrent account Country Code  3');
    }   


    @isTest static void test_Remaining_featuresAccountRecordType() 
    {
        // 1. Create first user that will be Sales Owner
        User user_SalesOwnerTest = new User(FirstName='TestUserLukaMarko', LastName='TestUserLuka', Username='LukaOwnerMarko@sads.cm', Email='LUKAMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest;

        User user_SalesOwner= new User(FirstName='TestUserMarko', LastName='TestUserLuka', Username='TestUserMarko@sads.cm', Email='TestUserMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwner;

        // 2. Get user from database (Id)
        User salesOwner1=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserLukaMarko'];
           // 2. Get user from database (Id)
         User salesOwnerMarko=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserMarko'];

        // 3. Create first parent account with inserted user as Sales Owner
        Account parent = new Account(Name='Parent Acc12', Sales_Owner__c=salesOwner1.Id, Type='Partner', RecordTypeId=RECORD_TYPE_KIS_ID, BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='BillingStreet\r\n V dolini tihi\r\n je vasica mala\r\n v večernem Mraku\r\n vse že mirno spava\r\n le eno okno še odprto je', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
        insert parent;
        Account insertedParent = [Select Id, Country_Code__c, RecordTypeId, Name FROM Account WHERE Name='Parent Acc12'];


        Account child =  new Account(Name='Child Acc', ParentId=insertedParent.Id, Type='Customer', Country_Code__c='NL', Special_Attention__c=false, High_Revenue__c=false, RecordTypeId=RECORD_TYPE_KIS_ID, BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child;
        Account insertedChild = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId, Country_Code__c FROM Account WHERE Name='Child Acc'];
        
        // Update Parrent Account Record Type
        insertedParent.RecordTypeId=RECORD_TYPE_KIS_NL_ID;
        insertedParent.Sales_Owner__c=salesOwnerMarko.Id;
        insertedParent.Special_Attention__c = true;
        insertedParent.High_Revenue__c = true;
        insertedParent.Support_Level__c ='Gold';

        insertedChild.Name='NewNameOfChild';


        List<Account> insertAccounts = new List<Account>();
        insertAccounts.add(insertedParent);
        insertAccounts.add(insertedChild);
        Update insertAccounts;



        Account UpdatedParent = [Select Id, Special_Attention__c, Support_Level__c, High_Revenue__c, Country_Code__c, RecordTypeId, Name FROM Account WHERE Name='Parent Acc12'];
        Account updatedChild = [Select Id, Country_Code__c, RecordTypeId, Special_Attention__c, Support_Level__c, High_Revenue__c, Name FROM Account WHERE Name='NewNameOfChild'];

        System.assertEquals('NL', UpdatedParent.Country_Code__c, 'Error: Account Country Code does not math with Expected!');
        System.assertEquals('NL', updatedChild.Country_Code__c, 'Error: Updated Account Country Code does not math with Expected!');

        System.assertEquals(true, updatedChild.Special_Attention__c, 'Error: Updated Child Account Special_Attention__c does not math with Expected!');
        System.assertEquals(true, updatedChild.High_Revenue__c, 'Error: Updated Child Account High_Revenue__c does not math with Expected!');
        System.assertEquals('Gold', updatedChild.Support_Level__c, 'Error: Updated Child Account Support_Level__c does not math with Expected!');
      
      
    }


    @isTest static void test_Remaining_featuresAccountBeforeUpdate() 
    {
        User user_SalesOwnerTest = new User(FirstName='TestUserLukaMarko', LastName='TestUserLuka', Username='LukaOwnerMarko@sads.cm', Email='LUKAMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest;

        User user_SalesOwner= new User(FirstName='TestUser', LastName='TestUserLuka', Username='TestUser@sads.cm', Email='TestUser@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwner;

        Account parent = new Account(Name='Parent Acc12', Sales_Owner__c=user_SalesOwnerTest.Id, Type='Partner', RecordTypeId=RECORD_TYPE_KIS_ID, Brand__c='MyFax', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
        insert parent;
   
        Account insertedParent = [Select Id, Sales_Owner__c, Country_Code__c, RecordTypeId, Name FROM Account WHERE Name='Parent Acc12'];

        Account child =  new Account(Name='Child Acc', ParentId=insertedParent.Id, Type='Customer', Country_Code__c='NL', RecordTypeId=RECORD_TYPE_KIS_ID, BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child;

        
        Account insertedChild = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId, Country_Code__c FROM Account WHERE Name='Child Acc'];

        insertedParent.Sales_Owner__c= user_SalesOwner.Id;
        insertedChild.Name='Child Acc Updated';

        List<Account> insertAccounts = new List<Account>();
        insertAccounts.add(insertedParent);
        insertAccounts.add(insertedChild);
        Update insertAccounts;

        Account UpdatedParrent = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId, Country_Code__c FROM Account WHERE Name='Parent Acc12'];
        Account UpdatedChild = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId, Country_Code__c FROM Account WHERE Name='Child Acc Updated'];

        System.assertEquals(RECORD_TYPE_MyFax, UpdatedParrent.RecordTypeId, 'Error: Account RecordType does not math with Expected!');
        System.assertEquals(RECORD_TYPE_MyFax, UpdatedChild.RecordTypeId, 'Error:Child Account RecordType does not math with Expected!');

    }

    @isTest static void account_keepItSafe_LiveVault_Test_1(){
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
// IMPORTANT: need to adjust to Sceduler:  ChildAccountSceduledUpdate(parentAccount, batchAccountsList)
   //     System.assertEquals(queriedParent.Support_Level__c, queriedChild.Support_Level__c, '[Update event] Support level is not mapped correctly.');
  //      System.assertEquals(queriedParent.High_Revenue__c, queriedChild.High_Revenue__c, '[Update event] High revenue is not mapped correctly.');
   //     System.assertEquals(queriedParent.Special_Attention__c, queriedChild.Special_Attention__c, '[Update event] Special attention is not mapped correctly.');
        
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
  /*
    @isTest static void account_testSupportLevel_on_MRR()
    {
        Id recordTypeId = [Select Name,Id From RecordType where Name ='KeepItSafe'].Id;

        Account parent = new Account(Name='Parent 1 test', Support_Level__c = 'Gold', Type='Partner', High_Revenue__c = true, Special_Attention__c = true, RecordTypeId=recordTypeId);
        insert parent;

        Account child1 = new Account(Name='Child 1 test', Support_Level__c = null, Type = 'Customer', /*KIS_Total_Invoice_Amount__c=540, High_Revenue__c = false, /*MRR__c = 540,Special_Attention__c = false, RecordTypeId=recordTypeId, ParentId=parent.Id);
        insert child1;
        Account queriedChild1 = [SELECT Id, Support_Level__c, MRR__c FROM Account WHERE Name='Child 1 test'];
       
        Invoice__c testInvoice = new Invoice__c(Account__c = child1.Id, Status__c = 'Active',
        Sign_Up_Date__c = date.Today(), Amount__c = 540,
        Billing_Run_Date__c  = date.Today());
        insert testInvoice;   
        queriedChild1 = [SELECT Id, Support_Level__c, MRR__c, Active_Invoices__c FROM Account WHERE Name='Child 1 test'];
        System.assertEquals(1, queriedChild1.Active_Invoices__c, 'Child Active invoices not set correctly');

        Account queriedParent = [SELECT Id, Support_Level__c, MRR__c FROM Account WHERE Name='Parent 1 test'];
        queriedChild1 = [SELECT Id, Support_Level__c, MRR__c FROM Account WHERE Name='Child 1 test'];

        System.assertEquals('Bronze', queriedParent.Support_Level__c, 'Support level on parent not set correctly');
        System.assertEquals('Bronze', queriedChild1.Support_Level__c, 'Support level on child not set correctly 2');

        // Temp workaround for update event 
        // We don't have info how MRR for account is calculated (probably Invoice Amount__c), therefore
        // we need to update both Account and the Invoice to get wanted result (should update only invoice once we have the info for MRR calculation)
        //queriedChild1.MRR__c = 2500;
        //update queriedChild1;
        
        Invoice__c queriedInvoice = [SELECT Id, Amount__c FROM Invoice__c WHERE Account__c =: queriedChild1.Id];
        System.Debug('Invoice query : ' + queriedInvoice);
        queriedInvoice.Amount__c = 2500;
        update queriedInvoice;

        queriedParent = [SELECT Id, Support_Level__c, MRR__c FROM Account WHERE Name='Parent 1 test'];
        queriedChild1 = [SELECT Id, Support_Level__c, MRR__c FROM Account WHERE Name='Child 1 test'];

        System.assertEquals('Gold', queriedParent.Support_Level__c, 'Support level on parent not set correctly [UPDATE]');
        System.assertEquals('Gold', queriedChild1.Support_Level__c, 'Support level on child not set correctly [UPDATE]');
    }*/
    @isTest  
    static void TestUpdateChildAccountWithBatch() 
    {
        Test.startTest();
  
        Set<Id> parentId= new Set<Id> ();
        User user_SalesOwnerTest = new User(FirstName='TestUserLukaMarko', LastName='TestUserLuka', Username='LukaOwnerMarko@sads.cm', Email='LUKAMarko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest;

        Account acc = new Account(Name='MarkoLukaTestSceduledAccounts', Type='Partner', RecordTypeId=RECORD_TYPE_KIS_NL_ID, phone='43535433');
        insert acc;

        Account parentAcc = [SELECT Id, Name, MRR__c, ParentId, Customer_ID2__c, RecordTypeId, Special_Attention__c, High_Revenue__c, CreatedDate, Sales_Owner__c, Type, Country_Code__c, 
        Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, 
        Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c from Account where name='MarkoLukaTestSceduledAccounts'];

        parentId.Add(parentAcc.Id);
        List<Account> childAccounts = new List<Account>();
        for (Integer i =0; i<20; i++)
        {
            Integer amount = 100+i;
            Account childAccount = new Account(Name = 'MarkoLukaAccountSceduler'+i, 
                                    Status__c = 'Active',parentId=parentAcc.ID,
                                    RecordTypeId = RECORD_TYPE_KIS_ID,
                                    BillingCountry='NL', 
                                    BillingCity='City', 
                                    BillingState='Budl', 
                                    BillingPostalCode='123123', 
                                    BillingStreet='Street', 
                                    Customer_Source__c='Backup Factory',
                                    Phone='12213213', 
                                    Support_Level__c='Regular',
                                    Veeam_License_Subscription__c='Yes');
            
            childAccounts.Add(childAccount);
        }
            insert childAccounts;

            //change parent account support level
            parentAcc.support_level__c='Gold';
            parentAcc.RecordTypeId=RECORD_TYPE_KIS_ID;
            parentAcc.Sales_Owner__c=user_SalesOwnerTest.Id;
            parentAcc.Special_Attention__c=true;
            parentAcc.High_Revenue__c=true;
            update parentAcc;

           ChildAccountUpdate_Batch UpdateAcc = new ChildAccountUpdate_Batch(parentId);
            Database.executeBatch(UpdateAcc);
            Test.stopTest();

            List<Account> newChildAccounts =[SELECT Id, Name, MRR__c, ParentId, Customer_ID2__c, RecordTypeId, Special_Attention__c, High_Revenue__c, CreatedDate, Sales_Owner__c, Type, Country_Code__c, 
            Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, 
            Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c from Account where parentId=:parentAcc.Id];           

            //get child acocunts support status
             List<Account> updatedChildAccounts =[Select Id, name,support_level__c from Account where parentId=:parentAcc.Id];
            List<Account> verifiedupdatedChildAccounts = new List<Account>();

            for(Account uppAcc : updatedChildAccounts )
            {
                if (uppAcc.support_level__c == 'Gold')
                {
                    verifiedupdatedChildAccounts.add(uppAcc);
                }
            }
            System.assertEquals(20, verifiedupdatedChildAccounts.size(),'The Child Account Support level does not match with Parent!');
    }

}