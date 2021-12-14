@isTest
public with sharing class AccountTriggerTest {
/*
    public static Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafe').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_UK_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeUK').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_US_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeUS').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_CA_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeCA').getRecordTypeId();
    
    @isTest static void SalesOwners_SupportLevel_ParrentAccount_Test_KIS()
    {
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='KeepItSafe US PLUS ePAY' LIMIT 1];
        List<User> user = [SELECT Id FROM User WHERE ProfileId=:profile[0].Id ORDER BY CreatedDate DESC LIMIT 3];
        
        // Test for trigger insert event
        Account accParentKIS = new Account(Name='Parent KIS', RecordTypeId=RECORD_TYPE_KIS_ID, Sales_Owner__c=user[0].Id, Support_Level__c ='Regular');
        insert accParentKIS;
        Account tempParentKIS = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS'];

        Account accChildKIS = new Account(Name='Child KIS', RecordTypeId=RECORD_TYPE_KIS_ID, ParentId=tempParentKIS.Id);
        insert accChildKIS;
        Account tempChildKIS = [SELECT Id,Support_Level__c, Sales_Owner__c FROM Account WHERE Name='Child KIS'];

        System.assertEquals(tempParentKIS.Sales_Owner__c, tempChildKIS.Sales_Owner__c);
        System.assertEquals(tempParentKIS.Support_Level__c, tempChildKIS.Support_Level__c,'Unexpeceted Support Level set on account (tempChildKIS.Support_Level__c)');

        // Test for trigger update event - parent Account
        Account tempParentKIS_3 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS'];
        tempParentKIS_3.Sales_Owner__c = user[2].Id;
        tempParentKIS_3.Support_Level__c = 'Silver';
        update tempParentKIS_3;
        tempParentKIS_3 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS'];
        Account tempChildKIS_3 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS'];
        System.assertEquals(tempParentKIS_3.Sales_Owner__c, tempChildKIS_3.Sales_Owner__c);
        System.assertEquals(tempParentKIS_3.Support_Level__c, tempChildKIS_3.Support_Level__c, 'Unexpeceted Support Level set on account (tempChildKIS_3.Support_Level__c)');
    }

    @isTest static void SalesOwners_SupportLevel_ChildAccount_Test_KIS()
    {
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='KeepItSafe US PLUS ePAY' LIMIT 1];
        List<User> user = [SELECT Id FROM User WHERE ProfileId=:profile[0].Id ORDER BY CreatedDate DESC LIMIT 3];
        
        // Test for trigger insert event
        Account accParentKIS = new Account(Name='Parent KIS', RecordTypeId=RECORD_TYPE_KIS_ID, Sales_Owner__c=user[0].Id, Support_Level__c ='Regular');
        insert accParentKIS;
        Account tempParentKIS = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS'];

        Account accChildKIS = new Account(Name='Child KIS', RecordTypeId=RECORD_TYPE_KIS_ID, ParentId=tempParentKIS.Id);
        insert accChildKIS;
        Account tempChildKIS = [SELECT Id,Support_Level__c, Sales_Owner__c FROM Account WHERE Name='Child KIS'];

        System.assertEquals(tempParentKIS.Sales_Owner__c, tempChildKIS.Sales_Owner__c);
        System.assertEquals(tempParentKIS.Support_Level__c, tempChildKIS.Support_Level__c,'Unexpeceted Support Level set on account (tempChildKIS.Support_Level__c)');

        // Test for trigger update event - child Account
        Account tempChildKIS_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS'];
        tempChildKIS_2.Sales_Owner__c = user[1].Id;
        tempChildKIS_2.Support_Level__c = 'Gold';
        update tempChildKIS_2;
        tempChildKIS_2 = [SELECT Id, Sales_Owner__c,Support_Level__c FROM Account WHERE Name='Child KIS'];
        Account tempParentKIS_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS'];
        System.assertEquals(tempParentKIS_2.Sales_Owner__c, tempChildKIS_2.Sales_Owner__c, 'Unexpeceted Sales Owner set on account (tempChildKIS_2.Sales_Owner__c)');
        System.assertEquals(tempParentKIS_2.Support_Level__c, tempChildKIS_2.Support_Level__c, 'Unexpeceted Support Level set on account (tempChildKIS_2.Support_Level__c)');
    }


    @isTest static void SalesOwners_SupportLevel_ParrentAccount_Test_KIS_NL()
    {
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='KeepItSafe US PLUS ePAY' LIMIT 1];
        List<User> user = [SELECT Id FROM User WHERE ProfileId=:profile[0].Id ORDER BY CreatedDate DESC LIMIT 3];

        Account accParentKIS_NL = new Account(Name='Parent KIS NL', RecordTypeId=RECORD_TYPE_KIS_NL_ID, Sales_Owner__c=user[0].Id, Support_Level__c ='Regular');
        insert accParentKIS_NL;
        Account tempParentKIS_NL = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS NL'];

        Account accChildKIS_NL = new Account(Name='Child KIS NL', RecordTypeId=RECORD_TYPE_KIS_NL_ID, ParentId=tempParentKIS_NL.Id);
        insert accChildKIS_NL;
        Account tempChildKIS_NL = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS NL'];

        System.assertEquals(tempParentKIS_NL.Sales_Owner__c, tempChildKIS_NL.Sales_Owner__c);
        System.assertEquals(tempParentKIS_NL.Support_Level__c, tempChildKIS_NL.Support_Level__c);

        // Test for trigger update event - parent Account
        Account tempParentKIS_NL_3 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS NL'];
        tempParentKIS_NL_3.Sales_Owner__c = user[2].Id;
        tempParentKIS_NL_3.Support_Level__c = 'Silver';
        update tempParentKIS_NL_3;
        tempParentKIS_NL_3 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS NL'];
        Account tempChildKIS_NL_3 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS NL'];
        System.assertEquals(tempParentKIS_NL_3.Sales_Owner__c, tempChildKIS_NL_3.Sales_Owner__c);
       System.assertEquals(tempParentKIS_NL_3.Support_Level__c, tempChildKIS_NL_3.Support_Level__c);
    }

    @isTest static void SalesOwners_SupportLevel_ChildAccount_Test_KIS_NL()
    {
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='KeepItSafe US PLUS ePAY' LIMIT 1];
        List<User> user = [SELECT Id FROM User WHERE ProfileId=:profile[0].Id ORDER BY CreatedDate DESC LIMIT 3];

        Account accParentKIS_NL = new Account(Name='Parent KIS NL', RecordTypeId=RECORD_TYPE_KIS_NL_ID, Sales_Owner__c=user[0].Id, Support_Level__c ='Regular');
        insert accParentKIS_NL;
        Account tempParentKIS_NL = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS NL'];

        Account accChildKIS_NL = new Account(Name='Child KIS NL', RecordTypeId=RECORD_TYPE_KIS_NL_ID, ParentId=tempParentKIS_NL.Id);
        insert accChildKIS_NL;
        Account tempChildKIS_NL = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS NL'];

        System.assertEquals(tempParentKIS_NL.Sales_Owner__c, tempChildKIS_NL.Sales_Owner__c);
        System.assertEquals(tempParentKIS_NL.Support_Level__c, tempChildKIS_NL.Support_Level__c);

        // Test for trigger update event - child Account
        Account tempChildKIS_NL_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS NL'];
        tempChildKIS_NL_2.Sales_Owner__c = user[1].Id;
        tempChildKIS_NL_2.Support_Level__c = 'Gold';
        update tempChildKIS_NL_2;
        tempChildKIS_NL_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS NL'];
        Account tempParentKIS_NL_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS NL'];
        System.assertEquals(tempParentKIS_NL_2.Sales_Owner__c, tempChildKIS_NL_2.Sales_Owner__c);
        System.assertEquals(tempParentKIS_NL_2.Support_Level__c, tempChildKIS_NL_2.Support_Level__c);
    }

    @isTest static void SalesOwners_SupportLevel_ParrentAccount_Test_KIS_UK()
    {
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='KeepItSafe US PLUS ePAY' LIMIT 1];
        List<User> user = [SELECT Id FROM User WHERE ProfileId=:profile[0].Id ORDER BY CreatedDate DESC LIMIT 3];

        Account accParentKIS_UK = new Account(Name='Parent KIS UK', RecordTypeId=RECORD_TYPE_KIS_UK_ID, Sales_Owner__c=user[0].Id, Support_Level__c ='Regular');
        insert accParentKIS_UK;
        Account tempParentKIS_UK = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS UK'];

        Account accChildKIS_UK = new Account(Name='Child KIS UK', RecordTypeId=RECORD_TYPE_KIS_UK_ID, ParentId=tempParentKIS_UK.Id);
        insert accChildKIS_UK;
        Account tempChildKIS_UK = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS UK'];

        System.assertEquals(tempParentKIS_UK.Sales_Owner__c, tempChildKIS_UK.Sales_Owner__c);
        System.assertEquals(tempParentKIS_UK.Support_Level__c, tempChildKIS_UK.Support_Level__c);

        // Test for trigger update event - parent Account
        Account tempParentKIS_UK_3 = [SELECT Id, Sales_Owner__c FROM Account WHERE Name='Parent KIS UK'];
        tempParentKIS_UK_3.Sales_Owner__c = user[2].Id;
        tempParentKIS_UK_3.Support_Level__c = 'Silver';
        update tempParentKIS_UK_3;
        tempParentKIS_UK_3 = [SELECT Id, Sales_Owner__c,Support_Level__c FROM Account WHERE Name='Parent KIS UK'];
        Account tempChildKIS_UK_3 = [SELECT Id, Sales_Owner__c, Support_Level__c  FROM Account WHERE Name='Child KIS UK'];
        System.assertEquals(tempParentKIS_UK_3.Sales_Owner__c, tempChildKIS_UK_3.Sales_Owner__c);
        System.assertEquals(tempParentKIS_UK_3.Support_Level__c, tempChildKIS_UK_3.Support_Level__c);
    }


    
    @isTest static void SalesOwners_SupportLevel_ChildAccount_Test_KIS_UK()
    {
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='KeepItSafe US PLUS ePAY' LIMIT 1];
        List<User> user = [SELECT Id FROM User WHERE ProfileId=:profile[0].Id ORDER BY CreatedDate DESC LIMIT 3];

        Account accParentKIS_UK = new Account(Name='Parent KIS UK', RecordTypeId=RECORD_TYPE_KIS_UK_ID, Sales_Owner__c=user[0].Id, Support_Level__c ='Regular');
        insert accParentKIS_UK;
        Account tempParentKIS_UK = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS UK'];

        Account accChildKIS_UK = new Account(Name='Child KIS UK', RecordTypeId=RECORD_TYPE_KIS_UK_ID, ParentId=tempParentKIS_UK.Id);
        insert accChildKIS_UK;
        Account tempChildKIS_UK = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS UK'];

        System.assertEquals(tempParentKIS_UK.Sales_Owner__c, tempChildKIS_UK.Sales_Owner__c);
        System.assertEquals(tempParentKIS_UK.Support_Level__c, tempChildKIS_UK.Support_Level__c);

        // Test for trigger update event - child Account
        Account tempChildKIS_UK_2 = [SELECT Id, Sales_Owner__c,Support_Level__c FROM Account WHERE Name='Child KIS UK'];
        tempChildKIS_UK_2.Sales_Owner__c = user[1].Id;
        tempChildKIS_UK_2.Support_Level__c = 'Gold';
        update tempChildKIS_UK_2;
        tempChildKIS_UK_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS UK'];
        Account tempParentKIS_UK_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS UK'];
        System.assertEquals(tempParentKIS_UK_2.Sales_Owner__c, tempChildKIS_UK_2.Sales_Owner__c);
        System.assertEquals(tempParentKIS_UK_2.Support_Level__c, tempChildKIS_UK_2.Support_Level__c);
    }

    @isTest static void SalesOwners_SupportLevel_ParrentAccount_Test_KIS_US()
    {
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='KeepItSafe US PLUS ePAY' LIMIT 1];
        List<User> user = [SELECT Id FROM User WHERE ProfileId=:profile[0].Id ORDER BY CreatedDate DESC LIMIT 3];

        Account accParentKIS_US = new Account(Name='Parent KIS US', RecordTypeId=RECORD_TYPE_KIS_US_ID, Sales_Owner__c=user[0].Id, Phone ='123445', Support_Level__c ='Regular');
        insert accParentKIS_US;
        Account tempParentKIS_US = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS US'];

        Account accChildKIS_US = new Account(Name='Child KIS US',  RecordTypeId=RECORD_TYPE_KIS_UK_ID, ParentId=tempParentKIS_US.Id, Phone ='123445');
        insert accChildKIS_US;
        Account tempChildKIS_US = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS US'];

        System.assertEquals(tempParentKIS_US.Sales_Owner__c, tempChildKIS_US.Sales_Owner__c);
        System.assertEquals(tempParentKIS_US.Support_Level__c, tempChildKIS_US.Support_Level__c);

        // Test for trigger update event - parent Account
        Account tempParentKIS_US_3 = [SELECT Id, Sales_Owner__c,Support_Level__c FROM Account WHERE Name='Parent KIS US'];
        tempParentKIS_US_3.Sales_Owner__c = user[2].Id;
        tempParentKIS_US_3.Support_Level__c = 'Silver';
        update tempParentKIS_US_3;
        tempParentKIS_US_3 = [SELECT Id, Sales_Owner__c,Support_Level__c FROM Account WHERE Name='Parent KIS US'];
        Account tempChildKIS_US_3 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS US'];
        System.assertEquals(tempParentKIS_US_3.Sales_Owner__c, tempChildKIS_US_3.Sales_Owner__c);
        System.assertEquals(tempParentKIS_US_3.Support_Level__c, tempChildKIS_US_3.Support_Level__c);
    }


    @isTest static void SalesOwners_SupportLevel_ChildAccount_Test_KIS_US()
    {
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='KeepItSafe US PLUS ePAY' LIMIT 1];
        List<User> user = [SELECT Id FROM User WHERE ProfileId=:profile[0].Id ORDER BY CreatedDate DESC LIMIT 3];

        Account accParentKIS_US = new Account(Name='Parent KIS US', RecordTypeId=RECORD_TYPE_KIS_US_ID, Sales_Owner__c=user[0].Id, Phone ='123445', Support_Level__c ='Regular');
        insert accParentKIS_US;
        Account tempParentKIS_US = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS US'];

        Account accChildKIS_US = new Account(Name='Child KIS US',  RecordTypeId=RECORD_TYPE_KIS_US_ID, ParentId=tempParentKIS_US.Id, Phone ='123445');
        insert accChildKIS_US;
        Account tempChildKIS_US = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS US'];

        System.assertEquals(tempParentKIS_US.Sales_Owner__c, tempChildKIS_US.Sales_Owner__c);
        System.assertEquals(tempParentKIS_US.Support_Level__c, tempChildKIS_US.Support_Level__c);

        // Test for trigger update event - child Account
        Account tempChildKIS_US_2 = [SELECT Id, Sales_Owner__c,Support_Level__c FROM Account WHERE Name='Child KIS US'];
        tempChildKIS_US_2.Sales_Owner__c = user[1].Id;
        tempChildKIS_US_2.Support_Level__c = 'Gold';
        update tempChildKIS_US_2;
        tempChildKIS_US_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS US'];
        Account tempParentKIS_US_2 = [SELECT Id, Sales_Owner__c,Support_Level__c FROM Account WHERE Name='Parent KIS US'];
        System.assertEquals(tempParentKIS_US_2.Sales_Owner__c, tempChildKIS_US_2.Sales_Owner__c);
        System.assertEquals(tempParentKIS_US_2.Support_Level__c, tempChildKIS_US_2.Support_Level__c); 
    }




    @isTest static void SalesOwners_SupportLevel_ParrentAccount_Test_KIS_CA()
    {
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='KeepItSafe US PLUS ePAY' LIMIT 1];
        List<User> user = [SELECT Id FROM User WHERE ProfileId=:profile[0].Id ORDER BY CreatedDate DESC LIMIT 3];

        Account accParentKIS_CA = new Account(Name='Parent KIS CA', RecordTypeId=RECORD_TYPE_KIS_CA_ID, Sales_Owner__c=user[0].Id, Phone ='123445', Support_Level__c ='Regular');
        insert accParentKIS_CA;
        Account tempParentKIS_CA = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS CA'];

        Account accChildKIS_CA = new Account(Name='Child KIS CA', RecordTypeId=RECORD_TYPE_KIS_US_ID, ParentId=tempParentKIS_CA.Id, Phone ='123445');
        insert accChildKIS_CA;
        Account tempChildKIS_CA = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS CA'];

        System.assertEquals(tempParentKIS_CA.Sales_Owner__c, tempChildKIS_CA.Sales_Owner__c);
        System.assertEquals(tempParentKIS_CA.Support_Level__c, tempChildKIS_CA.Support_Level__c);

        // Test for trigger update event - parent Account
        Account tempParentKIS_CA_3 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS CA'];
        tempParentKIS_CA_3.Sales_Owner__c = user[2].Id;
        tempParentKIS_CA_3.Support_Level__c = 'Silver';
        update tempParentKIS_CA_3;
        tempParentKIS_CA_3 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS CA'];
        Account tempChildKIS_CA_3 = [SELECT Id, Sales_Owner__c,Support_Level__c FROM Account WHERE Name='Child KIS CA'];
        System.assertEquals(tempParentKIS_CA_3.Sales_Owner__c, tempChildKIS_CA_3.Sales_Owner__c);
        System.assertEquals(tempParentKIS_CA_3.Support_Level__c, tempChildKIS_CA_3.Support_Level__c);
    }


    
    @isTest static void SalesOwners_SupportLevel_ChildAccount_Test_KIS_CA()
    {
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name='KeepItSafe US PLUS ePAY' LIMIT 1];
        List<User> user = [SELECT Id FROM User WHERE ProfileId=:profile[0].Id ORDER BY CreatedDate DESC LIMIT 3];

        Account accParentKIS_CA = new Account(Name='Parent KIS CA', RecordTypeId=RECORD_TYPE_KIS_CA_ID, Sales_Owner__c=user[0].Id, Phone ='123445', Support_Level__c ='Regular');
        insert accParentKIS_CA;
        Account tempParentKIS_CA = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS CA'];

        Account accChildKIS_CA = new Account(Name='Child KIS CA', RecordTypeId=RECORD_TYPE_KIS_CA_ID, ParentId=tempParentKIS_CA.Id, Phone ='123445');
        insert accChildKIS_CA;
        Account tempChildKIS_CA = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS CA'];

        System.assertEquals(tempParentKIS_CA.Sales_Owner__c, tempChildKIS_CA.Sales_Owner__c);
        System.assertEquals(tempParentKIS_CA.Support_Level__c, tempChildKIS_CA.Support_Level__c);

        // Test for trigger update event - child Account
        Account tempChildKIS_CA_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS CA'];
        tempChildKIS_CA_2.Sales_Owner__c = user[1].Id;
        tempChildKIS_CA_2.Support_Level__c = 'Gold';
        update tempChildKIS_CA_2;
        tempChildKIS_CA_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Child KIS CA'];
        Account tempParentKIS_CA_2 = [SELECT Id, Sales_Owner__c, Support_Level__c FROM Account WHERE Name='Parent KIS CA'];
        System.assertEquals(tempParentKIS_CA_2.Sales_Owner__c, tempChildKIS_CA_2.Sales_Owner__c);
        System.assertEquals(tempParentKIS_CA_2.Support_Level__c, tempChildKIS_CA_2.Support_Level__c); 

    }
*/

}