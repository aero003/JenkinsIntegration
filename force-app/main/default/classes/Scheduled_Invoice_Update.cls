global class Scheduled_Invoice_Update implements Schedulable 
{
  global void execute(SchedulableContext ctx) 
  {
    // Map for selecting the next month to check the billing
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


    /* 
    TO DO : 
      - Verify that if month is december we look for January's billing value
    */


    // Select all the Invoices that have the next month's billing > 0
    List<Invoice__c> invoicesToUpdateBillingRunDate = new List<Invoice__c>();

    Integer currentMonthNumber = Date.Today().Month();
    String nextMonth = nextMonthFieldMap.get(currentMonthNumber);

    // Prepare SOQL Querry for Active invoices with Billing due in next month
    String soqlQuery = 'SELECT Id, Billing_Run_Date__c, Status__c, ' + nextMonth + ' FROM Invoice__c WHERE Status__c=\'Active\' AND ' + nextMonth + ' > 0';

    invoicesToUpdateBillingRunDate = database.query(soqlQuery);

    // Update Billing Run Date field 
    for(Invoice__c inv : invoicesToUpdateBillingRunDate)
    {

      Date today = date.Today();
      Date new_Billing_Run_Date = today.addMonths(1);
      new_Billing_Run_Date = new_Billing_Run_Date.toStartOfMonth();
      inv.Billing_Run_Date__c = new_Billing_Run_Date;

    }

    update invoicesToUpdateBillingRunDate;
  }
}