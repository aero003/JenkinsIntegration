global class Schedule_Invoice_Report implements Schedulable{
    global void execute(SchedulableContext sc){
        Batch_Invoice_Report mc = new Batch_Invoice_Report();
        Database.executeBatch(mc,100);
    }
}