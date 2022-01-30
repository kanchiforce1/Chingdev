/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Confirmations  
Description: Creates Creative Brief.
***********************************/

public class CreativeBriefTriggerHandler {
   
    public static void beforeInserMethod(List<Creative_Brief__c> beforeNew) {
       //for about to be created Creative Briefs we want to do 2 things before inserting the records...
    //1. Check that the underlying title does not already have a Creative Brief record. If it does, supply an error and dont create it. 
    //2. If this is a new CB on the title, then grab the AQ / BQ information to be mapped to the CB upon creation...
    
    Map<id, Creative_Brief__c> existingCBMap = new Map<id, Creative_Brief__c>();
    Map<id, Book_Questionnaire__c> titleBQMap = new Map<id, Book_Questionnaire__c>();
    Map<id, Author_Questionnaire__c> titleAQMap = new Map<id, Author_Questionnaire__c>();
    Set<string> titleSet = new Set<string>();
    
    for(Creative_Brief__c c : beforeNew){
         titleSet.add(c.title__c);
    }
    
    system.debug(titleSet);
    
    List<Creative_Brief__c> cblst = [SELECT id, name, title__c FROM creative_brief__c ];
    system.debug(cblst);
    
    for(Creative_Brief__c cx : [SELECT id, name, title__c FROM creative_brief__c WHERE title__c =:titleSet]){
        existingCBMap.put(cx.Title__c, cx);
    }
    
   
    
    for(Book_Questionnaire__c bx : [select id, name, title__c, bq_5_3__c, bq_5_4__c, bq_5_5__c, bq_5_6__c, bq_5_7__c, bq_5_10__c, bq_5_11__c, bq_5_13__c, bq_5_14__c, bq_5_15__c 
                                    from book_questionnaire__c 
                                    where title__c =:titleSet]){
                                        titleBQMap.put(bx.Title__c, bx);
                                    }
    
    for(Author_Questionnaire__c ax : [select id, name, title__c from author_questionnaire__c where title__c =:titleSet]){
        titleAQMap.put(ax.Title__c, ax);
    }
    
    //if the title appears within existingCBMap.containsKey() then the title already has a brief.
    //supply an error on the title record
    //if not, then move forward with mapping the AQ/BQ fields to the CB and create.
    //redirect from controller extension wil handle taking the user to the new edit page. 
    
    for(Creative_Brief__c cb : beforeNew){
        if(existingCBMap.containsKey(cb.title__c)){
            //cb already exists, give an error
            system.debug('ther should be an error...');
            cb.Title__c.addError('This title already contains a Creative Brief('+existingCBMap.get(cb.Title__c).Name+'), please go back to the Title and continue on the Creative Brief.');
        }else{
            //we have a new cb so begin mapping fields...
            book_questionnaire__c bq = titleBQMap.get(cb.Title__c);
            author_questionnaire__c aq = titleAQMap.get(cb.Title__c);
            
            //fill in the blanks
            if(bq != null){
                cb.bq_5_3__c = bq.bq_5_3__c;
                cb.bq_5_4__c = bq.bq_5_4__c;
                cb.bq_5_5__c = bq.bq_5_5__c;
                cb.bq_5_6__c = bq.bq_5_6__c;
                cb.bq_5_7__c = bq.bq_5_7__c;
                cb.bq_5_10__c = bq.bq_5_10__c;
                cb.bq_5_11__c = bq.bq_5_11__c;
                cb.bq_5_13__c = bq.bq_5_13__c;
                cb.bq_5_14__c = bq.bq_5_14__c;
                cb.bq_5_15__c = bq.bq_5_15__c;
                cb.ps_Description_of_Characters__c = bq.bq_5_14__c;
            }
            
            //To map to the AQ...     if(aq != null){}
            
        }
       
       
        
    }
    
    
         
    }
   
    @future
    public static void shareWithVendorCommnityUsers(set<Id> cbNew) {
        Set<String> tids = new Set<String>();
        set<String>vIds = new set<String>();
        List<Sobject> createShareList = new List<Sobject>();
        Map<String,String> vendorMap = new Map<String,String>();
        List<Creative_Brief__c> cdNewList = [SELECT id,title__c FROM Creative_Brief__c WHERE id=: cbNew];
        for(Creative_Brief__c cb : cdNewList) 
            tids.add(cb.title__c);
            for(Project_Services__c ps : [SELECT Id,
                                     Service__r.Service_Grouping__c,Vendor__c,Project__c,Project__r.Title__c,Status__c  FROM Project_Services__c WHERE Project__r.Title__c=:tids]) {
    
             
             if(ps.Service__r.Service_Grouping__c != null)
                 if((ps.Service__r.Service_Grouping__c.containsIgnoreCase('Design') || ps.Service__r.Service_Grouping__c.containsIgnoreCase('Promotional')) && (ps.status__c != 'Cancelled' || ps.status__c != 'Killed'))
                     vIds.add(ps.Vendor__c);
            
           }  
     
    
        for(User u: [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: vIds AND isActive = true])
            for(Creative_Brief__c cb : cdNewList)          
                createShareList.add(UserTriggerHandler.shareRecords(u.id,cb.id, 'Read','Creative_Brief__Share'));
      
       insert createShareList;          
    } 
}