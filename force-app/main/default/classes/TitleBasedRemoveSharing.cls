global class TitleBasedRemoveSharing implements Database.Batchable<sObject>, Schedulable ,Database.Stateful {

    public List<String> titleIds = new List<String>();
    
     global Map<String,String> titleStatus = new Map<String,String>();// recordsProcessed = 0;
    
     global void execute(SchedulableContext SC) {
         database.executeBatch(new TitleBasedRemoveSharing(), 1);
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(!titleIds.isEmpty())
          return Database.getQueryLocator('SELECT id,  Marty_Title_ID__c FROM title__c WHERE status__c IN (\'Published\') AND id=: titleIds AND ApubOps_Previously_Published__c = false');
       else
           return Database.getQueryLocator('SELECT id,  Marty_Title_ID__c FROM title__c WHERE status__c IN (\'Published\') AND ApubOps_Previously_Published__c = false'); 
    
    }
    
    public titleBasedRemoveSharing(List<String> titleIds) {
        this.titleIds = titleIds;
    
    }
    
     public titleBasedRemoveSharing() {
     
     }
    global void execute(Database.BatchableContext bc, List<title__c> records) {
        set<String> tIds = new set<String>();
        if(!records.isEmpty()) {
            try {
            List<project__c> tprojects = [SELECT PS_Status_Rollup__c FROM project__c WHERE title__c =: records AND PS_Status_Rollup__c = 0 LIMIT 1];
            if(!tprojects.isEmpty()) { 
                removeAllShareRecrods(records[0]);
                titleStatus.put(records[0].Marty_Title_ID__c, 'Success');
            }
            } catch(exception e) { 
                titleStatus.put(records[0].Marty_Title_ID__c, e.getMessage());
            
            }
        }
    }    
    global void finish(Database.BatchableContext bc){
      sendBatchStatusEmail(titleStatus, 'TitleBasedRemoveSharing');
    } 
    
    public static void sendBatchStatusEmail(Map<String,String> titleStatus, String className) {
        String body = '';
        for(String s: titleStatus.keyset()) 
            body = body + s + ' ' + titleStatus.get(s) + '\n';
        OrgWideEmailAddress[] orgEmail = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where address = 'kpav321@gmail.com']; 
      
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[]{ UserInfo.getUserEmail() };
            if(!orgEmail.isEmpty()) 
            mail.setOrgWideEmailAddressId(orgEmail[0].id); 
        mail.setToAddresses(toAddresses);
        mail.setSubject(className);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});    
    
    
    }
    
     // remove all share records related with title logic
    public static void removeAllShareRecrods(title__c tle) {
        if(tle!=null) {
            Title__c t = [SELECT Id,(SELECT id FROM ASINs__r), (SELECT id FROM Creative_Briefs__r) ,(SELECT id FROM Title_Contacts__r),
                            (SELECT Id FROM ESP__r), (SELECT id FROM Projects__r) FROM Title__c WHERE id=:tle.id];
        
            List<title__share> tslst = [SELECT ID FROM title__share WHERE ParentID =: t.id AND RowCause='Manual'];
            delete tslst;
           // List<series__share> sslst = [SELECT ID FROM series__share WHERE ParentID =: t.id AND RowCause='Manual'];
           // delete sslst;
            List<asin__share> aslst = [SELECT ID FROM asin__share WHERE ParentID =: t.ASINs__r AND RowCause='Manual'];
            delete aslst;
            List<esp__share> esplst = [SELECT ID FROM esp__share WHERE ParentID =: t.ESP__r AND RowCause='Manual'];
            delete esplst;
            List<Project__share> plst = [SELECT ID FROM Project__share WHERE ParentID =: t.Projects__r AND RowCause='Manual'];
            delete plst;
            List<Creative_Brief__share> cblst = [SELECT ID FROM Creative_Brief__share WHERE ParentID =: t.Creative_Briefs__r AND RowCause='Manual'];
            delete cblst;
            List<Title_Contact__share> tclst = [SELECT ID FROM Title_Contact__share WHERE ParentID =: t.Title_Contacts__r AND RowCause='Manual'];
            delete tclst;
            //List< Service_Prep__share> spdlst = [SELECT ID FROM Service_Prep__share WHERE ParentID =:spLst AND RowCause='Manual'];
            //delete splst;
            
            //List<Service_Prep_Response__share> sprlst = [SELECT ID FROM Service_Prep_Response__share WHERE ParentID =:spr AND RowCause='Manual'];
           // delete sprlst;
           tle.ApubOps_Previously_Published__c = true;
           update tle;
         }
         
      //  sharingRecalculation(tadd);
    
    }
   
    }