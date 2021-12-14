public class Conensus_Billing_Stamp_Controller {
    public Account accRec{get;set;}
    public boolean displayPopup {get;set;} 
    public String AccountID = '';
    public boolean bool{get;set;}
    public Conensus_Billing_Stamp_Controller(ApexPages.StandardController controller){
        Account record = (Account) controller.getRecord();
        AccountID = record.Id;
        accRec = (Account)controller.getRecord();
        bool = true;
    }
    
    public void showPopup(){
        isIDProofing();
    } 
    
    public PageReference closePopup(){
        PageReference pg = new PageReference('/'+AccountID);
        return pg.setRedirect(true);
    }
    
    public PageReference isIDProofing(){
        displayPopup = true;
        Account acc = [SELECT Id,Billing_Stamp__c FROM Account WHERE Id=:accRec.Id];
        acc.Billing_Stamp__c = datetime.now();
        
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        List<SBQQ__Quote__c> quotes = [SELECT Id,SBQQ__Primary__c,SBQQ__Ordered__c,SBQQ__Account__c,SBQQ__Account__r.Corp_ID__c,SBQQ__Opportunity2__c FROM SBQQ__Quote__c 
                                       WHERE SBQQ__Primary__c = TRUE AND SBQQ__Opportunity2__r.IsClosed = TRUE AND SBQQ__Account__r.Corp_ID__c != NULL AND SBQQ__Opportunity2__r.AccountId=:accRec.Id];
        for(SBQQ__Quote__c sbQuote: quotes){
           // sbQuote.SBQQ__Ordered__c = TRUE;
            sbQuote.IdProofed__c = TRUE;
            quoteList.add(sbQuote);
        }
        
        try{
            if(quoteList!=Null && !quoteList.isEmpty()){
                bool = true;
                update acc;
                update quoteList;
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Billing Stamp Updated Successfully'));
            }else{
                bool = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Please ensure that Account has Application ID and Corp ID and Opportunity is closed won with a primary quote!'));
            } 
        }catch(DMLException e){
            displayPopup = false;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Record creation failed: ' + e.getMessage()));
        }
        
        return NULL;//new PageReference('/'+accRec.Id).setRedirect(true);
    }
    public Boolean boolValue(){
        system.debug('bool2-->'+bool);
        return bool;
    }
    Public PageReference billingStamp(){ 
        Pagereference pr;
        displayPopup = false;
        if(displayPopup == False){
            pr = new PageReference('/'+AccountID).setRedirect(true);
            return pr;
        }else{
            return null;
        }
    }
}