@RestResource(urlMapping='/ProjectServices/*')
global with sharing class censhareConnectorServiceMock {
   
    @HttpGet
    global static String getCaseById() {
        List<Project_Services__c> psList = [SELECT id,Estimated_Start_Date__c,Estimated_Completion_Date__c FROM Project_Services__c 
                                           WHERE status__c = 'Completed' ORDER BY LastmodifiedDate];
    
     String xmlRes = '';
     List<ppw_censhareCompletedPS.JsonParser> jsonRes = new List<ppw_censhareCompletedPS.JsonParser>();
     LIst<ppw_censhareCompletedPS.delayedTasks> jsDel = new List<ppw_censhareCompletedPS.delayedTasks>();
        for(Project_Services__c ps : psList) {
            ppw_censhareCompletedPS.JsonParser jsp = new ppw_censhareCompletedPS.JsonParser();
            jsp.actualStartDate = '2019-06-14';
            jsp.actualEndDate = '2019-06-14';
            jsp.serviceID = ps.id;
            jsp.delayedTasks = null;
            jsp.completedTasks = null;
             jsonRes.add(jsp);
        }
   // system.debug(xmlRes);
    
    return JSON.serialize(jsonRes);
    }
    
    public static List<resWrap> reswrpLst;
    public static resWrap resw;
    
    public static List<resWrap> parseXML(DOM.XMLNode node) {
        
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            system.debug(node.getName());
            if(node.getName()=='scheduledService') {
                
                resw = new resWrap();
               // system.debug()
                resw.titleID = node.getChildElement('titleID', null)!= null? node.getChildElement('titleID', null).getText() : null;
                resw.serviceID = node.getChildElement('serviceID', null)!=null? node.getChildElement('serviceID', null).getText() : null;
                reswrpLst.add(resw);// = new resWrap();
            }
        }
        for (Dom.XMLNode child: node.getChildElements()) {
            parseXML(child);
        }
        system.debug(reswrpLst);
        //  retResp.add(rw);
        return reswrpLst;
    } 
    
     
    public static List<resWrap> retResp = new List<resWrap>();
 
  // Mock response post method for success
  @HttpPost
    global static string createps() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String resBody = RestContext.request.requestBody.toString();
        system.debug(resBody);
        Dom.Document doc = new Dom.Document();
        doc.load(resBody);
        reswrpLst = new List<resWrap>();
        DOM.XmlNode rootNode=doc.getRootElement();
        reswrpLst = parseXML(rootNode);
        system.debug(reswrpLst);
        
        String xmlRes = '';
        for(resWrap rw : reswrpLst) 
            if(rw.serviceID!=null) {
                xmlRes = xmlRes + '<title censhare_assetid="47992" censhare_projectid="12345" titleID="'+rw.titleID+'">';
                xmlRes = xmlRes + '<service import_type="new" serviceID="'+ rw.serviceID+'" start="2010-05-21" end="2010-05-30" censhare_assetid="127275"/>';
                xmlRes = xmlRes + ' <error></error> </title>';
            }
        
        xmlRes = xmlRes + '';
        system.debug(xmlRes);
        return xmlRes;
       // return '';
    } 
    
   
    // Mock response post method for ERROR
  /* @HttpPost
    global static string createps1() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String resBody = RestContext.request.requestBody.toString();
        system.debug(resBody);
        Dom.Document doc = new Dom.Document();
        doc.load(resBody);
        reswrpLst = new List<resWrap>();
        DOM.XmlNode rootNode=doc.getRootElement();
        reswrpLst = parseXML(rootNode);
        system.debug(reswrpLst);
        
        String xmlRes = '';
        for(resWrap rw : reswrpLst) 
            if(rw.serviceID!=null) {
                xmlRes = xmlRes + '<error>Service already exists for service id: '+ rw.serviceID +'</error>';
               
            }
        
        xmlRes = xmlRes + '';
        system.debug(xmlRes);
        return xmlRes;
       // return '';
    }  
    */
    
  /* @HttpPost
    global static string createps2() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String resBody = RestContext.request.requestBody.toString();
        system.debug(resBody);
        Dom.Document doc = new Dom.Document();
        doc.load(resBody);
        reswrpLst = new List<resWrap>();
        DOM.XmlNode rootNode=doc.getRootElement();
        reswrpLst = parseXML(rootNode);
        system.debug(reswrpLst);
        
        String xmlRes = '';
        for(resWrap rw : reswrpLst) 
            if(rw.serviceID!=null) {
                xmlRes = xmlRes + '<title censhare_assetid="47992" titleID="'+rw.titleID+'">';
                xmlRes = xmlRes + '<service import_type="update" serviceID=" '+ rw.serviceID +'" start="2019-05-22" end="2019-06-25" censhare_assetid="127953"/>';
                xmlRes = xmlRes + '<error>Service already exists for service id: '+ rw.serviceID + '</error>';
            }
        
        xmlRes = xmlRes + '';
        system.debug(xmlRes);
        return xmlRes;
       // return '';
    }  
    
   */
    
    
    
  /*   @HttpPost
    global static string createps3() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String resBody = RestContext.request.requestBody.toString();
        system.debug(resBody);
        Dom.Document doc = new Dom.Document();
        doc.load(resBody);
        reswrpLst = new List<resWrap>();
        DOM.XmlNode rootNode=doc.getRootElement();
        reswrpLst = parseXML(rootNode);
        system.debug(reswrpLst);
        
        String xmlRes = '';
        for(resWrap rw : reswrpLst) 
            if(rw.serviceID!=null) {
                xmlRes = xmlRes + '<title censhare_assetid="47992" titleID="11079">';
                xmlRes = xmlRes + '<service import_type="update" serviceID="' + rw.serviceID +'" start="2019-05-22" end="2019-06-18" censhare_assetid="123040">';
                xmlRes = xmlRes + '<error>Service update with status of Kicked Off must contain a vendorID.</error></service> </title>';
            }
        
        xmlRes = xmlRes + '';
        system.debug(xmlRes);
        return xmlRes;
       // return '';
    } */
    
    
     // Mock response post method for nagetive
    
 /* @HttpPost
    global static string createpsError() {
       
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String resBody = RestContext.request.requestBody.toString();
        system.debug(resBody);
        Dom.Document doc = new Dom.Document();
        doc.load(resBody);
           reswrpLst = new List<resWrap>();
            DOM.XmlNode rootNode=doc.getRootElement();
           reswrpLst = parseXML(rootNode);
           system.debug(reswrpLst);
         
       String xmlRes = '';
             xmlRes = xmlRes + '<error>Asset loop detected with asset id: AssetId - in title(TitleId). </error>';
           
       
      xmlRes = xmlRes + '';
      system.debug(xmlRes);
      return xmlRes;
    }
    
 */
  
    
   
    public class resWrap {
        public string titleID{get;set;}
        public string serviceID{get;set;}
    } 
 }