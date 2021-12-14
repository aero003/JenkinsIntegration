global class JGCNewSignupAccountEmail Implements Schedulable {
global void execute (SchedulableContext ctx) {
     
     	//List<User> users = [select Id,Name,Email,isActive from User where Email =: System.Label.JGC_Users_Email_Address];
     	EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where DeveloperName = 'JGC_Send_New_Signup_Account_Report'];
        //System.debug('emails $$$ '+ users[0].Email);
        System.debug('emailTemp $$$ '+ emailTemplate.Subject);
        System.debug('users @@@ '+ System.Label.JGC_Users_Email_Address);
        Messaging.SingleEmailMessage email =  new Messaging.SingleEmailMessage();
        //  list of people who should get the email
        List<String> sendTo = new List<String>();
        String[] sendingTo=new String[]{'sanath.kumar@j2.com','satoshi.sato@j2.com','yuri.hoshino@j2.com','shoko.hiroi@j2.com','yoshitaka.emori@j2.com'};
		//sendTo.add('archan.bhachech@j2.com','archan.bhachech@cygnetinfotech.com');
         
        email.setToAddresses(sendingTo);
        email.setReplyTo('j2salesforceadmin@j2.com');
        email.setSenderDisplayName('J2 Salesforce Admin');
        
        String subject = emailTemplate.Subject +' '+ DateTime.now().addDays(-1).format('MM-dd-yyyy'); 
        System.debug('NewSubject### '+ subject);
        email.setSubject(subject);
        email.setHtmlBody(emailTemplate.HtmlValue);
       //email.setTemplateID(emailTemplate.Id);
        email.setSaveAsActivity(false);
        //mail.setSaveAsActivity(true);
         
     	Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
 	}
}