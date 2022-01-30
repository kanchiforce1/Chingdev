public class PrintJobSequenceClass {
    public static List<Print_job__c> sequenceAndDate (Map<Id, List<Print_Job__c>> printMap){
        //number of the current job
        //size of the job list zero-based
        //look at all non cancelled jobs, provide a sequence of the jobs based on the unit date, and stamp the unit date of the previous job, and the next job.
        //this will then allow for a formula field to calculate the day counts, for reporting
        
        decimal numInnerJobs;
        decimal currentJob;
        decimal numNonCancelled;
        integer jobIndex;
        
        List<Print_Job__c> updatedJobList = new List<Print_Job__c>();
        
        for(id asin : printMap.keySet()){
            List<Print_Job__c> innerPrintJobs = new List<Print_Job__c>(printMap.get(asin));
            List<Print_Job__c> nonCancelledPrintJobs = new List<Print_Job__c>();
            List<Print_Job__c> cancelledPrintJobs = new List<Print_Job__c>();
            
            for(Print_Job__c pnc : innerPrintJobs){
                if(pnc.Print_Job_Status__c != 'Cancelled'){
                    nonCancelledPrintJobs.add(pnc);
                }else{
                    cancelledPrintJobs.add(pnc);
                }
            }
            
            currentJob = 1;
            
            for(Print_Job__c p : nonCancelledPrintJobs){ //loop through the jobs in the list...
                numNonCancelled = nonCancelledPrintJobs.size();
                jobIndex = integer.valueOf(currentJob);
                
                if(currentJob == 1 && numNonCancelled == 1 && p.Print_Job_Status__c != 'Cancelled'){
                    //inner list only has 1 non cancelled job, no previous date.
                    p.Next_Job_Kick_Off__c = null;
                    p.Previous_Job_Kick_Off__c = null;
                    p.Job_Sequence__c = currentJob;
                    p.Format_Job_Count__c = numNonCancelled;
                    
                    updatedJobList.add(p);
                    
                    break;
                }
                
                if(currentJob == 1 && currentJob < numNonCancelled && p.Print_Job_Status__c != 'Cancelled'){
                    p.Previous_Job_Kick_Off__c = null;
                    p.Next_Job_Kick_Off__c = nonCancelledPrintJobs.get(jobIndex).Units_Spec_Due_Date__c;
                    p.Job_Sequence__c = currentJob;
                    p.Format_Job_Count__c = numNonCancelled;
                    
                    updatedJobList.add(p);
                    
                    currentJob++;
                    continue;
                }
                
                if(currentJob > 1 && currentJob < numNonCancelled && p.Print_Job_Status__c != 'Cancelled'){
                    p.Previous_Job_Kick_Off__c = nonCancelledPrintJobs.get(jobIndex-2).Units_Spec_Due_Date__c;
                    p.Next_Job_Kick_Off__c = nonCancelledPrintJobs.get(jobIndex).Units_Spec_Due_Date__c;
                    p.Job_Sequence__c = currentJob;
                    p.Format_Job_Count__c = numNonCancelled;
                    
                    updatedJobList.add(p);
                    
                    currentJob++;
                    continue;
                }
                
                if(currentJob == numNonCancelled && p.Print_Job_Status__c != 'Cancelled'){
                    p.Previous_Job_Kick_Off__c = nonCancelledPrintJobs.get(jobIndex-2).Units_Spec_Due_Date__c;
                    p.Next_Job_Kick_Off__c = null;
                    p.Job_Sequence__c = currentJob;
                    p.Format_Job_Count__c = numNonCancelled;
                    
                    updatedJobList.add(p);
                    
                    currentJob++;
                    continue;
                }
            }
            
            for(Print_Job__c cpj : cancelledPrintJobs){
                cpj.Previous_Job_Kick_Off__c = null;
                cpj.Next_Job_Kick_Off__c = null;
                cpj.Job_Sequence__c = null;
                cpj.Format_Job_Count__c = null;
                
                updatedJobList.add(cpj);
            }
            
        }
        
        return updatedJobList;
        
    }
}