@isTest
public class Batch_CreateIdProofOrder_TEST {
	@testSetup static void setup() {
        Account ac = new Account();
        ac.Name ='test Ac';
        insert ac;
        Opportunity op = new Opportunity();
        op.Name ='test op';
        op.StageName = 'Closed Won';
        op.CloseDate = date.today();
        op.Industry__c = 'Consulting';
        //op.CurrencyIsoCode = 'USD';
        op.AccountId = ac.Id;
        insert op;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__StartDate__c = date.today();
        quote.SBQQ__Primary__c = TRUE;
        quote.SBQQ__Account__c = ac.Id;
        quote.SBQQ__Opportunity2__c = op.Id;
        //quote.CurrencyIsoCode = 'USD';
        quote.IdProofed__c = TRUE;
        insert quote;
 
    }
    @isTest
    public static void method1() {
        Test.startTest();
        Database.executeBatch(new Batch_CreateIdProofOrder());
        Batch_CreateIdProofOrder_Scheduler upSch = new Batch_CreateIdProofOrder_Scheduler();
		system.schedule('Test status Check', '0 0 23 * * ?', upSch );
        Test.stopTest(); 
    }
}