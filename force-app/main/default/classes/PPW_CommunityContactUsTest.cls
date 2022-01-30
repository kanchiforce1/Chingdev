@isTest
private class PPW_CommunityContactUsTest {
    
    private static void testdataSetup() {
            
      // title__C t = new title__C(Status__c='TEST',Name='Digital',Marty_Title_ID__c='12345');
       // insert t;
    }
     @isTest static void HomePageControllerTest() {
        
       // testdataSetup();
        title__C t = new title__C(Status__c='TEST',Name='Digital',Marty_Title_ID__c='12345');
        insert t;
     
      
        new PPW_CommunityContactUs().getCaseRecordType();
       
       }  
  }