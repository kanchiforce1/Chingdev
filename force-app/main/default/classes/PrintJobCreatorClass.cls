public class PrintJobCreatorClass {
    public static list<print_Job__c> printFromASIN(list<asin__c> asinsToAddPrint){
        list<print_job__c> newPrintJobs = new list<Print_Job__c>();
        list<Vendor__c> printer = new list<Vendor__c>([SELECT id FROM Vendor__c WHERE Name = 'RR Donnelley & Sons' LIMIT 1]);
        map<id, id> usMarketplaceMap = new map<id, id>();
        
        for(marketplace__c m : [SELECT id, Name, Format__c FROM Marketplace__c WHERE Format__c IN :asinsToAddPrint AND Name = 'Amazon.com']){
            usMarketplaceMap.put(m.Format__c, m.id);
        }
        
        for(ASIN__c a : asinsToAddPrint){
            Print_Job__c p = new Print_Job__c();
            
            p.Title__c = a.Title__c;
            p.ASIN_Format__c = a.Id;
            p.Printer__c = printer.get(0).id;
            if(usMarketplaceMap.containsKey(a.Id)){p.Marketplace__c = usMarketplaceMap.get(a.Id);}
            p.Job_Type__c = 'Initial Print Run';
            p.Print_Job_Status__c = 'Pending';
            p.Schedule_Exception__c = false;
            p.Schedule_Override__c = false;
            
            if(a.Color_BW_Interior__c == '1/1' && a.Name == 'Paperback'){ //standard apub paperback
                p.Print_Location__c = 'RR Donnelley US';
            }else if(a.Color_BW_Interior__c == '1/1' && a.Name == 'Hardcover'){ //1C Hardcover
                p.Print_Location__c = 'RR Donnelley US';
            }else if(a.Color_BW_Interior__c != '1/1' && a.Color_BW_Interior__c != '' && (a.Name == 'Hardcover' || a.Name == 'Paperback') && a.Title__r.Internal_imprint__c == 'Two Lions'){ //TL Hardcover
                p.Print_Location__c = 'RR Donnelley China';
            }else if(a.Color_BW_Interior__c != '1/1' && a.Color_BW_Interior__c != '' && a.Title__r.Internal_imprint__c == 'Jet City Comics'){
                p.Print_Job_Status__c = 'Attention Required';
                p.notes__c = 'JCC requires RFQ and confirmed scheduled with printer.';
            }else{
                p.Print_Job_Status__c = 'Attention Required';
                p.notes__c = 'Unable to autoset print details based on Title, ASIN, or Marketplace information at creation. Please manually check.';
                p.Schedule_Exception__c = true;
            }
            newPrintJobs.add(p);
        }
        return newPrintJobs;
    }
}