/***********************************
Author:      Amazon Apub // kkolla@, michatem@
Used By:    
Description: 
************************************/   


global class ppw_censhareConnect_PSUpdate {
   
   
  
    public string censhareXMLBuilder(list<Project_services__c> psList) {
        string payloadHeader = '<?xml version="1.0" encoding="utf-8"?>';
     
       Map<String,Service__c> servicesMap;
       Map<String,Vendor__c> vendorMap;
       set<String> serviceIds = new set<String>();
       List<String> vendorIds = new List<String>();
       psList = [SELECT id,Service__c,Vendor__c, project__c,project__r.title__r.Marty_Title_ID__c,Service__r.name,
                                                            Service__r.Censhare_Template_ID__c,service__r.Service_Complexity_Value__c
                                                             ,Honor_Dependencies__c,status__c,Vendor__r.name,Censhare_XML_update_type__c 
                                     
                                     FROM Project_Services__c WHERE id=:psList]; 
        for(Project_Services__c ps: psList) {
            if(ps.Service__c != null)
               serviceIds.add(ps.Service__c); 
            if(ps.Vendor__c != null)
                 vendorIds.add(ps.Vendor__c);       
            
        }
        
        servicesMap = new Map<String,Service__c>([SELECT id,Name,Censhare_Template_ID__c,Service_Rate_Type__c,Service_Complexity_Value__c,
                              (SELECT id,Dependent_Service__c,Parent_Service__c FROM Service_Dependencies1__r) , (SELECT id,Dependent_Service__c,Parent_Service__c FROM Service_Dependencies__r) 
                                                                      FROM Service__c WHERE id=:serviceIds]);
       
        vendorMap = new Map<String,Vendor__c>([SELECT id,Name FROM Vendor__c WHERE id =: vendorIds]);
        String sdataXml = '<services>';  
        String psDataXml = '';
        String status = 'Status';
                                     
       for(Project_Services__c ps: psList) {
           String psXml = '<scheduledService>';                           
           psXml = psXml +'<titleID>' + ps.project__r.title__r.Marty_Title_ID__c +'</titleID>';
           psXml = psXml +'<serviceID>' + ps.id +'</serviceID>';
           if(ps.Service__c!=null) {
           psXml = psXml +'<serviceName>' + getServiceType(servicesMap.get(ps.Service__c)) +'</serviceName>';
           if(String.isNotBlank(servicesMap.get(ps.Service__c).Censhare_Template_ID__c))
               psXml = psXml +'<csTemplateID>' + servicesMap.get(ps.Service__c).Censhare_Template_ID__c +'</csTemplateID>';
           if(String.isNotBlank(servicesMap.get(ps.Service__c).Service_Complexity_Value__c))
               psXml = psXml +'<complexityID>' + servicesMap.get(ps.Service__c).Service_Complexity_Value__c +'</complexityID>';
           } if(String.isNotBlank(ps.status__c))
               psXml = psXml +'<serviceSchedulingStatus>' + ps.status__c +'</serviceSchedulingStatus>';
           if(String.isNotBlank(ps.Vendor__c)) {
               psXml = psXml +'<vendorID>' + ps.Vendor__c +' </vendorID>';  
               psXml = psXml +'<vendorName>' + (vendorMap != null? vendorMap.containsKey(ps.Vendor__c)? vendorMap.get(ps.Vendor__c).name : null : null) +'</vendorName>';
           }
           psXml = psXml +'<updateType>'+ status + '</updateType>';
           psXml = psXml + '</scheduledService>';
           psDataXml = psDataXml + psXml;
     }
       sdataXml = sdataXml + psDataXml + '</services>';
      return payloadHeader + sdataXml;
      }
      
         // update promo text services to other name and remainiang services are same 
    public String getServiceType(Service__c ser) {
        if(ser!=null) {
        if(ser.Name == 'Promo Text Creation')
            return 'Promo Text Service Package' ;
        else
            return getescapexml(ser.Service_Rate_Type__c); 
        } return '';        
        
    }
    public String getescapexml(String sxml) {
      if(sxml!=null)
          return sxml.escapeXml();
      else
          return sxml;    
  
  }
    // single or mulitple PSes Sync service(Update Ps)
    public static resWrap censhareServiceSync(String xmlBody, Map<String,Project_Services__c> psMap) {
        resWrap rw = new resWrap();
      
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://na72.salesforce.com/services/apexrest/PSUpdate/');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/xml');
        req.setHeader('Accept', 'application/xml');
        req.setBody(xmlBody);
        //req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        req.setHeader('Authorization','Bearer '+ ppw_censhareConnector.getCalloutResponseContents());
        req.setTimeout(120000); //max sync timeout for safer side 
        HttpResponse res = h.send(req); 
      
        String cenRes = res.getBody();//'<?xml version="1.0" encoding="utf-8"?><response><title censhare_assetid="151365" titleID="11079"><service import_type="update" serviceID="a021H00000Lj24I" start="2012-01-13" end="2012-02-08" censhare_assetid="222937"/> <service import_type="update" serviceID="a021H00000Lj24I" start="2012-01-13" end="2012-02-08" censhare_assetid="222937"/><error></error></title></response>';
        if(cenRes != null && cenRes != '') { //serviceDownSyncErrorMessage
            if(String.isNotEmpty(cenRes)) {
                String reBody = String.valueOf(cenRes).unescapeXml();
                system.debug(reBody);
                XmlStreamReader reader = new XmlStreamReader(reBody);
                rw = parsePSsyncService(reader, psMap);
             system.debug(rw);
            } else return serviceDownSyncErrorMessage();  // body empty or body fail
                
        } else return serviceDownSyncErrorMessage();  // body empty or body fail
       
        return rw;
           
    }
    
     // this method will call when service down or body is empty for sync service
      public static resWrap serviceDownSyncErrorMessage() {
        resWrap rWrp = new resWrap();
        rWrp.psStatus = false;
        rWrp.psList = null;
        //rWrp.resErrorMes = 'Job Failed - Empty response body received from censhare side';
        return rWrp;
      
        
      }
    
      
      // single or multiple ps updating process (sync Process)
    
     public static resWrap parsePSsyncService(XmlStreamReader reader, Map<String,Project_Services__c> psMap) {
          resWrap rw = new resWrap();
       
         List<Project_services__c> psUpdate = new List<Project_services__c>();
           boolean isSafeToGetNextXmlElement = true;
       
          while(isSafeToGetNextXmlElement) {
            system.debug(reader.getEventType());
             system.debug(reader.getLocalName());
             system.debug(XmlTag.START_ELEMENT);
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if ('error' == reader.getLocalName()) {
                    String serror = parseProjectServiceErrorType(reader);
                            if(String.isNotBlank(serror)) {
                                rW.psStatus = false;
                                rW.error = serror;
                                rw.psList = null;
                                return rW;
                            }
                     
                  }
                if ('service' == reader.getLocalName()) {
                    
                   Project_services__c ps = parseProjectService(reader);
                   system.debug(ps);
                   system.debug(psMap);
                   boolean psUpdate1 = false;
                   if(psMap.containsKey(ps.id) && ps.Estimated_Completion_Date__c != null && ps.Estimated_Start_Date__c !=null) {
                       if(psMap.get(ps.id).Estimated_Start_Date__c != null) {
                           if(!ps.Estimated_Start_Date__c.isSameDay(psMap.get(ps.id).Estimated_Start_Date__c))
                               psUpdate1 = true;
                       } else
                           psUpdate1 = true;
                                        
                        if(psMap.get(ps.id).Estimated_Completion_Date__c != null) {        
                            if(!ps.Estimated_Completion_Date__c.isSameDay(psMap.get(ps.id).Estimated_Completion_Date__c))
                              psUpdate1 = true;
                        } else
                            psUpdate1 = true;        
                              
                   } 
                   if(psUpdate1) 
                       psUpdate.add(ps);      
                  
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
          system.debug(psUpdate);
         
          rw.psList = psUpdate;
          rw.psStatus = true;
         return rw;
     }
   
   public class resWrap {
   
   public List<Project_services__c> psList{get;set;}
   public boolean psStatus{get;set;}
   public string error{get;set;}
   
   
   }
    
      // Parse through the XML, determine the author and the characters
    static Project_services__c parseProjectService(XmlStreamReader reader) {
         Project_services__c ps = new Project_services__c();
         system.debug(reader.getAttributeValue(null, 'serviceID'));
         system.debug(reader.getAttributeValue(null,'start'));
         system.debug(reader.getAttributeValue(null, 'end'));
         system.debug(reader.getAttributeValue(null, 'import_type'));
                 if(reader.getAttributeValue(null, 'serviceID')!=null && reader.getAttributeValue(null, 'serviceID') != 'null')
                     ps.id = id.valueof(reader.getAttributeValue(null, 'serviceID'));  //censhare_assetid
                // system.debug(psDataMap);
                 system.debug(ps.id);
                 /*if(psDataMap.containsKey(ps.Id)) {//Service_Name__c
                     if(psDataMap.get(ps.Id).Service_Name__c == 'Promo Text Creation')
                        ps.Master_PT_Service__c = true;
                      
                 }  */   
                 ps.Estimated_Start_Date__c = reader.getAttributeValue(null,'start')!=null? date.valueOf(reader.getAttributeValue(null,'start')) : null;
                 ps.Estimated_Completion_Date__c = reader.getAttributeValue(null,'end')!=null? date.valueOf(reader.getAttributeValue(null,'end')) : null;
                 ps.Censhare_XML_update_type__c  = reader.getAttributeValue(null, 'import_type')!=null? reader.getAttributeValue(null, 'import_type') : '';
                 ps.Censhare_Asset_ID__c = reader.getAttributeValue(null, 'censhare_assetid')!=null? reader.getAttributeValue(null, 'censhare_assetid') : '';
                
                 
                // psList1.add(ps);
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.START_ELEMENT) {
              
                   if ('error' == reader.getLocalName()) {
                     
                 
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
    static String parseProjectServiceErrorType(XmlStreamReader reader) {
       
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                   system.debug(reader.getText());
                   if(String.isNotBlank(reader.getText())) {
                       return reader.getText().trim();
                   
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