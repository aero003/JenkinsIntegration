@isTest
public class testCaseAccountLookupController {
    
static testMethod void testAccountLookupController(){
        
        Account a = New Account();
        a.Name='Test';
        a.Account_Status__c = 'Open';
        //a.RecordTypeId = rid;
        a.RecordTypeId = Label.LiveVault_Acc_Rec_Type_Id;
    	a.KeepItSafe_username__c = 'magnetic';
        insert a;
        /*
        PartnerPortalSettings__c thisconfig = new PartnerPortalSettings__c();
        thisconfig.Name = 'PortalSettings';
        thisconfig.ContactRecordTypeId__c = '012600000009bH5';
        //thisconfig.AccountRecordTypeId__c = Label.LiveVault_Acc_Rec_Type_Id;
        insert thisconfig;
        PortalServiceHelper.config = thisconfig; */
        
        
        Case c=new Case();
        c.RecordTypeid = Label.LiveVault_Case_Rec_Type_Id;
        c.accountId = a.Id;
    	c.subject = 'magnetic';
        insert c;
        
        ApexPages.currentPage().getParameters().put('username',a.Id);
        ApexPages.currentPage().getParameters().put('tocaseID',c.Id);
        
        CaseAccountLookupController  accLookUp = new CaseAccountLookupController();
        accLookUp.getCaseId = String.valueOf(c.Id);
    	accLookUp.username = 'magnetic';
        accLookUp.search();
    
   		accLookUp.refreshPageSize();
        
        accLookUp.searchString = 'Daniel Whiting';
        accLookUp.search();
        
        accLookUp.searchString = 'Daniel';
        accLookUp.search();
        
        accLookUp.selectedAccountId = String.valueOf(a.Id);
        accLookUp.saveCase();
    }
}