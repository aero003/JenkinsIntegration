/* update Contact Billing Address with right full names*/
global class UpdateContactAddress implements Database.Batchable<sObject>, Database.Stateful {
    
    global Integer recordsProcessed = 0;
    global String query;
    global String oldState;
	global String NewState;
    global String oldCountry;
    global String NewCountry;
    
    global UpdateContactAddress(String oldState, String NewState,  String oldCountry, String NewCountry) {
    this.oldState = oldState;
    this.NewState = NewState;
    this.oldCountry = oldCountry;
    this.NewCountry = NewCountry;
    System.debug('oldCountry values '+this.oldCountry);
    System.debug('NewCountry values '+this.NewCountry);
    query= 'SELECT ID, MailingCountry FROM Contact WHERE MailingState =  \'' + this.oldState + '\' AND MailingCountry =  \'' + this.oldCountry + '\'';
    System.debug('query values '+query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc ) {
        System.debug('query values :'+query);
        return Database.getQueryLocator(query);
    }
       
    global void execute(Database.BatchableContext bc, List<Contact> scope){
         System.debug('scope values :'+scope);
        List<Contact> conlist = new List<Contact>();
        // Process each batch of records
        
        for (Contact c: scope) {
            System.debug('scope values :'+c);
            c.MailingState= this.NewState;
            c.MailingCountry= this.NewCountry;
            system.debug('New MailingState :'+ c.MailingState +' New MailingCountry :'+c.MailingCountry);
            conlist.add(c);
            // increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
         }
        if(!conlist.isEmpty())
            update conlist;
    }
    
    global void finish(Database.BatchableContext bc) {
        
        System.debug(recordsProcessed + 'records processed.');
        AsyncApexJob job = [Select ID, status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob
                            WHERE ID = :bc.getJobId()];
        system.debug('job id :'+ job);
        
    }
}