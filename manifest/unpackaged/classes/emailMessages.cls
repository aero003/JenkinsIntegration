public without sharing class emailMessages {
    
    public static void afterInsert( List<EmailMessage> newList ){
        List<Case> caseUpdates = new List<Case>();
        Map<Id,String> caseIds = new Map<Id,String>();
        Set<Id> incomingCaseIds = new Set<Id>();
        for ( EmailMessage e : newList ){
            if ( e.parentId != null){
                if ( string.valueOf(e.parentId).subString(0,3) == '500' )   {
                    caseIds.put(e.parentId,e.Status);
                    if(e.Incoming)
                        incomingCaseIds.add(e.parentId);
                }
            }
        }
        for ( Case c : [Select Id,Subject,Description,Status,Email_Status__c, isclosed,RecordTypeId, Region__c,OwnerId, Owner.Type, Owner.IsActive from Case where Id in :caseIds.keySet()]){
            //if case is closed and record type is keepitsafe, re-open case and assign it to appropriate queue according to region.
            if(c.IsClosed == true && incomingCaseIds.contains(c.Id) && c.RecordTypeId== Label.KeepITSafe_Case_Rec_Type_Id)
            {
                c.Status = 'Inbound message received'; 
                c.Email_Status__c=caseIds.get(c.ID);
                //string casedescription = c.Description;
                //casedescription = 'owner is active =' + c.Owner.IsActive + '--- assert owner type =' + c.Owner.Type + ' --- Region is ' + c.Region__c + ' --- case record type id = '+ c.RecordTypeId;
               
                if(c.Owner.Type != 'Queue' && c.Owner.IsActive == False ){
                    system.debug('Region is ' + c.Region__c);
                    if(c.Region__c == 'US' || c.Region__c == 'Canada') {
                        c.OwnerId = '00G320000034NxGEAU';
                    } else if(c.Region__c == 'DK'){
                        //c.OwnerId = '00G0S000000cICrUAM'; //qafull
                        c.OwnerId = '00G0e000003KaevEAC'; //production.
                    } else {
                        c.OwnerId = '00G320000034NxLEAU';
                    }
                }
                //c.Description = casedescription;
            }
            //if case is of livevault or keepitsafe Change status to Inbound message received.
            else if((c.IsClosed == false || c.IsClosed == true) && incomingCaseIds.contains(c.Id) && (c.RecordTypeId == Label.LiveVault_Case_Rec_Type_Id || c.RecordTypeId == Label.KeepITSafe_Case_Rec_Type_Id))
            {
                c.Status = 'Inbound message received'; 
                c.Email_Status__c=caseIds.get(c.ID);
            }
            //if case is closed and record type is other than keepitsafe or livevault then change case status to Re-opened.
            else if(c.IsClosed == true && incomingCaseIds.contains(c.Id) && (c.RecordTypeId != Label.LiveVault_Case_Rec_Type_Id || c.RecordTypeId != Label.KeepITSafe_Case_Rec_Type_Id))
            {
                //if((c.OwnerId!='00G60000001A7N2'||c.OwnerId!='00G60000001CriY'||c.OwnerId!='00G60000001CriT'||c.OwnerId!='00G60000001lqPu'||c.OwnerId!='00G60000001lCtC')&&((!c.Subject.contains('cancel'))||(!c.Description.contains('cancel'))))
                //{
                    c.Status = 'Re-Opened';    
                	c.Email_Status__c=caseIds.get(c.ID);
                //}
                //else
                //{
                //    c.Status = 'Closed';    
                //	c.Email_Status__c=caseIds.get(c.ID);
                //}
            }
            else if(caseIds.containsKey(c.Id))
                c.Email_Status__c=caseIds.get(c.ID);
            caseUpdates.add(c);         
        }       
        if ( caseUpdates.size() > 0 ){
            database.update(caseUpdates, false);
        }
    }
    
}