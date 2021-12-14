@isTest
public class OpportunityPipelineReportControllerTest {
	 @testsetup static void OpportunityPipelineReportControllerTest_setup(){
        //Add new users
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        List<User> uList=new List<User>{
         new User(Alias = 'jsynk', Email='jsynk@gmail.com', FirstName='Joe',
                          EmailEncodingKey='UTF-8', LastName='synk', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='jsynk@orkut.com'),
             
         new User(Alias = 'Jepstein', Email='Jepstein@gmail.com', FirstName='Jim',
                          EmailEncodingKey='UTF-8', LastName='synk', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, Country='Canada',
                          TimeZoneSidKey='America/Los_Angeles', UserName='Jepstein@orkut.com'),
            
         new User(Alias = 'JCervera', Email='JCervera@gmail.com', FirstName='Jake',
                          EmailEncodingKey='UTF-8', LastName='Cervera', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='JCervera@orkut.com')
        };
        insert uList;
        
        //create custom setting
        Opportunity_Pipeline_Report_Settings__c oprsSetting = new Opportunity_Pipeline_Report_Settings__c();
        oprsSetting.Name='Test Setting';
        oprsSetting.OpportunityPipelineReportUserAlias__c='jsynk,Jepstein,JCervera';
        oprsSetting.OpportunityPipelineReportRecordType__c='eFax®: Opportunity,eFax Corporate Opp';
        insert oprsSetting;
        
        //get record type Id for account
        Id AccountRecordTypeId=[select Id from RecordType where (name = 'MyFax®: Account')].id;
        //create new account
        Account acc=new Account();
        acc.RecordTypeId=AccountRecordTypeId;
        acc.Name='Sample Health Account';
        acc.Industry='Health';
        acc.Corp_Id__c = '75681';
        insert acc;
        
       /* //get record type id for PartnerPortalSettings
        Id KISOppRecordTypeID = [select Name, ID from RecordType where Name='KeepItSafe: Opportunity'].Id;
        //Create new Partner Portal Settings
        PartnerPortalSettings__c thisconfig = new PartnerPortalSettings__c();
        thisconfig.Name = 'PortalSettings';
        thisconfig.OpportunityRecordTypeId__c = KISOppRecordTypeID;
        insert thisconfig;
        PortalServiceHelper.config = thisconfig; */
        
        //get list of record type Ids for opportunity
        List<ID> RecordtypeIds = new List<ID>();
        for(Recordtype r: [select id from RecordType where  (name = 'eFax®: Opportunity' or name = 'eFax Corporate Opp')]){
            RecordtypeIds.add(r.Id);
        }
        //create one Opportunity with probability = 0
        //and another with probability = 100  
        List<Opportunity> oppList=new List<Opportunity>{
            new Opportunity(Industry__c='Legal',AccountId=acc.Id,Name='Sample Opp 9547',StageName='10% - Prospect or Deferred Oppty',
                            Probability=100,CloseDate=date.newInstance(system.today().year()-2, 12, 31),OwnerId=uList[0].Id,Net_new_monthly_revenue__c=100000.00,
                            RecordTypeId=RecordtypeIds[0],Current_Solution_Provider__c='Fax Machines', Corp_Id__c = '75681', Amount = 1),
                new Opportunity(Industry__c='Legal',AccountId=acc.Id,Name='Sample Opp1 9547',StageName='10% - Prospect or Deferred Oppty',
                                Probability=0,CloseDate=date.newInstance(system.today().year()-3, 06, 06),OwnerId=uList[1].Id,Net_new_monthly_revenue__c=100000.00,
                                RecordTypeId=RecordtypeIds[1],Current_Solution_Provider__c='Fax Machines', Corp_Id__c = '75681', Amount = 1),
                new Opportunity(Industry__c='Legal',AccountId=acc.Id,Name='Sample Opp1 9547',StageName='10% - Prospect or Deferred Oppty',
                                Probability=100,CloseDate=date.newInstance(system.today().year(),12 , 31),OwnerId=uList[2].Id,Net_new_monthly_revenue__c=100000.00,
                                RecordTypeId=RecordtypeIds[1],Current_Solution_Provider__c='Fax Machines', Corp_Id__c = '75681', Amount = 1),
                new Opportunity(Industry__c='Legal',AccountId=acc.Id,Name='Sample Opp1 9547',StageName='10% - Prospect or Deferred Oppty',
                                Probability=0,CloseDate=date.newInstance(system.today().year(), 12, 31),OwnerId=uList[1].Id,Net_new_monthly_revenue__c=100000.00,
                                RecordTypeId=RecordtypeIds[1],Current_Solution_Provider__c='Fax Machines', Corp_Id__c = '75681', Amount = 1)
                };
                    
                    
                    insert oppList;
        
        // create Efax_corporate_reporting__c
        List<Efax_corporate_reporting__c> efaxopList=new List<Efax_corporate_reporting__c>{
            new Efax_corporate_reporting__c(Opportunity__c=oppList[2].Id,Name='sample efax1 9881'),
                new Efax_corporate_reporting__c(Opportunity__c=oppList[3].Id,Name='sample efax2 9881')
                };
                    
                    insert efaxopList;
    }
    public static testMethod void OpportunityPipelineReportControllerTest_1(){
        OpportunityPipelineReportController obj=new OpportunityPipelineReportController();
    }
    public static testMethod void OpportunityPipelineReportControllerTest_2(){
        OpportunityPipelineReportController obj=new OpportunityPipelineReportController();
        obj.getYears();
        obj.GenerateReport();        
        obj.OpportunityPipelineQuarterReport('q1');
        obj.SaveAsExcel();
        obj.SaveAspdf();
        List<OpportunityPipelineReportObject> reportobject1= obj.OpportunitiesTotalPipelineQ1;
        
    }
    public static testMethod void OpportunityPipelineReportControllerTest_3(){
        OpportunityPipelineReportController obj=new OpportunityPipelineReportController();
        obj.getYears();
        obj.GenerateReport();        
        obj.OpportunityPipelineQuarterReport('q2');
        obj.SaveAsExcel();
        obj.SaveAspdf();
        List<OpportunityPipelineReportObject> reportobject1=obj.OpportunitiesTotalPipelineQ2;
        
    }
    public static testMethod void OpportunityPipelineReportControllerTest_4(){
        OpportunityPipelineReportController obj=new OpportunityPipelineReportController();
        obj.getYears();
        obj.GenerateReport();        
        obj.OpportunityPipelineQuarterReport('q3');
        obj.SaveAsExcel();
        obj.SaveAspdf();
        List<OpportunityPipelineReportObject> reportobject1=obj.OpportunitiesTotalPipelineQ3;
        
    }
    public static testMethod void OpportunityPipelineReportControllerTest_5(){
        OpportunityPipelineReportController obj=new OpportunityPipelineReportController();
        obj.getYears();
        obj.GenerateReport();        
        obj.OpportunityPipelineQuarterReport('q4');
        obj.SaveAsExcel();
        obj.SaveAspdf();
        List<OpportunityPipelineReportObject> reportobject1=obj.OpportunitiesTotalPipelineQ4;
        
    }
}