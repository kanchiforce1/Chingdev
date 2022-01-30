@isTest
private class CreativeBriefTriggerHandlerTest {
    
   
    
    static testMethod void extViewPage() {
    test.starttest();
      title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital',Marty_Title_ID__c = '123', Internal_Imprint__c = 'Two Lions' , Series__c = 'test');
        insert t;
        
        title__C t1 = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital1',Marty_Title_ID__c = '1234', Internal_Imprint__c = '47North');
        insert t1;
         
          List<project__c> pList = new List<project__c>();// = PPW_TestDataFactory.getProjectData(5,tList[0].Id);
        pList = [select id from project__c];
        if(pList.isEmpty()) {
            pList.add(new project__c(title__c = t.id));
            pList.add(new project__c(title__c = t1.id));
            insert pList;
        }
        
        
        List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
           Service__c     
     s = new Service__c(name='Animating',Active__c = true,Service_Rate_Type__c = 'Animating - Handdrawn', Service_Grouping__c = 'Promotional Text');
        insert s;
        Service__c s1 = new Service__c(name='Animating',Active__c = true,Service_Rate_Type__c = 'Animating - Handdrawn', Service_Grouping__c = 'Comic Book');
        insert s1; 
        
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK');
        insert v;   
        
            List<Project_Services__c> psList = new List<Project_Services__c>();
        Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id,vendor__c= v.id,Estimated_Start_Date__c = date.today(), 
                                                         Estimated_Completion_Date__c = date.today(),Actual_Start_Date__c=date.today(),Actual_Completion_Date__c= date.today()
                                                        );
        psList.add(ps);
        
        ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id,vendor__c= v.id,Estimated_Start_Date__c = date.today(),
                                                         Estimated_Completion_Date__c = date.today(),Actual_Start_Date__c=date.today(),Actual_Completion_Date__c= date.today()
                                                        );
        psList.add(ps);
      //  ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id);
      //  psList.add(ps);
         insert psList;
        
        test.stoptest();
         
      book_questionnaire__c bq = new book_questionnaire__c(title__c = t1.id);
      
      insert bq;
     bq = new book_questionnaire__c(title__c = t.id);
      
      insert bq;
      
      author_questionnaire__c aq = new author_questionnaire__c(title__c = t1.id);
      insert aq;
      
      aq = new author_questionnaire__c(title__c = t.id);
      insert aq;
      
        Creative_brief__c cb= new Creative_brief__c(Title__c = t.id);
        insert cb;
        try {
       List<Creative_brief__c> cbLst = new List<Creative_brief__c>();
        List<Creative_Brief__c> cblst1 = [SELECT id, name, title__c FROM creative_brief__c];
    system.debug(cblst1);
     system.debug(t.id);
        Creative_brief__c cb1= new Creative_brief__c(Title__c = t.id);
         cbLst.add(cb1);
        cb1= new Creative_brief__c(Title__c = t1.id);
       
        cbLst.add(cb1);
       
        insert cbLst;
        } catch(exception e)  {system.debug(e.getmessage());}
        
        
       cb = [select id,title__c, title__r.Marty_Title_ID__c  from Creative_brief__c limit 1];
       
        cb.Title__c = cb.title__c;
        cb.Non_Standard_Formats__c = 'Other';
        cb.Publishing_Background__c = 'Debut';
         update cb;
     
    }
    
    
}