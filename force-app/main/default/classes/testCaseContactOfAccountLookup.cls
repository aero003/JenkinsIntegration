@isTest
public class testCaseContactOfAccountLookup {
    static testMethod void testContactLookup(){
        
        Account a = New Account();
        a.Name='Test';
        a.Account_Status__c = 'Open';
        //a.RecordTypeId = rid;
        a.RecordTypeId = Label.LiveVault_Acc_Rec_Type_Id;
        insert a;
        
        /*PartnerPortalSettings__c thisconfig = new PartnerPortalSettings__c();
        thisconfig.Name = 'PortalSettings';
        thisconfig.ContactRecordTypeId__c = '012600000009bH5';
        //thisconfig.AccountRecordTypeId__c = Label.LiveVault_Acc_Rec_Type_Id;
        insert thisconfig;
        PortalServiceHelper.config = thisconfig;*/
        
        Contact cnt = new Contact();
        cnt.LastName = 'test class';
        cnt.AccountId = a.Id;
        cnt.RecordTypeId = Label.Live_vault_contact_record_type_id;
        insert cnt;
        
        Case c=new Case();
        c.RecordTypeid = Label.LiveVault_Case_Rec_Type_Id;
        c.accountId = a.Id;
        insert c;
        
        ApexPages.currentPage().getParameters().put('relatedaccid',a.Id);
        ApexPages.currentPage().getParameters().put('tocaseID',c.Id);
        ApexPages.currentPage().getParameters().put('cntRecordTypeID',Label.Live_vault_contact_record_type_id);
        
        
        CaseContactLookupController  ccLookUp = new CaseContactLookupController();
        ccLookUp.getCaseId = String.valueOf(c.Id);
        ccLookUp.searchAccount = String.valueOf(a.Id);
        ccLookUp.selectedContactId = String.valueOf(cnt.Id);
        ccLookUp.search();
        
        ccLookUp.searchString = 'Daniel Whiting';
        ccLookUp.search();
        
        ccLookUp.searchString = 'Daniel';
        ccLookUp.search();
        
        ccLookUp.selectedContactId = String.valueOf(cnt.Id);
        ccLookUp.saveCase();
    }
}