@istest
private class OpportunityTriggerTest {    
    private static final Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId();
 //   private static final Id RECORD_TYPE_KIS_US = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeUS').getRecordTypeId();

 @isTest static void createAccountsWithOpps() { 
        // Create some test accounts
        String RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('KeepItSafeNL').getRecordTypeId();
        system.debug('RecordTypeId--->'+RecordTypeId);
        List<Account> listOfAccounts = new List<Account>();
        Account a = new account(Name='KeepItSafeNL test', RecordTypeId=RecordTypeId); 
        system.debug('a--------->'+a);
        Account a1 = new account(Name='KeepItSafeNL test1', RecordTypeId=RecordTypeId); 
        Account a2 = new account(Name='KeepItSafeNL test2', Send_Bill_To__c='Partner', RecordTypeId=RecordTypeId); 
        Account a3 = new account(Name='KeepItSafeNL test3', Send_Bill_To__c='Direct', RecordTypeId=RecordTypeId); 
        listOfAccounts.add(a);
        listOfAccounts.add(a1);
        listOfAccounts.add(a2);
        listOfAccounts.add(a3);
        try{
            insert listOfAccounts;
            system.debug(listOfAccounts[0]);
        }
        catch(exception e){
            system.debug('e--------->'+e.getMessage());
        }
        
        // Create some test opportunities
        List<Opportunity> listOfOpportunities = new List<Opportunity>();
        Opportunity opp = new Opportunity(Name='Portal - Online Backup - 25 GB',StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1), AccountId=a.Id); 
        Opportunity opp1 = new Opportunity(Name='Portal - Online Backup - 25 GBtest1',StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1), AccountId=a1.Id); 
        Opportunity opp2 = new Opportunity(Name='Portal - Online Backup - 25 GBtest2',StageName='Closed Won',
                                       CloseDate=System.today().addMonths(1), AccountId=a2.Id); 
        Opportunity opp3 = new Opportunity(Name='Portal - Online Backup - 25 GBtest3',StageName='Closed Won',
                                       CloseDate=System.today().addMonths(1), AccountId=a3.Id); 
        listOfOpportunities.add(opp);
        listOfOpportunities.add(opp1);
        listOfOpportunities.add(opp2);
        listOfOpportunities.add(opp3);
        try{
            insert listOfOpportunities; 
            system.debug('listOfOpportunities---------->'+listOfOpportunities);
        }
        catch(exception e){
            system.debug('exception'+e.getMessage());
        }
               
        
    }  
    
    @isTest static void OpportunityCaseTest_O365BU_and_Package_test()
    {
        Account acc = new Account(Name='Test Opp2323', RecordTypeId=RECORD_TYPE_KIS_NL_ID);
        insert acc;
        Account acc_queried = [SELECT Id FROM Account WHERE Name='Test Opp2323'];

        Opportunity opp = new Opportunity(Name='Portal - Online Backup - 25 GBtest23',StageName='Closed Won',
        CloseDate=System.today().addMonths(1), AccountId=acc_queried.Id, Service_Type__c = 'O365 BU', amount=200, O365_Mailbox_Sold__c='10'); 
        insert opp;

        Opportunity opp_queried = [SELECT Id, StageName, Package__c FROM Opportunity WHERE Name='Portal - Online Backup - 25 GBtest23'];
        System.assertEquals('Online Backup', opp_queried.Package__c, 'Incorrect package__c value on Opportunity');

        Case cs = [SELECT Id, Subject, Description FROM Case WHERE Opportunity__c=:opp_queried.Id];
        System.assertEquals('Veeam O365 BU Installation', cs.Subject, 'Subject field value on Case object incorrect.');
        System.assertEquals('O365 Mailbox sold: 10', cs.Description, 'Description field value on Case object incorrect.');

    }

    @isTest static void OpportunityCaseTest_VeeamBackup()
    {
        Account acc = new Account(Name='Test Opp2323', RecordTypeId=RECORD_TYPE_KIS_NL_ID);
        insert acc;
        Account acc_queried = [SELECT Id FROM Account WHERE Name='Test Opp2323'];

        Opportunity opp = new Opportunity(Name='Portal - Online Backup - 25 GBtest23',StageName='Closed Won',
        CloseDate=System.today().addMonths(1), AccountId=acc_queried.Id, 
        Service_Type__c = 'VCC Backup', 
        O365_Mailbox_Sold__c='10',
        of_VMs_needed__c=5, TB_Sold__c='8',Type_of_Environment__c='HyperV', amount=200, Zeus_Deal_RansomwareInsProtect__c=true); 
        insert opp;

        Opportunity opp_queried = [SELECT Id, StageName FROM Opportunity WHERE Name='Portal - Online Backup - 25 GBtest23'];
        
        Case cs = [SELECT Id, Subject, Description FROM Case WHERE Opportunity__c=:opp_queried.Id];
        System.assertEquals('Veeam Backup Installation', cs.Subject, 'Subject field value on Case object incorrect.');
        System.assertEquals('Number of VMs : 5\nTB Sold : 8\nType of environment : HyperV\nZeus Deal RansomwareInsProcect : true', cs.Description, 'Description field value on Case object incorrect.');

    }

    
    @isTest static void OpportunityCaseTest_VeeamReplication()
    {
        Account acc = new Account(Name='Test Opp2323', RecordTypeId=RECORD_TYPE_KIS_NL_ID);
        insert acc;
        Account acc_queried = [SELECT Id FROM Account WHERE Name='Test Opp2323'];

        Opportunity opp = new Opportunity(Name='Portal - Online Backup - 25 GBtest23',StageName='Closed Won',
        CloseDate=System.today().addMonths(1), AccountId=acc_queried.Id, 
        Service_Type__c = 'VCC Replication', 
        O365_Mailbox_Sold__c='10',
        amount=200,
        of_VMs_needed__c=5, TB_Sold__c='8',Type_of_Environment__c='HyperV',Zeus_Deal_RansomwareInsProtect__c=true); 
        insert opp;

        Opportunity opp_queried = [SELECT Id, StageName FROM Opportunity WHERE Name='Portal - Online Backup - 25 GBtest23'];

        Case cs = [SELECT Id, Subject, Description FROM Case WHERE Opportunity__c=:opp_queried.Id];
        System.assertEquals('Veeam Replication Installation', cs.Subject, 'Subject field value on Case object incorrect.');
        System.assertEquals('Number of VMs : 5\nTB Sold : 8\nType of environment : HyperV\nZeus Deal RansomwareInsProcect : true', cs.Description, 'Description field value on Case object incorrect.');

    }

    
    @isTest static void OpportunityCaseTest_VeeamLicences()
    {
        Account acc = new Account(Name='Test Opp2323', RecordTypeId=RECORD_TYPE_KIS_NL_ID);
        insert acc;
        Account acc_queried = [SELECT Id FROM Account WHERE Name='Test Opp2323'];

        Opportunity opp = new Opportunity(Name='Portal - Online Backup - 25 GBtest23',StageName='Closed Won',
        CloseDate=System.today().addMonths(1), AccountId=acc_queried.Id, 
        Service_Type__c= 'Veeam Licenses', 
        O365_Mailbox_Sold__c='10',
        amount=200,
        of_VMs_needed__c=5, TB_Sold__c='8',Type_of_Environment__c='HyperV',Zeus_Deal_RansomwareInsProtect__c=true); 
        insert opp;

        Opportunity opp_queried = [SELECT Id, StageName FROM Opportunity WHERE Name='Portal - Online Backup - 25 GBtest23'];
        
        Case cs = [SELECT Id, Subject, Description FROM Case WHERE Opportunity__c=:opp_queried.Id];
        System.assertEquals('Veeam Licenses Request', cs.Subject, 'Subject field value on Case object incorrect.');
        System.assertEquals('Number of VMs : 5\nType of environment : HyperV', cs.Description, 'Description field value on Case object incorrect.');

    }


    // This test covers LVProductAcc.triger
    @isTest static void AccountOpportunity_LVProductTest()
    {
        Account acc = new Account(Name='Test Live Vault Account',  
        Livevault_Product__c = 'Enterprise Backup (Classic)',
        RecordTypeId = Label.LiveVault_Acc_Rec_Type_Id);
        insert acc;
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Test Live Vault Account'];

        Opportunity opp = new Opportunity(Name='Portal - Online Backup - 25 GBtest23',StageName='Closed Won',
        CloseDate=System.today().addMonths(1), AccountId=acc_queried.Id, Service_Type__c= 'Veeam License - Instance', O365_Mailbox_Sold__c='10',
        of_VMs_needed__c=5, TB_Sold__c='8',Zeus_Deal_RansomwareInsProtect__c=true); 
        insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, StageName FROM Opportunity WHERE Name='Portal - Online Backup - 25 GBtest23'];
        
        Account OppoAccount =[Select Id, Name, RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals(OppoAccount.RecordTypeId, acc_queried.RecordTypeId, 'The Account  Record type does not mach with account record type on opporutnity');

        //Update Opportunity to triger 'update triger'

        Account acc2 = new Account(Name='Test Live Vault Account2',  
        Livevault_Product__c = 'Enterprise Backup (Classic)',
        RecordTypeId = Label.LiveVault_Acc_Rec_Type_Id);
        insert acc2;
        Account acc_queried2 = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Test Live Vault Account2'];

        // Update Opportunity and attach new account
        opp_queried.of_VMs_needed__c =10;
        opp_queried.AccountId=acc_queried2.Id;
        Update opp_queried;

        Opportunity opp_queried2 = [SELECT Id, accountId, StageName FROM Opportunity WHERE Name='Portal - Online Backup - 25 GBtest23'];

        Account OppoAccount2 =[Select Id, Name, RecordTypeId from Account where Id=: opp_queried2.accountId];

       
       //Update Triger after updated opporutnity 
       System.assertEquals(OppoAccount2.RecordTypeId, acc_queried2.RecordTypeId, 'The Account  Record type does not mach with account record type on opporutnity');
    }

    @isTest static void AccountOpportunity_Test_RapidRecoveryOffSite()
    {
        Account acc = new Account(Name='Account Test Rapid Recovery',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Rapid Recovery'];
    
        List<Opportunity> listOfOpportunities = new List<Opportunity>();
        Opportunity opp = new Opportunity(Name='Portal - Rapid Recovery - Offsite - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Rapid Recovery - Offsite - 25 GB'];

        Account OppoAccount =[Select Id, Name, Rapid_Recovery_Offsite__c, RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Rapid Recovery - Offsite', opp_queried.Package__c, 'The Opportuntiy Package does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Rapid_Recovery_Offsite__c, 'The Account Name does not match with opportunity product Name');

    }


    
    @isTest static void AccountOpportunity_Test_RapidRecoveryOnSite()
    {
        Account acc = new Account(Name='Account Test Rapid Recovery',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Rapid Recovery'];
    
        List<Opportunity> listOfOpportunities = new List<Opportunity>();
        Opportunity opp = new Opportunity(Name='Portal - Rapid Recovery - Onsite - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Rapid Recovery - Onsite - 25 GB'];

        Account OppoAccount =[Select Id, Name, Rapid_Recovery_Onsite__c, RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Rapid Recovery - Onsite', opp_queried.Package__c, 'The Opportuntiy Package name (Rapid Recovery - Onsite) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Rapid_Recovery_Onsite__c, 'The Account Product Name (Rapid Recovery - Onsite) does not match with opportunity product Name');

    }



    @isTest static void AccountOpportunity_Test_Mobile_KIS()
    {
        Account acc = new Account(Name='Account Test Mobile - KIS',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Mobile - KIS'];
    
        List<Opportunity> listOfOpportunities = new List<Opportunity>();
        Opportunity opp = new Opportunity(Name='Portal - Mobile - KIS - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Mobile - KIS - 25 GB'];

        Account OppoAccount =[Select Id, Name, Mobile_KIS__c, RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Mobile - KIS', opp_queried.Package__c, 'The Opportuntiy Product (Mobile - KIS) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Mobile_KIS__c, 'The Account Product Name (Mobile - KIS) does not match with opportunity product Name');

    }


    @isTest static void AccountOpportunity_Test_Workforce_KIS()
    {
        Account acc = new Account(Name='Account Test Workforce - KIS',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Workforce - KIS'];
    
        List<Opportunity> listOfOpportunities = new List<Opportunity>();
        Opportunity opp = new Opportunity(Name='Portal - Workforce - KIS - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Workforce - KIS - 25 GB'];

        Account OppoAccount =[Select Id, Name, Workforce_KIS__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Workforce - KIS', opp_queried.Package__c, 'The Opportuntiy Product (Workforce - KIS) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Workforce_KIS__c, 'The Account Product Name (Workforce - KIS) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_Reselling_Data_Backup_Equipment()
    {
        Account acc = new Account(Name='Account Test Reselling Data Backup Equipment',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Reselling Data Backup Equipment'];
    
        List<Opportunity> listOfOpportunities = new List<Opportunity>();
        Opportunity opp = new Opportunity(Name='Portal - Reselling Data Backup Equipment - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Reselling Data Backup Equipment - 25 GB'];

        Account OppoAccount =[Select Id, Name, Reselling_Data_Backup_Equipment__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Reselling Data Backup Equipment', opp_queried.Package__c, 'The Opportuntiy Product (Reselling Data Backup Equipment) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Reselling_Data_Backup_Equipment__c, 'The Account Product Name (Reselling Data Backup Equipment) does not match with opportunity product Name');

    }


    
    @isTest static void AccountOpportunity_Test_Enterprise_Hybrid_Backup_Onsite_KIS_Asigra()
    {
        Account acc = new Account(Name='Account Test Enterprise Hybrid Backup Onsite - KIS - Asigra',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Enterprise Hybrid Backup Onsite - KIS - Asigra'];
    
        Opportunity opp = new Opportunity(Name='Portal - Enterprise Hybrid Backup Onsite - KIS - Asigra - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Enterprise Hybrid Backup Onsite - KIS - Asigra - 25 GB'];

        Account OppoAccount =[Select Id, Name, Enterprise_Hybrid_Backup_Onsite_KIS__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Enterprise Hybrid Backup Onsite - KIS - Asigra', opp_queried.Package__c, 'The Opportuntiy Product (Enterprise Hybrid Backup Onsite - KIS - Asigra) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Enterprise_Hybrid_Backup_Onsite_KIS__c, 'The Account Product Name (Enterprise Hybrid Backup Onsite - KIS - Asigra) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_Server_Hosting()
    {
        Account acc = new Account(Name='Account Test Server Hosting',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Server Hosting'];
    
        Opportunity opp = new Opportunity(Name='Portal - Server Hosting - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Server Hosting - 25 GB'];

        Account OppoAccount =[Select Id, Name, Server_Hosting__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Server Hosting', opp_queried.Package__c, 'The Opportuntiy Product (Server Hosting) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Server_Hosting__c, 'The Account Product Name (Server Hosting) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_Colocation()
    {
        Account acc = new Account(Name='Account Test Colocation',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Colocation'];
    
        Opportunity opp = new Opportunity(Name='Portal - Colocation - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Colocation - 25 GB'];

        Account OppoAccount =[Select Id, Name, Colocation__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Colocation', opp_queried.Package__c, 'The Opportuntiy Product (Colocation) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Colocation__c, 'The Account Product Name (Colocation) does not match with opportunity product Name');

    }

    
    @isTest static void AccountOpportunity_Test_VCC_Backup()
    {
        Account acc = new Account(Name='Account Test VCC Backup',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test VCC Backup'];
    
        Opportunity opp = new Opportunity(Name='Portal - VCC Backup - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - VCC Backup - 25 GB'];

        Account OppoAccount =[Select Id, Name, VCC_Backup__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('VCC Backup', opp_queried.Package__c, 'The Opportuntiy Product (VCC Backup) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.VCC_Backup__c, 'The Account Product Name (VCC Backup) does not match with opportunity product Name');

    }


    @isTest static void AccountOpportunity_Test_Veeam_Cloud_Tier()
    {
        Account acc = new Account(Name='Account Test Veeam Cloud Tier',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Veeam Cloud Tier'];
    
        Opportunity opp = new Opportunity(Name='Portal - Veeam Cloud Tier - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Veeam Cloud Tier - 25 GB'];

        Account OppoAccount =[Select Id, Name, Veeam_Cloud_Connect__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Veeam Cloud Tier', opp_queried.Package__c, 'The Opportuntiy Product (Veeam Cloud Tier) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Veeam_Cloud_Connect__c, 'The Account Product Name (Veeam Cloud Tier) does not match with opportunity product Name');

    }


    @isTest static void AccountOpportunity_Test_VCC_Replication()
    {
        Account acc = new Account(Name='Account Test VCC Replication',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test VCC Replication'];
    
        Opportunity opp = new Opportunity(Name='Portal - VCC Replication - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - VCC Replication - 25 GB'];

        Account OppoAccount =[Select Id, Name, VCC_Replication__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('VCC Replication', opp_queried.Package__c, 'The Opportuntiy Product (VCC Replication) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.VCC_Replication__c, 'The Account Product Name (VCC Replication) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_TSM_Cloud_Backup()
    {
        Account acc = new Account(Name='Account Test TSM Cloud Backup',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test TSM Cloud Backup'];
    
        Opportunity opp = new Opportunity(Name='Portal - TSM Cloud Backup - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - TSM Cloud Backup - 25 GB'];

        Account OppoAccount =[Select Id, Name, TSM_Cloud_Backup__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('TSM Cloud Backup', opp_queried.Package__c, 'The Opportuntiy Product (TSM Cloud Backup) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.TSM_Cloud_Backup__c, 'The Account Product Name (TSM Cloud Backup) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_Front_Server()
    {
        Account acc = new Account(Name='Account Test Front-Server',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Front-Server'];
    
        Opportunity opp = new Opportunity(Name='Portal - Front-Server - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Front-Server - 25 GB'];

        Account OppoAccount =[Select Id, Name, Front_Server__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Front-Server', opp_queried.Package__c, 'The Opportuntiy Product (Front-Server) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Front_Server__c, 'The Account Product Name (Front-Server) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_eVault()
    {
        Account acc = new Account(Name='Account Test eVault',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test eVault'];
    
        Opportunity opp = new Opportunity(Name='Portal - eVault - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - eVault - 25 GB'];

        Account OppoAccount =[Select Id, Name, eVault__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('eVault', opp_queried.Package__c, 'The Opportuntiy Product (eVault) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.eVault__c, 'The Account Product Name (eVault) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_Send2Cloud()
    {
        Account acc = new Account(Name='Account Test Send2Cloud',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Send2Cloud'];
    
        Opportunity opp = new Opportunity(Name='Portal - Send2Cloud - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Send2Cloud - 25 GB'];

        Account OppoAccount =[Select Id, Name, Send2Cloud__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Send2Cloud', opp_queried.Package__c, 'The Opportuntiy Product (Send2Cloud) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Send2Cloud__c, 'The Account Product Name (Send2Cloud) does not match with opportunity product Name');

    }


    
    @isTest static void AccountOpportunity_Test_Ahsay_Whitelabel()
    {
        Account acc = new Account(Name='Account Test Ahsay - Whitelabel',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Ahsay - Whitelabel'];
    
        Opportunity opp = new Opportunity(Name='Portal - Ahsay - Whitelabel - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Ahsay - Whitelabel - 25 GB'];

        Account OppoAccount =[Select Id, Name, Ahsay_Whitelabel__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Ahsay - Whitelabel', opp_queried.Package__c, 'The Opportuntiy Product (Ahsay - Whitelabel) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Ahsay_Whitelabel__c, 'The Account Product Name (Ahsay - Whitelabel) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_Ahsay_2nd_Level_Support()
    {
        Account acc = new Account(Name='Account Test Ahsay - 2nd Level Support',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Ahsay - 2nd Level Support'];
    
        Opportunity opp = new Opportunity(Name='Portal - Ahsay - 2nd Level Support - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Ahsay - 2nd Level Support - 25 GB'];

        Account OppoAccount =[Select Id, Name, Ahsay_2nd_Level_Support__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Ahsay - 2nd Level Support', opp_queried.Package__c, 'The Opportuntiy Product (Ahsay - 2nd Level Support) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Ahsay_2nd_Level_Support__c, 'The Account Product Name (Ahsay - 2nd Level Support) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_O365_BU()
    {
        Account acc = new Account(Name='Account Test O365 BU',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test O365 BU'];
    
        Opportunity opp = new Opportunity(Name='Portal - O365 BU - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - O365 BU - 25 GB'];

        Account OppoAccount =[Select Id, Name, O365_BU__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('O365 BU', opp_queried.Package__c, 'The Opportuntiy Product (O365 BU) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.O365_BU__c, 'The Account Product Name (O365 BU) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_Ransomware_and_Insider_Protection()
    {
        Account acc = new Account(Name='Account Test Ransomware and Insider Protection',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Ransomware and Insider Protection'];
    
        Opportunity opp = new Opportunity(Name='Portal - Ransomware and Insider Protection - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Ransomware and Insider Protection - 25 GB'];

        Account OppoAccount =[Select Id, Name, Ransomware_and_Insider_Protection__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Ransomware and Insider Protection', opp_queried.Package__c, 'The Opportuntiy Product (Ransomware and Insider Protection) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Ransomware_and_Insider_Protection__c, 'The Account Product Name (Ransomware and Insider Protection) does not match with opportunity product Name');

    }


    @isTest static void AccountOpportunity_Test_Managed_Availability_Service()
    {
        Account acc = new Account(Name='Account Test Managed Availability Service',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Managed Availability Service'];
    
        Opportunity opp = new Opportunity(Name='Portal - Managed Availability Service - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Managed Availability Service - 25 GB'];

        Account OppoAccount =[Select Id, Name, Managed_Availability_Service__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Managed Availability Service', opp_queried.Package__c, 'The Opportuntiy Product (Managed Availability Service) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Managed_Availability_Service__c, 'The Account Product Name (Managed Availability Service) does not match with opportunity product Name');

    }

    
    @isTest static void AccountOpportunity_Test_Veeam_Licence_Perpetual()
    {
        Account acc = new Account(Name='Account Test Veeam License - Perpetual',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Veeam License - Perpetual'];
    
        Opportunity opp = new Opportunity(Name='Portal - Veeam License - Perpetual - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Veeam License - Perpetual - 25 GB'];

        Account OppoAccount =[Select Id, Name, /*Veeam_License_Perpetual__c , */ RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Veeam License - Perpetual', opp_queried.Package__c, 'The Opportuntiy Product (Veeam License - Perpetual) does nots not match with Product Name ');
       // System.assertEquals(TRUE, OppoAccount.Veeam_License_Perpetual__c, 'The Account Product Name (Veeam License - Perpetual) does not match with opportunity product Name');

    }


    @isTest static void AccountOpportunity_Test_Veeam_Licence_Rental()
    {
        Account acc = new Account(Name='Account Test Veeam License - Rental',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Veeam License - Rental'];
    
        Opportunity opp = new Opportunity(Name='Portal - Veeam License - Rental - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Veeam License - Rental - 25 GB'];

        Account OppoAccount =[Select Id, Name,/* Veeam_License_Rental__c ,*/ RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Veeam License - Rental', opp_queried.Package__c, 'The Opportuntiy Product (Veeam License - Rental) does nots not match with Product Name ');
     //   System.assertEquals(TRUE, OppoAccount.Veeam_License_Rental__c, 'The Account Product Name (Veeam License - Rental) does not match with opportunity product Name');

    }

    @isTest static void AccountOpportunity_Test_Veeam_Licence_Instance()
    {
        Account acc = new Account(Name='Account Test Veeam License - Instance',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Veeam License - Instance'];
    
        Opportunity opp = new Opportunity(Name='Portal - Veeam License - Instance - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Veeam License - Instance - 25 GB'];

        Account OppoAccount =[Select Id, Name,/* Veeam_License_Instance__c ,*/ RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Veeam License - Instance', opp_queried.Package__c, 'The Opportuntiy Product (Veeam License - Instance) does nots not match with Product Name ');
      //  System.assertEquals(TRUE, OppoAccount.Veeam_License_Instance__c, 'The Account Product Name (Veeam License - Instance) does not match with opportunity product Name');

    }


    
    @isTest static void AccountOpportunity_Test_Zerto_Replication()
    {
        Account acc = new Account(Name='Account Test Zerto Replication',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Zerto Replication'];
    
        Opportunity opp = new Opportunity(Name='Portal - Zerto Replication - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Zerto Replication - 25 GB'];

        Account OppoAccount =[Select Id, Name, Zerto_Replication__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Zerto Replication', opp_queried.Package__c, 'The Opportuntiy Product (Zerto Replication) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Zerto_Replication__c, 'The Account Product Name (Zerto Replication) does not match with opportunity product Name');

    }

        
    @isTest static void AccountOpportunity_Test_Iaas()
    {
        Account acc = new Account(Name='Account Test Iaas',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Iaas'];
    
        Opportunity opp = new Opportunity(Name='Portal - Iaas - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Iaas - 25 GB'];

        Account OppoAccount =[Select Id, Name, Iaas__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Iaas', opp_queried.Package__c, 'The Opportuntiy Product (Iaas) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Iaas__c, 'The Account Product Name (Iaas) does not match with opportunity product Name');

    }


    @isTest static void AccountOpportunity_Test_Archival_Storage()
    {
        Account acc = new Account(Name='Account Test Archival Storage',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Archival Storage'];
    
        Opportunity opp = new Opportunity(Name='Portal - Archival Storage - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Archival Storage - 25 GB'];

        Account OppoAccount =[Select Id, Name, Archival_Storage__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Archival Storage', opp_queried.Package__c, 'The Opportuntiy Product (Archival Storage) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Archival_Storage__c, 'The Account Product Name (Archival Storage) does not match with opportunity product Name');

    }

    
    @isTest static void AccountOpportunity_Test_Asigra()
    {
        Account acc = new Account(Name='Account Test Asigra',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Asigra'];
    
        Opportunity opp = new Opportunity(Name='Portal - Asigra - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Asigra - 25 GB'];

        Account OppoAccount =[Select Id, Name, Asigra__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Asigra', opp_queried.Package__c, 'The Opportuntiy Product (Asigra) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Asigra__c, 'The Account Product Name (Asigra) does not match with opportunity product Name');

    }


    @isTest static void AccountOpportunity_Test_Ahsay_Online_Backup()
    {
        Account acc = new Account(Name='Account Test Ahsay - Online Backup',  
        RecordTypeId = RECORD_TYPE_KIS_NL_ID);
       
        insert acc;
        
        Account acc_queried = [SELECT Id, RecordTypeId,Livevault_Product__c FROM Account WHERE Name='Account Test Ahsay - Online Backup'];
    
        Opportunity opp = new Opportunity(Name='Portal - Ahsay - Online Backup - 25 GB',
        StageName='Prospecting',
        CloseDate=System.today().addMonths(1),
        AccountId=acc_queried.Id); 
       
        Insert opp;

        Opportunity opp_queried = [SELECT Id, accountId, Package__c, StageName FROM Opportunity WHERE Name='Portal - Ahsay - Online Backup - 25 GB'];

        Account OppoAccount =[Select Id, Name, Ahsay_Online_Backup__c , RecordTypeId from Account where Id=: opp_queried.accountId];

        System.assertEquals('Ahsay - Online Backup', opp_queried.Package__c, 'The Opportuntiy Product (Ahsay - Online Backup) does nots not match with Product Name ');
        System.assertEquals(TRUE, OppoAccount.Ahsay_Online_Backup__c, 'The Account Product Name (Ahsay - Online Backup) does not match with opportunity product Name');

    }


}