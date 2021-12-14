@isTest
public class Test_Schedule_Montly_Billing_Date {

    public static testMethod void testschedule() {
        Test.StartTest();
			Schedule_Montly_Billing_Date sh1 = new Schedule_Montly_Billing_Date();

			String sch = '0 0 23 * * ?'; 
        	system.schedule('Test Check', sch, sh1); 
        
        Test.stopTest(); 
    }
}