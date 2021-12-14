@isTest
public class Test_Conensus_Billing_Stamp_Controller {

    @testSetup static void setup() {
        Account acc =  new Account();
        acc.name = 'Test Billing';
        acc.Corp_ID__c = '123456';
        insert acc;
        
        Opportunity opp = new Opportunity();
        //opp.IsClosed = TRUE;
        opp.Name = 'Test Opp';
        opp.StageName = '10% - Deferred';
        opp.CloseDate = Date.newInstance(2021, 12, 9);
        opp.AccountId = acc.Id;
        insert opp;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Account__c = acc.Id;
        quote.SBQQ__Ordered__c = TRUE;
        quote.SBQQ__Primary__c = TRUE;
        quote.SBQQ__Opportunity2__c = opp.Id;
        insert quote;
        
    }
    
    @isTest
    public static void isIDProofing() {
        Test.startTest();
        Account acc = [Select id,name from Account limit 1];
        ApexPages.StandardController var = new ApexPages.StandardController(acc);
        Conensus_Billing_Stamp_Controller billing = new Conensus_Billing_Stamp_Controller(var);
        billing.isIDProofing();
        Test.stopTest();
    }
    @isTest
    public static void Popups() {
        Test.startTest();
        Account acc = [Select id,name from Account limit 1];
        ApexPages.StandardController var = new ApexPages.StandardController(acc);
        Conensus_Billing_Stamp_Controller billing = new Conensus_Billing_Stamp_Controller(var);
        billing.showPopup();
        billing.closePopup();
        billing.boolValue();
        billing.billingStamp();
        Test.stopTest();
    }
}