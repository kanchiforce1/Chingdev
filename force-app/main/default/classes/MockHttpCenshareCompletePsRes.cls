@isTest
global class MockHttpCenshareCompletePsRes implements HttpCalloutMock {
   
    
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
       
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
       title__C titleRec = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = 'US',Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    Marty_Title_ID__c='123');
        insert  titleRec;
       //
          List<project__c> pList = new List<project__c>();
           pList = [Select id from project__c where title__c =: titleRec.id];
     //pList = [Select id from project__c where title__c =: tList];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
    
      if(pList.isEmpty()) {
          
                pList.add(new project__c(title__c = titleRec.id));
          
            insert pList;
        }
       
   
    // List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
  
  
      List<Service_Prep__c> spList = new List<Service_prep__c>();
     spList = [Select id from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: pList)
             spList.add(new Service_Prep__c(project__c = p.id));
     
         insert spList;
     }
  
     Service__c s = new Service__c(name='Developmental Edit',Active__c = true,Service_Rate_Type__c = 'Developmental Edit');
     insert s;
    Service__c s1 = new Service__c(name='Developmental Edit',Active__c = true,Service_Rate_Type__c = 'Developmental Edit');
     insert s1;
        
        List<Project_Services__c> psList = new List<Project_Services__c>();
        Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id,status__c = 'Completed',Honor_Dependencies__c = true,Estimated_Start_Date__c = date.today().addDays(36));
        psList.add(ps);
        ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id,Honor_Dependencies__c = true, Estimated_Start_Date__c = date.today().addDays(38));
        psList.add(ps);
        insert psList;
        
        
               psList = [SELECT id,Estimated_Start_Date__c,Estimated_Completion_Date__c FROM Project_Services__c 
                                           WHERE status__c = 'Completed' ORDER BY LastmodifiedDate ];
    
        
        
         List<ppw_censhareCompletedPS.JsonParser> jsonRes = new List<ppw_censhareCompletedPS.JsonParser>();
     LIst<ppw_censhareCompletedPS.delayedTasks> jsDel = new List<ppw_censhareCompletedPS.delayedTasks>();
        LIst<ppw_censhareCompletedPS.completedTasks> jsCom = new List<ppw_censhareCompletedPS.completedTasks>();
        for(Project_Services__c ps1 : psList) {
            ppw_censhareCompletedPS.JsonParser jsp = new ppw_censhareCompletedPS.JsonParser();
            jsp.actualStartDate = '14-06-2019';
            jsp.actualEndDate = '14-06-2019';
            jsp.serviceID = ps1.id;
            ppw_censhareCompletedPS.delayedTasks dt = new ppw_censhareCompletedPS.delayedTasks();
            dt.name = 'test';
            dt.delayDuration = '12';
            dt.delayReasonCode = '123';
           jsDel.add(dt);
            ppw_censhareCompletedPS.completedTasks jc = new ppw_censhareCompletedPS.completedTasks();
            jc.delayReasonCode = '123';
            jc.delayDuration = '123';
            jc.name = 'test';
            jsCom.add(jc);
            jsp.delayedTasks = jsDel;
            jsp.completedTasks = new LIst<ppw_censhareCompletedPS.completedTasks>();
             jsonRes.add(jsp);
        }
        
      String xmlRes = JSON.serialize(jsonRes);
        
   /*  String xmlRes = '';
        for(Project_Services__c ps1 : psList) {
            xmlRes = xmlRes + '<completedServices>';
            xmlRes = xmlRes + '<serviceID>'+ps1.id+'</serviceID>';
            xmlRes = xmlRes +  '<actualStartDate>2010-05-21</actualStartDate>';
            xmlRes = xmlRes + '<actualEndDate>2010-05-21</actualEndDate>';
            xmlRes = xmlRes + '<delayedTasks><name>CE Duration Placeholder</name><delayDuration>-1</delayDuration><delayReasonCode>vendor-missed-deadline</delayReasonCode></delayedTasks>';
            xmlRes = xmlRes + '</completedServices>';
            
        }
    system.debug(xmlRes); */
        
    
   
        
        res.setBody(xmlRes);
        res.setStatusCode(200);
        return res;
    }
}