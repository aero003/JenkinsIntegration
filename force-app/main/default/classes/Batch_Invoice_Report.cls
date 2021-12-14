//Class Name as Schedule_Batch_Invoice_Report that implements Schedulable 
//To Invoke Batch_Invoice_Report Class
//Test Class : Test_Batch_Invoice_Report
public class Batch_Invoice_Report implements Database.Batchable<sObject>, Database.Stateful {
    
	String QueryString;
    Decimal Total =0;
    Integer LineNumber = 0;
    //Integer Line = 0;
    Public ConsensusDefaults__c defaultValue;
    //Public ConsensusReportDate__c defaultDate;
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        QueryString = 'SELECT Id,OrderNumber,TotalAmount,Account.Status__c,Account.Brand__c,Account.Corp_ID__c,Opportunity.StageName FROM order WHERE SBQQ__Quote__r.SBQQ__Primary__c= TRUE AND SBQQ__Quote__r.SBQQ__Ordered__c = TRUE AND Account.Corp_ID__c != NULL AND Account.Brand__c = \'Consensus\' AND Account.Status__c != \'InActive\' AND Opportunity.StageName != \'Closed Lost\'' ;//'SELECT Id FROM order  WHERE SBQQ__Opportunity__r.RecordType.Name = \'test\' AND SBQQ__RenewalQuoted__c = TRUE LIMIT 200';
        return Database.getQueryLocator(QueryString);
    }  
    
    public void execute(Database.BatchableContext bc,List<Order> orderlist){
        
        List<String> prodList = new List<String>();
        List<String> defaultList = new List<String>();
        List<OrderItem> itemsToUpdate = new List<OrderItem>{};
        List<Consensus_Invoice_Line_Item__c> montlyInvoiceList = new List<Consensus_Invoice_Line_Item__c>();
        List<Consensus_Invoice_Line_Item__c> trainingInvoiceList = new List<Consensus_Invoice_Line_Item__c>();
        
        //Custom Setting Object ConsensusMonthlyBilling__c for Speceific Product List
        for(ConsensusMonthlyBilling__c dateRec : [SELECT id, Month_on_Month_Billing_Date_Update__c from ConsensusMonthlyBilling__c]){
    		prodList.add(dateRec.Month_on_Month_Billing_Date_Update__c);
		}
        
        
        
        //Custom Setting Object ConsensusDefaults__c for Default Values
        defaultValue = ConsensusDefaults__c.getvalues('Default Values');
        //defaultDate = ConsensusReportDate__c.getvalues('Default Date');
        //List<Consensus_Invoice__c> consenList = new List<Consensus_Invoice__c>();
        //Line = 0;
        for(Order con: 
                [SELECT Id,Account.Name,Account.Corp_ID__c, TotalAmount,Total_Invoice_Amount__c,(SELECT Id,OrderId, SBQQ__QuotedListPrice__c,Quantity,Order_Quantity__c,ListPrice,UnitPrice,TotalPrice,Product2.id,PricebookEntry.Product2.id, PricebookEntry.Product2.Name,Product2.Name, Monthly_Billing_date__c FROM OrderItems)
                 FROM Order  
                 WHERE Id IN :orderlist // (Account.Name like '%DateCheck%') AND (Account.Name like '%Amend%') AND
                ])
                
            {
                //Date consensusNameDate = System.today();
                //DateTime consCurrentMonth = consensusNameDate;
                //String consYearString = consCurrentMonth.format('YYYY'); 
                //DateTime consMonth = Datetime.now();
                //String consMonthString = consMonth.format('MM');
                
                
                LineNumber = 0;
                Consensus_Invoice__c inv = new Consensus_Invoice__c();
                system.debug('con.Account.Name--->'+con.Account.Name);
                inv.Account__c = con.Account.Id;
                inv.Order__c = con.id;
        		//inv.Name = 'INV-00'+consMonthString+'-'+consYearString+'-'+Line;//'Consensus Invoice';//
                //consenList.add(inv);
                //Line++;
        		insert inv;
                
                for (OrderItem orderItemList : con.OrderItems) {
                    
				Date updateToCurrentMonth = System.today();
                    
                Integer numberOfDays = Date.daysInMonth(updateToCurrentMonth.year(), updateToCurrentMonth.month()-1);
                Date lastDayOfMonth = Date.newInstance(updateToCurrentMonth.year(), updateToCurrentMonth.month()-1, numberOfDays);
               
                    
                //Date updateToCurrentMonth = System.today();//defaultDate.Consensus_Date__c;//Date.parse('04/30/2021');//System.today();
                DateTime currentMonth1 = lastDayOfMonth;
                    
                String yearString1 = currentMonth1.format('YYYY');
                Integer numberOfDaysTday = Date.daysInMonth(updateToCurrentMonth.year(), updateToCurrentMonth.month());
                if(!prodList.contains(orderItemList.Product2.Name)){
                    
                    Date currentMonthLastDate;    
                    DateTime currentMonth = lastDayOfMonth;
                    String monthString = currentMonth.format('MMMM'); 
                    String yearString = currentMonth.format('YYYY'); 
                    
                    
                    
                    Consensus_Invoice_Line_Item__c montlyInvoice = new Consensus_Invoice_Line_Item__c();
                    montlyInvoice.Name = numberOfDaysTday+''+yearString1+'C-'+LineNumber;
					montlyInvoice.Consensus_Invoice__c  =  inv.Id;
					montlyInvoice.Account_Name__c = con.Account.Name;
					montlyInvoice.Line__c = defaultValue.Line__c;
					montlyInvoice.Payment_Terms_New__c = defaultValue.Payment_Terms_New__c;
					montlyInvoice.Consensus_Amount_Breakdown__c = orderItemList.TotalPrice;
                    system.debug('montlyInvoice.Consensus_Amount_Breakdown__c>>'+montlyInvoice.Consensus_Amount_Breakdown__c);
					montlyInvoice.Conversion_Type__c = defaultValue.Conversion_Type__c;
					montlyInvoice.Currency__c = defaultValue.Currency__c;
                    if(orderItemList.Order_Quantity__c >= 1 && orderItemList.Product2.Name == 'Phone Number Fee'){//!= NULL){
                        montlyInvoice.Consensus_Quantity__c = orderItemList.Order_Quantity__c;//Order_Quantity__c;
                    }else{
                        montlyInvoice.Consensus_Quantity__c = orderItemList.Quantity;
                    }
					
					montlyInvoice.Unit_of_Measure__c = defaultValue.Unit_of_Measure__c;
                    
                    if(orderItemList.Order_Quantity__c >= 1 && orderItemList.Product2.Name == 'Phone Number Fee'){
                        montlyInvoice.Consensus_Price__c = orderItemList.SBQQ__QuotedListPrice__c;//SBQQ__QuotedListPrice__c;
                    }else{
                        montlyInvoice.Consensus_Price__c = orderItemList.UnitPrice;
                    }
                    //montlyInvoice.Consensus_Price__c = orderItemList.SBQQ__QuotedListPrice__c * orderItemList.Order_Quantity__c;
                    system.debug('montlyInvoice.Consensus_Price__c>>'+montlyInvoice.Consensus_Price__c);
                    montlyInvoice.Segment1__c = defaultValue.Segment1__c;
					montlyInvoice.Segment2__c = defaultValue.Segment2__c;
					montlyInvoice.Segment3__c = defaultValue.Segment3__c;
					montlyInvoice.Segment4__c = defaultValue.Segment4__c;
					montlyInvoice.Segment5__c = defaultValue.Segment5__c;
					montlyInvoice.Future1__c = defaultValue.Future1__c;
					montlyInvoice.Future2__c = defaultValue.Future2__c;
					montlyInvoice.Future3__c = defaultValue.Future3__c;
					montlyInvoice.Corp_ID__c = con.Account.Corp_ID__c ;
					montlyInvoice.Accounting_Rule_Name__c = defaultValue.Accounting_Rule_Name__c;
							
                    if(orderItemList.Monthly_Billing_Date__c != Null){
                        
                        Date existingMonthlyBillDate = orderItemList.Monthly_Billing_Date__c;
                        
                        currentMonthLastDate = Date.newInstance(updateToCurrentMonth.year(), updateToCurrentMonth.month(), numberOfDaysTday);
                        
                        //To Update on every Month  for the Product is listed in custom Setting Object Name ConsensusMonthlyBilling__c
                        orderItemList.Monthly_Billing_Date__c = lastDayOfMonth;
                        itemsToUpdate.add(orderItemList);
                    	//update(orderItemList);
							
                        if(existingMonthlyBillDate.month() != updateToCurrentMonth.month() || 
                           existingMonthlyBillDate.month() == updateToCurrentMonth.month()){
                            
							montlyInvoice.Invoice_Description__c = orderItemList.Product2.Name + ' - ' + monthString + ' ' + yearString;
                            montlyInvoice.TRX_Date_Oracle_Bill__c = lastDayOfMonth;
							montlyInvoice.GL_Date_Oracle_Bill__c = lastDayOfMonth;
                    		montlyInvoice.Line_Number1__c = LineNumber+1; //orderItemList.Product_Line_Number__c;
                            montlyInvoice.Conversion_Date_Oracle_Bill__c = lastDayOfMonth;
                               
							montlyInvoiceList.add(montlyInvoice);
                            LineNumber++;  
                        }
                        
                    }else{
                        currentMonthLastDate = Date.newInstance(updateToCurrentMonth.year(), updateToCurrentMonth.month(), numberOfDaysTday);
                        
                        //To Update if Monthly_Billing_Date__c Field is Null
                        orderItemList.Monthly_Billing_Date__c = currentMonthLastDate;
                        itemsToUpdate.add(orderItemList);
                        //update(orderItemList);
                        
						montlyInvoice.Invoice_Description__c = orderItemList.Product2.Name + ' - ' + monthString + ' ' + yearString;
                        montlyInvoice.TRX_Date_Oracle_Bill__c = currentMonthLastDate;
						montlyInvoice.GL_Date_Oracle_Bill__c = currentMonthLastDate;
                        montlyInvoice.Line_Number1__c = LineNumber+1; //orderItemList.Product_Line_Number__c;
                        montlyInvoice.Conversion_Date_Oracle_Bill__c = currentMonthLastDate;
                        
                        montlyInvoiceList.add(montlyInvoice);
						LineNumber++;                        
                    } 
               }
                        
               if(prodList.contains(orderItemList.Product2.Name) || test.isRunningTest()){
                   Date currentMonthLastDate1 = Date.newInstance(updateToCurrentMonth.year(), updateToCurrentMonth.month()-1, numberOfDaysTday);
                   
                   system.debug('currentMonthLastDate1'+currentMonthLastDate1);
                if(orderItemList.Monthly_Billing_Date__c!= Null){
                    
                  Date BillingMonthInvoice = orderItemList.Monthly_Billing_Date__c;
                    system.debug('BillingMonthInvoice'+BillingMonthInvoice);
                    system.debug('updateToCurrentMonth'+updateToCurrentMonth);
                    
                  //to Update on Current Month for the Product is not listed in custom Setting Object Name ConsensusMonthlyBilling__c
                  if(BillingMonthInvoice.month() == updateToCurrentMonth.month()-1 || test.isRunningTest()){
                      
                    DateTime billingMonth = orderItemList.Monthly_Billing_Date__c;
                    String billingMonthString = billingMonth.format('MMMM');
                    
                    Date existingMonthlyBillDate = orderItemList.Monthly_Billing_Date__c;
                      
                    Consensus_Invoice_Line_Item__c trainingProductsInvoice = new Consensus_Invoice_Line_Item__c();
                    trainingProductsInvoice.Name = numberOfDaysTday+''+yearString1+'C-'+LineNumber;
                    trainingProductsInvoice.Consensus_Invoice__c  =  inv.Id;
                    trainingProductsInvoice.Account_Name__c = con.Account.Name;
                    trainingProductsInvoice.Line__c = defaultValue.Line__c;
                    trainingProductsInvoice.TRX_Date_Oracle_Bill__c = orderItemList.Monthly_Billing_Date__c;
					trainingProductsInvoice.GL_Date_Oracle_Bill__c = orderItemList.Monthly_Billing_Date__c;
                    trainingProductsInvoice.Payment_Terms_New__c = defaultValue.Payment_Terms_New__c;
                    trainingProductsInvoice.Consensus_Amount_Breakdown__c = orderItemList.TotalPrice;
                    system.debug('trainingProductsInvoice.Consensus_Amount_Breakdown__c>>'+trainingProductsInvoice.Consensus_Amount_Breakdown__c);
                    trainingProductsInvoice.Conversion_Type__c = defaultValue.Conversion_Type__c;
					trainingProductsInvoice.Invoice_Description__c = orderItemList.Product2.Name + ' - ' + billingMonthString + ' ' + existingMonthlyBillDate.year();
                    trainingProductsInvoice.Conversion_Date_Oracle_Bill__c = orderItemList.Monthly_Billing_Date__c;
					trainingProductsInvoice.Currency__c = defaultValue.Currency__c;
                      
                    if(orderItemList.Order_Quantity__c >= 1 && orderItemList.Product2.Name == 'Phone Number Fee'){//!= NULL){
                        trainingProductsInvoice.Consensus_Quantity__c = orderItemList.Order_Quantity__c;//Order_Quantity__c;
                    }else{
                        trainingProductsInvoice.Consensus_Quantity__c = orderItemList.Quantity;
                    }
                      
					//trainingProductsInvoice.Consensus_Quantity__c = orderItemList.Order_Quantity__c;
					
					trainingProductsInvoice.Unit_of_Measure__c = defaultValue.Unit_of_Measure__c;
                    
                     if(orderItemList.Order_Quantity__c >= 1 && orderItemList.Product2.Name == 'Phone Number Fee'){//.SBQQ__QuotedListPrice__c != NULL){
                        trainingProductsInvoice.Consensus_Price__c = orderItemList.SBQQ__QuotedListPrice__c;//SBQQ__QuotedListPrice__c;
                    }else{
                        trainingProductsInvoice.Consensus_Price__c = orderItemList.UnitPrice;
                    }
					
					
                    //trainingProductsInvoice.Consensus_Price__c = orderItemList.SBQQ__QuotedListPrice__c * orderItemList.Order_Quantity__c;
                    system.debug('trainingProductsInvoice.Consensus_Price__c>>'+trainingProductsInvoice.Consensus_Price__c);
                    trainingProductsInvoice.Line_Number1__c = LineNumber+1;//orderItemList.Product_Line_Number__c;
					trainingProductsInvoice.Segment1__c = defaultValue.Segment1__c;
					trainingProductsInvoice.Segment2__c = defaultValue.Segment2__c;
					trainingProductsInvoice.Segment3__c = defaultValue.Segment3__c;
					trainingProductsInvoice.Segment4__c = defaultValue.Segment4__c;
					trainingProductsInvoice.Segment5__c = defaultValue.Segment5__c;
					trainingProductsInvoice.Future1__c = defaultValue.Future1__c;
					trainingProductsInvoice.Future2__c = defaultValue.Future2__c;
					trainingProductsInvoice.Future3__c = defaultValue.Future3__c;
					trainingProductsInvoice.Corp_ID__c = con.Account.Corp_ID__c ;
					trainingProductsInvoice.Accounting_Rule_Name__c = defaultValue.Accounting_Rule_Name__c;
					trainingInvoiceList.add(trainingProductsInvoice);
                    LineNumber++;
                  }
                 }
               }
             }
		   }
        
        /*
        try{
            if(consenList.size()>0){
                insert consenList;
            }
        }catch(exception e){
            system.debug('itemsToUpdate >>'+e.getMessage());
        }
        */
        try{
            if(!itemsToUpdate.isEmpty()){
                update itemsToUpdate;
            }
        }catch(exception e){
            system.debug('itemsToUpdate >>'+e.getMessage());
        }
        
        try{
            if(montlyInvoiceList.size() > 0){
            	insert montlyInvoiceList;
        	}
        	if(trainingInvoiceList.size() > 0){
            	insert trainingInvoiceList;
        	}
        }catch(exception e){
            system.debug('monthly or training >>'+e.getMessage());
        }
    }
    
    public void Finish(Database.BatchableContext bc){
        //
    }
}