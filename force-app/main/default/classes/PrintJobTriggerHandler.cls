public class PrintJobTriggerHandler {
    //handles execution of the PrintTrigger
    
    public static void PrintJobScheduler(list<Print_Job__c> TriggerNew){
        for (Print_Job__c p : TriggerNew) {
            if(p.Print_Job_Status__c == 'Pending' && p.Schedule_Override__c == False && p.Job_Type__c == 'Initial Print Run'){
                PrintJobScheduleUpdateClass.StandardPrintScheduler(p);
            }
            if(p.Print_Job_Status__c == 'Pending' && p.Schedule_Override__c == False && p.Job_Type__c == 'Reprint'){
                PrintJobScheduleUpdateClass.ReprintScheduler(p);
            }
            if(p.Print_Job_Status__c == 'Pending' && p.Schedule_Override__c == False && p.Job_Type__c == 'Hydra'){
                PrintJobScheduleUpdateClass.HydraScheduler(p);
            }
        }
    }
    
    //public static void PrintJobSequencer(list<Print_Job__c> TriggerNew){
        
    //}
    
}