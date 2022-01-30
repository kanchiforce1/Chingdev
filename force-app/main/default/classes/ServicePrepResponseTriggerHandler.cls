/***********************************
Author:      Amazon Apub // kkolla@
Used By:     
Description: when we change the rate value it will applicable for rate calculation in ps record 
***********************************/
public class ServicePrepResponseTriggerHandler {

/** update service prep form status new to inprogress when we change the response  **/
public static void ServicePrepRespTrigger(List<Service_Prep_Response__c> spRespNewList,map<id,Service_Prep_Response__c> spRespOldMap) {
    
    map<id,Service_Prep__c> sPrepUpdate = new map<id,Service_Prep__c>();
    
    set<Id> sPrepIds = new set<Id>();
    for(Service_Prep_Response__c sp : spRespNewList) 
        sPrepIds.add(sp.Service_Prep__c);
    
    Map<Id,Service_Prep__c> sPrepForm = new Map<Id,Service_Prep__c>([Select id,Status__c from Service_Prep__c where id =:sPrepIds]);
     
    for(Service_Prep_Response__c sp : spRespNewList) 
    if(sp.Response__c!=spRespOldMap.get(sp.id).Response__c || sp.Response_Number__c!=spRespOldMap.get(sp.id).Response_Number__c)
    if(!String.isBlank(sPrepForm.get(sp.Service_Prep__c).Status__c)  && sPrepForm.get(sp.Service_Prep__c).Status__c.containsignoreCase('New')){
        Service_Prep__c SerivePrep = new Service_Prep__c(id=sp.Service_Prep__c,status__c='In Progress');
        sPrepUpdate.put(sp.Service_Prep__c,SerivePrep);
        break;
    }
    if(!sPrepUpdate.isempty()) {
    System.debug('sPrepUpdate.values()'+sPrepUpdate.values());
    update sPrepUpdate.values();
    }
    
    
    

}

}