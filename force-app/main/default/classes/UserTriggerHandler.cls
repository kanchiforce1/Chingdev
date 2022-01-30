/***********************************
Author:      Amazon Apub // kkolla@
Used By:     
Description: 
***********************************/
public class UserTriggerHandler {
    public Static Map<String,Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    
    public static void shareVendorRecord(Set<Id> newMap) {
        
        Map<String,set<String>> UsersVendorMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoPsMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoProjectMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoTitleMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoSeriesMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoAsinMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoConfirmationMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoMarketPlaceMap = new Map<String,Set<String>>();
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
        
        List<String> profileIds = new List<String>();
        set<String> vendorIds = new set<String>();
        Map<String,String> vendorToUserIds = new Map<String,String>();
        
        set<String> titleIds = new set<String>();
        set<String> projectIds = new set<String>();
        set<String> esptitleeIds = new set<String>();
        for(Profile p: [SELECT id,profile.name FROM Profile WHERE name =: vendorProfiles])
            profileIds.add(p.id);
        for(User u: [SELECT  Contact.Vendor__c FROM USER WHERE id=:newMap AND profileId =: profileIds AND ContactId!=null AND Contact.Vendor__c!=null]) {
            vendorIds.add(u.Contact.Vendor__c);
            if(UsersVendorMap.containsKey(u.id))
                UsersVendorMap.get(u.id).add(u.Contact.Vendor__c);
            else
                UsersVendorMap.put(u.id, new Set<String>{u.Contact.Vendor__c});    
           
            vendorToUserIds.put(u.Contact.Vendor__c, u.id);
                
        
        }
        if(!vendorIds.isEmpty()) {
        // share ESP records
       /* for(esp__c e: [SELECT id,Vendor__c FROM esp__c WHERE Vendor__c =:vendorIds AND Vendor__r.Chinook_Access__c=true]) {
            if(vendortoEspMap.containsKey(e.Vendor__c))
                vendortoEspMap.get(e.Vendor__c).add(e.id);
            else
                vendortoEspMap.put(e.Vendor__c, new Set<String>{e.id});    
        }
        */
        
        Set<String> cbTitleIds = new Set<String>();
        Map<String,List<Project_Services__c>> titleToPSs = new Map<String,List<Project_Services__c>>();
      
        // project related records sharing
        for(Project_Services__c ps : [SELECT Id,(SELECT id FROM Confirmation__r),Rate__c,Service__c,status__c,Project__r.Series__c,
                                     Service__r.Service_Grouping__c,Vendor__c,Project__c,Project__r.Title__c  FROM Project_Services__c 
                                     WHERE Vendor__c=:vendorIds]) {
             frameKeyValuesMap(ps.Vendor__c,ps.id,vendortoPsMap);
             frameKeyValuesMap(ps.Vendor__c,ps.Rate__c,vendortoRateMap);
             frameKeyValuesMap(ps.Vendor__c,ps.Service__c,vendortoServiceMap);
             frameKeyValuesMap(ps.Vendor__c,ps.Project__c,vendortoProjectMap);
             frameKeyValuesMap(ps.Vendor__c,ps.Project__r.Title__c,vendortoTitleMap);
             frameKeyValuesMap(ps.Vendor__c,ps.Project__r.Series__c,vendortoSeriesMap);
             for(Confirmation__c c: ps.Confirmation__r) {
                 frameKeyValuesMap(ps.Vendor__c,c.id,vendortoConfirmationMap);    
             titleIds.add(ps.Project__r.Title__c);
             }
             if(ps.Service__r.Service_Grouping__c != null) {
                 if(ps.Service__r.Service_Grouping__c.containsIgnoreCase('Design') || 
                 ps.Service__r.Service_Grouping__c.containsIgnoreCase('Promotional') && 
                 (ps.status__c != 'Cancelled' && ps.status__c != 'Killed'))
                     cbTitleIds.add(ps.Project__r.Title__c);
             
             }
            
             projectIds.add(ps.Project__c);      
        }
        
       
        // share the project related indirect records instead of ps
        ppw_projectservicemassupdate_EST_Batch estb = new ppw_projectservicemassupdate_EST_Batch();
        Map<String,List<Sobject>> objsData = new  Map<String,List<Sobject>>();
        Map<String,String> serviceGrping = new Map<String,String>();
        Map<String,String> serviceTitleIds = new Map<String,String>();
        Map<String,String> espTitleIds = new Map<String,String>();
        Set<String> allTitleIds = new Set<String>();
          set<String> cbServices = new set<String>();
        for(VendorOps_CbAddServices__mdt vCb : [SELECT Service_Type__c  FROM VendorOps_CbAddServices__mdt])
            cbServices.add(vcb.Service_Type__c);
        set<String> objNames = new set<String>{'Comic_Book_Service__c', 'Cover_Service__c', 'Editorial_Service__c', 
                  'Full_Color_Service__c', 'Interior_Service__c', 'Promotional_Text_Service__c'};
                  
                  
                  system.debug(UsersVendorMap);
              Set<String> espServices = new Set<String>();
              if(Label.CommunityESPServices.contains(','))
                  espServices.addAll(Label.CommunityESPServices.split(','));
              else
                  espServices.add(Label.CommunityESPServices);         
                  
        for(String s: objNames) {
            List<Sobject> slst = database.query(estb.dyamicquery1(s,vendorIds));
            objsData.put(s , slst);
            
            
             for(Sobject so: slst) {
                 
                 if(so.get('Vendor__c') !=null && so.get('Service__c') != null && so.get('Project__c') !=null) {
                     String sVendor = String.valueOf(so.get('Vendor__c'));
                   
                     if(vendorIds.contains(sVendor)) {
                         Sobject pproject = so.getSObject('Project__r');
                          if(so.get('Project__c') !=null)
                             frameKeyValuesMap(sVendor ,String.valueOf(so.get('Project__c')) ,vendortoProjectMap);
                         if(so.get('Rate__c') !=null)
                             frameKeyValuesMap(sVendor ,String.valueOf(so.get('Rate__c')) ,vendortoRateMap);
                         if(so.get('Service__c')!=null)  {  
                             frameKeyValuesMap(sVendor , String.valueOf(so.get('Service__c')) ,vendortoServiceMap);
                             Sobject sstr = so.getSObject('Service__r');
                                if(sstr != null) {
                                    String sGroup = String.valueOf(sstr.get('Service_Grouping__c'));
                                    if(sGroup != null) {
                                 if(sGroup.containsIgnoreCase('Design') || 
                                 sGroup.containsIgnoreCase('Promotional') 
                                 )
                                     cbTitleIds.add(String.valueOf(pproject.get('Title__c')));
                             
                                 }
                              String sSerType = String.valueOf(sstr.get('Service_Rate_Type__c'));
                              if(String.isNotBlank(sSerType))
                                  if(cbServices.contains(sSerType))
                                      cbTitleIds.add(String.valueOf(pproject.get('Title__c')));
                                     
                         
                               
                              if(espServices.contains(String.valueOf(sstr.get('Name'))))
                                  esptitleeIds.add(String.valueOf(pproject.get('Title__c')));
                                 
                                }
                             
                          }   
                         if(so.get('Project__c')!= null && pproject != null)   { 
                             frameKeyValuesMap(sVendor , String.valueOf(so.get('Project__c')) ,vendortoProjectMap);
                         if(pproject.getSobject('Title__r') != null)    
                         if(pproject.getSobject('Title__r').get('Status__c') != null) {
                             Sobject tTitle = pproject.getSobject('Title__r');
                             String tstatus = String.valueOf(tTitle.get('Status__c'));
                             if(tstatus.equalsIgnoreCase('In Production') || tstatus.equalsIgnoreCase('Contracted'))
                                 frameKeyValuesMap(sVendor , String.valueOf(pproject.get('Title__c')),vendortoTitleMap);
                         }   
                             serviceTitleIds.put(s, String.valueOf(pproject.get('Title__c')));
                         } 
                       allTitleIds.add(String.valueOf(pproject.get('Title__c')));   
                   }     
                 }
                
            }
            
          
        }   
       set<String> titleContacts = new set<String>();
        for(Set<String> st : vendortoTitleMap.values())
            titleContacts.addall(st);
            
            system.debug(cbTitleIds);
            system.debug(titleIds);
            
        // title related records sharing
         for(Title__c t : [SELECT Id,(SELECT id FROM ASINs__r), (SELECT id FROM Creative_Briefs__r), (SELECT id FROM Title_Contacts__r)   FROM Title__c WHERE status__c IN ('In Production', 'Contracted') AND 
                             (id=:titleIds OR id=:cbTitleIds OR id=:titleContacts)]) {
             for(String v : vendortoTitleMap.keyset()) {
                 for(Title_Contact__c a: t.Title_Contacts__r) // Asin records share
                    UserTriggerHandler.frameKeyValuesMap(v,a.id,vendortoTitleContactsMap); 
                 if(vendortoTitleMap.get(v).contains(t.id))
                     frameKeyValuesMap(v, t.id ,vendortoTitleMap);
                 for(ASIN__c a: t.ASINs__r) // Asin records share
                    frameKeyValuesMap(v,a.id,vendortoAsinMap); 
                 if(!cbTitleIds.isEmpty() && cbTitleIds.contains(t.id)) // creative brief records share  
                     for(Creative_Brief__c cb : t.Creative_Briefs__r) 
                         frameKeyValuesMap(v,cb.id,vendortoCreativeBriefMap ); 
                
                          
             }
                     
        }
         if(!vendortoCreativeBriefMap.isEmpty())
             ServicesTriggerHandler.shareOtherBookSeries(cbTitleIds,null, newMap);// share other book in series
                     
        
        // share ESP records
            for(esp__c e: [SELECT id,Vendor__c FROM esp__c WHERE title__r.status__c IN ('In Production', 'Contracted') AND Vendor__c =:vendorIds AND title__c =: esptitleeIds AND Vendor__r.Chinook_Access__c=true]) {
                if(vendortoEspMap.containsKey(e.Vendor__c))
                    vendortoEspMap.get(e.Vendor__c).add(e.id);
                else
                    vendortoEspMap.put(e.Vendor__c, new Set<String>{e.id});    
            }
        
        
        // share project,service prep,service prep response,service prep questions
         for(Service_Prep_Response__c spr : [SELECT Id,Service_Prep__c,Service_Prep__r.Project__c,Service_Prep_Question__c  FROM Service_Prep_Response__c WHERE Service_Prep__r.Project__c =:projectIds AND Service_Prep__r.Project__c!=NULL AND Service_Prep_Question__c!=NULL]) {
             for(String v : vendortoTitleMap.keyset()) 
                 if(vendortoProjectMap.get(v).contains(spr.Service_Prep__r.Project__c)) {
                     frameKeyValuesMap(v,spr.id,vendortoSerivcePrepResMap); 
                     frameKeyValuesMap(v,spr.Service_Prep__c,vendortoSerivcePrepMap); 
                     frameKeyValuesMap(v,spr.Service_Prep_Question__c,vendortoSerivcePrepQueMap); 
             }           
                   
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
            
            // vendor share and note making  individual dml operation for one transation only allow 10 chunck size
            for(String u: UsersVendorMap.keyset())
                for(String vendor : UsersVendorMap.get(u)) {
                    createShareList.add(shareRecords(u,vendor,'Read','Vendor__Share'));
                    getAllCreateShareRecords(vendortoProjectMap,u,vendor,'Project__Share','Edit',createShareList2);
                     getAllCreateShareRecords(vendortoSeriesMap,u,vendor,'Series__Share','Edit',createShareList1);
                    getAllCreateShareRecords(vendortoTitleMap,u,vendor,'Title__Share','Read',createShareList3);
                    getAllCreateShareRecords(vendortoAsinMap,u,vendor,'Asin__Share','Read',createShareList4);
                    getAllCreateShareRecords(vendortoConfirmationMap,u,vendor,'Confirmation__Share','Edit',createShareList5);
                    getAllCreateShareRecords(vendortoSerivcePrepMap,u,vendor,'Service_Prep__Share','Read',createShareList6);
                    getAllCreateShareRecords(vendortoSerivcePrepQueMap,u,vendor,'Service_Prep_Question__Share','Read',createShareList7);
                    getAllCreateShareRecords(vendortoSerivcePrepResMap,u,vendor,'Service_Prep_Response__Share','Read',createShareList8);
                    getAllCreateShareRecords(vendortoRateMap,u,vendor,'Rate__Share','Read',createShareList9);
                    getAllCreateShareRecords(vendortoServiceMap,u,vendor,'Service__Share','Read',createShareList10);
                    getAllCreateShareRecords(vendortoCreativeBriefMap,u,vendor,'Creative_Brief__Share','Read',createShareList11);
                    getAllCreateShareRecords(vendortoEspMap,u,vendor,'ESP__Share','Edit',createShareList12);
                    getAllCreateShareRecords(vendortoTitleContactsMap,u,vendor,'Title_Contact__share','Edit',createShareList13);
                   
                  
                    
                   
            }
        
            system.debug('createShareList'+ createShareList.size());
             system.debug('createShareList1'+ createShareList1.size());
             system.debug('createShareList2'+ createShareList2.size());
             system.debug('createShareList3'+ createShareList3.size());
             system.debug('createShareList4'+ createShareList4.size());
            system.debug('createShareList5'+ createShareList5.size());
            system.debug('createShareList6'+ createShareList6.size());
            system.debug('createShareList7'+ createShareList7.size());
            system.debug('createShareList8'+ createShareList8.size());
            system.debug('createShareList9'+ createShareList9.size());
            system.debug('createShareList10'+ createShareList10.size());
            system.debug('createShareList11'+ createShareList11.size());
            system.debug('createShareList12'+ createShareList12.size());
            
           
                
            
            
            
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
         
          shareServicesRecords.shareServicess(allTitleIds, vendorIds);
         // Insert createShareList;  // share vendor records
         // Insert createShareList1;  // share vendor records
         }  
        }
        }
      
      public static void sharePSIndirectRecords() {
      
      
      }
      
       public static void getAllCreateShareRecords(Map<String,Set<String>> maprec,String u,String vendor,String objName,String accessLevel,List<Sobject> createShareList) {
           if(maprec.containsKey(vendor)) 
               for(String rec: maprec.get(vendor))
                   if(rec != null)
                       createShareList.add(shareRecords(u,rec,accessLevel,objName));         
                    
       
       }
       
       public static Map<String,Set<String>> frameKeyValuesMap(String key,String value,Map<String,Set<String>> MapObj) {
            if(MapObj.containsKey(key))
                MapObj.get(key).add(value);
            else
                MapObj.put(key, new Set<String>{value});  
       return MapObj;
       }
        
        public static SObject shareRecords(String uId,String recordId, String accessLevel,String objectName) {
             system.debug(ObjectName);      
             system.debug(recordId);      
            Sobject sobj =  schemaMap.get(ObjectName).newSObject();
            sobj.put('ParentID',recordId);
            sobj.put('AccessLevel',accessLevel);
            sobj.put('UserOrGroupId',uId);
           
           return sobj;
        }
       public void shareESPRecords(ESP__c esp) {
           List<Sobject> createShareList = new List<Sobject>();
           esp__c e = [SELECT id,Vendor__c FROM esp__c WHERE id =: esp.id];
           for(User u: [SELECT  Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: e.Vendor__c])
                createShareList.add(shareRecords(u.id,e.id,'Edit','ESP__Share'));
        }
        
        // remove cb share for vendor community user when special case
    @future  
    public static void removecbShare(set<id> psIds) {
     set<String>vIds = new set<String>();
     set<String>tIds = new set<String>();
     set<String> CBIds = new set<String>();
     set<String> uIds = new set<String>();
    //  List<Sobject> removeShareList = new List<Sobject>();
     List<Sobject> removeShareList = new List<Sobject>();
        for(Project_Services__c ps : [SELECT Id,project__r.title__c,
                                     Service__r.Service_Grouping__c,Vendor__c,Status__c  FROM Project_Services__c WHERE id=:psIds]) {
        
                 if((ps.status__c == 'Cancelled' || ps.status__c == 'Killed')) {
                     vIds.add(ps.Vendor__c);
                     tIds.add(ps.project__r.title__c);
             
             }
        }     
      for(Creative_Brief__c cb: [SELECT id FROM Creative_Brief__c WHERE Title__c =: tIds])
           CBIds.add(cb.id);   
      for(User u : [SELECT  Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: vIds])
          uIds.add(u.id);
             removeShareList = [SELECT id FROM Creative_Brief__Share WHERE parentid =:CBIds AND UserOrGroupId =: uIds];   
               // createShareList.add(shareRecords(u.id,e.id,'Edit','ESP__Share'));
             delete removeShareList;  
    
    }     
        
  
    }