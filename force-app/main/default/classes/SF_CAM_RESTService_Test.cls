@IsTest
public class SF_CAM_RESTService_Test {
    
    public static testMethod void serviceTest() {
        Account testAccount = new Account();
        
        testAccount.Name = 'Test_Account';
        testAccount.Industry = 'Automobile';
        testAccount.Contract_Application__c = false;
        testAccount.Application_Billing_Type__c = '';
        testAccount.Market_Segment__c = 'Mid Market';
        testAccount.Expected_DID_Limit__c = '';
        testAccount.Contact_Language__c = 'English';
        testAccount.cam_product_code__c = 'CONSENSUS';
        testAccount.cam_offer_code__c = 'CONSENSUS';
        testAccount.Secure_Fax_Type__c = 'ENABLED';
        testAccount.Tax_Number__c = '10';
        testAccount.Corp_ID__c = '1122330';
        testAccount.Application_ID__c = '112233';
        
        insert testAccount;
        
        Contact con = new Contact();
        con.AccountId = testAccount.Id;
        con.Title = 'Mr';
        con.FirstName = 'John';
        con.LastName = 'Dho';
        con.Email = 'test@test.com';
        con.MailingStreet = '1 street';
        con.MailingStreet2__c = '2 street';
        con.MailingCity = 'City';
        con.MailingState = 'State';
        con.MailingPostalCode = '23422';
        con.MailingCountry = 'Country';
        con.Phone = '1111111111';
        con.Fax = '1111111111';
        
        insert con;
        
        Contact con1 = new Contact();
        con1.AccountId = testAccount.Id;
        con1.Title = 'Mr';
        con1.FirstName = 'John';
        con1.LastName = 'Dho';
        con1.Email = 'test@test.com';
        con1.MailingStreet = '1 street';
        con1.MailingStreet2__c ='hyh';
        con1.MailingCity = 'City';
        con1.MailingState = 'State';
        con1.MailingPostalCode = '23422';
        con1.MailingCountry = 'Country';
        con1.Phone = '1111111111';
        con1.Fax = '1111111111';
        
        insert con1;
        Opportunity opp1 = new Opportunity();
        //[Name, StageName, CloseDate, Locations__c, Site_License__c, Tier__c
        opp1.AccountId = testAccount.Id;
        opp1.Amount = 111.00;
        opp1.Name = 'opp1';
        opp1.StageName = '10% - Deferred';
        opp1.CloseDate = date.newinstance(2020,01,01);
        opp1.Application__c = testAccount.Application_ID__c;
        
        insert opp1;
        
        SBQQ__Quote__c priQuote = new SBQQ__Quote__c();
        priQuote.SBQQ__Account__c =testAccount.id;
        priQuote.SBQQ__Primary__c = true;
        priQuote.SBQQ__Opportunity2__c = opp1.id;
        priQuote.cam_Payment_Term__c = 'Net 30';
        priQuote.SBQQ__StartDate__c = system.today();
        insert priQuote;
        
        Opportunity opp = new Opportunity();
        //[Name, StageName, CloseDate, Locations__c, Site_License__c, Tier__c
        opp.AccountId = testAccount.Id;
        opp.Amount = 111.00;
        opp.Name = 'opp';
        opp.SBQQ__PrimaryQuote__c = priQuote.id;
        opp.StageName = '10% - Deferred';
        opp.CloseDate = date.newinstance(2020,01,01);
        opp.Locations__c = 1.00;
        opp.Site_License__c = 1;
        opp.Tier__c = 'Tier1 -- $99';
        opp.Is_Pushed_to_CAM__c = true;
        opp.cam_Payment_Term__c = '';
        opp.cam_access_tocken__c = 'acb';
        opp.Application__c = testAccount.Application_ID__c;
        
        insert opp;
        
       // Select id, Role, Contact.Id, opportunityId FROM OpportunityContactRole
        OpportunityContactRole crole = new OpportunityContactRole();
        crole.Role = 'Corporate Admin';
        crole.OpportunityId = opp.id;
        crole.ContactId = con.id;
        insert crole;
        
        OpportunityContactRole prole = new OpportunityContactRole();
        prole.Role = 'Account Payable';
        prole.OpportunityId = opp.id;
        prole.ContactId = con.id;
        insert prole;
        
        SBQQ__Quote__c tQuote = new SBQQ__Quote__c();
        tQuote.SBQQ__Account__c =testAccount.id;
        tQuote.SBQQ__Primary__c = true;
        tQuote.SBQQ__Opportunity2__c = opp.id;
        tQuote.cam_Payment_Term__c = 'Net 30';
        tQuote.SBQQ__StartDate__c = system.today();
        insert tQuote;
        
        credit_application__c cred = new credit_application__c();
        cred.Name = 'log Crediential';
        cred.httpMethod__c = 'application/json';
        cred.Content_Type__c = 'content-type';
        cred.End_Point__c = 'www.test.com';
        cred.Application_Json__c = 'POST';
        cred.Authorization__c = 'Authorization';
        cred.Bearer__c = 'Bearer';
        
        insert cred;
        
        Login_Credential__c log = new Login_Credential__c();
        log.Name = 'log Crediential';
        log.applicationJson__c = 'application/json';
        log.Content_Type__c = 'content-type';
        log.End_Point__c = 'www.test.com';
        log.Http_Method__c = 'POST';
        
        insert log;
        CamAPIDefaultValues__c camLog = new CamAPIDefaultValues__c();
        camLog.collection_method__c = 'N';
        camLog.credit_limit__c = '1000000';
        camLog.did_limit__c ='10';
        camLog.Name = 'Defaults';
        camLog.oem__c = '500';
        camLog.secure_fax_Consensus__c = 'ENABLED';
        camLog.secure_fax_Efax__c = 'DISABLED';
        camLog.marketplace_code__c = 'NA';
        
        insert camLog;
        
        test.startTest();
        
        
        ApexPages.currentpage().getparameters().put('id',testAccount.id);
        ApexPages.currentpage().getparameters().put('id',opp.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        SF_CAM_RESTService serv = new SF_CAM_RESTService(controller);
        serv.isEdit = false;
        serv.getaccountInfo();
        serv.getcontactAdmin();
        serv.getcontactAdm();
        serv.getcontactPayable();
        serv.getcontactAccPayable();
        serv.getpaymentTerms();
        serv.currentRecordTypeName = 'Consensus_Account';
        serv.getopportunityInfo();
        serv.getselectedPaymentTerms();
        serv.getselectedIndustry();
        serv.getselectedLanguage();
        serv.getselectedBillingType();
        serv.getselectedMarketSegment();
        serv.getselectedOfferCode();
        serv.getSelectedSecure();
        serv.editRecord();
    	serv.goBack();
        serv.cancel();
        serv.saveRecord();        
        
        serv.saveRecord();        
        serv.opportunityID = opp.Id;
        //serv.contactAdmin = con.Id;
		serv.pushToCAM();  
        serv.resend();   
        serv.resendOld();
        serv.resendNew();
        string endpoint = 'https://test.console.com/';
        string httpmethod = 'POST';
        Map<String, String> headerDetails = new Map<String, String>();
        headerDetails.put('content-type', 'application/json');
        String jsonVal = '{'+
            '  \"username\": \"theTestUser\",'+
            '  \"password\": \"thepassword\",'+
            '}';
        test.stopTest();
    }
}