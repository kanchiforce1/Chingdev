@isTest(seeAllData=true)
private class PrintJobCreateTest {
    
    static testMethod void createTest() {
        List<Title__c> titles = new List<Title__c>();
        List<ASIN__c> asin = new List<ASIN__c>();
        date pubDate = date.newInstance(2016, 5, 3);
        
        
        Title__c t1 = new Title__c(Name = 'Title1', Status__c = 'Contracted', Language__c = 'English', Internal_Imprint__c ='Montlake Romance');
        Title__c t2 = new Title__c(Name = 'Title1', Status__c = 'Contracted', Language__c = '', Internal_Imprint__c ='47North');
        Title__c t3 = new Title__c(Name = 'Title2', Status__c = 'Contracted', Language__c = 'English', Internal_Imprint__c ='Two Lions');
        Title__c t4 = new Title__c(Name = 'Title3', Status__c = 'Contracted', Language__c = 'English', Internal_Imprint__c ='Jet City Comics');
        titles.add(t1);
        titles.add(t2);
        titles.add(t3);
        titles.add(t4);
        insert(titles);
        
        ASIN__c a1 = new ASIN__c(Name = 'Paperback', ASIN__c = '123456', X3p__c = False, Title__c = t1.Id, Color_BW_Interior__c = '1/1', APub_Publish_Date__c = pubDate );
        ASIN__c a2 = new ASIN__c(Name = 'Paperback', ASIN__c = '123456', X3p__c = False, Title__c = t2.Id, Color_BW_Interior__c = '1/1', APub_Publish_Date__c = pubDate );
        ASIN__c a3 = new ASIN__c(Name = 'Hardcover', ASIN__c = '123456', X3p__c = False, Title__c = t3.Id, Color_BW_Interior__c = '4/4', APub_Publish_Date__c = pubDate );
        ASIN__c a4 = new ASIN__c(Name = 'Paperback', ASIN__c = '123456', X3p__c = False, Title__c = t4.Id, Color_BW_Interior__c = '4/4', APub_Publish_Date__c = pubDate );
        ASIN__c a5 = new ASIN__c(Name = 'Paperback', ASIN__c = '123456789', X3p__c = True, Title__c = t1.Id, Color_BW_Interior__c = '1/1', APub_Publish_Date__c = pubDate );
        ASIN__c a6 = new ASIN__c(Name = 'Hardcover', ASIN__c = '123456454', X3p__c = False, Title__c = t1.Id, Color_BW_Interior__c = '1/1', APub_Publish_Date__c = pubDate );
        ASIN__c a7 = new ASIN__c(Name = 'Paperback', ASIN__c = '123456', X3p__c = False, Title__c = t3.Id, Color_BW_Interior__c = '4/4', APub_Publish_Date__c = pubDate );
        ASIN__c dupe = new ASIN__c(Name = 'Paperback', ASIN__c = '123456', X3p__c = False, Title__c = t1.Id, Color_BW_Interior__c = '4/4', APub_Publish_Date__c = pubDate );
        ASIN__c exp = new ASIN__c(Name = 'Paperback', ASIN__c = '123456', X3p__c = False, Title__c = t1.Id, Color_BW_Interior__c = '', APub_Publish_Date__c = pubDate );
        asin.add(a1);
        asin.add(a2);
        asin.add(a3);
        asin.add(a4);
        asin.add(a5);
        asin.add(a6);
        asin.add(a7);
        asin.add(dupe);
        asin.add(exp);
        insert(asin);
        
        Print_Job__c pj = new Print_Job__c(Title__c=t1.Id, ASIN_Format__c=dupe.Id, Print_Location__c='RR Donnelley US');
        insert(pj);
        
        Test.startTest();
        
        t1.Status__c = 'In Production';
        update(t1);
        
        t2.Status__c = 'Cancelled';
        update(t2);
        
        t3.Status__c = 'Production';
        update(t3);
        
        t4.Status__c = 'Art In Progress';
        update(t4);
        
        Test.stopTest();
    }
    
}