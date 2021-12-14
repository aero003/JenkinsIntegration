public class OpportunityPipelineReportObject {
    public Integer TotalCount{get;set;}

    public decimal AvgTotalCount{get;set;}
    public decimal AvgHealthcareCount{get;set;}
    public decimal AvgQHCCount{get;set;}
    public decimal AvgQCount{get;set;}
                                     
   
/*  public double AvgHealthcareAmount{get;set;}
    public double AvgQRevenue{get;set;}
    public double AvgTotalAmount{get;set;}
    public double AvgQHCRevenue{get;set;}
    public double AvgQMrr{get;set;}
    public double AvgQClosedWonAmount{get;set;}*/

   
    public Integer TotalAmount{
        get{
            return TotalAmount;
        }
        set{
            TotalAmount = value; 
        }
    }
    
    public Integer TotalASP {
        get{
            if(TotalCount != 0){
                return Math.round(Decimal.valueOf(TotalAmount)/TotalCount);
            } else {
                return 0;
            }
                
        }
    }
    
    public String UserName {get;set;}
    public string Country {get;set;}
    
    public Integer HealthcareCount {get; set;}
    public Integer HealthcareCountPercentage{
        get{
            if(TotalCount != 0){
                return Math.round((Decimal.valueOf(HealthcareCount)*100)/TotalCount);
            }
            else {
                return 0;
            }
        }
    }
    
    public Integer HealthcareAmount{
        get{
            return HealthcareAmount;
        }
        set{
            HealthcareAmount = value;
            
        }
    }
    public Integer HealthcareAmountPercentage{
        get{
            if(TotalCount != 0){
                return Math.round((Decimal.valueOf(HealthcareAmount)*100)/TotalAmount);
            } else {
                return 0;
            }
            
        }
    }
    public Integer HealthcareASP {
        get{
            if(HealthcareCount != 0)
                return Math.round((Decimal.valueOf(HealthcareAmount)/HealthcareCount));
            else
                return 0;
        }
    }
    public Integer ClosedWonCount{get; set;}
    public Integer ClosedLostCount{get;set;}
    
    public Integer WonLostPercentage{
        get{
            if((ClosedWonCount+ClosedLostCount) != 0){
                return Math.round((Decimal.valueOf(ClosedWonCount)*100/(ClosedWonCount+ClosedLostCount)));
            } else {
                return 0;
            }
            
        }
    }

    public integer QRevenue{
        get;set;
    }
    public integer QCount{
        get;set;
    }
    public integer QHCRevenue{
        get;set;
    }
    public integer QHCCount{
        get;set;
    }
    public integer QHCRevenuePercentage{
       get{
           if(QRevenue != 0){
               return Math.round((Decimal.valueOf(QHCRevenue)*100)/QRevenue);
           } else {
               return 0;
           }
                
        }
    }
    
    public integer QHCCountPercentage{
       get{
           if(Qcount != 0){
               return Math.round((Decimal.valueOf(QHCCount)*100)/QCount);
           } else {
               return 0;
           }
            
        }
    }
    public integer QMrr{
        get;set;
    }
    public integer QClosedWonCount{
        get;set;
    }
    public integer QClosedWonAmount{
        get;set;
    }
     public integer QMRR_ToGo{
        get;set;
    }
    
    public integer QClosedWonPercentage{
       get{
           if(QMrr != 0){
               return Math.round((Decimal.valueOf(QMrr)/Decimal.valueOf(QMRR_ToGo + QMrr))*100);
           } else {
               return 0;
           }
        }
    }
    public integer QACV_MRR{
       get{
           if(QMrr != 0){
               return Math.round((Decimal.valueOf(QMrr)*12));
           } else {
               return 0;
           }
        }
    }
    public integer QACV_ToGo{
       get{
           if(QMRR_ToGo != 0){
               return Math.round(Decimal.valueOf(QMRR_ToGo)*12);
           } else {
               return 0;
           }
        }
    }
    
    public OpportunityPipelineReportObject(String UserName, string CountryName){
        this.UserName = UserName;
        this.Country = CountryName;
        //total
        this.TotalCount = 0;
        this.TotalAmount = 0;
        //healthcare
        this.HealthcareCount = 0;
        this.HealthcareAmount = 0;
        //closed won/closed los
        this.ClosedWonCount = 0;
        this.ClosedLostCount = 0;
        //Quarter counts
        this.QRevenue = 0;
        this.QCount = 0;
        this.QHCRevenue = 0;
        this.QHCCount = 0;
        
        this.QMrr = 0;
        this.QClosedWonCount = 0;
        this.QClosedWonAmount = 0;
        this.QMRR_ToGo = 0;
    }
    
}