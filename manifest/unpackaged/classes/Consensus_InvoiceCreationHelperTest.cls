@isTest(SeeAllData=false)
public class Consensus_InvoiceCreationHelperTest {
    
    @isTest
    public static void InvoiceInsertOnOpportunity() {
        
        ConsensusDescriptions__c cs = new ConsensusDescriptions__c();
        cs.Name ='Invoice description';
        cs.Tier_and_Price__c = 'Tier and Price';
        cs.Locations_and_Site_Licenses__c = 'Locations and Site Licenses';
        cs.Phone_Number_Fee__c = 'Phone Number Fee';
        cs.Admin_Training_Fee__c = 'Admin Training Fee';
        cs.User_Training_Fee__c = 'User Training Fee';
        cs.Professional_Service_Fee__c = 'Professional Service Fee';
        insert cs;  
        
        Account acc = new Account();
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Consensus: Account'];
        acc.RecordTypeId = rt.Id;
        acc.Name = 'TestAccount';
        acc.Industry = 'Educational Services';
        acc.Application_ID__c = '123456';
        acc.Corp_ID__c = 'test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        RecordType rto = [SELECT Id,Name FROM RecordType WHERE SObjectType = 'Opportunity' AND Name = 'Consensus: Opportunity'];
        opp.RecordTypeId = rto.Id;
        opp.Name = 'TestOpp';
        opp.AccountId = acc.Id;
        opp.Industry__c = 'Education';
        opp.StageName = '10% - Deferred';
        opp.Probability = 10;
        opp.CloseDate = System.today();
        opp.Tier__c = 'Tier4 -- $679';
        opp.Locations__c = 5;
        opp.Site_License__c = 5;
        opp.Phone_Number_Fee__c = 5;
        opp.Phone_Number_Lines__c = 2;
        insert opp;
        
        Test.startTest();
        opp.StageName = 'Closed Won';
        opp.Probability = 100;
        update opp;
        Test.stopTest();
    }
    
    @isTest
    public static void DirectClosedWonOppAndInsertOpportunity() {
        
        ConsensusDescriptions__c cs = new ConsensusDescriptions__c();
        cs.Name ='Invoice description';
        cs.Tier_and_Price__c = 'Tier and Price';
        cs.Locations_and_Site_Licenses__c = 'Locations and Site Licenses';
        cs.Phone_Number_Fee__c = 'Phone Number Fee';
        cs.Admin_Training_Fee__c = 'Admin Training Fee';
        cs.User_Training_Fee__c = 'User Training Fee';
        cs.Professional_Service_Fee__c = 'Professional Service Fee';
        insert cs; 
        
        Account acc = new Account();
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Consensus: Account'];
        acc.RecordTypeId = rt.Id;
        acc.Name = 'TestAccount';
        acc.Industry = 'Educational Services';
        acc.Application_ID__c = '123456';
        acc.Corp_ID__c = 'test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'TestOpp';
        RecordType rt1 = [SELECT Id,Name FROM RecordType WHERE SObjectType = 'Opportunity' AND Name = 'Consensus: Opportunity'];
        opp.RecordTypeId = rt1.Id;
        opp.AccountId = acc.Id;
        opp.Industry__c = 'Education';
        opp.StageName = 'Closed Won';
        opp.Probability = 100;
        opp.CloseDate = System.today();
        opp.Tier__c = 'Tier4 -- $679';
        opp.Locations__c = 5;
        opp.Site_License__c = 5;
        opp.Phone_Number_Fee__c = 5;
        opp.Phone_Number_Lines__c = 2;
        
        Test.startTest();
        insert opp;
        opp.Locations__c = 10;
        update opp;
        Test.stopTest();
    }
}