@isTest
public class JGCVFpagetesing {
static testMethod void testMethod1() 
  {
    Account testAccount = new Account();
    testAccount.Name='Test Account' ;
    insert testAccount;
    
    Contact cont = new Contact ();
    cont.LastName ='Test';
    cont.FirstName ='Test';
        cont.Documents_Submitted__c='Y';
    cont.accountid = testAccount.id;
        cont.Documents_Uploaded__c = 'Customer';
        insert cont;
        
        Test.StartTest(); 

      ApexPages.currentPage().getParameters().put('id', String.valueOf(cont.Id));
          Apexpages.StandardController stdController = new Apexpages.StandardController(cont); 
      JGCContactIdentityVerifyExt  testAccPlan = new JGCContactIdentityVerifyExt(stdController);
      testAccPlan.submitContactForm();
            testAccPlan.getUserTypeItems();
        
            // testAccPlan.JGCContactIdentityVerifyExt();
      //testAccPlan.add ();

    Test.StopTest();
    }
    static testMethod void testMethod2() 
  {
    Account testAccount = new Account();
    testAccount.Name='Test Account' ;
    insert testAccount;
    
    Contact cont = new Contact ();
    cont.LastName ='Test';
    cont.FirstName ='Test';
        cont.Documents_Submitted__c='Y';
    cont.accountid = testAccount.id;
        cont.Documents_Uploaded__c = 'Customer';
        insert cont;
        
        Test.StartTest(); 

      ApexPages.currentPage().getParameters().put('id', String.valueOf(''));
          Apexpages.StandardController stdController = new Apexpages.StandardController(cont); 
      JGCContactIdentityVerifyExt  testAccPlan = new JGCContactIdentityVerifyExt(stdController);
      testAccPlan.submitContactForm();
            testAccPlan.getUserTypeItems();
        
            // testAccPlan.JGCContactIdentityVerifyExt();
      //testAccPlan.add ();

    Test.StopTest();
    }
    static testMethod void testMethod3() 
  {
    Account testAccount = new Account();
    testAccount.Name='Test Account' ;
    insert testAccount;
    
    Contact cont = new Contact ();
    cont.LastName ='Test';
    cont.FirstName ='Test';
        cont.Documents_Submitted__c='Y';
    cont.accountid = testAccount.id;
        cont.Documents_Uploaded__c = 'Customer Service';
        insert cont;
      
      ApexPages.currentPage().getParameters().put('id',cont.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(cont);
        
        JGCContactIdentityVerifyExt  cpt = new JGCContactIdentityVerifyExt (stdController);
      /*  Attachment cntattach = new Attachment();
        cntattach.Name = 'Unit test attachment';
        Blob bodyblob = Blob.valueOf('Unit test attachment body');
        cntattach.body = bodyblob;*/
        
      
       Attachment attach = new Attachment();
  		attach.Name = 'Signature_File';
  		Blob bodyBlob = Blob.valueOf('Testing Body of Attachment');
  		attach.body = bodyBlob;
  		attach.parentId =cont.id;
  		insert attach;
      
      cpt.thisAttachment = attach;
      cpt.documentAttachment=attach;
      cpt.extraDocumentAttachment=attach;
        cpt.submitContactForm();
      cpt.getUserTypeItems();
        
       /* Test.StartTest(); 

      ApexPages.currentPage().getParameters().put('id', String.valueOf(attach.Id));
          Apexpages.StandardController stdController = new Apexpages.StandardController(attach); 
      JGCContactIdentityVerifyExt  testAccPlan = new JGCContactIdentityVerifyExt(stdController);
      testAccPlan.submitContactForm(attach);
            testAccPlan.getUserTypeItems();
     // testAccPlan.thisAttachment();
        
            // testAccPlan.JGCContactIdentityVerifyExt();
      //testAccPlan.add ();

    Test.StopTest();*/
  }
    static testMethod void testMethod4() 
  {
    Account testAccount = new Account();
    testAccount.Name='Test Account' ;
    insert testAccount;
    
    Contact cont = new Contact ();
    cont.LastName ='Test';
    cont.FirstName ='Test';
        cont.Documents_Submitted__c='Y';
    cont.accountid = testAccount.id;
        cont.Documents_Uploaded__c = 'Customer Service';
        insert cont;
      
      ApexPages.currentPage().getParameters().put('id','');
        ApexPages.StandardController stdController = new ApexPages.StandardController(cont);
        
        JGCContactIdentityVerifyExt  cpt = new JGCContactIdentityVerifyExt (stdController);
       Attachment attach = new Attachment();
  		attach.Name = 'Signature_File';
  		Blob bodyBlob = Blob.valueOf('Testing Body of Attachment');
  		attach.body = bodyBlob;
  		attach.parentId =cont.id;
  		insert attach;
      
      cpt.thisAttachment = attach;
      cpt.documentAttachment=attach;
      cpt.extraDocumentAttachment=attach;
      cpt.submitContactForm();
      cpt.getUserTypeItems();
  }
}