public class CaseAccountLookupController {
    
    
    public string searchString{get;set;} // search keyword
    public string getCaseId{get;set;}//case id from url parameter
    public string selectedAccountId{get;set;}//account selected from grid
    public string accountRecordType{get;set;}//search  record type using query
    public String username{get;set;}//get username from url
    
    //controller to fetch all properties declared above
    public caseAccountLookupController() {
        getCaseID = System.currentPageReference().getParameters().get('tocaseID');
        username = System.currentPageReference().getParameters().get('username');
        //accountRecordType = System.currentPageReference().getParameters().get('accountRecordType');
        accountRecordType = '';
        List<RecordType> rIdMap = [Select Name,Id,sobjecttype From RecordType where (Name like '%KeepItSafe%') and sobjecttype='Account'];
        for(RecordType rtid :rIdMap){
            if(rtid != null){
                accountRecordType += rtid.Id + ',';
            }
        }
        accountRecordType = accountRecordType.removeEnd(',');
        setPageSizeOnLoad();
        runSearch();
    }
    
    public ApexPages.StandardSetController con{get; set;} 
    public List<Account> results
    {
        get{
               if(con != null)  
                return (List<Account>)con.getRecords();  
            else  
                return null ;  
        }
        set;
    } // search results
    //for pagination
    Public Integer size{get;set;} 
    Public Integer noOfRecords{get; set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}
         
    public void setPageSizeOnLoad(){
        size=10;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
    }
    //Changes the size of pagination
    public PageReference refreshPageSize() {
         con.setPageSize(size);
         return null;
    }
    
   
    
    // performs the keyword search
    public PageReference search() {
        runSearch();
        return null;
    }
    // save case on click
    public PageReference saveCase() {
        system.debug('selected contact id is ' + selectedAccountId);
        Case cs = [select id, contactId,accountId from case where id = :getCaseId limit 1];
        cs.accountid = selectedAccountId;
        
        update cs;
        return null;
    }
    
    // prepare the query and issue the search command
    private void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
        results = performSearch(searchString);               
    } 
    
    // run the search and return the records found. 
    private List<Account> performSearch(string searchString) {
        system.debug('perform search called...');
        String soql = 'select id, name, ParentId,Parent.name,Point_of_Contact__c, Country_Code__c,Keepitsafe_Username__c , LastViewedDate from Account where ';

        if(accountRecordType != ''){
            string accountRecordTypeForSoql = '';
            if(accountRecordType.contains(',')){
                system.debug('accouhnt record type id is '  + accountRecordType);
                accountRecordTypeForSoql = '\'' + accountRecordType + '\'';
                accountRecordTypeForSoql = accountRecordTypeForSoql.replace(',', '\',\'');
            } else {
                accountRecordTypeForSoql = '\'' + accountRecordType + '\'';
            }
            soql = soql + ' recordtypeid IN (' + accountRecordTypeForSoql + ')';
        }
        if(searchString != '' && searchString != null){
            searchString = searchString.trim();
        }
        if(searchString != '' && searchString != null){
             soql = soql + ' and name LIKE \'' + searchString + '%\' ';
        } else if(username == ''){
            soql = soql +  ' and LastViewedDate !=null';
            soql = soql + ' ORDER BY LastViewedDate DESC';
        }
        
        System.debug(soql);
        List<Account> filteredAccounts = new List<Account>();
        

        for(List<Account> accts : Database.Query(soql)) {
            // Each loop processes 200 items
            for(Account a : accts) {
               if(searchString != '' && searchString != null){
                    filteredAccounts.add(a);
                } else if(a.Keepitsafe_Username__c !=null && username != ''){
                    if(a.Keepitsafe_Username__c.contains(username)) {
                        filteredAccounts.add(a);
                        System.debug(a);
                    }
                }
            }
        }
        
        con = new ApexPages.StandardSetController(filteredAccounts); 
        con.setPageSize(size);
        noOfRecords = con.getResultSize();
        return (List<Account>)con.getRecords();
    }
}