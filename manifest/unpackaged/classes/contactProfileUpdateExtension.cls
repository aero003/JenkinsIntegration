public without sharing class contactProfileUpdateExtension {
    //declare all properties which are used in vf page.
    Public Contact thisContact{get;set;}
    public Boolean showError {get;set;}
    public Boolean showThankYou {get;set;}
    public string CntDescription{get;set;}
    public string CntPhone{get;set;}
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
    
    //Two types of customer. Handled using apex, business user is a checkbox field in contact.
    public List<selectOption> getUserTypeItems(){
        List<selectOption> opt = new List<SelectOption>();
        opt.add(new SelectOption('Consumer',System.Label.GCC_Consumer)); // Used Custom Labels
        opt.add(new SelectOption('Business',System.Label.GCC_Business)); // Used Custom Labels
        /*if(ApexPages.currentPage().getUrl().Contains('/apex/ContactProfileUpdateSP'))
        {
            opt.add(new SelectOption('Consumer','Consumidor'));
            opt.add(new SelectOption('Business','Negocio'));    
        }
        else if(ApexPages.currentPage().getUrl().Contains('/apex/ContactProfileUpdateFR'))
        {
            opt.add(new SelectOption('Consumer','l\'utilisateur'));
            opt.add(new SelectOption('Business','Entreprise'));    
        }
        else if(ApexPages.currentPage().getUrl().Contains('/apex/ContactProfileUpdateRO'))
        {
            opt.add(new SelectOption('Consumer','Persoana Fizica'));
            opt.add(new SelectOption('Business','Persoana Juridica'));    
        }
        else if(ApexPages.currentPage().getUrl().Contains('/apex/ContactProfileUpdateDU'))
        {
            opt.add(new SelectOption('Consumer','Consument'));
            opt.add(new SelectOption('Business','Bedrijf'));    
        }
        else if(ApexPages.currentPage().getUrl().Contains('/apex/ContactProfileUpdateIt'))
        {
            opt.add(new SelectOption('Consumer','Privato'));
            opt.add(new SelectOption('Business','Business'));    
        }
        else if(ApexPages.currentPage().getUrl().Contains('/apex/ContactProfileUpdateDE'))
        {
            opt.add(new SelectOption('Consumer','Verbraucher'));
            opt.add(new SelectOption('Business','Geschäft'));    
        }
        else
        {
            opt.add(new SelectOption('Consumer','Consumer'));
            opt.add(new SelectOption('Business','Business'));                     
        }*/
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
    //added attachment as transient to control viewstate size.
    public transient Attachment thisAttachmentHelper;
    public transient Attachment documentAttachmentHelper;
    
    //Constructor fetches contact record data by calling webservice and assigns to all the properties declared on top of the page.
    Public contactProfileUpdateExtension(ApexPages.StandardController controller){
        try{
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
                CntDescription = this.thisContact.Description;
                CntPhone = this.thisContact.Phone;
                CntBirthdate = this.thisContact.Birthdate;
                CntStreet = this.thisContact.MailingStreet;
                CntCity = this.thisContact.MailingCity;
                CntState = this.thisContact.MailingState;
                CntPostal = this.thisContact.MailingPostalCode;
                CntCountry = this.thisContact.MailingCountry;
                CntBusinessUser = this.thisContact.Business_User__c;
                //business user is a special case.
                if(CntBusinessUser == True){
                    UserType = 'Business';
                } else {
                    UserType = 'Consumer';
                }
                CntBirthLocation = this.thisContact.Signatory_Birth_Location__c;
                CntSignName = this.thisContact.Signatory_Name__c;
                CntNationality = this.thisContact.Signatory_Nationality__c;
                CntTaxCode = this.thisContact.Signatory_Tax_Code__c;
                CntVatNumber = this.thisContact.VAT_Number__c;
                CntProof_of_identity_submitted = this.thisContact.Proof_of_identity_submitted__c;
                if(CntProof_of_identity_submitted == True){
                    showThankYou = true;
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
            thisContact.Description = CntDescription;
            thisContact.Phone = CntPhone;
            thisContact.Birthdate  = CntBirthdate;
            thisContact.Signatory_Birth_Location__c = CntBirthLocation;
            thisContact.Signatory_Name__c = CntSignName ;
            thisContact.Signatory_Nationality__c = CntNationality ;
            system.debug('submit signatory nationality...');
            //thisContact.Signatory_Tax_Code__c = CntTaxCode;
            system.debug('submit signatory tax code...');
            thisContact.VAT_Number__c = CntVatNumber;
            thisContact.MailingStreet = CntStreet;
            thisContact.MailingCity = CntCity;
            thisContact.MailingState = CntState;
            thisContact.MailingPostalCode = CntPostal;
            thisContact.MailingCountry = CntCountry;
            if(UserType=='Business'){
                thisContact.Business_User__c = True;  
                system.debug('ssssssssssssssssssssbusiness');
            } else {
                thisContact.Business_User__c = False;
            }
            system.debug(' thisAttachment Helper is ... '+ thisAttachmentHelper.Name);
            if (thisAttachmentHelper.Name != null){
                system.debug('attachment not null');
                //calls webservice, saves contact data and attachment.
                if ( (ContactUpdateWebService.UpdateContact(ContactId,thisContact) == true) && (ContactUpdateWebService.InsertAttachment(ContactId,thisAttachmentHelper) == true) ){
                    showThankYou = true;
                    showError = false;
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.GCC_An_Error_has_occurred+'.'));
                    //System.debug('Check Attachment::: '+ApexPages.Severity.Error);
                    showThankYou = false;
                    showError = true;
                }
            }
            else {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select Photo ID.'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.GCC_Please_select_Photo_ID));
                System.debug('Check Attachment::: '+ApexPages.Severity.Error);
                showThankYou = false;
                showError = true;
            }
            if (documentAttachmentHelper.Name != null){
                system.debug('attachment not null');
                //calls webservice, saves contact data and attachment.
                if ( (ContactUpdateWebService.UpdateContact(ContactId,thisContact) == true) && (ContactUpdateWebService.InsertAttachment(ContactId,documentAttachmentHelper) == true) ){
                    showThankYou = true;
                    showError = false;
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.GCC_An_Error_has_occurred+'.'));
                    //System.debug('Check Attachment::: '+ApexPages.Severity.Error);
                    showThankYou = false;
                    showError = true;
                }
            }
            else {
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please select Photo ID.'));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.GCC_Please_select_Photo_ID));
                System.debug('Check Attachment::: '+ApexPages.Severity.Error);
                showThankYou = false;
                showError = true;
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