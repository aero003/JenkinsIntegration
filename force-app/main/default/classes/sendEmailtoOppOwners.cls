global class sendEmailtoOppOwners implements Schedulable {
 global void execute (SchedulableContext ctx) {
     List<Opportunity> oppList = [select Id,Name,AccountId,Account.name,RecordType.name,StageName,CloseDate,OwnerId,Owner.name,Owner.Email,Owner.IsActive from Opportunity where RecordType.name='eFax Corporate Opp' and Probability NOT IN (0,100) and CloseDate<TODAY and /*OwnerId='0050j000001aFYF'];*/Owner.UserRole.Name IN ('Fax Sales Manager','Fax Sales Rep','Fax Strategic Manager','Fax Strategic Reps')];
     User user = [select Id,Name,Email from User where Email =: System.Label.eFax_Corporate_Director_Email];
     List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
     EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName = 'eFax_Corp_Opp_not_Closed'];
     if(oppList!=null || oppList.size()>0)
     {
         for(integer i=0;i<oppList.size();i++)
         {
             Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
             //  list of people who should get the email
             List<String> sendTo = new List<String>();
             if(oppList[i].Owner.IsActive)
             {
             	sendTo.add(oppList[i].Owner.Email );
             }
             sendTo.add(user.Email);
             mail.setToAddresses(sendTo);
             mail.setReplyTo('j2salesforceadmin@j2.com');
             mail.setSenderDisplayName('J2 Salesforce Admin');
             mail.settargetobjectid(oppList[i].OwnerId);
             String subject = emailTemplate.Subject +' '+ oppList[i].Name;
             
             String htmlBody = emailTemplate.HtmlValue;
             htmlBody = htmlBody.replace('{!Opportunity.OwnerFullName}', oppList[i].Owner.Name);
             htmlBody = htmlBody.replace('{!Opportunity.Name}', oppList[i].Name);
             htmlBody = htmlBody.replace('{!Opportunity.Account}', oppList[i].Account.Name);
             htmlBody = htmlBody.replace('{!Opportunity.CloseDate}', string.valueOf(oppList[i].CloseDate));
             htmlBody = htmlBody.replace('{!Opportunity.Link}', URL.getSalesforceBaseUrl().getHost()+'/'+oppList[i].Id);
             
             String plainBody = emailTemplate.Body;
             plainBody = plainBody.replace('{!Opportunity.OwnerFullName}', oppList[i].Owner.Name);
             plainBody = plainBody.replace('{!Opportunity.Name}', oppList[i].Name);
             plainBody = plainBody.replace('{!Opportunity.Account}', oppList[i].Account.Name);
             plainBody = plainBody.replace('{!Opportunity.CloseDate}', string.valueOf(oppList[i].CloseDate));
             plainBody = plainBody.replace('{!Opportunity.Link}', URL.getOrgDomainUrl()+'/'+oppList[i].Id);

             mail.setSubject(subject);
             mail.setHtmlBody(htmlBody);
             mail.setPlainTextBody(plainBody);
             //mail.setTemplateID('00X0j000000MTRV');
             mail.setSaveAsActivity(false);
             //mail.setSaveAsActivity(true);
             mails.add(mail);
         }
     }
     if(mails.size()>0)  Messaging.sendEmail(mails);
 }
   
}