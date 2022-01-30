/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Service Prep Form
Description: Creates Service Prep Form and checks for duplicate project
***********************************/
public class ProjectTriggerHandler{
    
    /** Creating service prep form record **/
    public static void servicePrepQuestionCreate(List<Project__c> proNewList){
        
        set<Id> titleIds = new set<Id>();
        List<Service_Prep__c> sePrepList = new List<Service_Prep__c>();
        for(Project__c p: proNewList)
            if(p.title__C!=null)
            titleIds.add(p.title__c);
        
        sePrepList = [Select id,status__c from Service_Prep__c where project__c =:proNewList];
        map<String,title__c> titlesMap = new map<String,title__C>([select id,status__c from title__c where id=:titleIds]);
        List<Service_Prep__c> seList = new LIst<Service_Prep__c>();
        if( sePrepList.size()==0){
            for(Project__c p: proNewList){
                if(titlesMap.containskey(p.title__c))
                    seList.add(new Service_Prep__c(Project__c = P.Id));
            }
            insert seList;
        }
    }
    
    /** Check for duplicate project for title **/ 
    public static void checkDuplicateProject(List<Project__c> proNewList) {
        set<Id> titleIds = new set<Id>();
        List<Project__c> proList = new List<Project__C>();
        Map<String,List<project__c>> proMap = new Map<String,List<project__C>>();
        List<Service_Prep__c> sePrepList = new List<Service_Prep__c>();
        for(Project__c p: proNewList)
            if(p.title__C!=null)
            titleIds.add(p.title__c);
        for(Project__C p : [Select id,title__c from project__c where title__c =: titleIds]) {
            if(proMap.containsKey(p.title__c))
                proMap.get(p.title__C).add(p);
            else proMap.put(p.title__c, new List<project__c>{p});    
        }
        for(project__C p : proNewList) 
            if(proMap.containsKey(p.title__c))
            if(proMap.get(p.title__c).size()==1)
            p.addError('There is already a Project created for that title, Use one of those records');
    }
    
    
}