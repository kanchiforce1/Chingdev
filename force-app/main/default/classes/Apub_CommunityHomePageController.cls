/***********************************
Author: Amazon Apub // michatem@, kkolla@
Visualforce Page Extended:  
Description:
***********************************/

public with sharing class Apub_CommunityHomePageController{
    public string tId;
    public Apub_CommunityHomePageController() {
        tId = ApexPages.currentPage().getParameters().get('titleId'); //project service id
        if(tId != null) {
            Blob afterblob = EncodingUtil.base64Decode(tId);
            System.debug('is now decoded as: ' + afterblob.toString());
            tId = afterblob.toString();
        }
     
        selectedTitle = tId;
        transimittalBtn = false;
        cbBtn = false;
       // url = null;  // unused
        chinookBtn = false;
        if(tId!=null)
        checkBtnsAccess();
    }
    //public string url{get;set;}
    public boolean transimittalBtn{get;set;}
    public boolean cbBtn{get;set;}
    public boolean chinookBtn{get;set;}
    public String selectedTitle{get;set;}
    public list<selectOption> titleOptions {
        get{
            
            return loadTitlesOptions();
            
        }
        set;
    }
    
    public void selectTitle() {
        system.debug(selectedTitle);
        if(selectedTitle!='')
            tId = selectedTitle;
        else
            selectedTitle =  tId;    
        checkBtnsAccess();
    }
    
    // titles access and generate picklist values
    public List<selectOption> loadTitlesOptions() {
        List<selectOption> titles = new  List<selectOption>();
        titles.add(new selectOption('' ,'-- None -- '));
        for(title__c t: [SELECT Marty_Title_ID__c,Name FROM Title__c WHERE Marty_Title_ID__c != NULL]) 
            titles.add(new selectOption(t.Marty_Title_ID__c ,t.Marty_Title_ID__c + ' - '+ t.Name));
        return titles;
        
    }
    
    public Apub_CommunityHomePageController(ApexPages.StandardController sc) {
        
    }
    
    
    public void link() {
    
    }
    
    public PageReference transmittalPage() {
       
        System.debug('selectedTitle'+selectedTitle);
         if(transimittalBtn) {
        PageReference pageRef = new PageReference('/apex/PPW_Transmittal');
       
            pageref.getParameters().put('titleId',selectedTitle);
            pageRef.setRedirect(true);
         //  url = '/pavTest/s/sfdcpage/apex/PPW_Transmittal?titleId='+selectedTitle;
            return pageRef;
        }
        return null;
    }
    
    public PageReference creativeBriefPage() {
     if(cbBtn) {
        PageReference pageRef = new PageReference('/apex/cb_vext_view');
            pageref.getParameters().put('titleId',selectedTitle);
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }
    
    public PageReference chinookPage() {
     if(chinookBtn) {
        PageReference pageRef = new PageReference('/apex/esplanding');
            pageref.getParameters().put('titleId',selectedTitle);
            pageRef.setRedirect(true);
             return pageRef;
        }
        return null;
    
    }
    
    
    
    public void checkBtnsAccess() {
        system.debug(tId);
        // check creative brief access
        List<Creative_Brief__c> cbLst = [SELECT id FROM Creative_Brief__c WHERE Title__r.Marty_Title_ID__c =: tId AND Title__r.Marty_Title_ID__c != null];
        cbBtn = cbLst.size()>0? true : false;
       // List<esp__c> espLst = [SELECT id FROM esp__c WHERE Title__r.Marty_Title_ID__c =: tId AND Title__r.Marty_Title_ID__c != null];
       // chinookBtn = espLst.size()>0? true:false;
       
        // check chinook access
        List<User> uLst = [SELECT  Contact.Vendor__c,Contact.Vendor__r.Chinook_Access__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND id=: Userinfo.getUserId() limit 1];
        if(uLst.size()>0) {
            if(uLst[0].Contact.Vendor__r.Chinook_Access__c)
                chinookBtn = true;
            else
                chinookBtn = false;  
           // check trasmittal form access       
            List<project_services__c> psLst = [select id from project_services__c where project__r.title__r.Marty_Title_ID__c=:tId AND project__r.title__r.Marty_Title_ID__c != NULL AND vendor__c =:uLst[0].Contact.Vendor__c];
            
            transimittalBtn = psLst.size()>0? true: false;
        } else
            transimittalBtn = false;
        
    }
    
    
    
}