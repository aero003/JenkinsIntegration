public class SF_CAM_RESTService {
    
    public Account accountInfo = new Account();
    public Account getaccountInfo(){ return accountInfo; }
    
    public OpportunityContactRole contactAdmin = new OpportunityContactRole ();
    public OpportunityContactRole  getcontactAdmin(){ return contactAdmin; }
    
    public Contact contactAdm = new Contact ();
    public Contact  getcontactAdm(){ return contactAdm; }
    
    public OpportunityContactRole contactPayable = new OpportunityContactRole ();
    public OpportunityContactRole getcontactPayable(){ return contactPayable; }
    
    public Contact contactAccPayable = new Contact ();
    public Contact getcontactAccPayable(){ return contactAccPayable; }
    
    Public Opportunity opportunityInfo = new Opportunity();
   	public Opportunity getopportunityInfo(){ return opportunityInfo;}
    
    Public SBQQ__Quote__c paymentTerms = new SBQQ__Quote__c();
   	public SBQQ__Quote__c getpaymentTerms(){ return paymentTerms;}
    
    Public CamAPIDefaultValues__c defaultValues = new CamAPIDefaultValues__c();
    public CamAPIDefaultValues__c getdefaultValues(){ return defaultValues; }
    
    public Boolean isEdit {get;set;}
    public Boolean isEditableCheck {get;set;}
    public Boolean isPushtoCAMCheck {get;set;}
    public Boolean isCAMResendClick {get;set;}
    public String accessToken = '';
    public String opportunityID = '';
    public String contactID = '';
    public String corpAdminID = '';
    public String accPayableID = '';
    public String currentRecordTypeName = '';
    public String UserName {get; set;}
    
    public SF_CAM_RESTService(ApexPages.StandardController controller) {
        
       Opportunity record = (Opportunity) controller.getRecord();
        opportunityID = record.Id;
        isEdit = false;
        isEditableCheck = true;
        isPushtoCAMCheck = true;
        isCAMResendClick = false;
        UserName = UserInfo.getName();
        defaultValues = CamAPIDefaultValues__c.getvalues('Defaults');
        
       	String opportunityData = 'select id, Is_Pushed_to_CAM__c, cam_Payment_Term__c, SBQQ__PrimaryQuote__c,Application_ID__c,AccountId From Opportunity WHERE Id = \''+opportunityID+'\'';
        
        if(opportunityID != null){
                opportunityInfo  = Database.query(opportunityData);                 
        }
        
        String quotePaymentTerms = 'SELECT Id, SBQQ__Primary__c, cam_Payment_Term__c, SBQQ__Opportunity2__c FROM SBQQ__Quote__c where SBQQ__Primary__c = True AND SBQQ__Opportunity2__c = \''+opportunityID+'\'';
        
        if(opportunityInfo.Id != NULL){
        	String accountData = 'select id, Name, Industry,cam_product_code__c,Secure_Fax_Type__c,cam_offer_code__c,Application_Billing_Type__c,Market_Segment__c,Application_ID__c,Contract_Application__c,Expected_DID_Limit__c,Contact_Language__c, API_Faxing__c, Offer_Code__c,Billing_Channel__c, Annual_Revenue__c,Language__c, Tax_Number__c, (select id,Title,FirstName,LastName,Email,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone,Fax FROM Contacts) From Account WHERE Id =\''+ opportunityInfo.AccountId +'\'';
            if(accountData != null){
                accountInfo  = Database.query(accountData);                 
            }
            
            if(opportunityInfo.Is_Pushed_to_CAM__c == TRUE){
                isEditableCheck = false;
        		isPushtoCAMCheck = false;
                String msg = 'Application Id "'+accountInfo.Application_ID__c+'" is created Successfully, cannot be submitted again';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,msg));
            }
            if(opportunityInfo.cam_Payment_Term__c == NULL){
                isEditableCheck = true;
                isPushtoCAMCheck = false;
                String msg = 'Payment Term is Required';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msg));
            }
            if(accountInfo.Expected_DID_Limit__c == NULL){
                isEditableCheck = true;
                isPushtoCAMCheck = false;
                String msg = 'Expected Did Limit is Required';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msg));
            }
            if(accountInfo.Secure_Fax_Type__c == NULL){
                isEditableCheck = true;
                isPushtoCAMCheck = false;
                String msg = 'Secure option is Required';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msg));
            }
            if(accountInfo.Application_Billing_Type__c == NULL){
                isEditableCheck = true;
                isPushtoCAMCheck = false;
                String msg = 'Billing type is Required';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msg));
            }
            if(accountInfo.cam_product_code__c == NULL){
                isEditableCheck = true;
                isPushtoCAMCheck = false;
                String msg = 'Account Product code is not selected';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msg));
            }
            if(accountInfo.cam_offer_code__c == NULL){
                isEditableCheck = true;
                isPushtoCAMCheck = false;
                String msg = 'Offer Code is Required';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,msg));
            }
        }
        
        if(accountInfo.Contacts != Null){
            for(Contact con : accountInfo.Contacts){
            	contactID = con.id;
        	} 
        }
        
        Account accRecordType = [select id, RecordTypeId, RecordType.DeveloperName from Account where id=: opportunityInfo.AccountId];
        system.debug('accRecordType'+accRecordType.RecordType.DeveloperName);
        currentRecordTypeName = accRecordType.RecordType.DeveloperName;
        if(opportunityInfo.SBQQ__PrimaryQuote__c == NULL && currentRecordTypeName == 'Consensus_Account'){
        	try{
            
           		if(quotePaymentTerms != Null){
               		paymentTerms  = Database.query(quotePaymentTerms);
           		}
            
        	}catch(exception e){
                isEditableCheck = false;
        		isPushtoCAMCheck = false;
              	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'CAM Application cannot be submitted without primary quote in the opportunity'));
        	}
        }
        
        if(opportunityID != Null){
            String ErrMsg = '';
             try{
            	String corpAdminName = 'Corporate Admin';
                String corporateData =  'select id, Role, Contact.Id, opportunityId FROM OpportunityContactRole Where Role = \''+ corpAdminName +'\' AND opportunityId =\''+ opportunityID +'\'';
            	contactAdmin  = Database.query(corporateData);  
            	system.debug('contactAdmin----'+contactAdmin);		
                 	if(contactAdmin != Null){
                        
                        corpAdminID = contactAdmin.ContactId;
                        String corpAdminData = 'select id,Title,Is_Corporate_Admin__c,FirstName,LastName,Email,MailingStreet,MailingStreet2__c,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone,Fax FROM Contact Where Id =\''+ contactAdmin.ContactId+'\'';
                		contactAdm  = Database.query(corpAdminData);  
                        
                        if(contactAdm.FirstName == Null || contactAdm.LastName == NULL || contactAdm.Email == NULL){
                     			ErrMsg = 'First Name are Missing';
                     			isEditableCheck = true;
                				isPushtoCAMCheck = false;
                     			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrMsg));
                 		}
                 }
			}
            catch(exception e){
                	isEditableCheck = false;
        			isPushtoCAMCheck = false;
                	ErrMsg = 'No Corporate admin contact role for this opportunity';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrMsg));
          }
            
           try{
               
				String accPayableName = 'Account Payable';  
                String payableData =  'select id, Role, Contact.Id, opportunityId FROM OpportunityContactRole Where Role = \''+ accPayableName +'\' AND opportunityId =\''+ opportunityID +'\'';
            	contactPayable  = Database.query(payableData);  
				system.debug('contactPayable----'+contactPayable);				
           
                    if(contactPayable != Null){	
                        accPayableID  = contactPayable.ContactId;
                        String corpAdminData = 'select id,Title,Is_Account_Payable__c,FirstName,LastName,Email,MailingStreet,MailingStreet2__c,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone,Fax FROM Contact Where Id =\''+ contactPayable.ContactId+'\'';
                		contactAccPayable  = Database.query(corpAdminData);     		
      				}
               		if(contactAccPayable.FirstName == Null || contactAccPayable.LastName == NULL || contactAccPayable.Email == NULL){
                     			ErrMsg = 'First Name are Missing';
                     			isEditableCheck = true;
                				isPushtoCAMCheck = false;
                     			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ErrMsg));
                 		}
     }
               
            catch(exception e){
                isEditableCheck = false;
        		isPushtoCAMCheck = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Account payable contact role for this opportunity'));
        	} 
        }
    }
    
    Public List<Selectoption> getselectedIndustry(){
        List<Selectoption> industryValue = new List<selectoption>();
            Schema.DescribeFieldResult F = Account.Industry.getDescribe();    
			List<Schema.PicklistEntry> P = F.getPicklistValues();
        	if(accountInfo.Industry == Null){
            		industryValue.add(new selectoption('','--None--'));
        	}
            for( Schema.PicklistEntry li : P){
          		industryValue.add(new selectoption(li.getLabel(),li.getValue()));
            }
        return industryValue;   
    }
    
    Public List<Selectoption> getselectedOfferCode(){
        List<Selectoption> offerCodeValue = new List<selectoption>();
            Schema.DescribeFieldResult F = Account.cam_offer_code__c.getDescribe();    
			List<Schema.PicklistEntry> P = F.getPicklistValues();
        	if(accountInfo.cam_offer_code__c == Null){
            		offerCodeValue.add(new selectoption('','--None--'));
        	}
            for( Schema.PicklistEntry li : P){
                if(li.getLabel() != 'Consensus' && currentRecordTypeName != 'Consensus_Account'){
                    offerCodeValue.add(new selectoption(li.getLabel(),li.getValue()));
                }else if(li.getLabel() == 'Consensus' && currentRecordTypeName == 'Consensus_Account'){
                    offerCodeValue.add(new selectoption(li.getLabel(),li.getValue()));
                }
            }
        return offerCodeValue;   
    }
	
    Public List<Selectoption> getSelectedSecure(){
        List<Selectoption> secureValue = new List<selectoption>();
            Schema.DescribeFieldResult F = Account.Secure_Fax_Type__c.getDescribe();    
			List<Schema.PicklistEntry> P = F.getPicklistValues();
        	if(accountInfo.Secure_Fax_Type__c == Null){
            		secureValue.add(new selectoption('','--None--'));
        	}
            for( Schema.PicklistEntry li : P){
                if(currentRecordTypeName != 'Consensus_Account'){
                    secureValue.add(new selectoption(li.getLabel(),li.getValue()));
                }else if(li.getLabel() == 'ENABLED' && currentRecordTypeName == 'Consensus_Account'){
                    secureValue.add(new selectoption(li.getLabel(),li.getValue()));
                }
            }
        return secureValue;   
    }
    
    Public List<Selectoption> getselectedPaymentTerms(){
        List<Selectoption> paymentTermValue = new List<selectoption>();
        	Schema.DescribeFieldResult F = Opportunity.cam_Payment_Term__c.getDescribe();    
			List<Schema.PicklistEntry> P = F.getPicklistValues();
        	if(opportunityInfo.cam_Payment_Term__c == Null){
            	paymentTermValue.add(new selectoption('','-None-'));
        	}
            for( Schema.PicklistEntry li : P){
          		paymentTermValue.add(new selectoption(li.getLabel(),li.getValue()));
            }
          return paymentTermValue;   
    }
    
    Public List<Selectoption> getselectedBillingType(){
        List<Selectoption> billingTypeValue = new List<selectoption>();
        	Schema.DescribeFieldResult F = Account.Application_Billing_Type__c.getDescribe();    
			List<Schema.PicklistEntry> P = F.getPicklistValues();
        	if(accountInfo.Application_Billing_Type__c == Null){
            	billingTypeValue.add(new selectoption('','-None-'));
        	}
            for( Schema.PicklistEntry li : P){
          		billingTypeValue.add(new selectoption(li.getLabel(),li.getValue()));
            }
          return billingTypeValue;   
    }
    
    Public List<Selectoption> getselectedMarketSegment(){
        List<Selectoption> marketSegmentValue = new List<selectoption>();
        	Schema.DescribeFieldResult F = Account.Market_Segment__c.getDescribe();    
			List<Schema.PicklistEntry> P = F.getPicklistValues();
        	if(accountInfo.Market_Segment__c == Null){
            	marketSegmentValue.add(new selectoption('','-None-'));
        	}
            for( Schema.PicklistEntry li : P){
          		marketSegmentValue.add(new selectoption(li.getLabel(),li.getValue()));
            }
          return marketSegmentValue;   
    }
    
    Public List<Selectoption> getselectedLanguage(){
        List<Selectoption> languageValue = new List<selectoption>();
        	Schema.DescribeFieldResult F = Account.Contact_Language__c.getDescribe();    
			List<Schema.PicklistEntry> P = F.getPicklistValues();
        	if(accountInfo.Contact_Language__c == Null){
            	languageValue.add(new selectoption('','-None-'));
        	}
            for( Schema.PicklistEntry li : P){
          		languageValue.add(new selectoption(li.getLabel(),li.getValue()));
            }
          return languageValue;   
    }
    
    public pageReference goBack() { 
        Pagereference pr = new PageReference('/'+opportunityID);
        return pr;
    }
    
    public void editRecord(){
        if(isEdit != True){
            isEdit = true;
        }
    }
    
    public void cancel(){
        if(isEdit != false){
            isEdit = false;
        }
    }
    
    public void saveRecord() {
        
        isEdit = false;
        if(accountInfo.Id != Null){
            upsert accountInfo;
        }
        
        Boolean validationCheckContactPhn = true;
        Boolean validationCheckContactFax = true;
        String phoneNum = contactAdm.Phone;
        String faxNum = contactAdm.Fax;
        
        system.debug('phoneNum >> '+phoneNum);
        String contactAdmCheckPhone = '';
        String contactAdmCheckFax = '';
        if((phoneNum != NULL && phoneNum != '')){
             contactAdmCheckPhone = phoneNum.replaceAll('\\D', '');
            	if(contactAdmCheckPhone.length() != 10) {
            		validationCheckContactPhn = true;
        		}else{
            		validationCheckContactPhn = false;
        		}
        	}
        else{
            validationCheckContactPhn = false;
        } 
        
        if(faxNum != NULL && faxNum != ''){
             contactAdmCheckFax = faxNum.replaceAll('\\D', '');
            	if(contactAdmCheckFax.length() != 10) {
            		validationCheckContactFax = true;
        		}else{
            		validationCheckContactFax = false;
        		}
        	}
        else{
            validationCheckContactFax = false;
        } 
        
        if(validationCheckContactPhn == false && validationCheckContactFax == false && contactAdm.Id != Null){ 
            try{
              Update contactAdm;
            }
        	catch(Exception exe){
               ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.Error,exe.getMessage());
        	   ApexPages.addMessage(msg2);
        	}
        }
        else{
            isEdit = true;
            ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.Error,'Corporate Admin: Phone/Fax number is incorrect');
        	ApexPages.addMessage(msg1);
        }
        	
        	Boolean validationCheckPhone = true;
        	Boolean validationCheckFax = true;
        	String phoneAccPayable = contactAccPayable.Phone;
        	String faxAccPayable = contactAccPayable.Fax;
            String accPayPhone = '';
        	String accPayFax = '';
            if(phoneAccPayable != NULL && phoneAccPayable != '' ){
                accPayPhone = phoneAccPayable.replaceAll('\\D', '');
                if(accPayPhone.length() != 10) { 
                    validationCheckPhone = true;
                }else{
                    validationCheckPhone = false;
                } 
           	}else{
                validationCheckPhone = false;
            } 
        
        	if(faxAccPayable != NULL && faxAccPayable != ''){
                accPayFax = faxAccPayable.replaceAll('\\D', '');
                 if(accPayFax.length() != 10) { 
                    validationCheckFax = true;
                }else{
                    validationCheckFax = false;
                } 
             }  
        	else{
                validationCheckFax = false;
            }  
        
        if(validationCheckPhone == false && validationCheckFax == false && contactAccPayable.Id != NULL){ // 
            try{
                 Update contactAccPayable;
            }
        	catch(Exception exe){
               ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.Error,exe.getMessage());
        	   ApexPages.addMessage(msg2);
        	}
        }else{
                isEdit = true;
            	ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.Error,'Accounts Payable: Phone/Fax number is incorrect');
            	ApexPages.addMessage(msg2);
        }
        
        if(opportunityInfo.id != NULL){
            Update opportunityInfo;
        }
        
        try{
            if(accountInfo.Id != NULL){
            	Update accountInfo;
        	}
		}catch(Exception exe){
               ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.Error,exe.getMessage());
        	   ApexPages.addMessage(msg2);
        }
        
    }
    
    public void pushToCAM() {
        isEdit = false;
        CAMApiCallOut(opportunityID,defaultValues,corpAdminID,accPayableID,isEdit,isEditableCheck,isPushtoCAMCheck,isCAMResendClick); 
    }
    
    Public Static String CAMApiCallOut(Id opportunityID,CamAPIDefaultValues__c defaultValues,Id corpAdminID,Id accPayableID, boolean isEdit,boolean isEditableCheck,boolean isPushtoCAMCheck, boolean isCAMResendClick){
        Map<String, String> headerDetails = new Map<String, String>();
        Httprequest req = new HttpRequest();
        String httpMethod;
        String endPoint;
        String contentType;
        String application;
        String Access_Token;
        String grant_type;
        String client_id;
        String client_secret;
        
        List<Login_Credential__c> credentialList =[SELECT id, grant_type__c,client_id__c,client_secret__c,Http_Method__c,End_Point__c,Content_Type__c,applicationJson__c from Login_Credential__c];
        
        for(Login_Credential__c cred:credentialList){
            httpMethod = String.valueOf(cred.Http_Method__c);
            endPoint = String.valueOf(cred.End_Point__c);
            contentType = String.valueOf(cred.Content_Type__c);
            application = String.valueOf(cred.applicationJson__c);
            grant_type = String.valueOf(cred.grant_type__c);
            client_id = String.valueOf(cred.client_id__c);
            client_secret = String.valueOf(cred.client_secret__c);
        }
      
        headerDetails.put(contentType,application);
        String jsonData;
        String userDetails = String.valueOf(UserInfo.getUserEmail());
        system.debug('userDetails-->'+userDetails);
        String[] j2UserName = userDetails.split('@');
        System.debug('j2UserName--> '+ j2UserName[0]);
        
        jsonData = JSON.serialize(
        new Map<String, String> {
            'grant_type' => String.valueOf(grant_type),
            'code' => String.valueOf(j2UserName[0]),
            'client_id' => String.valueOf(client_id),
            'client_secret' => String.valueOf(client_secret)
         });
 
        try{
            if(Test.isRunningTest()){
                CreditApplication_CallOut('Access_Token',opportunityID,defaultValues,corpAdminID,accPayableID,isEdit,isEditableCheck,isPushtoCAMCheck,isCAMResendClick);
            }
            
            system.debug('endpoint---'+endpoint);
            system.debug('httpMethod---'+httpMethod);
            system.debug('headerDetails---'+headerDetails);
            system.debug('jsonData---'+jsonData);
           	HttpResponse response = APIUtility.makeHTTPRequest(endpoint, httpMethod, headerDetails, jsonData);
            system.debug('response.getBody()'+response.getBody());
            
            JSONParser parser = JSON.createParser(response.getBody());
			while (parser.nextToken() != null) {
			if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
            	parser.nextToken();
				Access_Token = parser.getText();
            	Access_Token = Access_Token;
			}
			}
            system.debug('Access_Token----'+Access_Token);
			
            
           List<Opportunity> currentOpportunityRec =[SELECT id,cam_access_tocken__c From Opportunity WHERE Id =: opportunityID];
            
                                                      
           if(Access_Token != NULL){
               for(Opportunity access: currentOpportunityRec){
                   access.cam_access_tocken__c = Access_Token;
               }
          CreditApplication_CallOut(Access_Token,opportunityID,defaultValues,corpAdminID,accPayableID,isEdit,isEditableCheck,isPushtoCAMCheck,isCAMResendClick);
          }
           update currentOpportunityRec;
           return response.getBody();
        }
        
        catch(Exception exe){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, exe.getMessage());
        	ApexPages.addMessage(msg);
        	return null;
        }
    }
    
    public void resend(){
        String getAccessTocken =[SELECT id,cam_access_tocken__c From Opportunity WHERE Id =: opportunityID].cam_access_tocken__c;
        
        isCAMResendClick = true;
        String errMsg = '';
        try{
            if(getAccessTocken == null){
                errMsg = 'Access-token is expired for this Application, Cannot Resend from salesforce';
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, errMsg);
        		ApexPages.addMessage(msg);
            }else{
                CreditApplication_CallOut(getAccessTocken,opportunityID,defaultValues,corpAdminID,accPayableID,isEdit,isEditableCheck,isPushtoCAMCheck,isCAMResendClick);
            }
        }catch(exception exe){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, exe.getMessage());
        	ApexPages.addMessage(msg);
        }
    }
    
    Public Static String CreditApplication_CallOut(String access_token, Id opportunityID,CamAPIDefaultValues__c defaultValues,Id corpAdminID, Id accPayableID,boolean isEdit,boolean isEditableCheck,boolean isPushtoCAMCheck,boolean isCAMResendClick){
        system.debug('access_token'+access_token);
        system.debug('opportunityID'+opportunityID);
        system.debug('corpAdminID'+corpAdminID);
        system.debug('accPayableID'+accPayableID);
        system.debug('isEdit'+isEdit);
        Map<String, String> headerDetails = new Map<String, String>();
        JSONGenerator jsonData = JSON.createGenerator(true);
        Httprequest req = new HttpRequest();
        String httpMethod;
        String endPoint;
        String contentType;
        String application;
        String athorization;
        String Bearer;
        
        List<Opportunity> opportunityList = [select id, AccountId,cam_Payment_Term__c,Application_ID__c,Is_Pushed_to_CAM__c From Opportunity WHERE Id= :opportunityID];
        List<credit_application__c> credit =[SELECT id, httpMethod__c,End_Point__c,Put_Method__c,send_email__c,Content_Type__c,Application_Json__c,Authorization__c,Bearer__c from credit_application__c];
        
        for(credit_application__c cred:credit){
            
            if(isCAMResendClick == true){
                
                String resendEndPoint = String.valueOf(cred.End_Point__c);
                string application_ID = opportunityList[0].Application_ID__c;
              	httpMethod = String.valueOf(cred.Put_Method__c);
                endPoint = resendEndPoint+'/'+application_ID+'/'+cred.send_email__c;
                
            }else{
                
            	httpMethod = String.valueOf(cred.httpMethod__c);
                endPoint = String.valueOf(cred.End_Point__c);
                
            }
            
            contentType = String.valueOf(cred.Content_Type__c);
            application = String.valueOf(cred.Application_Json__c);
            athorization = String.valueOf(cred.Authorization__c);
            Bearer = String.valueOf(cred.Bearer__c);
        }
        
        headerDetails.put(contentType,application);
        headerDetails.put(athorization, Bearer+' '+ access_token); //accTocken
        String paymentTerms;
        if(opportunityList.size() != 0){
                paymentTerms = opportunityList[0].cam_Payment_Term__c;
        }
        system.debug('paymentTerms-->>'+paymentTerms);
		if(opportunityList.size() > 0){
            system.debug('opportunityList 22>'+opportunityList);
       		List<Account> accountData1 = new List<Account>([select id,Name,cam_product_code__c,cam_offer_code__c,Secure_Fax_Type__c,Application_Billing_Type__c,Market_Segment__c,Industry,Tax_Number__c,Application_ID__c,Contract_Application__c,Expected_DID_Limit__c,Contact_Language__c,Language_Code__c
                 					From Account 
                 				WHERE Id =:opportunityList[0].AccountId]);
            system.debug('accountData1 22>'+accountData1);
            //cam_marketplace_code__c,cam_collection_method__c,cam_credit_limit__c,cam_secure_fax_type__c,cam_did_limit__c,cam_oem__c,
            String didLimitValue;
            String taxNumber;
            String secureType = '';
            if(accountData1[0].Expected_DID_Limit__c != NULL){
                didLimitValue = accountData1[0].Expected_DID_Limit__c;
            }
            if(accountData1[0].Tax_Number__c != NULL){
                taxNumber = accountData1[0].Tax_Number__c;
            }
            List<Contact> corporateAdminList = new List<Contact>([select id,Title,Is_Corporate_Admin__c,Is_Account_Payable__c,FirstName,LastName,Email,MailingStreet,MailingStreet2__c,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone,Fax FROM Contact where Id =: corpAdminID]);// 
            List<Contact> AcctPayableList = new List<Contact>([select id,Title,Is_Corporate_Admin__c,Is_Account_Payable__c,FirstName,LastName,Email,MailingStreet,MailingStreet2__c,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone,Fax FROM Contact  where Id =: accPayableID]);                                                 
            system.debug('corporateAdminList 22>'+corporateAdminList);
            system.debug('AcctPayableList 22>'+AcctPayableList);
            for(Account acc: accountData1){  
                jsonData.writeStartObject();
                jsonData.writeFieldName('info');
        			jsonData.writeStartObject();
                	system.debug('acc>>'+acc);
                 	system.debug('corporateAdminList>>'+corporateAdminList);
                	system.debug('AcctPayableList>>'+AcctPayableList);
                	if(acc.Market_Segment__c == 'Mid Market'){
                    	acc.Market_Segment__c = 'MIDMARKET';
                	}
                	if(acc.Market_Segment__c == 'Enterprise'){
                    	acc.Market_Segment__c = 'ENTERPRISE';
                	}
                	if(acc.Contact_Language__c == 'English'){
                    	acc.Contact_Language__c = 'en';
                	}
                
                	if(acc.Secure_Fax_Type__c == 'ENABLED'){
                    	secureType = defaultValues.secure_fax_Consensus__c;
                	}
                	
                	if(acc.Secure_Fax_Type__c == 'DISABLED'){
                    	secureType = defaultValues.secure_fax_Efax__c;
                	}
                    /*if(acc.cam_collection_method__c == NULL ){
                       acc.cam_collection_method__c = 'N';
                    }
                    if(acc.cam_marketplace_code__c == NULL ){
                       acc.cam_marketplace_code__c = 'NA';
                    }*/
                	if(paymentTerms == NULL){
                    	paymentTerms = '';
                	}
                	if(acc.Industry == NULL ){
                            acc.Industry = '';
                    }
                	if(acc.Tax_Number__c == NULL ){
                            acc.Tax_Number__c = '';
                    }
                    if(acc.Expected_DID_Limit__c == NULL ){
                       acc.Expected_DID_Limit__c = '';
                    }
                	string collectionMethodValue = '';
                	if(acc.Application_Billing_Type__c == 'Invoice'){
                    	collectionMethodValue = 'N';
                    }else{
                        collectionMethodValue = 'C';       
                    }
                
                	jsonData.writeStringField('product_code', String.valueOf(acc.cam_product_code__c));
                	jsonData.writeStringField('company_name', String.valueOf(acc.Name));
                	jsonData.writeStringField('industry_category', String.valueOf(acc.Industry));
                	jsonData.writeStringField('market_segment', String.valueOf(acc.Market_Segment__c));
                	jsonData.writeStringField('payment_terms', String.valueOf(paymentTerms));
                	jsonData.writeStringField('collection_method', String.valueOf(collectionMethodValue));//String.valueOf(acc.cam_collection_method__c));
                	
                	system.debug('acc.Tax_Number__c'+acc.Tax_Number__c);
                	system.debug('acc.Expected_DID_Limit__c'+acc.Expected_DID_Limit__c);
                	system.debug('acc.Contact_Language__c'+acc.Contact_Language__c);
                	system.debug('acc.Contract_Application__c'+acc.Contract_Application__c);
                
                	jsonData.writeStringField('tax_id', String.valueOf(acc.Tax_Number__c));
                	jsonData.writeStringField('expected_did_limit', String.valueOf(acc.Expected_DID_Limit__c));
                    jsonData.writeStringField('contact_language', String.valueOf(acc.Contact_Language__c));
                    jsonData.writeStringField('contract_application', String.valueOf(acc.Contract_Application__c));
                	
        			
                	jsonData.writeStringField('marketplace_code', String.valueOf(defaultValues.marketplace_code__c));//String.valueOf(acc.cam_marketplace_code__c));
                	jsonData.writeStringField('marketplace_account_id', '');
                	jsonData.writeStringField('marketplace_product_id', '');
        			jsonData.writeEndObject(); 
                
                    jsonData.writeFieldName('contact');
        				jsonData.writeStartObject();
        				jsonData.writeStringField('firstname', String.valueOf(corporateAdminList[0].FirstName));
        				jsonData.writeStringField('lastname', String.valueOf(corporateAdminList[0].LastName));
                		jsonData.writeStringField('email_address', String.valueOf(corporateAdminList[0].Email));
                		
                		if(corporateAdminList[0].MailingStreet == NULL ){
    						corporateAdminList[0].MailingStreet = '';
                        }
                        if(corporateAdminList[0].MailingCity == NULL ){
                            corporateAdminList[0].MailingCity = '';
                        }
                        if(corporateAdminList[0].MailingState == NULL ){
                            corporateAdminList[0].MailingState = '';
                        }
                        if(corporateAdminList[0].MailingPostalCode == NULL ){
                            corporateAdminList[0].MailingPostalCode = '';
                        }
                        if(corporateAdminList[0].MailingCountry == NULL ){
                            corporateAdminList[0].MailingCountry = '';
                        }
                        if(corporateAdminList[0].Phone == NULL ){
                            corporateAdminList[0].Phone = '';
                        }
                        if(corporateAdminList[0].Title == NULL ){
                            corporateAdminList[0].Title = '';
                        }
                        if(corporateAdminList[0].Fax == NULL ){
                            corporateAdminList[0].Fax = '';
                        }
                		if(corporateAdminList[0].MailingStreet2__c == NULL ){
                            corporateAdminList[0].MailingStreet2__c = '';
                        }
                
        				jsonData.writeStringField('address', String.valueOf(corporateAdminList[0].MailingStreet));
                		jsonData.writeStringField('address2', String.valueOf(corporateAdminList[0].MailingStreet2__c));
        				jsonData.writeStringField('city', String.valueOf(corporateAdminList[0].MailingCity));
        				jsonData.writeStringField('state_province', String.valueOf(corporateAdminList[0].MailingState));
        				jsonData.writeStringField('zip_postal_code', String.valueOf(corporateAdminList[0].MailingPostalCode));
        				jsonData.writeStringField('country', String.valueOf(corporateAdminList[0].MailingCountry));
        				jsonData.writeStringField('work_phone', String.valueOf(corporateAdminList[0].Phone));
        				jsonData.writeStringField('fax_number', String.valueOf(corporateAdminList[0].Fax));
        				jsonData.writeStringField('title', String.valueOf(corporateAdminList[0].Title));
                		system.debug('title1>>'+corporateAdminList[0].Title);
        				jsonData.writeEndObject(); 
                
        			jsonData.writeFieldName('accounts_payable');
        				jsonData.writeStartObject();
        				jsonData.writeStringField('firstname', String.valueOf(AcctPayableList[0].FirstName));
        				jsonData.writeStringField('lastname', String.valueOf(AcctPayableList[0].LastName));
                		jsonData.writeStringField('email_address', String.valueOf(AcctPayableList[0].Email));
                		
                		if(AcctPayableList[0].MailingStreet == NULL ){
                            AcctPayableList[0].MailingStreet = '';
                        }
                        if(AcctPayableList[0].MailingCity == NULL ){
                            AcctPayableList[0].MailingCity = '';
                        }
                        if(AcctPayableList[0].MailingState == NULL ){
                            AcctPayableList[0].MailingState = '';
                        }
                        if(AcctPayableList[0].MailingPostalCode == NULL ){
                            AcctPayableList[0].MailingPostalCode = '';
                        }
                        if(AcctPayableList[0].MailingCountry == NULL ){
                            AcctPayableList[0].MailingCountry = '';
                        }
                        if(AcctPayableList[0].Phone == NULL ){
                            AcctPayableList[0].Phone = '';
                        }
                        if(AcctPayableList[0].Title == NULL ){
                            AcctPayableList[0].Title = '';
                        }
                        if(AcctPayableList[0].Fax == NULL ){
                            AcctPayableList[0].Fax = '';
                        }
                        if(AcctPayableList[0].MailingStreet2__c == NULL ){
                            AcctPayableList[0].MailingStreet2__c = '';
                        }
                
        				jsonData.writeStringField('address', String.valueOf(AcctPayableList[0].MailingStreet));
                		jsonData.writeStringField('address2', String.valueOf(AcctPayableList[0].MailingStreet2__c));
        				jsonData.writeStringField('city', String.valueOf(AcctPayableList[0].MailingCity));
        				jsonData.writeStringField('state_province', String.valueOf(AcctPayableList[0].MailingState));
        				jsonData.writeStringField('zip_postal_code', String.valueOf(AcctPayableList[0].MailingPostalCode));
        				jsonData.writeStringField('country', String.valueOf(AcctPayableList[0].MailingCountry));
                		jsonData.writeStringField('work_phone', String.valueOf(AcctPayableList[0].Phone));
        				jsonData.writeStringField('fax_number', String.valueOf(AcctPayableList[0].Fax));
                		jsonData.writeStringField('title', String.valueOf(AcctPayableList[0].Title));
                		system.debug('title2>>'+AcctPayableList[0].Title);
                
        				jsonData.writeEndObject(); 
                
                	jsonData.writeFieldName('application_review');
                		jsonData.writeStartObject();
        				if(acc.cam_offer_code__c == NULL ){
                            acc.cam_offer_code__c = 'Consensus';
                        }
                        /*if(acc.cam_did_limit__c == NULL ){
                            acc.cam_did_limit__c = '10';
                        }
                        if(acc.cam_credit_limit__c == NULL ){
                            acc.cam_credit_limit__c = '1000000';
                        }
                        if(acc.cam_secure_fax_type__c == NULL ){
                            acc.cam_secure_fax_type__c = 'EMS';
                        }
                        if(acc.cam_oem__c == NULL ){
                            acc.cam_oem__c = '500';
                        }*/
        				jsonData.writeStringField('sales_rep', String.valueOf(UserInfo.getName()));
        				jsonData.writeStringField('offer_code', String.valueOf(acc.cam_offer_code__c));
        				jsonData.writeStringField('did_limit', String.valueOf(defaultValues.did_limit__c));//String.valueOf(acc.cam_did_limit__c));
        				jsonData.writeStringField('credit_limit', String.valueOf(defaultValues.credit_limit__c));//String.valueOf(acc.cam_credit_limit__c));
        				jsonData.writeStringField('secure_fax_type', String.valueOf(secureType));//String.valueOf(acc.cam_secure_fax_type__c));
        				jsonData.writeStringField('oem', String.valueOf(defaultValues.oem__c));//String.valueOf(acc.cam_oem__c));
                		jsonData.writeEndObject();
				jsonData.writeEndObject();                  
      			}
            
        try{
            isEdit = false;
            system.debug('JSON Data -->> '+jsonData.getAsString());
            system.debug('endpoint11>>'+endpoint);
            system.debug('httpMethod11>>'+httpMethod);
            HttpResponse response = APIUtility.makeHTTPRequest(endpoint, httpMethod, headerDetails, jsonData.getAsString());
            system.debug('response>>'+response);
            CreditApplicationResult receivedValue = CreditApplicationResult.parse(response.getBody()); 
            system.debug('receivedValue>>'+receivedValue);
            
            if(receivedValue.result.data == 'Send Email has been completed successfully.'){
                system.debug('receivedValue.result.data>>'+receivedValue.result.data);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Send Email has been completed successfully.'));
            }
            
            else if(receivedValue.result.data != 'Send Email has been completed successfully.'){
                accountData1[0].Application_ID__c = receivedValue.result.data;
                opportunityList[0].Is_Pushed_to_CAM__c = true;
                accountData1[0].Expected_DID_Limit__c =didLimitValue;
                accountData1[0].Tax_Number__c = taxNumber; 
                if(accountData1[0].Market_Segment__c == 'MIDMARKET'){
                   accountData1[0].Market_Segment__c = 'Mid Market';
                }
               if(accountData1[0].Market_Segment__c == 'ENTERPRISE'){
                   accountData1[0].Market_Segment__c = 'Enterprise';
              	}
                if(accountData1[0].Contact_Language__c == 'en'){
                   accountData1[0].Contact_Language__c = 'English';
              	}
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Recevied Application Id Successfully'));
                isEditableCheck = false;
				isPushtoCAMCheck = false;
               }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No Application ID received from response'));
            }
            
            if(isCAMResendClick == false && accountData1.size() > 0){
                update accountData1;
            }
            
            
            if(opportunityList.size() > 0){
                isEditableCheck = true;
				isPushtoCAMCheck = true;
                update opportunityList;
            }
          }
            catch(Exception exe){
            system.debug('creditApplication URL Error '+exe.getLineNumber());
            isEdit = true;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, exe.getMessage());
        	ApexPages.addMessage(msg);
        	return null;
        }
       }
       return '';
    }  
    
    public void resendOld(){
        String getAccessTocken =[SELECT id,cam_access_tocken__c From Opportunity WHERE Id =: opportunityID].cam_access_tocken__c;
        
        isCAMResendClick = true;
        String errMsg = '';
            if(getAccessTocken == null ||test.isRunningTest()){
                errMsg = 'Access-token is unavailable for this Application, Cannot Resend from salesforce';
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, errMsg);
            ApexPages.addMessage(msg);
            }
    }
    
    public void resendNew(){
        String getAccessTocken =[SELECT id,cam_access_tocken__c From Opportunity WHERE Id =: opportunityID].cam_access_tocken__c;
        
        isCAMResendClick = true;
        String errMsg = '';
            if(getAccessTocken == null ||test.isRunningTest()){
                errMsg = 'Access-token is unavailable for this Application, Cannot Resend from salesforce';
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, errMsg);
            ApexPages.addMessage(msg);
            }
    }
}