@IsTest(SeeAllData=true)
private with sharing  class PortalUnitTest {
/*
   @isTest  static void testLeadTriggerViaDML()
    {
            Account testAccountPartner = new Account( Name = 'Test Partner', RecordTypeId = PortalServiceHelper.config.AccountRecordTypeId__c, PortalPartnerID__c= '1');
            insert testAccountPartner ;
                        
            Lead testLead = new Lead( Company = 'Test Lead', Status = 'In Progress', Lead_Souce_Type__c = 'ITS Profiles List', LastName='Hirpara', Email='hirpara.sanjay@gmail.com',RecordTypeId = PortalServiceHelper.config.LeadRecordTypeId__c, Assigned_Partner_Portal_ID__c = testAccountPartner.Id);
            insert testLead ;
            testLead = [select Id, Company from Lead where Id = :testLead.Id];
            System.assertEquals(testLead.Company , 'Test Lead');  
    }


    @isTest static void testNoteTriggerViaDML()
    {
            Lead testLead = new Lead( Company = 'Test Lead', Status = 'In Progress', Lead_Souce_Type__c = 'ITS Profiles List', LastName='Hirpara', Email='hirpara.sanjay@gmail.com',RecordTypeId = PortalServiceHelper.config.LeadRecordTypeId__c );
            insert testLead ;
            testLead = [select Id, Company from Lead where Id = :testLead .Id];
                                                
            Note testNote = new Note( Title = 'Test Note', Body = 'Test Note', ParentId = testLead.Id);
            insert testNote ;
            testNote = [select Title, Body from Note where Id = :testNote .Id];
            System.assertEquals(testNote.Title , 'Test Note');  
    }

    @isTest static void testAccountTriggerViaDML()
    {
            Account testAccountPartner = new Account( Name = 'Test Partner', RecordTypeId = PortalServiceHelper.config.AccountRecordTypeId__c, PortalPartnerID__c= '1');
            insert testAccountPartner ;
            
            Account testAccount = new Account( Name = 'Test Account', RecordTypeId = PortalServiceHelper.config.AccountRecordTypeId__c, Assigned_Portal_Partner_ID__c = testAccountPartner.Id);
            insert testAccount ;
            testAccount = [select Name from Account where Id = :testAccount.Id];
            System.assertEquals(testAccount.Name , 'Test Account');  
    }

    @isTest static void testOpportunityTriggerViaDML()
    {
            Account testAccountPartner = new Account( Name = 'Test Partner', RecordTypeId = PortalServiceHelper.config.AccountRecordTypeId__c, PortalPartnerID__c= '1');
            insert testAccountPartner ;
        
            Account testAccount = new Account( Name = 'Test Account', RecordTypeId = PortalServiceHelper.config.AccountRecordTypeId__c , Assigned_Portal_Partner_ID__c = testAccountPartner.Id);
            insert testAccount ;

            Opportunity testopp = new Opportunity( Name = 'Test Opportunity', AccountId = testAccount.Id, CloseDate= date.today(), StageName='30% - Qualified Prospect', RecordTypeId = PortalServiceHelper.config.OpportunityRecordTypeId__c);
            insert testopp ;
            
            Contact testCont = new Contact( FirstName = 'TestContactFirstName', LastName = 'Hirpara', AccountId =testAccount.Id);
            insert testCont ;
        
            OpportunityContactRole opcontact =  new OpportunityContactRole(ContactId = testCont.Id, OpportunityId= testopp.Id);
            insert opcontact ;
        
            testopp = [select Name from Opportunity where Id = :testopp.Id];
            System.assertEquals(testopp.Name , 'Test Opportunity');  
    }

    @isTest static void testContactTriggerViaDML()
    {
            Account testAccount = new Account( Name = 'Test Account', RecordTypeId = PortalServiceHelper.config.AccountRecordTypeId__c, PortalPartnerID__c= '1');
            insert testAccount ;

            Contact testopp = new Contact( FirstName = 'TestContactFirstName', LastName = 'Hirpara', AccountId = testAccount.Id);
            insert testopp ;
            testopp = [select FirstName, LastName from Contact where Id = :testopp.Id];
            System.assertEquals(testopp.FirstName , 'TestContactFirstName');  
    }

    @isTest static void testLeadConvert()
    {
            Lead testLead = new Lead( Company = 'Test Lead', Status = 'In Progress', Lead_Souce_Type__c = 'ITS Profiles List', LastName='Hirpara', Email='hirpara.sanjay@gmail.com',RecordTypeId = PortalServiceHelper.config.LeadRecordTypeId__c);
            insert testLead ;
            Database.LeadConvertResult lcr = PortalServiceHelper.ConvertLead(testLead.Id);
            
            System.assert(lcr.isSuccess());
    }
*/
   
}