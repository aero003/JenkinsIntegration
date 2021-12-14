public class AccountTriggerCustomerIdHandler_v2 {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    public static boolean isRunOnce = false;
    public static String  KUS_RecordTypeId = '';        
    public static String KIE_RecordTypeId = '';  
    public static String KCA_RecordTypeId = '';  
    public static String KUK_RecordTypeId = '';  
    public static String KIC_RecordTypeId = '';  
    public static String KDK_RecordTypeId = '';  
    public static String KNL_RecordTypeId = '';
    public static String KNZ_RecordTypeId = '';
    
    
    public AccountTriggerCustomerIdHandler_v2(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    //Public void onBeforeInsertUpdate(List<Account> newAccount, boolean IsBeforeInsert){
    public List<Account> SetCustomerIDs_AfterInsert(List<Account> newAccount, boolean IsBeforeInsert){

        isRunOnce = true;
        system.debug('Before insert update...');
        // List of accounts with Empty CustId__c List. 
        List <Account> KUS_EmptyCustId_List = new List <Account>();
        List <Account> KIE_EmptyCustId_List = new List <Account>();
        List <Account> KCA_EmptyCustId_List = new List <Account>();
        List <Account> KUK_EmptyCustId_List = new List <Account>();
        List <Account> KIC_EmptyCustId_List = new List <Account>();
        List <Account> KDK_EmptyCustId_List = new List <Account>();
        List <Account> KNL_EmptyCustId_List = new List <Account>();
        List <Account> KNZ_EmptyCustId_List = new List <Account>();     
        
        // List of accounts with NonEmpty CustId__c List used for Update DML. 

        List<Account> Accounts_forUpdateList = new List<Account>();
        
        Integer HighestNumberKUS=0;
        Integer HighestNumberKIE=0;
        Integer HighestNumberKCA=0;
        Integer HighestNumberKUK=0;
        Integer HighestNumberKIC=0;
        Integer HighestNumberKDK=0;
        Integer HighestNumberKNL=0;
        Integer HighestNumberKNZ=0;
        
        //set of Id's
        Set<Id> newAccountIds = new Set<Id>();
        if(!IsBeforeInsert){
            newAccountIds = (new Map<Id,SObject>(newAccount)).keySet();
        }

        Boolean KUS_needed = false;
        Boolean KIE_needed = false;
        Boolean KCA_needed = false;
        Boolean KUK_needed = false;
        Boolean KIC_needed = false;
        Boolean KDK_needed = false;
        Boolean KNL_needed = false;
        Boolean KNZ_needed = false;  

        KUS_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeUS').RecordTypeId;
        KIE_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafe').RecordTypeId;
        KCA_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeCA').RecordTypeId;
        KUK_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeUK').RecordTypeId;
        KIC_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeIC').RecordTypeId;
        KDK_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeDK').RecordTypeId;
        KNL_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeNL').RecordTypeId;
        KNZ_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeNZ').RecordTypeId;

        
        for(Account accRTcheck : newAccount)
        {
            if(accRTcheck.RecordTypeId == KUS_RecordTypeId)
            {
                KUS_needed = true;
            }
            if(accRTcheck.RecordTypeId == KIE_RecordTypeId)
            {
                KIE_needed = true;
            }
            if(accRTcheck.RecordTypeId == KCA_RecordTypeId)
            {
                KCA_needed = true;
            }
            if(accRTcheck.RecordTypeId == KUK_RecordTypeId)
            {
                KUK_needed= true;
            }
            if(accRTcheck.RecordTypeId == KIC_RecordTypeId)
            {
                KIC_needed = true;
            }
            if(accRTcheck.RecordTypeId == KDK_RecordTypeId)
            {
                KDK_needed = true;
            }
            if(accRTcheck.RecordTypeId == KNL_RecordTypeId)
            {
                KNL_needed = true;
            }
            if(accRTcheck.RecordTypeId == KNZ_RecordTypeId)
            {
                KNZ_needed = true;
            }
        }
        
        // Current Highest KUS/KIE/KCA/KUK/KIC/KDK/KNL/KNZ  Customer_ID2__c Numbers in DB
        String Highest_KUS_CustID=''; // initialize String
        List <Account> Highest_KUS_CustID_List= new List <Account>();
        if(KUS_RecordTypeId!='' && KUS_needed == true){
            Highest_KUS_CustID_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KUS_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KUS%' Order by Customer_ID2__c Desc Limit 1];
        }
        if (Highest_KUS_CustID_List.size()>0) {
            
            Highest_KUS_CustID= Highest_KUS_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KUS_CustID' +Highest_KUS_CustID );
        
        String Highest_KIE_CustID=''; // initialize String
        List <Account> Highest_KIE_CustID_List= new List <Account>();
        if(KIE_RecordTypeId!='' && KIE_needed == true){
            Highest_KIE_CustID_List= [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KIE_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KIE%' Order by Customer_ID2__c Desc Limit 1];
        }
        
        if (Highest_KIE_CustID_List.size()>0) {
            
            Highest_KIE_CustID= Highest_KIE_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KIE_CustID' +Highest_KIE_CustID );
        
        String Highest_KCA_CustID=''; // initialize String
        List <Account> Highest_KCA_CustID_List= new List <Account>();
        if(KCA_RecordTypeId!='' && KCA_needed == true){
            Highest_KCA_CustID_List= [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KCA_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KCA%' Order by Customer_ID2__c Desc Limit 1];
        }
        
        if (Highest_KCA_CustID_List.size()>0) {
            
            Highest_KCA_CustID= Highest_KCA_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KCA_CustID' +Highest_KCA_CustID );
        
        String Highest_KUK_CustID=''; // initialize String
        List <Account> Highest_KUK_CustID_List= new List <Account>();
        if(KUK_RecordTypeId!='' && KUK_needed == true){
            Highest_KUK_CustID_List= [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KUK_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KUK%' Order by Customer_ID2__c Desc Limit 1];
        }
        
        if (Highest_KUK_CustID_List.size()>0) {
            
            Highest_KUK_CustID= Highest_KUK_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KUK_CustID' +Highest_KUK_CustID );
        
        String Highest_KIC_CustID=''; // initialize String
        List <Account> Highest_KIC_CustID_List= new List <Account>();
        if(KIC_RecordTypeId!='' && KIC_needed == true){
            Highest_KIC_CustID_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KIC_RecordTypeId And Customer_ID2__c !=''  and Customer_ID2__c like 'KIC%' Order by Customer_ID2__c Desc Limit 1];
        }
        if (Highest_KIC_CustID_List.size()>0) {
            
            Highest_KIC_CustID= Highest_KIC_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KIC_CustID' +Highest_KIC_CustID );
        
        String Highest_KDK_CustID=''; // initialize String
        List <Account> Highest_KDK_CustID_List= new List <Account>();
        if(KDK_RecordTypeId!='' && KDK_needed == true){
            Highest_KDK_CustID_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KDK_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KDK%' Order by Customer_ID2__c Desc Limit 1];
        }
        if (Highest_KDK_CustID_List.size()>0) {
            
            Highest_KDK_CustID= Highest_KDK_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KDK_CustID' +Highest_KDK_CustID );
        
        String Highest_KNL_CustID=''; // initialize String
        List <Account> Highest_KNL_CustID_List= new List <Account>();
        if(KNL_RecordTypeId!='' && KNL_needed == true){
            Highest_KNL_CustID_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KNL_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KNL%' Order by Customer_ID2__c Desc Limit 1];
        }
        if (Highest_KNL_CustID_List.size()>0) {
            
            Highest_KNL_CustID= Highest_KNL_CustID_List[0].Customer_ID2__c;
            
        }
        
        
        System.Debug('Highest_KNL_CustID' +Highest_KNL_CustID );
        
        String Highest_KNZ_CustID=''; // initialize String
        List <Account> Highest_KNZ_CustID_List= new List <Account>();
        if(KNZ_RecordTypeId!='' && KNZ_needed == true){
            Highest_KNZ_CustID_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KNZ_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KNZ%' Order by Customer_ID2__c Desc Limit 1];
        }
        if (Highest_KNZ_CustID_List.size()>0) {
            
            Highest_KNZ_CustID= Highest_KNZ_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KNZ_CustID' +Highest_KNZ_CustID );
        
        
        
        // Query Existing KUS, KIE, KCA, KUK and KIC Records in database with Empty Customer_ID2__c or unformatted Customer_ID2__c.
        if(KUS_RecordTypeId!='' && KUS_needed == true){
            KUS_EmptyCustId_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KUS_RecordTypeId And (Customer_ID2__c ='')Order by CreatedDate ASC ];
        }
        if(KIE_RecordTypeId!='' && KIE_needed == true){	
            KIE_EmptyCustId_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KIE_RecordTypeId And (Customer_ID2__c ='') Order by CreatedDate ASC ];
        }
        if(KCA_RecordTypeId!='' && KCA_needed == true){ 
            KCA_EmptyCustId_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KCA_RecordTypeId And (Customer_ID2__c ='') Order by CreatedDate ASC ];
        }               
        if(KUK_RecordTypeId!='' && KUK_needed == true){
            KUK_EmptyCustId_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KUK_RecordTypeId And (Customer_ID2__c ='') Order by CreatedDate ASC ];
            
        }
        if(KIC_RecordTypeId!='' && KIC_needed == true){
            KIC_EmptyCustId_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KIC_RecordTypeId And (Customer_ID2__c ='') Order by CreatedDate ASC ];
        }
        if(KDK_RecordTypeId!='' && KDK_needed == true){  
            KDK_EmptyCustId_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KDK_RecordTypeId And (Customer_ID2__c ='') Order by CreatedDate ASC ];
        }
        if(KNL_RecordTypeId!='' && KNL_needed == true){
            KNL_EmptyCustId_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KNL_RecordTypeId And (Customer_ID2__c ='') Order by CreatedDate ASC ];
            
        }
        if(KNZ_RecordTypeId!='' && KNZ_needed == true){
            KNZ_EmptyCustId_List = [SELECT Id, Name, ParentId, Customer_ID2__c, RecordTypeId, CreatedDate, Sales_Owner__c, Type, Country_Code__c, Support_Level__c, Update_TWINS__c, TWINS_ID__c, Relationship_Type_Communications__c, Owner.Name, Phone, Twins_Street__c, Twins_Suburb__c, Twins_City__c, Twins_postCode__c, Account_Manager_Communications__c FROM Account where RecordTypeId=:KNZ_RecordTypeId And (Customer_ID2__c ='') Order by CreatedDate ASC ];
        } 
        
        System.Debug('KUS_EmptyCustId_List' +KUS_EmptyCustId_List); 
        System.Debug('KIE_EmptyCustId_List' +KIE_EmptyCustId_List);
        System.Debug('KCA_EmptyCustId_List' +KCA_EmptyCustId_List);
        System.Debug('KUK_EmptyCustId_List' +KUK_EmptyCustId_List);
        System.Debug('KIC_EmptyCustId_List' +KIC_EmptyCustId_List);
        System.Debug('KDK_EmptyCustId_List' +KDK_EmptyCustId_List);
        System.Debug('KNL_EmptyCustId_List' +KNL_EmptyCustId_List);
        System.Debug('KNZ_EmptyCustId_List' +KNZ_EmptyCustId_List);
        
        
        
        // If there is a highest Customer Id in System  and also there are records with Empty Customer_ID2__c
        system.debug('Highest_KNL_CustID'+Highest_KNL_CustID);
        if (Highest_KUS_CustID!='' ) {
            
            HighestNumberKUS =Integer.valueof(Highest_KUS_CustID.substring(4));  
            
            if(KUS_EmptyCustId_List.size()>0){   
                System.Debug('HighestNumberKUS' +HighestNumberKUS);  
                for (Account KUS_account: KUS_EmptyCustId_List){
                    if(!newAccount.contains(KUS_account)){
                        if(!newAccountIds.contains(KUS_account.Id)){
                            HighestNumberKUS=HighestNumberKUS+1;
                            
                            System.Debug('HighestNumberKUS' +HighestNumberKUS);  
                            
                            
                            KUS_account.Customer_ID2__c= 'KUS-'+ (string.valueof(HighestNumberKUS));
                            
                            System.Debug('KUS_account.Customer_ID2__c' +KUS_account.Customer_ID2__c);  
                            Accounts_forUpdateList.add(KUS_account);
                        }
                    }
                    
                }
            }
        }
        
        // If there is a no Customer Id in System  and also there are records with Empty Customer_ID2__c
        if (Highest_KUS_CustID=='' && KUS_EmptyCustId_List.size()>0) {
            HighestNumberKUS=1000000;
            
            for (Account KUS_account: KUS_EmptyCustId_List){
                if(!newAccountIds.contains(KUS_account.Id)){
                    HighestNumberKUS=HighestNumberKUS+1;
                    
                    System.debug('HighestNumberKUS'+HighestNumberKUS );
                    KUS_account.Customer_ID2__c= 'KUS-'+ (string.valueof(HighestNumberKUS));
                    
                    System.Debug('KUS_account.Customer_ID2__c' +KUS_account.Customer_ID2__c);  
                    
                    Accounts_forUpdateList.add(KUS_account);
                }
            }
        }
        
        // If there is a highest Customer Id in System  and also there are records with Empty Customer_ID2__c for KIE Record Type
        system.debug('Highest_KNL_CustID'+Highest_KNL_CustID);
        if (Highest_KIE_CustID!='' ) {
            
            HighestNumberKIE = Integer.valueof(Highest_KIE_CustID.substring(4)); 
            
            if (KIE_EmptyCustId_List.size()>0){      
                System.Debug('HighestNumberKIE' +HighestNumberKIE);  
                for (Account KIE_account: KIE_EmptyCustId_List){
                    if(!newAccountIds.contains(KIE_account.Id)){
                        HighestNumberKIE=HighestNumberKIE+1;
                        
                        System.Debug('HighestNumberKIE' +HighestNumberKIE);  
                        
                        
                        KIE_account.Customer_ID2__c= 'KIE-'+ (string.valueof(HighestNumberKIE));
                        
                        System.Debug('KIE_account.Customer_ID2__c' +KIE_account.Customer_ID2__c);  

                        Accounts_forUpdateList.add(KIE_account);
                    }
                }
            }
        }
        
        // If there is a no Customer Id in System  and also there are records with Empty Customer_ID2__c
        if (Highest_KIE_CustID=='' && KIE_EmptyCustId_List.size()>0) {
            HighestNumberKIE=1000000;
            
            for (Account KIE_account: KIE_EmptyCustId_List){
                if(!newAccountIds.contains(KIE_account.Id)){
                    HighestNumberKIE=HighestNumberKIE+1;
                    
                    System.debug('HighestNumberKIE'+HighestNumberKIE );
                    KIE_account.Customer_ID2__c= 'KIE-'+ (string.valueof(HighestNumberKIE));
                    
                    System.Debug('KIE_account.Customer_ID2__c' +KIE_account.Customer_ID2__c);  
                    
                    Accounts_forUpdateList.add(KIE_account);
                }
            }
        }   

        // If there is a highest Customer Id in System  and also there are records with Empty Customer_ID2__c for KCA Record Type
        system.debug('Highest_KNL_CustID'+Highest_KNL_CustID);
        if (Highest_KCA_CustID!='' ) {
            
            HighestNumberKCA = Integer.valueof(Highest_KCA_CustID.substring(4)); 
            
            if (KCA_EmptyCustId_List.size()>0){      
                System.Debug('HighestNumberKCA' +HighestNumberKCA);  
                for (Account KCA_account: KCA_EmptyCustId_List){
                    if(!newAccountIds.contains(KCA_account.Id)){
                        HighestNumberKCA=HighestNumberKCA+1;
                        
                        System.Debug('HighestNumberKCA' +HighestNumberKCA);  
                        
                        
                        KCA_account.Customer_ID2__c= 'KCA-'+ (string.valueof(HighestNumberKCA));
                        
                        System.Debug('KCA_account.Customer_ID2__c' +KCA_account.Customer_ID2__c);  

                        Accounts_forUpdateList.add(KCA_account);
                    }
                }
            }
        }
        
        // If there is a no Customer Id in System  and also there are records with Empty Customer_ID2__c            
        if (Highest_KCA_CustID=='' && KCA_EmptyCustId_List.size()>0) {
            HighestNumberKCA=1000000;
            
            for (Account KCA_account: KCA_EmptyCustId_List){
                if(!newAccountIds.contains(KCA_account.Id)){
                    HighestNumberKCA=HighestNumberKCA+1;
                    
                    System.debug('HighestNumberKCA'+HighestNumberKCA );
                    KCA_account.Customer_ID2__c= 'KCA-'+ (string.valueof(HighestNumberKCA));
                    
                    System.Debug('KCA_account.Customer_ID2__c' +KCA_account.Customer_ID2__c);  
                    
                    Accounts_forUpdateList.add(KCA_account);
                }
            }
        }   
        system.debug('Highest_KNL_CustID'+Highest_KNL_CustID);
        // If there is a highest Customer Id in System  and also there are records with Empty Customer_ID2__c for KUK Record Type
        if (Highest_KUK_CustID!='' ) {
            
            HighestNumberKUK = Integer.valueof(Highest_KUK_CustID.substring(4)); 
            
            if (KUK_EmptyCustId_List.size()>0){      
                System.Debug('HighestNumberKUK' +HighestNumberKUK);  
                for (Account KUK_account: KUK_EmptyCustId_List){
                    if(!newAccountIds.contains(KUK_account.Id)){
                        HighestNumberKUK=HighestNumberKUK+1;
                        
                        System.Debug('HighestNumberKUK' +HighestNumberKUK);  
                        
                        
                        KUK_account.Customer_ID2__c= 'KUK-'+ (string.valueof(HighestNumberKUK));
                        
                        System.Debug('KUK_account.Customer_ID2__c' +KUK_account.Customer_ID2__c); 

                        Accounts_forUpdateList.add(KUK_account);
                    }
                }
            }
        }
        
        // If there is a no Customer Id in System  and also there are records with Empty Customer_ID2__c
        if (Highest_KUK_CustID=='' && KUK_EmptyCustId_List.size()>0) {
            HighestNumberKUK=1000000;
            
            for (Account KUK_account: KUK_EmptyCustId_List){
                if(!newAccountIds.contains(KUK_account.Id)){
                    HighestNumberKUK=HighestNumberKUK+1;
                    
                    System.debug('HighestNumberKUK'+HighestNumberKUK );
                    KUK_account.Customer_ID2__c= 'KUK-'+ (string.valueof(HighestNumberKUK));
                    
                    System.Debug('KUK_account.Customer_ID2__c' +KUK_account.Customer_ID2__c);  
                    
                    Accounts_forUpdateList.add(KUK_account);
                }
                
            }
        }   

        system.debug('Highest_KNL_CustID'+Highest_KNL_CustID);
        // If there is a highest Customer Id in System  and also there are records with Empty Customer_ID2__c for KIC Record Type
        if (Highest_KIC_CustID!='' ) {
            
            HighestNumberKIC = Integer.valueof(Highest_KIC_CustID.substring(4)); 
            
            if (KIC_EmptyCustId_List.size()>0){      
                System.Debug('HighestNumberKIC' +HighestNumberKIC);  
                for (Account KIC_account: KIC_EmptyCustId_List){
                    if(!newAccountIds.contains(KIC_account.Id)){
                        HighestNumberKIC=HighestNumberKIC+1;
                        
                        System.Debug('HighestNumberKIC' +HighestNumberKIC);  
                        
                        
                        KIC_account.Customer_ID2__c= 'KIC-'+ (string.valueof(HighestNumberKIC));
                        
                        System.Debug('KIC_account.Customer_ID2__c' +KIC_account.Customer_ID2__c);  

                        Accounts_forUpdateList.add(KIC_account);
                    }
                }
            }
        }
        
        // If there is a no Customer Id in System  and also there are records with Empty Customer_ID2__c
        if (Highest_KIC_CustID=='' && KIC_EmptyCustId_List.size()>0) {
            HighestNumberKIC=1000000;
            
            for (Account KIC_account: KIC_EmptyCustId_List){
                if(!newAccountIds.contains(KIC_account.Id)){
                    HighestNumberKIC=HighestNumberKIC+1;
                    
                    System.debug('HighestNumberKIC'+HighestNumberKIC );
                    KIC_account.Customer_ID2__c= 'KIC-'+ (string.valueof(HighestNumberKIC));
                    
                    System.Debug('KIC_account.Customer_ID2__c' +KIC_account.Customer_ID2__c);  
                    
                    Accounts_forUpdateList.add(KIC_account);
                }
            }
        }   
        system.debug('Highest_KNL_CustID'+Highest_KNL_CustID);
        // If there is a highest Customer Id in System  and also there are records with Empty Customer_ID2__c for KDK Record Type
        if (Highest_KDK_CustID!='' ) {
            
            HighestNumberKDK = Integer.valueof(Highest_KDK_CustID.substring(4)); 
            
            if (KDK_EmptyCustId_List.size()>0){      
                System.Debug('HighestNumberKDK' +HighestNumberKDK);  
                for (Account KDK_account: KDK_EmptyCustId_List){
                    if(!newAccountIds.contains(KDK_account.Id)){
                        HighestNumberKDK=HighestNumberKDK+1;
                        
                        System.Debug('HighestNumberKDK' +HighestNumberKDK); 
                        
                        KDK_account.Customer_ID2__c= 'KDK-'+ (string.valueof(HighestNumberKDK));
                        
                        System.Debug('KDK_account.Customer_ID2__c' +KDK_account.Customer_ID2__c);  

                        Accounts_forUpdateList.add(KDK_account);
                    }
                }
            }
        }
        
        // If there is a no Customer Id in System  and also there are records with Empty Customer_ID2__c
        if (Highest_KDK_CustID=='' && KDK_EmptyCustId_List.size()>0) {
            HighestNumberKDK=1000000;
            
            for (Account KDK_account: KDK_EmptyCustId_List){
                if(!newAccountIds.contains(KDK_account.Id)){
                    HighestNumberKDK=HighestNumberKDK+1;
                    
                    System.debug('HighestNumberKDK'+HighestNumberKDK );
                    KDK_account.Customer_ID2__c= 'KDK-'+ (string.valueof(HighestNumberKDK));
                    
                    System.Debug('KDK_account.Customer_ID2__c' +KDK_account.Customer_ID2__c);  
                    
                    Accounts_forUpdateList.add(KDK_account);
                }
            }
        }   
        
        // If there is a highest Customer Id in System  and also there are records with Empty Customer_ID2__c for KNL Record Type
        system.debug('Highest_KNL_CustID--------->'+Highest_KNL_CustID);
        if (Highest_KNL_CustID!='') {
            
            HighestNumberKNL = Integer.valueof(Highest_KNL_CustID.substring(4)); 
            system.debug('KNL_EmptyCustId_List.size()--------->'+KNL_EmptyCustId_List.size());
            system.debug('KNL_EmptyCustId_List--------->'+KNL_EmptyCustId_List);
            if (KNL_EmptyCustId_List.size()>0){      
                System.Debug('HighestNumberKNL' +HighestNumberKNL);  
                for (Account KNL_account: KNL_EmptyCustId_List){
                    if(!newAccountIds.contains(KNL_account.Id)){
                        HighestNumberKNL=HighestNumberKNL+1;
                        
                        System.Debug('HighestNumberKNL' +HighestNumberKNL);  
                        
                        
                        KNL_account.Customer_ID2__c= 'KNL-'+ (string.valueof(HighestNumberKNL));
                        
                        System.Debug('KNL_account.Customer_ID2__c' +KNL_account.Customer_ID2__c);  

                        Accounts_forUpdateList.add(KNL_account);
                    }
                }
            }
        }
        
        // If there is a no Customer Id in System  and also there are records with Empty Customer_ID2__c
        if (Highest_KNL_CustID=='' && KNL_EmptyCustId_List.size()>0) {
            HighestNumberKNL=6000000;
            
            for (Account KNL_account: KNL_EmptyCustId_List){
                if(!newAccountIds.contains(KNL_account.Id)){
                    HighestNumberKNL=HighestNumberKNL+1;
                    
                    System.debug('HighestNumberKNL'+HighestNumberKNL );
                    KNL_account.Customer_ID2__c= 'KNL-'+ (string.valueof(HighestNumberKNL));
                    
                    System.Debug('KNL_account.Customer_ID2__c' +KNL_account.Customer_ID2__c);  
                    
                    Accounts_forUpdateList.add(KNL_account);
                }
            }
        }  
        system.debug('KNL_ForUpdate_List-------->'+Accounts_forUpdateList);
        system.debug('KNL_ForUpdate_List-------->'+Accounts_forUpdateList.size());
        

        // If there is a highest Customer Id in System  and also there are records with Empty Customer_ID2__c for KNZ Record Type
        if (Highest_KNZ_CustID!='' ) {
            
            HighestNumberKNZ = Integer.valueof(Highest_KNZ_CustID.substring(4)); 
            
            if (KNZ_EmptyCustId_List.size()>0){      
                System.Debug('HighestNumberKNZ' +HighestNumberKNZ);  
                for (Account KNZ_account: KNZ_EmptyCustId_List){
                    if(!newAccountIds.contains(KNZ_account.Id)){
                        HighestNumberKNZ=HighestNumberKNZ+1;
                        
                        System.Debug('HighestNumberKNZ' +HighestNumberKNZ);  
                        
                        
                        KNZ_account.Customer_ID2__c= 'KNZ-'+ (string.valueof(HighestNumberKNZ));
                        
                        System.Debug('KNZ_account.Customer_ID2__c' +KNZ_account.Customer_ID2__c);  

                        Accounts_forUpdateList.add(KNZ_account);
                    }
                }
            }
        }
        
        // If there is a no Customer Id in System  and also there are records with Empty Customer_ID2__c
        if (Highest_KNZ_CustID=='' && KNZ_EmptyCustId_List.size()>0) 
        {
            HighestNumberKNZ=1000000;
            
            for (Account KNZ_account: KNZ_EmptyCustId_List){
                if(!newAccountIds.contains(KNZ_account.Id)){
                    HighestNumberKNZ=HighestNumberKNZ+1;
                    
                    System.debug('HighestNumberKNZ'+HighestNumberKNZ );
                    KNZ_account.Customer_ID2__c= 'KNZ-'+ (string.valueof(HighestNumberKNZ));
                    
                    System.Debug('KNZ_account.Customer_ID2__c' +KNZ_account.Customer_ID2__c);  
                    
                    Accounts_forUpdateList.add(KNZ_account);
                }
            }
        } 

        System.Debug('Highest number system debugs..');
        System.Debug('HighestNumberKUS'+HighestNumberKUS);
        System.Debug('HighestNumberKIE'+HighestNumberKIE);
        System.Debug('HighestNumberKCA'+HighestNumberKCA);
        System.Debug('HighestNumberKUK'+HighestNumberKUK);
        System.Debug('HighestNumberKIC'+HighestNumberKIC);
        System.Debug('HighestNumberKDK'+HighestNumberKDK);
        System.Debug('HighestNumberKNL'+HighestNumberKNL);
        System.Debug('HighestNumberKNZ'+HighestNumberKNZ);
                        
        if(Accounts_forUpdateList.size() > 0)
        {
            return Accounts_forUpdateList;
        }
        else 
        {
            return null;    
        }
    }

    public void SetCustomerIDs_BeforeInsert(List<Account> newAccounts, boolean IsBeforeInsert)
    {

        KUS_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeUS').RecordTypeId;
        KIE_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafe').RecordTypeId;
        KCA_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeCA').RecordTypeId;
        KUK_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeUK').RecordTypeId;
        KIC_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeIC').RecordTypeId;
        KDK_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeDK').RecordTypeId;
        KNL_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeNL').RecordTypeId;
        KNZ_RecordTypeId = Schema.SObjectType.Account.RecordTypeInfosByName.get('KeepItSafeNZ').RecordTypeId;

        Integer HighestNumberKUS=0;
        Integer HighestNumberKIE=0;
        Integer HighestNumberKCA=0;
        Integer HighestNumberKUK=0;
        Integer HighestNumberKIC=0;
        Integer HighestNumberKDK=0;
        Integer HighestNumberKNL=0;
        Integer HighestNumberKNZ=0;
        
        // Current Highest KUS/KIE/KCA/KUK/KIC/KDK/KNL/KNZ  Customer_ID2__c Numbers in DB
        String Highest_KUS_CustID=''; // initialize String
        List <Account> Highest_KUS_CustID_List= new List <Account>();
        if(KUS_RecordTypeId!=''){
            Highest_KUS_CustID_List = [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:KUS_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KUS%' Order by Customer_ID2__c Desc Limit 1];
        }
        if (Highest_KUS_CustID_List.size()>0) {
            
            Highest_KUS_CustID= Highest_KUS_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KUS_CustID' +Highest_KUS_CustID );
        
        String Highest_KIE_CustID=''; // initialize String
        List <Account> Highest_KIE_CustID_List= new List <Account>();
        if(KIE_RecordTypeId!=''){
            Highest_KIE_CustID_List= [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:KIE_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KIE%' Order by Customer_ID2__c Desc Limit 1];
        }
        
        if (Highest_KIE_CustID_List.size()>0) {
            
            Highest_KIE_CustID= Highest_KIE_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KIE_CustID' +Highest_KIE_CustID );
        
        String Highest_KCA_CustID=''; // initialize String
        List <Account> Highest_KCA_CustID_List= new List <Account>();
        if(KCA_RecordTypeId!=''){
            Highest_KCA_CustID_List= [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:KCA_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KCA%' Order by Customer_ID2__c Desc Limit 1];
        }
        
        if (Highest_KCA_CustID_List.size()>0) {
            
            Highest_KCA_CustID= Highest_KCA_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KCA_CustID' +Highest_KCA_CustID );
        
        String Highest_KUK_CustID=''; // initialize String
        List <Account> Highest_KUK_CustID_List= new List <Account>();
        if(KUK_RecordTypeId!=''){
            Highest_KUK_CustID_List= [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:KUK_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KUK%' Order by Customer_ID2__c Desc Limit 1];
        }
        
        if (Highest_KUK_CustID_List.size()>0) {
            
            Highest_KUK_CustID= Highest_KUK_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KUK_CustID' +Highest_KUK_CustID );
        
        String Highest_KIC_CustID=''; // initialize String
        List <Account> Highest_KIC_CustID_List= new List <Account>();
        if(KIC_RecordTypeId!=''){
            Highest_KIC_CustID_List = [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:KIC_RecordTypeId And Customer_ID2__c !=''  and Customer_ID2__c like 'KIC%' Order by Customer_ID2__c Desc Limit 1];
        }
        if (Highest_KIC_CustID_List.size()>0) {
            
            Highest_KIC_CustID= Highest_KIC_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KIC_CustID' +Highest_KIC_CustID );
        
        String Highest_KDK_CustID=''; // initialize String
        List <Account> Highest_KDK_CustID_List= new List <Account>();
        if(KDK_RecordTypeId!=''){
            Highest_KDK_CustID_List = [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:KDK_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KDK%' Order by Customer_ID2__c Desc Limit 1];
        }
        if (Highest_KDK_CustID_List.size()>0) {
            
            Highest_KDK_CustID= Highest_KDK_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KDK_CustID' +Highest_KDK_CustID );
        
        String Highest_KNL_CustID=''; // initialize String
        List <Account> Highest_KNL_CustID_List= new List <Account>();
        if(KNL_RecordTypeId!=''){
            Highest_KNL_CustID_List = [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:KNL_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KNL%' Order by Customer_ID2__c Desc Limit 1];
        }
        if (Highest_KNL_CustID_List.size()>0) {
            
            Highest_KNL_CustID= Highest_KNL_CustID_List[0].Customer_ID2__c;
            
        }
        
        
        System.Debug('Highest_KNL_CustID' +Highest_KNL_CustID );
        
        String Highest_KNZ_CustID=''; // initialize String
        List <Account> Highest_KNZ_CustID_List= new List <Account>();
        if(KNZ_RecordTypeId!=''){
            Highest_KNZ_CustID_List = [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:KNZ_RecordTypeId And Customer_ID2__c !='' and Customer_ID2__c like 'KNZ%' Order by Customer_ID2__c Desc Limit 1];
        }
        if (Highest_KNZ_CustID_List.size()>0) {
            
            Highest_KNZ_CustID= Highest_KNZ_CustID_List[0].Customer_ID2__c;
            
        }
        
        System.Debug('Highest_KNZ_CustID' +Highest_KNZ_CustID );


        system.debug('NewAccount for loop will start.');
        for (Account New_Account: newAccounts){
            system.debug('NewAccount for loop started.');
            if(IsBeforeInsert){
    
                //set record type on basis of customer ID's first three letter
                if(string.isNotEmpty(New_Account.Customer_ID2__c) && string.isNotEmpty(New_Account.Account_Record_Type_Hidden__c) && New_Account.Account_Record_Type_Hidden__c == 'KeepItSafe: Lead' ){
                    string billingcode = New_Account.Customer_ID2__c;
                    if(billingcode == 'KUS'){
                        New_Account.RecordtypeId = KUS_RecordTypeId;
                    } else if(billingcode == 'KCA'){
                        New_Account.RecordtypeId = KCA_RecordTypeId;
                    }else if(billingcode == 'KUK'){
                        New_Account.RecordtypeId = KUK_RecordTypeId;
                    }else if(billingcode == 'KIC'){
                        New_Account.RecordtypeId = KIC_RecordTypeId;
                    }else if(billingcode == 'KDK'){
                        New_Account.RecordtypeId = KDK_RecordTypeId;
                    }else if(billingcode == 'KNL'){
                        New_Account.RecordtypeId = KNL_RecordTypeId;
                    }else if(billingcode == 'KIE'){
                        New_Account.RecordtypeId = KIE_RecordTypeId;
                    }
                    else if(billingcode == 'KNZ'){
                        New_Account.RecordtypeId = KNZ_RecordTypeId;
                    }else {
                        New_Account.RecordtypeId = KUS_RecordTypeId;
                    }
                }
                
                system.debug('Isupdate called to update customerid....Now...');
                system.debug('check condition1: ' + String.isEmpty(New_Account.Customer_ID2__c));
                boolean CustIdStartsWithK = false;
                if(String.isNotBlank(New_Account.Customer_ID2__c)){
                    CustIdStartsWithK = New_Account.Customer_ID2__c.startsWithIgnoreCase('K');
                }
                if(String.isEmpty(New_Account.Customer_ID2__c) || CustIdStartsWithK){
                    if(New_Account.RecordtypeId==KUS_RecordTypeId){

                        if (Highest_KUS_CustID!='') 
                        {
                            HighestNumberKUS =Integer.valueof(Highest_KUS_CustID.substring(4));  
                        }
                        else if(HighestNumberKUS < 1000000)
                        {                          
                            HighestNumberKUS=1000000;
                        }

                        if (HighestNumberKUS!=0){
                            
                            HighestNumberKUS=HighestNumberKUS+1;
                            New_Account.Customer_ID2__c= 'KUS-'+ (string.valueof(HighestNumberKUS));
                            
                        }
                    }
                    if(New_Account.RecordtypeId==KIE_RecordTypeId){
                        
                        if (Highest_KIE_CustID!='') 
                        {
                            HighestNumberKIE =Integer.valueof(Highest_KIE_CustID.substring(4));  
                        }
                        else if(HighestNumberKIE < 1000000)
                        {                          
                            HighestNumberKIE=1000000;
                        }

                        if (HighestNumberKIE!=0){
                            HighestNumberKIE=HighestNumberKIE+1;
                            
                            New_Account.Customer_ID2__c= 'KIE-'+ (string.valueof(HighestNumberKIE));
                            
                        }
                    }
                    if(New_Account.RecordtypeId==KCA_RecordTypeId){
                        
                        if (Highest_KCA_CustID!='') 
                        {
                            HighestNumberKCA =Integer.valueof(Highest_KCA_CustID.substring(4));  
                        }
                        else if(HighestNumberKCA < 1000000)
                        {                          
                            HighestNumberKCA=1000000;
                        }

                        if (HighestNumberKCA!=0){
                            HighestNumberKCA=HighestNumberKCA+1;
                            
                            New_Account.Customer_ID2__c= 'KCA-'+ (string.valueof(HighestNumberKCA));
                            
                        }
                    }
                    if(New_Account.RecordtypeId==KUK_RecordTypeId){
                        
                        if (Highest_KUK_CustID!='') 
                        {
                            HighestNumberKUK =Integer.valueof(Highest_KUK_CustID.substring(4));  
                        }
                        else if(HighestNumberKUK < 1000000)
                        {                          
                            HighestNumberKUK=1000000;
                        }

                        if (HighestNumberKUK!=0){
                            HighestNumberKUK=HighestNumberKUK+1;
                            
                            New_Account.Customer_ID2__c= 'KUK-'+ (string.valueof(HighestNumberKUK));
                            
                        }
                    }
                    
                    if(New_Account.RecordtypeId==KIC_RecordTypeId){
                        
                        if (Highest_KIC_CustID!='') 
                        {
                            HighestNumberKIC =Integer.valueof(Highest_KIC_CustID.substring(4));  
                        }
                        else if(HighestNumberKIC < 1000000)
                        {                          
                            HighestNumberKIC=1000000;
                        }

                        if (HighestNumberKIC!=0){
                            
                            HighestNumberKIC=HighestNumberKIC+1;
                            New_Account.Customer_ID2__c= 'KIC-'+ (string.valueof(HighestNumberKIC));
                            
                        }
                    }
                    if(New_Account.RecordtypeId==KDK_RecordTypeId){
                        
                        if (Highest_KDK_CustID!='') 
                        {
                            HighestNumberKDK =Integer.valueof(Highest_KDK_CustID.substring(4));  
                        }
                        else if(HighestNumberKDK < 1000000)
                        {                          
                            HighestNumberKDK=1000000;
                        }
                        if (HighestNumberKDK!=0){
                            HighestNumberKDK=HighestNumberKDK+1;
                            
                            New_Account.Customer_ID2__c= 'KDK-'+ (string.valueof(HighestNumberKDK));
                            
                        }
                    }
                    if(New_Account.RecordtypeId==KNL_RecordTypeId){
                        
                        if (Highest_KNL_CustID!='') 
                        {
                            HighestNumberKNL =Integer.valueof(Highest_KNL_CustID.substring(4));  
                        }
                        else if(HighestNumberKNL < 1000000)
                        {                          
                            HighestNumberKNL=1000000;
                        }
                        if (HighestNumberKNL!=0){
                            HighestNumberKNL=HighestNumberKNL+1;
                            
                            New_Account.Customer_ID2__c= 'KNL-'+ (string.valueof(HighestNumberKNL));
                            
                        }
                    }
                    if(New_Account.RecordtypeId==KNZ_RecordTypeId){
                        
                        if (Highest_KNZ_CustID!='') 
                        {
                            HighestNumberKNZ =Integer.valueof(Highest_KNZ_CustID.substring(4));  
                        }
                        else if(HighestNumberKNZ < 1000000)
                        {                          
                            HighestNumberKNZ=1000000;
                        }
                        if (HighestNumberKNZ!=0){
                            HighestNumberKNZ=HighestNumberKNZ+1;
                            
                            New_Account.Customer_ID2__c= 'KNZ-'+ (string.valueof(HighestNumberKNZ));
                            
                        }
                    }
                }
            }
        }
    }
}