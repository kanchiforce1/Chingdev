@RestResource(urlMapping='/ProjectServices1/*')
global with sharing class censhareConnectorServiceMock1 {
   
  /*
    
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
    global static string createKickOffServiceps() {
        
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
        for(resWrap rw : reswrpLst) {
            xmlRes = xmlRes + '<title censhare_assetid="47992" titleID="'+rw.titleID+'">';
            xmlRes = xmlRes + '<censhare_kick_off="true"/>';
            xmlRes = xmlRes + '<error></error> </title>';
            
        }
        xmlRes = xmlRes + '';
        system.debug(xmlRes);
        return xmlRes;
       // return '';
    } 
    
     // Mock response post method for nagetive
    
 /* @HttpPost
    global static string createKickOffServiceps() {
        
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
        for(resWrap rw : reswrpLst) {
            xmlRes = xmlRes + '<title censhare_assetid="47992" titleID="'+rw.titleID+'">';
            xmlRes = xmlRes + '<censhare_kick_off="false"/>';
            xmlRes = xmlRes + '<error></error> </title>';
            
        }
        xmlRes = xmlRes + '';
        system.debug(xmlRes);
        return xmlRes;
       // return '';
    }  */
    
    /* @HttpPost
    global static string createKickOffServiceps() {
        
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
        for(resWrap rw : reswrpLst) {
            xmlRes = xmlRes + '<title censhare_assetid="47992" titleID="'+rw.titleID+'">';
            xmlRes = xmlRes + '';
            xmlRes = xmlRes + '<error>Kick Off Service Update Failed</error> </title>';
            
        }
        xmlRes = xmlRes + '';
        system.debug(xmlRes);
        return xmlRes;
       // return '';
    }  */
    
 	/* 
    public class resWrap {
        public string titleID{get;set;}
        public string serviceID{get;set;}
    } */
 }