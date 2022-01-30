@isTest
private class PPW_NotificationWindowBatchSchedulerTest {
 
 @isTest static void PPW_NotificationWindowBatchTest() {
 
 String sch = '0 0 23 * * ?'; 
system.schedule('Test Territory Check', sch, new PPW_NotificationWindowBatchScheduler()); 

 }

}