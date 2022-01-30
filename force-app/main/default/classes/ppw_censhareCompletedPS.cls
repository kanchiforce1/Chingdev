global class ppw_censhareCompletedPS implements Schedulable{

global void execute(SchedulableContext ctx){

}
    
   /* global void execute(SchedulableContext ctx){
        //censhare call out get completed PSs data from censhare system 
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        reswrpLst = new List<resWrap>();
        req.setEndpoint('https://na72.salesforce.com/services/apexrest/ProjectServices/');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/xml');
        req.setHeader('Accept', 'application/xml');
        
        req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        HttpResponse res = h.send(req);
       
        String resBody = String.valueOf(res.getBody()).unescapeXml();
        Dom.Document doc = new Dom.Document();
        doc.load(resBody);
        reswrpLst = new List<resWrap>();
        DOM.XmlNode rootNode=doc.getRootElement();
        reswrpLst = parseXML(rootNode);
        system.debug(reswrpLst);
        
    }*/
    
    public static void excuteCallout() {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
      
        req.setEndpoint('https://na72.salesforce.com/services/apexrest/ProjectServices/');
        req.setMethod('GET');
       // req.setHeader('Content-Type', 'application/json');
       // req.setHeader('Accept', 'application/json');
        
        req.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        HttpResponse res = h.send(req);
        String resbody = res.getBody();
        system.debug('response'+resbody);
        List<JsonParser> jsonObj = (List<JsonParser>)JSON.deserialize(resbody, List<JsonParser>.class);
        
        //Project_Services__c ps;
        List<Project_Services__c> psUpdateList = new List<Project_Services__c>();
        List<Reason_Code__c> rUpdateCodes = new List<Reason_Code__c>();
        for(JsonParser jp: jsonObj) {
            if(jp.serviceID!=null) {
               // DateTime sDt = 
                psUpdateList.add(new Project_Services__c(id=jp.serviceID,
                                                        Actual_Start_Date__c = jp.actualStartDate!=null?getDate(jp.actualStartDate) : null, 
                                                        Actual_Completion_Date__c = jp.actualEndDate!=null?getDate(jp.actualEndDate): null));
           
            for(delayedTasks dt: jp.delayedTasks) {
                rUpdateCodes.add(new Reason_Code__c(Project_Service__c = jp.serviceID,
                                                    Duration__c = dt.delayDuration,
                                                    Name = dt.name,
                                                    Reason_Code__c = dt.delayReasonCode)); 
              }
            
            }
        }
        system.debug(psUpdateList);
        system.debug(rUpdateCodes);
        update psUpdateList;
        upsert rUpdateCodes;
        
    }
  public static date getDate(String dt) {  
      String[] dtf = dt.split(' ')[0].split('-');
      return date.valueOf(dtf[2] + '-' + dtf[1] + '-' + dtf[0]);  
  }   
    
   public class JsonParser{
        public String actualStartDate{get;set;}
        public String actualEndDate{get;set;}
        public String serviceID{get;set;}
        public list<delayedTasks> delayedTasks{get;set;}
        public list<completedTasks> completedTasks{get;set;}
    }
    public class delayedTasks{
        public String name{get;set;}
        public String delayReasonCode{get;set;}
        public String delayDuration{get;set;}
    }
    public class completedTasks{
        public String delayReasonCode{get;set;}
        public String delayDuration{get;set;}
        public String name{get;set;}
    }


}