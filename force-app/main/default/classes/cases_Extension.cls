public with sharing class cases_Extension {

    public case thisCase {get;set;}
    public List<Case> theseCases {get;set;}
    
    public cases_Extension(ApexPages.StandardController controller){
        this.thisCase = (Case) controller.getRecord();
        this.theseCases = new List<Case>();
    }
    
    public cases_Extension(ApexPages.StandardSetController controller){
        this.theseCases = (List<Case>) controller.getRecords();
    }


    public PageReference insertAndRedirect(){
        //If DID__c is populated, Query DIDs
        if ( thisCase.Did__c != null  && (thisCase.AccountId == null || thisCase.ContactId == null )){
            List<DID__c> didQuery = [Select Id, Account__c, Contact__c from DID__c where Id = :thisCase.Did__c limit 1];
            if ( didQuery.size() > 0 ){
                DID__c thisDid = didQuery[0];
                if ( thisCase.AccountId == null && thisDID.Account__c != null ){
                    thisCase.AccountId = thisDID.Account__c;
                } 
                if ( thisCase.ContactId == null && thisDID.Contact__c != null ){
                    thisCase.ContactId = thisDID.Contact__c;
                } 
            } 
        }

       thiscase.Is_Livevault_Email_Not_Sent__c = True;
       insert thisCase;
       String url = '/'+thisCase.id+'/e?retURL=' + EncodingUtil.urlEncode('/500/o','UTF-8');
       PageReference p = new PageReference(url);
       return p;
        
    }

    public PageReference getNextCase(){
        //Determine current user
        Id userId = userinfo.getUserId();
        Set<Id> listQueueIds = new Set<id>();
        Set<Id> myQueueIds = new Set<id>();
        List<Case> caseQuery = new List<Case>();
        
        if ( theseCases.size() > 0 ){
            for ( Case c : theseCases ){
                if ( string.valueOf(theseCases[0].OwnerId).subString(0,3) != '005' ){
                    myQueueIds.add( theseCases[0].OwnerId );
                }
            }
            if ( myQueueIds.size() > 0 ){
                caseQuery = [Select Id, CreatedDate, IsClosed from Case where OwnerId in :myqueueIds and IsClosed != TRUE order by CreatedDate asc limit 1];
            }
        }

        if ( caseQuery.size() == 0){
            for ( GroupMember gm : [Select UserOrGroupId, Group.Type, Group.RelatedId, Group.Name, GroupId From GroupMember where Group.Type = 'Queue' and UserOrGroupId = :userId]){
                listQueueIds.add(gm.GroupId);
            }
            caseQuery = [Select Id, CreatedDate, IsClosed from Case where OwnerId in :listQueueIds and IsClosed != TRUE order by CreatedDate asc limit 1];
        }

        if ( caseQuery.size() > 0 ){
            thisCase = caseQuery[0];
            thisCase.OwnerId = userId;
            update thisCase;
            PageReference p = new PageReference('/'+thisCase.id);
            return p;
        } else {
            PageReference p = new PageReference('/500/o');
            return p;
        }
    }

    public PageReference replyToCase(){
        if ( string.valueOf(thisCase.OwnerId).subString(0,3) != '005' ){
            thisCase.OwnerId = userInfo.getUserId();
            update thisCase;
        }
        String templateId = '00X60000000xlFf';  //Production
 
        
        if(thisCase.recordtypeid == Label.KeepITSafe_Case_Rec_Type_Id || thisCase.recordtypeid == Label.LiveVault_Case_Rec_Type_Id)
        {
            system.debug('email thread id of case ' + thisCase.Email_Thread_Id__c);
            if(!thisCase.Subject.contains(thisCase.Email_Thread_Id__c)){
                thisCase.Subject = thisCase.Subject+'   '+thisCase.Email_Thread_Id__c;
                if(!thisCase.Subject.contains(thisCase.CaseNumber))
                thisCase.Subject = 'Case:'+thisCase.CaseNumber+' '+thisCase.Subject;
            }
            if(thisCase.Additional_to__c  == null){
                thisCase.Additional_to__c = '';
            }
            if(thisCase.Bcc__c == null){
                thisCase.Bcc__c = '';
            }
            if(thisCase.Cc__c == null){
                thisCase.Cc__c = '';
            }
            PageReference p = new PageReference('/_ui/core/email/author/EmailAuthor?p2_lkid='+ thisCase.ContactId + '&p3_lkid=' +  thisCase.Id + '&rtype=003&p26=' + thisCase.From1__c + '&p6=' + thisCase.Subject+ '&p4='+ thisCase.CC__c +'&p5='+ thisCase.BCC__c +'&p24='+ thisCase.Additional_to__c +'&p23&retURL=%2F' + thisCase.Id);
            p.setRedirect(true);
            return p;
            
        }
        else
        {
            if(thisCase.Additional_to__c  == null){
                thisCase.Additional_to__c = '';
            }
            if(thisCase.Bcc__c == null){
                thisCase.Bcc__c = '';
            }
            if(thisCase.Cc__c == null){
                thisCase.Cc__c = '';
            }
            PageReference p = new PageReference('/_ui/core/email/author/EmailAuthor?p2_lkid='+ thisCase.ContactId + '&p3_lkid=' +  thisCase.Id + '&rtype=003&p26=' + thisCase.From__c + '&p6=' + thisCase.Subject+ '&p4='+ thisCase.CC__c +'&p5='+ thisCase.BCC__c +'&p24='+ thisCase.Additional_to__c +'&p23=&retURL=%2F' + thisCase.Id);
            p.setRedirect(true);
            return p;
        }
       //PageReference p = new PageReference('/_ui/core/email/author/EmailAuthor?p2_lkid='+ thisCase.ContactId + '&p3_lkid=' +  thisCase.Id + '&rtype=003&template_id=' + templateId + '&p26=' + thisCase.From__c + '&retURL=%2F' + thisCase.Id);
        //p.setRedirect(true);
        //return p;
    }
    
    public PageReference replyToAll(){
        if ( string.valueOf(thisCase.OwnerId).subString(0,3) != '005' ){
            thisCase.OwnerId = userInfo.getUserId();
            update thisCase;
        }
        String templateId = '00X60000000xlFf';  //Production
        
        
        if(thisCase.recordtypeid == Label.KeepITSafe_Case_Rec_Type_Id || thisCase.recordtypeid == Label.LiveVault_Case_Rec_Type_Id)
        {
             system.debug('email thread id of case ' + thisCase.Email_Thread_Id__c);
            if(!thisCase.Subject.contains(thisCase.Email_Thread_Id__c)){
                thisCase.Subject = thisCase.Subject+'   '+thisCase.Email_Thread_Id__c;
                if(!thisCase.Subject.contains(thisCase.CaseNumber))
                thisCase.Subject = 'Case:'+thisCase.CaseNumber+' '+thisCase.Subject;
            }
            if(thisCase.Additional_to__c  == null){
                thisCase.Additional_to__c = '';
            }
            if(thisCase.Bcc__c == null){
                thisCase.Bcc__c = '';
            }
            if(thisCase.Cc__c == null){
                thisCase.Cc__c = '';
            }
            PageReference p = new PageReference('/_ui/core/email/author/EmailAuthor?p2_lkid='+ thisCase.ContactId + '&replyToAll=1&p3_lkid=' +  thisCase.Id + '&rtype=003&p26=' + thisCase.From1__c + '&p6=' + thisCase.Subject+ '&p4='+ thisCase.CC__c +'&p5='+ thisCase.BCC__c +'&p24='+ thisCase.Additional_to__c +'&p23&retURL=%2F' + thisCase.Id);
            p.setRedirect(true);
            return p;
        }
        else
        {    
            if(thisCase.Additional_to__c  == null){
                thisCase.Additional_to__c = '';
            }
            if(thisCase.Bcc__c == null){
                thisCase.Bcc__c = '';
            }
            if(thisCase.Cc__c == null){
                thisCase.Cc__c = '';
            }
            PageReference p = new PageReference('/_ui/core/email/author/EmailAuthor?p2_lkid='+ thisCase.ContactId + '&replyToAll=1&p3_lkid=' +  thisCase.Id + '&rtype=003&p26=' + thisCase.From__c + '&p6=' + thisCase.Subject+ '&p4='+ thisCase.CC__c +'&p5='+ thisCase.BCC__c +'&p24='+ thisCase.Additional_to__c +'&p23=&retURL=%2F' + thisCase.Id);
            p.setRedirect(true);
            return p;
        }
    }
}