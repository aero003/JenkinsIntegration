public class OppEfaxVolumeReportSchedule implements schedulable {
    
    public void execute(SchedulableContext SC){
        sendExcelFile();
    }
    public void sendExcelFile(){
        List<OppPipelineReportEmailAddresses__c> oppPipelineReportEmailAddresses = OppPipelineReportEmailAddresses__c.getall().values();
        List<OppEfaxVolumeReportEmailAddresses__c> oppEfaxVolumeReportEmailAddresses = OppEfaxVolumeReportEmailAddresses__c.getall().values();
        
         //get "from Adress" from Custom Setting
        OpportunitySchedulerFromEmail__c osfm = OpportunitySchedulerFromEmail__c.getOrgDefaults();
        //System.debug('from address = ' + osfm.From_Address__c);
        
        String FromAddress = osfm.From_Address__c == null ? 'j2salesforceadmin@j2.com' : osfm.From_Address__c;
        
             
        System.debug('opportunity pipeline report To email addresses = ' + oppPipelineReportEmailAddresses);
        // Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        Messaging.EmailFileAttachment attachOppEfaxVolumeReport = new Messaging.EmailFileAttachment();
        Messaging.EmailFileAttachment attachOppPipelineRpt = new Messaging.EmailFileAttachment();
        
        // Reference the Opportunity Efax Volume Report attachment page 
        PageReference excelOppEfaxVolume = new PageReference('/apex/OpportunityEfaxVolumeReport');
        excelOppEfaxVolume.getParameters().put('contentType','application/vnd.ms-excel#Corporate Fax Enterprise Page Volume Pipeline Report.xls'); 
        
        // Reference the Opportunity Pipeline Report attachment page 
        PageReference excelOppPipeline = new PageReference('/apex/OpportunityPipelineReport');
        excelOppPipeline.getParameters().put('contentType','application/vnd.ms-excel#North American - Opportunity Pipeline Performance Review.xls'); 
        
        // Take the Excel content
        Blob b = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : excelOppEfaxVolume.getContent();
        Blob b1 = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : excelOppPipeline.getContent();
        
        //set the body if attachment
        attachOppEfaxVolumeReport.setBody(b);
        attachOppEfaxVolumeReport.setFileName('Opportunity Efax Volume Report.xls');
        
        attachOppPipelineRpt.setBody(b1);
        attachOppPipelineRpt.setFileName('Opportunity Pipeline Report.xls');
        
        
        //subject, body, address
        List<String> toaddresses_OppPipeline = new List<String>();
        for(Integer i=0;i<oppPipelineReportEmailAddresses.size();i++){
            toaddresses_OppPipeline.add(oppPipelineReportEmailAddresses[i].Name);
        }
        List<String> toaddresses_OppEfaxVolume = new List<String>();
        for(Integer i=0;i<oppEfaxVolumeReportEmailAddresses.size();i++){
            toaddresses_OppEfaxVolume.add(oppEfaxVolumeReportEmailAddresses[i].Name);
        }
        
        
        //get Email Template Id
        Id OppEfaxVolumeRptTemplateId = [select Id from EmailTemplate where DeveloperName = 'Opportunity_efax_volume_report'].Id;
        Id OppPipelineRptTemplateId = [select Id from EmailTemplate where DeveloperName = 'Opportunity_Pipeline_Report'].Id;
        
        //get lead Id
        Id LeadId = [select Id from Lead limit 1].Id;
        
        //get "from email address" from Org wide email Addresses
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :FromAddress];
        
        
        
        // email for opportunity efax volume report
        Messaging.singleEmailMessage EmailOppEfaxVolumeRpt = new Messaging.singleEmailMessage();
        if ( owea.size() > 0 ) {
            EmailOppEfaxVolumeRpt.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        EmailOppEfaxVolumeRpt.setTemplateId(OppEfaxVolumeRptTemplateId);
        EmailOppEfaxVolumeRpt.setToAddresses(toaddresses_OppEfaxVolume);
        EmailOppEfaxVolumeRpt.setTargetobjectid(LeadId); // use any Lead, User or contact id
        EmailOppEfaxVolumeRpt.setTreatTargetObjectAsRecipient(false);
        EmailOppEfaxVolumeRpt.setFileAttachments(new Messaging.EmailFileAttachment[]{attachOppEfaxVolumeReport});
        
        // email for Opportunity pipeline report
        Messaging.singleEmailMessage EmailOppPipelineRpt = new Messaging.singleEmailMessage();
        if ( owea.size() > 0 ) {
            EmailOppPipelineRpt.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        EmailOppPipelineRpt.setTemplateId(OppPipelineRptTemplateId);
        EmailOppPipelineRpt.setToAddresses(toaddresses_OppPipeline);
        EmailOppPipelineRpt.setTargetobjectid(LeadId); // use any Lead, User or contact id
        EmailOppPipelineRpt.setTreatTargetObjectAsRecipient(false);
        EmailOppPipelineRpt.setFileAttachments(new Messaging.EmailFileAttachment[]{attachOppPipelineRpt});
        
        // Sends 2 emails
        Messaging.SendEmailResult [] e =
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {EmailOppEfaxVolumeRpt,EmailOppPipelineRpt});
        inspectResults(e);
    }
    // Helper method
    public static String inspectResults(Messaging.SendEmailResult[] results) {
        String result = '';
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            
            result = res.isSuccess() ? 'Email sent successfully' : 'The following errors occurred: ' + res.getErrors();
            System.debug(result);
        }
        return result;
    } 
}