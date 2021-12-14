@isTest
class Test_Montly_Billing_date {
    
    @isTest 
    static void Test_Batch_On_Montly() {
	/*	
        // Insert Account
    	Account a = new Account();
    	a.Name = 'Test Account';
    	insert a;
        
    	// Insert Product
    	Product2 p = new Product2();
    	p.Name = ' Test Product ';
    	p.Description='Test Product Entry 1';
    	p.productCode = 'ABC';
    	p.isActive = true;
    	insert p;
    	
        // PricebookID;
    	Id pricebookId = Test.getStandardPricebookId();
        
        // RecordType ID;
        Id rtID=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Consensus: Opportunity').getRecordTypeId();
        
        // Insert PricebookEntry
    	PricebookEntry standardPrice = new PricebookEntry();
    	standardPrice.Pricebook2Id = pricebookId;
    	standardPrice.Product2Id = p.Id;
    	standardPrice.UnitPrice = 1;
    	standardPrice.IsActive = true;
    	standardPrice.UseStandardPrice = false;
    	insert standardPrice ;
        
        // Insert Opportunity
        Opportunity opp=new Opportunity();
		opp.Name='opl';
		opp.RecordtypeId=rtID;
		opp.Probability=99;
		opp.StageName='Stage 2 - Qualified';
		opp.CloseDate=Date.today();
        opp.Locations__c=1;
        opp.Site_License__c = 10;
        opp.Phone_Number_Fee__c = 10;
        opp.Phone_Number_Lines__c = 1;
        opp.Industry__c = 'Other';
		insert opp;
        
        // Insert CPQ Quote
        SBQQ__Quote__c quoteList = new SBQQ__Quote__c();
        quoteList.SBQQ__Primary__c = true;
        quoteList.SBQQ__Ordered__c = true;
        quoteList.SBQQ__Opportunity2__c = opp.Id;
    	insert quotelist;
        
        // Insert Custom Setting Object ConsensusMonthlyBilling__c
     	ConsensusMonthlyBilling__c montly = new ConsensusMonthlyBilling__c();
        montly.Name='Phone Number';
        montly.Month_on_Month_Billing_Date_Update__c= 'Phone Number Fee';
        insert montly;   
    
        // Insert Order
        Order o = new Order();
    	o.Name = 'Test Order ';
    	o.Status = 'Draft';
    	o.EffectiveDate = system.today();
    	o.EndDate = system.today() + 4;
    	o.AccountId = a.id;
    	o.SBQQ__Quote__c = quotelist.Id;
    	o.Pricebook2Id =  pricebookId ;
     	insert o;
   		
        // Insert OrderItems
    	OrderItem orderItemList = new OrderItem();
    	orderItemList.OrderId = o.Id;
    	orderItemList.Product2Id = p.Id;
    	orderItemList.UnitPrice = 1;
    	orderItemList.Quantity = 1;
    	orderItemList.Monthly_Billing_Date__c = Date.Today();
    	orderItemList.PricebookEntryId = standardPrice.Id;
    	insert orderItemList;

        
        List<AsyncApexJob> jobs = new List<AsyncApexJob>();
               
        //insert 10 jobs
        List<AsyncApexJob> jobInfo = [SELECT ApexClassId, CreatedDate, Id, JobType, NumberOfErrors, Status, ExtendedStatus, ApexClass.Name, TotalJobItems, CreatedBy.Email from AsyncApexJob WHERE Status = 'Failed' AND (ApexClass.Name = 'QueueableContractOrdersClient' OR ApexClass.Name = 'QueueableCalculatorService')];
        for (Integer i=0;i<10;i++) {
            jobs.add(new AsyncApexJob());
        }
            
        Test.startTest();
        Batch_Montly_Billing_Date ena = new Batch_Montly_Billing_Date();
        Id batchId = Database.executeBatch(ena);
        Test.stopTest();
        */
    } 
}