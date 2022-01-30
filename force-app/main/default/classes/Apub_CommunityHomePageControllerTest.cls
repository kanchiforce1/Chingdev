@isTest
private class Apub_CommunityHomePageControllerTest {
    
    private static void testdataSetup() {
            
      // title__C t = new title__C(Status__c='TEST',Name='Digital',Marty_Title_ID__c='12345');
       // insert t;
    }
     @isTest static void HomePageControllerTest() {
        
       // testdataSetup();
        title__C t = new title__C(Status__c='TEST',Name='Digital',Marty_Title_ID__c='12345');
        insert t;
        
        Blob b = blob.valueof('12345');
        String title = EncodingUtil.base64Encode(b); 
        
        PageReference myVfPage = Page.Apub_CommunityHomePage;
        Test.setCurrentPage(myVfPage);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('titleId',String.valueOf(title));//.toString());
        ApexPages.StandardController sc;
        Apub_CommunityHomePageController chp = new Apub_CommunityHomePageController();
        Apub_CommunityHomePageController chps = new Apub_CommunityHomePageController(sc);
        chp.transmittalPage();
        chp.transmittalPage();
        list<selectOption> sp = chp.titleOptions;
        chp.transmittalPage();
        chp.creativeBriefPage();
        chp.chinookPage();
        chp.selectTitle();
        chp.link();
        chp.transimittalBtn = true;
        chp.cbBtn = true;
        chp.chinookBtn = true;
        chp.transmittalPage();
        chp.transmittalPage();
        //list<selectOption> sp = chp.titleOptions;
        chp.transmittalPage();
        chp.creativeBriefPage();
        chp.chinookPage();
        chp.selectTitle();
        new PPW_CommunityContactUs().getCaseRecordType();
       
       // String id = ApexPages.currentPage().getParameters().get('id');
       // System.assert('true',id==null);
       }  
  }