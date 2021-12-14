public with sharing class OpportunityProcessingClass {
    
    Map <Opportunity,List<String>> oppEmailMap = new Map <Opportunity,List<String>> ();
    Map <Id,String> managerEmailMap = new Map <Id,String> ();
    Set <Id> managerIdSet = new Set <Id> ();
    
    public void processWonOpportunities (list <Opportunity> opplist){
        
        for(Opportunity opp:opplist){
            managerIdSet.add(opp.Owner.ManagerId);
        }
        
        list <User> userlist = [select id,email from User where ID IN:managerIdSet];
        
            for(User u : userlist){
                managerEmailMap.put(u.Id,u.Email);
            }
        
        
            for(Opportunity opp:opplist){
                List <String> emailaddress = new List <String> ();
                emailaddress.add(managerEmailMap.get(opp.Owner.ManagerId));
                oppEmailMap.put(opp,emailaddress);
            }
        if(userlist.size() >0){
        
            for(Opportunity opp:oppEmailMap.keyset()){
                
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage ();
                List <String> emailaddress = oppEmailMap.get(opp);
                email.setToAddresses(oppEmailMap.get(opp));
                email.setSubject('Won Opportunity Notification');
                email.setPlainTextBody('This is an automatic Salesforce Customer Relationship Management notification to inform you that today we won the '+ opp.Name +' from '+ opp.Account.Name + ' with a revenue of '+ opp.Estimate_Value_Excl_Settlement_GST__c +'.');
                Messaging.sendEmail(new Messaging.Singleemailmessage [] {email});
            }
        }
        
        
        Id rid = [select id,Name from RecordType where Name = 'Label.Zintel_Case_RT'].Id;
        list <Case> insertCase = new list <Case> ();
        for(Opportunity opp:oppEmailMap.keyset()){
            Case c = new Case ();
            c.Title__c = 'Provisioning New Service';
            c.RecordTypeId = rid;
            c.AccountId = opp.AccountId;
            c.Opportunity__c = opp.Id;
            c.Priority = 'P3 Medium';
            c.Subject = 'Opportunity Won';
            c.Status = 'Active';
            c.Network_Service_Provider__c = 'Zintel';
            c.Description = 'New Opportunity Won';
            insertCase.add(c);
        }
        insert insertCase;
        
    }
}