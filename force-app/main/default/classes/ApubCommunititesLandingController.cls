/***********************************
Author: Amazon Apub // michatem@, kkolla@
Visualforce Page Extended:  
Description:    NOT USING     NOT USING
***********************************/

public with sharing class ApubCommunititesLandingController {

    public String tId;
    public String page;
   
    public ApubCommunititesLandingController() {
        tId = ApexPages.currentPage().getParameters().get('titleId'); //project service id
        page = ApexPages.currentPage().getParameters().get('page'); //project service id
      
       // System.debug('is now decoded as: ' + afterblob.toString());
        
       // Blob afterblob = EncodingUtil.base64Decode(paramvalue);
        
       selectedTitle = tId;
        system.debug(tid);
       system.debug(page); 
    }

    public String selectedTitle;
  
    public void link() {
    
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
         PageReference pageRef = new PageReference('/apex/cb_vext_view');
          pageref.getParameters().put('titleId',tId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
     public PageReference chinookPage() {
        PageReference pageRef = new PageReference('/apex/esplanding');
         pageref.getParameters().put('titleId',tId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference adminHomePage() {
       PageReference pageRef = new PageReference('/apex/Apub_CommunityHomePage');
     //   PageReference pageRef = new PageReference('/transmittal-form');
       // pageref.getParameters().put('titleId',tId);
        //pageRef.setRedirect(true);
        pageRef.setRedirect(false);
        return pageRef;
       //return null;
    } 
  
   
  }