public class BCBSAccountRecordsManualSharing {
    
    public static void addAccounts(){
        Map<Id,Id> recordId_OldOwnerId = new Map<Id,Id>();
        //provide Account record Id as Key and Old Owner Id as Value in the Map 
        //to provide Read access to the Owner

        //recordId_OldOwnerId.put('0010e00001JxhnbAAB','00560000001GFtDAAW');
        
        // Temporarliy fix - because the user with ID '00560000001GFtDAAW' is inactive, therefore the test BCBSAccountRecordsManualSharingTest fails
        recordId_OldOwnerId.put('0010e00001JxhnbAAB','0050e000008br7aAAA');
		recordId_OldOwnerId.put('0016000000NwO94AAF','00560000001EusaAAC');
        manualShareRead(recordId_OldOwnerId);
    }
    
    
    public static boolean manualShareRead(Map<Id, Id> recordId_userOrGroupId){
        // Create new sharing object for the custom object Job.
        List<AccountShare> lst_accShr  = new List<AccountShare>();
        
        for(Id recId : recordId_userOrGroupId.keySet()){
            
            AccountShare accShr = new AccountShare();
            
            // Set the ID of record being shared.
            accShr.AccountId = recId;
            
            // Set the ID of user or group being granted access.
            accShr.UserOrGroupId = recordId_userOrGroupId.get(recId);
            
            // Set the access level.
            accShr.AccountAccessLevel = 'Read';
            accShr.OpportunityAccessLevel = 'Read';
            
            // Set rowCause to 'manual' for manual sharing.
            // This line can be omitted as 'manual' is the default value for sharing objects.
            accShr.RowCause = Schema.AccountShare.RowCause.Manual;
            lst_accShr.add(accShr);
        }
        
        // Insert the sharing record and capture the save result. 
        // The false parameter allows for partial processing if multiple records passed 
        // into the operation.
        List<Database.SaveResult> srList = Database.insert(lst_accShr,true);
        
        Boolean Result = false;
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
                if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                   err.getMessage().contains('AccessLevel')){
                       // Indicates success.
                       Result = true;
                   }
                else{
                    // Indicates failure.
                    Result = false;
                }
            }
        }
        return Result;
    }
}