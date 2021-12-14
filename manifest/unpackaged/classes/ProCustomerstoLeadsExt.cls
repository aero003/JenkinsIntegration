public class ProCustomerstoLeadsExt {
	public List<Contact> contact_list {get; set;} 
    public List<CheckBoxWrapper> selectedContList{get;set;}
    public Map<Id,CheckBoxWrapper> contactWrappersById {get;set;}
    public List<Lead> leadList = null;
    public List<Contact> updateContact = null;
    public String[] txtString {get; set;} 
    public String txt1 {get; set;}
    public String searchtxt {get; set;}
    public String qrystring {get; set;}
    public Boolean editMode {get; set;}
    
    public ProCustomerstoLeadsExt() {
        
         editMode = false;
        //email or account name parameters
        searchtxt = 'hospice,counseling,home,loan,mortgage,wellness,medic,clinic,thera,doctor,ology,lab,care,cure,pharma,vascular,patient,bio,anesthesia,psych,law,legal,gov,chiropractic,dental,Dentistry,family,recovery,tech,software,hardware,integration,telecommunications,ucaas,services,consulting,network,computer';
        txt1 = '%' +searchtxt.replace(',','%,%')+ '%';
        txtString = txt1.split(',');
        
        //contact_list  = [Select Id, FirstName,LastName,DID_Number__c, MailingStreet,MailingCity,MailingState,MailingCountry,Phone,Email,Customer_ID__c,CreatedById,CreatedBy.name, Account.Name,Account.RecordTypeId,Account.Brand__c,LastModifiedBy.name,CreatedDate from Contact where CreatedDate > 2020-12-16T00:00:00Z AND LastModifiedBy.name = 'DW ETL' AND Converted_to_Lead__c = false AND Account.RecordTypeId IN ('012600000009UrX','012600000009V7u','012600000009ZPL') AND MailingCountry = 'US' AND Status__c NOT IN ('inactive','I') AND (Email like: txtString OR Account.Name like: txtString)];
        qrystring = System.Label.proaccQrString;
        //qrystring = 'Select Id, FirstName,LastName,DID_Number__c,MailingStreet,MailingCity,MailingState,MailingCountry,Phone,Email,Customer_ID__c,CreatedById,CreatedBy.name, Account.Name,Account.RecordTypeId,Account.Brand__c, LastModifiedBy.name,CreatedDate from Contact where CreatedDate = TODAY AND LastModifiedBy.name = \'DW ETL\' AND Converted_to_Lead__c = false AND Account.Brand__c != \'eFax Corporate\' AND Account.RecordTypeId IN (\'012600000009UrX\',\'012600000009V7u\',\'012600000009ZPL\') AND MailingCountry = \'US\' AND Status__c NOT IN (\'inactive\',\'I\') AND (Email like: txtString OR Account.Name like: txtString )';
        contact_list = Database.query(qrystring);
        
        //contact_list  = [Select Id, FirstName,LastName,DID_Number__c,MailingStreet,MailingCity,MailingState,MailingCountry,Phone,Email,Customer_ID__c,CreatedById,CreatedBy.name, Account.Name,Account.RecordTypeId,Account.Brand__c, LastModifiedBy.name,CreatedDate from Contact where CreatedDate > 2020-12-16T00:00:00Z AND Converted_to_Lead__c = false AND Account.Brand__c != 'eFax Corporate' AND Account.RecordTypeId IN ('012600000009UrX','012600000009V7u','012600000009ZPL') AND MailingCountry = 'US' AND Status__c NOT IN ('inactive','I') AND (Email like: txtString OR Account.Name like: txtString)];
        System.debug('list size :  ' + UserInfo.getName() +contact_list.size());
        ////wrapperContList = new List<checkBoxWrapper>();
        contactWrappersById = new Map<Id,CheckBoxWrapper>();
		for(Contact con :contact_list){
        ////wrapperContList.add(new CheckBoxWrapper(false,con));
            contactWrappersById.put(con.Id,new CheckBoxWrapper(false,con));
        }
        
        System.debug('list size :  ' + UserInfo.getName() +contactWrappersById.size());
    }
    public void toggleEditMode() {
       
    editMode = !editMode;
}
    public void changeQry()
    {
         editMode = false;
        txt1 = '%' +searchtxt.replace(',','%,%')+ '%';
        txtString = txt1.split(',');
        ////qrystring = 'Select Id, FirstName,LastName,DID_Number__c,MailingStreet,MailingCity,MailingState,MailingCountry,Phone,Email,Customer_ID__c,CreatedById,CreatedBy.name, Account.Name,Account.RecordTypeId,Account.Brand__c, LastModifiedBy.name,CreatedDate from Contact where CreatedDate > 2020-12-16T00:00:00Z AND Converted_to_Lead__c = false AND Account.Brand__c != \'eFax Corporate\' AND Account.RecordTypeId IN (\'012600000009UrX\',\'012600000009V7u\',\'012600000009ZPL\') AND MailingCountry = \'US\' AND Status__c NOT IN (\'inactive\',\'I\') AND (Email like: txtString OR Account.Name like: txtString )';
        
        contact_list = Database.query(qrystring);
        System.debug('000 ::: '+contact_list.size());
        System.debug('list size :  ' + UserInfo.getName() +contact_list.size());
        ////wrapperContList = new List<checkBoxWrapper>();
        contactWrappersById = new Map<Id,CheckBoxWrapper>();
		for(Contact con :contact_list){
        ////wrapperContList.add(new CheckBoxWrapper(false,con));
            contactWrappersById.put(con.Id,new CheckBoxWrapper(false,con));
        }
        
        System.debug('list size :  ' + UserInfo.getName() +contactWrappersById.size());
    }
    
    public PageReference processSelected(){
        System.debug('list size :  ' + UserInfo.getName() +contactWrappersById.size());
        //selectedcontactWrappersById = new Map<Id,CheckBoxWrapper>();
        selectedContList = new List<CheckBoxWrapper>();
        leadList = new List<Lead>();
        Group leadQueue = [select Id from Group where Name = 'Reps for Prosumer Accounts' and Type = 'Queue'];

        updateContact = new List<Contact>();
        for (CheckBoxWrapper c : contactWrappersById.values()) {
            if (c.flag == true) {
                selectedContList.add(c); 
            System.debug('Selected list size :::  ' +selectedContList.size());
           }
           	 
        }
        
        if(selectedContList.size()>0)
        {
            System.debug('Selected record name :::  ' +selectedContList[0].contObj.Account.RecordTypeId);
            System.debug('Size:: '+selectedContList.size());
            for(Integer i = 0; i<selectedContList.size(); i++){
                Lead l = new Lead();
                Contact updCon = new Contact();
                if(selectedContList[i].contObj.RecordTypeId=='012600000009Uvy')
                {
                    l.RecordTypeId = '012600000009Wxy';                      
                }
                if(selectedContList[i].contObj.RecordTypeId=='012600000009Xx4')
                {
                    l.RecordTypeId = '012600000009Uon';                      
                }
                if(selectedContList[i].contObj.RecordTypeId=='012600000009ZPV')
                {
                    l.RecordTypeId = '012600000009ZPG';                      
                }
                if(selectedContList[i].contObj.FirstName!=null)
                {
                    l.FirstName = selectedContList[i].contObj.FirstName;
                System.debug(' l.FirstName:: '+ l.FirstName);
                }
                if(selectedContList[i].contObj.LastName!=null)
                {
                    l.LastName = selectedContList[i].contObj.LastName;
                     System.debug(' l.LastName:: '+ l.LastName);
                }
                if(selectedContList[i].contObj.Email!=null)
                {
                    l.Email = selectedContList[i].contObj.Email;
                     System.debug('l.Email :: '+l.Email );
                }
                if(selectedContList[i].contObj.Account.name!=null)
                {
                    l.Company = selectedContList[i].contObj.Account.name;
                    System.debug('l.Company:: '+l.Company);
                }
                if(selectedContList[i].contObj.Phone!=null)
                {
                    l.Phone = selectedContList[i].contObj.Phone;
                   System.debug('l.Phone:: '+l.Phone);
                }
                if(selectedContList[i].contObj.Customer_ID__c!=null)
                {
                    l.Customer_Key_CID__c = selectedContList[i].contObj.Customer_ID__c;
                     System.debug('l.Customer_Key_CID__c:: '+l.Customer_Key_CID__c);
                }
                if(selectedContList[i].contObj.MailingStreet!=null)
                {
                    l.Street = selectedContList[i].contObj.MailingStreet;
                    System.debug('l.Street:: '+l.Street);
                }
                if(selectedContList[i].contObj.MailingCity!=null)
                {
                    l.City = selectedContList[i].contObj.MailingCity;
                    System.debug('l.City:: '+l.City);
                }
                if(selectedContList[i].contObj.MailingState!=null)
                {
                    l.State = selectedContList[i].contObj.MailingState;
                    System.debug('l.State :: '+l.State );
                }
                if(selectedContList[i].contObj.MailingCountry!=null)
                {
                    l.Country = selectedContList[i].contObj.MailingCountry;
                    System.debug('l.Country :: '+l.Country );
                }   
                if(selectedContList[i].contObj.DID_Number__c!=null)
                {
                    l.Comments__c = 'DID : '+ selectedContList[i].contObj.DID_Number__c;
                    System.debug('DID :: '+l.Country );
                }  
                l.Status='Open';
                l.LeadSource='Prosumer Customer';
                l.OwnerId=leadQueue.Id;
                updCon.Id=selectedContList[i].contObj.Id;
                updCon.Converted_to_Lead__c = true;
                leadList.add(l);
				updateContact.add(updCon);
                //System.debug('leadListSize:: '+leadList.size());
            }
				
            System.debug('leadListSize:: '+leadList.size());
            insert leadList; 
            update updateContact;
        }
        
        return new PageReference('/apex/ProsumerCustomersToLeads');
    }
    public Integer SizeOfMap { get { return contactWrappersById.size(); } } 

}