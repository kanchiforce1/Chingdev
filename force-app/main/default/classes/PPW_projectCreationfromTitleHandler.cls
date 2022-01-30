public class PPW_projectCreationfromTitleHandler {

    public static void insertAndUpdateTitlemethod(list<Title__C> titles){
        list<Project__c> proInsertList = new list<Project__c>();
    map<String,Project__c> projectscheck = new map<String,Project__c>();
    
          for( Project__c p: [select id,title__c from Project__c where title__C=: titles])
        if(p.title__c!=null)
        projectscheck.put(p.title__c,p);
        
       for(title__c t: titles){
            if(!projectscheck.containskey(t.id)){
                project__c p =new project__c(title__C = t.id);
                 proInsertList.add(p);
            }
         }
       insert proInsertList;          
    }
}