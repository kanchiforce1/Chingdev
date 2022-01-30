@isTest(seeAllData=true)
private class PrintJobScheduleUpdateClassTest { 
    static testMethod void PrintSchedulerTest() {
        List<Title__c> titles = new List<Title__c>();
        List<ASIN__c> asin = new List<ASIN__c>();
        List<Print_Job__c> printjobs = new List<Print_Job__c>();
        date pubDate = date.newInstance(2016, 5, 3);
        date hydraDate = date.newInstance(2016, 9, 10);
        
        Title__c t1 = new Title__c(Name = 'Title1', Status__c = 'Production', Language__c = 'English', Internal_Imprint__c ='Montlake Romance');
        titles.add(t1);
        insert(titles);
        
        ASIN__c a1 = new ASIN__c(Name = 'Paperback', ASIN__c = '123', X3p__c = False, 
                                 Title__c = t1.Id, Color_BW_Interior__c = '1/1', APub_Publish_Date__c = pubDate );
        ASIN__c a2 = new ASIN__c(Name = 'Hardcover', ASIN__c = '123', X3p__c = False, 
                                 Title__c = t1.Id, Color_BW_Interior__c = '1/1', APub_Publish_Date__c = pubDate );
        asin.add(a1);
        asin.add(a2);
        insert(asin);
        
        Marketplace__c market1 = new marketplace__c(Name = '1', Format__c =a1.Id, Amazon_Street_Date__c = a1.APub_Publish_Date__c
        );
        
        insert(market1);
        
        Print_Job__c standardPB = new Print_Job__c(Title__c=t1.Id, 
                                                   ASIN_Format__c=a1.Id, 
                                                   Print_Location__c='RR Donnelley US', 
                                                   Job_Type__c='Initial Print Run',
                                                   Print_Job_Status__c='Pending',
                                                   Schedule_Override__c = false);
        
        Print_Job__c standardHC = new Print_Job__c(Title__c=t1.Id, 
                                                   ASIN_Format__c=a2.Id, 
                                                   Print_Location__c='RR Donnelley US', 
                                                   Job_Type__c='Initial Print Run',
                                                   Print_Job_Status__c='Pending',
                                                   Schedule_Override__c = false);
        
        Print_Job__c standardCN = new Print_Job__c(Title__c=t1.Id, 
                                                   ASIN_Format__c=a1.Id, 
                                                   Print_Location__c='RR Donnelley China', 
                                                   Job_Type__c='Initial Print Run',
                                                   Print_Job_Status__c='Pending');
        
        Print_Job__c reprintPB = new Print_Job__c(Title__c=t1.Id, 
                                                  ASIN_Format__c=a1.Id, 
                                                  Print_Location__c='RR Donnelley US', 
                                                  Job_Type__c='Reprint',
                                                  Print_Job_Status__c='Pending',
                                                  Schedule_Override__c = false);
        
        Print_Job__c reprintHC = new Print_Job__c(Title__c=t1.Id, 
                                                  ASIN_Format__c=a2.Id, 
                                                  Print_Location__c='RR Donnelley US', 
                                                  Job_Type__c='Reprint',
                                                  Print_Job_Status__c='Pending',
                                                  Schedule_Override__c = false);
        
        Print_Job__c reprintCN = new Print_Job__c(Title__c=t1.Id, 
                                                  ASIN_Format__c=a1.Id, 
                                                  Print_Location__c='RR Donnelley China', 
                                                  Job_Type__c='Reprint',
                                                  Print_Job_Status__c='Pending');
        
        Print_Job__c hydraPB = new Print_Job__c(Title__c=t1.Id, 
                                                ASIN_Format__c=a1.Id, 
                                                Print_Location__c='RR Donnelley US', 
                                                Job_Type__c='Hydra',
                                                Print_Job_Status__c='Pending',
                                                Hydra_Sale_Date__c = hydraDate,
                                                Schedule_Override__c = false);
        
        Print_Job__c hydraHC = new Print_Job__c(Title__c=t1.Id, 
                                                ASIN_Format__c=a2.Id, 
                                                Print_Location__c='RR Donnelley US', 
                                                Job_Type__c='Hydra',
                                                Print_Job_Status__c='Pending',
                                                Hydra_Sale_Date__c = hydraDate,
                                                Schedule_Override__c = false);
        
        Print_Job__c hydraCN = new Print_Job__c(Title__c=t1.Id, 
                                                ASIN_Format__c=a1.Id, 
                                                Print_Location__c='RR Donnelley China', 
                                                Job_Type__c='Hydra',
                                                Print_Job_Status__c='Pending',
                                                Hydra_Sale_Date__c = hydraDate,
                                                Schedule_Override__c = false);
        
        printjobs.add(standardPB);
        printjobs.add(standardHC);
        printjobs.add(standardCN);
        
        printjobs.add(reprintPB);
        printjobs.add(reprintHC);
        printjobs.add(reprintCN);
        
        printjobs.add(hydraPB);
        printjobs.add(hydraHC);
        printjobs.add(hydraCN);
        
        insert(printjobs);
        
        
        for (Print_Job__c p : printjobs){
            p.BPI_Units__c = 100;
        }
        
        test.startTest();
        update(printjobs);
        market1.Amazon_Street_Date__c = pubDate + 21;
        update(market1);
        test.stopTest();
    } //tests PrintJobScheduleUpdateClass() and PrintSchedulePJUpdate()
    
}