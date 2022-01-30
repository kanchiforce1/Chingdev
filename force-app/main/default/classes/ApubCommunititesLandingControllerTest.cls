@isTest
private class ApubCommunititesLandingControllerTest {
    
   
     @isTest static void HomePageControllerTest() {
        
        title__C t = new title__C(Status__c='TEST',Name='Digital',Marty_Title_ID__c='12345');
        insert t;
        
        Test.setCurrentPageReference(new PageReference('Page.CommunitiesLanding')); 
        System.currentPageReference().getParameters().put('titleId', t.id);
        System.currentPageReference().getParameters().put('page', 'transmittalPage');
        
        ApubCommunititesLandingController  ac = new ApubCommunititesLandingController();
        ac.autoRedirect();
        ac.transmittalPage();
        
        }
         @isTest static void HomePageControllerTest1() {
        
        title__C t = new title__C(Status__c='TEST',Name='Digital',Marty_Title_ID__c='12345');
        insert t;
        
        Test.setCurrentPageReference(new PageReference('Page.CommunitiesLanding')); 
        System.currentPageReference().getParameters().put('titleId', t.id);
        System.currentPageReference().getParameters().put('page', 'creativeBriefPage');
        
        ApubCommunititesLandingController  ac = new ApubCommunititesLandingController();
        ac.autoRedirect();
        ac.transmittalPage();
        
        }
        
         @isTest static void HomePageControllerTest2() {
        
        title__C t = new title__C(Status__c='TEST',Name='Digital',Marty_Title_ID__c='12345');
        insert t;
        
        Test.setCurrentPageReference(new PageReference('Page.CommunitiesLanding')); 
        System.currentPageReference().getParameters().put('titleId', t.id);
        System.currentPageReference().getParameters().put('page', 'chinookPage');
        
        ApubCommunititesLandingController  ac = new ApubCommunititesLandingController();
        ac.autoRedirect();
        ac.transmittalPage();
        
        }
        
         @isTest static void HomePageControllerTest3() {
        
        title__C t = new title__C(Status__c='TEST',Name='Digital',Marty_Title_ID__c='12345');
        insert t;
        
        Test.setCurrentPageReference(new PageReference('Page.CommunitiesLanding')); 
        System.currentPageReference().getParameters().put('titleId', t.id);
        //System.currentPageReference().getParameters().put('page', 'chinookPage');
        
        ApubCommunititesLandingController  ac = new ApubCommunititesLandingController();
        ac.autoRedirect();
        ac.transmittalPage();
        
        }
  }