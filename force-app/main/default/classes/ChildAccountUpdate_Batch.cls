global class ChildAccountUpdate_Batch implements Database.Batchable<sObject>, schedulable 
{
        public Set<Id> ParrentIds;
        public static Id RECORD_TYPE_KIS_NL_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafeNL').getRecordTypeId();
        public static Id RECORD_TYPE_KIS_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('KeepItSafe').getRecordTypeId();
       

        global ChildAccountUpdate_Batch(Set<Id> parrent_Ids)
        {
            ParrentIds=parrent_Ids;
            System.debug('Parrent Ids: '+ ParrentIds);
        }
        
        global Database.QueryLocator start(Database.BatchableContext bc ) 
        {
            String listOfAccounts = 'SELECT Id, Name, MRR__c, ParentId, Customer_ID2__c, RecordTypeId, Special_Attention__c, High_Revenue__c, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c, (SELECT Id, Name, MRR__c, ParentId, Customer_ID2__c, RecordTypeId, Special_Attention__c, High_Revenue__c, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM ChildAccounts) FROM Account WHERE Id IN: ParrentIds order by CreatedDate';
            return Database.getQueryLocator(listOfAccounts);
        }
           
        global void execute(Database.BatchableContext bc, List<Account> accountList)
        {
            Boolean childAccountNeedUpdate = false;
            System.debug('List Of Accoutns :'+accountList);
            List<Account> listOfAccountsToUpdate = new List<Account>();
            List<Id> changedAccountIds = new List<Id>();
            // Process each batch of records
            
            for (Account parentAccount : accountList)
            {
                for(Account childrenAccount : parentAccount.ChildAccounts)
                {
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
                    if(parentAccount.Support_Level__c != childrenAccount.Support_Level__c)
                    {
                        System.debug('Different Support level Child:' + childrenAccount.Support_Level__c +' parent: '+ parentAccount.Support_Level__c);
                        childrenAccount.Support_Level__c = parentAccount.Support_Level__c;
                        childAccountNeedUpdate=true;
                    }    
                    // 3. Sales Owner
                    if(parentAccount.Sales_Owner__c != childrenAccount.Sales_Owner__c)
                    {
                        childrenAccount.Sales_Owner__c = parentAccount.Sales_Owner__c;
                        childAccountNeedUpdate=true;
                    }
                    // ---------------------------------- START KeepItSafe_LiveVault_KeepItSafe --------------------------
                    // Map Special_Attention__c from parent
                    if(childrenAccount.Special_Attention__c != parentAccount.Special_Attention__c)
                    {
                        childrenAccount.Special_Attention__c = parentAccount.Special_Attention__c;
                        childAccountNeedUpdate=true;
                    }
                    // Map High_Revenue__c from parent
                    if(childrenAccount.High_Revenue__c != parentAccount.High_Revenue__c)
                    {
                        childrenAccount.High_Revenue__c = parentAccount.High_Revenue__c;
                        childAccountNeedUpdate=true;
                    }
                    // ---------------------------------- END KeepItSafe_LiveVault_KeepItSafes ---------------------------            
                    
                    if  (!changedAccountIds.contains(childrenAccount.Id) && childAccountNeedUpdate)
                    {
                        System.debug('The Account with name: '+  childrenAccount.name + ' has ID: '+ childrenAccount.id);
                        changedAccountIds.add(childrenAccount.Id);
                        listOfAccountsToUpdate.add(childrenAccount);
                    }
                }
            }
            update listOfAccountsToUpdate;
            listOfAccountsToUpdate.clear();
        }

        global void execute(SchedulableContext SC) 
        {
            database.executebatch(new ChildAccountUpdate_Batch(ParrentIds));
        }

        global static void start(Set<Id> parentIds)
        {

            String second = String.valueOf(Datetime.now().second());
            String minute = String.valueOf(Datetime.now().minute() + 1);
            String hour = String.valueOf(Datetime.now().hour()); 
            String day = String.valueOf(Datetime.now().day());
            String month = String.valueOf(Datetime.now().month());
            String year = String.valueOf(Datetime.now().year());
            integer updateHour= integer.valueof(day);

            if (Integer.valueOf(hour) >= 23 && Integer.valueOf(minute) >= 59)
            {
                hour='0';
                minute = '0';
                integer updatedday= integer.valueof(day);
                updatedday= updatedday+1;
                day = String.valueOf(updatedday);
                system.debug('new day: ' + day);
                system.debug('new hour: ' + hour);
                
                system.debug('new minute: '+minute );
            }
            else if (Integer.valueOf(minute)>=59)
            {
                minute = '0';
                integer updatedhour = integer.valueof(hour);
                updatedhour = updatedhour + 1;
                hour = String.valueOf(updatedhour);
                system.debug('new hour: '+ hour);
            }
        
            Integer randomNumber = Integer.valueof((Math.random() * 10000));
            System.debug('randomNumber is'+randomNumber);

            String nextFireTimeJob = second + ' ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ? ' + year;
            string jobName = 'UpdateChildAccount';
            jobName = jobName += ' - ' +randomNumber+datetime.now().format();
            system.schedule(jobName, nextFireTimeJob, new ChildAccountUpdate_Batch(parentIds));
        }
        
        global void finish(Database.BatchableContext bc) 
        {
            AsyncApexJob job = [Select ID, status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE ID = :bc.getJobId()];
            system.debug('job id :'+ job);
        }
    }