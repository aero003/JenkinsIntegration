public class OpportunityEfaxVolumeReportController {
   public List<Efax_corporate_reporting__c> ListOfEfaxReporting{get;set;}
   public List<OpportunityEfaxVolumeReportObject> ListOfEfaxVolumeReport {get;set;}
    
    public List<String> UserName{get;set;}
    public List<Id> UserIds{get; set;}
    public List<Id> AllUserIds{get; set;}
    public List<Id> RecordtypeIds{get; set;}
    List<user> ListOfUsers{get;set;}
    
    public string renderAsExcel{get;set;}
    public string renderAsPdf{get;set;}
    
    Opportunity_Pipeline_Report_Settings__c OpportunityReportSettings = Opportunity_Pipeline_Report_Settings__c.getOrgDefaults();
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
    
    public PageReference saveAsPdf(){
        renderAsPdf='pdf';
        //setup a default filename
        String filename='Corporate Fax Enterprise Page Volume Pipeline Report' + date.today() + '.pdf';
        ApexPages.currentPage().getHeaders().put('content-disposition','attachment; filename=' + filename);
        return null;
    }
    public PageReference saveAsExcel(){
        renderAsExcel='application/vnd.ms-excel#Corporate Fax Enterprise Page Volume Pipeline Report.xls';
        return null;
    }
    Public OpportunityEfaxVolumeReportController(){ 
        if(selectedYear==null || selectedYear > string.valueOf(system.today().year())){
            selectedYear=string.valueOf(system.today().year());
        }
        //get user alias from custom setting
        List<SelectOption> SelectUserOptions=new List<SelectOption>();
        
        string useraliases = OpportunityReportSettings.OpportunityPipelineReportUserAlias__c;
        List<string> SetUserAlias = useraliases.split(',');
        String userValues = 'Select Name, username from User where alias in :SetUserAlias';
        List<user> UsersList = Database.query(userValues);
        
        AllUserIds = new List<Id>();
        for(User u:UsersList){
            SelectUserOptions.add(new SelectOption(String.valueOf(u.Id),String.valueOf(u.Name)));
            AllUserIds.add(u.Id);
        } 
        Users = SelectUserOptions;
        selectedUsers = AllUserIds;
        
        //get Record Type from custom settings
        String oppsPipelineRTs = OpportunityReportSettings.OpportunityPipelineReportRecordType__c;
        List<string> ListOppsPipelineRTs = oppsPipelineRTs.split(',');
        System.debug('Custom settings record type values === ' +  ListOppsPipelineRTs[1]);
        RecordtypeIds = new List<ID>();
        string soql_recordtypes = 'Select ID from RecordType where name in :ListOppsPipelineRTs';
        for(Recordtype r: Database.query(soql_recordtypes)){
            RecordtypeIds.add(r.Id);
        }
    }
    public pageReference GenerateReport(){
        
        UserName = new List<String>();
        ListOfUsers = new List<User>();
        UserIds = new List<Id>();
        
        String soql_users = 'Select ID, Name, username from User where Id in :selectedUsers';
        List<user> ListOfUsers = Database.query(soql_users);
        For(User u: ListOfUsers){
            UserIds.add(u.id);
            UserName.add(u.Name);
        }
        List<Efax_corporate_reporting__c> all_efax_opportunity = [select  Opportunity__r.id, 
                                                                  Opportunity__r.Industry__c, 
                                                                  Opportunity__r.Account.Industry,
                                                                  Opportunity__r.Account.Name,
                                                                  Opportunity__r.Name,
                                                                  Opportunity__r.StageName, 
                                                                  Opportunity__r.Probability, 
                                                                  Opportunity__r.CloseDate, 
                                                                  Opportunity__r.OwnerID, 
                                                                  Opportunity__r.eFax_Corporate_Product__c,
                                                                  Opportunity__r.Current_Solution_Provider__c,
                                                                  Opportunity__r.Net_new_monthly_revenue__c,
                                                                  Opportunity__r.Current_receive_pages_month__c,
                                                                  Opportunity__r.Current_send_pages_month__c,
                                                                  Opportunity__r.Net_new_receive_pages_month__c,
                                                                  opportunity__r.Net_new_send_pages_month__c,
                                                                  ConnectionReceivedId,ConnectionSentId,
                                                                  CreatedById,CreatedDate,
                                                                  Id,IsDeleted,
                                                                  LastModifiedById,LastModifiedDate,
                                                                  MRR__c,Name,
                                                                  OpportunityID__c,Opportunity__c,
                                                                  SystemModstamp,                                                                
                                                                  WR_Inbound__c,WR_Outbound__c
                                                                  
                                                                  FROM Efax_corporate_reporting__c 
                                                                  where 
                                                                  (TotalPages__c != 0) and
                                                                  CALENDAR_YEAR(Opportunity__r.CloseDate)= :Integer.valueOf(selectedYear) and
                                                                 // CALENDAR_YEAR(Opportunity__r.CloseDate) = 2018 and
                                                                  Opportunity__r.ownerid in :UserIds and 
                                                                  Opportunity__r.recordtypeid in :RecordtypeIds];
        
        ListOfEfaxVolumeReport = new List<OpportunityEfaxVolumeReportObject>();
        
        // get Opportunity Efax Product Picklist values in List
        List<string> efax_product_list = new List<string>();
        Schema.DescribeFieldResult fieldResult = Opportunity.eFax_Corporate_Product__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            efax_product_list.add(pickListVal.getLabel());
        }     
        
        //Forloop for list of users.
        //Then forloop for all opportunities.
        for(User usr: ListOfUsers){
            System.debug('user size = '  + ListOfUsers.size()) ;
            List<OpportunityEfaxVolumeReportObject> opreportPage = new List<OpportunityEfaxVolumeReportObject>(); 
            
            // create maps to create new instance of OpportunityEfaxVolumeReportObject for every product in efax_product_list
            Map<string, List<OpportunityEfaxVolumeReportObject>> map_product_Pages = new Map<string, List<OpportunityEfaxVolumeReportObject>>();
            for(String str : efax_product_list){
                map_product_Pages.put(str, new List<OpportunityEfaxVolumeReportObject>());
            }
            
            for(Efax_corporate_reporting__c op: all_efax_opportunity){
                if(op.Opportunity__r.OwnerId == usr.id){
                    System.debug('Opp owner id = user id, user name = ' + usr.Name);
                    //create object of report helper class.
                    
                    if(map_product_Pages.containsKey(op.Opportunity__r.eFax_Corporate_Product__c)){
                        System.debug('map inside loop called for product: ' + op.Opportunity__r.eFax_Corporate_Product__c);
                        
                        opreportPage = map_product_Pages.get(op.Opportunity__r.eFax_Corporate_Product__c);
                        if(opreportPage.size() == 0){
                            opreportPage.add(new OpportunityEfaxVolumeReportObject());
                            opreportPage.add(new OpportunityEfaxVolumeReportObject());
                            opreportPage.add(new OpportunityEfaxVolumeReportObject());
                            opreportPage.add(new OpportunityEfaxVolumeReportObject());
                        }
                        
                        // for Product total(Inbound + Outbound) 
                        Integer jji=0;
                        for(jji=op.Opportunity__r.CloseDate.Month();jji<=12;jji++){
                            opreportPage[0].Month[jji-1] += Integer.valueOf(op.WR_Inbound__c + op.WR_Outbound__c );
                        } 
                        if(op.Opportunity__r.Net_new_receive_pages_month__c!=null){
                            opreportPage[0].Pages += Integer.valueOf(op.Opportunity__r.Net_new_receive_pages_month__c);
                        }
                        if(op.Opportunity__r.Net_new_send_pages_month__c != null){
                            opreportPage[0].Pages += Integer.valueOf(op.Opportunity__r.Net_new_send_pages_month__c);
                        }
                        opreportPage[0].UserName = usr.Name;
                        opreportPage[0].ProbabilityCount++;
                        opreportPage[0].TotalProbability += Integer.valueOf(op.Opportunity__r.Probability);                     
                        opreportPage[0].Product = op.Opportunity__r.eFax_Corporate_Product__c;
                        opreportPage[0].January = opreportPage[0].Month[0];
                        opreportPage[0].February = opreportPage[0].Month[1];
                        
                        opreportPage[0].March = opreportPage[0].Month[2];
                        opreportPage[0].April = opreportPage[0].Month[3];
                        
                        opreportPage[0].May = opreportPage[0].Month[4];
                        opreportPage[0].June = opreportPage[0].Month[5];
                        
                        opreportPage[0].July = opreportPage[0].Month[6];
                        opreportPage[0].August = opreportPage[0].Month[7];
                        
                        opreportPage[0].September = opreportPage[0].Month[8];
                        opreportPage[0].October = opreportPage[0].Month[9];
                        
                        opreportPage[0].November = opreportPage[0].Month[10];
                        opreportPage[0].December = opreportPage[0].Month[11];
                        
                        
                        // for Product's Inbound
                        Integer ji=0;
                        for(ji=op.Opportunity__r.CloseDate.Month();ji<=12;ji++){
                            opreportPage[1].Month[ji-1] += Integer.valueOf(op.WR_Inbound__c);
                        } 
                        if(op.Opportunity__r.Net_new_receive_pages_month__c!=null){
                            opreportPage[1].Pages += Integer.valueOf(op.Opportunity__r.Net_new_receive_pages_month__c);
                        }
                        opreportPage[1].PageName = 'Inbound';
                        opreportPage[1].ProbabilityCount++;
                        opreportPage[1].Product = op.Opportunity__r.eFax_Corporate_Product__c;
                        opreportPage[1].TotalProbability += Integer.valueOf(op.Opportunity__r.Probability); 
                        opreportPage[1].January = opreportPage[1].Month[0];
                        opreportPage[1].February = opreportPage[1].Month[1];
                        
                        opreportPage[1].March = opreportPage[1].Month[2];
                        opreportPage[1].April = opreportPage[1].Month[3];
                        
                        opreportPage[1].May = opreportPage[1].Month[4];
                        opreportPage[1].June = opreportPage[1].Month[5];
                        
                        opreportPage[1].July = opreportPage[1].Month[6];
                        opreportPage[1].August = opreportPage[1].Month[7];
                        
                        opreportPage[1].September = opreportPage[1].Month[8];
                        opreportPage[1].October = opreportPage[1].Month[9];
                        
                        opreportPage[1].November = opreportPage[1].Month[10];
                        opreportPage[1].December = opreportPage[1].Month[11];
                        
                        //for Product's Outbound Record
                        Integer j=0;
                        for(j=op.Opportunity__r.CloseDate.Month();j<=12;j++){
                            opreportPage[2].Month[j-1] += Integer.valueOf(op.WR_Outbound__c);
                        }
                        if(op.Opportunity__r.Net_new_send_pages_month__c!=null){
                            opreportPage[2].Pages += Integer.valueOf(op.Opportunity__r.Net_new_send_pages_month__c);
                        }
                        opreportPage[2].PageName = 'Outbound';
                        opreportPage[2].Product = op.Opportunity__r.eFax_Corporate_Product__c;
                        opreportPage[2].ProbabilityCount++;
                        opreportPage[2].TotalProbability += Integer.valueOf(op.Opportunity__r.Probability); 
                        opreportPage[2].January = opreportPage[2].Month[0];
                        opreportPage[2].February = opreportPage[2].Month[1];
                        
                        opreportPage[2].March = opreportPage[2].Month[2];
                        opreportPage[2].April = opreportPage[2].Month[3];
                        
                        opreportPage[2].May = opreportPage[2].Month[4];
                        opreportPage[2].June = opreportPage[2].Month[5];
                        
                        opreportPage[2].July = opreportPage[2].Month[6];
                        opreportPage[2].August = opreportPage[2].Month[7];
                        
                        opreportPage[2].September = opreportPage[2].Month[8];
                        opreportPage[2].October = opreportPage[2].Month[9];
                        
                        opreportPage[2].November = opreportPage[2].Month[10];
                        opreportPage[2].December = opreportPage[2].Month[11];
                        
                        System.debug('User is ' + usr.Name +  ', opreport(list) for product '+  op.Opportunity__r.eFax_Corporate_Product__c +'  = ' +opreportPage );
                        map_product_Pages.put(op.Opportunity__r.eFax_Corporate_Product__c,opreportPage);
                    }
                    
                }
                
            }
           
            system.debug('size of map for user '+ usr.Name +' is ' + map_product_pages.size());
           
            for(List<OpportunityEfaxVolumeReportObject> mp:map_product_Pages.values()){
                //System.debug('map values = ' + map_product_Pages.values());
                
                if(mp.size() > 0){
                    ListOfEfaxVolumeReport.add(mp[0]);
                    ListOfEfaxVolumeReport.add(mp[1]);  
                    ListOfEfaxVolumeReport.add(mp[2]); 
                    //for total
                    opreportPage[3].Product = 'Total';
                    opreportPage[3].UserName = mp[0].UserName;
                    opreportPage[3].Pages += mp[0].Pages;
                    opreportPage[3].January += mp[0].January;
                    opreportPage[3].February += mp[0].February;
                    
                    System.debug('Total of January = ' + opreportPage[3].January + ' ' + usr.Name);
                    System.debug('Total of february = ' + opreportPage[3].February + ' ' + usr.Name);
                    
                    opreportPage[3].March += mp[0].March;
                    opreportPage[3].April += mp[0].April;
                    
                    opreportPage[3].May += mp[0].May;
                    opreportPage[3].June += mp[0].June;
                    
                    opreportPage[3].July += mp[0].July;
                    opreportPage[3].August += mp[0].August;
                    
                    opreportPage[3].September += mp[0].September;
                    opreportPage[3].October += mp[0].October;
                    
                    opreportPage[3].November += mp[0].November;
                    opreportPage[3].December += mp[0].December; 
                }
            }
            if(opreportPage.size()>2){
                ListOfEfaxVolumeReport.add(opreportPage[3]);
            }
        }
        //Add Grand Total Product wise with Inbound and Outbound
        List<OpportunityEfaxVolumeReportObject> opreportGrandTotal = new List<OpportunityEfaxVolumeReportObject>();
        opreportGrandTotal.add(new OpportunityEfaxVolumeReportObject());
        opreportGrandTotal.add(new OpportunityEfaxVolumeReportObject());
        opreportGrandTotal.add(new OpportunityEfaxVolumeReportObject());
        
        Map<String, List<OpportunityEfaxVolumeReportObject>> map_for_grandTotal = new Map<String, List<OpportunityEfaxVolumeReportObject>>();
        System.debug('List of efax volume report = ' + ' ' + ListOfEfaxVolumeReport );
        for(String str : efax_product_list){
            map_for_grandTotal.put(str, new List<OpportunityEfaxVolumeReportObject>());
        }
        for(OpportunityEfaxVolumeReportObject ro: ListOfEfaxVolumeReport){
            if(map_for_grandTotal.containsKey(ro.Product)){
                opreportGrandTotal = map_for_grandTotal.get(ro.Product);
                if(opreportGrandTotal.size()==0){
                    opreportGrandTotal.add(new OpportunityEfaxVolumeReportObject());
                    opreportGrandTotal.add(new OpportunityEfaxVolumeReportObject());
                    opreportGrandTotal.add(new OpportunityEfaxVolumeReportObject());
                    opreportGrandTotal.add(new OpportunityEfaxVolumeReportObject());
                }
                if(ro.Product!=null && ro.PageName == null){
                    
                    opreportGrandTotal[0].UserName = 'Grand Total';
                    
                    opreportGrandTotal[0].Product = ro.Product;
                    opreportGrandTotal[0].Pages += ro.Pages;
                    opreportGrandTotal[0].january += ro.january;
                    opreportGrandTotal[0].february += ro.february;
                    opreportGrandTotal[0].march += ro.march;
                    opreportGrandTotal[0].april += ro.april;
                    opreportGrandTotal[0].may += ro.may;
                    opreportGrandTotal[0].june += ro.june;
                    opreportGrandTotal[0].july += ro.july;
                    opreportGrandTotal[0].august += ro.august;
                    opreportGrandTotal[0].september += ro.september;
                    opreportGrandTotal[0].october += ro.october;
                    opreportGrandTotal[0].november += ro.november;
                    opreportGrandTotal[0].december += ro.december;
                    
                }
                if(ro.Product!=null && ro.PageName == 'Inbound'){
                    
                    opreportGrandTotal[1].PageName = ro.PageName;
                    opreportGrandTotal[1].Pages += ro.Pages;
                    opreportGrandTotal[1].january += ro.january;
                    opreportGrandTotal[1].february += ro.february;
                    opreportGrandTotal[1].march += ro.march;
                    opreportGrandTotal[1].april += ro.april;
                    opreportGrandTotal[1].may += ro.may;
                    opreportGrandTotal[1].june += ro.june;
                    opreportGrandTotal[1].july += ro.july;
                    opreportGrandTotal[1].august += ro.august;
                    opreportGrandTotal[1].september += ro.september;
                    opreportGrandTotal[1].october += ro.october;
                    opreportGrandTotal[1].november += ro.november;
                    opreportGrandTotal[1].december += ro.december;
                    //map_for_grandTotal.put(ro.Product,opreportGrandTotal);
                }
                
                if(ro.Product!=null && ro.PageName == 'Outbound'){
                    
                    
                    opreportGrandTotal = map_for_grandTotal.get(ro.Product);
                    
                    opreportGrandTotal[2].PageName = ro.PageName;
                    opreportGrandTotal[2].Pages += ro.Pages;
                    opreportGrandTotal[2].january += ro.january;
                    opreportGrandTotal[2].february += ro.february;
                    opreportGrandTotal[2].march += ro.march;
                    opreportGrandTotal[2].april += ro.april;
                    opreportGrandTotal[2].may += ro.may;
                    opreportGrandTotal[2].june += ro.june;
                    opreportGrandTotal[2].july += ro.july;
                    opreportGrandTotal[2].august += ro.august;
                    opreportGrandTotal[2].september += ro.september;
                    opreportGrandTotal[2].october += ro.october;
                    opreportGrandTotal[2].november += ro.november;
                    opreportGrandTotal[2].december += ro.december;
                }
                map_for_grandTotal.put(ro.Product,opreportGrandTotal);
            }
        }
        
        for(List<OpportunityEfaxVolumeReportObject> mp1:map_for_grandTotal.values()){
            if(mp1.size()>0){
                ListOfEfaxVolumeReport.add(mp1[0]);
                ListOfEfaxVolumeReport.add(mp1[1]);
                ListOfEfaxVolumeReport.add(mp1[2]);
                //for total
                opreportGrandTotal[3].Product = 'Total';
                //  opreportGrandTotal[3].UserName = 'Grand Total';
                opreportGrandTotal[3].Pages += mp1[0].Pages;
                opreportGrandTotal[3].January += mp1[0].January;
                opreportGrandTotal[3].February += mp1[0].February;
                
                opreportGrandTotal[3].March += mp1[0].March;
                opreportGrandTotal[3].April += mp1[0].April;
                
                opreportGrandTotal[3].May += mp1[0].May;
                opreportGrandTotal[3].June += mp1[0].June;
                
                opreportGrandTotal[3].July += mp1[0].July;
                opreportGrandTotal[3].August += mp1[0].August;
                
                opreportGrandTotal[3].September += mp1[0].September;
                opreportGrandTotal[3].October += mp1[0].October;
                
                opreportGrandTotal[3].November += mp1[0].November;
                opreportGrandTotal[3].December += mp1[0].December; 
            }
        }
        if(opreportGrandTotal.size()>3){
              ListOfEfaxVolumeReport.add(opreportGrandTotal[3]);
          }
        return null;
    }
    
    public class OpportunityEfaxVolumeReportObject{
        
        public Integer[] Month = new Integer[12];
        public string UserName {get;set;}
        
        public String PageName{get;set;}
        
        public String Product{get;set;}
        
        public Integer Pages{get;set;}
        public Integer January {get;set;}
        public Integer February {get;set;}
        public Integer March {get;set;}
        public Integer April {get;set;}
        public Integer May {get;set;}
        public Integer June {get;set;}
        public Integer July {get;set;}
        public Integer August {get;set;}
        public Integer September {get;set;}
        public Integer October {get;set;}
        public Integer November {get;set;}
        public Integer December {get;set;}
        public Integer Total_Revenue{
            get{
                return january + february + march + april + may + june + july + august + 
                    september + october + november + december;
            }
            set{
                Total_Revenue = value;
            }
        }
        public Integer ProbabilityCount{get;set;}
        public Integer TotalProbability{get;set;}
        public Integer Probability {
            get{
                if(ProbabilityCount > 0){
                    return TotalProbability/ProbabilityCount;    
                }
                else{
                    return 0;
                }
            }
            set{
                Probability = value;
            }
        }
        
        
        public OpportunityEfaxVolumeReportObject(){
            this.UserName = '';
            // this.Product = '';
            this.Probability = 0;
            this.ProbabilityCount = 0;
            this.TotalProbability = 0;
            this.Pages = 0;
            //this.Total_Revenue = 0;
            
            this.Month[0]=0;
            this.Month[1]=0;
            this.Month[2]=0;
            this.Month[3]=0;
            this.Month[4]=0;
            this.Month[5]=0;
            this.Month[6]=0;
            this.Month[7]=0;
            this.Month[8]=0;
            this.Month[9]=0;
            this.Month[10]=0;
            this.Month[11]=0;
            
            
            this.January = 0;
            this.February = 0;
            this.March = 0;
            this.April = 0;
            this.May = 0;
            this.June = 0;
            this.July = 0;
            this.August = 0;
            this.September = 0;
            this.October = 0;
            this.November = 0;
            this.December = 0;
            
        }
    }
}