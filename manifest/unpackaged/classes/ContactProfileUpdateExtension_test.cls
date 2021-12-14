@isTest
private class ContactProfileUpdateExtension_test {
    
    @isTest static void test_method_one() {
        /*//have to create PartnerPortalSettings to satisfy TriggerUpdatePortalContact.trigger
        PartnerPortalSettings__c thisconfig = new PartnerPortalSettings__c();
        thisconfig.Name = 'PortalSettings';
        thisconfig.ContactRecordTypeId__c = '012600000009bH5';
        //thisconfig.AccountRecordTypeId__c = Label.LiveVault_Acc_Rec_Type_Id;
        thisconfig.SalesforceAPIUserId__c = UserInfo.getUserId();
        insert thisconfig;
        PortalServiceHelper.config = thisconfig;*/
        
        
        Account ab = new account();
        ab.name = 'test account';
        insert ab;
        
        //create contact record type
        Contact c = new Contact();
        c.recordtypeid = '012600000009Y4t';
        c.lastname = 'test contact';
        insert c;
        
        ApexPages.currentPage().getParameters().put('id',c.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(c);
        
        ContactProfileUpdateExtension cpt = new ContactProfileUpdateExtension(stdController);
        Attachment cntattach = new Attachment();
        cntattach.Name = 'Unit test attachment';
        Blob bodyblob = Blob.valueOf('Unit test attachment body');
        cntattach.body = bodyblob;
        
        cpt.thisAttachment = cntattach;
        cpt.submitContactForm();
    }
    @isTest static void test_method_negative() {
        
       /* PartnerPortalSettings__c thisconfig = new PartnerPortalSettings__c();
        thisconfig.Name = 'PortalSettings';
        thisconfig.ContactRecordTypeId__c = '012600000009bH5';
        //thisconfig.AccountRecordTypeId__c = Label.LiveVault_Acc_Rec_Type_Id;
        insert thisconfig;
        PortalServiceHelper.config = thisconfig;*/
        
        // Implement test code
        case c = new case();
        c.RecordTypeId = '012600000009cyj';
        insert c;
        ApexPages.currentPage().getParameters().put('id',c.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(c);
        ContactProfileUpdateExtension cpt = new ContactProfileUpdateExtension(stdController);
        cpt.ContactId = c.Id;
        cpt.submitContactForm();
    }
    @isTest static void test_method_negative_2() {
        
        /*PartnerPortalSettings__c thisconfig = new PartnerPortalSettings__c();
        thisconfig.Name = 'PortalSettings';
        thisconfig.ContactRecordTypeId__c = '012600000009bH5';
        //thisconfig.AccountRecordTypeId__c = Label.LiveVault_Acc_Rec_Type_Id;
        thisconfig.SalesforceAPIUserId__c = UserInfo.getUserId();
        insert thisconfig;
        PortalServiceHelper.config = thisconfig; */
        
          Account ab = new account();
        ab.name = 'test account';
        insert ab;
        
        // Implement test code
        Contact c = new Contact();
        c.recordtypeid = '012600000009Y4t';
        c.lastname = 'test contact 2';
        insert c;
        
         ApexPages.currentPage().getParameters().put('id','');
        ApexPages.StandardController stdController = new ApexPages.StandardController(c);
        ContactProfileUpdateExtension cpt = new ContactProfileUpdateExtension(stdController);
        cpt.submitContactForm();
    }
}