public class PrintJobScheduleUpdateClass {
    
    public static Print_Job__c StandardPrintScheduler(Print_Job__c pj){
        if(pj.On_Sale_Date__c != null){
            //if this is a domestic 1C work 
            if(pj.Print_Location__c == 'RR Donnelley US' && pj.Format_Name__c == 'Paperback'){
                pj.Units_Spec_Due_Date__c = pj.On_Sale_Date__c - 56;
                pj.Files_Due_At_Printer__c = pj.On_Sale_Date__c - 56;
                pj.Estimated_Ship__c = pj.On_Sale_Date__c - 35;
                pj.BPI_Forecast_Due__c = pj.Units_Spec_Due_Date__c - 21;
            }
            //domestic 1C hardcover work
            if(pj.Print_Location__c == 'RR Donnelley US' && pj.Format_Name__c == 'Hardcover'){
                system.debug(pj);
                pj.Units_Spec_Due_Date__c = pj.On_Sale_Date__c - 112;
                pj.Files_Due_At_Printer__c = pj.On_Sale_Date__c - 91;
                pj.Estimated_Ship__c = pj.On_Sale_Date__c - 35;
                pj.BPI_Forecast_Due__c = pj.Units_Spec_Due_Date__c - 21;
            }
            //anything china gets updated to its base schedule
            if(pj.Print_Location__c == 'RR Donnelley China'){
                pj.Units_Spec_Due_Date__c = pj.On_Sale_Date__c - 140;
                pj.Files_Due_At_Printer__c = pj.On_Sale_Date__c - 126;
                pj.Estimated_Ship__c = pj.On_Sale_Date__c - 84;
                pj.BPI_Forecast_Due__c = pj.Units_Spec_Due_Date__c - 21;
            }
        }else{
            pj.Units_Spec_Due_Date__c = null;
            pj.Files_Due_At_Printer__c = null;
            pj.Estimated_Ship__c = null;
            pj.BPI_Forecast_Due__c = null;
            pj.Print_Job_Status__c = 'Attention Required';
            pj.Schedule_Exception__c = true;
            pj.notes__c = 'No publication date from the Milestone/ASIN.';
        }
        return pj;
    }
    
    public static Print_Job__c ReprintScheduler(Print_Job__c pj){
        datetime create = datetime.now();
        if(pj.Print_Location__c == 'RR Donnelley China'){
            pj.Schedule_Override__c = True;
            pj.Schedule_Exception__c = True;
            pj.Files_Approved__c = True;
            pj.RFQ_Required__c = True;
            pj.Units_Spec_Due_Date__c = create.date();
            pj.Notes__c = 'China reprint, schedule to come from printer';
        }
        
        if(pj.Print_Location__c == 'RR Donnelley US' && pj.Format_Name__c == 'Paperback'){
            pj.Schedule_Override__c = True;
            pj.Files_Approved__c = True;
            pj.Standard_CPU__c = True;
            
            pj.BPI_Forecast_Due__c = null;
            pj.Units_Spec_Due_Date__c = create.date();
            pj.Files_Due_At_Printer__c = pj.Units_Spec_Due_Date__c;
            pj.Estimated_Ship__c = pj.Units_Spec_Due_Date__c + 16;
        }
        
        if(pj.Print_Location__c == 'RR Donnelley US' && pj.Format_Name__c == 'Hardcover'){
            pj.Schedule_Override__c = True;
            pj.Files_Approved__c = True;
            pj.RFQ_Required__c = True;
            
            pj.BPI_Forecast_Due__c = null;
            pj.Units_Spec_Due_Date__c = create.date();
            pj.Files_Due_At_Printer__c = pj.Units_Spec_Due_Date__c;
            pj.Estimated_Ship__c = pj.Units_Spec_Due_Date__c + 21;
        }
        
        return pj;
    }
    
    public static Print_Job__c HydraScheduler(Print_Job__c pj){
        //if this is a domestic 1C work 
        if(pj.Print_Location__c == 'RR Donnelley US' && pj.Format_Name__c == 'Paperback'){
            pj.Schedule_Override__c = True;
            pj.Standard_CPU__c = True;
            pj.Units_Spec_Due_Date__c = pj.Hydra_Sale_Date__c - 56;
            pj.Files_Due_At_Printer__c = pj.Hydra_Sale_Date__c - 56;
            pj.Estimated_Ship__c = pj.Hydra_Sale_Date__c - 35;
            pj.BPI_Forecast_Due__c = pj.Units_Spec_Due_Date__c - 21;
            pj.Notes__c = 'Hydra print job.';
            
        }
        //domestic 1C hardcover work
        if(pj.Print_Location__c == 'RR Donnelley US' && pj.Format_Name__c == 'Hardcover'){
            pj.Schedule_Override__c = True;
            pj.RFQ_Required__c = True;
            pj.Units_Spec_Due_Date__c = pj.Hydra_Sale_Date__c - 84;
            pj.Files_Due_At_Printer__c = pj.Hydra_Sale_Date__c - 63;
            pj.Estimated_Ship__c = pj.Hydra_Sale_Date__c - 35;
            pj.BPI_Forecast_Due__c = pj.Units_Spec_Due_Date__c - 21;
            pj.Notes__c = 'Hydra print job.';
            
        }
        //anything china gets updated to its base schedule
        if(pj.Print_Location__c == 'RR Donnelley China'){
            pj.Schedule_Override__c = True;
            pj.Schedule_Exception__c = True;
            pj.RFQ_Required__c = True;
            pj.Units_Spec_Due_Date__c = pj.Hydra_Sale_Date__c - 140;
            pj.Files_Due_At_Printer__c = pj.Hydra_Sale_Date__c - 126;
            pj.Estimated_Ship__c = pj.Hydra_Sale_Date__c - 84;
            pj.BPI_Forecast_Due__c = pj.Units_Spec_Due_Date__c - 21;
            pj.Notes__c = 'Hydra print job. China schedule to be provided by the printer.';
        }
        return pj;
    }
    
}