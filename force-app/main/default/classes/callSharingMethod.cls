global with sharing class callSharingMethod {

   
    webservice static void callFromTitle(String titleId) {
    
    database.executeBatch(new titleBasedSharingRecalulation(new List<String> {titleId}), 1);
    
    }
    
     webservice static void callFromContact(String conId) {
    
     database.executeBatch(new vendorBasedSharingRecalulation(new List<String> {conId}), 1);
    
    }
    
 }