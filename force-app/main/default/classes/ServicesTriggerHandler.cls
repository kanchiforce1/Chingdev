public class ServicesTriggerHandler {

    public static void shareServicesRecordsHandler(List<SObject> newItems, String objName, Map<Id,Sobject> oldMap) {
    
     if(trigger.isInsert)
            shareServicesRecords(newItems , objName, oldMap);
         if(trigger.isUpdate) 
         for(Sobject es: newItems)
             if(es.get('Vendor__c') != oldmap.get(es.id).get('Vendor__c') || es.get('Service__c') != oldmap.get(es.id).get('Service__c'))
                shareServicesRecords(newItems, objName, oldMap);
    
    
    }

    public static void shareServicesRecords(List<SObject> newItems, String objName, Map<Id,Sobject> oldMap) {
        set<String> vendorIds = new set<String>();
        set<String> serviceIds = new set<String>(); 
        set<String> projectIds = new set<String>(); 
        set<String> espTitleIds = new set<String>(); 
        Map<String,Set<String>> vendorMap = new Map<String,Set<String>>();
        
        Map<String,Set<String>> vendortoProjectMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoTitleMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoSeriesMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoRateMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoServiceMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoCreativeBriefMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoEspMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoAsinMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoTitleContactMap = new Map<String,Set<String>>();
        Set<String> allTitleIds = new Set<String>();
       
        set<String> cbTitleIds = new set<String>();
        set<String> ttleIds = new set<String>();
        for(Sobject so: newItems) {
        if(so.get('Vendor__c') !=null) 
                 vendorIds.add(String.valueOf(so.get('Vendor__c')));
             if(so.get('Service__c') != null)
                 serviceIds.add(String.valueOf(so.get('Service__c')));
             if(so.get('Project__c') !=null)
                 projectIds.add(String.valueOf(so.get('Project__c')));
         }        
         if(oldmap != null)       
         for(Sobject so: oldmap.values()) {
              if(so.get('Service__c') != null)
                  serviceIds.add(String.valueOf(so.get('Service__c')));
              if(so.get('Vendor__c') != null)
                  vendorIds.add(String.valueOf(so.get('Vendor__c'))); 
         } 
          ppw_projectservicemassupdate_EST_Batch estb = new ppw_projectservicemassupdate_EST_Batch(); 
        //  List<Sobject> slst = new List<Sobject>();
         if(!vendorIds.isEmpty()) {      
        
          for(Sobject so: newItems) 
               if(so.get('Vendor__c') !=null && so.get('Service__c') != null && so.get('Project__c') !=null) 
                   serviceIds.add(String.valueOf(so.get('Service__c')));
         }   
         system.debug(serviceIds);    
         system.debug(projectIds);    
         Map<String, Project__c> projectsMap = new Map<String, Project__c>([SELECT id,title__c,series__c,title__r.status__c FROM Project__c WHERE id=:projectIds]);        
         Map<String,service__c> servicesMap = new Map<String,service__c>([SELECT id,Name, Service_Grouping__c, Service_Rate_Type__c FROM service__c WHERE id=: serviceIds]);
         set<String> cbServices = new set<String>();
         for(String s: projectsMap.keyset())
             ttleIds.add(projectsMap.get(s).title__c);
         
         
         for(VendorOps_CbAddServices__mdt vCb : [SELECT Service_Type__c  FROM VendorOps_CbAddServices__mdt])
            cbServices.add(vcb.Service_Type__c);
        
          for(Sobject so: newItems) {
               if(so.get('Vendor__c') !=null && so.get('Service__c') != null && so.get('Project__c') !=null) {
               String sVendor = String.valueOf(so.get('Vendor__c'));
               String service = String.valueOf(so.get('Service__c'));
               String project = String.valueOf(so.get('Project__c'));
               String rate = String.valueOf(so.get('Rate__c'));
             
               if(servicesMap!=null) {
               if(String.isNotBlank(servicesMap.get(service).Service_Grouping__c))
                if(servicesMap.get(service).Service_Grouping__c.containsIgnoreCase('Design') || 
                             servicesMap.get(service).Service_Grouping__c.containsIgnoreCase('Promotional') 
                             )
                     cbTitleIds.add(projectsMap.get(project).title__c);
   
               String sSerType = servicesMap.get(service).Service_Rate_Type__c;
             
               if(String.isNotBlank(sSerType))
                  if(cbServices.contains(sSerType))
                      cbTitleIds.add(projectsMap.get(project).title__c);
             
                 if(String.isNotBlank(service)) {
                      Set<String> espServices = new Set<String>();
                      if(Label.CommunityESPServices.contains(','))
                          espServices.addAll(Label.CommunityESPServices.split(','));
                      else
                          espServices.add(Label.CommunityESPServices); 
                          
                      if(espServices.contains(servicesMap.get(service).Name))
                          espTitleIds.add(projectsMap.get(project).title__c);
                          system.debug(espTitleIds);
                                                  
                  }  
                }          
             if(projectsMap.get(project).title__r.status__c == 'In Production' || projectsMap.get(project).title__r.status__c == 'Contracted' ||  projectsMap.get(project).title__r.status__c == 'In Translation') {        
                 UserTriggerHandler.frameKeyValuesMap(sVendor, sVendor ,vendorMap);
                 UserTriggerHandler.frameKeyValuesMap(sVendor,(so.get('Rate__c')!=null? String.valueOf(so.get('Rate__c')): null),vendortoRateMap);
                 UserTriggerHandler.frameKeyValuesMap(sVendor,service ,vendortoServiceMap);
                 UserTriggerHandler.frameKeyValuesMap(sVendor,project ,vendortoProjectMap);
                 if(!cbTitleIds.isEmpty() || !espTitleIds.isEmpty())
                     UserTriggerHandler.frameKeyValuesMap(sVendor,projectsMap.get(project).title__c ,vendortoTitleMap); 
                 UserTriggerHandler.frameKeyValuesMap(sVendor,projectsMap.get(project).series__c ,vendortoSeriesMap);  
              }    
             } 
          } 
          
          
            
                                             
          
          
          set<String> titleContacts = new set<String>();
        for(Set<String> st : vendortoTitleMap.values())
            titleContacts.addall(st);
            // title related records sharing
         for(Title__c t : [SELECT Id,(SELECT id FROM ASINs__r), (SELECT id FROM Title_Contacts__r) ,(SELECT id FROM Creative_Briefs__r)   FROM Title__c WHERE status__c IN ('In Production', 'Contracted', 'In Translation') AND 
                                 (id=:cbTitleIds OR id=:titleContacts)]) {
             for(String v : vendortoTitleMap.keyset()) {
                 for(Title_Contact__c a: t.Title_Contacts__r) // Asin records share
                    UserTriggerHandler.frameKeyValuesMap(v,a.id,vendortoTitleContactMap); 
                  for(ASIN__c a: t.ASINs__r) // Asin records share
                    UserTriggerHandler.frameKeyValuesMap(v,a.id,vendortoAsinMap); 
                 if(!cbTitleIds.isEmpty() && cbTitleIds.contains(t.id)) // creative brief records share  
                     for(Creative_Brief__c cb : t.Creative_Briefs__r) 
                         UserTriggerHandler.frameKeyValuesMap(v,cb.id,vendortoCreativeBriefMap ); 
             }
                     
          } 
          if(!vendortoCreativeBriefMap.isEmpty())
             shareOtherBookSeries(cbTitleIds,vendortoCreativeBriefMap,null);// share other book in series
       
             
        
        
         // share ESP records
            for(esp__c e: [SELECT id,Vendor__c FROM esp__c WHERE Vendor__c =:vendorIds AND title__r.status__c IN ('In Production', 'Contracted', 'In Translation') AND title__c =: espTitleIds AND Vendor__r.Chinook_Access__c=true]) {
                if(vendortoEspMap.containsKey(e.Vendor__c))
                    vendortoEspMap.get(e.Vendor__c).add(e.id);
                else
                    vendortoEspMap.put(e.Vendor__c, new Set<String>{e.id});    
            }
            List<Sobject> createShareList = new List<Sobject>();
            List<Sobject> createShareList1 = new List<Sobject>();
            List<Sobject> createShareList2 = new List<Sobject>();
            List<Sobject> createShareList3 = new List<Sobject>(); 
            List<Sobject> createShareList4 = new List<Sobject>();       
            List<Sobject> createShareList5 = new List<Sobject>();       
            List<Sobject> createShareList6 = new List<Sobject>();  
            List<Sobject> createShareList7 = new List<Sobject>();

     
        
         for(User u: [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND 
                     Contact.Vendor__c =: vendorIds AND isActive = true])    {
            createShareList5.add(UserTriggerHandler.shareRecords(u.id,u.Contact.Vendor__c,'Read','Vendor__Share'));
            UserTriggerHandler.getAllCreateShareRecords(vendortoProjectMap,u.id,u.Contact.Vendor__c ,'Project__Share','Edit',createShareList);
            UserTriggerHandler.getAllCreateShareRecords(vendortoRateMap,u.id,u.Contact.Vendor__c,'Rate__Share','Read',createShareList1);
            UserTriggerHandler.getAllCreateShareRecords(vendortoTitleMap,u.id,u.Contact.Vendor__c ,'Title__Share','Read',createShareList2);
            UserTriggerHandler.getAllCreateShareRecords(vendortoSeriesMap,u.id,u.Contact.Vendor__c ,'Series__Share','Read',createShareList2);
            UserTriggerHandler.getAllCreateShareRecords(vendortoCreativeBriefMap,u.id,u.Contact.Vendor__c ,'Creative_Brief__Share','Read',createShareList3);
            UserTriggerHandler.getAllCreateShareRecords(vendortoEspMap,u.id,u.Contact.Vendor__c ,'ESP__Share','Edit',createShareList4);
            UserTriggerHandler.getAllCreateShareRecords(vendortoTitleContactMap,u.id,u.Contact.Vendor__c ,'Title_Contact__share','Edit',createShareList6);
            UserTriggerHandler.getAllCreateShareRecords(vendortoAsinMap,u.id,u.Contact.Vendor__c ,'ASIN__Share','Edit',createShareList7);
         }
         
        database.insert(createShareList,true);
        database.insert(createShareList1,true);
        database.insert(createShareList2,true);
        database.insert(createShareList3,true);
        database.insert(createShareList4,true);
        database.insert(createShareList5,true);
        database.insert(createShareList6,true);
        database.insert(createShareList7,true);
          shareServicesRecords.shareServicess(ttleIds, new set<String>());
      
           // UsersVendorMap.put(usr.id, new Set<String>{usr.Contact.Vendor__c});  
    }
    
    public static void shareOtherBookSeries(set<String> cbTitleIds, Map<String, Set<String>> vendortoCreativeBriefMap, set<Id> UIds) {
          List<SObject> tcShare = new List<Sobject>();
             List<SObject> asinShare = new List<Sobject>();
             set<String> tseries = new set<String>();
             set<String> newCbTitleIds = new set<String>();
             List<String> legalNameContacts = new List<String>();
             
             for(Creative_Brief__c cb: [SELECT id,title__c FROM Creative_Brief__c WHERE title__c =: cbTitleIds])
                 newCbTitleIds.add(cb.title__c);
             
             for(title__c t: [SELECT id,Series__c FROM title__c WHERE id=:newCbTitleIds])
                 legalNameContacts.add(t.Series__c);
             for(Title_Contact__c tc1: [SELECT id,Legal_Name__c  FROM Title_Contact__c 
                                        WHERE Role__c='Author' AND Title__c=: newCbTitleIds]) 
                 legalNameContacts.add(tc1.Legal_Name__c);
             
             system.debug(newCbTitleIds);
             system.debug(legalNameContacts);
             
                List<ASIN__c> previousASINs = new List<ASIN__c>();
               previousASINs = [
                    SELECT id, ASIN__c,Title_Name__c, Title_External_Imprint__c 
                    FROM ASIN__c WHERE Title__c 
                    IN (SELECT Title__c 
                    FROM Title_Contact__c 
                    WHERE Legal_Name__c = :legalNameContacts AND Title_Status__c IN ('In Production', 'Published') AND Title_Series__c = :legalNameContacts AND 
                    Title__c != :newCbTitleIds) 
                    AND Name = 'Digital' ORDER BY Apub_Publish_Date__c ASC
                ]; 
             List<Title_Contact__c> tc = [SELECT id ,title__c
                                          FROM Title_Contact__c 
                                          WHERE Legal_Name__c=: legalNameContacts AND Title_Status__c IN ('In Production', 'Published') AND 
                                          Title_Series__c = :legalNameContacts AND Title__c != :newCbTitleIds
                                         ]; 
             List<String> tIds = new List<String>();           
             // for(User uid: uList)
              List<User> uList = new  List<User>();  
             if(vendortoCreativeBriefMap != null)
                uList = [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND 
                     Contact.Vendor__c =: vendortoCreativeBriefMap.keyset() AND isActive = true];
            
             if(UIds != null)
                  uList = [SELECT  id,Contact.Vendor__c FROM USER WHERE id=:UIds];
            
                 for(Title_Contact__c c : tc) {    
                     for(User u: uList)    {    
                         tcShare.add(UserTriggerHandler.shareRecords(u.id,c.id, 'Read','Title_Contact__share')); 
                         tIds.add(c.title__c);
                     }   
                 }              
                 insert tcShare;
              
                 
                 for(ASIN__c a : previousASINs)      
                      for(User u: uList)          
                          asinShare.add(UserTriggerHandler.shareRecords(u.id,a.id, 'Read','ASIN__share'));           
                 insert asinShare;
          
    
    }


}