@isTest
private class ServiceTriggerHandlerTest {
    
    private static void loadTestData2() {
        List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
        Insert tList;
        Asin__c asin = new Asin__c(title__c = tList[0].id);
        insert asin;
        Creative_Brief__c cb = new Creative_Brief__c(title__c=tList[0].id);
        insert cb;
        
        User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
        tList[0].Production_Manager__c = u.CommunityNickname;
        update tList[0];
        
     
        
       List<project__c> pList = new List<project__c>();
     pList = [Select id from project__c where title__c =: tList];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
    
      if(pList.isEmpty()) {
            for(title__c t: tList)
                pList.add(new project__c(title__c = t.id));
          
            insert pList;
        }
    
    
    
    // Insert pList;
     List<Service_Prep__c> spList = new List<Service_prep__c>();
     spList = [Select id from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: pList)
             spList.add(new Service_Prep__c(project__c = p.id));
     
         insert spList;
     }
        Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
        insert s;
        Service__c s1 = new Service__c(name='Design Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
        insert s1;
        
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK');
        insert v;   
        
           Account ac = new Account(name ='TEST'+v.id) ;
        insert ac;  
        contact cont =new contact(LastName='TSEt',Email='TEST'+v.id+'@gmail.com',vendor__c = v.id,accountid=ac.id, ApubOps_Community_User__c = true);
        insert cont;
          contact c =[SELECT id,Name,Email FROM contact LIMIT 1];
        profile p = [SELECT id FROM profile WHERE name = 'vendor partner community login user' LIMIT 1];
       /* User user = new User(alias = 'TESTzzxx', email=c.Email,
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p.id, country='United States',IsActive =true,
                             ContactId = c.Id,
                             timezonesidkey='America/Los_Angeles', username=c.Email+'@noemail.com');
        
        insert user;*/
        
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
        
    }
    
    @isTest static void projectCreationTest2() {
        
        test.startTest();
        loadTestData2();
       
        List<service__c> sl = new List<service__c>();
        for(service__c s: [select id from service__c]) {
            s.Service_Grouping__c = 'Promotional Text';
            sl.add(s);
        }  
        update sl;
      
        test.stopTest();
        
    } 
    
    @isTest static void projectCreationTest3() {
        
        test.startTest();
        loadTestData2();
        List<service__c> sl = new List<service__c>();
        for(service__c s: [select id from service__c]) {
            s.Service_Grouping__c = null;
            sl.add(s);
        }  
        update sl;
        test.stopTest();
        
    }
    
    @isTest static void projectCreationTest4() {
        
        test.startTest();
        loadTestData2();
        List<service__c> sl = new List<service__c>();
        for(service__c s: [select id from service__c limit 1]) {
            s.Service_Grouping__c = 'Full Color';
            sl.add(s);
        }  
        update sl;
        test.stopTest();
        
    } 
    
    @isTest static void projectCreationTest5() {
        
        test.startTest();
        loadTestData2();
       
        List<service__c> sl = new List<service__c>();
        for(service__c s: [select id from service__c]) {
            s.Service_Grouping__c = 'Promotional Text';
            sl.add(s);
        }  
        update sl;
      sl = new List<service__c>();
      for(service__c s: [select id from service__c]) {
            s.Service_Grouping__c = null;
            sl.add(s);
        }  
        update sl;
        test.stopTest();
        
    } 
}