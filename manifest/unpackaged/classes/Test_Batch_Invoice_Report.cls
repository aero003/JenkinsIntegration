@isTest
class Test_Batch_Invoice_Report {
    
    @isTest 
    static void Test_Batch_On_Montly() {
		
        // Insert Account
    	Account a = new Account();
    	//a.Name = 'JONICA TEST';
		a.Name = 'asd';
        a.Corp_ID__c = '11233';
        a.Status__c = 'Qualified';
        a.Brand__c = 'Consensus';
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
    	orderItemList.Order_Quantity__c = 1;
        orderItemList.SBQQ__QuotedListPrice__c = 20;
    	orderItemList.Monthly_Billing_Date__c = Date.Today();
    	orderItemList.PricebookEntryId = standardPrice.Id;
    	insert orderItemList;
        
        ConsensusDefaults__c defaultValue = new ConsensusDefaults__c();
        defaultValue.Name ='Default Values';
        defaultValue.Line__c ='LINE';
        defaultValue.Accounting_Rule_Name__c = '';
        defaultValue.Conversion_Type__c = 'Corporate';
        defaultValue.Currency__c = 'USD';
        defaultValue.Future1__c = '00000';
        defaultValue.Future2__c = '000';
        defaultValue.Future3__c = '0000';
        defaultValue.Payment_Terms_New__c = 'Credit Card';
        defaultValue.Unit_of_Measure__c = 'EA';
        defaultValue.Segment1__c = '100';
        defaultValue.Segment2__c = '000';
        defaultValue.Segment3__c = '4100';
        defaultValue.Segment4__c = '180';
        defaultValue.Segment5__c = '000';
        defaultValue.Accounting_Rule_Name__c = 'Advance Invoice';        
        insert defaultValue; 

        Consensus_Invoice__c inv = new Consensus_Invoice__c();
        //inv.Name = 'Invoice';
        insert inv;
        
        Consensus_Invoice_Line_Item__c montlyInvoice = new Consensus_Invoice_Line_Item__c();      
		montlyInvoice.Consensus_Invoice__c  =  inv.Id;
		montlyInvoice.Account_Name__c = a.Name;
		montlyInvoice.Line__c = defaultValue.Line__c;
		montlyInvoice.Oracle_Invoice_ID__c = '';
		montlyInvoice.TRX_Date_Oracle_Bill__c = orderItemList.Monthly_Billing_Date__c;
		montlyInvoice.GL_Date_Oracle_Bill__c = orderItemList.Monthly_Billing_Date__c;
		montlyInvoice.Payment_Terms_New__c = defaultValue.Payment_Terms_New__c;
		montlyInvoice.Consensus_Amount_Breakdown__c = orderItemList.UnitPrice;
		montlyInvoice.Conversion_Type__c = defaultValue.Conversion_Type__c;
		montlyInvoice.Invoice_Description__c = orderItemList.Product2.Name;
		montlyInvoice.Conversion_Rate__c = '';
		montlyInvoice.Conversion_Date_Oracle_Bill__c = orderItemList.Monthly_Billing_Date__c;
		montlyInvoice.Currency__c = defaultValue.Currency__c;
		montlyInvoice.Consensus_Quantity__c = orderItemList.Order_Quantity__c;
		montlyInvoice.Unit_of_Measure__c = defaultValue.Unit_of_Measure__c;
		montlyInvoice.Consensus_Price__c = orderItemList.UnitPrice;
		montlyInvoice.Segment1__c = defaultValue.Segment1__c;
		montlyInvoice.Segment2__c = defaultValue.Segment2__c;
		montlyInvoice.Segment3__c = defaultValue.Segment3__c;
		montlyInvoice.Segment4__c = defaultValue.Segment4__c;
		montlyInvoice.Segment5__c = defaultValue.Segment5__c;
		montlyInvoice.Future1__c = defaultValue.Future1__c;
		montlyInvoice.Future2__c = defaultValue.Future2__c;
		montlyInvoice.Future3__c = defaultValue.Future3__c;
		montlyInvoice.Corp_ID__c = a.Corp_ID__c ;
		montlyInvoice.Accounting_Rule_Name__c = defaultValue.Accounting_Rule_Name__c;
        
        insert montlyInvoice;
        
        /**************************************************/
        /*
        List<AsyncApexJob> jobs = new List<AsyncApexJob>();
               
        //insert 10 jobs
        List<AsyncApexJob> jobInfo = [SELECT ApexClassId, CreatedDate, Id, JobType, NumberOfErrors, Status, ExtendedStatus, ApexClass.Name, TotalJobItems, CreatedBy.Email from AsyncApexJob WHERE Status = 'Failed' AND (ApexClass.Name = 'QueueableContractOrdersClient' OR ApexClass.Name = 'QueueableCalculatorService')];
        for (Integer i=0;i<10;i++) {
            jobs.add(new AsyncApexJob());
        }*/
            
        Test.startTest();
        Batch_Invoice_Report ena = new Batch_Invoice_Report();
        Id batchId = Database.executeBatch(ena);
        Test.stopTest();
    } 
    
}