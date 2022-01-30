@isTest
public class PrintOrderCreateTest {
    /*
    
    static testMethod void OrderGeneratorTest() {
        PageReference pageRef = Page.PrintOrderGenerator;
        Test.setCurrentPage(pageRef);
        
        PrintOrderCreate OGT = new PrintOrderCreate();
        OGT.getPrintJobs();
        
        //test the button being clicked. 
        
        
    }
    
    static testMethod void CreateCSVTestGOOD() {
        Date pubDate = date.today();
        Date fileDate = pubdate - 56;
        Date shipDate = pubDate - 35;
        
        List<Title__c> Titles = new List<Title__c>();
        List<ASIN__c> ASINS = new List<ASIN__c>();
        List<Print_Job__c> PJ = new List<Print_Job__c>();
        
        Title__c T1 = new Title__c(Name='Title 1');
        Titles.add(T1);
        insert(Titles);
        
        ASIN__C A1 = new ASIN__c(Title__c=T1.id, Name='Paperback', Trim_Width__c='5.0', Trim_Height__c='8.0', Page_Count__c=352, 
                                 Binding_Type__c='Perfect Bound', Interior_Press_work__c='1-Color', Interior_Paper_Stock__c='50# Trade Paper Cream', 
                                 Cover_Press_Work__c='4', Cover_Laminate__c='Matte', Cover_Effects__c='Embossing', Spine_3pc__c='Rainbow White', Sides_3pc__c='Rainbow Blue', 
                                 Head_Tail_Bands__c='White', Foil_Type__c='Silver', Endsheet_Color__c='Rainbow Silver', Additional_Interior_Spec__c='none', Additional_Cover_Spec__c='none', Additional_Case_Spec__c='none', MAP_ID__c='123456', Apub_Publish_date__c=pubDate);
        ASIN__C A2 = new ASIN__c(Title__c=T1.id, Name='Paperback', Apub_Publish_date__c=pubDate);
        ASIN__C A3 = new ASIN__c(Title__c=T1.id, Name='Paperback', Apub_Publish_date__c=pubDate);
        ASINS.add(A1);
        ASINS.add(A2);
        ASINS.add(A3);
        insert(ASINS);
        
        Print_Job__c P1 = new Print_Job__c(title__c=t1.Id, asin_format__c=a1.Id, Brilliance_PO__c='0123456', BPI_Units__c=500, Files_Approved__c=true, Print_Job_Status__c ='Pending', Files_Due_At_Printer__c=fileDate, Estimated_Ship__c=shipDate, Print_Location__c='RR Donnelley US');//, CPU__c=1.00);
        Print_Job__c P2 = new Print_Job__c(title__c=t1.Id, asin_format__c=a2.Id, Brilliance_PO__c='0123456', BPI_Units__c=500, Files_Approved__c=true, Print_Job_Status__c ='Pending', Files_Due_At_Printer__c=fileDate, Estimated_Ship__c=shipDate, Print_Location__c='RR Donnelley US');
        PJ.add(P1);
        PJ.add(P2);
        insert(PJ);
        
        
        
        PageReference pageRef = Page.PrintOrderGenerator;
        Test.setCurrentPage(pageRef);
        
        PrintOrderCreate OGT = new PrintOrderCreate(); //go to the VF page
        OGT.getPrintJobs();
        
        PrintOrderCreate.CreatePrintOrder(); // "click" the button
    }
    */
}