/***********************************
Author:      Amazon Apub // kkolla@ 
Used By:     ESP__c
Description: Creates ESP records sharing access for community users
***********************************/

public without sharing class ESPTriggerHandler {
    
    public static void shareWithVendorCommnityUsers(List<ESP__c> espLts) {
        set<String> vendorIds = new set<String>();
        Map<String,set<String>> vendorUsersMap = new Map<String,set<String>>();
        List<SObject> conShare = new List<Sobject>();
        for(ESP__c c: espLts) 
            vendorIds.add(c.vendor__c);
        for(User u: [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: vendorIds AND isActive = true])
            for(ESP__c e: espLts)            
                conShare.add(UserTriggerHandler.shareRecords(u.id,e.id, 'Edit','ESP__Share'));
        
        insert conShare;          
    }
}