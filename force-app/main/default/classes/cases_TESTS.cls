@isTest
public class cases_TESTS {

    static testMethod void cases_Extension_TEST() {
        List<Case> cases = new List<Case>();
        cases.add(cases_WebServices.insertTestCase());

        test.startTest();
            cases_Extension extension = new cases_Extension(new ApexPages.StandardSetController(cases));
        test.stopTest();
    }

    static testMethod void cases_New_TEST() {
        Account a = new Account();
        a.Name = 'test';
        a.Livevault_Product__c = 'Undecided';
        a.RecordTypeId = Label.LiveVault_Acc_Rec_Type_Id;
        insert a;
        
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'test';
        con.AccountId = a.Id;
        //con.RecordTypeId = '012600000009Uvy';
        insert con;

        DID__c d = new DID__c();
        d.Name = '3105551212';
        d.Account__c = a.Id;
        d.Contact__c = con.Id;
        d.Status__c = 'Active';
        insert d;
        
        Case c = cases_WebServices.insertTestCase();
        c.AccountId = a.Id;
        c.ContactId = con.Id;
        c.DID__c = d.Id;
        update c;
        
        test.startTest();
            cases_Extension extension = new cases_Extension(new ApexPages.StandardController(c));
            extension.thisCase = c;
            extension.replyToCase();
            
            extension.thisCase = c.clone(false,true);
            extension.thisCase.AccountId = null;
            PageReference p = extension.insertAndRedirect();
        test.stopTest();
        
    }

    static testMethod void cases_getNext_TEST() {
        User myUser = [Select Id from user where Id = :userInfo.getUserId() limit 1];
        Group g;
        system.runAs(myUser){
            g = new Group();
            g.Type = 'Queue';
            g.Name = 'test';
            insert g;
            
            QueueSObject q = new QueueSObject();
            q.SobjectType = 'Case';
            q.QueueId = g.Id;
            insert q;
        }

        Case c = cases_WebServices.insertTestCase();
        c.OwnerId = g.Id;
        update c;
        
        List<Case> caseList = new List<Case>();
        caseList.add(c);
        
        test.startTest();
            cases_Extension extension = new cases_Extension(new ApexPages.StandardController(c));
            extension.thisCase = c;
            PageReference p = extension.getNextCase();

            extension.theseCases = caseList;
            p = extension.getNextCase();

        test.stopTest();
    }
    static testMethod void cases_getNext2_TEST() {
        User myUser = [Select Id from user where Id = :userInfo.getUserId() limit 1];
        Group g;
        system.runAs(myUser){
            g = new Group();
            g.Type = 'Queue';
            g.Name = 'test';
            insert g;
            
            QueueSObject q = new QueueSObject();
            q.SobjectType = 'Case';
            q.QueueId = g.Id;
            insert q;
        }

        Case c = cases_WebServices.insertTestCase();
        c.OwnerId = g.Id;
        update c;
        
        Case c2 = cases_WebServices.insertTestCase();
        c2.OwnerId = g.Id;
         c2.status = 'Closed';
        update c2;

        c2 = [select ID, OwnerId, status, IsClosed from case where id=:c2.Id];
        List<Case> caseList = new List<Case>();
        caseList.add(c2);
        
        test.startTest();
            cases_Extension extension = new cases_Extension(new ApexPages.StandardController(c));
            extension.thisCase = c;
            PageReference p = extension.getNextCase();

            cases_Extension extension2 = new cases_Extension(new ApexPages.StandardSetController(caseList));
            extension2.theseCases = caseList;
            extension2.getNextCase();

        test.stopTest();
    }

    static testMethod void cases_Survey_Extension_TEST() {
        Case c = cases_WebServices.insertTestCase();

        test.startTest();
            cases_Survey_Extension extension = new cases_Survey_Extension(new ApexPages.StandardController(c));
            extension.thisCase = c;
            extension.caseId = c.Id;
            extension.getAwareOptions();
            extension.getGoodOptions();
            extension.getSatisfiedOptions();
            extension.submitSurvey();
        test.stopTest();
    }

    static testMethod void cases_WebServices_TEST() {
        Case c = new Case();
        c.Subject = 'test';
        c.Status = 'New';
        insert c;

        test.startTest();
            cases_WebServices.updateCase(c.Id, c);
        test.stopTest();
    }


    ///<classes>
    ///     <emailMessages.cls>100% Coverage as of 2011-03-23</emailMessages.cls>
    ///</classes>
    ///<triggers>
    ///     <emailMessages.trg>100% Coverage as of 2011-03-23</emailMessages.trg>
    ///</triggers>
    static testMethod void emailMessages_TEST() {
        Case c = cases_WebServices.insertTestCase();
        c.Status = 'Closed';
        update c;

        test.startTest();

            emailMessage e = new emailMessage();
            e.ParentId = c.Id;
            e.Incoming = true;
            e.FromAddress = 'testCoverage@mkpartners.com';
            e.TextBody = 'test';
            e.Subject = 'test';
            insert e;
            
        c = [Select Id, Status, Email_Status__c, IsClosed from Case where Id = :c.Id limit 1];
        system.assert( c.IsClosed != true );

        test.stopTest();
    }
    
    static testMethod void reply_toCase_TEST(){
        Account a = new Account();
        a.Name = 'test';
        insert a;
        
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'test';
        con.AccountId = a.Id;
        insert con;
        
        Case c = cases_WebServices.insertTestCase();
        c.OwnerId = userInfo.getUserId();
        c.status = 'Closed';
        c.ContactId = con.id;
        c.Subject = 'test';
        update c;
        
        Case c2 = cases_WebServices.insertTestCase();
        c2.OwnerId = userInfo.getUserId();
        c2.status = 'Closed';
        c2.ContactId = con.id;
        c2.Subject = 'test2';
        update c2;
        
        test.startTest();
        cases_Extension cases_ext = new cases_Extension(new ApexPages.StandardController(c));
        cases_ext.thiscase = c;
        cases_ext.replyToCase();
        
        cases_Extension cases_ext2 = new cases_Extension(new ApexPages.StandardController(c2));
        cases_ext2.thiscase = c2;
        cases_ext2.replyToAll();
        test.stopTest();
    }
    public static testMethod void reply_toCase2_TEST(){
        Account a = new Account();
        a.Name = 'account holder';
        insert a;
        
        Contact con = new Contact();
        con.FirstName = 'princess';
        con.LastName = 'consuella';
        con.AccountId = a.Id;
        insert con;
        
        Case c = cases_WebServices.insertTestCase();
        c.OwnerId = userInfo.getUserId();
        c.status = 'Closed';
        c.ContactId = con.id;
        c.Subject = 'game time';
        c.AccountId = a.id;
        c.RecordTypeId = Label.KeepITSafe_Case_Rec_Type_Id;
        update c;
       
        c = [select Email_Thread_Id__c,OwnerId,status,ContactId,Subject, AccountID, RecordtypeId,CaseNumber, ID from case where ID = :c.Id];
        
        Case c2 = cases_WebServices.insertTestCase();
        c2.OwnerId = userInfo.getUserId();
        c2.status = 'Closed';
        c2.ContactId = con.id;
        c2.Subject = 'game time2';
        c2.AccountId = a.id;
        c2.RecordTypeId = Label.KeepITSafe_Case_Rec_Type_Id;
        update c2;
       
        c2 = [select Email_Thread_Id__c,OwnerId,status,ContactId,Subject, AccountID, RecordtypeId,CaseNumber, ID from case where ID = :c2.Id];
        test.startTest();
        cases_Extension cases_ext = new cases_Extension(new ApexPages.StandardController(c));
        cases_ext.thiscase = c;
        cases_ext.replyToCase();
        
         cases_Extension cases_ext2 = new cases_Extension(new ApexPages.StandardController(c2));
        cases_ext2.thiscase = c2;
        cases_ext2.replyToAll();
       
        test.stopTest();
    }

}