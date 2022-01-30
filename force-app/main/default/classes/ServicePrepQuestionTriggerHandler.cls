/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Service Prep Question Trigger
Description: Handler for Service Prep Question Object
***********************************/

public class ServicePrepQuestionTriggerHandler {


/** create a response record whenever a new question is added into service prep question object to add into service prep forms where status!=Completed **/
public static void createSerPreResponse(List<Service_Prep_Question__c> spRespNewList,
                                        map<id,Service_Prep_Question__c> spRespOldMap) {

    if(Trigger.isAfter && Trigger.isInsert){
        List<Service_Prep__c>  seList = [select id,project__r.title__r.Production_Locale__c from Service_Prep__c
                                        where Status__c!='Completed'];
          
                                        
        list<Service_Prep_Response__c> resInsertlist = new list<Service_Prep_Response__c>();
        
        for(Service_Prep__c sp: seList){
            for(Service_Prep_Question__c serPrepQus: spRespNewList){
                Service_Prep_Response__c sPreRes = new Service_Prep_Response__c();
                 
                  if(!String.isBlank(serPrepQus.Locale__c) && !String.isBlank(sp.project__r.title__r.Production_Locale__c))
                  if(serPrepQus.Locale__c.contains(sp.project__r.title__r.Production_Locale__c)){
                     sPreRes = new Service_Prep_Response__c(Service_Prep__c=sp.id,Service_Prep_Question__c = serPrepQus.id);
                     resInsertlist.add( sPreRes);
                
                }
            
            }
        }
        insert resInsertlist;
    }

}

/** update in Locale value in SPQ record determines the addition or removal of question from the service prep where status is not Completed **/
public static void updateResponsesLocale(List<Service_Prep_Question__c> spRespNewList,map<id,Service_Prep_Question__c> spRespOldMap) {

    if(Trigger.isAfter && Trigger.isUpdate) {
    set<String> sQIds = new set<String>();
    Map<String,set<String>> removedQLocale = new Map<String,set<String>>();
    String getRemovedLocale = '';
    for(Service_Prep_Question__c sq: spRespNewList) 
        if(sq.Locale__c != spRespOldMap.get(sq.id).Locale__c) {
            sQIds.add(sq.id);
            String oldLocale = spRespOldMap.get(sq.id).Locale__c;
            if(sq.Locale__c.length() <= oldLocale.length())
                for(String s : oldLocale.split(';')) {
                    if(sq.Locale__c.contains(s))
                        {} else {
                                if(removedQLocale.containsKey(sq.id))
                                    removedQLocale.get(sq.id).add(s);
                                else  removedQLocale.put(sq.id, new set<string>{s}); 
                               }   
                             
                 }               
                
          }
         
   
        if(!sQIds.isEmpty()) {
        List<Service_Prep__c>  seList = [select id,project__r.title__r.Production_Locale__c from Service_Prep__c
                                        where Status__c!='Completed'];
         
        Map<String,Map<String,set<String>>> responseLocale = new Map<String,Map<String,set<String>>>();
        list<Service_Prep_Response__c> resInsertlist = new list<Service_Prep_Response__c>();
        list<Service_Prep_Response__c> resDeletelist = new list<Service_Prep_Response__c>();
         
        for(Service_Prep_Response__c sp : [Select id, Service_Prep__r.project__r.title__r.Production_Locale__c,
                                            Service_Prep__c,Service_Prep_Question__c from Service_Prep_Response__c where Service_Prep__c =:seList]){
             String locale =  sp.Service_Prep__r.project__r.title__r.Production_Locale__c;                                  
            if(responseLocale.containsKey(sp.Service_Prep__c)) {
                if(responseLocale.get(sp.Service_Prep__c).containsKey(locale)) 
                    responseLocale.get(sp.Service_Prep__c).get(locale).add(sp.Service_Prep_Question__c);
                else
                    responseLocale.get(sp.Service_Prep__c).put(locale , new set<String> {sp.Service_Prep_Question__c}); 
              } else
                    responseLocale.put(sp.Service_Prep__c , new Map<String,set<String>> {locale => new set<String> {sp.Service_Prep_Question__c}});                                               
        
        if(removedQLocale.containsKey(sp.Service_Prep_Question__c))
            resDeletelist.add(sp);   
        
        }                                
       
        
        for(Service_Prep__c sp: seList) {
            for(Service_Prep_Question__c serPrepQus: spRespNewList){
                Service_Prep_Response__c sPreRes = new Service_Prep_Response__c();
                 system.debug(sp.project__r.title__r.Production_Locale__c);
                 system.debug(serPrepQus.Locale__c);
                  if(!String.isBlank(serPrepQus.Locale__c) && !String.isBlank(sp.project__r.title__r.Production_Locale__c))
                      if(serPrepQus.Locale__c.contains(sp.project__r.title__r.Production_Locale__c)) {
                          if(responseLocale.containsKey(sp.id)) {
                              if(responseLocale.get(sp.id).containsKey(sp.project__r.title__r.Production_Locale__c)) {
                                  if(responseLocale.get(sp.id).get(sp.project__r.title__r.Production_Locale__c).contains(serPrepQus.id)){
                                  } else {
                                  setReponses(sp.id,serPrepQus.id,resInsertlist);
                                           
                                           }
                                  } else{
                                        setReponses(sp.id,serPrepQus.id,resInsertlist);
                                  
                                      } 
                             }  else {
                                     setReponses(sp.id,serPrepQus.id,resInsertlist);
                                     }               
                                       
                    
                      }
                      
                     
                
            
            }
        }
        insert resInsertlist;
        delete resDeletelist;
    }
   }

}

/** create service prep response method **/
    public static void setReponses(Id spId,Id qId,list<Service_Prep_Response__c> resInsertlist) {
        Service_Prep_Response__c sPreRes = new Service_Prep_Response__c(Service_Prep__c=spId,Service_Prep_Question__c = qId);
        resInsertlist.add( sPreRes);
        
    }


}