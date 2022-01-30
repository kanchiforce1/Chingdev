/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Confirmations
Description: Creates confirmation records sharing access for community users
***********************************/

public class ConfirmationTriggerHandler {
    @future 
    public static void shareWithVendorCommnityUsers(Set<Id> confirmations) {
       set<String> vendorIds = new set<String>();
       Map<String,set<String>> vendorUsersMap = new Map<String,set<String>>();
       List<SObject> conShare = new List<Sobject>();
       for(Confirmation__c c: [SELECT Project_Services__r.vendor__c FROM Confirmation__c WHERE id=:confirmations AND Project_Services__r.vendor__c!=NULL]) 
           vendorIds.add(c.Project_Services__r.vendor__c);
        for(User u: [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: vendorIds AND isActive = true])
            for(String con: confirmations)           
                conShare.add(UserTriggerHandler.shareRecords(u.id,con, 'Edit','Confirmation__Share'));
      
       database.insert(conShare, false);          
    }
     // when cofirmation status change from internal close or rejected than change the ps status
   /*  public static void statuschangeActions(List<Confirmation__c> cNew,Map<Id,Confirmation__c> cOldMap) {
         Set<Id> PsIds = new Set<Id>();
         for(Confirmation__c c: cNew) {
         if((c.status__c != cOldMap.get(c.id).status__c || c.confirmation__c != cOldMap.get(c.id).confirmation__c)  && (c.status__c == 'Internal Closed' ||
             c.confirmation__c  == 'No'))
             PsIds.add(c.Project_Services__c);
         }
        if(!PsIds.isEmpty()) {
            List<Project_Services__c> psUpdate = new List<Project_Services__c>();
            for(Project_Services__c ps: [SELECT id,status__c FROM Project_Services__c WHERE id=:PsIds]) {
                ps.status__c = 'In Planning';
                psUpdate.add(ps);
            }
            Update psUpdate;    
        
        }
               
    } */
}