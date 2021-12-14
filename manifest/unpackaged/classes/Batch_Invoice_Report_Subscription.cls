global class Batch_Invoice_Report_Subscription implements Database.Batchable<sObject>, Database.Stateful{
    String QueryString='';
    String batchProcessName;
    Integer LineNumber = 0;
    global Batch_Invoice_Report_Subscription(String name) {
        batchProcessName = name;
    }
    global Database.QueryLocator start(Database.BatchableContext bc){        
        if(batchProcessName == 'cpq') {
            //QueryString = 'SELECT Id,SBQQ__Account__r.Status__c,SBQQ__Account__r.Brand__c,SBQQ__Account__r.Corp_ID__c,SBQQ__Subscription__r.SBQQ__QuoteLine__r.SBQQ__Quote__r.Opportunity.StageName FROM SBQQ__Subscription__c WHERE SBQQ__Subscription__r.SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__Primary__c= TRUE AND SBQQ__Subscription__r.SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__Ordered__c = TRUE AND SBQQ__Account__r.Corp_ID__c != NULL AND SBQQ__Account__r.Brand__c = \'Consensus\' AND SBQQ__Account__r.Status__c != \'InActive\' AND SBQQ__Subscription__r.SBQQ__QuoteLine__r.SBQQ__Quote__r.Opportunity.StageName != \'Closed Lost\'';
            QueryString = 'SELECT Id,SBQQ__Account__r.Status__c,SBQQ__Account__r.Brand__c,SBQQ__Account__r.Corp_ID__c,SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__Opportunity2__r.StageName FROM SBQQ__Subscription__c WHERE SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__Primary__c= TRUE AND SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__Ordered__c = TRUE AND SBQQ__Account__r.Corp_ID__c != NULL AND SBQQ__Account__r.Brand__c = \'Consensus\' AND SBQQ__Account__r.Status__c != \'InActive\' AND SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__Opportunity2__r.StageName != \'Closed Lost\'';
            system.debug('QueryString'+QueryString);
        }
        return Database.getQueryLocator(QueryString);
    }
    global void execute(Database.BatchableContext bc,List<SBQQ__Subscription__c> subscriptionlist){
        List<Consensus_Invoice_Line_Item__c> montlyInvoiceList = new List<Consensus_Invoice_Line_Item__c>();
        if(batchProcessName == 'cpq') {
            List<SBQQ__Subscription__c> SubList = (List<SBQQ__Subscription__c>)subscriptionlist;
            Consensus_Invoice__c inv = new Consensus_Invoice__c();
            for(SBQQ__Subscription__c sub:[SELECT Id,SBQQ__Account__c FROM SBQQ__Subscription__c  
                                           WHERE Id IN :subscriptionlist ]){
                                               //for(SBQQ__Subscription__c sub : SubList) {                
                                               inv.Account__c = sub.SBQQ__Account__c;
                                               system.debug('Account Name'+inv.Account__c);
                                               system.debug('sub Name'+SubList);
                                               
                                           }
            insert inv;
            Date updateToCurrentMonth = System.today();
            
            Integer numberOfDays = Date.daysInMonth(updateToCurrentMonth.year(), updateToCurrentMonth.month()-1);
            Date lastDayOfMonth = Date.newInstance(updateToCurrentMonth.year(), updateToCurrentMonth.month()-1, numberOfDays);
            
            
            //Date updateToCurrentMonth = System.today();//defaultDate.Consensus_Date__c;//Date.parse('04/30/2021');//System.today();
            DateTime currentMonth1 = lastDayOfMonth;
            
            String yearString1 = currentMonth1.format('YYYY');
            Integer numberOfDaysTday = Date.daysInMonth(updateToCurrentMonth.year(), updateToCurrentMonth.month());
            
            Consensus_Invoice_Line_Item__c montlyInvoice = new Consensus_Invoice_Line_Item__c();
            montlyInvoice.Name = numberOfDaysTday+''+yearString1+'C-'+LineNumber;
            montlyInvoice.Consensus_Invoice__c  =  inv.Id;
            montlyInvoiceList.add(montlyInvoice);
            LineNumber++;
        }
        try{
            if(montlyInvoiceList.size() > 0){
                insert montlyInvoiceList;
            }
            
        }catch(exception e){
            system.debug('monthly or training >>'+e.getMessage());
        }
        
    }
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}