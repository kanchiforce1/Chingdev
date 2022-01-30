@isTest
global class MockHttpCenshareResponse implements HttpCalloutMock {
    public String xmlRequest;
    public MockHttpCenshareResponse(String xmlreq) {
    xmlRequest = xmlreq;
    
    }
    
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
      //  System.assertEquals('http://example.com/example/test', req.getEndpoint());
       // System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        
        system.debug('xmlRequest'+xmlRequest);
        Dom.Document doc = new Dom.Document();
        doc.load(xmlRequest);
        List<censhareConnectorServiceMock.resWrap> reswrpLst1 = new List<censhareConnectorServiceMock.resWrap>();
        DOM.XmlNode rootNode=doc.getRootElement();
        censhareConnectorServiceMock.reswrpLst = new List<censhareConnectorServiceMock.resWrap>();
        reswrpLst1 = censhareConnectorServiceMock.parseXML(rootNode);
        system.debug(reswrpLst1);
        
        String xmlRes = '';
        for(censhareConnectorServiceMock.resWrap rw : reswrpLst1) {
            xmlRes = xmlRes + '<title censhare_assetid="47992" titleID="'+rw.titleID+'">';
            xmlRes = xmlRes + '<service import_type="new" serviceID="'+ rw.serviceID+'" start="2010-05-21" end="2010-05-30" censhare_assetid="127275"/>';
            xmlRes = xmlRes + ' <error></error> </title>';
            
        }
        xmlRes = xmlRes + '';
        system.debug(xmlRes);
       
        
        
        res.setBody(xmlRes);
        res.setStatusCode(200);
        return res;
    }
}