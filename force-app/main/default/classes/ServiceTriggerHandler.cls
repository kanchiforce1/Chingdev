/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Confirmations
Description: Creates CreativeBrief records sharing access for community users
***********************************/

public class ServiceTriggerHandler {
    
    public static void shareWithVendorCommnityUsers(List<Service__c> services, Map<Id,Service__c> oldMap) {
       
       Set<String> newCBShareVendorIds = new Set<String>();
       Set<String> removeCBShareVendorIds = new Set<String>();
       Map<String, project_services__c> psMap = new Map<String, project_services__c>();
       Set<String> titlesId = new Set<String>();
       for(Project_Services__c ps: [SELECT id,service__c,project__r.title__c,Vendor__c,status__c FROM Project_Services__c WHERE service__c=: services AND Vendor__c!=null])  {
           psMap.put(ps.service__c,ps);
           titlesId.add(ps.project__r.title__c);
       }    
       if(trigger.isUpdate) {
           for(Service__c s: services) 
               if(s.Service_Grouping__c != oldMap.get(s.id).Service_Grouping__c && psMap.containsKey(s.id)) {
                   if(s.Service_Grouping__c!=null) {
                       if(s.Service_Grouping__c.containsIgnoreCase('Design') || s.Service_Grouping__c.containsIgnoreCase('Promotional') && (psMap.get(s.id).status__c != 'Cancelled' && psMap.get(s.id).status__c != 'Killed'))
                           newCBShareVendorIds.add(psMap.get(s.id).vendor__c);
                       else
                           removeCBShareVendorIds.add(psMap.get(s.id).vendor__c);  
                   } else
                         removeCBShareVendorIds.add(psMap.get(s.id).vendor__c);     
         
               }
        }   
        
    
      if(!newCBShareVendorIds.isEmpty())
          shareCBRecords(newCBShareVendorIds,titlesId);
      if(!removeCBShareVendorIds.isEmpty())
          removeCBShareRecords(removeCBShareVendorIds,titlesId);                  
     }  
     @future
    public static void shareCBRecords(Set<String> newCBShareVendorIds,Set<String> titlesId) {
       List<SObject> CBShare = new List<Sobject>();
       Set<String> cbIds = new Set<String>();
       List<Creative_Brief__c> cbList = [SELECT id FROM Creative_Brief__c WHERE title__c=:titlesId];          
        
        for(User u: [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: newCBShareVendorIds AND isActive = true])
            for(Creative_Brief__c e: cbList)           
                CBShare.add(UserTriggerHandler.shareRecords(u.id,e.id, 'Read','Creative_Brief__Share'));
       system.debug(CBShare);
       insert CBShare;          
    }
  // additional titles,asin,title contact share for while giving cb share
    public static void shareAdditionalTitles() {
        
        
        
        
    }
     @future
    public static void removeCBShareRecords(Set<String> removeCBShareVendorIds,Set<String> titlesId) {
      
       Set<String> cbIds = new Set<String>();
       Set<String> userIds = new Set<String>();
    //   Set<String> tId = new Set<String>();
       Set<String> psIds = new Set<String>();
      // Set<String> serviceIds = new Set<String>();
       
       for(project_services__c ps: [select id,service__r.Service_Grouping__c from project_services__c where project__r.title__c =:titlesId and status__C != 'Cancelled' and status__c !='Killed' and service__c!=null and service__r.Service_Grouping__c != null]) 
            if(ps.service__r.Service_Grouping__c.containsIgnoreCase('Design') || ps.service__r.Service_Grouping__c.containsIgnoreCase('Promotional')) {
                psIds.add(ps.id);
            }
       
       
       List<Creative_Brief__Share> cbShrList = new List<Creative_Brief__Share>();
       for(Creative_Brief__c e: [SELECT id FROM Creative_Brief__c WHERE title__c=:titlesId]) 
           cbIds.add(e.id);
        for(User u: [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: removeCBShareVendorIds AND isActive = true])
            userIds.add(u.id);
         if(psIds.isEmpty()) {    
        cbShrList = [SELECT id FROM Creative_Brief__Share WHERE parentid IN (SELECT id FROM Creative_Brief__c WHERE title__c=:titlesId) AND UserOrGroupId IN (SELECT  id FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: removeCBShareVendorIds AND isActive = true)];   
        delete cbShrList;  
        }    
                    
    }
}