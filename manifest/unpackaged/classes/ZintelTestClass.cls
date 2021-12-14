@isTest(SeeAllData=true)
public with sharing class ZintelTestClass {
    
     static testmethod void  opportunityTestMethod(){
        
            Account a = new Account();
            a.Name = 'Test Account';
            a.Relationship_Type_Communications__c = 'Customer';
            Id arid = [select Id from RecordType where Id=:Label.Zintel_NZ_AccountRT  limit 1].Id;
            a.RecordTypeId= arid;
            insert a;
            
            Id rid = [select Id from RecordType where (Name =: Label.Zintel_Opportunity_RT and SObjectType = 'Opportunity') limit 1].Id;     
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity';
            opp.Topic__c = 'Test Topic';
            opp.CloseDate = system.today();
            opp.StageName = '100%-Won (Paperwork Rec\'d/Credit Appv\'d)';
            opp.Revenue_Type__c = 'Add On: part/service added to existing product/service under existing contract';
            opp.Estimate_Value_Excl_Settlement_GST__c = 1000.00;
            opp.AccountId = a.Id;
            opp.RecordTypeId = rid;
            insert opp;
            
            Contact c = new Contact ();
            c.AccountId = a.Id;
            c.FirstName = 'Test';
            c.LastName  = 'Contact';
            c.Email     = 'Test@test.com';
            c.Contact_Roles__c = 'TWINS Billing Contact';
            insert c;
            
            a.Update_TWINS__c = true;
            a.Phone = '123465';
            update a;
            
            c.Fax = '12345';
            update c;
            
            Case ca = new Case();
            ca.Title__c = 'Billing Resign';
            ca.AccountId = a.Id;
            ca.Subject = 'Opportunity Won';
            ca.Description = 'Test Case';
            insert ca;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'st1234', Email='standarduser1234@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='ZintelTestUser@testorg.com');
            
            insert u;
            
            ca.OwnerId = u.Id;
            update ca;
            
            
            TwinsCalloutIntegrationClass tci = new TwinsCalloutIntegrationClass();
            //TwinsCalloutIntegrationClass.createUpdateAccountCallout(a.Id);
            //TwinsCalloutIntegrationClass.createContactCallout(c.Id);
            String response;
            
            response = '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';
            response += '<s:Header>';
            response += '<ActivityId CorrelationId="d628a61e-645e-4739-a159-4cb99b1f82bf" xmlns="http://schemas.microsoft.com/2004/09/ServiceModel/Diagnostics">221d77e3-f152-40c5-8a64-29aee2c2a89c</ActivityId>';
            response += '</s:Header>';
            response += '<s:Body>';
            response += '<UpdatePerorgResponse xmlns="http://zintelcogent.co.nz/xmlschemas/TwinsService">';
            response += '<UpdatePerorgResult>&lt;?xml version = "1.0" encoding="Windows-1252" standalone="yes"?&gt;&#xD;';
            response += '&lt;Perorgs&gt;&#xD;';
            response += '&lt;Perorg&gt;&#xD;';
            response += '&lt;TwinsId&gt;Z00126072&lt;/TwinsId&gt;&#xD;';
            response += '&lt;CrmGuid/&gt;&#xD;';
            response += '&lt;Name&gt;Test Contact&lt;/Name&gt;&#xD;';
            response += '&lt;AlternateID/&gt;&#xD;';
            response += '&lt;Type&gt;Person&lt;/Type&gt;&#xD;';
            response += '&lt;Honorifc/&gt;&#xD;';
            response += '&lt;GivenName&gt;Test&lt;/GivenName&gt;&#xD;';
            response += '&lt;Surname&gt;Contact&lt;/Surname&gt;&#xD;';
            response += '&lt;Parent&gt;&#xD;';
            response += '&lt;TwinsId&gt;Z00126064&lt;/TwinsId&gt;&#xD;';
            response += '&lt;CrmGuid/&gt;&#xD;';
            response += '&lt;Name&gt;test account2&lt;/Name&gt;&#xD;';
            response += '&lt;/Parent&gt;&#xD;';
            response += '&lt;Roles&gt;&#xD;';
            response += '&lt;Role&gt;Report Subscriber&lt;/Role&gt;&#xD;';
            response += '&lt;/Roles&gt;&#xD;';
            response += '&lt;/Perorg&gt;&#xD;';
            response += '&lt;/Perorgs&gt;&#xD;';
            response += '</UpdatePerorgResult>';
            response += '</UpdatePerorgResponse>';
            response += '</s:Body></s:Envelope>';
                    
            DOM.Document doc = new DOM.Document();    
            doc.load(response);  
            tci.parseResponse(doc.getRootElement());
    }   
}