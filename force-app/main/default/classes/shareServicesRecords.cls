global class shareServicesRecords implements Database.Batchable<sObject>, Schedulable{

    public List<String> titleIds = new List<String>();
    public List<String> vendorIds = new List<String>();
     global void execute(SchedulableContext SC) {
         database.executeBatch(new shareServicesRecords(), 1);
     }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
       if(!titleIds.isEmpty())
           return Database.getQueryLocator('SELECT id FROM title__c WHERE status__c IN (\'In Production\', \'Contracted\',\'In Translation\') AND id=: titleIds');
       else
           return Database.getQueryLocator('SELECT id FROM title__c WHERE status__c IN (\'In Production\', \'Contracted\',\'In Translation\')'); 
    }
    global void execute(Database.BatchableContext bc, List<title__c> records){
        set<String> tIds = new set<String>();
        for(title__c t: records)
            tIds.add(t.id);
       shareServicess(tIds, new set<String>());
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }  
    
    public shareServicesRecords(List<String> titleIds, List<String> vendorIds) {
        this.titleIds = titleIds;
        this.vendorIds = vendorIds;
    
    }
    
    public shareServicesRecords() {
        
    
    }
      
    public static void shareServicess(set<String> tId , set<String> vids) {
        List<Sobject> createShareList = new List<Sobject>();
        List<Sobject> createShareList1 = new List<Sobject>();
        Map<String, SObject> cShare1 = new Map<String, SObject>();
        
        ppw_projectservicemassupdate_EST_Batch estb = new ppw_projectservicemassupdate_EST_Batch();
        Map<String,List<Sobject>> objsData = new  Map<String,List<Sobject>>();
        Map<String,String> serviceGrping = new Map<String,String>();
        Map<String,String> serviceTitleIds = new Map<String,String>();
        Map<String,String> espTitleIds = new Map<String,String>();
        set<String> cbServices = new set<String>();
        set<String> vendorIds = new set<String>();
        
        for(VendorOps_CbAddServices__mdt vCb : [SELECT Service_Type__c  FROM VendorOps_CbAddServices__mdt])
            cbServices.add(vcb.Service_Type__c);
        set<String> objNames = new set<String>{'Comic_Book_Service__c', 'Cover_Service__c', 'Editorial_Service__c', 
                  'Full_Color_Service__c', 'Interior_Service__c', 'Promotional_Text_Service__c'};
                  
         List<project__c> pro = [SELECT id FROM project__c WHERE title__C =: tId];         
         Map<String,List<String>> vendorUserMap = new Map<String,List<String>>();
       
             
                 
        if(!pro.isEmpty()) {
             for(String s: objNames) {
                List<Sobject> slst = database.query(estb.dyamicquery(s, pro ));
                objsData.put(s , slst);
             } 
             List<Sobject> allSobjects = new LIst<Sobject>();   
          
                for(List<Sobject> sol : objsData.values())
                    for(Sobject so: sol) {
                        String sVendor = String.valueOf(so.get('Vendor__c'));
                        if(!vids.isEmpty()) {
                            if(sVendor !=null)
                                if(vids.contains(sVendor))
                                    vendorIds.add(sVendor);
                        } else {
                             if(sVendor !=null)
                                vendorIds.add(sVendor);
                            }
                }
            Set<String> profileIds = new Set<String>();              
             List<String> vendorProfiles = Label.Community_Vendor_Profile.split(',');
            for(Profile p1: [SELECT id,profile.name FROM Profile WHERE name =: vendorProfiles])
                profileIds.add(p1.id); 
          for(User u: [SELECT  Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c=:vendorIds AND 
                          isActive = true AND profileId =: profileIds])
              if(vendorUserMap.containskey(u.Contact.Vendor__c))
                  vendorUserMap.get(u.Contact.Vendor__c).add(u.id);
              else
                  vendorUserMap.put(u.Contact.Vendor__c, new List<String> {u.id});    
            
              Set<String> espServices = new Set<String>();
              if(Label.CommunityESPServices.contains(','))
                  espServices.addAll(Label.CommunityESPServices.split(','));
              else
                  espServices.add(Label.CommunityESPServices);  
           Map<String,Set<String>> projectShare = new Map<String,Set<String>>();
            
            system.debug(espServices);
            for(String s: objNames) {
                 for(Sobject so: objsData.get(s)) {
                     if(so.get('Vendor__c') !=null && so.get('Service__c') != null && so.get('Project__c') !=null) {
                         String sVendor = String.valueOf(so.get('Vendor__c'));
                         String project = String.valueOf(so.get('Project__c'));
                         Sobject sstr = so.getSObject('Service__r');
                         if(vendorUserMap.containskey(sVendor)) 
                             for(String uId: vendorUserMap.get(sVendor)) {
                                 system.debug(String.valueOf(sstr.get('Name')));
                              if(espServices.contains(String.valueOf(sstr.get('Name')))) {
                             
                                 createShareList.add(UserTriggerHandler.shareRecords(uId,String.valueOf(so.get('Id')),'Read',s.removeend('__c')+ '__share'));
                               }  
                               
                               if(projectShare.containsKey(project))
                                   projectShare.get(project).add(uid);
                               else
                                   projectShare.put(project, new set<String>{uid});     
                               
                             /*  if(cShare1.ContainsKey(project)) {
                                     cShare1.add(createShareList1.add(UserTriggerHandler.shareRecords(uId, project ,'Read', 'Project__share')));
                                 } else
                                     cShare1.put(project, UserTriggerHandler.shareRecords(uId, project ,'Read', 'Project__share'));    
                                 */
                             }
                     }
                  }   
            } 
            
            // share projects
            for(String p: projectShare.keyset())
                for(String uId: projectShare.get(p))
                    createShareList1.add(UserTriggerHandler.shareRecords(uId, p ,'Read', 'Project__share'));    
        }
        system.debug(createShareList);
        system.debug(createShareList1);
        Insert createShareList;
        Insert createShareList1;
    
    } 

}