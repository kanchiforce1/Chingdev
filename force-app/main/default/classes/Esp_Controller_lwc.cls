public with sharing class Esp_Controller_lwc { 
 
 
 @AuraEnabled
 public static String newEspRecord(String ESP) {
     Esp__c espp = (Esp__c)JSON.deserialize(ESP, Esp__c.class);
     Group g = [SELECT id,name,type FROM Group WHERE developername = 'Editorial_Quality_Group' and type = 'Queue'];
     espp.ownerId=g.id;
     Insert espp;
     return espp.id;
 
 }
 
 @AuraEnabled
 public static List<SObject> getESPRecords(String titleId) {
     String sObjName = 'ESP__C';
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
      Map <String, Schema.SObjectField> fieldMap = schemaMap.get(sObjName).getDescribe().fields.getMap();
            String query='SELECT ';
            query += string.join(new List<String>(fieldMap.keyset()),',');
          //  query = query.removeend(',');
            query = query + ',Title__r.Marty_Title_ID__c,Title__r.Name ';            
            query = query+ ' FROM '+ sObjName;
     
       query = query+ ' WHERE Title__r.Marty_Title_ID__c = \''+titleId + '\'';
           
            System.debug(query);
            List<SObject> sObjeList = database.query(query);
    // List<ESP__c> ESPList = new List<ESP__C> ([SELECT id, name,ESP_Status__c, Title__r.Marty_Title_ID__c, FROM ESP__c WHERE Title__r.Marty_Title_ID__c = : titleId]);
 
     return sObjeList;
 }
 
 }