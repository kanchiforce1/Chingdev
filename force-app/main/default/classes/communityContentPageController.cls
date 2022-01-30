public with sharing class communityContentPageController {

 /*@AuraEnabled(cacheable=true)
 public static Map<id,title__c> getTitles() {
     
     Map<id,title__c> titles = new Map<Id,title__c>([SELECT id,Marty_Title_ID__c,Status__c,Digital_Publication_Date__c FROM title__c LIMIT 50000]);
     return titles;
 
 } */
 
 @AuraEnabled(cacheable=true)
 public static Map<id,Sobject> getTitles() {
     
     Map<id,Sobject> titles = new Map<Id,Sobject>(PPW_StaticUtils.dynamicQueryListType('title__c','',''));
     return titles;
 
 }
}