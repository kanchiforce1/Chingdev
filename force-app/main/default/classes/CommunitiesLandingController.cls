/***********************************
Author: Amazon Apub // michatem@, kkolla@
Visualforce Page Extended:  
Description:
***********************************/

public with sharing class CommunitiesLandingController {

    public String tId;
    public String page;
   
    public CommunitiesLandingController() {
        tId = ApexPages.currentPage().getParameters().get('titleId'); //project service id
        page = ApexPages.currentPage().getParameters().get('page'); //project service id
       selectedTitle = tId;
        system.debug(tid);
       system.debug(page); 
    }

    public String selectedTitle;
    
    public CommunitiesLandingController(ApexPages.StandardController sc) {
        String urlvalue =Apexpages.currentPage().getUrl();
        system.debug(urlvalue);
       
        
    }
    
    public PageReference autoRedirect() {
       
      // sysrem.debug()
     //String  selectedTitle = tId;
        if(page == 'transmittalPage')
           return transmittalPage();
        if(page == 'creativeBriefPage')
           return creativeBriefPage();
        if(page == 'chinookPage')
           return chinookPage();
       return adminHomePage();    
    }
    
    public PageReference transmittalPage() {
        
        PageReference pageRef = new PageReference('/apex/PPW_Transmittal');
        
        pageref.getParameters().put('titleId',tId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
     public PageReference creativeBriefPage() {
         PageReference pageRef = new PageReference('/apex/cb_vext_view?titleId');
          pageref.getParameters().put('titleId',tId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
     public PageReference chinookPage() {
        PageReference pageRef = new PageReference('/apex/esplanding?titleId');
         pageref.getParameters().put('titleId',tId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference adminHomePage() {
        PageReference pageRef = new PageReference('/apex/CommunityHomePage');
        pageref.getParameters().put('titleId',tId);
        pageRef.setRedirect(true);
        return pageRef;
    } 
  
   
  }