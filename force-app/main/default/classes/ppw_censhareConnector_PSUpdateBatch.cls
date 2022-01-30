global class ppw_censhareConnector_PSUpdateBatch implements 
    Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global map<String,Map<String,String>>  resultData = new map<String,Map<String,String>>();
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, title__r.Marty_Title_ID__c, (SELECT id,Service__c,Vendor__c, project__c,project__r.title__r.Marty_Title_ID__c,Service__r.name,' +
                                                               'Estimated_Start_Date__c, Estimated_Completion_Date__c,'+
                                                            'Service__r.Censhare_Template_ID__c,service__r.Service_Complexity_Value__c'+
                                                             ',Honor_Dependencies__c,status__c,Vendor__r.name,Censhare_XML_update_type__c '+
                                     
                                     ' FROM Project_Services__r WHERE status__c = \'In Planning\') FROM Project__c WHERE id IN (SELECT project__c FROM Project_Services__c WHERE status__c = \'In Planning\')');
       // );
    }
    global void execute(Database.BatchableContext bc, List<Project__c> scope) {
        Map<String,Project_Services__c> psLst = new Map<String,Project_Services__c>();
       // map<String,Map<String,String>> rdata = 
        if(!scope.isEmpty()) {
        for(project__c p: scope)
        for(Project_Services__c ps: p.Project_Services__r) 
            psLst.put(ps.id, ps);
       
       }
        if(!psLst.isEmpty()) {
            ppw_censhareConnect_PSUpdate pc = new ppw_censhareConnect_PSUpdate();
            
            String xmlBody = pc.censhareXMLBuilder(psLst.values());
            system.debug('xml'+ xmlBody);
            ppw_censhareConnect_PSUpdate.resWrap rw = new  ppw_censhareConnect_PSUpdate.resWrap();
            rw = ppw_censhareConnect_PSUpdate.censhareServiceSync(xmlBody, psLst);
            system.debug( rw);
            if(rw.psStatus == true) {
                for(Project_Services__c ps: rw.psList) {
                    if(resultData.containsKey(psLst.get(ps.id).project__r.title__r.Marty_Title_ID__c))
                        resultData.get(psLst.get(ps.id).project__r.title__r.Marty_Title_ID__c).put(ps.id,'success');
                    else
                       resultData.put(psLst.get(ps.id).project__r.title__r.Marty_Title_ID__c, new map<String,String> {ps.id =>'success'});     
                    
                }    
                update rw.psList;
            } else {
                for(Project_Services__c ps: psLst.values()) {
                     if(resultData.containsKey(psLst.get(ps.id).project__r.title__r.Marty_Title_ID__c))
                        resultData.get(psLst.get(ps.id).project__r.title__r.Marty_Title_ID__c).put(ps.id,rw.error);
                     else
                        resultData.put(psLst.get(ps.id).project__r.title__r.Marty_Title_ID__c, new map<String,String> {ps.id =>rw.error});     
               
                }
            
              }   
        }
       // system.debug(resultData);
       
       
    }    
    global void finish(Database.BatchableContext bc) {
        String body = '';
        for(String t: resultData.keyset()) 
            for(String p: resultData.get(t).keyset()) 
                body = body + t + ' ' + p + ' ' + resultData.get(t).get(p) + '\n';
       
      
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[]{ UserInfo.getUserEmail() };
        mail.setToAddresses(toAddresses);
        mail.setSubject('ppw_censhareConnector_PSUpdateBatch');
        mail.setPlainTextBody(body);
        system.debug(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});     
    }    
}