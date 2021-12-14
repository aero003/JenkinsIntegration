@isTest
public class J2_Docusign_Account_Update_Test {
    @istest static void creatingDocusignRecord() {
        Account act = new Account();
        act.Name = 'test';
        act.Customer_ID__c = 'ISP-42081170';
        insert act;
        
        dsfs__DocuSign_Status__c dc = new dsfs__DocuSign_Status__c();
        dc.dsfs__Subject__c = 'Please sign attached LOA for eFax Account# 42081170.pdf';
        dc.dsfs__Sender__c = 'J2 Salesforce';
        dc.dsfs__Sender_Email__c = 'j2salesforceadmin@j2.com';
        insert dc;
        
        
        Account[] accountID = [select Id from Account where Customer_ID__c =: act.Customer_ID__c];
        system.debug('SIZE:-'+accountID.size());
        
        dc.Id = dc.Id;
        dc.dsfs__Company__c = accountID[0].id;
        update dc;        
    }
}