@isTest
public class J2_ISP_Tool_ControllerTEST {
    static testMethod void j2ISPToolTest() {
        
       PageReference pg = Page.J2_FAXFORCE_PROD;
        Test.setCurrentPage(pg);
        test.startTest();
        
        Account a = new Account(Name = 'Test Account', Customer_id__c='ISP-221');
        insert a;
        ApexPages.StandardController stdController = new ApexPages.StandardController(a);
        
        J2_ISP_Tool_Controller j2IspTool_nocontroller1 = new J2_ISP_Tool_Controller();
        
        ApexPages.currentPage().getParameters().put('customerid','22122');
        J2_ISP_Tool_Controller j2IspTool_nocontroller2 = new J2_ISP_Tool_Controller();
        
        J2_ISP_Tool_Controller j2IspTool_noaccount = new J2_ISP_Tool_Controller(stdController);
        j2IspTool_noaccount.DisplayNoAccount = true;
        ApexPages.currentPage().getParameters().put('customerid','221');
        
        J2_ISP_Tool_Controller j2IspTool = new J2_ISP_Tool_Controller(stdController);
        
        boolean j2Acc = j2IspTool.DisplayNoAccount;
        
        dsfs__DocuSign_Status__c dc = new dsfs__DocuSign_Status__c();
        dc.dsfs__Subject__c = 'Please sign attached LOA for MyFax Account# 42081170.pdf';
        dc.dsfs__Sender__c = 'J2 Salesforce';
        dc.dsfs__Sender_Email__c = 'j2salesforceadmin@j2.com';
        //untitled envelope id for qafull
        //dc.dsfs__DocuSign_Envelope_ID__c = '5ad0a3f3-a4fb-42c0-ade6-37885de271a4';
        //untitled envelope id for prod
        dc.dsfs__DocuSign_Envelope_ID__c = '42016891-b3bf-4e90-acb5-aa232700406f';
        insert dc;
        
        Attachment att = new Attachment();
        att.Name = 'Name';
        att.Description = 'Test description';
        att.ParentId = dc.Id;
        att.Body = blob.valueOf('Test Body');
        insert att;
        
         ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion; 
           
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = dc.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        List<String> lstofEnvelop = new List<String>();
        lstofEnvelop.add(dc.dsfs__DocuSign_Envelope_ID__c);
        
        J2_ISP_Tool_Controller.downloadLOA(dc.dsfs__DocuSign_Envelope_ID__c);
        J2_ISP_Tool_Controller.getEnvelopStatus(lstofEnvelop);
        
        
        test.stopTest();
    }
}