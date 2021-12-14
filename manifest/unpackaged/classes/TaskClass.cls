public without sharing class TaskClass {

    public static void afterInsert( List<Task> newList )
    {
        List<Case> caseUpdates = new List<Case>();
        Set<Id> caseIds = new Set<Id>();
        for ( Task t: newList ){
            //check if added task is related to case or not
            if ( t.whatId != null && string.valueOf(t.whatId).subString(0,3) == '500' && (t.RecordTypeId == Label.LiveVault_Task_Rec_Type_Id || t.RecordTypeId == Label.KeepITSafe_Task_Rec_Type_Id))  
            {
                caseIds.add(t.whatId);
            } 
         }
        
        // Updates Livevault cases when a Livevault Task is Created or Updated
        for(Case cs : [Select Id, RecordTypeId, Status from Case where Id IN: caseIds])
        {
            if(cs.RecordTypeId == Label.LiveVault_Case_Rec_Type_Id)
            {
                caseUpdates.add(cs);
            } 
             
            // Re-Opens Closed Case when a Keepitsafe Task is Created or Updated    
            else if((cs.Status=='Resolved' || cs.Status=='Closed with no Resolution')&& (cs.RecordTypeId == Label.KeepITSafe_Case_Rec_Type_Id || cs.RecordTypeId == Label.KeepITSafe_AM_Case_Rec_Type_Id))
            {
                cs.Status = 'Re-Opened';
                caseUpdates.add(cs);
            } 
            else caseUpdates.add(cs);
        }
        if(caseUpdates.size() > 0)
        update caseUpdates; 
    }
    
    public static void afterUpdate( List<Task> newList )
    {
        List<Case> caseUpdates = new List<Case>();
        Set<Id> caseIds = new Set<Id>();
        for ( Task t: newList ){
            //check if added task is related to case or not
            if ( t.whatId != null && string.valueOf(t.whatId).subString(0,3) == '500' && (t.RecordTypeId == Label.LiveVault_Task_Rec_Type_Id || t.RecordTypeId == Label.KeepITSafe_Task_Rec_Type_Id))  
            {
                caseIds.add(t.whatId);
            } 
         }
        
        // Updates Livevault cases when a Livevault Task is Created or Updated
        for(Case cs : [Select Id, RecordTypeId, Status from Case where Id IN: caseIds])
        {
            if(cs.RecordTypeId == Label.LiveVault_Case_Rec_Type_Id)
            {
                caseUpdates.add(cs);
            } 
             
            // Re-Opens Closed Case when a Keepitsafe Task is Created or Updated    
            else if((cs.Status=='Resolved' || cs.Status=='Closed with no Resolution')&& (cs.RecordTypeId == Label.KeepITSafe_Case_Rec_Type_Id || cs.RecordTypeId == Label.KeepITSafe_AM_Case_Rec_Type_Id))
            {
                cs.Status = 'Re-Opened';
                caseUpdates.add(cs);
            } 
            //else if((cs.Status=='Inbound message received' || cs.Status!='Working')&& (cs.RecordTypeId == Label.KeepITSafe_Case_Rec_Type_Id || cs.RecordTypeId == Label.KeepITSafe_AM_Case_Rec_Type_Id))
            //{
            //    cs.Status = 'Working';
            //    caseUpdates.add(cs);
            //} 
            else caseUpdates.add(cs);
        }
        if(caseUpdates.size() > 0)
        update caseUpdates; 
    }
    
}