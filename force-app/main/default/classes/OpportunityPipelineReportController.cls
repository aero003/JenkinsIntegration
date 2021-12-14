public class OpportunityPipelineReportController {
    Integer closeDateWhen = 1;
    public List<String> UserName{get;set;}
    public List<String> countryName;
    public string renderAspdf{get;set;}
    public string renderAsExcel{get;set;}
    
    public List<Id> UserIds{get; set;}
    public List<Id> AllUserIds{get; set;}
    public List<Id> RecordtypeIds{get; set;}
    List<user> ListOfUsers{get;set;}
    
    Map<String, List<User>> map_Section_ListUser = new Map<String, List<User>>();
    Set<String> setOfSection = new Set<String>();
    Opportunity_Pipeline_Report_Settings__c oprs = Opportunity_Pipeline_Report_Settings__c.getOrgDefaults();
    
    public List<OpportunityPipelineReportObject> OpportunitiesTotalPipeline{get;set;}
    public List<OpportunityPipelineReportObject> OpportunitiesTotalPipelineQ1{
        get{
            return OpportunityPipelineQuarterReport('q1');
        }
    }
    public List<OpportunityPipelineReportObject> OpportunitiesTotalPipelineQ2{
        get{
            return OpportunityPipelineQuarterReport('q2');
        }
    }
    public List<OpportunityPipelineReportObject> OpportunitiesTotalPipelineQ3{
        get{
            return OpportunityPipelineQuarterReport('q3');
        }
    }
    public List<OpportunityPipelineReportObject> OpportunitiesTotalPipelineQ4{
        get{
            return OpportunityPipelineQuarterReport('q4');
        }
    }
    
    public String selectedYear{get; set;}  
    public List<SelectOption> getYears(){
        List<SelectOption> options=new List<SelectOption>();
        for (Integer i = System.Today().year(); i >= System.Today().year()-3; i--) {
            options.add(new SelectOption(String.valueOf(i),String.valueOf(i)));
        }
        return options;
    }
    public List<String> selectedUsers{get; set;}
    public List<SelectOption> Users{get; set;}   
    /*-------------------------------------------------------------------------------------------------------------------------------*/
    public PageReference SaveAspdf() {
        renderAspdf='pdf';
        //setup a default file name
        string fileName = 'Opportunity Pipeline Report '+ date.today() +'.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachemnt; filename='+fileName);
        return null;
    }
    public PageReference SaveAsExcel() {
        renderAsExcel='application/vnd.ms-excel#Opportunity Pipeline Report '+ date.today() +'.xls';
        return null;
    }
    /*---------------------------------------------------------------------------------------------------------------------------------*/
    
    public OpportunityPipelineReportController() {
        if(selectedYear==null || selectedYear > string.valueOf(system.today().year())){
            selectedYear=string.valueOf(system.today().year());
        }
        //get record type from custom settings
        String oppsPipelineRTs = oprs.OpportunityPipelineReportRecordType__c;
        List<string> ListOppsPipelineRTs = oppsPipelineRTs.split(',');
        RecordtypeIds = new List<ID>();
        string soql_recordtypes = 'Select ID from RecordType where name in :ListOppsPipelineRTs';
        for(Recordtype r: Database.query(soql_recordtypes)){
            RecordtypeIds.add(r.Id);
        }
        //get user alias from custom setting
        List<SelectOption> SelectUserOptions=new List<SelectOption>();
        List<string> List_UserAlias = new List<String>();
        List<OpportunityEfaxPipelineReportSettings__c> mcs = OpportunityEfaxPipelineReportSettings__c.getAll().values();
        if(mcs.size()>0){
            for(OpportunityEfaxPipelineReportSettings__c m:mcs){
                List_UserAlias.add(m.UserAliasNames__c);
                setOfSection.add(m.Section__c);
            }
        }
        String userValues = 'Select Name, alias, username from User where alias in :List_UserAlias';
        List<user> UsersList = Database.query(userValues);
        AllUserIds = new List<Id>();
        for(User u:UsersList){
            SelectUserOptions.add(new SelectOption(String.valueOf(u.Id),String.valueOf(u.Name)));
            AllUserIds.add(u.Id);
        } 
        Users = SelectUserOptions;
        selectedUsers = Alluserids;
        
        // Add key and values in Map - map_Section_ListUser
        for(String section : setOfSection){
            List<User> List_UserPerSection = new List<User>();
            for(User u : UsersList){
                for(OpportunityEfaxPipelineReportSettings__c setting : mcs){
                    if(u.Alias == setting.UserAliasNames__c && section == setting.Section__c){
                        List_UserPerSection.add(u);
                    }
                }
            }
            map_Section_ListUser.put(section, List_UserPerSection);
        }
    }
    public pageReference GenerateReport(){
        UserName=new List<String>();
        ListOfUsers = new List<User>();
        UserIds = new List<Id>();
        String soql_users = 'Select ID, alias, Name, username, Country from User where Id in :selectedUsers';
        ListOfUsers = Database.query(soql_users);
        For(User u: ListOfUsers){
            UserIds.add(u.id);
            UserName.add(u.Name);
        }
        
        List<Efax_corporate_reporting__c> all_efax_opportunity = [select  Opportunity__r.id, 
                                                                  Opportunity__r.Industry__c, 
                                                                  Opportunity__r.Account.Industry,
                                                                  Opportunity__r.Name,      
                                                                  Opportunity__r.StageName, 
                                                                  Opportunity__r.Probability, 
                                                                  Opportunity__r.CloseDate, 
                                                                  Opportunity__r.OwnerID, 
                                                                  Opportunity__r.Net_new_monthly_revenue__c,
                                                                  Total_Revenue__c,     
                                                                  WR__c     
                                                                  FROM Efax_corporate_reporting__c 
                                                                  where 
                                                                  CALENDAR_YEAR(Opportunity__r.CloseDate)=:Integer.valueOf(selectedYear) and 
                                                                  Opportunity__r.ownerid in :UserIds and 
                                                                  Opportunity__r.recordtypeid in :RecordtypeIds];
        
        OpportunitiesTotalPipeline = new List<OpportunityPipelineReportObject>();
        //Forloop for list of users.
        //Then forloop for all opportunities.
        
        for(String sec : map_Section_ListUser.keySet()){
            Boolean IsPresent = false;
            for(User u : map_Section_ListUser.get(sec)){
                if(selectedUsers.contains(u.Id)){
                    IsPresent=true;
                }
            }
            if(IsPresent == true){
                OpportunityPipelineReportObject opreport_heading = new OpportunityPipelineReportObject('Heading', sec);
                OpportunitiesTotalPipeline.add(opreport_heading);    
            }
            for(User user : map_Section_ListUser.get(sec)){
                if(selectedUsers.contains(user.id)){
                    OpportunityPipelineReportObject opreport = new OpportunityPipelineReportObject(user.Name, sec);
                    for(Efax_corporate_reporting__c op: all_efax_opportunity){
                        //Total Opportunity condition.
                        //Other reports will come inside this for loop.
                        if(op.Opportunity__r.OwnerId == user.id){
                            Integer op_probability = Integer.valueOf(Math.ceil(op.Opportunity__r.Probability));
                            switch on op_probability{
                                when 0{
                                    opreport.ClosedLostCount++;
                                }
                                when else{
                                    opreport.TotalCount++;
                                    if(op.Total_Revenue__c != null){
                                        opreport.TotalAmount += Integer.valueOf(op.Total_Revenue__c);
                                    }
                                    //Healthcare industry
                                    if(op.Opportunity__r.Industry__c != null && op.Opportunity__r.Industry__c.contains('Health')){
                                        opreport.HealthcareCount++;
                                        if(op.Total_Revenue__c != null){
                                            opreport.HealthcareAmount += Integer.valueOf(op.Total_Revenue__c);
                                        }
                                    }
                                    //closed won count
                                    if(op.Opportunity__r.Probability == 100){
                                        opreport.ClosedWonCount++;
                                    }
                                }
                            }
                        }
                    }
                    OpportunitiesTotalPipeline.add(opreport);
                }
            }
            if(isPresent == true){
                if(OpportunitiesTotalPipeline.size()>0){
                    OpportunityPipelineReportObject opreport_Total = new OpportunityPipelineReportObject('Total', sec);
                    for(OpportunityPipelineReportObject oppr : OpportunitiesTotalPipeline){
                        if(sec == oppr.Country){
                            
                            //total of toal pipeline
                            opreport_Total.TotalCount += oppr.TotalCount;
                            opreport_Total.TotalAmount += oppr.TotalAmount;
                            
                            //total of healthcare
                            opreport_Total.HealthcareCount += oppr.HealthcareCount;
                            opreport_Total.HealthcareAmount += oppr.HealthcareAmount;
                            
                            //total of closed won/closed lost
                            opreport_Total.ClosedWonCount += oppr.ClosedWonCount;
                            opreport_Total.ClosedLostCount += oppr.ClosedLostCount;
                        }
                    }
                    OpportunitiesTotalPipeline.add(opreport_Total);
                    if(sec == 'US'){
                        Integer USCount = map_Section_ListUser.get('US').size();
                        OpportunityPipelineReportObject opreport_USAvg = new OpportunityPipelineReportObject('Average', sec);
                        opreport_USAvg.AvgTotalCount = decimal.valueOf(opreport_Total.TotalCount)/decimal.valueOf(USCount);
                        opreport_USAvg.AvgTotalCount = opreport_USAvg.AvgTotalCount.setScale(2);
                        opreport_USAvg.TotalAmount =  math.round(decimal.valueOf(opreport_Total.TotalAmount)/decimal.valueOf(USCount));
                        opreport_USAvg.AvgHealthcareCount = decimal.valueOf(opreport_Total.HealthcareCount)/decimal.valueOf(USCount);
                        opreport_USAvg.AvgHealthcareCount =  opreport_USAvg.AvgHealthcareCount.setScale(2);
                        opreport_USAvg.HealthcareAmount = math.round(Decimal.valueOf(opreport_Total.HealthcareAmount)/decimal.valueOf(USCount));
                        OpportunitiesTotalPipeline.add(opreport_USAvg);
                    }
                }
            }
        }
        
        if(OpportunitiesTotalPipeline.size()>0){
            OpportunityPipelineReportObject opreport_all = new OpportunityPipelineReportObject('Total','');
            for(OpportunityPipelineReportObject oppr: OpportunitiesTotalPipeline) 
            {  
                if(oppr.UserName != 'Total' && oppr.UserName != 'Average'){
                    opreport_all.UserName = 'Grand Total';
                    //total of toal pipeline
                    opreport_all.TotalCount += oppr.TotalCount;
                    opreport_all.TotalAmount += oppr.TotalAmount;
                    
                    //total of healthcare
                    opreport_all.HealthcareCount += oppr.HealthcareCount;
                    opreport_all.HealthcareAmount += oppr.HealthcareAmount;
                    
                    //total of closed won/closed lost
                    opreport_all.ClosedWonCount += oppr.ClosedWonCount;
                    opreport_all.ClosedLostCount += oppr.ClosedLostCount;
                }
            }
            OpportunitiesTotalPipeline.add(opreport_all);  
        }
        
        return null;
    }
    public List<OpportunityPipelineReportObject> OpportunityPipelineQuarterReport(String quarterName){
        
        switch on quarterName{
            when 'q1'{
                closeDateWhen = 1;
            }
            when 'q2'{
                closeDateWhen = 2;
            }
            when 'q3'{
                closeDateWhen = 3;
            }
            when 'q4'{
                closeDateWhen = 4;
            }
        }
        List<Efax_corporate_reporting__c> all_efax_opportunity = [select  Opportunity__r.id, Opportunity__r.Industry__c, Opportunity__r.Account.Industry,
                                                                  Opportunity__r.Name, Opportunity__r.StageName, Opportunity__r.Probability, 
                                                                  Opportunity__r.CloseDate, Opportunity__r.OwnerID, Opportunity__r.Net_new_monthly_revenue__c,
                                                                  Total_Revenue__c, WR__c, MRR__c,MRR_ToGo__c FROM Efax_corporate_reporting__c 
                                                                  where CALENDAR_QUARTER(Opportunity__r.closeDate) = :closeDateWhen and 
                                                                  CALENDAR_YEAR(Opportunity__r.closeDate)= :Integer.valueOf(selectedYear) and
                                                                  Opportunity__r.ownerid in :UserIds and 
                                                                  Opportunity__r.recordtypeid in :RecordtypeIds];
        List<OpportunityPipelineReportObject> OpportunitiesTotalPipelineQ = new List<OpportunityPipelineReportObject>();
        
        //Forloop for list of users.
        //Then forloop for all opportunities.
        for(String sec : map_Section_ListUser.keySet()){
            boolean IsPresent = false;
            //  System.debug('Section = ' + sec);
            for(User u : map_Section_ListUser.get(sec)){
                if(selectedUsers.contains(u.Id)){
                    IsPresent = true;
                }
            }
            if(IsPresent == true){
                OpportunityPipelineReportObject opreport_heading = new OpportunityPipelineReportObject('Heading', sec);
                OpportunitiesTotalPipelineQ.add(opreport_heading);
            }
            for(User user : map_Section_ListUser.get(sec)){
                if(selectedUsers.contains(user.id)){
                    OpportunityPipelineReportObject opreport = new OpportunityPipelineReportObject(user.Name, sec);
                    for(Efax_corporate_reporting__c op: all_efax_opportunity){
                        if(op.Opportunity__r.OwnerId == user.id){
                            
                            System.debug('User Name = ' + user.name);
                            System.debug('Month = ' + op.Opportunity__r.closeDate.month());
                            System.debug('Amount = ' + op.Opportunity__r.Net_new_monthly_revenue__c);
                            System.debug('Probability = '  + op.Opportunity__r.Probability);
                            System.debug('MRR_ToGo__c = ' + op.MRR_ToGo__c);
                            Integer op_probability = Integer.valueOf(Math.ceil(op.Opportunity__r.Probability));
                            
                            switch on op_probability{
                                when 0{
                                    opreport.ClosedLostCount++;
                                }
                                when else{
                                    opreport.QCount++;
                                    if(op.Total_Revenue__c != null){
                                        opreport.QRevenue += Integer.valueOf(op.Total_Revenue__c);
                                    }
                                    
                                    //Healthcare industry
                                    if(op.Opportunity__r.Industry__c != null && op.Opportunity__r.Industry__c.contains('Health')){
                                        opreport.QHCCount++;
                                        if(op.Total_Revenue__c != null){
                                            opreport.QHCRevenue += Integer.valueOf(op.Total_Revenue__c);
                                        }
                                    }
                                    //closed won count
                                    if(op.Opportunity__r.Probability != 100){
                                        if(op.MRR_ToGo__c != null){
                                            opreport.QMRR_ToGo += Integer.valueOf(op.MRR_ToGo__c);
                                        }
                                    }
                                    if(op.Opportunity__r.Probability == 100){
                                        if(op.Mrr__c != null){
                                            opreport.QMrr += Integer.valueOf(op.Mrr__c);
                                        }
                                    }
                                }
                            }
                        }
                    }   
                    OpportunitiesTotalPipelineQ.add(opreport);
                }
            }
            if(IsPresent == true){
                if(OpportunitiesTotalPipelineQ.size()>0){
                    OpportunityPipelineReportObject opreportQ_Total = new OpportunityPipelineReportObject('Total', sec);
                    for(OpportunityPipelineReportObject opprQ : OpportunitiesTotalPipelineQ){
                        if(sec == opprQ.Country){
                            
                            //total of toal pipeline
                            opreportQ_Total.QRevenue += opprQ.QRevenue;
                            opreportQ_Total.QCount += opprQ.QCount;
                            
                            //total of healthcare
                            opreportQ_Total.QHCCount += opprQ.QHCCount;
                            opreportQ_Total.QHCRevenue += opprQ.QHCRevenue;
                            
                            opreportQ_Total.QMrr += opprQ.QMrr;
                            
                            //total of closed won/closed lost
                            opreportQ_Total.QMRR_ToGo += opprQ.QMRR_ToGo;
                            opreportQ_Total.QClosedWonCount += opprQ.QClosedWonCount;
                        }
                    }
                    OpportunitiesTotalPipelineQ.add(opreportQ_Total);
                    if(sec == 'US'){
                        Integer USCount = map_Section_ListUser.get('US').size();
                        OpportunityPipelineReportObject opreportQ_USAvg = new OpportunityPipelineReportObject('Average', sec);
                        opreportQ_USAvg.QRevenue =  math.round(Decimal.valueOf(opreportQ_Total.QRevenue)/Decimal.valueOf(USCount));
                        opreportQ_USAvg.AvgQCount = math.round(Decimal.valueOf(opreportQ_Total.QCount)/Decimal.valueOf(USCount));
                        opreportQ_USAvg.AvgQCount = opreportQ_USAvg.AvgQCount.SetScale(2);
                        opreportQ_USAvg.QHCRevenue = math.round(Decimal.valueOf(opreportQ_Total.QHCRevenue)/Decimal.valueOf(USCount));
                        opreportQ_USAvg.AvgQHCCount = math.round(Decimal.valueOf(opreportQ_Total.QHCCount)/Decimal.valueOf(USCount));
                        opreportQ_USAvg.AvgQHCCount = opreportQ_USAvg.AvgQHCCount.SetScale(2);
                        opreportQ_USAvg.QMrr = math.round(Decimal.valueOf(opreportQ_Total.QMrr)/Decimal.valueOf(USCount));
                        opreportQ_USAvg.QMRR_ToGo = math.round(Decimal.valueOf(opreportQ_Total.QMRR_ToGo)/Decimal.valueOf(USCount));
                        OpportunitiesTotalPipelineQ.add(opreportQ_USAvg);
                    }
                }
            }
        }
        if(OpportunitiesTotalPipelineQ.size()>0){
            OpportunityPipelineReportObject opreport_all = new OpportunityPipelineReportObject('Total','');
            for(OpportunityPipelineReportObject oppr: OpportunitiesTotalPipelineQ) 
            {  
                if(oppr.UserName != 'Total' && oppr.UserName != 'Average'){
                    opreport_all.UserName = 'Grand Total';
                    //total of toal pipeline
                    opreport_all.QRevenue += oppr.QRevenue;
                    opreport_all.QCount += oppr.QCount;
                    
                    //total of healthcare
                    opreport_all.QHCCount += oppr.QHCCount;
                    opreport_all.QHCRevenue += oppr.QHCRevenue;
                    
                    opreport_all.QMrr += oppr.QMrr;
                    
                    //total of closed won/closed lost
                    opreport_all.QMRR_ToGo += oppr.QMRR_ToGo;
                    opreport_all.QClosedWonCount += oppr.QClosedWonCount;
                }
            }
            OpportunitiesTotalPipelineQ.add(opreport_all);  
        }
        return OpportunitiesTotalPipelineQ;
    }
}