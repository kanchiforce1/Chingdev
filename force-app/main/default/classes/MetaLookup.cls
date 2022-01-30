public with sharing class MetaLookup {
    
    public static String FindAuthor(String t){
        List<Title_Contact__c> tc = new List<Title_Contact__c>();
        tc = [SELECT id ,Legal_Name__c FROM Title_Contact__c 
              WHERE Role__c='Author' AND Title__c=:t 
              ORDER BY Contact_Last_Name__c ASC 
              LIMIT 1]; 
               
        if(!tc.isEmpty())
           return tc[0].Legal_Name__c;  
        else 
           return null; 
     
    }
    
    public static String FindContributors(String title, String role){
        List<Title_Contact__c> tc = new List<Title_Contact__c>();
        tc = [SELECT id, name, role__c,Legal_Name__r.id, Legal_Name__r.Name 
              FROM Title_Contact__c 
              WHERE Role__c=:role AND Title__r.Id=:title 
              ORDER BY Legal_Name__r.LastName ASC 
              LIMIT 1];
        
        if(!tc.isEmpty()){
            string cid;
            for(Title_Contact__c c : tc){
                cid = string.valueOf(c.Legal_Name__r.id);  
            }
            system.debug(cid);
            return cid;
            
        }else{
            return null; 
        }
        
    }

    public static List<ASIN__C> FindASINS (string t){
        
        List<ASIN__C> ASINList = new List<ASIN__C>();
        List<ASIN__C> PA = new List<ASIN__C>();
        List<ASIN__C> DA = new List<ASIN__C>();
        
        ASINList = [SELECT id, name FROM ASIN__c WHERE Title__r.id=:t AND Name !='Physical Audio' AND Name!='Digital Audio'];
        PA = [SELECT id, name FROM ASIN__c WHERE Title__r.id=:t AND Name ='Physical Audio' LIMIT 1];
        DA = [SELECT id, name FROM ASIN__c WHERE Title__r.id=:t AND Name ='Digital Audio' LIMIT 1];
        
        ASINList.addAll(PA);
        ASINList.addAll(DA);
                
        if(!ASINList.isEmpty()){
            return ASINList;
        }else{
            return null;
        }
        
    }
    
}
/*
    public static List<Contact> FindContributorSet(Set<Title__c> titles){
        List<Title_Contact__c> tc = new List<Title_Contact__c>();
        tc = [SELECT id, name, role__c,Legal_Name__r.id, Legal_Name__r.Name 
              FROM Title_Contact__c 
              WHERE Role__c=:role AND Title__r.Id=:title 
              ORDER BY Legal_Name__r.LastName ASC 
              LIMIT 1];
        
        if(!tc.isEmpty()){
            string cid;
            for(Title_Contact__c c : tc){
                cid = string.valueOf(c.Legal_Name__r.id);  
            }
            system.debug(cid);
            return cid;
            
        }else{
            return null; 
        }
        
    }
*/