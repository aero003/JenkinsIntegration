@isTest
private class KeepitSafeNLAccountHandlerTest {     
 /*   @testSetup static void testMethod_setup() { 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='KeepItSafe IRE Sales User']; 
        User u = new User(Alias = 'standt', Email='adminuser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='adminuser@testorgkeepitsafenl.com');
        insert u;
        //Create Account
        List<RecordType> AccRecordTypes = [Select Id from RecordType where sObjectType = 'Account' and developerName ='KeepItSafeNL'];        
        List<Account> accsToInsert = new List<Account>();
        for(Integer i = 0; i<4 ; i++){   
            accsToInsert.add(new Account(Name = 'KeepItsafe Test Account' + i , Type = 'Prospect', Sales_Owner__c = u.Id, Support_Level__c = 'Gold', Country_Code__c = 'US', RecordTypeId = AccRecordTypes[0].Id ));
        }
        insert accsToInsert; 
        
        //Create related Contact
        List<RecordType> ConRecordTypes = [Select Id from RecordType where sObjectType = 'Contact' and developerName ='Keepitsafe'];        
        List<Contact> consToInsert = new List<Contact>();
        for(Integer i=0; i<4; i++){          
            consToInsert.add(new Contact(LastName = 'KeepItsafe Test Contact' + i , AccountId =  accsToInsert[i].Id, RecordTypeId = ConRecordTypes[0].Id, Access_role__c='Customer User', MailingCountry ='US'));
        }
        insert consToInsert;
        
        //Create related Opportunity
        List<RecordType> OppRecordTypes = [Select Id from RecordType where sObjectType = 'Opportunity' and developerName ='Keepitsafe_Record_Type'];        
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        for(Integer i=0; i<4; i++){            
            oppsToInsert.add(new Opportunity(Name = 'KeepItsafe Test Opp' + i, Amount = 12, Package__c = 'Online Backup', Type='Partner', StageName = 'Contract Sent',
                                            LeadSource='Cold Call', ForecastCategoryName = 'Pipeline', GB_Package__c = 21, CloseDate=System.today().addMonths(1),
                                            AccountId =  accsToInsert[i].Id, RecordTypeId = OppRecordTypes[0].Id));
        }
        insert oppsToInsert;
        
        //Create child Accounts(Account Hierarchy)        
        List<Account> childAccsToInsert = new List<Account>();
        for(Integer i = 0; i<4 ; i++){              
            childAccsToInsert.add(new Account(Name = 'KeepItsafe Test Child Account' + i , Sales_Owner__c = u.Id, Support_Level__c = 'Gold', Country_Code__c = 'US',
                                     RecordTypeId = AccRecordTypes[0].Id, Type = 'Customer', ParentID =  accsToInsert[i].Id));
        }
        insert childAccsToInsert;
        
        //Create Contacts of child Accounts
        List<Contact> childConsToInsert = new List<Contact>();
        for(Integer i=0; i<4; i++){           
            childConsToInsert.add(new Contact(LastName = 'KeepItsafe Test Contact' + i , AccountId =  childAccsToInsert[i].Id, RecordTypeId = ConRecordTypes[0].Id, Access_role__c='Customer User', MailingCountry ='US'));
        }
        insert childConsToInsert;
        
        //Create Opportunity of Child Accounts
        List<Opportunity> childOppsToInsert = new List<Opportunity>();
        for(Integer i=0; i<4; i++){           
            childOppsToInsert.add(new Opportunity(Name = 'KeepItsafe Test Opp' + i, Amount = 12, Package__c = 'Online Backup', Type='Partner', StageName = 'Contract Sent',
                                            LeadSource='Cold Call', ForecastCategoryName = 'Pipeline', GB_Package__c = 21, CloseDate=System.today().addMonths(1),
                                            AccountId =  childAccsToInsert[i].Id, RecordTypeId = OppRecordTypes[0].Id));
        }
        insert childOppsToInsert;  
    }

    @isTest static void testMethod_1() {
        List<Account> insertedAcc = [Select Id, Name, OwnerId, Type, Sales_Owner__c, Support_Level__c, Country_Code__c, RecordType.Name from Account where Name like 'KeepItsafe Test Account%'];
        
        //Update the Parent Account
        for(Account a : insertedAcc){
            a.Type = 'Partner';
        }
        test.startTest();
        update insertedAcc;        
        test.stopTest();
        System.debug('insertedAcc type field value = ' + insertedAcc[0].Type);  */
       
     /* Contact contact = [Select Id, OwnerId from Contact where AccountId = :insertedAcc[0].Id limit 1];
        Opportunity opportunity = [Select Id, OwnerId from Opportunity where AccountId = :insertedAcc[0].Id limit 1];
        Account childAccount = [Select Id, OwnerId, Sales_Owner__c from Account where ParentId = :insertedAcc[0].Id limit 1];
        Contact childAccount_contact = [Select Id, OwnerId from Contact where AccountId = :childAccount.Id limit 1];
        Opportunity childAccount_opportunity = [Select Id, OwnerId from Opportunity where AccountId = :childAccount.Id limit 1 ];
        System.assertEquals(contact.OwnerId, insertedAcc[0].Sales_Owner__c);
        System.assertEquals(opportunity.OwnerId, insertedAcc[0].Sales_Owner__c);
        System.assertEquals(childAccount.OwnerId, insertedAcc[0].Sales_Owner__c);
        System.assertEquals(childAccount.Sales_Owner__c, insertedAcc[0].Sales_Owner__c);
        System.assertEquals(childAccount_contact.OwnerId, childAccount.Sales_Owner__c);
        System.assertEquals(childAccount_opportunity.OwnerId, childAccount.Sales_Owner__c);*/
    //}

    private static final Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId();
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
/*
     
    @isTest static void test_SalesOwner_fromParentAccount() {

        // 1) creates a parent NL account with contact and an owner
        User parentAccountSalesOwner = new User(FirstName='parentAccountSalesOwner', LastName='parentAccountSalesOwner', 
                Username='parentAccountSalesOwner@j2.com', Email='parentAccountSalesOwner@j2.com', 
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
                RecordTypeId=RECORD_TYPE_KIS_NL_ID,BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
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
                Username='newParentAccountSalesOwner@j2.com', Email='newParentAccountSalesOwner@j2.com', Alias='usr', 
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
        Account par = [Select Id, Sales_Owner__c, Name FROM Account WHERE Name='Parent Acc12'];

        // 4. Create second user to change the Sales Owner Id field on Accounts
        User user_SalesOwnerTest2 = new User(FirstName='TestUserSimonMarko', LastName='TestSimonMarko', Username='SimonMarko@neki.com', Email='simonamrko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest2;
        User salesOwner2=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserSimonMarko'];     
        
        // 5. Create contact associated with first parent account
        Contact contactChild = new Contact(LastName='Child Contact Sales Owner', AccountId=par.Id, Contact_Roles__c='Accounting/Invoice role');
        insert contactChild;

        // 6. Create child account associated with first parent account
        Account child =  new Account(Name='Child Acc', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child;
        Account insertedChild = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc'];

        // 7. Get updated records from database to check if trigger logic is correct
        Account updatedChild = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc'];
        Contact updatedContact = [Select Id, OwnerID, LastName FROM Contact WHERE Name='Child Contact Sales Owner'];

        // Expect that inserted child account has the same Sales owner as Parent Account
        System.assertEquals(parent.Sales_Owner__c, insertedChild.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 1');
        System.assertEquals(parent.Sales_Owner__c, updatedContact.OwnerID,'Error: Contact Sales Owner does not match with Account Sales Owner');

        
        // 8. Create second parent to change the ParentId field on Account
        Account parent2 = new Account(Name='Parent AccSimon', Sales_Owner__c=salesOwner2.Id, Type='Partner', RecordTypeId='012320000005P4IAAU');
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
        insert child1;
        Account insertedChild1 = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc1'];
        
        Account child2 =  new Account(Name='Child Acc2', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child2;
        Account insertedChild2 = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc2'];

        Account child3 =  new Account(Name='Child Acc3', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child3;
        Account insertedChild3 = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc3'];

        Account child4 =  new Account(Name='Child Acc4', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child4;
        Account insertedChild4 = [Select Id, Sales_Owner__c, OwnerID, Name FROM Account WHERE Name='Child Acc4'];

        Account child5 =  new Account(Name='Child Acc5', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child5;
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
        insert user_SalesOwnerTest;

        // 2. Get user from database (Id)
        User salesOwner1=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserLukaMarko'];
    
        // 3. Create first parent account with inserted user as Sales Owner
        Account parent = new Account(Name='Parent Acc RecordType', Sales_Owner__c=salesOwner1.Id, Type='Partner', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
        insert parent;
        Account par = [Select Id, Sales_Owner__c, Name, RecordTypeId FROM Account WHERE Name='Parent Acc RecordType'];

        // 4. Create second user to change the Sales Owner Id field on Accounts
        User user_SalesOwnerTest2 = new User(FirstName='TestUserSimonMarko', LastName='TestSimonMarko', Username='SimonMarko@neki.com', Email='simonamrko@haha.com', Alias='usr', LocaleSidKey='en_US', LanguageLocaleKey ='en_US', EmailEncodingKey='UTF-8', ProfileId='00e60000000ioOUAAY', TimeZoneSidKey='Europe/Berlin');
        insert user_SalesOwnerTest2;
        User salesOwner2=[SELECT Id, FirstName, LastName FROM User WHERE FirstName='TestUserSimonMarko'];     

        // 5. Create child accounts associated with first parent account but have 'recordType=> KeepItSafe' (ID='012600000009VEgAAM')
        Account child1 =  new Account(Name='Child Acc1', ParentId=par.Id, Type='Customer', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child1;
        Account insertedChild1 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId FROM Account WHERE Name='Child Acc1'];
        
        Account child2 =  new Account(Name='Child Acc2', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child2;
        Account insertedChild2 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId FROM Account WHERE Name='Child Acc2'];

        Account child3 =  new Account(Name='Child Acc3', ParentId=par.Id, Type='Customer', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child3;
        Account insertedChild3 = [Select Id, Sales_Owner__c, OwnerID, Name, RecordTypeId FROM Account WHERE Name='Child Acc3'];

        Account child4 =  new Account(Name='Child Acc4', ParentId=par.Id, Type='Customer', RecordTypeId='012600000009VEgAAM', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child4;
        Account insertedChild4 = [Select Id, Sales_Owner__c, OwnerID, RecordTypeId, Name FROM Account WHERE Name='Child Acc4'];

        Account child5 =  new Account(Name='Child Acc5', ParentId=par.Id, Type='Customer', RecordTypeId='012320000005P4IAAU', BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert child5;
        Account insertedChild5 = [Select Id, Sales_Owner__c, OwnerID, RecordTypeId, Name FROM Account WHERE Name='Child Acc5'];

        // 6. Check child accounts records for  'recordType=> KeepItSafeNL'
        System.assertEquals(par.RecordTypeId, insertedChild1.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type 1');
        System.assertEquals(par.RecordTypeId, insertedChild2.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type 2');
        System.assertEquals(par.RecordTypeId, insertedChild3.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type 3');
        System.assertEquals(par.RecordTypeId, insertedChild4.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type 4');
        System.assertEquals(par.RecordTypeId, insertedChild4.RecordTypeId, 'Error: Child Account RecordType does not math with parrent account Record Type 4');
        System.assertEquals(par.Sales_Owner__c, insertedChild4.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 4');
        System.assertEquals(par.Sales_Owner__c, insertedChild5.Sales_Owner__c, 'Error: Child Account Sales owner does not math with parrent account Sales Owner 5'); 
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
    }   */
}