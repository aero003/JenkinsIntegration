@isTest
private class OppEfaxVolumeReportScheduleTest {
    @testsetup
    public static void sendEmail_setup(){
       /* //have to create PartnerPortalSettings to satisfy TriggerUpdatePortalLead.trigger
        PartnerPortalSettings__c thisconfig = new PartnerPortalSettings__c();
        thisconfig.Name = 'PortalSettings';
        thisconfig.LeadRecordTypeId__c = '012600000009bH5';
        //thisconfig.AccountRecordTypeId__c = Label.LiveVault_Acc_Rec_Type_Id;
        thisconfig.SalesforceAPIUserId__c = UserInfo.getUserId();
        insert thisconfig;
        PortalServiceHelper.config = thisconfig; */
        
        //custom setting for opportunity pipeline report email addresses
        List<OppPipelineReportEmailAddresses__c> oprsSetting_PipelineReport = new List<OppPipelineReportEmailAddresses__c>();
        OppPipelineReportEmailAddresses__c OppPipelineReportEmailAdd1 = new OppPipelineReportEmailAddresses__c();
        OppPipelineReportEmailAdd1.name='arun.reddy@j2.com';
        oprsSetting_PipelineReport.add(OppPipelineReportEmailAdd1);
        OppPipelineReportEmailAddresses__c OppPipelineReportEmailAdd2 = new OppPipelineReportEmailAddresses__c();
        OppPipelineReportEmailAdd2.name='vitap.ramdevputra@cygnetinfotech.com';
        oprsSetting_PipelineReport.add(OppPipelineReportEmailAdd2);
        insert oprsSetting_PipelineReport;
        
        //custom setting for opportunity efax volume report email addresses
        List<OppEfaxVolumeReportEmailAddresses__c> oprsSetting_EfaxVolumeReport = new List<OppEfaxVolumeReportEmailAddresses__c>();
        OppEfaxVolumeReportEmailAddresses__c OppEfaxVolumeReportEmailAdd1 = new OppEfaxVolumeReportEmailAddresses__c();
        OppEfaxVolumeReportEmailAdd1.name='arun.reddy@j2.com';
        oprsSetting_EfaxVolumeReport.add(OppEfaxVolumeReportEmailAdd1);
        OppEfaxVolumeReportEmailAddresses__c OppEfaxVolumeReportEmailAdd2 = new OppEfaxVolumeReportEmailAddresses__c();
        OppEfaxVolumeReportEmailAdd2.name='vitap.ramdevputra@cygnetinfotech.com';
        oprsSetting_EfaxVolumeReport.add(OppEfaxVolumeReportEmailAdd2);
        insert oprsSetting_EfaxVolumeReport;
        
        
        Id leadRecordTypeId = [select Id from RecordType where (name = 'eFax® UK Sales')].id;        
        Lead l = new Lead(LastName='Console', Company='abc global', Email='jj@gmail.com', Status='New',Country='US');
        insert l;
    }
    @isTest public static void sendEmail_Test1(){
        
        test.startTest();
        String chron = '0 0 13 * * ?' ;
        try{
            system.schedule('job', chron, new OppEfaxVolumeReportSchedule());     
        }
        catch(Exception e){
            System.assert(false);
        }
        test.stopTest();
    }
}