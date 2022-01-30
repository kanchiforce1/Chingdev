public class TitleBasedSharingRecalulation implements Schedulable, Database.Batchable<sObject> , Database.Stateful {

    public List<String> titleIds = new List<String>();
     public Map<String,String> titleStatus = new Map<String,String>();
    
     public void execute(SchedulableContext SC) {
         database.executeBatch(new titleBasedSharingRecalulation(), 1);
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        if(!titleIds.isEmpty())
           return Database.getQueryLocator('SELECT id,Marty_Title_ID__c FROM title__c WHERE status__c IN (\'In Production\', \'Contracted\',\'In Translation\') AND id=: titleIds');
       else
           return Database.getQueryLocator('SELECT id,Marty_Title_ID__c FROM title__c WHERE status__c IN (\'In Production\', \'Contracted\',\'In Translation\')'); 
    
    }
    
    public titleBasedSharingRecalulation(List<String> titleIds) {
        this.titleIds = titleIds;
    
    }
    
     public titleBasedSharingRecalulation() {
     
     }
    public void execute(Database.BatchableContext bc, List<title__c> records) {
        set<String> tIds = new set<String>();
        if(!records.isEmpty()) {
            try {
            sharingRecalculation(records[0]);
            titleStatus.put(records[0].Marty_Title_ID__c, 'Success');
        }  catch(exception e) { 
                titleStatus.put(records[0].Marty_Title_ID__c, e.getMessage());
           }
       }    
    }    
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        TitleBasedRemoveSharing.sendBatchStatusEmail(titleStatus, 'TitleBasedSharingRecalulation');
    } 
     public static void sharingRecalculation(title__c tadd) {
          if(tadd!=null) {
                 // share the project related indirect records instead of ps
          Set<String> cbTitleIds = new Set<String>();
          Set<String> esptitleeIds = new Set<String>();       
          Set<String> vendorIds = new Set<String>();       
                 Map<String,set<String>> UsersVendorMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoVendorMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoProjectMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoTitleMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoSeriesMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoAsinMap = new Map<String,Set<String>>();
        
        Map<String,Set<String>> vendortoSerivcePrepMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoSerivcePrepResMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoSerivcePrepQueMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoRateMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoServiceMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoCreativeBriefMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoTitleContactsMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoAuthorQuesMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoBookQuesMap = new Map<String,Set<String>>();
       // Map<String,Set<String>> vendortoESPMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoEspMap = new Map<String,Set<String>>();
       List<String> vendorProfiles = Label.Community_Vendor_Profile.split(',');
        ppw_projectservicemassupdate_EST_Batch estb = new ppw_projectservicemassupdate_EST_Batch();
        Map<String,List<Sobject>> objsData = new  Map<String,List<Sobject>>();
        Map<String,String> serviceGrping = new Map<String,String>();
        Map<String,String> serviceTitleIds = new Map<String,String>();
        Map<String,String> espTitleIds = new Map<String,String>();
          set<String> cbServices = new set<String>();
        for(VendorOps_CbAddServices__mdt vCb : [SELECT Service_Type__c  FROM VendorOps_CbAddServices__mdt])
            cbServices.add(vcb.Service_Type__c);
        set<String> objNames = new set<String>{'Comic_Book_Service__c', 'Cover_Service__c', 'Editorial_Service__c', 
                  'Full_Color_Service__c', 'Interior_Service__c', 'Promotional_Text_Service__c'};
                  
         List<project__c> pro = [SELECT id FROM project__c WHERE title__C =: tadd.id];         
                 // system.debug(UsersVendorMap);
         if(!pro.isEmpty()) {  
        for(String s: objNames) {
            List<Sobject> slst = database.query(estb.dyamicquery(s, pro ));
            objsData.put(s , slst);
            
             for(Sobject so: slst) {
                 //frameKeyValuesMap(so.get('Vendor__c'),ps.id,vendortoPsMap);
                 if(so.get('Vendor__c') !=null && so.get('Service__c') != null && so.get('Project__c') !=null) {
                     String sVendor = String.valueOf(so.get('Vendor__c'));
                     vendorIds.add(sVendor);
                         Sobject pproject = so.getSObject('Project__r');
                         if(so.get('Rate__c') !=null)
                             UserTriggerHandler.frameKeyValuesMap(sVendor ,String.valueOf(so.get('Rate__c')) ,vendortoRateMap);
                          if(so.get('Vendor__c') !=null)
                             UserTriggerHandler.frameKeyValuesMap(sVendor ,String.valueOf(so.get('Vendor__c')) ,vendortoVendorMap);    
                         if(so.get('Service__c')!=null)  {  
                             UserTriggerHandler.frameKeyValuesMap(sVendor , String.valueOf(so.get('Service__c')) ,vendortoServiceMap);
                             Sobject sstr = so.getSObject('Service__r');
                                if(sstr != null) {
                                    String sGroup = String.valueOf(sstr.get('Service_Grouping__c'));
                                    if(sGroup != null) {
                                 if(sGroup.containsIgnoreCase('Design') || 
                                 sGroup.containsIgnoreCase('Promotional') 
                                 )
                                     cbTitleIds.add(String.valueOf(pproject.get('Title__c')));
                                    // UserTriggerHandler.frameKeyValuesMap(sVendor , String.valueOf(so.get('Service__c')) , vendortoCreativeBriefMap);
                             
                                 }
                              String sSerType = String.valueOf(sstr.get('Service_Rate_Type__c'));
                              if(String.isNotBlank(sSerType))
                                  if(cbServices.contains(sSerType)) {
                                     // UserTriggerHandler.frameKeyValuesMap(sVendor , String.valueOf(so.get('Service__c')) , vendortoCreativeBriefMap);
                                      cbTitleIds.add(String.valueOf(pproject.get('Title__c')));
                                   }   
                                     
                         
                              Set<String> espServices = new Set<String>();
                              if(Label.CommunityESPServices.contains(','))
                                  espServices.addAll(Label.CommunityESPServices.split(','));
                              else
                                  espServices.add(Label.CommunityESPServices);    
                              if(espServices.contains(String.valueOf(sstr.get('Name')))) {
                                   //UserTriggerHandler.frameKeyValuesMap(sVendor , String.valueOf(so.get('Service__c')) , vendortoEspMap);
                                   esptitleeIds.add(String.valueOf(pproject.get('Title__c')));
                               }  
                                }
                             
                          }   
                         if(so.get('Project__c')!= null)   { 
                             String titleIds = String.valueOf(pproject.get('Title__c'));
                            String seriesIds = String.valueOf(pproject.get('Series__c'));
                             UserTriggerHandler.frameKeyValuesMap(sVendor , titleIds,vendortoProjectMap);
                              UserTriggerHandler.frameKeyValuesMap(sVendor , seriesIds,vendortoSeriesMap);
                             if(pproject.getSobject('Title__r').get('Status__c') != null) {
                                 Sobject tTitle = pproject.getSobject('Title__r');
                                 String tstatus = String.valueOf(tTitle.get('Status__c'));
                                 if(!cbTitleIds.isEmpty() || !esptitleeIds.isEmpty())
                                    if((tstatus.equalsIgnoreCase('In Production') || tstatus.equalsIgnoreCase('Contracted') || tstatus.equalsIgnoreCase('In Translation'))
                                    && (cbTitleIds.contains(titleIds) || esptitleeIds.contains(titleIds)))
                                        UserTriggerHandler.frameKeyValuesMap(sVendor , titleIds ,vendortoTitleMap);
                             }   
                                 serviceTitleIds.put(s, String.valueOf(pproject.get('Title__c')));
                         } 
                   }     
                
            }
            
          
        }   
       set<String> titleContacts = new set<String>();
        for(Set<String> st : vendortoTitleMap.values())
            titleContacts.addall(st);
            
           // system.debug(cbTitleIds);
           // system.debug(titleIds);
            
        // title related records sharing
         for(Title__c t : [SELECT Id,(SELECT id FROM ASINs__r),  (SELECT id FROM Title_Contacts__r), (SELECT id FROM Creative_Briefs__r)   FROM Title__c WHERE status__c IN ('In Production', 'Contracted','In Translation') AND 
                             (id=:tadd.id)]) {
             for(String v : vendortoTitleMap.keyset()) {
                 for(Title_Contact__c a: t.Title_Contacts__r) // Asin records share
                    UserTriggerHandler.frameKeyValuesMap(v,a.id,vendortoTitleContactsMap); 
                 if(vendortoTitleMap.get(v).contains(t.id))
                     UserTriggerHandler.frameKeyValuesMap(v, t.id ,vendortoTitleMap);
                 for(ASIN__c a: t.ASINs__r) // Asin records share
                    UserTriggerHandler.frameKeyValuesMap(v,a.id,vendortoAsinMap); 
                 if(!cbTitleIds.isEmpty() && cbTitleIds.contains(t.id)) // creative brief records share  
                     for(Creative_Brief__c cb : t.Creative_Briefs__r) 
                         UserTriggerHandler.frameKeyValuesMap(v,cb.id,vendortoCreativeBriefMap ); 
                
                          
             }
                     
        }
         if(!vendortoCreativeBriefMap.isEmpty())
             ServicesTriggerHandler.shareOtherBookSeries(cbTitleIds,vendortoCreativeBriefMap, null);// share other book in series
                     
        
        // share ESP records
            for(esp__c e: [SELECT id,Vendor__c FROM esp__c WHERE title__r.status__c IN ('In Production', 'Contracted','In Translation') AND title__c =: esptitleeIds AND Vendor__r.Chinook_Access__c=true]) {
                if(vendortoEspMap.containsKey(e.Vendor__c))
                    vendortoEspMap.get(e.Vendor__c).add(e.id);
                else
                    vendortoEspMap.put(e.Vendor__c, new Set<String>{e.id});    
            }
                
         
            // List<String> vendorProfiles = Label.Community_Vendor_Profile.split(',');
              List<String> profileIds = new List<String>();
              Map<String,String> vendorToUserIds = new  Map<String,String>();
              for(Profile p: [SELECT id,profile.name FROM Profile WHERE name =: vendorProfiles])
            profileIds.add(p.id); 
             for(User u: [SELECT  Contact.Vendor__c FROM USER WHERE profileId =: profileIds AND ContactId!=null AND Contact.Vendor__c!=null AND contact.vendor__c =: vendorIds AND isActive = true]) {
            vendorIds.add(u.Contact.Vendor__c);
            if(UsersVendorMap.containsKey(u.id))
                UsersVendorMap.get(u.id).add(u.Contact.Vendor__c);
            else
                UsersVendorMap.put(u.id, new Set<String>{u.Contact.Vendor__c});    
           
            vendorToUserIds.put(u.Contact.Vendor__c, u.id);
                
        
        }
          List<Sobject> createShareList = new List<Sobject>();
        List<Sobject> createShareList1 = new List<Sobject>();
        List<Sobject> createShareList2 = new List<Sobject>();    
        List<Sobject> createShareList3 = new List<Sobject>();
        List<Sobject> createShareList4 = new List<Sobject>();    
        List<Sobject> createShareList5 = new List<Sobject>();     
        List<Sobject> createShareList6 = new List<Sobject>();    
        List<Sobject> createShareList7 = new List<Sobject>();    
        List<Sobject> createShareList8 = new List<Sobject>();    
        List<Sobject> createShareList9 = new List<Sobject>();    
        List<Sobject> createShareList10 = new List<Sobject>();                
        List<Sobject> createShareList11 = new List<Sobject>();
        List<Sobject> createShareList12 = new List<Sobject>();     
        List<Sobject> createShareList13 = new List<Sobject>();     
        
        
         if(!UsersVendorMap.isEmpty()) {
            
            // vendor share and note making individual dml operation for one transation only allow 10 chunck size
            for(String u: UsersVendorMap.keyset())
                for(String vendor : UsersVendorMap.get(u)) {
                    createShareList.add(UserTriggerHandler.shareRecords(u,vendor,'Read','Vendor__Share'));
                   // UserTriggerHandler.getAllCreateShareRecords(vendortoProjectMap,u,vendor,'Project__Share','Edit',createShareList2);
                    UserTriggerHandler.getAllCreateShareRecords(vendortoTitleMap,u,vendor,'Title__Share','Read',createShareList3);
                     UserTriggerHandler.getAllCreateShareRecords(vendortoSeriesMap,u,vendor,'Seies__Share','Read',createShareList1);
                    UserTriggerHandler.getAllCreateShareRecords(vendortoAsinMap,u,vendor,'Asin__Share','Read',createShareList4);
                 //   UserTriggerHandler.getAllCreateShareRecords(vendortoConfirmationMap,u,vendor,'Confirmation__Share','Edit',createShareList5);
                 //   UserTriggerHandler.getAllCreateShareRecords(vendortoSerivcePrepMap,u,vendor,'Service_Prep__Share','Read',createShareList6);
                 //   UserTriggerHandler.getAllCreateShareRecords(vendortoSerivcePrepQueMap,u,vendor,'Service_Prep_Question__Share','Read',createShareList7);
                 //   UserTriggerHandler.getAllCreateShareRecords(vendortoSerivcePrepResMap,u,vendor,'Service_Prep_Response__Share','Read',createShareList8);
                    UserTriggerHandler.getAllCreateShareRecords(vendortoRateMap,u,vendor,'Rate__Share','Read',createShareList9);
                    UserTriggerHandler.getAllCreateShareRecords(vendortoServiceMap,u,vendor,'Service__Share','Read',createShareList10);
                    UserTriggerHandler.getAllCreateShareRecords(vendortoCreativeBriefMap,u,vendor,'Creative_Brief__Share','Read',createShareList11);
                    UserTriggerHandler.getAllCreateShareRecords(vendortoEspMap,u,vendor,'ESP__Share','Edit',createShareList12);
                    UserTriggerHandler.getAllCreateShareRecords(vendortoTitleContactsMap,u,vendor,'Title_Contact__share','Edit',createShareList13);
                   
                  
                }    
                   
            }
            database.insert(createShareList, true);
          database.insert(createShareList1,  true);
          database.insert(createShareList2,  true);
          database.insert(createShareList3,  true);
          database.insert(createShareList4,  true);
          database.insert(createShareList5,  true);
          database.insert(createShareList6,  true);
          database.insert(createShareList7,  true);
          database.insert(createShareList8,  true);
          database.insert(createShareList9,  true);
          database.insert(createShareList10,  true);
          database.insert(createShareList11,  true);
          database.insert(createShareList12,  true);
          database.insert(createShareList13,  true);
          shareServicesRecords.shareServicess(new set<String> {tadd.id}, new Set<String>());
       }
    }
     
    
    }
    public Static Map<String,Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    //  make share reocrds for delete
      public static SObject shareRecords(String objectName, String recId) {
            Sobject sobj =  schemaMap.get(ObjectName).newSObject();
            sobj.put('Id',recId);
            return sobj;
        }
   
  
   
    }