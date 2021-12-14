@isTest
public class Test_Batch_ETLUpdate {

    @testSetup static void setup() {
       
        Account_Fax__c ax = new Account_Fax__c();
        ax.Application_Id__c = 'A19028';
        ax.Status__c = 'Active';
        insert ax;
        
        Account acc = new Account();
        acc.name = 'Batch Account';
        insert acc;  
    } 
    @isTest
    public static void method1() {
        Test.startTest();
        Database.executeBatch(new Batch_ETLUpdate());
        Test.stopTest(); 
    }
    @isTest
    public static void method2() {
        Account acc = [Select id,name,Application_ID__c from Account Limit 1];
        Account_Fax__c ax = [Select id,Application_Id__c,Status__c from Account_Fax__c Limit 1];
        acc.Application_ID__c = ax.Application_ID__c;
        update acc;
        Test.startTest();
        Database.executeBatch(new Batch_ETLUpdate());
        Test.stopTest(); 
    }
    @isTest
    public static void method3() {
        Account_Fax__c ax = [Select id,Application_Id__c,Status__c from Account_Fax__c Limit 1];
        ax.Corp_ID__c = '0000';
        Account acc = [Select id,name,Application_ID__c from Account Limit 1];
        acc.Application_ID__c = ax.Application_ID__c;
        acc.Corp_ID__c ='0001';
        update ax;
        update acc;
        Test.startTest();
        Database.executeBatch(new Batch_ETLUpdate());
        Test.stopTest(); 
    }
    @isTest
    public static void testschedule() {
		Test.StartTest();
		Batch_ETLUpdateScheduler upSch = new Batch_ETLUpdateScheduler();
		system.schedule('Test status Check', '0 0 23 * * ?', upSch );
		Test.stopTest();
	}
    
}