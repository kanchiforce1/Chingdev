public class VendorBasedSharingRecalulation implements Database.Batchable<sObject>, Schedulable{

    public List<String> conIds = new List<String>();
    public void execute(SchedulableContext SC) {
      database.executeBatch(new vendorBasedSharingRecalulation(), 1);
   }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        if(!conIds.isEmpty())
           return Database.getQueryLocator('SELECT id FROM Contact WHERE  id=: conIds');
       else
           return Database.getQueryLocator('SELECT id FROM Contact WHERE ApubOps_Community_User__c = true'); 
    
    }
      public vendorBasedSharingRecalulation(List<String> conIds) {
        this.conIds = conIds;
    
    }
     public vendorBasedSharingRecalulation() {
      
    }
    public void execute(Database.BatchableContext bc, List<Contact> records){
        set<Id> uIds = new set<Id>();
        set<Id> conIds = new set<Id>();
        for(Contact c: records)
            conIds.add(c.id);
        for(User u:[SELECT id FROM User WHERE ContactId=:conIds AND isActive=true])
            uIds.add(u.id);
            UserTriggerHandler.shareVendorRecord(uIds);
      
    }    
    public void finish(Database.BatchableContext bc){
        
    }  
    }