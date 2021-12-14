public class Consensus_InvoiceCreationHelper{
    Public ConsensusDescriptions__c descriptionValue;
    Public RecordType rt;
    
    public Consensus_InvoiceCreationHelper() {
        //get the Description values on Invoice record from custom setting
        descriptionValue = ConsensusDescriptions__c.getvalues('Invoice description');
        rt = [SELECT Id 
              FROM RecordType
              WHERE SobjectType = 'Opportunity' AND Name = 'Consensus: Opportunity'
              LIMIT 1];
    }
    
    public void insertOppRelatedInvRecords(Map<Id, Opportunity> oppNewMap) {
        List<Invoice__c> invoices = new List<Invoice__c>();
        Double totalDirectInvAmt = 0;
        Map<Id,Double> mapOfTotalDirectInvAmount = new Map<Id, Double>();
        
        for(Opportunity o: oppNewMap.values()) {
            if(o.RecordTypeId == rt.Id && o.StageName == 'Closed Won') {
                
                totalDirectInvAmt  = o.Price__c + (o.Locations__c * o.Site_License__c) + (o.Phone_Number_Fee__c * o.Phone_Number_Lines__c - 5)
                    + ((o.Admin_Training_Date__c != null && (o.Admin_Training_Date__c.Month() == Date.today().Month()) && o.Admin_Training_Fee__c != null) ? o.Admin_Training_Fee__c : 0)
                    + ((o.User_Training_Date__c != null && (o.User_Training_Date__c.Month() == Date.today().Month()) && o.User_Training_Fee__c  != null) ? o.User_Training_Fee__c : 0)
                    + ((o.Professional_Date__c != null && (o.Professional_Date__c.Month() == Date.today().Month()) && o.Professional_Fee__c != null && o.Professional_Hours__c != null) ? (o.Professional_Fee__c * o.Professional_Hours__c) : 0);
                mapOfTotalDirectInvAmount.put(o.Id, totalDirectInvAmt);
                
                // Tier and Price Invoice Line Item
                Invoice__c inv = new Invoice__c();
                inv.Opportunity__c = o.Id;
                inv.Account__c = o.AccountId;
                inv.Description__c = descriptionValue.Tier_and_Price__c;
                inv.Sign_Up_Date__c = Date.today();
                inv.Billing_Run_Date__c = Date.today();
                inv.Status__c = 'Active';
                inv.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;
                inv.Line_Number1__c = '1';
                //inv.Custom_Invoice_Description__c = descriptionValue.Tier_and_Price__c;
                inv.Consensus_Quantity__c = 1;
                inv.Consensus_Price__c = o.Price__c;
                inv.Consensus_Amount_Breakdown__c = inv.Consensus_Quantity__c * inv.Consensus_Price__c;
                inv.Amount__c = mapOfTotalDirectInvAmount.get(inv.Opportunity__c);
                Inv.Product__c = 'Consensus';
                invoices.add(inv);
                
                //Locations and Site Licenses Invoice Line Item
                Invoice__c inv1 = new Invoice__c();
                inv1.Opportunity__c = o.Id;
                inv1.Account__c = o.AccountId;
                inv1.Description__c = descriptionValue.Locations_and_Site_Licenses__c;
                inv1.Sign_Up_Date__c = Date.today();
                inv1.Billing_Run_Date__c = Date.today();
                inv1.Status__c = 'Active';
                inv1.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;
                inv1.Line_Number1__c = '2';
                //inv1.Custom_Invoice_Description__c = descriptionValue.Locations_and_Site_Licenses__c;
                inv1.Consensus_Quantity__c = o.Locations__c;
                inv1.Consensus_Price__c = o.Site_License__c;
                inv1.Consensus_Amount_Breakdown__c = o.Locations__c * o.Site_License__c;
                inv1.Amount__c = mapOfTotalDirectInvAmount.get(inv.Opportunity__c);
                Inv1.Product__c = 'Consensus';
                invoices.add(inv1);
                
                //Phone Number Fee Invoice Line Item
                Invoice__c inv2 = new Invoice__c();
                inv2.Opportunity__c = o.Id;
                inv2.Account__c = o.AccountId;
                inv2.Description__c = descriptionValue.Phone_Number_Fee__c;
                inv2.Sign_Up_Date__c = Date.today();
                inv2.Billing_Run_Date__c = Date.today();
                inv2.Status__c = 'Active';
                inv2.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;
                inv2.Line_Number1__c = '3';
                //inv2.Custom_Invoice_Description__c = descriptionValue.Phone_Number_Fee__c;
                inv2.Consensus_Quantity__c = o.Phone_Number_Lines__c;
                inv2.Consensus_Price__c = o.Phone_Number_Fee__c ;
                inv2.Consensus_Amount_Breakdown__c = ((o.Phone_Number_Lines__c * o.Phone_Number_Fee__c) - 5) ;
                inv2.Amount__c = mapOfTotalDirectInvAmount.get(inv.Opportunity__c);
                Inv2.Product__c = 'Consensus';
                invoices.add(inv2);
                
                //Admin Training Fee Invoice Line Item
                Invoice__c inv3 = new Invoice__c();
                inv3.Opportunity__c = o.Id;
                inv3.Account__c = o.AccountId;
                inv3.Description__c = descriptionValue.Admin_Training_Fee__c;
                inv3.Sign_Up_Date__c = inv3.Status__c == 'Active' ? o.Admin_Training_Date__c : Date.today();
                inv3.Billing_Run_Date__c = inv3.Status__c == 'Active' ? o.Admin_Training_Date__c : Date.today();
                inv3.Status__c = (o.Admin_Training_Date__c != null && o.Admin_Training_Date__c.Month() >= Date.today().Month()) 
                    ? 'Active' : 'Inactive';
                inv3.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;            
                inv3.Line_Number1__c = '4';
                //inv3.Custom_Invoice_Description__c = descriptionValue.Admin_Training_Fee__c;
                inv3.Consensus_Quantity__c = inv3.Status__c == 'Active' ? 1 : 0;
                inv3.Consensus_Price__c = inv3.Status__c == 'Active' ? o.Admin_Training_Fee__c : 0;            
                inv3.Consensus_Amount_Breakdown__c = inv3.Status__c == 'Active' ? 1 * o.Admin_Training_Fee__c : 0;
                inv3.Invoice_Reason__c = inv3.Status__c == 'Inactive' ? 'Service Opted Out' : '';
                inv3.Amount__c = mapOfTotalDirectInvAmount.get(inv.Opportunity__c);
                Inv3.Product__c = 'Consensus';
                invoices.add(inv3);
                
                // User Training Fee Invoice Line Item
                Invoice__c inv4 = new Invoice__c();
                inv4.Opportunity__c = o.Id;
                inv4.Account__c = o.AccountId;
                inv4.Description__c = descriptionValue.User_Training_Fee__c;
                inv4.Sign_Up_Date__c =  inv4.Status__c == 'Active' ? o.User_Training_Date__c : Date.today();
                inv4.Billing_Run_Date__c = inv4.Status__c == 'Active' ? o.User_Training_Date__c : Date.today();
                inv4.Status__c = (o.User_Training_Date__c != null && o.User_Training_Date__c.Month() >= Date.today().Month()) 
                    ? 'Active' : 'Inactive';
                inv4.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;
                inv4.Line_Number1__c = '5';
                //inv4.Custom_Invoice_Description__c = descriptionValue.User_Training_Fee__c;
                inv4.Consensus_Quantity__c = inv4.Status__c == 'Active' ? 1 : 0;
                inv4.Consensus_Price__c = inv4.Status__c == 'Active' ? o.User_Training_Fee__c : 0;
                inv4.Consensus_Amount_Breakdown__c = inv4.Status__c == 'Active' ? 1 * o.User_Training_Fee__c : 0;
                inv4.Invoice_Reason__c = inv4.Status__c == 'Inactive' ? 'Service Opted Out' : '';
                inv4.Amount__c = mapOfTotalDirectInvAmount.get(inv.Opportunity__c);
                Inv4.Product__c = 'Consensus';
                invoices.add(inv4);
                
                //Professional Service Fee Invoice Line Item
                Invoice__c inv5 = new Invoice__c();
                inv5.Opportunity__c = o.Id;
                inv5.Account__c = o.AccountId;
                inv5.Description__c = descriptionValue.Professional_Service_Fee__c;
                inv5.Sign_Up_Date__c = inv5.Status__c == 'Active' ? o.Professional_Date__c : Date.today();
                inv5.Billing_Run_Date__c = inv5.Status__c == 'Active' ? o.Professional_Date__c : Date.today();
                inv5.Status__c = (o.Professional_Date__c != null && o.Professional_Date__c.Month() >= Date.today().Month()) 
                    ? 'Active' : 'Inactive';
                inv5.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;            
                inv5.Line_Number1__c = '6';
                //inv5.Custom_Invoice_Description__c = descriptionValue.Professional_Service_Fee__c;
                inv5.Consensus_Quantity__c = o.Professional_Hours__c;
                inv5.Consensus_Price__c = inv5.Status__c == 'Active' ? o.Professional_Fee__c : 0;
                inv5.Consensus_Amount_Breakdown__c = inv5.Status__c == 'Active' ? o.Professional_Hours__c * o.Professional_Fee__c : 0;
                inv5.Invoice_Reason__c = inv5.Status__c == 'Inactive' ? 'Service Opted Out' : '';
                inv5.Amount__c = mapOfTotalDirectInvAmount.get(inv.Opportunity__c);
                Inv5.Product__c = 'Consensus';
                invoices.add(inv5);   
            }
        }
        if(invoices.size() > 0) {
            insert invoices;   
        }
    }
    
    public void updateOppRelatedInvRecords(Map<Id, Opportunity> oppOldMap, Map<Id, Opportunity> oppNewMap) {
        List<Invoice__c> updatedInvoices = new List<Invoice__c>();
        List<Invoice__c> invoices = new List<Invoice__c>();
        Set<Id> setOfChangedOpp = new Set<Id>();
        Double totalInvAmt = 0;
        Map<Id,Double> mapOfTotalAmount = new Map<Id, Double>();
        
        for(Opportunity o : oppNewMap.values()) {
            
            if(o.RecordTypeId == rt.Id){
                totalInvAmt  = o.Price__c + (o.Locations__c * o.Site_License__c) + (o.Phone_Number_Fee__c * o.Phone_Number_Lines__c - 5)
                    + ((o.Admin_Training_Date__c != null && (o.Admin_Training_Date__c.Month() == Date.today().Month()) && o.Admin_Training_Fee__c != null) ? o.Admin_Training_Fee__c : 0)
                    + ((o.User_Training_Date__c != null && (o.User_Training_Date__c.Month() == Date.today().Month()) && o.User_Training_Fee__c  != null) ? o.User_Training_Fee__c : 0)
                    + ((o.Professional_Date__c != null && (o.Professional_Date__c.Month() == Date.today().Month()) && o.Professional_Fee__c != null && o.Professional_Hours__c != null) ? (o.Professional_Fee__c * o.Professional_Hours__c) : 0);
                mapOfTotalAmount.put(o.Id, totalInvAmt);
            }
                        
            //This logic will call in insert the opportunity
            if(o.RecordTypeId == rt.Id && o.StageName == 'Closed Won' && (oppOldMap.get(o.Id).StageName) != o.StageName) {
                //insertOppRelatedInvRecords(oppNewMap);
                // Tier and Price Invoice Line Item
                Invoice__c inv = new Invoice__c();
                inv.Opportunity__c = o.Id;
                inv.Account__c = o.AccountId;
                inv.Description__c = descriptionValue.Tier_and_Price__c;
                inv.Sign_Up_Date__c = Date.today();
                inv.Billing_Run_Date__c = Date.today();
                inv.Status__c = 'Active';  
                inv.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;
                inv.Line_Number1__c = '1';
                //inv.Custom_Invoice_Description__c = descriptionValue.Tier_and_Price__c;
                inv.Consensus_Quantity__c = 1;
                inv.Consensus_Price__c = o.Price__c;
                inv.Consensus_Amount_Breakdown__c = inv.Consensus_Quantity__c * inv.Consensus_Price__c;
                inv.Amount__c = mapOfTotalAmount.get(inv.Opportunity__c);
                Inv.Product__c = 'Consensus';
                invoices.add(inv);
                
                //Locations and Site Licenses Invoice Line Item
                Invoice__c inv1 = new Invoice__c();
                inv1.Opportunity__c = o.Id;
                inv1.Account__c = o.AccountId;
                inv1.Description__c = descriptionValue.Locations_and_Site_Licenses__c;
                inv1.Sign_Up_Date__c = Date.today();
                inv1.Billing_Run_Date__c = Date.today();
                inv1.Status__c = 'Active';
                inv1.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;
                inv1.Line_Number1__c = '2';
                //inv1.Custom_Invoice_Description__c = descriptionValue.Locations_and_Site_Licenses__c;
                inv1.Consensus_Quantity__c = o.Locations__c;
                inv1.Consensus_Price__c = o.Site_License__c;
                inv1.Consensus_Amount_Breakdown__c = o.Locations__c * o.Site_License__c;
                inv1.Amount__c = mapOfTotalAmount.get(inv1.Opportunity__c);
                Inv1.Product__c = 'Consensus';
                invoices.add(inv1);
                
                //Phone Number Fee Invoice Line Item
                Invoice__c inv2 = new Invoice__c();
                inv2.Opportunity__c = o.Id;
                inv2.Account__c = o.AccountId;
                inv2.Description__c = descriptionValue.Phone_Number_Fee__c;
                inv2.Sign_Up_Date__c = Date.today();
                inv2.Billing_Run_Date__c = Date.today();
                inv2.Status__c = 'Active';
                inv2.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;
                inv2.Line_Number1__c = '3';
                //inv2.Custom_Invoice_Description__c = descriptionValue.Phone_Number_Fee__c;
                inv2.Consensus_Quantity__c = o.Phone_Number_Lines__c;
                inv2.Consensus_Price__c = o.Phone_Number_Fee__c ;
                inv2.Consensus_Amount_Breakdown__c = ((o.Phone_Number_Lines__c * o.Phone_Number_Fee__c) - 5) ;
                inv2.Amount__c = mapOfTotalAmount.get(inv2.Opportunity__c);
                Inv2.Product__c = 'Consensus';
                invoices.add(inv2);
                
                //Admin Training Fee Invoice Line Item
                Invoice__c inv3 = new Invoice__c();
                inv3.Opportunity__c = o.Id;
                inv3.Account__c = o.AccountId;
                inv3.Description__c = descriptionValue.Admin_Training_Fee__c;
                inv3.Sign_Up_Date__c = inv3.Status__c == 'Active' ? o.Admin_Training_Date__c : Date.today();
                inv3.Billing_Run_Date__c = inv3.Status__c == 'Active' ? o.Admin_Training_Date__c : Date.today();
                inv3.Status__c = (o.Admin_Training_Date__c != null && o.Admin_Training_Date__c.Month() >= Date.today().Month()) 
                    ? 'Active' : 'Inactive';
                inv3.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;            
                inv3.Line_Number1__c = '4';
                //inv3.Custom_Invoice_Description__c = descriptionValue.Admin_Training_Fee__c;
                inv3.Consensus_Quantity__c = inv3.Status__c == 'Active' ? 1 : 0;
                inv3.Consensus_Price__c = inv3.Status__c == 'Active' ? o.Admin_Training_Fee__c : 0;            
                inv3.Consensus_Amount_Breakdown__c = inv3.Status__c == 'Active' ? 1 * o.Admin_Training_Fee__c : 0;
                inv3.Invoice_Reason__c = inv3.Status__c == 'Inactive' ? 'Service Opted Out' : '';
                inv3.Amount__c = mapOfTotalAmount.get(inv3.Opportunity__c);
                Inv3.Product__c = 'Consensus';
                invoices.add(inv3);
                
                // User Training Fee Invoice Line Item
                Invoice__c inv4 = new Invoice__c();
                inv4.Opportunity__c = o.Id;
                inv4.Account__c = o.AccountId;
                inv4.Description__c = descriptionValue.User_Training_Fee__c;
                inv4.Sign_Up_Date__c = inv4.Status__c == 'Active' ? o.User_Training_Date__c : Date.today();
                inv4.Billing_Run_Date__c = inv4.Status__c == 'Active' ? o.User_Training_Date__c : Date.today();
                inv4.Status__c = (o.User_Training_Date__c != null && o.User_Training_Date__c.Month() >= Date.today().Month()) 
                    ? 'Active' : 'Inactive';
                inv4.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;
                inv4.Line_Number1__c = '5';
                //inv4.Custom_Invoice_Description__c = descriptionValue.User_Training_Fee__c;
                inv4.Consensus_Quantity__c = inv4.Status__c == 'Active' ? 1 : 0;
                inv4.Consensus_Price__c = inv4.Status__c == 'Active' ? o.User_Training_Fee__c : 0;
                inv4.Consensus_Amount_Breakdown__c = inv4.Status__c == 'Active' ? 1 * o.User_Training_Fee__c : 0;
                inv4.Invoice_Reason__c = inv4.Status__c == 'Inactive' ? 'Service Opted Out' : '';
                inv4.Amount__c = mapOfTotalAmount.get(inv4.Opportunity__c);
                Inv4.Product__c = 'Consensus';
                invoices.add(inv4);
                
                //Professional Service Fee Invoice Line Item
                Invoice__c inv5 = new Invoice__c();
                inv5.Opportunity__c = o.Id;
                inv5.Account__c = o.AccountId;
                inv5.Description__c = descriptionValue.Professional_Service_Fee__c;
                inv5.Sign_Up_Date__c = inv5.Status__c == 'Active' ? o.Professional_Date__c : Date.today();
                inv5.Billing_Run_Date__c = inv5.Status__c == 'Active' ? o.Professional_Date__c : Date.today();
                inv5.Status__c = (o.Professional_Date__c != null && o.Professional_Date__c.Month() >= Date.today().Month()) 
                    ? 'Active' : 'Inactive';
                inv5.Oracle_Invoice_ID__c = o.Consensus_Invoice_No__c;            
                inv5.Line_Number1__c = '6';
                //inv5.Custom_Invoice_Description__c = descriptionValue.Professional_Service_Fee__c;
                inv5.Consensus_Quantity__c = o.Professional_Hours__c;
                inv5.Consensus_Price__c = inv5.Status__c == 'Active' ? o.Professional_Fee__c : 0;
                inv5.Consensus_Amount_Breakdown__c = inv5.Status__c == 'Active' ? o.Professional_Hours__c * o.Professional_Fee__c : 0;
                inv5.Invoice_Reason__c = inv5.Status__c == 'Inactive' ? 'Service Opted Out' : '';
                inv5.Amount__c = mapOfTotalAmount.get(inv5.Opportunity__c);
                Inv5.Product__c = 'Consensus';
                invoices.add(inv5);   
            }
            //This Logic will call in update the opportunity
            if(o.RecordTypeId == rt.Id && o.StageName == 'Closed Won' && (oppOldMap.get(o.Id).StageName) == o.StageName) {
                setOfChangedOpp.add(o.Id);
            }
        }
        
        if(invoices.size() > 0) {
            insert invoices;
        }
        
        List<Invoice__c> lstInvoice = [SELECT Id, Consensus_Price__c, Description__c, Opportunity__c 
                                       FROM Invoice__c 
                                       WHERE Opportunity__c IN : setOfChangedOpp];
        
        if(lstInvoice.size() > 0) {
            for(Invoice__c invObj : lstInvoice) {
                if(invObj.Description__c == descriptionValue.Tier_and_Price__c) {
                    invObj.Consensus_Price__c = oppNewMap.get(invObj.Opportunity__c).Price__c;  
                    invObj.Consensus_Quantity__c = 1;
                    invObj.Consensus_Amount_Breakdown__c = invObj.Consensus_Price__c;
                    invObj.Amount__c = mapOfTotalAmount.get(invObj.Opportunity__c);
                }
                if(invObj.Description__c == descriptionValue.Locations_and_Site_Licenses__c) {
                    invObj.Consensus_Price__c = oppNewMap.get(invObj.Opportunity__c).Site_License__c;
                    invObj.Consensus_Quantity__c =  oppNewMap.get(invObj.Opportunity__c).Locations__c; 
                    invObj.Consensus_Amount_Breakdown__c = 
                        oppNewMap.get(invObj.Opportunity__c).Locations__c * oppNewMap.get(invObj.Opportunity__c).Site_License__c;
                    invObj.Amount__c = mapOfTotalAmount.get(invObj.Opportunity__c);
                }
                if(invObj.Description__c == descriptionValue.Phone_Number_Fee__c) {
                    invObj.Consensus_Price__c = oppNewMap.get(invObj.Opportunity__c).Phone_Number_Fee__c;
                    invObj.Consensus_Quantity__c = oppNewMap.get(invObj.Opportunity__c).Phone_Number_Lines__c;
                    invObj.Consensus_Amount_Breakdown__c = 
                        ((oppNewMap.get(invObj.Opportunity__c).Phone_Number_Lines__c * oppNewMap.get(invObj.Opportunity__c).Phone_Number_Fee__c) - 5);
                    invObj.Amount__c = mapOfTotalAmount.get(invObj.Opportunity__c);
                }
                if(invObj.Description__c == descriptionValue.Admin_Training_Fee__c) {
                    invObj.Status__c = (oppNewMap.get(invObj.Opportunity__c).Admin_Training_Date__c != null && 
                                        (oppNewMap.get(invObj.Opportunity__c).Admin_Training_Date__c.Month() >= Date.today().Month())) ? 'Active' : 'Inactive';
                    invObj.Consensus_Price__c = invObj.Status__c == 'Active' ? oppNewMap.get(invObj.Opportunity__c).Admin_Training_Fee__c : 0;
                    invObj.Consensus_Quantity__c = invObj.Status__c == 'Active' ? 1 : 0;
                    invObj.Consensus_Amount_Breakdown__c = invObj.Status__c == 'Active' ? invObj.Consensus_Price__c : 0;
                    invObj.Invoice_Reason__c = invObj.Status__c == 'Inactive' ? 'Service Opted Out' : '';
                    invObj.Amount__c = mapOfTotalAmount.get(invObj.Opportunity__c);
                    invObj.Sign_Up_Date__c = invObj.Status__c == 'Active' ? oppNewMap.get(invObj.Opportunity__c).Admin_Training_Date__c: Date.today();
                    invObj.Billing_Run_Date__c = invObj.Status__c == 'Active' ? oppNewMap.get(invObj.Opportunity__c).Admin_Training_Date__c: Date.today();
                }
                if(invObj.Description__c == descriptionValue.User_Training_Fee__c) {
                    invObj.Status__c = (oppNewMap.get(invObj.Opportunity__c).User_Training_Date__c != null && 
                                        (oppNewMap.get(invObj.Opportunity__c).User_Training_Date__c.Month() >= Date.today().Month())) ? 'Active' : 'Inactive';
                    invObj.Consensus_Price__c = invObj.Status__c == 'Active' ? oppNewMap.get(invObj.Opportunity__c).User_Training_Fee__c : 0;
                    invObj.Consensus_Quantity__c = invObj.Status__c == 'Active' ? 1 : 0;
                    invObj.Consensus_Amount_Breakdown__c = invObj.Status__c == 'Active' ? invObj.Consensus_Price__c : 0;
                    invObj.Invoice_Reason__c = invObj.Status__c == 'Inactive' ? 'Service Opted Out' : '';
                    invObj.Amount__c = mapOfTotalAmount.get(invObj.Opportunity__c);
                    invObj.Sign_Up_Date__c = invObj.Status__c == 'Active' ? oppNewMap.get(invObj.Opportunity__c).User_Training_Date__c: Date.today();
                    invObj.Billing_Run_Date__c = invObj.Status__c == 'Active' ? oppNewMap.get(invObj.Opportunity__c).User_Training_Date__c: Date.today();
                }
                if(invObj.Description__c == descriptionValue.Professional_Service_Fee__c) {
                    invObj.Status__c = (oppNewMap.get(invObj.Opportunity__c).Professional_Date__c != null && 
                                        (oppNewMap.get(invObj.Opportunity__c).Professional_Date__c.Month() >= Date.today().Month())) ? 'Active' : 'Inactive';
                    invObj.Consensus_Price__c = invObj.Status__c == 'Active' ? oppNewMap.get(invObj.Opportunity__c).Professional_Fee__c : 0;
                    invObj.Consensus_Quantity__c = invObj.Status__c == 'Active' ? oppNewMap.get(invObj.Opportunity__c).Professional_Hours__c : 0;
                    invObj.Consensus_Amount_Breakdown__c = invObj.Status__c == 'Active' ?
                        oppNewMap.get(invObj.Opportunity__c).Professional_Hours__c * invObj.Consensus_Price__c : 0;
                    invObj.Invoice_Reason__c = invObj.Status__c == 'Inactive' ? 'Service Opted Out' : '';
                    invObj.Amount__c = mapOfTotalAmount.get(invObj.Opportunity__c);
                    invObj.Sign_Up_Date__c = invObj.Status__c == 'Active' ? oppNewMap.get(invObj.Opportunity__c).Professional_Date__c : Date.today();
                    invObj.Billing_Run_Date__c = invObj.Status__c == 'Active' ? oppNewMap.get(invObj.Opportunity__c).Professional_Date__c : Date.today();
                }
                updatedInvoices.add(invObj);
            }
        }
        if(updatedInvoices.size() > 0) {
            update updatedInvoices;
        }
    }
}