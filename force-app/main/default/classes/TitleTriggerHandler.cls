/***********************************
Author:      Amazon Apub // kkolla@
Used By:     
Description: 
***********************************/

public class TitleTriggerHandler {//,Schedulable{
    
    //helper methods
    public static map<string, id> userAliasMapper(){
        Map<string, id> userAliasMap = new Map<string, id>();
        for(User u : [SELECT id, Name, Alias FROM User WHERE isActive = true]){
            userAliasMap.put(u.Alias, u.id);
        }
        return userAliasMap;
    }
    
    
    //after update methods
    public static void autoCreate_CreativeBrief(list<Title__c> TriggerNew, map<id,Title__c> TriggerOldMap) {
        map<string, id> userAliasMap = new map<string, id>();
        map<id, creative_brief__c> titleCBMap = new map<id, creative_brief__c>();
        
        list<Title__c> contractedTitles = new list<Title__c>();
        list<creative_brief__c> newCB = new list<creative_brief__c>();
        
        set<id> contractedTitleIDs = new set<id>();
        
        for (Title__c t : TriggerNew){
            if(t.Status__c == 'Contracted' && t.Status__c != TriggerOldMap.get(t.id).Status__c){
                //status changed, isolate the newly contracted titles
                contractedTitles.add(t);
                contractedTitleIDs.add(t.Id);
            }
        }
        
        if(!contractedTitles.isEmpty()){
            
            userAliasMap = userAliasMapper();
            
            for(Creative_Brief__c cb : [SELECT id, Name, Title__c FROM Creative_Brief__c WHERE Title__c in :contractedTitleIDs]){
                titleCBMap.put(cb.Title__c, cb);
            }
            
            for (Title__c ct : contractedTitles) {
                if(!titleCBMap.containsKey(ct.Id) && ct.Internal_Imprint__c != 'Two Lions'){
                    Creative_Brief__c ncb = new Creative_Brief__c ();
                    ncb.Title__c = ct.Id;
                    if(userAliasMap.containsKey(ct.Current_Editor__c)){ncb.OwnerId = userAliasMap.get(ct.Current_Editor__c);}
                    newCB.add(ncb);
                }
            }
            insert(newCB);
        }
    }
    
   /* public static void autoCreate_CoverApproval(list<Title__c> TriggerNew, map<id,Title__c> TriggerOldMap) {
        map<string, id> userAliasMap = new map<string, id>();
        map<id, creative_brief__c> titleCBMap = new map<id, creative_brief__c>();
        map<id, cover_approval__c> titleCAMap = new map<id, cover_approval__c>();
        
        list<Title__c> contractedTitles = new list<Title__c>();
        list<cover_approval__c> newCA = new list<cover_approval__c>();
        
        set<id> contractedTitleIDs = new set<id>();
        
        string cbURL = System.URL.getSalesforceBaseUrl().toExternalForm() + '/';
        
        userAliasMap = userAliasMapper();
        
        for (Title__c t : TriggerNew){
            if(t.Status__c == 'Contracted' && t.Status__c != TriggerOldMap.get(t.id).Status__c){
                //status changed, isolate the newly contracted titles
                contractedTitles.add(t);
                contractedTitleIDs.add(t.Id);
            }
        }
        
        if(!contractedTitles.isEmpty()){
            for(Creative_Brief__c cb : [SELECT id, Name, Title__c FROM Creative_Brief__c WHERE Title__c in :contractedTitleIDs]){
                titleCBMap.put(cb.Title__c, cb);
            }
            
            for(Cover_Approval__c ca : [SELECT id, Name, Title__c FROM Cover_Approval__c WHERE Title__c IN :contractedTitleIDs]){
                titleCAMap.put(ca.title__c, ca);
            }
            
            for (Title__c ct : contractedTitles){
                if(!titleCAMap.containsKey(ct.Id)){ //no current ca, so create a new one
                    if(ct.Production_Locale__c == 'US'){
                        Cover_Approval__c nca = new Cover_Approval__c();
                        nca.Title__c = ct.Id;
                        
                        if(userAliasMap.containsKey(ct.Production_Manager__c)){
                            nca.OwnerId = userAliasMap.get(ct.Production_Manager__c);
                        }else if(userAliasMap.containsKey(ct.Art_Director__c)){
                            nca.OwnerId = userAliasMap.get(ct.Art_Director__c);
                        }
                        
                        if(titleCBMap.containsKey(ct.Id)){
                            Creative_Brief__c cb = titleCBMap.get(ct.Id);
                            nca.Creative_Brief_Lng__c = cbURL + cb.Id;
                        }
                        newCA.add(nca);
                    }
                }
            }
            insert(newCA);
        }
    }
    */
   /* public static void autoCreate_PrintJob(list<Title__c> TriggerNew, map<id,Title__c> TriggerOldMap) {
        list<print_job__c> newPrintJobs = new list<Print_Job__c>();
        list<ASIN__c> asinsToAddPrint = new list<ASIN__c>();
        list<Title__c> productionTitles = new list<Title__c>();
        
        set<id> productionTitleIDs = new set<id>();
        
        for (Title__c t : TriggerNew) {
            if (t.status__c != TriggerOldMap.get(t.Id).status__c && (t.Status__c == 'In Production' || t.Status__c == 'Art In Progress')) { 
                productionTitles.add(t);
                productionTitleIDs.add(t.Id);
            } 
        }
        
        if(!productionTitles.isEmpty()){
            asinsToAddPrint = [SELECT id, Name, Title__c, x3p__c, Color_BW_Interior__c, APub_Publish_Date__c, 
                               Title__r.Internal_Imprint__c
                               FROM ASIN__c 
                               WHERE Name NOT IN ('Digital', 'Digital Audio', 'Physical Audio')
                               AND Title__c IN :productionTitleIDs
                               AND Title__r.Production_Locale__c IN ('US', 'UK')
                               AND x3p__c = false
                               AND id NOT IN (SELECT ASIN_Format__c FROM Print_Job__c WHERE Print_Job_Status__c != 'Complete')
                              ];
        }
        
        if(!asinsToAddPrint.isEmpty()){
            newPrintJobs = PrintJobCreatorClass.printFromASIN(asinsToAddPrint);
        }
        insert(newPrintJobs);
    }
    
    */
    public static void setProductionLocale(list<Title__c> TriggerNew) {
        for(Title__c t : TriggerNew){
            t.Production_Locale__c = TitleProductionLocaleCalculator.calculateProductionLocale(t);
        }
    } 
    
    /** remove all sharing for vendor user when title status changed to published **/  
     public static void removeAllShare(Map<Id,title__c> newMap, Map<Id,title__c> oldMap) {
        
      /*   List<String> tIdsDel = new List<String>();
         List<String> tIdsAdd = new List<String>();
         for(title__c t: newMap.values()) {
             if(oldMap.get(t.id).Status__c != t.Status__c && String.isNotBlank(t.status__c))
                 if(t.status__c.equalsIgnoreCase('Published'))
                     tIdsDel.add(t.id);
                     
              if(oldMap.get(t.id).Status__c != t.Status__c && String.isNotBlank(t.status__c))
                  if(t.Status__c.equalsIgnoreCase('Contracted') || t.Status__c == 'In Translation' || t.Status__c == 'In Production')
                
                     tIdsAdd.add(t.id);        
                      
         }            
         for(id tid : newMap.keyset())  {   // for time being commenting below batches because of hiting async limit hitting in prod, we can run batch manually
             // database.executeBatch(new titleBasedRemoveSharing(tIdsDel), 1);
             // database.executeBatch(new titleBasedSharingRecalulation(tIdsAdd), 1);
         }    
        */
     }
     
    // public static List<project__c> proList = new list<project__c>();
    /** create new project when we create/update the title record **/  
     public static void createProject(list<Title__c> TriggerNew,map<Id,Title__c> Triggerold){
      list<Project__c> proInsertList = new list<Project__c>();
     list<title__C> tiList = new List<title__C>();
     List<project__C> proList = new List<project__C>();
     proList = [Select id from project__c where title__c=: TriggerNew];
     Id proRecordtype = Schema.SObjectType.Project__c.getRecordTypeInfosByName().get('Title_Project').getRecordTypeId();

        if(proList.size()==0){
          if(trigger.isInsert)
           for(title__C t: TriggerNew){
                if(t.status__C!=null)
                    if(label.StatusCheckProjectCreation.contains(t.Status__c)){
                     project__c p =new project__c(title__C = t.id,RecordTypeId=proRecordtype);
                     proInsertList.add(p);
                     }
                
                }
         
        if(trigger.isupdate){
            for(title__C t: TriggerNew)
                if(t.status__C!=null)
            if(Triggerold.get(t.id).status__C!=t.status__c && label.StatusCheckProjectCreation.contains(t.Status__c))
                if(label.StatusCheckProjectCreation.contains(t.Status__c)){
                   project__c p =new project__c(title__C = t.id,RecordTypeId=proRecordtype);
                   proInsertList.add(p);
                 }  
        } 
        } 
        insert proInsertList;
     
     
     }
     
       /** make ps status is cancelled when we update the title status is cancelled **/  
     public static void psRecordsCancelled(list<Title__c> TriggerNew,map<Id,Title__c> Triggerold) {
      list<Project_services__c> proInsertList = new list<Project_services__c>();
      Map<String,project_services__c> kickedOffservices = new Map<String, project_services__c>();
     list<title__C> tiList = new List<title__C>();
     List<Id> lsttitleIds = new List<Id>();
          if(trigger.isupdate) {
            for(title__C t: TriggerNew)
                    if(Triggerold.get(t.id).status__C!=t.status__c && t.status__C!=null)
                        if(label.PPW_titleCancelled.contains(t.Status__c)) 
                            lsttitleIds.add(t.Id);
                   
        } 
      for(project_services__c ps: [SELECT id,status__c,project__r.Title__r.Production_Locale__c,vendor__c,service__r.Service_Rate_Type__c,service__r.name, Project__c,Project__r.title__r.id
                                   FROM project_services__c WHERE status__c != 'Cancelled' AND status__c!= 'Completed' AND project__r.title__c=: lsttitleIds]) {
          if(ps.status__c == 'Kicked Off') {
              ps.status__c = 'Killed';
             kickedOffservices.put(ps.Id,ps);
         } else ps.status__c =  'Cancelled';   
          proInsertList.add(ps);
      }  
        update proInsertList;
     if(!kickedOffservices.isEmpty()) {
         RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType='Case' AND Name='Kill Submissions'];
         Map<String,Group> localeGroup = new Map<String,Group>();
         for(Group g: [SELECT Id,DeveloperName FROM Group WHERE Type='Queue' AND (DeveloperName='VM_EU_Internal' OR DeveloperName='VM_US_Internal')])
             localeGroup.put(g.DeveloperName, g);
       
         List<User> ulst = [SELECT Id FROM User WHERE alias='kkolla'];
         String defaultOwnerid = !ulst.isEmpty()? ulst[0].Id: Userinfo.getUserid();//[SELECT Id FROM User WHERE alias='kkolla'].id;
         for(project_services__c ps: kickedOffservices.values())
             createCase(ps, rt, localeGroup, defaultOwnerid);
     }
   
   }
     public static void createCase(project_services__c x, RecordType rt,  Map<String,Group> localeGroup,  String defaultOwnid) {
      Group gp;   // for time being commented
                      String defaultOwnerid;
       String prodLocale = x.project__r.Title__r.Production_Locale__c;
          if(prodLocale != null) {
              if(prodLocale.equalsIgnoreCase('US')) 
                  gp = localeGroup.get('VM_US_Internal'); 
              else 
                  if(prodLocale.equalsIgnoreCase('EU') || prodLocale.equalsIgnoreCase('DE') || prodLocale.equalsIgnoreCase('ES') || prodLocale.equalsIgnoreCase('FR') || prodLocale.equalsIgnoreCase('IN') || prodLocale.equalsIgnoreCase('IT') || prodLocale.equalsIgnoreCase('JP') || prodLocale.equalsIgnoreCase('UK')) 
                  gp = localeGroup.get('VM_EU_Internal');
              else
                  defaultOwnerid = defaultOwnid;    
          } else       
              defaultOwnerid = defaultOwnid;
          case ca = new Case(RecordTypeId=rt.id,Priority='Medium',
                             Title__c = x.Project__r.title__r.id,Project__c = x.Project__c,
                             Project_Service__c = x!=null? x.id : null,Service__c = x.service__c!=null?x.service__r.name : '',
                             Service_Type__c = x.service__c!=null? x.service__r.Service_Rate_Type__c : '', 
                             Vendor__c = x.Vendor__c!=null? x.Vendor__c : null,
                             status='Open',
                                ownerId= gp!=null? gp.id : defaultOwnerid);
                        insert ca;
     
     }
    
  /*  // execute scheduled job
    public void execute(SchedulableContext sc) {
       set<title__c> tids = new set<title__c>(); 
       for(Marketplace__c m : [SELECT id,Amazon_Street_Date__c,Format__r.Title__c from Marketplace__c WHERE Amazon_Street_Date__c <= TODAY AND Format__r.Name = 'Digital'])  
           tids.add(new title__c( id= m.Format__r.Title__c));
       for(title__c tid : tids)            
           System.enqueueJob(new TitleTriggerHandler(tid));    
           
   }*/
    
   
    
   
    
}