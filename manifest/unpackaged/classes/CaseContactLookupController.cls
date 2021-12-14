public class CaseContactLookupController {
    public Contact contact {get;set;}
    
    public string searchString{get;set;} // search keyword
    public string searchAccount{get;set;}//account from url parameter
    public string getCaseId{get;set;}//case id from url parameter
    public string selectedContactId{get;set;}//contact selected from grid
    public string contactRecordTypeID{get;set;}//contact record type
    
    public ApexPages.StandardSetController con{get; set;} 
    public List<Contact> results
    {
        get{
               if(con != null)  
                return (List<Contact>)con.getRecords();  
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
    
    public CaseContactLookupController() {       
        // get the current search string
        searchAccount = System.currentPageReference().getParameters().get('relatedaccid');
        getCaseID = System.currentPageReference().getParameters().get('tocaseID');
        if(System.currentPageReference().getParameters().get('cntRecordTypeID') != null){
            contactRecordTypeID = System.currentPageReference().getParameters().get('cntRecordTypeID');
        } else {
            contactRecordTypeID = '';
        }
        setPageSizeOnLoad();
        runSearch();
    }
    
    // performs the keyword search
    public PageReference search() {
        runSearch();
        return null;
    }
    // save case on click
    public PageReference saveCase() {
        system.debug('selected contact id is ' + selectedContactId);
        Case cs = [select id, contactId,accountId from case where id = :getCaseId limit 1];
        cs.contactid = selectedContactId;
        //if(searchAccount == '' || searchAccount == null){
            Contact saveAccId = [select accountid from contact where id=:selectedContactId limit 1];
            if(saveAccId != null)
                cs.AccountId = saveAccId.accountid;
        //}
        update cs;
        return null;
    }
    
    // prepare the query and issue the search command
    private void runSearch() {
        // TODO prepare query string for complex serarches & prevent injections
        results = performSearch(searchString);               
    } 
    
    // run the search and return the records found. 
    private List<Contact> performSearch(string searchString) {
        system.debug('perform search called...');
        String soql = 'select id, firstname,lastname,name,title,account.Country_Code__c, account.name,Customer_ID__c , account.id, email,LastViewedDate from contact where ';
        if(searchString != '' && searchString != null){
            searchString = searchString.trim();
        }
        if(searchString != '' && searchString != null){
            if(searchString.containsWhitespace()){
                List<string> searchStringList = searchString.split(' ');
                if(searchStringList[0] != ''){
                    soql = soql + ' firstname LIKE \'' + searchStringList[0] + '%\' ';
                }
                if(searchStringList[1] != ''){
                    soql = soql + ' and lastname LIKE \'' + searchStringList[1] + '%\'';
                }
            } else {
                soql = soql + ' ( firstname LIKE \'' + searchString + '%\' ';
                soql = soql + ' or lastname LIKE \'' + searchString + '%\' )';
            }
        }
        else if( searchAccount != '' && searchAccount != null ){
            soql = soql +  ' account.id =\'' + searchAccount + '\'';
        } else {
            soql = soql +  ' LastViewedDate !=null';
        }
        if(contactRecordTypeId != ''){
            string contactRecordTypeForSoql = '';
            if(contactRecordTypeId.contains(',')){
                system.debug('contact record type id is '  + contactRecordTypeId);
                contactRecordTypeForSoql = '\'' + contactRecordTypeId + '\'';
                contactRecordTypeForSoql = contactRecordTypeForSoql.replace(',', '\',\'');
            } else {
                contactRecordTypeForSoql = '\'' + contactRecordTypeId + '\'';
            }
            soql = soql + ' and recordtypeid IN (' + contactRecordTypeForSoql + ')';
        }
        if(searchString != null && searchString != '' && searchAccount !='' && searchAccount != null){
            soql = soql + ' ORDER BY LastViewedDate DESC';
        }
        //soql = soql + ' limit 25';
        System.debug(soql);
        con = new ApexPages.StandardSetController(Database.getQueryLocator(soql)); 
        con.setPageSize(size);
        noOfRecords = con.getResultSize();
        return (List<contact>)con.getRecords();
        //return database.query(soql); 
        
    }
}