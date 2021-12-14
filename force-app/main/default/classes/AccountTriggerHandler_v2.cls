public with sharing class AccountTriggerHandler_v2 {

    // Declare global variables
    public static Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafe').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_UK_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeUK').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_US_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeUS').getRecordTypeId();
    public static Id RECORD_TYPE_KIS_CA_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeCA').getRecordTypeId();

    // TO DO : Check if this is the correct RecordType to set for Accounts with Brand__c = 'MyFax'
    public static Id RECORD_TYPE_MyFax= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('MyFax_Account').getRecordTypeId();



    public static void BeforeInsertEvent(List<Account> newAccounts, Map<Id,Account> newAccountsMap, Map<Id,Account> oldAccountsMap, Boolean isUpdate) 
    {
        Set<Id> IdsOfParents = new Set<Id>();
        List<Account> ListOfParents = new List<Account>();
        Map<Id, Account> mapParentId_ParentAccount = new Map<Id, Account>();
        List<Account> lstAccountKIS = new List<Account>();

        // ------------------------- START KeepItSafeNLAccountHandler - NLUpdateAccountOwners() -------------------------



        for (Account newAcc : newAccounts)
        {           
            // Set Country code based on the RecordTypeId
            if (newAcc.RecordTypeId == RECORD_TYPE_KIS_NL_ID)
            {
                newAcc.Country_Code__c = 'NL';
            }
            if (newAcc.RecordTypeId == RECORD_TYPE_KIS_ID)
            {
                newAcc.Country_Code__c = 'IE';
            }
            // Check if Account is 'Child Account'
            if (newAcc.ParentId != null)
            {
                IdsOfParents.add(newAcc.ParentId);
            }
            // Gather Account that are appropriate for AccountTriggerCustomerIdHandler
            if(!string.isEmpty(newAcc.RecordTypeId) || newAcc.Account_Record_Type_Hidden__c == 'KeepItSafe: Lead')
            {
                string recordtypename = Schema.SObjectType.Account.getRecordTypeInfosById().get(newAcc.recordtypeid).getname();
                if(recordtypename.contains('KeepItSafe') || newAcc.Account_Record_Type_Hidden__c == 'KeepItSafe: Lead')
                {
                    lstAccountKIS.add(newAcc);
                }
            }
        }

        // Query for Parent Accounts if neccessary
        if(IdsOfParents.size() > 0)
        {
            ListOfParents = [SELECT Id, Name, RecordTypeId, Sales_Owner__c, Special_Attention__c, High_Revenue__c, Support_Level__c FROM Account WHERE Id IN: IdsOfParents];
            for(Account parent : ListOfParents)
            {
                mapParentId_ParentAccount.put(parent.Id, parent);
            }
        }

        // ----------------------------------- START AccountTriggerCustomerIdHandler -----------------------------------        
        if((System.Label.AccountCustomerIDTriggerSwitch == 'On' || System.Label.AccountCustomerIDTriggerSwitch == '') && lstAccountKIS.size() > 0)
        {       
            AccountTriggerCustomerIdHandler_v2 CustomerIdHandler = new AccountTriggerCustomerIdHandler_v2(Trigger.isExecuting, Trigger.size);
            CustomerIdHandler.SetCustomerIDs_BeforeInsert(lstAccountKIS, trigger.isinsert);
        }
        // ----------------------------------- END  AccountTriggerCustomerIdHandler ------------------------------------        

        for(Account account : newAccounts)
        {
            // ------------------------------------- START AccountMyFaxRecordTypeSet ---------------------------------------
            if(account.Brand__c == 'MyFax')
            {
                account.RecordTypeid = RECORD_TYPE_MyFax;
            }
            // -------------------------------------- END  AccountMyFaxRecordTypeSet ---------------------------------------

            if(account.ParentId != null)
            {
                    Account Parent = mapParentId_ParentAccount.get(account.ParentId);

                    // Set the same values on Parent and Child for :
                        // 1. RecordTypeId
                    if(Parent.RecordTypeId != account.RecordTypeId)
                    {
                        account.RecordTypeId = Parent.RecordTypeId;
                        if (account.RecordTypeId == RECORD_TYPE_KIS_NL_ID)
                        {
                            account.Country_Code__c = 'NL';
                        }
                        if (account.RecordTypeId == RECORD_TYPE_KIS_ID)
                        {
                            account.Country_Code__c = 'IE';
                        }
                    }
                        // 2. Support Level
                    if(Parent.Support_Level__c != account.Support_Level__c)
                    {
                        account.Support_Level__c = Parent.Support_Level__c;
                    }    
                        // 3. Sales Owner
                    if(Parent.Sales_Owner__c != account.Sales_Owner__c)
                    {
                        account.Sales_Owner__c = Parent.Sales_Owner__c;
                    }
                    // ---------------------------------- START KeepItSafe_LiveVault_KeepItSafe --------------------------
                    // Map Special_Attention__c from parent
                    if(account.Special_Attention__c != Parent.Special_Attention__c)
                    {
                        account.Special_Attention__c = Parent.Special_Attention__c;
                    }
                    // Map High_Revenue__c from parent
                    if(account.High_Revenue__c != Parent.High_Revenue__c)
                    {
                        account.High_Revenue__c = Parent.High_Revenue__c;
                    }
                    // ---------------------------------- END KeepItSafe_LiveVault_KeepItSafes ---------------------------            
            }
        }
        // ------------------------- END KeepItSafeNLAccountHandler - NLUpdateAccountOwners() -------------------------

        // ------------------------------------- START FormatAccountBillingStreet -------------------------------------
        AccountTriggerHandler_v2_Helper.FormatAccBillingStreet(newAccounts);
        // ----------------------------------- END FormatAccountBillingStreet   ---------------------------------------
        
        // ----------------------------------- START LiveVault_KeepItSafe_Hierarchy -----------------------------------
        //AccountTriggerHandler_v2_Helper.Hierarchy_KeepItSafe_LiveVault(newAccounts, newAccountsMap, oldAccountsMap, isUpdate);
        // --------------------------------- END LiveVault_KeepItSafe_Hierarchy   -------------------------------------
        
    }

    public static void AfterInsertEvent(List<Account> newAccounts, Map<Id,Account> newAccountsMap, Map<Id,Account> oldAccountsMap, Boolean isUpdate) 
    {
        /* 
        In all functions of the after insert event
        !! Make sure that returned lists of accounts (that is updated at the end) always include all of the fields required for updating and usage in all of the functions!!
        Should the needed fields be hardcoded as variable (list of strings) and sent to helper functions ??

        UNIQUE NEEDED FIELDS:
        -   Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, 
        Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c

        
        ! Queries can be dynamically created (https://webkul.com/blog/execute-a-dynamically-created-query-in-apex/)
        - create a List<String> that will include all the needed fields for the After insert event
        - send List<String> to helper functions as argument
        - create querry from the List<String> in helper functions to ensure that all of the needed fields are present
        */
        
        // "Global" list of accounts to be updated
        List<Account> recordsToUpdate = new List<Account>();
        List<Account> recordsToUpdate2 = new List<Account>(); 

        // ----------------------------------- START SAccountTriggerHandler.doAfterInsert() ----------------------------------  
        AccountTriggerHandler_v2_Helper.syncWithOracle(null, newAccountsMap, false);

        // doAfterInsert() sets also the same Sales_owner__c and Support_Level__c on Child and Parent, which is already handled in the BeforeInsertEvent() function
        // and should not be needed to execute in AfterInsertEvent too.

        // ----------------------------------- END SAccountTriggerHandler.doAfterInsert() -------------------------------------  

        // ----------------------------------- START KNLAccHandler.KeepItSafeNLUpdateContactOwners ----------------------------
            // Method does not update the account objects - therefore there is no return statement (also the queries don't need to follow the protocol)  
            // Must be called in after insert event - because the Id of the record is needed to find the associated Contact
        System.debug('OldAccount Map'+ oldAccountsMap);
        AccountTriggerHandler_v2_Helper.KeepItSafeNLUpdateContacOwners(oldAccountsMap, newAccounts);
        // ----------------------------------- END KNLAccHandler.KeepItSafeNLUpdateContactOwners ------------------------------ 

        // ----------------------------------- START AccountTriggerCustomerIdHandler ------------------------------------------   
        List<Account> lstAccountKIS = new List<Account>();

        for (Account newAcc : newAccounts)
        {           
            // Gather Account that are appropriate for AccountTriggerCustomerIdHandler
            if(!string.isEmpty(newAcc.RecordTypeId) || newAcc.Account_Record_Type_Hidden__c == 'KeepItSafe: Lead')
            {
                string recordtypename = Schema.SObjectType.Account.getRecordTypeInfosById().get(newAcc.recordtypeid).getname();
                if(recordtypename.contains('KeepItSafe') || newAcc.Account_Record_Type_Hidden__c == 'KeepItSafe: Lead')
                {
                    lstAccountKIS.add(newAcc);
                }
            }
        }

        if((System.Label.AccountCustomerIDTriggerSwitch == 'On' || System.Label.AccountCustomerIDTriggerSwitch == '') && lstAccountKIS.size() > 0)
        {       
            AccountTriggerCustomerIdHandler_v2 CustomerIdHandler = new AccountTriggerCustomerIdHandler_v2(Trigger.isExecuting, Trigger.size);
            recordsToUpdate = CustomerIdHandler.SetCustomerIDs_AfterInsert(lstAccountKIS, trigger.isinsert);
        }
        // ----------------------------------- END  AccountTriggerCustomerIdHandler ---------------------------------------------

        // Handle the duplicates in Accouts to update lists
        if(recordsToUpdate2 != null && recordsToUpdate != null)
        {
            if(recordsToUpdate2.size() > 0)
            {
                for(Account accountToAdd : recordsToUpdate2)
                {
                    for (Integer i = (recordsToUpdate.size()-1) ; i>= 0 ; i--)
                    {
                        // Check if list has duplicate object
                        if(recordsToUpdate[i].Id == accountToAdd.Id)
                        {
                            // Remove the old account (duplicate) and add the new one (after all updates)
                            recordsToUpdate.remove(i);
                            recordsToUpdate.add(accountToAdd);
                        }
                    }
                }
            }
        }

        if(recordsToUpdate == null)
        {
            if(recordsToUpdate2 != null)
            {
                update recordsToUpdate2;
            }
        }

        if(recordsToUpdate != null)
        {
            if(recordsToUpdate.size() > 0)
            {
                update recordsToUpdate;
            }
        }

    }

    public static void BeforeUpdateEvent(List<Account> newAccounts, Map<Id,Account> newAccountsMap, Map<Id,Account> oldAccountsMap, Boolean isUpdate) 
    {
        if(System.isBatch())
        {
            return;
        }

        List<Account> accountsToUpdateSalesOwner = new List<Account>();
        List<Account> lstAccountKIS = new List<Account>();
        Map<Id, Account> mapParentId_ParentAccount = new Map<Id, Account>();
        Set<Id> IdsOfParents = new Set<Id>();
        List<Account> ListOfParents = new List<Account>();


          // ------------------------- START KeepItSafeNLAccountHandler - NLUpdateAccountOwners() -------------------------
        //get ID's of parents Accounts
        for (Account newAcc : newAccounts)
        {
            if (newAcc.ParentId != null)
            {
                IdsOfParents.add(newAcc.ParentId);
            }
        }
        
        // Query for Parent Accounts
        if(IdsOfParents.size() > 0)
        {
            ListOfParents = [SELECT Id, Name, RecordTypeId, Sales_Owner__c, Support_Level__c, (SELECT Id FROM ChildAccounts WHERE Status__c='Active') FROM Account WHERE Id IN: IdsOfParents];
            for(Account parent : ListOfParents)
            {
                mapParentId_ParentAccount.put(parent.Id, parent);
            }
        }

        //update account and child account Sales Owner, Support level
        for (Account newAcc : newAccounts)
        {    
            Datetime forLoopStart = DateTime.Now();
            // Set Country code based on the RecordTypeId
            if (newAcc.RecordTypeId == RECORD_TYPE_KIS_NL_ID)
            {
                newAcc.Country_Code__c = 'NL';
            }
            if (newAcc.RecordTypeId == RECORD_TYPE_KIS_ID)
            {
                newAcc.Country_Code__c = 'IE';
            }
            // Check if Account is 'Child Account'
            if (newAcc.ParentId != null)
            {
                Account Parent = mapParentId_ParentAccount.get(newAcc.ParentId);

                // Update sales owner field if needed
                if(newAcc.Sales_owner__c != Parent.Sales_owner__c)
                {
                    newAcc.Sales_owner__c = Parent.Sales_owner__c;
                }

                // update accout support level to match with Parrent
                if (newAcc.Support_Level__c != Parent.Support_Level__c) 
                {
                    newAcc.Support_Level__c= Parent.Support_Level__c;
                }

                if(!accountsToUpdateSalesOwner.contains(newAcc))
                {
                    accountsToUpdateSalesOwner.add(newAcc);
                }
            }
            // ------------------------------------- START AccountMyFaxRecordTypeSet ---------------------------------------
            if(newAcc.Brand__c == 'MyFax')
            {
                newAcc.RecordTypeid = RECORD_TYPE_MyFax;
            }
            // -------------------------------------- END  AccountMyFaxRecordTypeSet ---------------------------------------
            
            // for measuring code execution duration for some parts of code 
            /*    Datetime forLoopEnd = DateTime.Now();

            Long msStart = forLoopStart.getTime();
            Long msEnd = forLoopEnd.getTime();
            Long diff = msEnd - msStart;
            System.debug('Execution time Before Update For Lopp [ms]: ' + diff);*/
        }

        // Should LiveVault_KeepItSafe_Hierarchy be moved to after update ?
        // Even if the function is in before update - the update statement is needed to satisfy the tests - we are trying to avoid multiple update statements...

        // Addition to the before insert events ;
        // Always check if the object that has raised the trigger is Child / Parent
        // No matter if the child or parent is updated, you must verify that parent and child do have the same values (sales_owner, support_level)
        
        // ------------------------------------- START FormatAccountBillingStreet -------------------------------------
        AccountTriggerHandler_v2_Helper.FormatAccBillingStreet(newAccounts);
        // ----------------------------------- END FormatAccountBillingStreet   ---------------------------------------

    }

    public static void AfterUpdateEvent(List<Account> newAccounts, Map<Id,Account> newAccountsMap, Map<Id,Account> oldAccountsMap, Boolean isUpdate) 
    {
        // Create list of Accounts (for the update statement) -> which is used as argument for functions
        // and the list that function returns its values

     /*   if(System.isBatch())
        {
            return;
        }*/

        List<Account> recordsToUpdate = new List<Account>(); 
        List<Account> recordsToUpdate2 = new List<Account>(); 
        Boolean needsUpdate = false;
        List<Account> accountsToUpdateSalesOwner = new List<Account>();
        List<Account> lstAccountKIS = new List<Account>();
        Map<Id, Account> mapChildId_ChildAccount = new Map<Id, Account>();
        Map<Id, Account> mapParentId_ParentAccount = new Map<Id,Account>();
        Set<Id> IdsOfParents = new Set<Id>();
        List<Account> ListOfChilds = new List<Account>();

        // ---------------------------------- START KNLAccHandler.KeepItSafeNLUpdateChildAccountOwners --------------------------
        //get ID's of parents Accounts
        for (Account newAcc : newAccounts)
        {
            if (newAcc.Parentid == null && newAcc.Type=='Partner')
            {
                System.debug('ADDING PARENT ID: '+ newAcc.Id);
                IdsOfParents.add(newAcc.Id);
                mapParentId_ParentAccount.put(newAcc.Id, newAcc);
            }
        }
        
        // Query for update child Accounts
        if(IdsOfParents.size() > 0)
        {
            //get Child accounts for Each Parrent

            List<Account> ListOfChildAccountsforScheduledUpdpate = new List<Account>();
            Boolean parentAccountNeedUpdate = false;
            Set<Id> parentIds = new Set<Id>();
            for(id IdofParent:IdsOfParents)
            {
                Account parentAccount= mapParentId_ParentAccount.get(IdofParent);
             
              List<Account> ListOfChildAccounts = [SELECT Id, Name, MRR__c, ParentId, Customer_ID2__c, RecordTypeId, Special_Attention__c, High_Revenue__c, CreatedDate, Sales_Owner__c, Type, Country_Code__c, 
                Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, 
                Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account WHERE ParentId =: IdofParent order by CreatedDate];

                
                If(ListOfChildAccounts.size() > 0)
                {
                    // verify if any important field is different with parent comparison
                    for (Account childrenAccount : ListOfChildAccounts)
                    {
                        Account tempParent = mapParentId_ParentAccount.get(childrenAccount.ParentId);
                        if(tempParent != null)
                        {
                            Account parentOld = oldAccountsMap.get(tempParent.Id);
                            Account parentNew = newAccountsMap.get(tempParent.Id);

                            if(parentAccount.RecordTypeId != childrenAccount.RecordTypeId)
                            {
                                childrenAccount.RecordTypeId = parentAccount.RecordTypeId;
                                if (childrenAccount.RecordTypeId == RECORD_TYPE_KIS_NL_ID)
                                {
                                    childrenAccount.Country_Code__c = 'NL';
                                }
                                if (childrenAccount.RecordTypeId == RECORD_TYPE_KIS_ID)
                                {
                                    childrenAccount.Country_Code__c = 'IE';
                                }
                            }
                                // 2. Support Level
                            // Map Sales_owner from parent
                            if(parentOld.Support_Level__c != parentNew.Support_Level__c)
                            {
                                parentAccountNeedUpdate=true;
                            }
                                // 3. Sales Owner
                            // Map Sales_owner from parent
                            if(parentOld.Sales_Owner__c != parentNew.Sales_Owner__c)
                            {
                                parentAccountNeedUpdate=true;
                            }
                            // ---------------------------------- START KeepItSafe_LiveVault_KeepItSafe --------------------------
                            // Map Special_Attention__c from parent
                            if(parentOld.Special_Attention__c != parentNew.Special_Attention__c)
                            {
                                parentAccountNeedUpdate=true;
                            }
                            // Map High_Revenue__c from parent
                            if(parentOld.High_Revenue__c != parentNew.High_Revenue__c)
                            {
                                parentAccountNeedUpdate=true;
                            }
                            // ---------------------------------- END KeepItSafe_LiveVault_KeepItSafes ---------------------------            
                            
                            if (parentAccountNeedUpdate)
                            {
                                ListOfChildAccountsforScheduledUpdpate.add(childrenAccount);
                            }
                            parentAccountNeedUpdate = false;
                        } // endif Parrent !=null
                    }// end for loop and verification for Child Account
                }// end of check if child accountt exist

                 // check if list of account which should be updated is larger then 11
                if (ListOfChildAccountsforScheduledUpdpate.size() > 11)
                {
                    parentIds.add(IdofParent);
                }
                // if child account number is lower than 10
                else 
                {  
                    for(Account child : ListOfChildAccountsforScheduledUpdpate)
                    //   for(Account child : ListOfChilds)
                    {
                        Account tempParent = mapParentId_ParentAccount.get(child.ParentId);
                        if(tempParent != null)
                        {
                            Account parentOld = oldAccountsMap.get(tempParent.Id);
                            Account parentNew = newAccountsMap.get(tempParent.Id);
                            
                            // Map Sales_owner from parent
                            if(parentOld.Sales_owner__c != parentNew.Sales_owner__c)
                            {
                                if(child.Sales_owner__c != tempParent.Sales_owner__c)
                                {
                                    child.Sales_owner__c = tempParent.Sales_owner__c;
                                    System.debug('Sales owner update - AfterUpdate AccountTriggerHandlerV2');
                                    needsUpdate = true;
                                }
                            }
        
                            // Map Support_Level from parent
                            if(parentOld.Support_Level__c != parentNew.Support_Level__c)
                            {
                                if(child.Support_Level__c != tempParent.Support_Level__c)
                                {
                                    child.Support_Level__c = tempParent.Support_Level__c;
                                    System.debug('Support Level update - AfterUpdate AccountTriggerHandlerV2');
                                    needsUpdate = true;
                                }
                            }
                            // ---------------------------------- START KeepItSafe_LiveVault_KeepItSafe --------------------------
                            // Map Special_Attention__c from parent
                            if(parentOld.Special_Attention__c != parentNew.Special_Attention__c)
                            {
                                if(child.Special_Attention__c != tempParent.Special_Attention__c)
                                {
                                    child.Special_Attention__c = tempParent.Special_Attention__c;
                                    System.debug('Special attention update - AfterUpdate AccountTriggerHandlerV2');
                                    needsUpdate = true;
                                }
                            }
                            // Map High_Revenue__c from parent
                            if(parentOld.High_Revenue__c != parentNew.High_Revenue__c)
                            {
                                if(child.High_Revenue__c != tempParent.High_Revenue__c)
                                {
                                    child.High_Revenue__c = tempParent.High_Revenue__c;
                                    System.debug('High Revenue update - AfterUpdate AccountTriggerHandlerV2');
                                    needsUpdate = true;
                                }
                            }
                            // ---------------------------------- END KeepItSafe_LiveVault_KeepItSafes ---------------------------
                            // Map RecordTypeId from parent
                            if(child.RecordTypeId != tempParent.RecordTypeId)
                            {
                                child.RecordTypeId = tempParent.RecordTypeId;
        
                                if ((child.RecordTypeId == RECORD_TYPE_KIS_NL_ID) && (child.Country_Code__c != 'NL'))
                                {
                                    child.Country_Code__c = 'NL';
                                    System.debug('Country code update - AfterUpdate AccountTriggerHandlerV2');
                                }
                                if ((child.RecordTypeId == RECORD_TYPE_KIS_ID) && (child.Country_Code__c != 'IE'))
                                {
                                    child.Country_Code__c = 'IE';
                                    System.debug('Country code update - AfterUpdate AccountTriggerHandlerV2');
                                }
        
                                needsUpdate = true;
                            }
                        }
                        if(needsUpdate)
                        {
                            recordsToUpdate.add(child);
                        }
                        needsUpdate = false;
                    } // end for loop for child account verification support_level,Sales_owner__c,High_Revenue__c...
                }// end else uf there is less then 11 child accounts
            } // end loop through id of parrents

            if (parentIds.size() > 0)
            {
                // update child accounts with batch (if there is more then 11 child accounts)
                ChildAccountUpdate_Batch.start(parentIds);
            }
        }
        // ---------------------------------- END KNLAccHandler.KeepItSafeNLUpdateChildAccountOwners --------------------------

        // ----------------------------------- START KNLAccHandler.KeepItSafeNLUpdateContactOwners ----------------------------
        // Method does not update the account objects - therefore there is no return statement (also the queries don't need to follow the protocol)  
        // Must be called in after insert event - because the Id of the record is needed to find the associated Contact
        // If contact was alredy updated
        if (ContactTriggerHandler.hasFiredContactTrigger == false)
        {
            AccountTriggerHandler_v2_Helper.KeepItSafeNLUpdateContacOwners(oldAccountsMap, newAccounts);
        }
        // ----------------------------------- END KNLAccHandler.KeepItSafeNLUpdateContactOwners ------------------------------ 

        // --------------------------------------- START AccountTriggerHandler.doAfterUpdate ----------------------------------
        AccountTriggerHandler_v2_Helper.syncWithOracle(oldAccountsMap, newAccountsMap, true);
        
        // doAfterUpdate sets the same Sales_owner and Support_Level from Parent to Child account
        // This logic is already handled in KNLAccHandler.KeepItSafeNLUpdateChildAccountOwners

        // ---------------------------------------- END AccountTriggerHandler.doAfterUpdate -----------------------------------

        /* 
        In all functions of the after update event
        !! Make sure that returned lists of accounts (that is updated at the end) always include all of the fields required for updating and usage in all of the functions!!
        Should the needed fields be hardcoded as variable (list of strings) and sent to helper functions ??
        - Verify all of the queries in helper functions []

        UNIQUE NEEDED FIELDS:
        -   Id, Name, ParentId, Customer_ID2__c, RecordTypeId, Special_Attention__c, MRR__c, High_Revenue__c, CreatedDate, Sales_Owner__c, Type, Country_Code__c, 
        Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, 
        Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c
        
        ! Queries can be dynamically created (https://webkul.com/blog/execute-a-dynamically-created-query-in-apex/)
        - create a List<String> that will include all the needed fields for the After update event
        - send List<String> to helper functions as argument
        - create querry from the List<String> in helper functions to ensure that all of the needed fields are present
        */

        // ----------------------------------- START LiveVault_KeepItSafe_Hierarchy -----------------------------------
        //recordsToUpdate2 = AccountTriggerHandler_v2_Helper.Hierarchy_KeepItSafe_LiveVault(recordsToUpdate, newAccountsMap, oldAccountsMap, isUpdate);
        // --------------------------------- END LiveVault_KeepItSafe_Hierarchy   -------------------------------------


        // Handle the duplicates in Accouts to update lists
        if(recordsToUpdate2 != null && recordsToUpdate != null)
        {
            if(recordsToUpdate2.size() > 0)
            {
                for(Account accountToAdd : recordsToUpdate2)
                {
                    for (Integer i = (recordsToUpdate.size()-1) ; i>= 0 ; i--)
                    {
                        // Check if list has duplicate object
                        if(recordsToUpdate[i].Id == accountToAdd.Id)
                        {
                            // Remove the old account (duplicate) and add the new one (after all updates)
                            recordsToUpdate.remove(i);
                            recordsToUpdate.add(accountToAdd);
                        }
                    }
                }
            }
        }

        if(recordsToUpdate == null)
        {
            if(recordsToUpdate2 != null)
            {
                update recordsToUpdate2;
            }
        }
        
        if(recordsToUpdate != null)
        {
            if(recordsToUpdate.size() > 0)
            {
                update recordsToUpdate;
            }
        }
    }
}