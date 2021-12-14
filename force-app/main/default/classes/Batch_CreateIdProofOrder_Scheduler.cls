global class Batch_CreateIdProofOrder_Scheduler implements Schedulable {
    global void execute(Schedulablecontext Batch_CreateIdProofOrder_Scheduler){
        Batch_CreateIdProofOrder batchJob = new Batch_CreateIdProofOrder();
        Database.executeBatch(batchJob,50);
    }
}