public class opportunityTriggerHandler {

    private static final Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId();
    private static final Id RECORD_TYPE_KIS_IE_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafe').getRecordTypeId();
    public static boolean isRunOnce = false;
    public static  List<Account> lstOfAccountToUpdate = new List<Account>(); 
    public static List<Id> listOfOpportunityIds = new List<Id>();
    public static List<String> listOfOpportunityNames = new List<String>();
    public static List<Opportunity> listOfOppProductNames = new List<Opportunity>();
    public static List<Opportunity> listOfOppProductNames2 = new List<Opportunity>();
    public static Map<Id,List<String>> mapOfAccountToOpportunity = new Map<Id,List<String>>();
    public static Map<Id,List<Opportunity>> mapOfAccountToOpportunityForInvoices = new Map<Id,List<Opportunity>>();
    public static boolean isOppCloned = false;
    

    public static void updateAccountKISProducts(List<Opportunity> listOfOpportunities){  
        Set<Id> oppIds = new Set<Id>();
        system.debug('Inside updateAccountKISProducts');
        system.debug('isRunOnce'+isRunOnce);
        system.debug('listOfOpportunities------->'+listOfOpportunities);
        if(isRunOnce)
        {
            return;
        }
         
        for(Opportunity tmpOpp : listOfOpportunities)
        {
            oppIds.add(tmpOpp.Id);
        }

        // Update Existing List of opportunities with temporay values for properties which are validated by Zeus Validation Rules
      //  listOfOpportunities = zeusValidationRulesWorkAround(listOfOpportunities);

        List<Opportunity> listOfOpportunitiesIds =[Select id,name, accountId, account.RecordType.DeveloperName, Package__c, account.Account_Status__c, StageName, Description, LeadSource from Opportunity where Id IN:oppIds];
        system.debug('listOfOpportunitiesIds------->'+listOfOpportunitiesIds);
        for(Opportunity opp : listOfOpportunitiesIds){            
            system.debug('opp.AccountId------->'+opp.AccountId);
            system.debug('opp.Account.RecordType.DeveloperName------->'+opp.Account.RecordType.DeveloperName);
            if(opp.Name.contains('-') && opp.AccountId != null && (opp.Account.RecordType.DeveloperName =='KeepItSafeNL' || opp.Account.RecordType.DeveloperName =='KeepItSafe')){
                
                //Parse product name
                String productName='';
                List<Integer> intIndex = new List<Integer>();
                Integer stringLenght = opp.Name.length();
                string product='';
                
                Integer firstDash =-1;
                Integer lastDash = -2;
                
                firstDash = opp.Name.IndexOf('-');
                lastDash = opp.Name.lastIndexOf('-');
               
                system.debug('first Dash'+ firstDash);
                system.debug('Last Dash'+ lastDash);
                
                if (firstDash == -1 && lastDash == -2)
                {
                    product = opp.Name;
                }
                else if(firstDash == lastDash)
                {
                    firstDash = opp.Name.IndexOf('-');
                    product = opp.Name.substring(firstDash+1, stringLenght-1);
                }
                else
                {
                    firstDash = opp.Name.IndexOf('-');
                    lastDash = opp.Name.lastIndexOf('-');
                    system.debug('first Dash'+ firstDash);
                    system.debug('Last Dash'+ lastDash);
                    product = opp.Name.substring(firstDash+1,lastDash);
                }
                    
                productName =product;
            //    String productName = opp.name.substringBetween('-','-');     
                if(productName != null)
                {           
                productName = productName.trim();               
                opp.Package__c = productName;
                }
                system.debug('opp.Package__c'+opp.Package__c);
                listOfOppProductNames.add(opp);
                listOfOpportunityNames.add(productName);
                if(!mapOfAccountToOpportunity.containsKey(opp.AccountId)){   
                    mapOfAccountToOpportunity.put(opp.AccountId, new List<String>());
                }
                mapOfAccountToOpportunity.get(opp.AccountId).add(productName);
                
                mapOfAccountToOpportunity.put(opp.AccountId,listOfOpportunityNames);
                system.debug('mapOfAccountToOpportunity------->'+mapOfAccountToOpportunity);
                
            }
        }
        
        List<Account> listOfAccount = [Select id, name, Currently_Using_Online_Backup__c from Account where Id IN: mapOfAccountToOpportunity.keySet()];
        System.debug('listOfAccount--->'+listOfAccount);   
        for(Account acc:listOfAccount){
            List<String> listOfProductNames = mapOfAccountToOpportunity.get(acc.Id);  
            system.debug('listOfProductNames---->'+listOfProductNames);
            for(String s:listOfProductNames)
            {            
                Switch on s{
                    when 'Rapid Recovery - Offsite'
                    {
                        acc.Rapid_Recovery_Offsite__c= true;
                    }
                    when 'Rapid Recovery - Onsite'
                    {
                        acc.Rapid_Recovery_Onsite__c= true;
                    }
                    when 'Asigra'
                    {
                        acc.Asigra__c= true;
                    }
                    when 'Ahsay - Online Backup'
                    {
                        acc.Ahsay_Online_Backup__c= true;
                    } 
                    when 'Mobile - KIS'
                    {
                        acc.Mobile_KIS__c= true;
                    } 
                    when 'Workforce - KIS'
                    {
                       acc.Workforce_KIS__c= true;
                    }
                    when 'Reselling Data Backup Equipment'
                    {
                        acc.Reselling_Data_Backup_Equipment__c= true;
                    }
                    when 'Enterprise Hybrid Backup Onsite - KIS - Asigra'
                    {
                        acc.Enterprise_Hybrid_Backup_Onsite_KIS__c= true;
                    }
                    when 'Server Hosting'
                    {
                        acc.Server_Hosting__c= true;
                    }
                    when 'Colocation'
                    {
                        acc.Colocation__c= true;
                    }
                    when 'VCC Backup'
                    {
                        acc.VCC_Backup__c= true;
                    }
                    when 'Veeam Cloud Tier'
                    {
                        acc.Veeam_Cloud_Connect__c= true;
                    }
                    when 'VCC Replication'
                    {
                        acc.VCC_Replication__c= true;
                    }
                    when 'TSM Cloud Backup'
                    {
                        acc.TSM_Cloud_Backup__c= true;
                    }
                    when 'Front-Server'
                    {
                        acc.Front_Server__c= true;
                    }
                    when 'eVault'
                    {
                        acc.eVault__c= true;
                    }
                    when 'Send2Cloud'
                    {
                        acc.Send2Cloud__c= true;
                    }
                    when 'Ahsay - Whitelabel'
                    {
                        acc.Ahsay_Whitelabel__c= true;
                    }
                    when 'Ahsay - 2nd Level Support'
                    {
                        acc.Ahsay_2nd_Level_Support__c= true;
                    }
                    when 'O365 BU'
                    {
                        acc.O365_BU__c= true;
                    }
                    when 'Ransomware and Insider Protection'
                    {
                        acc.Ransomware_and_Insider_Protection__c= true;
                    }
                    when 'Managed Availability Service'
                    {
                        acc.Managed_Availability_Service__c= true;
                    }
                    when 'Veeam License - Perpetual'
                    {
                   //     acc.Veeam_License_Perpetual__c= true;
                    }
                    when 'Veeam License - Rental'
                    {
                   //     acc.Veeam_License_Rental__c= true;
                    }
                    when 'Veeam License - Instance'
                    {
                   //     acc.Veeam_License_Instance__c= true;
                    }
                    when 'Zerto Replication'
                    {
                        acc.Zerto_Replication__c= true;
                    }
                    when 'Iaas'
                    {
                        acc.Iaas__c= true;
                    }
                    when 'Archival Storage'
                    {
                        acc.Archival_Storage__c= true;
                    }
                    //old
                    when 'Online Backup'
                    {
                        acc.Currently_Using_Online_Backup__c = true; 
                    }
                    When 'Managed Backup (Ahsay)'{
                        acc.Ahsay_Licences_Only__c = true;
                    }
                    When 'Enterprise Backup (Asigra)'{
                        acc.Asigra__c = true;
                    }
                    when 'DR (Asigra)'{
                       acc.Rapid_Recovery_Onsite__c = true;
                    }
                    when 'Veeam Cloud Connect'{
                        acc.Veeam_Cloud_Connect__c = true;
                    }                       
                }
            }
            if(!lstOfAccountToUpdate.contains(acc))
            {
                lstOfAccountToUpdate.add(acc);
                system.debug('lstOfAccountToUpdate----->'+lstOfAccountToUpdate);
            }        
        }

        update lstOfAccountToUpdate;
        system.debug('lstOfAccountToUpdate'+lstOfAccountToUpdate);
        system.debug('listOfOppProductNames------->'+listOfOppProductNames);
        update listOfOppProductNames;
        system.debug('listOfOppProductNames'+listOfOppProductNames);
        //mapOfAccountToOpportunity.keyset 
        //query on account for all keyset
        //for loop of that query result
        //get name from map
        //for loop on list
        
    }


//Update Product
// for all the opportunities find the account
// for each account search all 'Closed Won' opportunities
// Ufor each Opportunity update product on Account based on Opporutnity Account
public static void updateAccountProduct(List<Opportunity> listOfOpportunities)
    {  
        Set<Id> oppIds = new Set<Id>();
        Set<Id> accIds= new Set<Id>();
        Set<Account> accountsToUpdate = new Set<Account>();

        // GO through all the opportunities and get Related Account Id
        for(Opportunity opp : listOfOpportunities)
        {            
            system.debug('opp.AccountId------->'+opp.AccountId);
            system.debug('opp.Account.RecordType.DeveloperName------->'+opp.Account.RecordType.DeveloperName);
            if(opp.AccountId != null &&  opp.StageName=='Closed Won')
            {
                //get the account id's with
                if (!accIds.contains(opp.AccountId)) 
                {
                    System.debug('List of Account IDs: '+ opp.AccountId);
                    accIds.add(opp.AccountId);
                } 
            }
        }
        //get all the Opportunities for the Account That are type KISNL OR KIS
        List <Account> listOfAccounts =[Select Id, Name from Account WHERE Id IN:accIds AND (RecordType.Id =:RECORD_TYPE_KIS_NL_ID OR RecordType.Id =:RECORD_TYPE_KIS_IE_ID) ];
        System.debug('lIST OF Accounts: '+listOfAccounts);
        //For each account get all oportunitues and update Product On account
        for (Account acc: listOfAccounts)
        {
            List<Opportunity> listOfAccOpportunities =[Select id, name, Package__c, accountId, account.RecordType.DeveloperName, account.Account_Status__c, StageName, Description, LeadSource from Opportunity where accountId =:acc.id and (StageName='Closed Won' OR  StageName='Closed-Won')];
            System.debug('lIST OF Opportunities: '+listOfAccOpportunities);
            // Loop through the all Account 'ClosedWon'  Opportunities
            for (Opportunity oppo : listOfAccOpportunities)
            {

                if (oppo.Package__c.contains('Rapid Recovery - Offsite'))
                {
                    acc.Rapid_Recovery_Offsite__c= true;
                }
                if(oppo.Package__c.contains('Rapid Recovery - Onsite'))
                {
                    acc.Rapid_Recovery_Onsite__c= true;
                }
                if(oppo.Package__c.contains('Asigra'))
                {
                    acc.Asigra__c= true;
                }
                if(oppo.Package__c.contains('Ahsay - Online Backup'))
                {
                    acc.Ahsay_Online_Backup__c= true;
                } 
                if(oppo.Package__c == 'Mobile - KIS')
                {
                    acc.Mobile_KIS__c= true;
                } 
                if(oppo.Package__c.contains('Workforce - KIS'))
                {
                    acc.Workforce_KIS__c= true;
                }
                if(oppo.Package__c.contains('Reselling Data Backup Equipment'))
                {
                    acc.Reselling_Data_Backup_Equipment__c= true;
                }
                if(oppo.Package__c.contains('Enterprise Hybrid Backup Onsite - KIS - Asigra'))
                {
                    acc.Enterprise_Hybrid_Backup_Onsite_KIS__c= true;
                }
                if(oppo.Package__c.contains('Server Hosting - KIS'))
                {
                    acc.Server_Hosting__c= true;
                }
                if(oppo.Package__c.contains('Server Colocation - KIS'))
                {
                    acc.Colocation__c= true;
                }
                if(oppo.Package__c.contains('Veeam - KIS'))
                {
                    acc.VCC_Backup__c= true;
                }
                if(oppo.Package__c.contains('Veeam Cloud Tier'))
                {
                    acc.Veeam_Cloud_Connect__c= true;
                }
                if(oppo.Package__c.contains('Veeam DRAAS'))
                {
                    acc.VCC_Replication__c= true;
                }
                if(oppo.Package__c.contains('TSM Cloud Backup'))
                {
                    acc.TSM_Cloud_Backup__c= true;
                }
                if(oppo.Package__c.contains('Front-Server'))
                {
                    acc.Front_Server__c= true;
                }
                if(oppo.Package__c.contains('eVault'))
                {
                    acc.eVault__c= true;
                }
                if(oppo.Package__c.contains('Send2Cloud'))
                {
                    acc.Send2Cloud__c= true;
                }
                if(oppo.Package__c.contains('Ahsay - Whitelabel'))
                {
                    acc.Ahsay_Whitelabel__c= true;
                }
                if(oppo.Package__c.contains('Ahsay - 2nd Level Support'))
                {
                    acc.Ahsay_2nd_Level_Support__c= true;
                }
                if(oppo.Package__c.contains('O365 BU'))
                {
                    acc.O365_BU__c= true;
                }
                if(oppo.Package__c.contains('Ransomware and Insider Protection'))
                {
                    acc.Ransomware_and_Insider_Protection__c= true;
                }
                if(oppo.Package__c.contains('Managed Availability Service'))
                {
                    acc.Managed_Availability_Service__c= true;
                }
                if(oppo.Package__c.contains('Veeam License - Perpetual'))
                {
                //    acc.Veeam_License_Perpetual__c= true;
                }
                if(oppo.Package__c.contains('Veeam License - Rental'))
                {
                //    acc.Veeam_License_Rental__c= true;
                }
                if(oppo.Package__c.contains('Veeam License - Instance'))
                {
                //    acc.Veeam_License_Instance__c= true;
                }
                if(oppo.Package__c.contains('Zerto Replication'))
                {
                    acc.Zerto_Replication__c= true;
                }
                if(oppo.Package__c.contains('Iaas'))
                {
                    acc.Iaas__c= true;
                }
                if(oppo.Package__c.contains('Archival Storage'))
                {
                    acc.Archival_Storage__c= true;
                }
            }
            //Check if account is already on the list
             if (!accountsToUpdate.contains(acc))
             {
                accountsToUpdate.add(acc);
             }
        }
        //check if account list is updated
        if (accountsToUpdate.size() > 0) 
        {
            update new List<Account>(accountsToUpdate);
        }
    }



    //Logic to create invoice for account whose child opportunities stage is closed won
    public static void createInvoicesForOpportunities(List<Opportunity> listOfOpportunities){
        
        // Update Existing List of opportunities with temporay values for properties which are validated by Zeus Validation Rules
       // listOfOpportunities = zeusValidationRulesWorkAround(listOfOpportunities);
        
        system.debug('Inside createInvoicesForOpportunities');
        system.debug('isRunOnce'+isRunOnce);
        system.debug('listOfOpportunities------->'+listOfOpportunities);
        if(isRunOnce)
        {
            return;
        }
        isRunOnce=true;
        system.debug('listOfOpportunities inside update--------->'+listOfOpportunities);
        List<Invoice__c>  lstOfInvoiceToUpdate = new List<Invoice__c>();
        List<Opportunity> listOfOpportunitiesForInvoices = new List<Opportunity>();
        List<Account> accountsToUpdate = new List<Account>();

        
        List<Opportunity> listOfOpportunitiesIds =[Select id,name,account.Account_Status__c,StageName, accountId, account.ParentId,account.RecordType.DeveloperName,
                                                   account.Send_Bill_To__c, O365_Mailbox_Sold__c, Description, Zeus_Deal_RansomwareInsProtect__c, Type_of_Environment__c, IsInvoiceCreated__c,Account.Keepitsafe_Username__c,
                                                   Package__c,GB_Package__c, Service_Type__c, of_VMs_needed__c, TB_Sold__c, Term__c,Amount from Opportunity 
                                                   where Id IN:listOfOpportunities];

        for(Opportunity oppor : listOfOpportunitiesIds){
            if(oppor.Account != null) {
                system.debug('Account Record type developer name ------->'+oppor.Account.RecordType.DeveloperName);
                if (oppor.Account.RecordType.Id == RECORD_TYPE_KIS_NL_ID || oppor.Account.RecordType.Id == RECORD_TYPE_KIS_IE_ID) {

                    // Clone flag is assuming there is only one opportunity in trigger (+static member!!)
                    if(isOppCloned == false) {
                        if(oppor.isClone()){
                            isOppCloned = true;
                            System.debug('opp is cloned');
                        }
                    }
                    listOfOpportunitiesForInvoices.add(oppor);
                }
            }
        }
        
        system.debug('listOfOpportunitiesForInvoices------->'+listOfOpportunitiesForInvoices);
        for(Opportunity opp : listOfOpportunitiesForInvoices){   
            system.debug('opp.IsInvoiceCreated__c------->'+opp.IsInvoiceCreated__c);
            if(opp.IsInvoiceCreated__c == false || isOppCloned == true){  
                // Workaround for NL portal sending 'Closed Won, delay Invoice'
                if(opp.StageName == 'Closed Won' || opp.StageName == 'Closed Won, delay Invoice')
                {

                    // Create the case for the opportunity
                    Case cs = new Case();
                    cs.Opportunity__c = opp.Id;
                    cs.AccountId = opp.AccountId;

                    String tmpString = '';
                    if(opp.Service_Type__c != null)
                    {
                        if(opp.Service_Type__c == 'O365 BU')
                        {
                            cs.Subject = 'Veeam O365 BU Installation';
                            cs.Description = 'O365 Mailbox sold: ' + opp.O365_Mailbox_Sold__c;
                        }
                        if(opp.Service_Type__c == 'VCC Backup')
                        {
                            cs.Subject = 'Veeam Backup Installation';
                            if(opp.Zeus_Deal_RansomwareInsProtect__c)
                            {
                                //checkbox checked
                                tmpString = 'true';
                            }
                            else 
                            {
                                //checkbox unchecked
                                tmpString = 'false';
                            }
                            cs.Description = 'Number of VMs : ' + opp.of_VMs_needed__c + '\nTB Sold : ' + opp.TB_Sold__c + '\nType of environment : ' + opp.Type_of_Environment__c + '\nZeus Deal RansomwareInsProcect : ' + tmpString;
                        }
                        if(opp.Service_Type__c == 'VCC Replication')
                        {
                            cs.Subject = 'Veeam Replication Installation';
                            if(opp.Zeus_Deal_RansomwareInsProtect__c)
                            {
                                //checkbox checked
                                tmpString = 'true';
                            }
                            else 
                            {
                                //checkbox unchecked
                                tmpString = 'false';
                            }
                            cs.Description = 'Number of VMs : ' + opp.of_VMs_needed__c + '\nTB Sold : ' + opp.TB_Sold__c + '\nType of environment : ' + opp.Type_of_Environment__c + '\nZeus Deal RansomwareInsProcect : ' + tmpString;
                        }
                        if(opp.Service_Type__c == 'Veeam Licenses')
                        {
                            cs.Subject = 'Veeam Licenses Request';
                            cs.Description = 'Number of VMs : ' + opp.of_VMs_needed__c + '\nType of environment : ' + opp.Type_of_Environment__c;
                        }
                    }
                    insert cs;

                    
                    system.debug('opp.IsInvoiceCreated__c------->'+opp.IsInvoiceCreated__c);
                    Invoice__c invoice = new Invoice__c();
                    invoice.Opportunity__c=opp.Id;

                /*    if(opp.account.Send_Bill_To__c == 'Partner'){
                        invoice.Account__c=opp.Account.parentId;
                    }
                    else if(opp.account.Send_Bill_To__c == 'Direct' || opp.account.Send_Bill_To__c == 'Customer' ||  opp.account.Send_Bill_To__c == null)
                    {
                        
                    }*/

                    invoice.Account__c=opp.AccountId; 

                    Account accountToUpdateType = [SELECT Id, Name, Type, Status__c, Payment_method__c, Customer_Source__c, Account_Status__c FROM Account WHERE Id =: opp.account.Id];
                    accountToUpdateType.Type = 'Customer';
                    accountToUpdateType.Status__c = 'Active';
                    accountToUpdateType.Account_Status__c = 'Active';
                    if(!accountsToUpdate.contains(accountToUpdateType))
                    {
                        accountsToUpdate.add(accountToUpdateType);
                    }
                    if(String.isEmpty(accountToUpdateType.Customer_Source__c))
                    {
                        accountToUpdateType.Customer_Source__c = 'Organic';
                    }
                    if(String.isEmpty(accountToUpdateType.Payment_method__c))
                    {
                        accountToUpdateType.Payment_method__c = 'Bank Transfer';
                    }
                    
                    invoice.Status__c='Active';
                    invoice.Sign_Up_Date__c=System.Date.today();
                    invoice.Suppress_Standard_Invoice_Description__c=true;
                    //invoice.Billing_Run_Date__c = date.today().toStartOfMonth().addMonths(1);
                    invoice.Billing_Period__c = opp.Term__c;
                    invoice.Amount__c = opp.Amount;

                    invoice.Custom_Invoice_Description__c='';
                    if(opp.Account.Keepitsafe_Username__c != null)
                    {
                        invoice.Custom_Invoice_Description__c+= opp.Account.Keepitsafe_Username__c+ ' ';
                    }
                    if(opp.Package__c != null)
                    {
                        invoice.Custom_Invoice_Description__c+= opp.Package__c+ ' ';
                    }
                    if(opp.GB_Package__c != null)
                    {
                        invoice.Custom_Invoice_Description__c+= opp.GB_Package__c+ ' ';
                    }

                  //  invoice.Custom_Invoice_Description__c=opp.Account.Keepitsafe_Username__c+ '' +opp.Package__c+ '' +opp.GB_Package__c;
                        opp.IsInvoiceCreated__c = true;

                    System.debug('opp.account.Account_Status__c  = ' +opp.account.Account_Status__c );                   
                    listOfOppProductNames2.add(opp);
                    System.debug('listOfOppProductNames2 : ' + listOfOppProductNames2 );
                    lstOfInvoiceToUpdate.add(invoice);
                    System.debug('lstOfInvoiceToUpdate' + lstOfInvoiceToUpdate );
                }
            }
            
        }
        update accountsToUpdate;
        system.debug('lstOfInvoiceToUpdate------->'+lstOfInvoiceToUpdate);
        system.debug('listOfOppProductNames2------->'+listOfOppProductNames2);
        insert lstOfInvoiceToUpdate;       
        update listOfOppProductNames2;
        system.debug('lstOfInvoiceToUpdate------->'+lstOfInvoiceToUpdate);
        system.debug('listOfOppProductNames2------->'+listOfOppProductNames2);
        system.debug('lstOfAccountToUpdate----->'+lstOfAccountToUpdate);  
    }  
    
}