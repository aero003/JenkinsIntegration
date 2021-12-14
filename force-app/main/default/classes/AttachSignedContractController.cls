public class AttachSignedContractController {
    
    public Contract_Request__c contractRequest{get;set;} // get and set values to contract_request__c sObject
    public string contractRequests{get;set;} //picklist selected value/id of contract requests
    Id OpportunityId=apexpages.currentpage().getparameters().get('OpportunityId');
    public boolean Amendment{get;set;}   
    
    //attachment helper created to manage viewstate size.
    public Attachment thisAttachment {
        get {
            if (thisAttachmentHelper == null)
                thisAttachmentHelper = new Attachment();
            return thisAttachmentHelper;
        }
        set{
            thisAttachmentHelper = value;
        }
    }
    //added attachment as transient to control viewstate size.
    public transient Attachment thisAttachmentHelper;
    
    public AttachSignedContractController(ApexPages.StandardController stdController){
        this.contractRequest=(Contract_Request__c)stdController.getRecord();
    }
    
    public List<SelectOption> getItems(){
        System.debug('opportunity id = ' + OpportunityId);
        List<SelectOption> op=new List<SelectOption>();
        op.add(new SelectOption('--None--','--None--'));
        for(Contract_Request__c	cr:[Select Id, Name from Contract_Request__c where Opportunity__c=:OpportunityId order by Name DESC]){
            op.add(new SelectOption(cr.Id,cr.Name));
        }

        return op;
    }
    //Added this method to autopopulate other fields from contract request on page based on dropdown value
    public void ValuesForContractRequest(){
        contractRequest = new Contract_Request__c();
        
        if(contractRequests != null && contractRequests != '--None--'){
            contractRequest = [Select Id, Expiration_Date_of_Contract__c, Term_of_Contract__c, Name ,Other_Term_of_Contract__c, Term_of_Amendment__c, Term_of_Amendment_Units__c, Contract_Value__c from Contract_Request__c where Id=:contractRequests];
            System.debug('contractRequest'+contractRequest);       
        }
    }
    
    public pageReference doSave(){
        Contract_Request__c cntrct = new Contract_Request__c();
       
        //Update Contract_Request__c sObject
        try{
            cntrct=[select Id, Name, Expiration_Date_of_Contract__c,Term_of_Contract__c,Term_of_Amendment__c, Term_of_Amendment_Units__c, Contract_Value__c,Other_Term_of_Contract__c from Contract_Request__c where Id = :contractRequests ];
            if(contractRequest.Expiration_Date_of_Contract__c != null){
                cntrct.Expiration_Date_of_Contract__c=contractRequest.Expiration_Date_of_Contract__c;
            }
            if(contractRequest.Term_of_Contract__c != null){
                cntrct.Term_of_Contract__c=contractRequest.Term_of_Contract__c;
            }
            if(contractRequest.Contract_Value__c != null){
                cntrct.Contract_Value__c=contractRequest.Contract_Value__c;
            }
            if(contractRequest.Other_Term_of_Contract__c != null){
                cntrct.Other_Term_of_Contract__c=contractRequest.Other_Term_of_Contract__c;
            }
            if(contractRequest.Term_of_Amendment__c != null){
                cntrct.Term_of_Amendment__c=contractRequest.Term_of_Amendment__c;
            } 
            if(contractRequest.Term_of_Amendment_Units__c != null){
                cntrct.Term_of_Amendment_Units__c=contractRequest.Term_of_Amendment_Units__c;
            } 
            
            update cntrct;          
            
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
            ApexPages.addMessage(msg);
            return null;
        }
        //Insert attachment in Opportunity
        if(thisAttachmentHelper.Name !=null){
            try{
                Attachment a = new Attachment(parentid=OpportunityId, Name = cntrct.Name + ' ' + thisAttachmentHelper.Name , Body = thisAttachmentHelper.body );
                system.debug('attachment name = ' + cntrct.Name + ' ' + thisAttachmentHelper.Name);
                insert a;  
                Opportunity opp=[select Id, isSignContractAttached__c from Opportunity where Id=:OpportunityId];
                opp.isSignContractAttached__c = true;
                update opp;   
            }
            catch(Exception ex){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage());
                ApexPages.addMessage(msg);
                return null;
            }
        }
        
        
         //Update Opportunity Stage Name to "Closed Won" 
        if(OpportunityId!=null){
            try{
                Opportunity opp=[select Id, StageName from Opportunity where Id=:OpportunityId];
                if(opp.StageName != 'Closed Won'){
                    opp.StageName='Closed Won';
                    update opp;        
                }
            }
            catch(Exception e){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, e.getMessage());
                ApexPages.addMessage(msg);
                return null;
            }
        }              
        
        return new PageReference('javascript:window.opener.location.href='+'\'/'+OpportunityId+'\';window.close();'); 
    }
}