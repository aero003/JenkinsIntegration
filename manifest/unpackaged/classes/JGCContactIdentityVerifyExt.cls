public without sharing class JGCContactIdentityVerifyExt {
    //declare all properties which are used in vf page.
    Public Contact thisContact{get;set;}
    public Boolean showError {get;set;}
    public Boolean showThankYou {get;set;}
    public Boolean showSubmit {get;set;}
    public Boolean expireLink {get;set;}
    //Public Date AcctCloseDate{get;set;}
    Public Date CntEndDate{get;set;}    //Contact_End_Date__c
    public string CntDescription{get;set;}
    public string CntName{get;set;}
    public string CntCompanyName{get;set;}
    public string CnteFaxNumber{get;set;}
    public string CntPhone{get;set;}
    public string CntEmailAddress{get;set;}
    Public Date CntBirthdate{get;set;}
    Public Boolean CntBusinessUser{get;set;}
    public string CntStreet{get;set;}
    public string CntCity{get;set;}
    public string CntState{get;set;}
    public string CntPostal{get;set;}
    public string CntCountry{get;set;}
    public string CntBirthLocation{get;set;}
    public string CntSignName{get;set;}
    public string CntNationality{get;set;}
    public string CntTaxCode{get;set;}
    public string CntVatNumber{get;set;}
    public Boolean CntProof_of_identity_submitted {get;set;}
    public string ErrorMessage{get;set;}
    public string UserType{get;set;}
    public string CntDocsSubmitted{get;set;}
    public string CntDocsUploadedBy{get;set;}
    public string CntPostCardDelivered{get;set;}
    public string uploadedBy{get;set;}
    public string docsSubmit{get;set;}
    public integer nooflinks{get;set;}
    public integer CntNoOfLinks{get;set;}
    public string dsp{get;set;}
    //Two types of customer. Handled using apex, business user is a checkbox field in contact.
    public List<selectOption> getUserTypeItems(){
        List<selectOption> opt = new List<SelectOption>();
        opt.add(new SelectOption('Must Select Option',System.Label.JGC_MustSelectOption));
        opt.add(new SelectOption('Consumer',System.Label.JGC_Consumer)); // Used Custom Labels
        opt.add(new SelectOption('Business',System.Label.JGC_Business)); // Used Custom Labels
        return opt;
    }
    
    
    public String ContactId;
    //attachment helper created to manage viewstate size.
    public Attachment thisAttachment {
        get {
            if (thisAttachmentHelper == null)
                thisAttachmentHelper = new Attachment();
            return thisAttachmentHelper;
        }
        set{
            thisAttachmentHelper = value;
        }
    }
    public Attachment documentAttachment {
        get {
            if (documentAttachmentHelper == null)
                documentAttachmentHelper = new Attachment();
            return documentAttachmentHelper;
        }
        set{
            documentAttachmentHelper = value;
        }
    }
    public Attachment extraDocumentAttachment {
        get {
            if (extraDocumentAttachmentHelper == null)
                extraDocumentAttachmentHelper = new Attachment();
            return extraDocumentAttachmentHelper;
        }
        set{
            extraDocumentAttachmentHelper = value;
        }
    }
    //added attachment as transient to control viewstate size.
    public transient Attachment thisAttachmentHelper;
    public transient Attachment documentAttachmentHelper;
    public transient Attachment extraDocumentAttachmentHelper;
    
    //Constructor fetches contact record data by calling webservice and assigns to all the properties declared on top of the page.
    Public JGCContactIdentityVerifyExt(ApexPages.StandardController controller){
        try{
            showSubmit = true;
            expireLink=false;
            ContactId = apexPages.currentPage().getParameters().get('id');
            if ( ContactId == null || ContactId == '' || ContactId == ' ' ){
                showError = true;
                showThankYou = false;
                thisContact = new Contact();
            } else {
                system.debug('page controller... calling get contact');
                this.thisContact = ContactUpdateWebService.getContactRecord(ContactId);
                system.debug('page controller... get contact called');
                system.debug(this.thisContact.Name);
                if(ApexPages.currentPage().getParameters().get('links')!=null){
                      nooflinks = Integer.valueOf(ApexPages.currentPage().getParameters().get('links'));
                }
                if(this.thisContact.No_of_links_sent__c!=null){
                      CntNoOfLinks =Integer.valueOf(this.thisContact.No_of_links_sent__c);
                }
                string nr='n';
                string nm='m';
                dsp = ApexPages.currentPage().getParameters().get('ds');
                uploadedBy = ApexPages.currentPage().getParameters().get('uplby');
                CntEndDate = this.thisContact.Contact_End_Date__c;
                CntDocsSubmitted = this.thisContact.Documents_Submitted__c;
                CntDocsUploadedBy = this.thisContact.Documents_Uploaded__c;
                CntPostCardDelivered = this.thisContact.Post_Card_Delivered__c;
                system.debug('link qs == '+nooflinks);
                system.debug('CntNoOfLinks == '+CntNoOfLinks);
                system.debug('AcctCloseDate == '+CntEndDate);
                system.debug('createdDate== '+this.thisContact.CreatedDate);
                system.debug('CntDocsSubmitted == '+CntDocsSubmitted);
                system.debug('CntDocsUploadedBy == '+CntDocsUploadedBy);
                system.debug('CntPostCardDelivered == '+CntPostCardDelivered);
                system.debug('uplby QS == '+uploadedBy);
                if(CntEndDate<Date.today() || (CntDocsSubmitted=='Y'&&CntDocsUploadedBy=='Customer'&&nooflinks<CntNoOfLinks) || (nooflinks!=CntNoOfLinks&&nooflinks<CntNoOfLinks)|| (CntDocsSubmitted=='Y'&&CntDocsUploadedBy=='Customer'))
                { expireLink = true;}//Expire Links
                system.debug('Expired == '+expireLink);
                CntDescription = this.thisContact.Description;
                CntName=this.thisContact.Name;
                CntCompanyName=this.thisContact.Company_Name__c;
                CntName=this.thisContact.Name;
                CntPhone = this.thisContact.Phone;
                CntEmailAddress = this.thisContact.Email;
                CntStreet = this.thisContact.MailingStreet;
                CntCity = this.thisContact.MailingCity;
                CntState = this.thisContact.MailingState;
                CntPostal = this.thisContact.MailingPostalCode;
                CnteFaxNumber = this.thisContact.DID_Number__c;
                CntBusinessUser = this.thisContact.Business_User__c;
                //business user is a special case.
                if(CntBusinessUser == True){
                    UserType = 'Business';
                } else {
                    UserType = 'Consumer';
                }
                
                
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,System.Label.GCC_Error+': ' + ex.getMessage()));
             System.debug('controller::: '+ApexPages.Severity.Error + ' $$$$$$ '+ ex.getMessage());
            showError = True;
        }
    }
    
    //on submit click.
    //assign all the properties to a contact object's variable,
    //along with attachment,
    //and call webservice.
    public PageReference submitContactForm(){
        system.debug('submit start...');
        try{
        
           // ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'An Error has occurred.'));    
       
            system.debug('submit start...');
            
            if (thisAttachmentHelper.Name != null){
                system.debug(' thisAttachment Helper is ... '+ thisAttachmentHelper.Name);
                system.debug('attachment not null');
                //calls webservice, saves contact data and attachment.
                if (ContactUpdateWebService.InsertAttachment(ContactId,thisAttachmentHelper) == true){
                    showThankYou = true;
                    showError = false;
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.GCC_An_Error_has_occurred+'.'));
                    //System.debug('Check Attachment::: '+ApexPages.Severity.Error);
                    showThankYou = false;
                    showError = true;
                }
            }
            
            if (documentAttachmentHelper.Name != null){
                system.debug(' documentAttachmentHelper  is ... '+ documentAttachmentHelper.Name);
                system.debug('attachment not null');
                //calls webservice, saves contact data and attachment.
                if ( ContactUpdateWebService.InsertAttachment(ContactId,documentAttachmentHelper) == true) {
                    showThankYou = true;
                    showError = false;
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.GCC_An_Error_has_occurred+'.'));
                    //System.debug('Check Attachment::: '+ApexPages.Severity.Error);
                    showThankYou = false;
                    showError = true;
                }
            }
           
            if (extraDocumentAttachmentHelper.Name != null){
                system.debug(' extraDocumentAttachmentHelper  is ... '+ extraDocumentAttachmentHelper.Name);
                system.debug('attachment not null');
                //calls webservice, saves contact data and attachment.
                if ( ContactUpdateWebService.InsertAttachment(ContactId,extraDocumentAttachmentHelper) == true) {
                    showThankYou = true;
                    showError = false;
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.GCC_An_Error_has_occurred+'.'));
                    //System.debug('Check Attachment::: '+ApexPages.Severity.Error);
                    showThankYou = false;
                    showError = true;
                }
            }
            
            if(showThankYou == true)
            {//Update Documents Submitted = Y and Documents Uploaded = Customer
                System.debug('set values');
                thisContact.Documents_Submitted__c = 'Y';                
                if(uploadedBy!='cs')
                {
                	thisContact.Documents_Uploaded__c = 'Customer';
                }
                if(uploadedBy=='cs')
                {
                    thisContact.Documents_Uploaded__c = 'Customer Service';
                }
                 
                if(ContactUpdateWebService.UpdateContact(ContactId,thisContact) == true)
                { 
                    System.debug('THANK YOUUUUU');
                    showThankYou = true;
                    showError = false;
                    showSubmit = false;
                    //return new PageReference('javascript:window.close()');
                }
            }
            
        }
        catch(exception ex){
            system.debug('extension catch');
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Error in saving records: ' + ex.getMessage()));
             System.debug('Submit::: '+ApexPages.Severity.Error);
            showError = True;
            showThankYou = false;
        }
        return null;
    }   
}