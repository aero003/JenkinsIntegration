@isTest
public class ConsensusControllerTest {
    
    public static testmethod void InvoiceInsertOnOpportunity() {
        Consensus__c con = new Consensus__c();
        con.name = 'J2Address';
        con.Account_Name__c = 'A/C Name: j2 Cloud Services, Inc.';
        con.Account_Number__c = 'A/C Number: 720,049,163';
        con.Bank__c = 'Bank: Union Bank 1980 Saturn Street, Monterey Park, CA 91755';
        con.eFax__c = 'eFax: +1 (877) 895-7698  ';
        con.J2_Address__c = 'j2 Cloud Services, LLC';
        con.J2_State__c = 'Los Angeles CA 90051-6173';
        con.J2_Street__c ='P O Box 51873';
        con.J2TaxID__c = '51 - 0371142';
        con.Routing__c = 'Rounting #: 122,000,496';
        con.Swift_Code__c ='Swift Code: BOFCUS33MPK';
        con.Telephone__c ='Tel: +1 (844) 804-1234';
        insert con;
        
        Account acc = new Account();
        RecordType rta = [SELECT Id,Name FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Consensus: Account'];
        acc.RecordTypeId = rta.Id;
        acc.Name = 'TestAccount';
        acc.Industry = 'Educational Services';
        acc.Application_ID__c = '123456';
        acc.Payment_Method__c = 'Invoice';
        insert acc;
        
        Contact con1 = new Contact();
        RecordType rtc = [SELECT Id,Name FROM RecordType WHERE SObjectType = 'Contact' AND Name = 'Consensus: Contact'];
        con1.Accountid = acc.Id;
        con1.RecordTypeId = rtc.Id;
        con1.Firstname = 'Firstname';
        con1.lastname = 'Lastname';
        con1.Email = 'con@test.com';
        insert con1;
        
        Opportunity opp = new Opportunity();
        RecordType rto = [SELECT Id,Name FROM RecordType WHERE SObjectType = 'Opportunity' AND Name = 'Consensus: Opportunity'];
        opp.Name = 'TestOpp';
        opp.RecordTypeId = rto.Id;
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
        
        Test.StartTest(); 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        ConsensusController testConsensusController = new ConsensusController(sc);
        
        PageReference pageRef = Page.consensusTemplate;
        pageRef.getParameters().put('Id', String.valueOf(opp.Id));
        Test.setCurrentPage(pageRef);
        
        Test.StopTest();
    }
}