/* update Lead Billing Address with right full names*/
global class UpdateLeadAddress implements Database.Batchable<sObject>, Database.Stateful {
    
    global Integer recordsProcessed = 0;
    global String query;
    global String oldState;
    global String NewState;
    global String oldCountry;
    global String NewCountry;
    
    global UpdateLeadAddress(String oldState, String NewState, String oldCountry, String NewCountry) {
    this.oldState = oldState;
    this.NewState = NewState;
    this.oldCountry = oldCountry;
    this.NewCountry = NewCountry;
    System.debug('oldState '+ this.oldState +' oldCountry values '+this.oldCountry);
    System.debug('NewState '+ this.NewState +' NewCountry values '+this.NewCountry);
    query= 'SELECT ID, Country FROM Lead WHERE Country =  \'' + this.oldCountry + '\' AND State =  \'' + this.oldState + '\' ';
    System.debug('query values '+query);
    }
    global Database.QueryLocator start(Database.BatchableContext bc ) {
        System.debug('query values :'+query);
        return Database.getQueryLocator(query);
    }
       
    global void execute(Database.BatchableContext bc, List<Lead> scope){
         System.debug('scope values :'+scope);
        List<Lead> leadlist = new List<Lead>();
        // Process each batch of records
        
        for (Lead l: scope) {
            System.debug('scope values :'+l);
            l.State= this.NewState;
            l.Country= this.NewCountry;
            system.debug('New State :'+ l.State +' New Country :'+ l.Country);
            leadlist.add(l);
            // increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
         }
        if(!leadlist.isEmpty())
            update leadlist;
    }
    
    global void finish(Database.BatchableContext bc) {
        
        System.debug(recordsProcessed + 'records processed.');
        AsyncApexJob job = [Select ID, status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob
                            WHERE ID = :bc.getJobId()];
        system.debug('job id :'+ job);
        
    }

}