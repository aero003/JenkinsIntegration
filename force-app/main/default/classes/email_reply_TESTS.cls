@isTest
public class email_reply_TESTS {
    static testMethod void email_extension_TEST(){
        Case c = cases_WebServices.insertTestCase1();
        //c.Subject = 'test';
        c.recordtypeid = Label.LiveVault_Case_Rec_Type_Id;
        update c;
        system.debug('return thread id after update'+c.Email_Thread_Id__c);
        emailMessage e = new emailMessage();
        e.ParentId = c.Id;
        e.Incoming = true;
        e.FromAddress = 'testCoverage@mkpartners.com';
        e.TextBody = 'test';
        e.Subject = 'test';
        insert e;
        
        test.startTest();
        email_Extension email_ext = new email_Extension(new ApexPages.StandardController(e));
        email_ext.thisEmail = e;
        email_ext.thisCase = c;
        email_ext.replyToEmail();
        email_ext.replyToAllEmail();
        test.stopTest();
    }
    static testMethod void email_extension_TEST2(){  
        Case c1 = cases_WebServices.insertTestCase1();
        //c1.Subject = 'test';
        c1.recordtypeid = Label.KeepITSafe_Case_Rec_Type_Id;
        update c1;
        emailMessage e1 = new emailMessage();
        e1.ParentId = c1.Id;
        e1.Incoming = true;
        e1.FromAddress = 'testCoverage@mkpartners.com';
        e1.TextBody = 'test';
        e1.Subject = 'test';
        insert e1;
        
        test.startTest();
        email_Extension email_ext = new email_Extension(new ApexPages.StandardController(e1));
        email_ext.thisEmail = e1;
        email_ext.thisCase = c1;
        email_ext.replyToEmail();
        email_ext.replyToAllEmail();
        test.stopTest();
        
    }
    static testMethod void email_extension_TEST3(){  
        Account a = New Account();
        a.Name='Test';
        a.Account_Status__c = 'Open';
        //a.RecordTypeId = rid;
        a.RecordTypeId = Label.LiveVault_Acc_Rec_Type_Id;
    	a.KeepItSafe_username__c = 'magnetic';
        insert a;
        
        Case c1 = cases_WebServices.insertTestCase1();
        //c1.Subject = 'test';
        c1.AccountId = a.Id;
        c1.recordtypeid = Label.KeepITSafe_Case_Rec_Type_Id;
        c1.Status = 'Closed';
        update c1;
        
        emailMessage e1 = new emailMessage();
        e1.ParentId = c1.Id;
        e1.Incoming = true;
        e1.FromAddress = 'testCoverage@mkpartners.com';
        e1.TextBody = 'test';
        e1.Subject = 'test';
        insert e1;
        
        test.startTest();
        email_Extension email_ext = new email_Extension(new ApexPages.StandardController(e1));
        email_ext.thisEmail = e1;
        email_ext.thisCase = c1;
        email_ext.replyToEmail();
        email_ext.replyToAllEmail();
        test.stopTest();
        
    }
    static testMethod void email_extension_TEST4(){  
        Account a = New Account();
        a.Name='Test';
        a.Account_Status__c = 'Open';
        //a.RecordTypeId = rid;
        a.RecordTypeId = '012600000009V7u';
    	a.KeepItSafe_username__c = 'magnetic';
        insert a;
        
        Case c1 = cases_WebServices.insertTestCase1();
        //c1.Subject = 'test';
        c1.AccountId = a.Id;
        c1.recordtypeid = '012600000009V7k';
        c1.Status = 'Closed';
        update c1;
        
        emailMessage e1 = new emailMessage();
        e1.ParentId = c1.Id;
        e1.Incoming = true;
        e1.FromAddress = 'testCoverage4@mkpartners.com';
        e1.TextBody = 'test';
        e1.Subject = 'Cancel this case';
        insert e1;
        
        test.startTest();
        email_Extension email_ext = new email_Extension(new ApexPages.StandardController(e1));
        email_ext.thisEmail = e1;
        email_ext.thisCase = c1;
        email_ext.replyToEmail();
        email_ext.replyToAllEmail();
        test.stopTest();
        
    }
}