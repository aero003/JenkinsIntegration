@isTest
public class Test_Scheduled_Invoice_Update 
{
    static testmethod void test() 
    {
        Test.startTest();

        Id RECORD_TYPE_KISNL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId(); 
    
        Map<Integer,String> nextMonthFieldMap = new Map<Integer,String>();
        nextMonthFieldMap.put(1,'February__c');
        nextMonthFieldMap.put(2,'March__c');
        nextMonthFieldMap.put(3,'April__c');
        nextMonthFieldMap.put(4,'May__c');
        nextMonthFieldMap.put(5,'June__c');
        nextMonthFieldMap.put(6,'July__c');
        nextMonthFieldMap.put(7,'August__c');
        nextMonthFieldMap.put(8,'September__c');
        nextMonthFieldMap.put(9,'October__c');
        nextMonthFieldMap.put(10,'November__c');
        nextMonthFieldMap.put(11,'December__c');
        nextMonthFieldMap.put(12,'January__c');

        Integer currentMonthNumber = Date.Today().Month();
        String nextMonth = nextMonthFieldMap.get(currentMonthNumber);
        List<Invoice__c> invoicesToUpdateBillingRunDate = new List<Invoice__c>();
       
        system.Debug('Current Month: '+ nextMonth );
        
        Datetime dt = Datetime.now().addMinutes(1);

        Account testAcc = new Account(Name = 'TestInvoiceSchedulerAccount', Status__c = 'Active', BillingCountry='NL',RecordTypeId = RECORD_TYPE_KISNL_ID,BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert testAcc;

        Account insertedAcc = [Select Id, Name from Account where name ='TestInvoiceSchedulerAccount'];

        Invoice__c inv = new Invoice__c();
        inv.Account__c= insertedAcc.Id;
        inv.Status__c='Active';
        inv.january__c=20;
        inv.February__c=20;
        inv.March__c=20;
        inv.April__c=20;
        inv.May__c=20;
        inv.June__c=20;
        inv.July__c=20;
        inv.August__c=20;
        inv.September__c=20;
        inv.October__c=20;
        inv.November__c=20;
        inv.December__c=20;
        inv.Sign_Up_Date__c=Date.Today();
        inv.Billing_Run_Date__c=Date.Today();
        Insert inv;

        Invoice__c insertedInvoice =[select Id,Name from Invoice__C where Account__c =:insertedAcc.Id];

        system.Debug('inv.Status__c : '+ inv.Status__c );
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('Test Invoice Scheduler', CRON_EXP, new Scheduled_Invoice_Update() );

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression,'Next execution date does not match with expected date of execution');
        System.assertEquals(0, ct.TimesTriggered, 'Cron Job was already executed!');
 
        Test.stopTest();

        String invoiceId =inv.Id;
        String soqlQuery = 'SELECT Id, Billing_Run_Date__c, December__c, Status__c, ' + nextMonth + ' FROM Invoice__c WHERE Id=\''+ insertedInvoice.id +'\'';

        system.Debug('soqlQuery: '+ soqlQuery );
        invoicesToUpdateBillingRunDate = database.query(soqlQuery);       
        
        Date today = date.Today();
        Date new_Billing_Run_Date = today.addMonths(1);
        new_Billing_Run_Date = new_Billing_Run_Date.toStartOfMonth();
        inv.Billing_Run_Date__c = new_Billing_Run_Date;
        system.Debug('New Billing Run Date: '+ inv.Billing_Run_Date__c);
                    
        for(Invoice__c stored_invoice : invoicesToUpdateBillingRunDate)
        {
            date invoice_Billing_date = stored_invoice.Billing_Run_Date__c;
            System.assertEquals(inv.Billing_Run_Date__c, invoice_Billing_date, 'Billing Run Verify Date is not matched with expected date!');
        }
    }
}