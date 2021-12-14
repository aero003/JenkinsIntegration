@isTest
public class TestJGCSendClosedAccountEmail {
public static testMethod void unitTest(){
    Test.startTest();
    EmailTemplate template = [SELECT id,Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'JGC_Send_Closed_Account_Report'];
        JGCSendClosedAccountEmail emailSch = new JGCSendClosedAccountEmail();
      String sch = '0 0 23 * * ?'; 
      System.schedule('Test Territory Check', sch, emailSch); 
        Test.stopTest();
}
  public static testMethod void unitTest1(){
    Test.startTest();
    EmailTemplate template = [SELECT id,Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'JGC_Send_New_Signup_Account_Report'];
        JGCNewSignupAccountEmail emailSch = new JGCNewSignupAccountEmail();
      String sch = '0 0 23 * * ?'; 
      System.schedule('Test Territory Check', sch, emailSch); 
        Test.stopTest();
}
    public static testMethod void unitTest3(){
    Test.startTest();
    EmailTemplate template = [SELECT id,Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'JGC_Send_Pending_Review_Account_Report'];
        JGCSendPendingReviewAccountEmail emailSch = new JGCSendPendingReviewAccountEmail();
      String sch = '0 0 23 * * ?'; 
      System.schedule('Test Territory Check', sch, emailSch); 
        Test.stopTest();
}
    public static testMethod void unitTest4(){
    Test.startTest();
    EmailTemplate template = [SELECT id,Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName = 'JGC_Send_Active_Account_Report'];
      JGCSendActiveAccountEmail emailSch = new JGCSendActiveAccountEmail();
      String sch = '0 0 23 * * ?'; 
      System.schedule('Test Territory Check', sch, emailSch); 
        Test.stopTest();
}
}