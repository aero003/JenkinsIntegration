//Class Name as Schedule_Montly_Billing_Date that implements Schedulable 
//To Invoke Batch_Montly_Billing_Date Class
//Test Class : Test_Batch_Montly_Billing_Date
public class Batch_Montly_Billing_Date implements Database.Batchable<sObject>, Database.Stateful {
    
	String QueryString;
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        QueryString = 'SELECT Id,OrderNumber FROM order Where SBQQ__Quote__r.SBQQ__Primary__c= true and SBQQ__Quote__r.SBQQ__Ordered__c = true' ;//'SELECT Id FROM order  WHERE SBQQ__Opportunity__r.RecordType.Name = \'Informatics\' AND SBQQ__RenewalQuoted__c = TRUE LIMIT 200';
        return Database.getQueryLocator(QueryString);
    }  
    
    public void execute(Database.BatchableContext bc,List<Order> orderlist){
        
        List<String> prodList = new List<String>();
        //Custom Setting Object ConsensusMonthlyBilling__c for Speceific Product List
        for(ConsensusMonthlyBilling__c dateRec : [SELECT id, Month_on_Month_Billing_Date_Update__c from ConsensusMonthlyBilling__c]){
    		prodList.add(dateRec.Month_on_Month_Billing_Date_Update__c);
		}
        
        for(Order con:
                [SELECT Id, (SELECT Id,OrderId, Product2.id,PricebookEntry.Product2.id, PricebookEntry.Product2.Name,Product2.Name, Monthly_Billing_date__c FROM OrderItems)
                 FROM Order  
                 WHERE Id in :orderlist
                ])
                
            {
                
                for (OrderItem orderItemList : con.OrderItems) {
                    
                 if(!prodList.contains(orderItemList.Product2.Name)){
                    Date currentMonthLastDate;    
                    Date updateToCurrentMonth = System.today();
                    Integer numberOfDaysTday = Date.daysInMonth(updateToCurrentMonth.year(), updateToCurrentMonth.month());
                     
                    if(orderItemList.Monthly_Billing_Date__c != Null){
                        
                        Date existingMonthlyBillDate = orderItemList.Monthly_Billing_Date__c;
						//Integer numberOfDays = Date.daysInMonth(existingMonthlyBillDate.year(), existingMonthlyBillDate.month());
                        
                        if(existingMonthlyBillDate.month() != updateToCurrentMonth.month()){
                                 
                         	currentMonthLastDate = Date.newInstance(updateToCurrentMonth.year(), updateToCurrentMonth.month(), numberOfDaysTday);
                            //To Update Monthly_Billing_Date__c on every Month to End Date
                            orderItemList.Monthly_Billing_Date__c = currentMonthLastDate;
                            update(orderItemList);
                            
                        }
                        
                    }else{
                        currentMonthLastDate = Date.newInstance(updateToCurrentMonth.year(), updateToCurrentMonth.month(), numberOfDaysTday);
                        //To Update if Monthly_Billing_Date__c Field is Null to current Month End Date
                        orderItemList.Monthly_Billing_Date__c = currentMonthLastDate;
                        update(orderItemList);
                    }
                     
               }
             }
		   }
    }
    
    public void Finish(Database.BatchableContext bc){
        //
    }
}