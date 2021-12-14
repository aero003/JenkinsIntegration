/* update Account Billing Address with right full names*/
global class UpdateAccountAddress implements Database.Batchable<sObject>, Database.Stateful {
    
    global Integer recordsProcessed = 0;
    global String query;
    global String oldState;
	global String NewState;
	global String oldCountry;
	global String NewCountry;
    
    global UpdateAccountAddress(String oldState, String NewState,  String oldCountry, String NewCountry) {
    this.oldState = oldState;
    this.NewState = NewState;
    this.oldCountry = oldCountry;
    this.NewCountry = NewCountry;
    System.debug('oldState '+ this.oldState +'oldCountry values '+this.oldCountry);
    System.debug('NewState '+ this.NewState +'NewCountry values '+this.NewCountry);
    query= 'SELECT ID, BillingState, BillingCountry FROM Account WHERE BillingState = \'' + this.oldState + '\' AND BillingCountry =  \'' + this.oldCountry + '\'';
    System.debug('query values '+query);
	}
    
    
        
    global Database.QueryLocator start(Database.BatchableContext bc ) {
        System.debug('query values :'+query);
        return Database.getQueryLocator(query);
    }
       
    global void execute(Database.BatchableContext bc, List<Account> scope){
         System.debug('scope values :'+scope);
        List<Account> acclist = new List<Account>();
        // Process each batch of records
        
        for (Account a: scope) {
            System.debug('scope values :'+a);
            a.BillingState = this.NewState;
            a.BillingCountry= this.NewCountry;
            system.debug('New BillingState :'+ a.BillingState +' New BillingCountry :'+ a.BillingCountry);
            acclist.add(a);
			// increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
         }
        if(!acclist.isEmpty())
            update acclist;
    }
    
    global void finish(Database.BatchableContext bc) {
        
        System.debug(recordsProcessed + 'records processed.');
        AsyncApexJob job = [Select ID, status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob
                            WHERE ID = :bc.getJobId()];
        system.debug('job id :'+ job);
        
    }
}