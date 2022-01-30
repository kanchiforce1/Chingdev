/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Confirmations
Description: Creates esp records sharing access for community users
***********************************/

public class VendorTriggerHandler {
    
    public static void shareWithVendorCommnityUsers(List<vendor__c> vendors, Map<Id,vendor__c> oldMap) {
       
       Set<String> newEspShareVendorIds = new Set<String>();
       Set<String> removeEspShareVendorIds = new Set<String>();
       if(trigger.isUpdate) {
           for(vendor__c v: vendors) 
               if(v.Chinook_Access__c != oldMap.get(v.id).Chinook_Access__c) {
                   if(v.Chinook_Access__c)
                      newEspShareVendorIds.add(v.id);
                   else
                      removeEspShareVendorIds.add(v.id);     
         
               }
        }   
        
         if(trigger.isInsert) {
           for(vendor__c v: vendors) {
               if(v.Chinook_Access__c)
                  newEspShareVendorIds.add(v.id);
               else
                  removeEspShareVendorIds.add(v.id);     
     
               }
        } 
      if(!newEspShareVendorIds.isEmpty())
          shareEspRecords(newEspShareVendorIds);
      if(!removeEspShareVendorIds.isEmpty())
          removeEspShareRecords(removeEspShareVendorIds);                  
     }  
     @future
    public static void shareEspRecords(Set<String> newEspShareVendorIds) {
       List<SObject> espShare = new List<Sobject>();
       List<esp__c> espList = [SELECT id FROM esp__c WHERE vendor__c!=NULL AND vendor__c=:newEspShareVendorIds]; 
        
        for(User u: [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: newEspShareVendorIds AND isActive = true])
            for(esp__c e: espList)           
                espShare.add(UserTriggerHandler.shareRecords(u.id,e.id, 'Edit','esp__Share'));
      system.debug(espShare);
       insert espShare;          
    }
    
     @future
    public static void removeEspShareRecords(Set<String> removeEspShareVendorIds) {
      
       Set<String> espIds = new Set<String>();
       Set<String> userIds = new Set<String>();
       List<esp__Share> espShrList = new List<esp__Share>();
       for(esp__c e: [SELECT id FROM esp__c WHERE vendor__c!=NULL AND vendor__c=:removeEspShareVendorIds]) 
           espIds.add(e.id);
        for(User u: [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: removeEspShareVendorIds AND isActive = true])
            userIds.add(u.id);
         espShrList = [SELECT id FROM esp__Share WHERE parentid =:espIds AND UserOrGroupId =: userIds];   
         delete espShrList;      
                    
    }
}