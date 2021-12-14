public with sharing class j2_KeepitSafe_InvoiceUpdateClass {
    
    public void invoiceUpdate(Map<Id, Account> accMap){
        
        List<Invoice__c> Invlist = [SELECT Id, Status__c, Account__c,Account__r.Reason__c,Invoice_Reason__c
                                    FROM Invoice__c 
                                    WHERE Account__c IN: accMap.keyset()];
        
        list<Invoice__c> UpdateInv = new list<Invoice__c>();
        
        if(Invlist.size() > 0) {
            for(Invoice__c i: Invlist){
                i.Status__c = 'Inactive';
                i.invoice_Reason__c = i.Account__r.Reason__c;
                UpdateInv.add(i);
            }
        }
        if(UpdateInv.size() > 0) {
            update UpdateInv;    
        }
    }
}