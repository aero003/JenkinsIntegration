public class KeepItSafeNLAccountHandler {

    public static final Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId();
    public static final Id RECORD_TYPE_KIS_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafe').getRecordTypeId();
    
 
    public static void KeepItSafeNLAccount(List<Account> newAccounts)
    {
    }

     public static void KeepItSafeNLUpdateAccountOwners(Map<Id,Account> oldAccounts, List<Account> newAccounts)
     {

        if(newAccounts == null)
        {
            return;
        }

         System.debug('Method: --> KeepItSafeNLUpdateAccountOwners');
         if(Trigger.isUpdate){
             System.debug('it is update');
         }
         else{
             System.debug('It is insert');
         }
         Set<Id> parentIdOfChangedOwner = new Set<Id>();
 
         //check if account was updated (new added or existing changed)

            for (Account newAcc : newAccounts)
            {
                Account oldAcc = null;
                if (newAcc.Id != null)
                {
                    oldAcc = oldAccounts.get(newAcc.Id);
                }

                // If Sales Owner or Parent Account has changed
                if (oldAcc == null ||
                oldAcc.Sales_Owner__c != newAcc.Sales_Owner__c ||
                oldAcc.ParentId != newAcc.ParentId )
                { 
                    // if record type is 'KeepItSafeNL' Set 'Country_Code__c' to NL
                    if (newAcc.RecordTypeId == RECORD_TYPE_KIS_NL_ID)
                    {
                        newAcc.Country_Code__c = 'NL';
                    }
                    else if (newAcc.RecordTypeId == RECORD_TYPE_KIS_ID)
                    {
                        newAcc.Country_Code__c = 'IE';
                    }
                parentIdOfChangedOwner.add(newAcc.parentId);
                }
            }
 
         // For Deleted accounts we cannot calculate new owners, so 'oldAccounts' are not processed
 
         // Searh for the parents of all the changed accounts
         Map<Id, Account> parentMap = new Map<Id, Account>();
         List<Account> tempParent = [SELECT Id, Name, RecordTypeId, Type, Sales_Owner__c FROM Account WHERE (RecordTypeId = :RECORD_TYPE_KIS_NL_ID OR RecordTypeId = :RECORD_TYPE_KIS_ID ) AND Type = 'Partner' AND Id IN :parentIdOfChangedOwner];
         for (Account acc: tempParent)
         {
             parentMap.put(acc.Id, acc);
         }
 
         // Update Sales Owner for Account that changed parent
         for(Account a : newAccounts)
         {

             // Check if account has Parent
             if(a.ParentId != null)
             {
                Account tempParentacc = parentMap.get(a.ParentId);
                
                // Check that the record types and support levels of parent and child match (accounts that are not partner type)
                if(!parentMap.containsKey(a.ParentId))
                {
                    Account tempParentRecordType = [SELECT Id, Name, RecordTypeId, Support_Level__c FROM Account WHERE Id=:a.ParentId];
                    if(tempParentRecordType.RecordTypeId != a.RecordTypeId)
                    {
                        a.RecordTypeId = tempParentRecordType.RecordTypeId;
                    }
                    if(a.RecordTypeId == RECORD_TYPE_KIS_NL_ID || a.RecordTypeId == RECORD_TYPE_KIS_ID)
                    {
                        // If account are Keep It Safe NL or IE, check if support levels match
                        if(tempParentRecordType.Support_Level__c != a.Support_Level__c)
                        {
                            a.Support_Level__c = tempParentRecordType.Support_Level__c;
                        }
                    }
                }

                if(tempParentacc != null )
                {
                    a.Sales_Owner__c = tempParentacc.Sales_Owner__c;
                     
                    //Chekc if record type ID is diffetent from parent record type ID (should be KeepItSafeNL)
                    if (a.RecordTypeId != tempParentacc.RecordTypeId)
                    {
                        a.RecordTypeId = tempParentacc.RecordTypeId;
                    }
                     // check if NL Country Code is not set
                    if ( a.RecordTypeId == RECORD_TYPE_KIS_NL_ID && a.Country_Code__c !='NL')
                    {
                        a.Country_Code__c ='NL';
                    }
                    if ( a.RecordTypeId == RECORD_TYPE_KIS_ID && a.Country_Code__c !='IE')
                    {
                        a.Country_Code__c ='IE';
                    }
                }   
            }
        
            // Check for appropriate Country Code in regards to RecordTypeId
            if(a.RecordTypeId == RECORD_TYPE_KIS_NL_ID)
            {
                if(a.Country_Code__c != 'NL')
                {
                    a.Country_Code__c = 'NL';
                }
            }
            if(a.RecordTypeId == RECORD_TYPE_KIS_ID)
            {
                if(a.Country_Code__c != 'IE')
                {
                    a.Country_Code__c = 'IE';
                }
            }
        }
     }
 
 
     public static void KeepItSafeNLUpdateChildAccountOwners(Map<Id, Account> oldAccounts,  List <Account> newAccounts)
     {
         Map<Id, Account> accountCahangedOwnerMap = new Map <Id, Account>();
 
         //check if Child account was updated (new added or existing changed) 
         if (newAccounts!=null) 
         {
             for (Account newAcc : newAccounts)
             { 
                 Account oldAcc = null;
                 if (oldAccounts != null)
                 {
                     // get the account before the update
                     oldAcc= oldAccounts.get(newAcc.Id);
                 }
                 // compare account sales Owner before update (oldAcc) and after update (newAcc) 
                 if (oldAcc == null || oldAcc.Sales_Owner__c != newAcc.Sales_Owner__c || newAcc.Sales_Owner__c == null)
                 {
                     accountCahangedOwnerMap.put(newAcc.Id, newAcc);
                 }
             }
         }
       
         // For Deleted accounts we cannot calculate new owners, so 'oldAccounts' are not processed
 
         // id's of changed parrent accounts
         Set<Id> parrentAccId = accountCahangedOwnerMap.keySet();
         List <Account> updatedChildAccounts = new list<Account>();
 
         // get the list of (child) accounts for updated (parent) accounts
         List<Account> childAcounts = [SELECT Id, ParentId, Name, RecordTypeId, Type, Sales_Owner__c FROM Account WHERE ParentId IN :parrentAccId];
         for(Account a : childAcounts)
         {
             Account tempParent = accountCahangedOwnerMap.get(a.ParentId);
             // chekc if child and parrent account sales owner is different 
             if(a.Sales_Owner__c != tempParent.Sales_Owner__c)
             {
                 a.Sales_Owner__c = tempParent.Sales_Owner__c;
                 if(!updatedChildAccounts.contains(a))
                    {
                      updatedChildAccounts.add(a);
                    }
             }
             // check if child record type is diferent then Parent record type ()
             if (a.RecordTypeId == RECORD_TYPE_KIS_NL_ID || a.RecordTypeId == RECORD_TYPE_KIS_ID)
             {
                 if (a.RecordTypeId!= tempParent.RecordTypeId)
                 {
                    a.RecordTypeId = tempParent.RecordTypeId;
                 }
                 //set 'Country_Code__c' to NL for KeepItSafeNL users
                 if(a.RecordTypeId == RECORD_TYPE_KIS_NL_ID)
                 {
                    a.Country_Code__c ='NL';
                 }
                 // set 'Country_Code__c' tp OE for KeepItSafeIE users
                 else 
                 {
                    a.Country_Code__c ='IE';    
                 }
                 if(!updatedChildAccounts.contains(a))
                {
                    updatedChildAccounts.add(a);
                }
             }
             
         }
         // Update child account if the account Sales Owner has changed
         update updatedChildAccounts;
     }
 
     public static void KeepItSafeNLUpdateContacOwners(Map<Id, Account> oldAccounts, List<Account> newAccounts)
     {
 
         List<Contact> listOfUpdatedContacts = new List<Contact>();
         Map<Id, Account> accountChangedOwnerMap = new Map <Id, Account>();    
 
         //check if account was updated (new added or existing changed)  
         if (newAccounts!=null) 
         {
             for (Account newAcc : newAccounts)
             {
 
                 Account oldAcc = null;
                 if (oldAccounts != null)
                 {
                     oldAcc= oldAccounts.get(newAcc.Id);
                 }
                 if (oldAcc == null || 
                 oldAcc.Sales_Owner__c != newAcc.Sales_Owner__c ||
                 oldAcc.ParentId != newAcc.ParentId)
                 {
                     accountChangedOwnerMap.put(newAcc.Id, newAcc);
                 }
             }
         }
 
         Set<Id> AccId = accountChangedOwnerMap.keySet();
         // get the list of Contacts for the account that owner has changed
         List<Contact> contacts = [SELECT Id, OwnerId, AccountId, MailingCountry FROM Contact WHERE AccountId IN :AccId];
         for(Contact con : contacts)
         {
             Account acc = accountChangedOwnerMap.get(con.AccountId);
             // Check if Sales owner on Account has changed?
             if ( acc!=null && con.OwnerID != acc.Sales_Owner__c)
             {
                 // set new Sales onwer to Contact (OwnerID)
                 if(acc.Sales_Owner__c != null)
                 {
                    con.OwnerID = acc.Sales_Owner__c;
                 }
                 if (con.MailingCountry == null ||  String.isEmpty(con.MailingCountry))
                 {
                     // cannot be null because validation rule does not allow empty MailingCountry
                     if(acc.RecordTypeId==RECORD_TYPE_KIS_NL_ID)
                     {
                        con.MailingCountry='NL';
                     }
                     else 
                     {
                        con.MailingCountry='IE';
                     }                    
                 }
                 listOfUpdatedContacts.add(con);
             }
         }
         update listOfUpdatedContacts;
     } 
 }