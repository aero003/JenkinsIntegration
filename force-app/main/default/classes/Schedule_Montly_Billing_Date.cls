global class Schedule_Montly_Billing_Date implements Schedulable{
    global void execute(SchedulableContext sc){
        Batch_Montly_Billing_Date mc = new Batch_Montly_Billing_Date();
        Database.executeBatch(mc,5);
    }
}