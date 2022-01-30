/***********************************
Author:      Amazon Apub // kkolla@
Used By:     
Description: Scheduler class for ppw_censhareConnector_PSUpdateBatch
***********************************/
global class Ppw_cc_PSUpdateBatchScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
      Database.executeBatch(new ppw_censhareConnector_PSUpdateBatch(),1);
   }
}