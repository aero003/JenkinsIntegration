public class Conensus_Tier_UpgradeController {
        
    public String AccountID = '';
    public List<SelectOption> options {get;set;}
    public Boolean disableInput {get; set;}
    public String currentProduct {get; set;}
    
    public Conensus_Tier_UpgradeController(ApexPages.StandardController controller) {
        disableInput = true;
        Account record = (Account) controller.getRecord();
        AccountID = record.Id;
        
        List<Order> currentTierProduct = [SELECT Id, Account.Id, (SELECT Id, OrderId,Quantity,Order_Quantity__c, Product2.Name FROM OrderItems) from Order where Account.Id =: AccountID];
        for(Order con: currentTierProduct){
            for (OrderItem orderItemList : con.OrderItems) {
				currentProduct = orderItemList.Product2.Name;  
            }
        }
    }
    String currentTierProduct = null;
    String currentTier = null;
         
    public PageReference test() {
        return null;
    }

public PageReference actionSave()
{
           
    return null;
}
    Public List<Selectoption> getselectedTierOption(){
        List<Selectoption> options = new List<selectoption>();
        String Unite100 = 'Unite 100';
        String Unite300 = 'Unite 300';
        String Unite500 = 'Unite 500';
        String Unite1000 = 'Unite 1,000';
        String Unite2000 = 'Unite 2,000';
        String Unite3500 = 'Unite 3,500';
        String Unite6000 = 'Unite 6,000';
        String Unite10000 = 'Unite 10,000';
        
        if(currentProduct != Unite100){
            options.add(new SelectOption(Unite100,Unite100)); 
        }
        if(currentProduct != Unite300){
            options.add(new SelectOption(Unite300,Unite300)); 
        }
        if(currentProduct != Unite500){
            options.add(new SelectOption(Unite500,Unite500)); 
        }
        if(currentProduct != Unite1000){
            options.add(new SelectOption(Unite1000,Unite1000)); 
        }
        if(currentProduct != Unite2000){
            options.add(new SelectOption(Unite2000,Unite2000)); 
        }
        if(currentProduct != Unite3500){
            options.add(new SelectOption(Unite3500,Unite3500)); 
        }
        if(currentProduct != Unite6000){
            options.add(new SelectOption(Unite6000,Unite6000)); 
        }
        if(currentProduct != Unite10000){
            options.add(new SelectOption(Unite10000,Unite10000)); 
        }
     return options; 
    }
    
    public String getcurrentTier() {
        System.debug('currentTier'+currentTier);
        return currentTier;
    }
                    
    public void setcurrentTier(String currentTier) {
        this.currentTier = currentTier; 
        system.debug('currentTier -->'+currentTier);
    }
    
    public PageReference saveRecord() {
        Date currentMonthLastDate;  
        Date updateToCurrentMonth = System.today();
        /*Integer numberOfDaysTday = Date.daysInMonth(updateToCurrentMonth.year(), updateToCurrentMonth.month());
        Date currentMonthLastDate2 = Date.newInstance(updateToCurrentMonth.year(), updateToCurrentMonth.month(), numberOfDaysTday);
        system.debug('currentMonthLastDate2-->'+currentMonthLastDate2);*/
        currentMonthLastDate = updateToCurrentMonth.addMonths(1).toStartofMonth().addDays(-1);
        system.debug('currentMonthLastDate--> '+currentMonthLastDate);
        Date monthlyBillingDate =  date.newinstance(currentMonthLastDate.year(), currentMonthLastDate.month(), currentMonthLastDate.day());
        system.debug('monthlyBillingDate -->'+monthlyBillingDate);
        
        system.debug('currentTier -->'+currentTier);
        String consensusPriceBookID = [SELECT Id,name FROM Pricebook2 WHERE IsStandard = False AND Name = 'Consensus Unite - Updated Pricebook'].Id;
        system.debug('consensusPriceBookID '+consensusPriceBookID);
        if(Test.isRunningTest()){
            String currentTierProductCode = 'Aastra04';
        }
        String currentTierProductCode = [SELECT Name,ProductCode FROM Product2 WHERE Name =:currentTier].ProductCode;
        system.debug('currentTierProductCode '+currentTierProductCode);
        
        List<PricebookEntry> consensusProducts = new List<PricebookEntry>([SELECT Id,productCode,unitPrice,Pricebook2Id FROM PricebookEntry where Pricebook2Id =: consensusPriceBookID AND productCode =: currentTierProductCode]);
        String currentProductName = '';
        Decimal currentProductQuantity = 0;
        //Decimal TotalPriceValue = 0;
		String orderIdValue = '';        
        System.debug('saveCCC '+currentTier);
        List<Order> currentTierData = [SELECT Id, Account.Id, (SELECT Id, OrderId,Quantity,Order_Quantity__c, Product2.Name FROM OrderItems) from Order where Account.Id =: AccountID];
        //OrderItem deleteCurrentTier = new OrderItem();
        OrderItem upgradingTier = new OrderItem(); 
       /* for(Order con: currentTierData){
            for (OrderItem orderItemList : con.OrderItems) {
				currentProductName = orderItemList.Product2.Name;                
                currentProductQuantity = orderItemList.Quantity;
                orderIdValue = con.Id;
                system.debug('orderItemList.Product2.Name '+orderItemList.Product2.Name);
                system.debug('currentTier..>> '+currentTier);
                if(!currentTier.contains(orderItemList.Product2.Name)){
                    system.debug('iffff '+currentTier);
                    deleteCurrentTier.Id = orderItemList.Id;
                }
               system.debug('deleteCurrentTier>>> '+deleteCurrentTier);
            }
        }*/
        system.debug('currentProduct-->'+currentProduct);
        system.debug('currentTier----->'+currentTier);
        //AD
        List<OrderItem> currentOrderItem = [SELECT Id,OrderId,Quantity,Order_Quantity__c, Product2.Name, Order.AccountId FROM OrderItem WHERE Order.AccountId =: AccountID];
		system.debug('currentOrderItem '+currentOrderItem);
        List<OrderItem> orderItemToDelete = new List<OrderItem>();
		for(OrderItem oi : currentOrderItem){
            System.Debug('Prod2 name : ' + oi.Product2.Name);
			if(oi.Product2.Name == currentProduct){
                system.debug('order item product name ->'+oi.Product2.Name);
				currentProductQuantity = oi.Quantity;
				orderIdValue = oi.OrderId;
				orderItemToDelete.add(oi);
			}
		}
		if(orderItemToDelete != NULL && !orderItemToDelete.isEmpty()){
			delete orderItemToDelete;
		}//end
        
        
        if(currentProductName != NULL){
             upgradingTier.PricebookEntryId = consensusPriceBookID;
             upgradingTier.Product2Id = consensusProducts[0].Id;
             upgradingTier.UnitPrice = consensusProducts[0].unitPrice;
             upgradingTier.Monthly_Billing_Date__c = monthlyBillingDate;
             upgradingTier.Quantity = currentProductQuantity;
             if(orderIdValue != '')
             {
                upgradingTier.OrderId = orderIdValue;
             }
             //upgradingTier.TotalPrice = TotalPriceValue;
             system.debug('upgradingTier>>> '+upgradingTier);
       }
        
        
       Insert upgradingTier;
        system.debug('inserted upgradingTier-->'+upgradingTier);
        
        /*if(deleteCurrentTier.Id != NULL){
          delete deleteCurrentTier;
        }*/
    String redirectId =  String.valueOf(orderIdValue).substring(0, 15);   
	PageReference pageref = new PageReference('/'+redirectId+'#'+redirectId+'_RelatedOrderItemList_target');
    pageref.setRedirect(true);
	return pageref;        
    }
    
    public void changeInputState(){
        disableInput = false;
    }
    
	}