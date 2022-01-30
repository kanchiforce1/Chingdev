/***********************************
Author:      Amazon Apub // kkolla@
Used By:     PPW Project
Description: when we change the rate value it will applicable for rate calculation in ps record 
***********************************/

public class RateTriggerHandler {
    
    /** Rate calculation when we update rate ***/
    public static void rateCalcAfterUpdate(Map<Id,Rate__c> newMap,Map<Id,Rate__c> oldMap) {
        list<Rate__c> ratelist = new list<Rate__C>();
        
        for(rate__C r: newMap.values())
            if(oldMap.get(r.id).Minimum_Fee__c != r.Minimum_Fee__c || 
                oldMap.get(r.id).Rate_Amount__c != r.Rate_Amount__c )
            ratelist.add(r);
        
        if(ratelist.size()>0){
            List<Project_Services__c> psList = [select id from Project_Services__c where rate__c =: newMap.keyset()];
            
            ppw_handlerforCalculation ppwhand = new ppw_handlerforCalculation();
            ppwhand.ratecalc(psList);
        }
    }
}