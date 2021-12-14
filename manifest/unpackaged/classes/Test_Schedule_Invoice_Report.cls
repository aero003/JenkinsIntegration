@isTest
public class Test_Schedule_Invoice_Report {

    public static testMethod void testschedule() {
        Test.StartTest();
			Schedule_Invoice_Report sh1 = new Schedule_Invoice_Report();

			String sch = '0 0 23 * * ?'; 
        	system.schedule('Test Check', sch, sh1); 
        
        Test.stopTest(); 
    }
}