global with sharing class InvoiceInactiveSchedular implements Schedulable{
    
    global void execute(SchedulableContext sc){
        Set <Id> aidSet = new Set <Id>();
        list <Account> acclist = [Select id,Deactivate_Invoice__c From Account where Deactivate_Invoice__c=true];
        for (Account a:acclist){
            aidSet.add(a.Id);
        }
        
        list <Invoice__c> updatelist = new list <Invoice__c> ();
        list <Invoice__c> invlist = [select id,Status__c from Invoice__c where Account__c IN:aidSet ];
        
        for(Invoice__c i : invlist){
            i.Status__c = 'Inactive';
            i.Invoice_Reason__c = 'Closed Down';
            updatelist.add(i);
        }
        
        update updatelist;
    }

}