@isTest
public with sharing class InvoiceTrigger_Test {

    public static final Id RECORD_TYPE_KISNL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId(); 
    public static Id RECORD_TYPE_KIS_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafe').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_UK_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeUK').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_US_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeUS').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_CA_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeCA').getRecordTypeId();
    public static final Integer BULK_SIZE = 1;

    @isTest 
    //- If Active Account has 'Active' Invoce and Invoice is closed then Account should be 'Inactive' 
    static void InvoiceUpdateTrigger_Test_active_account_to_closed_after_invoice_closed() {

       // create account
       Account testAcc = new Account(Name = 'MarkoLukaTest', Status__c = 'Active', RecordTypeId = RECORD_TYPE_KISNL_ID,BillingCountry='NL', BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular',Veeam_License_Subscription__c='Yes');
       insert testAcc;

       // create new test invoice
       Invoice__c testInvoice = new Invoice__c(Account__c = testAcc.Id, Status__c = 'Active',
                              Sign_Up_Date__c = date.Today(), Amount__c = 50,
                              Billing_Run_Date__c  = date.Today());
       insert testInvoice;                

       testInvoice.Status__c = 'InActive';
       testInvoice.Invoice_Reason__c = 'Closed Down';

       update testInvoice;

       // GET Account status after upgrade account invoice
       Account updatedAcc = [Select Id, Status__c, Name FROM Account WHERE Name='MarkoLukaTest'];
       // the account should be set on closed if there is not active invoice
       System.assertEquals('Inactive', updatedAcc.Status__c,'No active invoces should set/update Account status to Inactive');
    }

    //- If Account is in 'Inactive' state and 'Active' Invoice is created for this Account, the Acount status should be changed to 'Active'
    @isTest
    static void InvoiceUpdateTrigger_Test_closed_account_to_active_after_invoice_added() {

        // create account
        Account testAcc = new Account(Name = 'MarkoLukaTest', Status__c = 'InActive', BillingCountry='NL',RecordTypeId = RECORD_TYPE_KISNL_ID,BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes');
        insert testAcc;

        //create new invoce with 'active' status for existing account 
        Invoice__c testActiveInvoice = new Invoice__c(Account__c = testAcc.Id, Line_Number1__c='asde', Status__c = 'Active',
                              Sign_Up_Date__c = date.Today(), Amount__c = 50,
                              Billing_Run_Date__c  = date.Today());

        insert testActiveInvoice;

        Account updatedAcc = [Select Id, Status__c, Name FROM Account WHERE Name='MarkoLukaTest'];
        // verify if Acount 'status' has change on "active" after added invoice with "active" state
        System.assertEquals('Active', updatedAcc.Status__c, 'Any active invoice should activate account (Active status)');

        Invoice__c invToUpdateAccount = [SELECT Id, Account__c FROM Invoice__c WHERE Line_Number1__c='asde'];
        delete invToUpdateAccount;

        Integer invoiceCount = [SELECT COUNT() FROM Invoice__c where Account__c = :updatedAcc.Id];
        Account inactiveAcc = [Select Id, Status__c, Name FROM Account WHERE Name='MarkoLukaTest'];

        System.assertEquals('Inactive', inactiveAcc.Status__c, 'Account without invoice should be Inactive');
        System.assertEquals(0, invoiceCount, 'No invoice should be found after delete');
    }

    // If Account is in 'Inactive' state and new Opportunity is created for this Account, the Acount status should be changed to 'Active'
    @isTest
    static void InvoiceUpdateTrigger_Test_closed_account_to_active_after_opportunity_added() {

        Account test_accStatus_fromOpportunity = new Account(Name='123LukaMarko', 
                                Status__c='InActive', 
                                Reason__c='Closed Down',
                                Phone='123123', 
                                Country_code__c='NL', 
                                Currency_1__c='EUR',
                                BillingCountry='NL',
                                BillingCity='Budl', 
                                BillingState='Budl',
                                BillingPostalCode='123123', 
                                BillingStreet='Street', 
                                Customer_Source__c='Backup Factory',
                                Support_Level__c='Regular', 
                                Veeam_License_Subscription__c='Yes',  
                               RecordTypeId=RECORD_TYPE_KISNL_ID);

        insert test_accStatus_fromOpportunity;


        Opportunity oppToUpdateAccStatus = new Opportunity(AccountId=test_accStatus_fromOpportunity.Id, 
                                  Name='Portal - Managed Backup (Ahsay) - 25 GB ', 
                                  Amount=264, Package__c='Managed Backup (Ahsay)',
                                  Contract_Length__c='1', 
                                  GB_Package__c=25, 
                                  CloseDate=date.Today(), 
                                  StageName='Closed Won, delay Invoice', 
                                  Type='New Business');

        
        // note inserting opportunity should create an active invoice
        insert oppToUpdateAccStatus;
 
        Account updatedAcc = [Select Id, Status__c, Name FROM Account WHERE Name='123LukaMarko'];
        System.assertEquals('Active', updatedAcc.Status__c,'Won opportunity should create Active Invoce and activate account');
   }

   @isTest static void InvoiceUpdateTrigger_Test_Create_Multipple_Opportunities_to_automatic_create_multiple_invoices() {

    List<Opportunity> testOpportunity = new List<Opportunity>();

       // create Test Account
        Account testAccount = new Account(Name = 'Test Multiple Account Invoces',
        Status__c='InActive', 
        Reason__c='Closed Down',
        Phone='123123', 
        Country_code__c='NL', 
        Currency_1__c='EUR',
        BillingCountry='NL',
        BillingCity='Budl', 
        BillingState='Budl',
         BillingPostalCode='123123', 
         BillingStreet='Street', 
         Customer_Source__c='Backup Factory',
         Support_Level__c='Regular', 
         Veeam_License_Subscription__c='Yes', 
        RecordTypeId=RECORD_TYPE_KISNL_ID);

        insert testAccount;

        // create multiple opportunities for created account
    for (Integer i = 0; i < BULK_SIZE ; i++) {

        testOpportunity.add(new Opportunity(AccountId=testAccount.Id, 
        Name='Portal - Managed Backup (Ahsay) - 25 GB ', 
        Amount=264+i, 
        Package__c='Managed Backup (Ahsay)',
        Contract_Length__c='1', 
        GB_Package__c=25, 
        CloseDate=date.Today(), 
        StageName='Closed Won, delay Invoice',
        Comments__c='Test Opportunity Marko Luka'+i, 
        Type='New Business'));
    }
    
    insert testOpportunity;

    Account AccId = [Select Id, Name, Status__c  FROM Account WHERE Name = 'Test Multiple Account Invoces'];
    // Check if account status was chandeg to 'Active'
    System.assertEquals('Active', AccId.Status__c, 'The Account Status does not match with Expected status');
    
    // check number of created Opportunities for created account
    Integer numAccount =[SELECT Count() FROM Opportunity WHERE AccountId =: AccId.Id];
    System.assertEquals(BULK_SIZE, numAccount, 'The number of Created Opportunities does not match with expected number');

    //check the number of created 'Active' invoices for created Account
    Integer NumberOFActiveInvoice = [SELECT Count() FROM Invoice__c WHERE Account__c = :AccId.Id and Status__c = 'Active'];
    System.assertEquals(BULK_SIZE, NumberOFActiveInvoice, 'The number of Active Invoices does not match with expected number');       
    }

    @isTest static void Test_Send_Bill_To_From_Invoice_To_Account()
    {
            // create account
            Account testAcc = new Account(Name = 'Send Bill To test', BillingCountry='NL', Send_Bill_To__c='Direct', Status__c = 'InActive',BillingCity='Budl', BillingState='Budl', BillingPostalCode='123123', BillingStreet='Street', Customer_Source__c='Backup Factory', Phone='12213213', Support_Level__c='Regular', Veeam_License_Subscription__c='Yes', RecordTypeId = RECORD_TYPE_KISNL_ID);
            insert testAcc;
            
            //create new invoce with populated Audit_Send_Bill_To__c property
            Invoice__c testActiveInvoice = new Invoice__c(Account__c = testAcc.Id, Status__c = 'Active', Amount__c = 50,
            Sign_Up_Date__c = date.Today(),
            Billing_Run_Date__c  = date.Today()/*,
            Audit_Send_Bill_To__c = 'Direct'*/);
            insert testActiveInvoice;

            Account updatedAccount = [SELECT Id, Send_Bill_To__c FROM Account WHERE Name='Send Bill To test'];
            Invoice__c testInvoice = [SELECT Id, Audit_Send_Bill_To__c FROM Invoice__C WHERE Id =: testActiveInvoice.Id];
            System.assertEquals(testInvoice.Audit_Send_Bill_To__c, updatedAccount.Send_Bill_To__c,'Error: Invoice Audit_Send_Bill_To__c property does not mach with Account Send_Bill_To field.');

            /* 
            TO DO : 
            - What happens if Send bill to is updated on the account ?
            - What happen if Audit Send bill to is updated on the Invoice ?

            The logic to map values is implemented via the Formula on the Invoice's filed Audit Send Bill To
            to map the value from the Account__r relationship.
            */
    }

    @isTest static void Set_Invoce_Billing_Periode_To_Monthly_NL_RecordType()
    {
        Account acc = new Account(Name='Status test acc', 
                          Type='Prospect', 
                          Status__c = 'Active', 
                          RecordTypeId=RECORD_TYPE_KISNL_ID,
                          BillingCountry__c='NL',
                          BillingCity='AM',
                          BillingState='State',
                          BillingPostalCode='Postal code',
                          BillingStreet='St123',
                          Phone='123123123',
                          Customer_Source__c='Partner',
                          Support_Level__c='Regular');

    insert acc;

    Account ac = [SELECT Id, RecordTypeId FROM Account WHERE Name='Status test acc'];

    Invoice__c inv = new Invoice__c(Status__c='Active', 
                             Account__c=ac.Id, Amount__c = 50,
                             Sign_Up_Date__c=date.Today());

     insert inv;

    Invoice__c insertedInvoice =[Select Id,Billing_Period__c  from Invoice__c Where Account__c =: ac.Id];

     System.assertEquals('Monthly',insertedInvoice.Billing_Period__c,'Unexpeceted Billing Period set on Invoice (insertedInvoice.Billing_Period__c)');
    }


    @isTest static void Set_Invoce_Billing_Periode_To_Monthly_IE_RecordType()
    {
        Account acc = new Account(Name='Status test acc IE', 
                          Type='Prospect', 
                          Status__c = 'Active', 
                          RecordTypeId=RECORD_TYPE_KIS_ID,
                          BillingCountry__c='NL',
                          BillingCity='AM',
                          BillingState='State',
                          BillingPostalCode='Postal code',
                          BillingStreet='St123',
                          Phone='123123123',
                          Customer_Source__c='Partner',
                          Support_Level__c='Regular');

    insert acc;

    Account ac = [SELECT Id, RecordTypeId FROM Account WHERE Name='Status test acc IE'];

    Invoice__c inv = new Invoice__c(Status__c='Active', 
                             Account__c=ac.Id, Amount__c = 50,
                             Sign_Up_Date__c=date.Today());

     insert inv;

    Invoice__c insertedInvoice =[Select Id,Billing_Period__c  from Invoice__c Where Account__c =: ac.Id];

     System.assertEquals('Monthly',insertedInvoice.Billing_Period__c,'Unexpeceted Billing Period set on Invoice (insertedInvoice.Billing_Period__c)');
    }

}