@isTest

private class censhareConnectorServiceMockTest {

    static testMethod void myUnitTest() {
         RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();

         req.addHeader('httpMethod', 'POST');
         req.requestUri = '/services/apexrest/ProjectServices/';       
         String postData = 'Your actual request which covers both scenario in JSON format';
         //String JsonMsg=JSON.serialize(postData);
         //req.requestBody = Blob.valueof(JsonMsg);
         RestContext.request = req; 
         RestContext.response= res;
         Test.startTest();
       //  GetContactFromUKOrg.insertContact();
         Test.stopTest();
   }

}