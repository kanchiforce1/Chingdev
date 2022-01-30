/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Service Prep Form
Description: Scheduler class for PPW_notificationWindowBatch
***********************************/
global class PPW_NotificationWindowBatchScheduler implements Schedulable {
   global void execute(SchedulableContext SC) {
      Database.executeBatch(new PPW_NotificationWindowBatch(),10);
   }
}