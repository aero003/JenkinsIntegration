global class ContactUpdateWebService {
    //get contact details using  soql query
    webservice static contact getContactRecord(String ContactId){
        //System.debug('Inside ContID === '+ContactId);
        List<contact> Contacts = [Select Id,Name,CreatedDate,Account.Name,Contact_End_Date__c,Account.Account_Close_Date__c, FirstName, LastName, Email, Phone, Description,Happy_Hour__c, Birthdate, Business_User__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, Signatory_Name__c, Signatory_Birth_Location__c, Signatory_Nationality__c, Signatory_Tax_Code__c, VAT_Number__c,Proof_of_identity_submitted__c,DID_Number__c,Documents_Uploaded__c,Documents_Submitted__c,Documents_Reviewed__c,No_of_links_sent__c,Company_Name__c,Post_Card_Delivered__c from Contact where Id = :ContactId limit 1]; 
        if ( Contacts.size() > 0 ){
            return Contacts[0];
        } else {
            return new Contact();
        }
    }
    //creates new contact object instance, updates it, and return success.
    webservice static Boolean updateContact(String ContactId, Contact ct){
        try{
            Contact ct_update = new Contact(ID=ContactId);
            ct_update.Description = ct.Description;
            ct_update.Phone = ct.Phone;
            ct_update.Birthdate = ct.Birthdate;
            ct_update.Business_User__c = ct.Business_User__c;
            ct_update.MailingStreet = ct.MailingStreet;
            ct_update.MailingCity = ct.MailingCity;
            ct_update.MailingState = ct.MailingState;
            ct_update.MailingPostalCode = ct.MailingPostalCode;
            ct_update.MailingCountry = ct.MailingCountry;
            if(ct.Business_User__c){
                ct_update.VAT_Number__c = ct.VAT_Number__c;
                ct_update.Signatory_Name__c = ct.Signatory_Name__c;
                
            }
            //ct_update.Signatory_Tax_Code__c = ct.Signatory_Tax_Code__c;
            ct_update.Signatory_Birth_Location__c = ct.Signatory_Birth_Location__c;
            ct_update.Signatory_Nationality__c = ct.Signatory_Nationality__c;
            ct_update.Proof_of_identity_submitted__c	= True;
            ct_update.Documents_Uploaded__c = ct.Documents_Uploaded__c; 
            ct_update.Documents_Submitted__c=ct.Documents_Submitted__c;    
            ct_update.Business_User__c = ct.Business_User__c;
            database.saveResult dsr = database.update(ct_update,true);
            system.debug('Webservice update');
            return dsr.isSuccess();
        }
        catch(exception ex){
            system.debug('Webservice catchs');
            return false;
        }
    }
    //pass contact id and attachment to insert attachment.
    webservice static Boolean insertAttachment(String ContactId, Attachment att){
        try{
            Attachment att_insert = new Attachment();
            att_insert.Name = att.Name;
            att_insert.Body = att.Body;
            att_insert.OwnerId = UserInfo.getUserId();
            
            att_insert.ParentId = ContactId;
            database.saveResult dsr = database.insert(att_insert,true);
            return dsr.isSuccess();
        }
        catch(exception ex){
            System.debug('exceptiion is ::: '+ex);
            return false;
        }
    }
}