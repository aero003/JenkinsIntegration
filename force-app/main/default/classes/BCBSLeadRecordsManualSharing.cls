public class BCBSLeadRecordsManualSharing {
    public static boolean manualShareRead(Map<Id, Id> recordId_userOrGroupId){
        
        // Create new sharing object for the custom object Job.
        List<LeadShare> lst_leadShr  = new List<LeadShare>();
        
        for(Id recId : recordId_userOrGroupId.keySet()){
            
            LeadShare leadShr = new LeadShare();
            
            // Set the ID of record being shared.
            leadShr.LeadId = recId;
            
            // Set the ID of user or group being granted access.
            leadShr.UserOrGroupId = recordId_userOrGroupId.get(recId);
            
            // Set the access level.
            leadShr.LeadAccessLevel = 'Read';
            
            
            // Set rowCause to 'manual' for manual sharing.
            // This line can be omitted as 'manual' is the default value for sharing objects.
            leadShr.RowCause = Schema.LeadShare.RowCause.Manual;
            lst_leadShr.add(leadShr);
        }
        
        // Insert the sharing record and capture the save result. 
        // The false parameter allows for partial processing if multiple records passed 
        // into the operation.
        Boolean Result = false;
        
        List<Database.SaveResult> srList = Database.insert(lst_leadShr,false);
        
        for(Database.SaveResult sr : srList){ 
            // Process the save results.
            if(sr.isSuccess()){
                // Indicates success
                Result = true;
            }
            else {
                // Get first save result error.
                Database.Error err = sr.getErrors()[0];
                
                // Check if the error is related to trival access level.
                // Access level must be more permissive than the object's default.
                // These sharing records are not required and thus an insert exception is acceptable. 
                Result = err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                    err.getMessage().contains('AccessLevel') ? true : false; 
            }
        }       
        return Result;
    }
}