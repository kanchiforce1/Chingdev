/***********************************
Author:      Amazon Apub // kkolla@, michatem@
Used By:     Service Prep Form, Project controller extension
Description: Used to build XML for various logics. Single service, multiple Service XML, Vendor update, Service update, Dependencies XML build
************************************/   


global class ppw_censhareConnector {
    /*Defines the methods used to connect to censhare and update specific project services, or process an entire list of services together in one transaction. */
    
   // public static List<Project_services__c> psList1 = new List<Project_services__c>();
   
    public Map<String,Project_services__c>  existingPsMap;
    public Map<String,Service__c> servicesMap;
    public Map<String,Vendor__c> vendorMap;
    public Map<String,Project__c> projectMap;
    public List<String> projectIds = new List<String>();
    public String productionLocale;
    public Map<String,List<Project_services__c>> service_To_PsMap = new Map<String,List<Project_services__c>>();
    public string payloadHeader = '<?xml version="1.0" encoding="utf-8"?>';
    public string censhareBundleXMLBuilder(List<String> bIds, String operation) {
        List<Bundled_Project_Service__c>  bpsList = [SELECT id,(select Project__c from Project_Services__r),Actual_Start_Date__c ,Service_Complexity_Value__c ,
                                               Status__c , Total_Rate_Amount_with_Currency__c  FROM Bundled_Project_Service__c WHERE Id=: bIds];
        
        List<Bundled_Project_Service__c> bundleNewList = new List<Bundled_Project_Service__c>();
        List<Bundled_Project_Service__c> existingbundleList = new List<Bundled_Project_Service__c>();
         List<String> serviceIds = new List<String>();
        List<String> vendorIds = new List<String>();
              for(Bundled_Project_Service__c ps: bpsList) {
            if(operation == 'New')
               bundleNewList.add(ps);  
            else
               existingbundleList.add(ps);   
            if(ps.Bundled_Service__c  != null)
               serviceIds.add(ps.Bundled_Service__c );   
        
             if(ps.Bundled_Service__c != null)
                  vendorIds.add(ps.Bundled_Service__c); 
                  if(ps.Project_Services__r.isEmpty())
            		projectIds.add(ps.Project_Services__r[0].project__c);        
           
        }
        
          servicesMap = new Map<String,Service__c>([SELECT id,Name,Censhare_Template_ID__c,Service_Rate_Type__c,Service_Complexity_Value__c, US_Censhare_Template_ID__c,UK_Censhare_Template_ID__c,
                                                DE_Censhare_Template_ID__c, FR_Censhare_Template_ID__c, IT_Censhare_Template_ID__c, ES_Censhare_Template_ID__c, JP_Censhare_Template_ID__c,
                              (SELECT id,Dependent_Service__c,Parent_Service__c FROM Service_Dependencies1__r) , (SELECT id,Dependent_Service__c,Parent_Service__c FROM Service_Dependencies__r) 
                                                                      FROM Service__c WHERE id=:serviceIds]);
      
      vendorMap = new Map<String,Vendor__c>([SELECT id,Name FROM Vendor__c WHERE id =: vendorIds]);
       
       projectMap = new Map<String,Project__c>([SELECT id,Name,title__r.Marty_Title_ID__c, title__r.Production_Locale__c, series__r.Wombat_Series_ID__c,
                                                series__r.Production_Locale__c FROM Project__c WHERE id=:projectIds]);
       
         
        String serviceXml = '<services>';
        
            return null;
    }
    
    /*Build the XML body for any Project Service record being sent to censhare.
         * Logic for what get put into this method should start from the parent class where the call is being made. 
         */
    public string censhareXMLBuilder(list<Project_services__c> psList) {
       
         
        
       
        list<Project_services__c> psNewList = new list<Project_services__c>();
        list<Project_services__c> existingPsList = new list<Project_services__c>();
        existingPsMap = new Map<String,Project_services__c>([SELECT id,Service__c,Vendor__c, project__r.series__r.Wombat_Series_ID__c, project__c,project__r.title__r.Marty_Title_ID__c,Service__r.name,
                                                            Service__r.Censhare_Template_ID__c,service__r.Service_Complexity_Value__c
                                                             ,Honor_Dependencies__c,status__c,Vendor__r.name,Censhare_XML_update_type__c 
                                     
                                     FROM Project_Services__c WHERE id=:psList]);
         
      
       
        List<String> serviceIds = new List<String>();
        List<String> vendorIds = new List<String>();
      
        for(Project_services__c ps: psList) {
            if(ps.Censhare_XML_update_type__c == 'New')
               psNewList.add(ps);  
            else
               existingPsList.add(ps);   
            if(ps.Service__c != null)
               serviceIds.add(ps.Service__c);   
        
             if(ps.Vendor__c != null)
                  vendorIds.add(ps.Vendor__c); 
            projectIds.add(ps.project__c);        
           
        }
        set<string> activeSet = new set<string>();
         activeSet.addAll(label.Project_Service_Active_Status.split(','));
     for(project_services__c ps: [SELECT id,service__c,Service_Name__c,Master_PT_Service__c FROM project_services__c WHERE project__c=:projectIds and Status__c =:activeSet])
         if(service_To_PsMap.containsKey(ps.service__c))
             service_To_PsMap.get(ps.service__c).add(ps);
         else
             service_To_PsMap.put(ps.service__c, new List<Project_services__c>{ps});    
     
     system.debug('existingPsList'+existingPsList);
     system.debug('existingPsMap'+existingPsMap);
     
     system.debug(' psNewList'+ psNewList);
      servicesMap = new Map<String,Service__c>([SELECT id,Name,Censhare_Template_ID__c,Service_Rate_Type__c,Service_Complexity_Value__c, US_Censhare_Template_ID__c,UK_Censhare_Template_ID__c,
                                                DE_Censhare_Template_ID__c, FR_Censhare_Template_ID__c, IT_Censhare_Template_ID__c, ES_Censhare_Template_ID__c, JP_Censhare_Template_ID__c,
                              (SELECT id,Dependent_Service__c,Parent_Service__c FROM Service_Dependencies1__r) , (SELECT id,Dependent_Service__c,Parent_Service__c FROM Service_Dependencies__r) 
                                                                      FROM Service__c WHERE id=:serviceIds]);
      
      vendorMap = new Map<String,Vendor__c>([SELECT id,Name FROM Vendor__c WHERE id =: vendorIds]);
       
       projectMap = new Map<String,Project__c>([SELECT id,Name,title__r.Marty_Title_ID__c, title__r.Production_Locale__c, series__r.Wombat_Series_ID__c,
                                                series__r.Production_Locale__c FROM Project__c WHERE id=:projectIds]);
       
         
        String serviceXml = '<services>';
        
        //new ps
        for(Project_services__c ps: psNewList) {
            system.debug(serviceXml);
            serviceXml = serviceXml+ xmlNewPsBuilder(ps);
            system.debug(serviceXml);
        }
        system.debug(serviceXml);
        // existing ps
      
        for(Project_services__c ps: existingPsList) {
            if(existingPsMap != null && !existingPsMap.isEmpty() && ps.id != null && !existingPsList.isEmpty())
                serviceXml = serviceXml+ xmlExistingPsBuilder(ps);
        }
       
        serviceXml = serviceXml+ '</services>';
         system.debug(serviceXml);
        return payloadHeader + serviceXml;
    }
   
 
   
   // vendor change
    public string vendorXmlBuilder(Project_services__c ps, String xmlExist) {
         if(ps.Vendor__c!=null) {
             xmlExist = xmlExist + '<vendorID>' + makeShortId(ps.Vendor__c)+'</vendorID>';
             xmlExist = xmlExist +'<vendorName>' + (vendorMap != null? vendorMap.containsKey(ps.Vendor__c)? vendorMap.get(ps.Vendor__c).name : null : null)+'</vendorName>';
         }
         return  xmlExist;
   }
   
   public String makeShortId(String cId) {
       if(cId!=null)
           return cId.substring(0, 15);
       else
           return cId;    
   }
   
   // service change
    public String serviceXml(Project_services__c ps,String xe) {
       system.debug(xe);
       
       xe = xe +'<serviceID>' + makeShortId(ps.id)+'</serviceID>';
        String csLocaleTemplateId = getLocalecsTemplateId(ps);
       if(servicesMap != null)
           if(servicesMap.containskey(ps.Service__c)) {
           if(ps.Service__c!=null)
           xe = xe + '<serviceName>' + getServiceType(servicesMap.get(ps.Service__c)) +'</serviceName>';
           if(servicesMap.get(ps.Service__c).Censhare_Template_ID__c!=null)
            xe = xe +  (String.isNotBlank(csLocaleTemplateId)?  csLocaleTemplateId : '');// '<csTemplateID>' + servicesMap.get(ps.Service__c).Censhare_Template_ID__c +'</csTemplateID>' ;
            if(servicesMap.get(ps.Service__c).Service_Complexity_Value__c != null)
            xe = xe + '<complexityID>' + servicesMap.get(ps.Service__c).Service_Complexity_Value__c+'</complexityID>';
           return xe;
           }
     
      
       system.debug(xe);
    return xe;
    }
    
    // update promo text services to other name and remainiang services are same 
    public String getServiceType(Service__c ser) {
        if(ser.Name == 'Promo Text Creation')
            return 'Promo Text Service Package' ;
        else
            return getescapexml(ser.Service_Rate_Type__c);     
        
    }
    
    //status change
    public string statusXmlBuilder(Project_services__c ps, String xmle) {
         if(ps.status__c!=null) {
             xmle = xmle+ '<serviceSchedulingStatus>' + ps.status__c +'</serviceSchedulingStatus>';
             xmle = xmle+ '<updateType>Status</updateType>';
         }
        return  xmle;
    }
    
    // service dependency xml builer
   
    
    /* If a service has a dependency requirement, this method will flush out the proper Project_Services__c IDs to include in the web call. 
         */    
      
    public String serviceDepdencysXmlBuilder(Project_services__c ps) {
        String dService = '';
        if(servicesMap .containsKey(ps.service__c)) {
            for(Service_Dependency__c sd : servicesMap.get(ps.service__c).Service_Dependencies1__r)
                if(service_To_PsMap.containsKey(sd.Parent_Service__c))
                    for(Project_services__c s: service_To_PsMap.get(sd.Parent_Service__c)) 
                        if(s.Service_Name__c == 'Promo Text Creation') {
                            if(s.Master_PT_Service__c == true)
                                dService = dService+'<csDependencyID>' + makeShortId(s.id) +'</csDependencyID>';
                       } else
                             dService = dService+'<csDependencyID>' + makeShortId(s.id) +'</csDependencyID>';     
                  
                        
           //dService = dService+ '<updateType>Complexity</updateType>';             
          //  for(Service_Dependency__c sd : servicesMap.get(ps.service__c).Service_Dependencies__r)
                //if(service_To_PsMap.containsKey(sd.Dependent_Service__c))
                  //  for(String s: service_To_PsMap.get(sd.Dependent_Service__c))
                       // dService = dService+'<csDependencyID>' + makeShortId(s) +'</csDependencyID>';            
                        
        }    
            
        return dService;
    }
    
     // service dependency xml builer
    
    /* If a service has a dependency requirement, this method will flush out the proper Project_Services__c IDs to include in the web call. 
         */    
     /* public String existingServiceDepdencysXmlBuilder(Project_services__c ps) {
        String dService = '';
        if(servicesMap .containsKey(ps.service__c)) {
            for(Service_Dependency__c sd : servicesMap.get(ps.service__c).Service_Dependencies1__r)
                if(service_To_PsMap.containsKey(sd.Parent_Service__c))
                    for(String s: service_To_PsMap.get(sd.Parent_Service__c))
                        dService = dService+'<csDependencyID>' + makeShortId(s) +'</csDependencyID>';
                        
          //  for(Service_Dependency__c sd : servicesMap.get(ps.service__c).Service_Dependencies__r)
                //if(service_To_PsMap.containsKey(sd.Dependent_Service__c))
                  //  for(String s: service_To_PsMap.get(sd.Dependent_Service__c))
                       // dService = dService+'<csDependencyID>' + makeShortId(s) +'</csDependencyID>';            
                        
        }    
            
        return dService;
    } */
    
    public String xmlExistingPsBuilder(Project_services__c ps) {
        String xmlExist = '';
        if(existingPsMap.get(ps.id).project__r.series__r!=null)
            xmlExist = xmlExist + '<scheduledService><titleID>'+ existingPsMap.get(ps.id).project__r.series__r.Wombat_Series_ID__c + '</titleID>' ;
        else
            if(existingPsMap.get(ps.id).project__r.title__r.Marty_Title_ID__c!=null)
                xmlExist = xmlExist + '<scheduledService><titleID>'+ existingPsMap.get(ps.id).project__r.title__r.Marty_Title_ID__c + '</titleID>' ;
        if(ps.Service__c != existingPsMap.get(ps.id).Service__c) { // service will get change from service prep form
            
             if(!(ps.Vendor__c != existingPsMap.get(ps.id).vendor__c)) {
                   xmlExist = serviceXml(ps,xmlExist);
                   xmlExist = vendorXmlBuilder(ps,xmlExist);
                   xmlExist = xmlExist + '<serviceSchedulingStatus>In Planning</serviceSchedulingStatus>';
             }
              xmlExist = xmlExist + '<updateType>Service</updateType>'; 
        }
        // vendor will get change when we change service edit service button               
         if(ps.Vendor__c != existingPsMap.get(ps.id).vendor__c) {
           xmlExist = serviceXml(ps,xmlExist); 
           xmlExist = vendorXmlBuilder(ps,xmlExist) + '<updateType>Vendor</updateType>';
           if(existingPsMap.get(ps.id).status__c!=null)   
           xmlExist = xmlExist + '<serviceSchedulingStatus>' + existingPsMap.get(ps.id).status__c +'</serviceSchedulingStatus>';
         }   
           system.debug(xmlExist);
         if(ps.Status__c != existingPsMap.get(ps.id).Status__c) {
             xmlExist = serviceXml(ps,xmlExist); 
              xmlExist = vendorXmlBuilder(ps,xmlExist);
              xmlExist = statusXmlBuilder(ps,xmlExist);
             
         }   
          
          if(ps.Honor_Dependencies__c) {
              xmlExist = serviceXml(ps,xmlExist);
              xmlExist = xmlExist + serviceDepdencysXmlBuilder(ps);
              
              }  
            
       system.debug(xmlExist);     
        return xmlExist + '</scheduledService>';  
    }
    
   
    
     public String xmlNewPsBuilder(Project_services__c ps) {
        String xmlnew = '<scheduledService>';
      
        xmlnew = xmlnew+ basicXmlBuilder(ps);
        system.debug(xmlnew);
        if(ps.Honor_Dependencies__c)
            xmlnew = xmlnew+ serviceDepdencysXmlBuilder(ps);
        system.debug(xmlnew);
        return xmlnew+ '<updateType>New</updateType></scheduledService>'; 
    
    }
    
    public String basicXmlBuilder(Project_services__c ps) {
       system.debug(ps);
       String csLocaleTemplateId = getLocalecsTemplateId(ps);
       String xmlreq = ''; //series__r.Wombat_Series_ID__c
          if(projectMap.get(ps.project__c).series__r!=null)
           xmlreq = xmlreq + projectMap.get(ps.project__c).series__r.Wombat_Series_ID__c!=null? ('<titleID>'+  projectMap.get(ps.project__c).series__r.Wombat_Series_ID__c + '</titleID>') : '';
          else xmlreq = xmlreq + projectMap.get(ps.project__c).title__r.Marty_Title_ID__c!=null? ('<titleID>'+ projectMap.get(ps.project__c).title__r.Marty_Title_ID__c + '</titleID>') : '';
          xmlreq = xmlreq + '<serviceID>' + makeShortId(ps.id)+'</serviceID>';
          xmlreq = xmlreq + ((ps.Service__c!=null? servicesMap.get(ps.Service__c).Service_Rate_Type__c: null)!=null? ('<serviceName>' + getServiceType(servicesMap.get(ps.Service__c)) +'</serviceName>'):''); 
          xmlreq = xmlreq + (String.isNotBlank(csLocaleTemplateId)?  csLocaleTemplateId : '');//((ps.Service__c!=null? servicesMap.get(ps.Service__c).Censhare_Template_ID__c:null)!=null? ('<csTemplateID>' + servicesMap.get(ps.Service__c).Censhare_Template_ID__c +'</csTemplateID>') : ''); 
          xmlreq = xmlreq + ((ps.Service__c!=null? servicesMap.get(ps.service__c).Service_Complexity_Value__c:null)!=null? ('<complexityID>' + servicesMap.get(ps.service__c).Service_Complexity_Value__c+'</complexityID>') : '');
          xmlreq = xmlreq + ((ps.status__c!=null? ps.status__c : null)!=null? ('<serviceSchedulingStatus>' + ps.status__c +'</serviceSchedulingStatus>') : '');
          xmlreq = xmlreq +     (ps.Vendor__c!=null? ('<vendorID>' + makeShortId(ps.Vendor__c)+'</vendorID>') : ''); 
          xmlreq = xmlreq +     ((ps.Vendor__c!=null? vendorMap.get(ps.Vendor__c).name: null)!=null? ('<vendorName>' + getescapexml(vendorMap.get(ps.Vendor__c).name) +'</vendorName>') : '');
        
       return xmlreq;
    }
    
  private String getLocalecsTemplateId(Project_services__c ps) {
     String locale = projectMap.get(ps.project__c)!=null? (projectMap.get(ps.project__c).series__r!=null? projectMap.get(ps.project__c).series__r.Production_Locale__c : projectMap.get(ps.project__c).title__r.Production_Locale__c): '';
     Service__c s = servicesMap.get(ps.Service__c);
     String cstempId = String.isNotBlank(locale)? locale == 'US'? s.US_Censhare_Template_ID__c : (locale == 'US'? s.US_Censhare_Template_ID__c : locale == 'UK'? s.UK_Censhare_Template_ID__c : locale == 'DE'? s.DE_Censhare_Template_ID__c : locale == 'FR'? s.FR_Censhare_Template_ID__c : locale == 'IT'? s.IT_Censhare_Template_ID__c : locale == 'ES'? s.ES_Censhare_Template_ID__c :locale == 'JP'? s.JP_Censhare_Template_ID__c: null) : null;
     if(csTempId!=null)
         return  ('<csTemplateID>' + cstempId +'</csTemplateID>');
      else return null;
  }  
    
  public String getescapexml(String sxml) {
      if(sxml!=null)
          return sxml.escapeXml();
      else
          return sxml;    
  
  }
  
  
   // when single ps record is creating  
       @Future(callout=true)
    public static void censhareService(String xmlBody,String psId) {
        List<Project_services__c> psList1 = new List<Project_services__c>();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://na72.salesforce.com/services/apexrest/ProjectServices/');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/xml');
        req.setHeader('Accept', 'application/xml');
        req.setBody(xmlBody);
        req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        HttpResponse res = h.send(req);
      
       // serviceDownAsyncErrorMessage(new set<String>{psId});
         String cenRes = res.getBody();                       
        if(cenRes != null && cenRes!='') {
            if(String.isNotEmpty(cenRes)) {  // body success 
                String reBody = String.valueOf(res.getBody()).unescapeXml();
                system.debug(reBody);
                XmlStreamReader reader = new XmlStreamReader(reBody);
                List<Project_services__c> psList = [select id,Master_PT_Service__c,project__c, Service_Name__c from Project_services__c where id=:psId];
              
                 Map<String,Project_services__c> psDataMap = new Map<String,Project_services__c>();
               
               for(Project_services__c ps1 : psList)
                   psDataMap.put(ps1.id,ps1);
                
                psList1 = parseProjectServicesInsert(reader,psId, psDataMap);
                system.debug('psList1'+psList1);
                update psList1;
             } else serviceDownAsyncErrorMessage(new set<String>{psId}); // body empty or body fail 
        } else serviceDownAsyncErrorMessage(new set<String>{psId});  //// body empty or body fail  
           
    }
    
    // when mulitiple ps records is creating  
       @Future(callout=true)
    public static void censhareServiceMultiple(String xmlBody,set<String> psIds) {
        List<Project_services__c> psList1 = new List<Project_services__c>();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://na72.salesforce.com/services/apexrest/ProjectServices/');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/xml');
        req.setHeader('Accept', 'application/xml');
        req.setBody(xmlBody);
        req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        HttpResponse res = h.send(req);
        
       //  serviceDownAsyncErrorMessage(psIds);                           
       String cenRes = res.getBody();                       
        if(cenRes != null && cenRes != '') {
            if(String.isNotEmpty(cenRes)) {    // body success                 
                String reBody = cenRes.unescapeXml();
                system.debug(reBody);
                XmlStreamReader reader = new XmlStreamReader(reBody);
                psList1 = parseMulitiplePSsInsert(reader,psIds);
                system.debug('psList1'+psList1);
                     
                update psList1;
            } else serviceDownAsyncErrorMessage(psIds); // body empty or body fail
            
        } else serviceDownAsyncErrorMessage(psIds);  // body empty or body fail
           
    }
    
     @AuraEnabled
    public static String getCalloutResponseContents() {
        system.debug(getSessionIdFromVFPage(Page.getsessionid));
        return getSessionIdFromVFPage(Page.getsessionid);
    }
    
    
    
    
    public static String getSessionIdFromVFPage(PageReference visualforcePage){
        String content;
          if(Test.isRunningTest()){
            content = 'Start_Of_Session_Id: 2323233sdsdsddssdddddd End_Of_Session_Id';
        }else{
            content = visualforcePage.getContent().toString();}
        
        Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                e = content.indexOf('End_Of_Session_Id');
        return content.substring(s, e);
    }
    
    
    //here updating estimated start and end dates for promo text services
  /*  public void updatePromotionalPsRecords(List<Project_services__c> upLst) {
        List<Project_services__c> psLst1 = new List<Project_services__c>();
        List<Project_services__c> promotialPs = [SELECT id,Estimated_Start_Date__c,Estimated_Completion_Date__c FROM Project_services__c WHERE Service__r.Name LIKE 'Promo Text Creation' AND Project__c =: projectIds AND id =: upLst LIMIT 1];
        if(!promotialPs.isEmpty())
        for(Project_services__c ps: [SELECT id,Estimated_Start_Date__c,Estimated_Completion_Date__c FROM Project_services__c WHERE Service__r.Name LIKE 'Promo Text Creation' AND Project__c =: projectIds AND id !=: upLst]) {
            ps.Estimated_Start_Date__c = promotialPs[0].Estimated_Start_Date__c;
            ps.Estimated_Completion_Date__c = promotialPs[0].Estimated_Completion_Date__c;
            psLst1.add(ps);
        }
        update psLst1;
    }*/
    
   // single or mulitple PSes Sync service(Update Ps)
    public static resWrap censhareServiceSync(String xmlBody) {
         
        List<Project_services__c> psList1 = new List<Project_services__c>();
        resWrap rWrp = new resWrap();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://na72.salesforce.com/services/apexrest/ProjectServices/');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/xml');
        req.setHeader('Accept', 'application/xml');
        req.setBody(xmlBody);
        req.setHeader('Authorization','Bearer '+getCalloutResponseContents());
        HttpResponse res = h.send(req);
      // return serviceDownSyncErrorMessage();
        String cenRes = res.getBody();
        if(cenRes != null && cenRes != '') { //serviceDownSyncErrorMessage
            if(String.isNotEmpty(cenRes)) {
                String reBody = String.valueOf(cenRes).unescapeXml();
                system.debug(reBody);
                XmlStreamReader reader = new XmlStreamReader(reBody);
                //rWrp.resStatus = true;
               rWrp = parsePSsyncService(reader);
            } else return serviceDownSyncErrorMessage();  // body empty or body fail
                
        } else return serviceDownSyncErrorMessage();  // body empty or body fail
        system.debug('rWrp'+rWrp);
       
        return rWrp;
           
    }
    
     // single or mulitple bulk PSes Sync service(Update Ps)
    public static Map<String,resWrap> censhareBulkServiceSync(String xmlBody) {
         
        List<Project_services__c> psList1 = new List<Project_services__c>();
        Map<String,resWrap> rWrpMap = new Map<String,resWrap>();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://na72.salesforce.com/services/apexrest/ProjectServices/');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/xml');
        req.setHeader('Accept', 'application/xml');
        req.setBody(xmlBody);
        req.setHeader('Authorization','Bearer '+getCalloutResponseContents());
        HttpResponse res = h.send(req);
     
        String cenRes = res.getBody();
        if(cenRes != null && cenRes != '') { 
            if(String.isNotEmpty(cenRes)) {
                String reBody = String.valueOf(cenRes).unescapeXml();
                system.debug(reBody);
                XmlStreamReader reader = new XmlStreamReader(reBody);
                //rWrp.resStatus = true;
               rWrpMap = parseBulkPSsyncService(reader);
            } else return bulkServiceDownSyncErrorMessage();  // body empty or body fail
                
        } else return bulkServiceDownSyncErrorMessage();  // body empty or body fail
        system.debug('rWrpMap'+rWrpMap);
       
        return rWrpMap;
           
    }
   
   
    // single PS Sync Kick off service(Update Ps) disabled bcoz censhare kickoff has not yet been ready
   /* public static resWrap censhareKickOffServiceSync(String xmlBody) {
         
        List<Project_services__c> psList1 = new List<Project_services__c>();
        resWrap rWrp = new resWrap();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://na72.salesforce.com/services/apexrest/ProjectServices1/');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/xml');
        req.setHeader('Accept', 'application/xml');
        req.setBody(xmlBody);
        req.setHeader('Authorization','Bearer '+ '0'+ UserInfo.getSessionId());
        HttpResponse res = h.send(req);
      // return serviceDownSyncErrorMessage();
        String cenRes = res.getBody();
        if(cenRes != null && cenRes != null) { //serviceDownSyncErrorMessage
            if(String.isNotEmpty(cenRes)) {
                String reBody = String.valueOf(cenRes).unescapeXml();
                system.debug(reBody);
                XmlStreamReader reader = new XmlStreamReader(reBody);
                //rWrp.resStatus = true;
               rWrp = parsePSsyncService(reader);
            } else return serviceDownSyncErrorMessage();  // body empty or body fail
                
        } else return serviceDownSyncErrorMessage();  // body empty or body fail
        system.debug('rWrp'+rWrp);
       
        return rWrp;
           
    } */
   
   public class resWrap {
       @AuraEnabled
       public Boolean resStatus{get;set;}
       @AuraEnabled
       public String resErrorMes{get;set;}
       @AuraEnabled
       public Boolean kickOffRes{get;set;}
       @AuraEnabled
       public Map<String,Project_services__c> resPs{get;set;}
       @AuraEnabled
       public Project_services__c resProjectService{get;set;}
       
   }
  
    // this method will call when service down or body is empty for sync service
      public static resWrap serviceDownSyncErrorMessage() {
        resWrap rWrp = new resWrap();
        rWrp.resStatus = false;
        rWrp.resErrorMes = 'Job Failed - Empty response body received from censhare side';
        return rWrp;
      
        
      }
  
  
  // this method will call when bulk service down or body is empty for sync service
      public static Map<String,resWrap> bulkServiceDownSyncErrorMessage() {
        Map<String,resWrap> rWrpMap = new Map<String,resWrap>();
        resWrap rWrp = new resWrap();
        rWrp.resStatus = false;
        rWrp.resErrorMes = 'Job Failed - Empty response body received from censhare side';
        rWrpMap.put('',rWrp);
        return rWrpMap;
      
        
      }
     // this method will call when service down or body is empty for Async service 
      public static void serviceDownAsyncErrorMessage(set<String> psIds) {
          List<Project_services__c> pslst = new List<Project_services__c>();
          
          for(Project_services__c ps: [select id,Censhare_XML_Error_Response__c from Project_services__c where id=:psIds]) {
            
             ps.Censhare_XML_Error_Response__c = 'Job Failed - Empty response body received from censhare side';
             pslst.add(ps);
          }
          update pslst;
     
      }
      
      
       // single or multiple ps updating process (sync Process)
    
     public static Map<String,resWrap> parseBulkPSsyncService(XmlStreamReader reader) {
        Map<String,resWrap> resWrpMap = new Map<String,resWrap>();
          boolean censhareStatus = false;
        
          //Project_services__c ps = new Project_services__c();
         // List<Project_services__c> psList = new List<Project_services__c>();
        Map<String,Project_services__c> psMap = new Map<String,Project_services__c>();
        system.debug(reader);
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
              String resPSId;
            resWrap rWrp = new resWrap();
            system.debug(reader.getEventType());
             system.debug(reader.getLocalName());
             system.debug(XmlTag.START_ELEMENT);
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                  if ('error' == reader.getLocalName()) {
                   Project_services__c ps = parseProjectServiceErrorType(reader);
                   
                    if(ps.Censhare_XML_Error_Response__c!=null) {
                        ps.Censhare_XML_Error_Response__c = ps.Censhare_XML_Error_Response__c.trim();
                        if(ps.Censhare_XML_Error_Response__c != '' && ps.Censhare_XML_Error_Response__c != ' ') { 
                        rWrp.resStatus = false;
                        rWrp.resProjectService = ps;
                        resPSId = ps.Id;
                       // return rWrp;
                        }
                      } 
                      censhareStatus = true; 
                  }
            
                if ('service' == reader.getLocalName()) {
                    
                    Project_services__c ps = parseProjectService(reader,psMap, new Map<String,Project_services__c>());
                    rWrp.resStatus = true;
                    rWrp.resProjectService = ps;
                    resPSId = ps.Id;
                  //  censhareStatus = true;
                   // psList.add(ps);
                  // psMap.put(ps.id,ps);
                }
             
                
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
            if(resPSId!=null)
                resWrpMap.put(resPSId, rWrp);
        }
        system.debug(resWrpMap);
        // rWrp.resStatus = censhareStatus;
        // rWrp.resPs = psMap;
         return resWrpMap;
     }
    
    
    // single or multiple ps updating process (sync Process)
    
     public static resWrap parsePSsyncService(XmlStreamReader reader) {
         resWrap rWrp = new resWrap();
          boolean censhareStatus = false;
         // List<Project_services__c> psList = new List<Project_services__c>();
        Map<String,Project_services__c> psMap = new Map<String,Project_services__c>();
        system.debug(reader);
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            system.debug(reader.getEventType());
             system.debug(reader.getLocalName());
             system.debug(XmlTag.START_ELEMENT);
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                  if ('error' == reader.getLocalName()) {
                    Project_services__c ps = parseProjectServiceErrorType(reader);
                   
                    if(ps.Censhare_XML_Error_Response__c!=null) {
                        ps.Censhare_XML_Error_Response__c = ps.Censhare_XML_Error_Response__c.trim();
                        if(ps.Censhare_XML_Error_Response__c != '' && ps.Censhare_XML_Error_Response__c != ' ') { 
                        rWrp.resStatus = false;
                        rWrp.resPs = new map<String,Project_services__c> {ps.id=>ps};
                        return rWrp;
                        }
                      } 
                      censhareStatus = true; 
                  }
            
                if ('service' == reader.getLocalName()) {
                    
                    Project_services__c ps = parseProjectService(reader,psMap, new Map<String,Project_services__c>());
                    censhareStatus = true;
                   // psList.add(ps);
                   psMap.put(ps.id,ps);
                }
                
               /*  if ('censhare_kick_off' == reader.getLocalName()) {
                     String kickOff = censhareKickOff(reader);
                     if(kickOff!=null)
                         rWrp.kickOffRes = Boolean.valueOf(kickOff);
                     else
                         rWrp.kickOffRes = false;    
                 
                } */
                
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
         rWrp.resStatus = censhareStatus;
         rWrp.resPs = psMap;
         return rWrp;
     }
    
    
    // single ps creating process (Async Process)
    
     public static List<Project_services__c> parseProjectServicesInsert(XmlStreamReader reader,String psId,  Map<String,Project_services__c> psDataMap) {
         boolean censhareStatus = false;
        List<Project_services__c> psList = new List<Project_services__c>();
        Map<String,Project_services__c> psMap = new Map<String,Project_services__c>();
        
        system.debug(reader);
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            system.debug(reader.getEventType());
             system.debug(reader.getLocalName());
             system.debug(XmlTag.START_ELEMENT);
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                  if ('error' == reader.getLocalName()) {
                    
                    Project_services__c ps = parseProjectServiceErrorType(reader);
                    if(ps.Censhare_XML_Error_Response__c!=null) {
                        ps.Censhare_XML_Error_Response__c = ps.Censhare_XML_Error_Response__c.trim();
                        if(ps.Censhare_XML_Error_Response__c != '' && ps.Censhare_XML_Error_Response__c != ' ') { 
                            ps.id = psId;
                            psmap.put(ps.id,ps);
                        }
                    }  
                    censhareStatus = false;  
                  }
            
                if ('service' == reader.getLocalName()) {
                    
                    Project_services__c ps = parseProjectService(reader,psMap , psDataMap);
                    ps.id = psId;
                    psmap.put(ps.id,ps);
                    censhareStatus = true;
                   
                    
                }
                
                if ('title' == reader.getLocalName()) {
                    
                    String cpId = getcenshare_projectid(reader);
                        project__c p = new project__c(id= psDataMap.get(psId).project__c,Censhare_Project_ID__c=cpId);
                        update p;
                   
                }
                
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        //return psList;
        return psmap.values();
    }

     // mulitiple pses creating process  (Async Process)
    
     public static List<Project_services__c> parseMulitiplePSsInsert(XmlStreamReader reader,set<String> psIds) {
        List<Project_services__c> psList = [select id,Master_PT_Service__c,project__c,Service_Name__c from Project_services__c where id=:psIds];
        Map<String,Project_services__c> psMap = new Map<String,Project_services__c>();
         Map<String,Project_services__c> psDataMap = new Map<String,Project_services__c>();
       
       for(Project_services__c ps1 : psList)
           psDataMap.put(ps1.id,ps1);
               
        
        system.debug(reader);
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            system.debug(reader.getEventType());
             system.debug(reader.getLocalName());
             system.debug(XmlTag.START_ELEMENT);
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                  if ('error' == reader.getLocalName()) {
                    for(Project_services__c s: psList) {
                       Project_services__c ps = s;
                        ps.Censhare_XML_Error_Response__c = parseMulitpleProjectServiceErrorType(reader);
                        if(ps.Censhare_XML_Error_Response__c!=null) {
                            ps.Censhare_XML_Error_Response__c = ps.Censhare_XML_Error_Response__c.trim();
                            if(ps.Censhare_XML_Error_Response__c != '' && ps.Censhare_XML_Error_Response__c != ' ') { 
                                 if(ps.id != null) {
                                    psMap.put(ps.id,ps);
                                    break;
                                }
                             }      
                        }
                    }
                  }
            
                if ('service' == reader.getLocalName()) {
                    
                    Project_services__c ps = parseProjectService(reader,psMap, psDataMap);
                    if(ps.id != null)
                        psMap.put(ps.id,ps);
                   
                }
                
               if ('title' == reader.getLocalName()) {
                    
                    String cpId = getcenshare_projectid(reader);
                        project__c p = new project__c(id=psList[0].project__c,Censhare_Project_ID__c=cpId);
                        update p;
                   
                }
            }
          
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return psMap.values();
    }
    
     // Parse through the XML, determine the author and the characters
  /* @testvisible
   static String censhareKickOff(XmlStreamReader reader) {
        if(reader.getAttributeValue(null, 'censhare_kick_off')!=null && reader.getAttributeValue(null, 'censhare_kick_off') != 'null')
           return reader.getAttributeValue(null, 'censhare_kick_off');
        else
            return null;    
    } 
    
    */
    
    
    static String getcenshare_projectid(XmlStreamReader reader) {
         if(reader.getAttributeValue(null, 'censhare_projectid')!=null && reader.getAttributeValue(null, 'censhare_projectid') != 'null')
            return String.valueof(reader.getAttributeValue(null, 'censhare_projectid'));  //censhare_assetid
         else
             return '';  
    
    }
    
    // Parse through the XML, determine the author and the characters
    static Project_services__c parseProjectService(XmlStreamReader reader, Map<String,Project_services__c> psMap, Map<String,Project_services__c> psDataMap) {
         Project_services__c ps = new Project_services__c();
         system.debug(reader.getAttributeValue(null, 'serviceID'));
         system.debug(reader.getAttributeValue(null,'start'));
         system.debug(reader.getAttributeValue(null, 'end'));
         system.debug(reader.getAttributeValue(null, 'import_type'));
                 if(reader.getAttributeValue(null, 'serviceID')!=null && reader.getAttributeValue(null, 'serviceID') != 'null')
                     ps.id = id.valueof(reader.getAttributeValue(null, 'serviceID'));  //censhare_assetid
                 system.debug(psDataMap);
                 system.debug(ps.id);
                 if(psDataMap.containsKey(ps.Id)) {//Service_Name__c
                     if(psDataMap.get(ps.Id).Service_Name__c == 'Promo Text Creation')
                        ps.Master_PT_Service__c = true;
                      
                 }     
                 ps.Estimated_Start_Date__c = reader.getAttributeValue(null,'start')!=null? date.valueOf(reader.getAttributeValue(null,'start')) : null;
                 ps.Estimated_Completion_Date__c = date.valueOf(reader.getAttributeValue(null, 'end'))!=null? date.valueOf(reader.getAttributeValue(null, 'end')): null;
                 ps.Censhare_XML_update_type__c  = reader.getAttributeValue(null, 'import_type')!=null? reader.getAttributeValue(null, 'import_type') : '';
                 ps.Censhare_Asset_ID__c = reader.getAttributeValue(null, 'censhare_assetid')!=null? reader.getAttributeValue(null, 'censhare_assetid') : '';
                 ps.Censhare_XML_Error_Response__c  = null;
                 
                // psList1.add(ps);
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.START_ELEMENT) {
              
                   if ('error' == reader.getLocalName()) {
                        ps.Censhare_XML_Error_Response__c = parseMulitpleProjectServiceErrorType(reader);
                        if(ps.Censhare_XML_Error_Response__c!=null) {
                            ps.Censhare_XML_Error_Response__c = ps.Censhare_XML_Error_Response__c.trim();
                            if(ps.Censhare_XML_Error_Response__c != '' && ps.Censhare_XML_Error_Response__c != ' ') { 
                                 if(ps.id != null) {
                                    psMap.put(ps.id,ps);
                                    break;
                                }
                             }      
                        }
                     //system.debug(reader.getPIData());
                 
                 }
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return ps;
    }
    
     // Parse through the XML, determine the author and the characters for error type
    static Project_services__c parseProjectServiceErrorType(XmlStreamReader reader) {
    
    Project_services__c ps = new Project_services__c();
       
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                   system.debug(reader.getText());
                   if(reader.getText() != null && reader.getText() != '') {
                     ps.Censhare_XML_Error_Response__c = reader.getText();
                   
                   }
                
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return ps;
    }
    
    
        // Parse through the XML, determine the author and the characters for error type
    @testvisible
    static String parseMulitpleProjectServiceErrorType(XmlStreamReader reader) {
    
       
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                   system.debug(reader.getText());
                   if(reader.getText() != null && reader.getText() != '') {
                    // ps.Censhare_XML_Error_Response__c = reader.getText();
                    //return 'Censhare Service has been failed please connect with system administrator';
                    return reader.getText();
                   
                   }
                
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return null;
    }
    
    
    
}