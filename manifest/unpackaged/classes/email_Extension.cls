public with sharing class email_Extension {

    public email_Extension(ApexPages.StandardSetController controller) {

    }

    public EmailMessage thisEmail {get;set;}
    public case thisCase {get;set;}
    
    public email_Extension(ApexPages.StandardController controller){
        this.thisEmail = (EmailMessage) controller.getRecord();
        this.thisCase = thisEmail.Parent;
        
    }
    
     public PageReference replyToEmail(){
         
        if(thisCase.recordtypeid == Label.KeepITSafe_Case_Rec_Type_Id || thisCase.recordtypeid == Label.LiveVault_Case_Rec_Type_Id)
        {   system.debug('email thread id:'+thisCase.Email_Thread_Id__c);
            if(!thisEmail.Subject.contains(thisCase.Email_Thread_Id__c)){
                thisEmail.Subject = thisEmail.Subject+' '+thisCase.Email_Thread_Id__c;
                if(!thisEmail.Subject.contains(thisCase.CaseNumber))
                thisEmail.Subject = 'Case:'+thisCase.CaseNumber+' '+thisEmail.Subject;
            }
            PageReference p = new PageReference('/_ui/core/email/author/EmailAuthor?email_id='+ thisEmail.Id + '&replyToAll=0&p26=' + thisCase.From1__c + '&p6=' + thisEmail.Subject + '&retURL=%2F' + thisEmail.Id);
            p.setRedirect(true);
            return p;
        }
        else
        {
            PageReference p = new PageReference('/_ui/core/email/author/EmailAuthor?email_id='+ thisEmail.Id + '&replyToAll=0&p26=' + thisCase.From__c + '&retURL=%2F' + thisEmail.Id);
            p.setRedirect(true);
            return p;
        }
    }
    public PageReference replyToAllEmail(){
         
        if(thisCase.recordtypeid == Label.KeepITSafe_Case_Rec_Type_Id|| thisCase.recordtypeid == Label.LiveVault_Case_Rec_Type_Id)
        {   
            if(!thisEmail.Subject.contains(thisCase.Email_Thread_Id__c)){
                thisEmail.Subject = thisEmail.Subject+' '+thisCase.Email_Thread_Id__c;
                if(!thisEmail.Subject.contains(thisCase.CaseNumber))
                thisEmail.Subject = 'Case:'+thisCase.CaseNumber+' '+thisEmail.Subject;
            }
            PageReference p = new PageReference('/_ui/core/email/author/EmailAuthor?email_id='+ thisEmail.Id + '&replyToAll=1&p26=' + thisCase.From1__c + '&p6=' + thisEmail.Subject + '&retURL=%2F' + thisEmail.Id);
            p.setRedirect(true);
            return p;
        }
        else
        {
            PageReference p = new PageReference('/_ui/core/email/author/EmailAuthor?email_id='+ thisEmail.Id + '&replyToAll=1&p26=' + thisCase.From__c + '&retURL=%2F' + thisEmail.Id);
            p.setRedirect(true);
            return p;
        }
    }
}