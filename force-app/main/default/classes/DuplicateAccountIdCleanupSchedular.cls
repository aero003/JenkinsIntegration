global class DuplicateAccountIdCleanupSchedular implements Schedulable{

    global void execute(SchedulableContext sc){

        String KUS_RecordTypeId =[SELECT Id FROM RecordType where Name='KeepItSafeUS' And SObjectType='Account' Limit 1].Id;
        System.debug('KUS_RecordTypeId'+ KUS_RecordTypeId );
        String KIE_RecordTypeId =[SELECT Id FROM RecordType where Name='KeepItSafe' And SObjectType='Account' Limit 1].Id;
        System.debug('KIE_RecordTypeId'+KIE_RecordTypeId );
        String KCA_RecordTypeId =[SELECT Id FROM RecordType where Name='KeepItSafeCA' And SObjectType='Account' Limit 1].Id;
        System.debug('KCA_RecordTypeId'+KCA_RecordTypeId );
        String KUK_RecordTypeId =[SELECT Id FROM RecordType where Name='KeepItSafeUK' And SObjectType='Account' Limit 1].Id;
        System.debug('KUK_RecordTypeId'+KUK_RecordTypeId );
        String KIC_RecordTypeId =[SELECT Id FROM RecordType where Name='KeepItSafeIC' And SObjectType='Account' Limit 1].Id;
        System.debug('KIC_RecordTypeId'+KIC_RecordTypeId );

        KUSCorrectorMethod(KUS_RecordTypeId);
        KIECorrectorMethod(KIE_RecordTypeId);
        KCACorrectorMethod(KCA_RecordTypeId);
        KUKCorrectorMethod(KUK_RecordTypeId);
        KICCorrectorMethod(KIC_RecordTypeId);

    }

    public Datetime getDate(){
        List<DuplicateAccountsBatchDate__c> dateValue = DuplicateAccountsBatchDate__c.getAll().Values();
        if(dateValue.size() > 0){
            return Datetime.parse(dateValue[0].Date__c) ;
        }else{
            String s = '11/6/2014 12:00 AM';
            DateTime dt = DateTime.parse(s);
            return dt;
        }    
    }

    public void KUSCorrectorMethod(String Id){
        Set <String> nonduplicateAccount = new Set <String> ();
        Map <Id,Account> duplicateAccountMap = new Map <Id,Account> ();
        Datetime startDate = getDate();

        List <Account> acclist = [SELECT Name, Id, Customer_ID2__c from Account where RecordTypeId =:Id And CreatedDate >=: startDate ORDER BY Customer_ID2__c];
        system.debug('Record List --->' + acclist);
        if(acclist.size() > 0){
            for(Account a : acclist){
                if(!(nonduplicateAccount.contains(a.Customer_ID2__c))){
                        nonduplicateAccount.add(a.Customer_ID2__c);
                    }else{
                        duplicateAccountMap.put(a.Id,a);    
                    }
            }


            String Highest_KUS_CustID = [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:Id And Customer_ID2__c !='' Order by Customer_ID2__c Desc Limit 1].Customer_ID2__c;
            Integer Value = Integer.valueof(Highest_KUS_CustID.substring(4));

            List <Account> updatelist = new List <Account> ();
            for(Account a : duplicateAccountMap.Values()){

                a.Customer_ID2__c = 'KUS-'+ (string.valueof (Value + 1));
                Value = Value + 1;
                updatelist.add(a);
            }

            update updatelist;
        }
    }

    public void KIECorrectorMethod(String Id){
        Set <String> nonduplicateAccount = new Set <String> ();
        Map <Id,Account> duplicateAccountMap = new Map <Id,Account> ();
        Datetime startDate = getDate();

        List <Account> acclist = [SELECT Name, Id, Customer_ID2__c from Account where RecordTypeId =:Id And CreatedDate >=: startDate ORDER BY Customer_ID2__c];
        if(acclist.size() > 0){
            for(Account a : acclist){
                if(!(nonduplicateAccount.contains(a.Customer_ID2__c))){
                        nonduplicateAccount.add(a.Customer_ID2__c);
                    }else{
                        duplicateAccountMap.put(a.Id,a);    
                    }
            }

            String Highest_KUS_CustID = [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:Id And Customer_ID2__c !='' Order by Customer_ID2__c Desc Limit 1].Customer_ID2__c;
            Integer Value = Integer.valueof(Highest_KUS_CustID.substring(4));

            List <Account> updatelist = new List <Account> ();
            for(Account a : duplicateAccountMap.Values()){

                a.Customer_ID2__c = 'KIE-'+ (string.valueof (Value + 1));
                Value = Value + 1;
                updatelist.add(a);
            }
            update updatelist;
        }
    }

    public void KCACorrectorMethod(String Id){
        Set <String> nonduplicateAccount = new Set <String> ();
        Map <Id,Account> duplicateAccountMap = new Map <Id,Account> ();
        Datetime startDate = getDate();

        List <Account> acclist = [SELECT Name, Id, Customer_ID2__c from Account where RecordTypeId =:Id And CreatedDate >=: startDate ORDER BY Customer_ID2__c];
        if(acclist.size() > 0){
            for(Account a : acclist){
                if(!(nonduplicateAccount.contains(a.Customer_ID2__c))){
                        nonduplicateAccount.add(a.Customer_ID2__c);
                    }else{
                        duplicateAccountMap.put(a.Id,a);    
                    }
            }

            String Highest_KUS_CustID = [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:Id And Customer_ID2__c !='' Order by Customer_ID2__c Desc Limit 1].Customer_ID2__c;
            Integer Value = Integer.valueof(Highest_KUS_CustID.substring(4));

            List <Account> updatelist = new List <Account> ();
            for(Account a : duplicateAccountMap.Values()){

                a.Customer_ID2__c = 'KCA-'+ (string.valueof (Value + 1));
                Value = Value + 1;
                updatelist.add(a);
            }
            update updatelist;
        }   
    }

    public void KUKCorrectorMethod(String Id){
        Set <String> nonduplicateAccount = new Set <String> ();
        Map <Id,Account> duplicateAccountMap = new Map <Id,Account> ();
        Datetime startDate = getDate();

        List <Account> acclist = [SELECT Name, Id, Customer_ID2__c from Account where RecordTypeId =:Id And CreatedDate >=: startDate ORDER BY Customer_ID2__c];
        if(acclist.size() > 0){
            for(Account a : acclist){
                if(!(nonduplicateAccount.contains(a.Customer_ID2__c))){
                        nonduplicateAccount.add(a.Customer_ID2__c);
                    }else{
                        duplicateAccountMap.put(a.Id,a);    
                    }
            }

            String Highest_KUS_CustID = [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:Id And Customer_ID2__c !='' Order by Customer_ID2__c Desc Limit 1].Customer_ID2__c;
            Integer Value = Integer.valueof(Highest_KUS_CustID.substring(4));

            List <Account> updatelist = new List <Account> ();
            for(Account a : duplicateAccountMap.Values()){

                a.Customer_ID2__c = 'KUK-'+ (string.valueof (Value + 1));
                Value = Value + 1;
                updatelist.add(a);
            }
            update updatelist;
        }   
    }

    public void KICCorrectorMethod(String Id){
        Set <String> nonduplicateAccount = new Set <String> ();
        Map <Id,Account> duplicateAccountMap = new Map <Id,Account> ();
        Datetime startDate = getDate();

        List <Account> acclist = [SELECT Name, Id, Customer_ID2__c from Account where RecordTypeId =:Id And CreatedDate >=: startDate ORDER BY Customer_ID2__c];

        if(acclist.size() > 0){
            for(Account a : acclist){
                if(!(nonduplicateAccount.contains(a.Customer_ID2__c))){
                        nonduplicateAccount.add(a.Customer_ID2__c);
                    }else{
                        duplicateAccountMap.put(a.Id,a);    
                    }
            }

            String Highest_KUS_CustID = [SELECT Name, Id, Customer_ID2__c FROM Account where RecordTypeId=:Id And Customer_ID2__c !='' Order by Customer_ID2__c Desc Limit 1].Customer_ID2__c;
            Integer Value = Integer.valueof(Highest_KUS_CustID.substring(4));

            List <Account> updatelist = new List <Account> ();
            for(Account a : duplicateAccountMap.Values()){

                a.Customer_ID2__c = 'KIC-'+ (string.valueof (Value + 1));
                Value = Value + 1;
                updatelist.add(a);
            }
            update updatelist;
        }
    }
}