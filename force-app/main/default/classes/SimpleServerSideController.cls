public with sharing class SimpleServerSideController { 
 
 
 @AuraEnabled
 public static Account getRecord() {
     return [select name,createdby.Name from account limit 1];
 
 }
 
 }