/* 
 * This is a Scheduler class for Batch_ETLUpdate
 */

global class Batch_ETLUpdateScheduler implements Schedulable{
    global void execute(Schedulablecontext Batch_ETLUpdateScheduler){
        Batch_ETLUpdate batchJob = new Batch_ETLUpdate();
        Database.executeBatch(batchJob,20);
    }
}