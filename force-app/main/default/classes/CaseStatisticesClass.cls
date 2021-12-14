/****** This class is used to get the total open case count and also current users open case count, this is used in OpenCaseViewPage which
        is a home page component *******/
public Class CaseStatisticesClass{

    public CaseStatisticesClass() {
         statusValues = new list <String> {'Closed','Resolved','Cancelled','Completed','Closed with no resolution','Closed - Duplicate'};
        openCaseCount();
        myopenCaseCount();
    }

    
    public Integer caseCount{get;set;}
    public Integer myCaseCount{get;set;}
    list <String> statusValues ;
    
    /*public CaseStatisticesClass (ApexPages.Standardcontroller stdcontroller){
        statusValues = new list <String> {'Closed','Resolved','Cancelled','Completed'};
        openCaseCount();
        myopenCaseCount();
    }*/
    
    public void openCaseCount(){
         caseCount = [select count() from case where Status='Open'];
    }
    
    public void myopenCaseCount(){
         //myCaseCount = [select count() from case where OwnerId=: UserInfo.getUserId()and Status NOT IN :statusValues];
         myCaseCount = [select count() from case where OwnerId=: UserInfo.getUserId()and isClosed=False];
    }
    
}