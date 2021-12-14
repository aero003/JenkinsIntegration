@isTest(seeAllData=false)
public class testTask {

    static testMethod void testTasks(){
        
        Account a = New Account();
        a.Name='Test';
        insert a;
        
        List<Task> taskList = new List<Task>();
        
        Case c=new Case();
        c.RecordTypeid = Label.LiveVault_Case_Rec_Type_Id;
        insert c;
        Task tsk = New Task();
        tsk.Subject='test';
        tsk.RecordTypeid = Label.LiveVault_Task_Rec_Type_Id;
        tsk.whatId=c.Id;
        insert tsk;
        taskList.add(tsk);
        
        Case c1=new Case();
        c1.RecordTypeid = Label.KeepITSafe_Case_Rec_Type_Id ;
        c1.Status ='Resolved';
        c1.AccountId=a.Id;
        c1.Region__c='US';
        c1.Product__c='test1';
        insert c1;
        Task tsk1 = New Task();
        tsk1.Subject='test1';
        tsk1.RecordTypeid = Label.KeepITSafe_Task_Rec_Type_Id;
        tsk1.whatId=c1.Id;
        insert tsk1;
        taskList.add(tsk1);
        
        TaskClass t1= new TaskClass();
        TaskClass.afterInsert(taskList);
        TaskClass.afterUpdate(taskList);
        
     }
}