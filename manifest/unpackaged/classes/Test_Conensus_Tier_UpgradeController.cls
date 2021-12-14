@isTest
public class Test_Conensus_Tier_UpgradeController {
    
    @testSetup static void setup() {
        Account acc =  new Account();
        acc.name = 'Test Billing';
        acc.Corp_ID__c = '123456';
        insert acc;
        
        Pricebook2 pb = new Pricebook2();
        pb.Name = 'Consensus Unite - Updated Pricebook';
        pb.IsActive = true ;
    	insert pb;
        
        Pricebook2 pb1 = new Pricebook2();
        pb1.Name = 'Consensus';
        pb1.IsActive = true ;
    	insert pb1;
        
		Product2 prod = new Product2();
        prod.Name = 'Unite';
        prod.ProductCode = 'Unite';
        prod.IsActive = true;
   		insert prod;
        
        PricebookEntry pbe=new PricebookEntry();
        pbe.unitprice=0.01;
        pbe.Product2Id=prod.Id;
        pbe.Pricebook2Id=Test.getStandardPricebookId();
        pbe.IsActive= true;
    	insert pbe;
        
        PricebookEntry pbe1=new PricebookEntry();
        pbe1.unitprice=0.01;
        pbe1.Product2Id=prod.Id;
        pbe1.Pricebook2Id=pb.Id;
        pbe1.IsActive= true;
    	insert pbe1;
        
        PricebookEntry pbe11=new PricebookEntry();
        pbe11.unitprice=0.01;
        pbe11.Product2Id=prod.Id;
        pbe11.Pricebook2Id=pb1.Id;
        pbe11.IsActive= true;
    	insert pbe11;
           
        Order od = new Order();
        od.AccountId = acc.Id;
        od.EffectiveDate = Date.newInstance(2021, 12, 9);
        od.Status = 'Draft';
        od.Pricebook2Id = pb.Id;
        insert od;
        
        Order od1 = new Order();
        od1.AccountId = acc.Id;
        od1.EffectiveDate = Date.newInstance(2021, 12, 9);
        od1.Status = 'Draft';
        od1.Pricebook2Id = pb1.Id;
        insert od1;
        system.debug('od1'+od1);
        OrderItem item =  new OrderItem();
        item.OrderId = od.Id;
        item.Order_Quantity__c = 28.8;
        item.Quantity = 54;
        item.UnitPrice = 2.0;
        item.PricebookEntryId = pbe1.Id;
        insert item; 
        
        OrderItem item1 =  new OrderItem();
        item1.OrderId = od1.Id;
        item1.Order_Quantity__c = 28.8;
        item1.Quantity = 54;
        item1.UnitPrice = 2.0;
        item1.PricebookEntryId = pbe11.Id;
        insert item1;   
        
    }
     @isTest
    public static void getselectedTierOption() {
        Test.startTest();
        Account acc = [Select id,name from Account limit 1];
        Product2 currentTier = [Select id,name,ProductCode from Product2 where ProductCode = 'Unite' limit 1];
        ApexPages.StandardController var = new ApexPages.StandardController(acc);
        Consensus_Tier_UpgradeController billing = new Consensus_Tier_UpgradeController(var);
        billing.getselectedTierOption();
        billing.actionSave();
        billing.getcurrentTier(); 
        billing.test();
        billing.setcurrentTier(currentTier.name);
        billing.getcurrentTier();
        billing.changeInputState();
        Test.stopTest();
    }
    @isTest
    public static void saveRecord() {
        //Test.startTest();
        Account acc = [Select id,name from Account WHERE Name='Test Billing'];
        Product2 currentTier = [Select id,name,ProductCode from Product2 where ProductCode = 'Unite' limit 1];
        ApexPages.StandardController var = new ApexPages.StandardController(acc);
        Consensus_Tier_UpgradeController billing = new Consensus_Tier_UpgradeController(var);
        billing.setcurrentTier(currentTier.name);
        billing.saveRecord();
        //Test.stopTest();
    }
}