global class Batch_ETLUpdate implements Database.Batchable<SObject>,Database.Stateful{
    public List<Account> acToUpdate;
    public List<Account_Fax__c> accFaxList;
    global List<String> exception_List;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query='';
        String status = 'Completed';
        query = 'SELECT Id,Acct_End_Date__c,Acct_Start_Date__c,Account_Type__c,Accounts_Payable__c,Address_Line_3__c,'+
                  		'Admin__c,Application_Id__c,BillingCity__c,BillingCountry__c,BillingPostalCode__c,BillingStreet__c,Brand__c,Closed_On__c,'+
                        'Closed_Reason__c,Collection_Method__c,Currency__c,Customer_ID__c,Reseller_ID__c,Sales_Group__c,'+
                        'Reseller_Name__c,Sales_Rep__c,Secure__c,Source_System_Notes__c,Corp_ID__c,Status__c,Update_Status__c'+
                ' FROM Account_Fax__c WHERE Update_Status__c!=:status';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account_Fax__c> scope){
        
        accFaxList = new List<Account_Fax__c>();
        acToUpdate = new List<Account>();
        for(Account_Fax__c ax:scope){
            if(ax.Application_Id__c == Null || ax.Application_ID__c == ''){
                ax.Status_Description__c = 'Application Id is Blank';
                ax.Update_Status__c = 'Failed';
                accFaxList.add(ax);
            }else{
            List<Account> actList2 = [SELECT Id,Acct_End_Date__c,Acct_Start_Date__c,Account_Type__c,Accounts_Payable__c,Address_Line_3__c,
                                      Admin__c,BillingCity__c,Application_Id__c,BillingCountry__c,
                                      Brand__c,Closed_On__c,Closed_Reason__c,Collection_Method__c,Currency__c,Customer_ID__c,Reseller_ID__c,
                                      Sales_Group__c,Reseller_Name__c,Sales_Rep__c,Secure__c,Source_System_Notes__c,Corp_ID__c,Status__c
                                      FROM Account WHERE Application_Id__c !=null AND Application_Id__c =: ax.Application_Id__c];
            
            if(actList2.size() == 0 || (actList2.size() == NULL && actList2.isEmpty())){
                ax.Status_Description__c = 'No match is found';
                ax.Update_Status__c = 'Failed';
                accFaxList.add(ax);
            }
            else if(actList2.size() > 1){
                ax.Status_Description__c = 'Duplicate records found (more than one account having same application ID)';
                ax.Update_Status__c = 'Failed';
                accFaxList.add(ax);
            }
            else if(actList2.size() == 1){
                if(actList2[0].Corp_ID__c != NULL && ax.Corp_ID__c != NULL && ax.Corp_ID__c != actList2[0].Corp_ID__c){
                    ax.Status_Description__c = 'CORP ID Mismatch';
                    ax.Update_Status__c = 'Failed';
                    accFaxList.add(ax);
                }else{
                    try{
                        if(ax.Acct_End_Date__c!=null) actList2[0].Acct_End_Date__c = ax.Acct_End_Date__c;
                        if(ax.Acct_Start_Date__c!=null) actList2[0].Acct_Start_Date__c = ax.Acct_Start_Date__c;
                        if(ax.Account_Type__c!=null) actList2[0].Account_Type__c = ax.Account_Type__c;
                        if(ax.Accounts_Payable__c!=null) actList2[0].Accounts_Payable__c = ax.Accounts_Payable__c;
                        if(ax.Address_Line_3__c!=null) actList2[0].Address_Line_3__c = ax.Address_Line_3__c;
                        if(ax.Admin__c!=null) actList2[0].Admin__c = ax.Admin__c;
                        if(ax.BillingCity__c!=null) actList2[0].BillingCity__c = ax.BillingCity__c;
                        if(ax.BillingCountry__c!=null) actList2[0].BillingCountry__c = ax.BillingCountry__c;
                        if(ax.BillingPostalCode__c!=null) actList2[0].BillingPostalCode__c = ax.BillingPostalCode__c;
                        if(ax.BillingStreet__c!=null) actList2[0].BillingStreet__c = ax.BillingStreet__c;
                        if(ax.Brand__c!=null) actList2[0].Brand__c = ax.Brand__c;
                        if(ax.Closed_On__c!=null) actList2[0].Closed_On__c = ax.Closed_On__c;
                        if(ax.Closed_Reason__c!=null) actList2[0].Closed_Reason__c = ax.Closed_Reason__c;
                        if(ax.Collection_Method__c!=null) actList2[0].Collection_Method__c = ax.Collection_Method__c;
                        if(ax.Corp_ID__c!=null)	actList2[0].Corp_ID__c = ax.Corp_ID__c;
                        if(ax.Currency__c!=null) actList2[0].Currency__c = ax.Currency__c;
                        if(ax.Customer_ID__c!=null)	actList2[0].Customer_ID__c = ax.Customer_ID__c;
                        if(ax.Reseller_ID__c!=null)	actList2[0].Reseller_ID__c = ax.Reseller_ID__c;
                        if(ax.Sales_Group__c!=null)	actList2[0].Sales_Group__c = ax.Sales_Group__c;
                        if(ax.Reseller_Name__c!=null) actList2[0].Reseller_Name__c = ax.Reseller_Name__c;
                        if(ax.Sales_Rep__c!=null) actList2[0].Sales_Rep__c = ax.Sales_Rep__c;
                        if(ax.Secure__c!=null) actList2[0].Secure__c = ax.Secure__c;
                        if(ax.Source_System_Notes__c!=null)	actList2[0].Source_System_Notes__c = ax.Source_System_Notes__c;
                        if(ax.Status__c!=null) actList2[0].Status__c = ax.Status__c;
                        acToUpdate.add(actList2[0]);
                        ax.Status_Description__c = 'Update successful';
                        ax.Update_Status__c = 'Completed';
                        accFaxList.add(ax);
                    }catch(Exception ex){
                        ax.Status_Description__c = 'The account is facing validation error/process error. kindly review the account record->'+ax.Id;
                        ax.Update_Status__c = 'Failed';
                        accFaxList.add(ax);
                    }
                }
            }
            }
        }
        
        if(acToUpdate!=NULL && !acToUpdate.isEmpty()){
            update acToUpdate;
        }
        
        if(!accFaxList.isEmpty()){
            Database.SaveResult[] updateResults = Database.update(accFaxList, false);
            List<Account_Fax__c> afaxList = new List<Account_Fax__c>();
            for(Integer i=0;i<updateResults.size();i++){
                if(!updateResults.get(i).isSuccess()){
                    Database.Error errors =  updateResults.get(i).getErrors().get(0);
                    Account_Fax__c afax = new Account_Fax__c();
                    afax.Update_Status__c = 'Failed';
                    afax.Status_Description__c = 'The account is facing validation error/process error. kindly review the account record->';
                    afaxList.add(afax);
                }                
            }
            if(afaxList.size()>0) update afaxList;
        }
        
    }
    global void finish(Database.BatchableContext BC){}
}