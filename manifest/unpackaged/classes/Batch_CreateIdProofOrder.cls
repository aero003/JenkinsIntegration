global class Batch_CreateIdProofOrder implements Database.Batchable<SObject> {
    public List<SBQQ__Quote__c> quoteToUpdate;
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = '';
        query  = 'SELECT Id,IdProofed__c,SBQQ__Ordered__c FROM SBQQ__Quote__c WHERE IdProofed__c = TRUE AND SBQQ__Ordered__c = FALSE';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<SBQQ__Quote__c> scope){
        quoteToUpdate = new List<SBQQ__Quote__c>();
        for(SBQQ__Quote__c quote : scope){
            quote.SBQQ__Ordered__c = TRUE;
            quoteToUpdate.add(quote);
        }
        if(quoteToUpdate != NULL && !quoteToUpdate.isEmpty()){
            update quoteToUpdate;
        }
    }
    global void finish(Database.BatchableContext BC){}
}