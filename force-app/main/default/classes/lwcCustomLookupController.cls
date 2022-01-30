public with sharing class lwcCustomLookupController {

     @AuraEnabled(cacheable=true)
    public static String getVendorId() {
        List<User> uLst = [SELECT  Contact.Vendor__c,Contact.Vendor__r.Chinook_Access__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND id=: Userinfo.getUserId() limit 1];
          if(uLst.size()>0) 
             return uLst[0].Contact.Vendor__c;
        return null;
    }
    
     @AuraEnabled(cacheable=true)
    public static getDataTitle getTitleIdResults(String titleId) {
    
        getDataTitle titleData = new getDataTitle();
         String q = 'select id, Name, Marty_Title_ID__c, Full_Title_Name__c, Is_In_Series__c From title__c where Marty_Title_ID__c = \''+ titleId+ '\'';
          system.debug(q);
          title__c s = (title__c)database.query(q);
            titleData.title = s;
            titleData.btnToggle = checkBtnsAccess(titleId, false);
            
        return titleData;
                                                        
    }                                         
    
    @AuraEnabled(cacheable=true)
    public static List<resWrp> getResults(String ObjectName,String fieldName, String fieldName1,
                                            String value, String filter1, String filter2) {
        set<id> prIds = new set<id>();
        set<id> tIds = new set<id>();
        List<resWrp> w = new List<resWrp>();
     
      if(String.isNotBlank(value)) {    
          // title data search query 
          String q = 'select id, Name, '+ fieldName + ' ,status__c,Digital_Publication_Date__c From '+ ObjectName + ' where ('+ filter1 +' LIKE \'%'+ value + '\' OR '+ 
                       filter2 +' LIKE \'%'+ value + '\' OR ' + filter1 +' LIKE \'%'+ value + '%\' OR '+ filter2 +' LIKE \'%'+ value + '%\') LIMIT 200';
          system.debug(q);
          List<title__c> accList = (List<title__c>)database.query(q);
        
          for(title__c s: accList) {
              system.debug(s.Marty_Title_ID__c);
              resWrp r = new resWrp();
              r.recId = s.id;
              r.status = s.status__c;
              r.digitalPublicationDate = s.Digital_Publication_Date__c;
              r.recMartyId = s.Marty_Title_ID__c;
              r.recName = s.Name;
              r.isInSeries = s.Is_In_Series__c;
              r.fullTitleName = s.Full_Title_Name__c;
              w.add(r);
          
          }
        // series data search query
           String q1 = 'select id, Series_Title__c ,  Wombat_Series_ID__c From Series__c  where ( Wombat_Series_ID__c LIKE \'%'+ value + '\' OR '+ 
                       'Series_Title__c ' +' LIKE \'%'+ value + '\' OR ' + 'Wombat_Series_ID__c ' +' LIKE \'%'+ value + '%\' OR '+ 'Series_Title__c ' +' LIKE \'%'+ value + '%\') LIMIT 200';
          system.debug(q);
          List<Series__c> seriesList = (List<Series__c>)database.query(q1);
        
          for(Series__c s: seriesList) {
              resWrp r = new resWrp();
              r.recId = s.id;
              r.isSeries = true;
              r.recMartyId = s.Wombat_Series_ID__c;
              r.recName = s.Series_Title__c;
         
              w.add(r);
          
          }
              } else { 
                /*  Map<id,Project_Services__c> titleMap = new Map<id,Project_Services__c>();
                
                  for(Project_Services__c p : [select id,project__r.title__c,project__r.title__r.Marty_Title_ID__c, project__r.title__r.Name,  project__r.title__r.Is_In_Series__c, 
                                                  project__r.title__r.Full_Title_Name__c,project__r.title__r.Digital_Publication_Date__c,project__r.title__r.status__c
                                                  from Project_Services__c order by Estimated_Start_Date__c ASC limit 1000]) 
                      titleMap.put(p.project__r.title__c,p);
                    
                  
                      if(titleMap!=null) {
                         
                          for(String s : titleMap.keyset()) { 
                              if(w.size() <=7 ) {
                                  resWrp r = new resWrp();
                                  r.recId = titleMap.get(s).project__r.title__c;
                                  r.status = titleMap.get(s).project__r.title__r.status__c;
                                  r.digitalPublicationDate = titleMap.get(s).project__r.title__r.Digital_Publication_Date__c;
                                  r.recMartyId = titleMap.get(s).project__r.title__r.Marty_Title_ID__c;
                                  r.recName = titleMap.get(s).project__r.title__r.Name;
                                  r.isInSeries = titleMap.get(s).project__r.title__r.Is_In_Series__c;
                                  r.fullTitleName = titleMap.get(s).project__r.title__r.Full_Title_Name__c;
                                  w.add(r);
                              }
                          }
                      } */
                   
                   // Map<id,Project__c> titleMap = new Map<id,Project__c>();   
                    for(title__c t: [SELECT id, status__c, Digital_Publication_Date__c, Marty_Title_ID__c, Name, Is_In_Series__c, Full_Title_Name__c
                                      FROM title__c order by Digital_Publication_Date__c ASC])  {
                              if(w.size() <=7 ) {
                                  resWrp r = new resWrp();
                                  r.recId = t.id;
                                  r.status = t.status__c;
                                  r.digitalPublicationDate = t.Digital_Publication_Date__c;
                                  r.recMartyId = t.Marty_Title_ID__c;
                                  r.recName = t.Name;
                                  r.isInSeries = t.Is_In_Series__c;
                                  r.fullTitleName = t.Full_Title_Name__c;
                                  w.add(r);
                              }
                          }
                    for(Series__c t: [SELECT id,  Series_Title__c ,  Wombat_Series_ID__c
                                FROM Series__c])  {
                        if(w.size() <=7 ) {
                            resWrp r = new resWrp();
                            r.recId = t.id;
                            r.isSeries = true;
                            r.recMartyId = t.Wombat_Series_ID__c;
                            r.recName = t.Series_Title__c;
                          
                            w.add(r);
                        }
                    }
                                       
                 }
                
      return w;
      
    }
    
    public class getDataTitle {
        @AuraEnabled
        public title__c title{get;set;}
        @AuraEnabled
        public btnToggleResWrp btnToggle{get;set;}
    
    
    }
    
    public class resWrp {
        @AuraEnabled
        public string recId{get;set;}
        @AuraEnabled
        public string recName{get;set;}
        @AuraEnabled
        public string recMartyId{get;set;}
        @AuraEnabled
        public boolean isInSeries{get;set;}
        @AuraEnabled
        public boolean isSeries{get;set;}
        @AuraEnabled
        public string fullTitleName{get;set;}
        @AuraEnabled
        public string status{get;set;}
         @AuraEnabled
        public date digitalPublicationDate{get;set;}
    
    }
    
     public class btnToggleResWrp {
        @AuraEnabled
        public boolean cbBtn{get;set;}
        @AuraEnabled
        public boolean chinookBtn{get;set;}
        @AuraEnabled
        public boolean chinookCreateBtn{get;set;}
        @AuraEnabled
        public boolean transimittalBtn{get;set;}
        @AuraEnabled
        public integer servicesCount{get;set;}
         @AuraEnabled
        public String contactId{get;set;}
    
    }
    
     @AuraEnabled(cacheable=true)
     public static btnToggleResWrp checkBtnsAccess(String tId, Boolean isSeries) {
        system.debug(tId);
         
        Set<String> contIds = String.isNotBlank(label.PTF_button_Visibile_User_Id)? label.PTF_button_Visibile_User_Id.contains(',')? new Set<String>(label.PTF_button_Visibile_User_Id.split(',')) : new Set<String>{label.PTF_button_Visibile_User_Id}: new Set<String>();
        Set<String> titleIds =  String.isNotBlank(label.PTF_button_Visibile_title_ID)? label.PTF_button_Visibile_title_ID.contains(',')? new Set<String>(label.PTF_button_Visibile_title_ID.split(',')) : new Set<String>{label.PTF_button_Visibile_title_ID}: new Set<String>();
        
        
        btnToggleResWrp btnWrp = new btnToggleResWrp();
        // check creative brief access
        integer cbcount = [SELECT count() FROM Creative_Brief__c WHERE Title__r.Marty_Title_ID__c =: tId AND Title__r.Marty_Title_ID__c != null];
        btnWrp.cbBtn = cbcount>0? true : false;
         
        // check chinook access
        List<User> uLst = [SELECT  Contactid,Contact.Vendor__c,Contact.Vendor__r.Chinook_Access__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND id=: Userinfo.getUserId() limit 1];
       
        // check esp access
        List<esp__c> espLst = [SELECT id FROM esp__c WHERE Title__r.Marty_Title_ID__c =: tId AND Title__r.Marty_Title_ID__c != null];
        //btnWrp.cbBtn = cbLst.size()>0? true : false;
        if(uLst.size()>0) {
            if(!espLst.isEmpty()) {
            if(uLst[0].Contact.Vendor__r.Chinook_Access__c) 
                btnWrp.chinookBtn = true;
            else
                btnWrp.chinookBtn = false;  
            } else
                 btnWrp.chinookBtn = false; 
            
            integer servicecount=0;        
                    // commenting make less queries
              if(isSeries==true)
              for(AggregateResult Agg : [SELECT count(id)c FROM project_services__c WHERE project__r.series__r.Wombat_Series_ID__c =:tId AND project__r.series__r.Wombat_Series_ID__c != NULL AND 
                                                     vendor__c =:uLst[0].Contact.Vendor__c AND Status__c = 'Confirming'])
             	 btnWrp.servicesCount = Integer.valueOf(Agg.get('c')); 
            else   
                for(AggregateResult Agg : [SELECT count(id)c FROM project_services__c WHERE project__r.title__r.Marty_Title_ID__c=:tId AND project__r.title__r.Marty_Title_ID__c != NULL AND 
                                                     vendor__c =:uLst[0].Contact.Vendor__c AND Status__c = 'Confirming'])
              		btnWrp.servicesCount = Integer.valueOf(Agg.get('c')); 
           // check trasmittal form access   
              List<project_services__c> psLst = new List<project_services__c>();
            if(isSeries == true)
                psLst = [select id,Status__c,vendor__c,service__c,project__c,project__r.title__c,project__r.title__r.Marty_Title_ID__c ,project__r.name,service__r.name from project_services__c where project__r.series__r.Wombat_Series_ID__c =:tId AND project__r.series__r.Wombat_Series_ID__c != NULL AND
                                                         vendor__c =:uLst[0].Contact.Vendor__c];
            else
           		psLst = [select id,Status__c,vendor__c,service__c,project__c,project__r.title__c,project__r.title__r.Marty_Title_ID__c ,project__r.name,service__r.name from project_services__c where project__r.title__r.Marty_Title_ID__c=:tId AND project__r.title__r.Marty_Title_ID__c != NULL AND
                                                         vendor__c =:uLst[0].Contact.Vendor__c];
          /*  for(project_services__c pss: psLst)
                if(pss.Status__c == 'Confirming')
                    servicecount+= 1;
            btnWrp.servicesCount = servicecount;  */                                          
            if(titleIds.contains(tId) && contIds.contains(uLst[0].ContactId)) {
             
                    btnWrp.transimittalBtn = psLst.size()>0? true: false;
              
                  btnWrp.contactId = uLst[0].ContactId;  
             } 
             
               if(uLst[0].Contact.Vendor__r.Chinook_Access__c) {
                  btnWrp.chinookBtn = btnWrp.chinookBtn? btnWrp.chinookBtn: getAddtionalEspLogic(tId); // check additional access   
                  btnWrp.chinookBtn = btnWrp.chinookBtn? btnWrp.chinookBtn: checkAddLogicPSserviceNames(psLst , tId); // check additional access  
              }         
         } else
               btnWrp.transimittalBtn = false;
               
                
                
            system.debug(btnWrp);
            
          return btnWrp; 
       }
       
    public static boolean checkAddLogicPSserviceNames(List<project_services__c> psLst, String tId) {
     Set<String> esptitleeIds = new Set<String>();
       Set<String> espServices = new Set<String>();
          if(Label.CommunityESPServices.contains(','))
              espServices.addAll(Label.CommunityESPServices.split(','));
          else
              espServices.add(Label.CommunityESPServices); 
          for(project_services__c so: psLst ) {
               
                 if(so.get('Vendor__c') !=null && so.get('Service__c') != null && so.get('Project__c') !=null) {
                            if(espServices.contains(so.service__r.name)) 
                                   
                                   esptitleeIds.add(so.project__r.title__r.Marty_Title_ID__c);
                        
                    }     
                
                }
                system.debug(esptitleeIds);
                 system.debug(tId);
                return esptitleeIds.contains(tId);
    
    }   
       
    public static boolean getAddtionalEspLogic(String tId) {
        ppw_projectservicemassupdate_EST_Batch estb = new ppw_projectservicemassupdate_EST_Batch();
       
        Set<String> esptitleeIds = new Set<String>();
            set<String> objNames = new set<String>{'Comic_Book_Service__c', 'Cover_Service__c', 'Editorial_Service__c', 
                  'Full_Color_Service__c', 'Interior_Service__c', 'Promotional_Text_Service__c'};
                  
         List<project__c> pro = [SELECT id,title__c FROM project__c WHERE title__r.Marty_Title_ID__c=:tId]; 
         
          Set<String> espServices = new Set<String>();
          if(Label.CommunityESPServices.contains(','))
              espServices.addAll(Label.CommunityESPServices.split(','));
          else
              espServices.add(Label.CommunityESPServices);  
         
          for(String s: objNames) {
              String dQuery = estb.dyamicquery(s, pro);
            List<Sobject> slst = String.isNotBlank(dQuery)? database.query(dQuery): new List<Sobject>();
             for(Sobject so: slst) {
                 //frameKeyValuesMap(so.get('Vendor__c'),ps.id,vendortoPsMap);
                 if(so.get('Vendor__c') !=null && so.get('Service__c') != null && so.get('Project__c') !=null) {
                   
                         Sobject pproject = so.getSObject('Project__r');
                          if(so.get('Service__c')!=null)  {  
                            
                             Sobject sstr = so.getSObject('Service__r');
                          if(sstr != null) {
                                
                              if(espServices.contains(String.valueOf(sstr.get('Name')))) {
                                   
                                   esptitleeIds.add(String.valueOf(pproject.get('Title__c')));
                               }  
                            }
                             
                        }   
                        
                    }     
                
                }
            
          
              }   
       system.debug(esptitleeIds);
       system.debug(tId);
           if(!pro.isEmpty())
               return esptitleeIds.contains(pro[0].title__c);
           else
               return false;    
       
       }
    
    }