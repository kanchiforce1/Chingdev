@isTest
global class MockHttpCenshareResponseEmpty implements HttpCalloutMock {
    public String xmlRequest;
    public MockHttpCenshareResponseEmpty(String xmlreq) {
    xmlRequest = xmlreq;
    
    }
    
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
     
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
            xmlRes = xmlRes + '<error>Asset loop detected with asset id: AssetId - in title(TitleId). </error>';
            
        }
        xmlRes = xmlRes + '';
        system.debug(xmlRes);
       
        
        
        res.setBody('');
        res.setStatusCode(200);
        return res;
    }
}