public class PrintOrderCSVCreate {
    //accepts a list of approved and filtered print jobs
    //creates a detailed order form in csv format
    //returned csv is then used as email attachment, and attached to the parent print order
    /*
    public static blob CSVCreate(List<Print_Job__c> pj) {
        //check the list, if its empty return null for validation
        blob csvBlob;
        if(pj.isEmpty()){
            csvBlob = null;
            return csvBlob;
        }else{
            string header = 'Print Job #, Job Type, MAP ID, Format, ISBN-13, Title, Brilliance PO, Total Units, CPU, Files Due, Requested Ship, Proofing Requirements, Notes, Print Location, Trim Width, Trim Height, Page Count, Binding Type, Interior Presswork, Interior Paper, Cover Presswork, Cover Lamination, Cover Effects, Spine (3pc), Sides (3pc), Head/Tail Bands, Foil Type, Endsheet Color, Additional Interior Spec, Additional Cover Spec, Additional Case Spec \n';
            string finalstr = header;
            
            for(Print_Job__c p: pj){
                //string recordstring = '"'+p.Name+'","'+p.Job_Type__c+'","'+p.ASIN_Format__r.MAP_Id__c+'","'+p.ASIN_Format__r.Name+'","'+p.ISBN_13__c+'","'+p.Title__r.Name+'","'+p.Brilliance_PO__c+'","'+p.Total_Units__c+'","'+p.CPU__c+'","'+p.Files_Due_At_Printer__c.format()+'","'+p.Estimated_Ship__c.format()+'","'+p.Proofing_Requirements__c+'","'+p.Notes__c+'","'+p.Print_Location__c+'","';
                //recordstring += p.ASIN_Format__r.Trim_Width__c+'"';
                
                
                //convert decimals to strings for logic check below
                string cpu = string.valueOf(p.CPU__c); 
                string pages = string.valueOf(p.ASIN_Format__r.Page_Count__c);
                
                string recordstring = '"'+p.name+'","'+p.job_type__c+'","'+p.ASIN_Format__r.MAP_Id__c+'","'+p.ASIN_Format__r.Name+'","'+p.ISBN_13__c+'","'+p.Title__r.Name; 
                
                //metadata
                recordstring += '","'+(String.isBlank(p.Brilliance_PO__c)?'':p.Brilliance_PO__c)+'","'+p.Total_Units__c+'","'; 
                
                //cost&units
                if(cpu!=null){
                    recordstring += p.CPU__c;
                }else{
                    recordstring += ' ';
                }
                
                //Dates
                recordstring += '","'+p.Files_Due_At_Printer__c.format()+'","'+p.Estimated_Ship__c.format(); 
                
                //notes
                recordstring += '","'+(String.isBlank(p.Proofing_Requirements__c)?'':p.Proofing_Requirements__c)+'","';
                recordstring += (String.isBlank(p.Notes__c)?'':p.Notes__c)+'","';
                recordstring += p.Print_Location__c+'","'; 
                
                //interior
                recordstring += (String.isBlank(p.ASIN_Format__r.Trim_Width__c)?'':p.ASIN_Format__r.Trim_Width__c)+'","';
                recordstring += p.ASIN_Format__r.Trim_Height__c+'","';
                
                if(pages!=null){
                    recordstring += p.ASIN_Format__r.Page_Count__c;
                }else{
                    recordstring += ' ';
                }
                
                recordstring += '","'+(String.isBlank(p.ASIN_Format__r.Binding_Type__c)?'':p.ASIN_Format__r.Binding_Type__c)+'","';
                recordstring += (String.isBlank(p.ASIN_Format__r.Interior_Press_work__c)?'':p.ASIN_Format__r.Interior_Press_work__c)+'","';
                recordstring += (String.isBlank(p.ASIN_Format__r.Interior_Paper_Stock__c)?'':p.ASIN_Format__r.Interior_Paper_Stock__c)+'","';
                
                //cover
                recordstring += (String.isBlank(p.ASIN_Format__r.Cover_Press_Work__c)?'':p.ASIN_Format__r.Cover_Press_Work__c)+'","';       
                recordstring += (String.isBlank(p.ASIN_Format__r.Cover_Laminate__c)?'':p.ASIN_Format__r.Cover_Laminate__c)+'","';
                recordstring += (String.isBlank(p.ASIN_Format__r.Cover_Effects__c)?'':p.ASIN_Format__r.Cover_Effects__c)+'","';
                
                //case
                recordstring += (String.isBlank(p.ASIN_Format__r.Spine_3pc__c)?'':p.ASIN_Format__r.Spine_3pc__c)+'","';
                recordstring += (String.isBlank(p.ASIN_Format__r.Sides_3pc__c)?'':p.ASIN_Format__r.Sides_3pc__c)+'","';
                recordstring += (String.isBlank(p.ASIN_Format__r.Head_Tail_Bands__c)?'':p.ASIN_Format__r.Head_Tail_Bands__c)+'","';
                recordstring += (String.isBlank(p.ASIN_Format__r.Foil_Type__c)?'':p.ASIN_Format__r.Foil_Type__c)+'","';
                recordstring += (String.isBlank(p.ASIN_Format__r.Endsheet_Color__c)?'':p.ASIN_Format__r.Endsheet_Color__c)+'","';
                
                //additional specs
                recordstring += (String.isBlank(p.ASIN_Format__r.Additional_Interior_Spec__c)?'':p.ASIN_Format__r.Additional_Interior_Spec__c)+'","';
                recordstring += (String.isBlank(p.ASIN_Format__r.Additional_Cover_Spec__c)?'':p.ASIN_Format__r.Additional_Cover_Spec__c)+'","';     
                recordstring += (String.isBlank(p.ASIN_Format__r.Additional_Case_Spec__c)?'':p.ASIN_Format__r.Additional_Case_Spec__c)+'"\n';      
                finalstr = finalstr +recordString;
            }
            csvBlob = blob.valueOf(finalstr);
            return csvBlob;
        }
    }    */
}