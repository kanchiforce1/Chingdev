@isTest
private class PPW_ServicePrepFormController_lwcTest {
    
    public static String nickName;
    public static Map<String,User> allUserIds = new Map<String,User>();// = new Map<String,User>();
     @testVisible
    private static void loadTestData() {
     List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
     Insert tList;
     Asin__c asin = new Asin__c(title__c = tList[0].id);
     insert asin;
      User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
     tList[0].Acquiring_Editor__c = u.CommunityNickname;
     nickName=u.CommunityNickname;
     allUserIds.put(u.communityNickName,u);
     update tList[0];
     
    List<project__c> pList = new List<project__c>();
 pList = [Select id from project__c where title__c =: tList];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
 if(pList.isempty()) {
     for(title__c t: tList)
         pList.add(new project__c(title__c = t.id));
    insert pList;     
  }
    // List<Service_Prep__c> spList = [Select id,Service_Id_s_Created__c from Service_Prep__c limit 1];
      List<Service_Prep__c> spList = new List<Service_Prep__c>();
     spList = [Select id ,Service_Id_s_Created__c from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: pList)
             spList.add(new Service_Prep__c(project__c = p.id));    
     
     insert spList;
     
     }
    
     Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s;
    Service__c s1 = new Service__c(name='Acquisition Service1',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s1;
     
   
    List<Project_Services__c> psList = new List<Project_Services__c>();
    Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id,Status__c = 'In Planning');
    psList.add(ps);
    ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id ,Status__c = 'In Planning');
    psList.add(ps);
    insert psList;
     
        List<Service_Prep_Response__c> sprList = new List<Service_Prep_Response__c>();
        Service_Prep_Response__c spr = new Service_Prep_Response__c();
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.08,
                                            Locale__c='US',
                                            Option_Values__c='Yes;No',  active__c = true,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.01,1.15,1.02;');                                                                                                                                                                          
       insert spq; 
       
               
               
                                                                         
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
          sprList.add(spr); 
        
        /** design main question tet data **/ // create ps
        Service_Prep_Question__c spq4 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)', Option_Values__c='Yes;No', 
                                            Service_Prep_Parent_Question__c = spq.id,
                                            Order__c=1.15,Locale__c='US',active__c = true,Render_type__c = 'Create PS',Render_Response__c='Yes='+s.id
                                            ,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.01,1.15,1.02,1.001;');
           insert spq4;
           spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq4.id,Response__c = '[Yes;No]');
           sprList.add(spr);
           
            spq4 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Full Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)', Option_Values__c='Yes;No', 
                                            Service_Prep_Parent_Question__c = spq.id,
                                            Order__c=1.001,Locale__c='US',active__c = true,Render_type__c = 'Create PS',Render_Response__c='Yes='+s.id
                                            ,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.01,1.15,1.02,1.001;');
           insert spq4;
           spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq4.id,Response__c = '[Yes;No]');
           sprList.add(spr);
           
            spq4 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Full Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)', Option_Values__c='Yes;No', 
                                            Service_Prep_Parent_Question__c = spq.id,
                                            Order__c=1.1002,Locale__c='US',active__c = true,Render_type__c = 'Create PS',Render_Response__c='Yes='+s.id
                                            ,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.01,1.15,1.02,1002;');
           insert spq4;
           spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq4.id,Response__c = '[Yes;No]');
           sprList.add(spr);
           
            Service_Prep_Question__c spq3 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)', Option_Values__c='Yes;No', 
                                            Service_Prep_Parent_Question__c = spq.id,
                                            Order__c=1.02,Locale__c='US',active__c = true,Render_type__c = 'Create PS',Render_Response__c='Yes='+s.id
                                            ,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.10,1.15,1.002;');
           insert spq3;
           spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq3.id,Response__c = 'Yes');
           sprList.add(spr);
           
           /** sub question **/
         Service_Prep_Question__c spq5 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)', Option_Values__c='Yes;No',
                                            Order__c=1.004,Locale__c='US',active__c = true, 
                                            Service_Prep_Parent_Question__c = spq.id,
                                             Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.03;');
           insert spq5;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq5.id, Response__c = 'Yes');
           sprList.add(spr);                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.005,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS', Render_Response__c='Yes='+s.id,
                                            Update_Render_Response__c='yes='+s.id+'->'+s1.id+';');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
           
           
           spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.006,
                                            Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'No');
           sprList.add(spr); 
                                              
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Checkbox',Order__c=1.007,
                                            Locale__c='US',active__c = true,
                                            Delete_Render_type__c = 'Delete PS', Delete_Render_Response__c ='yes='+s.id);
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);                                   
         Service_Prep_Question__c spq7 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                            Order__c=1.008,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true, 
                                            Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.11;');
           insert spq7;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq7.id, Response__c = 'Yes');
           sprList.add(spr); 
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.11,
                                            Locale__c='US',active__c = true,Service_Prep_Parent_Question__c =spq7.id);
         insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
           sprList.add(spr); 
         /** Acquistion questions test data**/                                   
         Service_Prep_Question__c spq1 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,
                                              Service_Prep_Parent_Question__c =spq3.id,
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.10,
                                            Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.06;' ); 
          
                                                                                                                                                                                                                     
          
          insert spq1;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq1.id, Response__c = 'Yes');
           sprList.add(spr); 
           
       
       Service_Prep_Question__c spq10 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,
                                           
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.111,
                                            Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.06,1.07;' ); 
          
                                                                                                                                                                                                                     
          
          insert spq10;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq10.id, Response__c = 'Yes');
           sprList.add(spr); 
           
           
            
        Service_Prep_Question__c spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Title Data' ,
                                              Service_Prep_Parent_Question__c =spq10.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                            Order__c=1.106,
                                            Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true );                                                                                                                                                                          
          insert spq2;
                                                                         
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response__c = 'yes');
           sprList.add(spr);  
           
           spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Title Data' ,
                                              Service_Prep_Parent_Question__c =spq10.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                            Order__c=1.010,
                                            Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true );                                                                                                                                                                          
          insert spq2;
                                                                         
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response__c = 'yes');
           sprList.add(spr);  
          spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,
                                              Service_Prep_Parent_Question__c =spq10.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.070,Locale__c='US',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.08,1.07;');                                                                                                                                                                          
          insert spq2;
                                                                           
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response_Number__c  = 2);
           sprList.add(spr); 
          
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,
                                            Service_Prep_Parent_Question__c =spq2.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.08,
                                            Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true );                                                                                                                                                                          
       insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
           sprList.add(spr); 
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,
                                            Service_Prep_Parent_Question__c =spq10.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Order__c=1.071,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true );                                                                                                                                                                          
       insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr); 
        
        
        
        
         /** Editorial questions test data**/                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                            Option_Values__c='Yes;No',Order__c=1.079,Locale__c='US',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.04,1.07;' );                                                                                                                                                                          
          insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' ,
                                              Service_Prep_Parent_Question__c =spq.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',Order__c=1.046,Locale__c='US',active__c = true );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);
           
           
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                           Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',Order__c=1.09,Locale__c='US',active__c = true,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.046,1.07,1.04;');                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);   
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' ,
                                              Service_Prep_Parent_Question__c =spq.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',Order__c=1.0401,Locale__c='US',active__c = true );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);
        
            
          
    
         insert sprList;
         
         /* meta data setup **/
      
    }
    
    
  
    private static void loadTestData2() {
     List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
     Insert tList;
     Asin__c asin = new Asin__c(title__c = tList[0].id);
     insert asin;
     User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
     tList[0].Production_Manager__c = u.CommunityNickname;
     update tList[0];
       nickName=u.CommunityNickname;
     allUserIds.put(u.communityNickName,u);
     update tList[0];
     
    // List<project__c> pList;
    // pList = [select id from project__c];
        List<project__c> pList = new List<project__c>();
        pList = [select id from project__c];
        if(pList.isEmpty()) {
            for(title__c t: tList)
             pList.add(new project__c(title__c = t.id));
            insert pList;
        }
     
     List<Service_Prep__c> spList = new List<Service_Prep__c>();
     spList = [Select id ,Service_Id_s_Created__c from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: pList)
             spList.add(new Service_Prep__c(project__c = p.id));    
     
     insert spList;
     
     }
     Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s;
    Service__c s1 = new Service__c(name='Promo Text Creation',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s1;
     
      Service__c s12 = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s12;
    Service__c s13 = new Service__c(name='Promo Text Creation',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s13; 
    
    List<Project_Services__c> psList = new List<Project_Services__c>();
    Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id ,Status__c = 'In Planning');
    psList.add(ps);
    ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id ,Status__c = 'In Planning');
    psList.add(ps);
    insert psList;
     
        List<Service_Prep_Response__c> sprList = new List<Service_Prep_Response__c>();
        Service_Prep_Response__c spr = new Service_Prep_Response__c();
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
        
        /** design main question tet data **/ // create ps
         spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', 
                                            Option_Values__c='Yes;No',
                                            Order__c=1.0,Locale__c='US',active__c = true,Render_type__c = 'Create PS',
                                            Render_Response__c='Yes='+s.id,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.01,10.02;');
           insert spq;
           spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id,Response__c = 'Yes');
           sprList.add(spr);
           
           /** sub question **/
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                             Option_Values__c='Yes;No',
                                            Order__c=1.01,Locale__c='US',active__c = true, 
                                            Service_Prep_Parent_Question__c = spq.id,
                                             Sub_Question_Render_Type__c = 'Render Sub Question', 
                                             Sub_Question_Render__c = 'Yes=1.03;');
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.03,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS', Render_Response__c='Yes='+s.id,
                                            Update_Render_Response__c='yes='+s.id+'->'+s12.id+','+s1.id+'->'+s13.id+';');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
           
           spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.13,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS', Render_Response__c='Yes='+s.id,
                                            Update_Render_Response__c='yes='+s.id+'->'+s12.id+';');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);
           
           spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.23,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'No');
           sprList.add(spr); 
                                              
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Checkbox',Order__c=1.17,Locale__c='US',active__c = true,
                                            Delete_Render_type__c = 'Delete PS', Delete_Render_Response__c ='yes='+s.id);
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',Order__c=1.11,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true );
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
           sprList.add(spr); 
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.12,Locale__c='US',active__c = true );
         insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
           sprList.add(spr); 
         /** Acquistion questions test data**/                                   
         Service_Prep_Question__c spq1 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.13,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.06,1.07;1.09' ); 
          
                                                                                                                                                                                                                     
          
          insert spq1;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq1.id, Response__c = '');
           sprList.add(spr);  
        Service_Prep_Question__c spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.06,Locale__c='US',
                                            Option_Values__c='Yes;No',
                                            active__c = true );                                                                                                                                                                          
          insert spq2;
                                                                         
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response__c = '');
           sprList.add(spr);  
          spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.07,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.08,1.07;');                                                                                                                                                                          
          insert spq2;
                                                                           
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response_Number__c  = null);
           sprList.add(spr); 
          
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                            Order__c=1.08,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true );                                                                                                                                                                          
       insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr); 
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',Order__c=1.14,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true );
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr);
        
         /** Editorial questions test data**/                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                            Option_Values__c='Yes;No',Order__c=1.16,Locale__c='US',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.04,1.07;' );                                                                                                                                                                          
          insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' ,
                                          Service_Prep_Parent_Question__c =spq.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',
                                            Order__c=1.04,Locale__c='US',active__c = true );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);
           
           
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                             Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',
                                            Order__c=1.09,Locale__c='US',active__c = true,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.04,1.07;');                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);   
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' ,
                                              Service_Prep_Parent_Question__c =spq.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',
                                            Order__c=1.041,Locale__c='US',active__c = true );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);
        
           
        // upsert spQList;
          
    
         insert sprList;
         
         /* meta data setup **/
       //  (List<PPW_SPthreeOrMore__mdt>) JSON.deserialize( '[{"Custom_Field__c":"1"}]', List<Custom_Metadata__mdt>.class )
    }
    
     private static void loadTestData4() {
     List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
     Insert tList;
     Asin__c asin = new Asin__c(title__c = tList[0].id);
     insert asin;
     User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
     tList[0].Production_Manager__c = u.CommunityNickname; //Literary_Form__c
     tList[0].Literary_Form__c = 'Fiction Prose'; //
     update tList[0];
     
     
    List<project__c> pList = new List<project__c>();
     pList = [Select id from project__c where title__c =: tList];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
     if(pList.isempty()) {
         for(title__c t: tList)
             pList.add(new project__c(title__c = t.id));
        insert pList;     
      }
    // List<Service_Prep__c> spList = [Select id,Service_Id_s_Created__c from Service_Prep__c limit 1];
      List<Service_Prep__c> spList = new List<Service_Prep__c>();
     spList = [Select id ,Service_Id_s_Created__c from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: pList)
             spList.add(new Service_Prep__c(project__c = p.id));    
     
     insert spList;
     
     }
     Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s;
    Service__c s1 = new Service__c(name='Promo Text Creation',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s1;
     
      Service__c s12 = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s12;
    Service__c s13 = new Service__c(name='Promo Text Creation',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s13;
    
    List<Project_Services__c> psList = new List<Project_Services__c>();
    Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id, Service_Type_Complexity__c = 'Book Tsglines - copyediting, crewation' , Service__c =s.id ,Status__c = 'In Planning');
    psList.add(ps);
    ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id , Service_Type_Complexity__c = 'Book Tsglines - copyediting, crewation' , Status__c = 'In Planning');
    psList.add(ps);
     ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id , Service_Type_Complexity__c = 'Book Tsglines - copyediting, crewation' , Status__c = 'In Planning');
    psList.add(ps);
     ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s12.id , Service_Type_Complexity__c = 'Book Tsglines - copyediting, crewation' , Status__c = 'In Planning');
    psList.add(ps);
    insert psList;
     
        List<Service_Prep_Response__c> sprList = new List<Service_Prep_Response__c>();
        Service_Prep_Response__c spr = new Service_Prep_Response__c();
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
        
        /** design main question tet data **/ // create ps
         spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', Option_Values__c='Yes;No',
                                            Order__c=1.0,Locale__c='US',active__c = true,Render_type__c = 'Create PS',
                                            Render_Response__c='Yes='+s.id,
                                            Title_Response_Value__c = 'Fiction Prose - Yes='+s.id+';');
           insert spq;
           spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id,Response__c = 'Yes');
           sprList.add(spr);
           
           /** sub question **/
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', 
                                            Option_Values__c='Yes;No', Delete_Render_Response__c ='yes='+s.id,
                                            Order__c=1.01,Locale__c='US',active__c = true 
                                             );
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.03,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS', Render_Response__c='Yes='+s.id,
                                            Update_Render_Response__c='yes='+s.id+'->'+s12.id+','+s1.id+'->'+s13.id+';');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
           
           
           spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.05,
                                            Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'No');
           sprList.add(spr); 
                                              
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Checkbox',Order__c=1.06,
                                            Locale__c='US',active__c = true,
                                            Delete_Render_type__c = 'Delete PS', Delete_Render_Response__c ='yes='+s.id);
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                            Order__c=1.07,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true );
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
           sprList.add(spr); 
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.08,
                                            Locale__c='US',active__c = true );
         insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
           sprList.add(spr); 
         /** Acquistion questions test data**/                                   
         Service_Prep_Question__c spq1 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.09,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true ); 
          
                                                                                                                                                                                                                     
          
          insert spq1;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq1.id, Response__c = 'yes');
           sprList.add(spr);  
        Service_Prep_Question__c spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Order__c=1.10,Locale__c='US',
                                            Option_Values__c='Yes;No', active__c = true );                                                                                                                                                                          
          insert spq2;
                                                                         
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response__c = 'yes');
           sprList.add(spr);  
          spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.11,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true);                                                                                                                                                                          
          insert spq2;
                                                                           
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response_Number__c  = 2);
           sprList.add(spr); 
          
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                            Order__c=1.12,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true );                                                                                                                                                                          
       insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',Order__c=1.13,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true );
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr);
        
         /** Editorial questions test data**/                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',Order__c=1.14,Locale__c='US',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.04,1.07;' );                                                                                                                                                                          
          insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' ,  
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',Order__c=1.15,Locale__c='US',active__c = true );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);
           
           
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',Order__c=1.16,
                                            Locale__c='US',active__c = true
                                           );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);   
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' ,  
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',Order__c=1.17,Locale__c='US',active__c = true );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);
        
           
        // upsert spQList;
          
    
         insert sprList;
         
         /* meta data setup **/
       //  (List<PPW_SPthreeOrMore__mdt>) JSON.deserialize( '[{"Custom_Field__c":"1"}]', List<Custom_Metadata__mdt>.class )
    }
    
    
    
    private static void loadTestData1() {
     List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
     Insert tList;
     Asin__c asin = new Asin__c(title__c = tList[0].id);
     insert asin;
     User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
     tList[0].Current_Editor__c = u.CommunityNickname;
     update tList[0];
     
    List<project__c> pList = new List<project__c>();
 pList = [Select id from project__c where title__c =: tList];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
 if(pList.isempty()) {
     for(title__c t: tList)
         pList.add(new project__c(title__c = t.id));
    insert pList;     
  }
    // List<Service_Prep__c> spList = [Select id,Service_Id_s_Created__c from Service_Prep__c limit 1];
      List<Service_Prep__c> spList = new List<Service_Prep__c>();
     spList = [Select id ,Service_Id_s_Created__c from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: pList)
             spList.add(new Service_Prep__c(project__c = p.id));    
     
     insert spList;
     
     }
     Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s;
    Service__c s1 = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s1;
     
      Service__c s12 = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s12;
    Service__c s13 = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s13;
    
    List<Project_Services__c> psList = new List<Project_Services__c>();
    Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id ,Status__c = 'In Planning');
    psList.add(ps);
    ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id ,Status__c = 'In Planning');
    psList.add(ps);
    insert psList;
     
        List<Service_Prep_Response__c> sprList = new List<Service_Prep_Response__c>();
        Service_Prep_Response__c spr = new Service_Prep_Response__c();
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
        
        /** design main question tet data **/ // create ps
         spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                             Option_Values__c='Yes;No',
                                            Order__c=1.0,Locale__c='US',active__c = true,Render_type__c = 'Create PS',
                                            Render_Response__c='Yes='+s.id,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.01,10.02;');
           insert spq;
           spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id,Response__c = 'Yes');
           sprList.add(spr);
           
           /** sub question **/
         Service_Prep_Question__c spq10 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', 
                                            Option_Values__c='Yes;No',
                                            Order__c=1.01,Locale__c='US',active__c = true,
                                             Service_Prep_Parent_Question__c = spq.id,
                                             Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.03;');
           insert spq10;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq10.id, Response__c = 'Yes');
           sprList.add(spr);                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',
                                            Order__c=1.03,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS',
                                             Render_Response__c='Yes='+s.id,
                                            Update_Render_Response__c='yes='+s.id+'->'+s12.id+','+s1.id+'->'+s13.id+';');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
           
           spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',
                                            Order__c=1.031,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS',
                                             Render_Response__c='Yes='+s.id,
                                            Update_Render_Response__c='yes='+s.id+'->'+s12.id+';');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
           
           spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',
                                            Order__c=1.032,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'No');
           sprList.add(spr); 
                                              
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Checkbox',Order__c=1.034,
                                            Locale__c='US',active__c = true,
                                            Delete_Render_type__c = 'Delete PS', Delete_Render_Response__c ='yes='+s.id);
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                            Order__c=1.035,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true );
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
           sprList.add(spr); 
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.036,
                                            Locale__c='US',active__c = true );
         insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
           sprList.add(spr); 
         /** Acquistion questions test data**/                                   
         Service_Prep_Question__c spq1 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                            Order__c=1.037,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.06,1.07;1.09' ); 
          
                                                                                                                                                                                                                     
          
          insert spq1;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq1.id, Response__c = 'Yes');
           sprList.add(spr);  
        Service_Prep_Question__c spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,
                                            Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.06,
                                            Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true );                                                                                                                                                                          
          insert spq2;
                                                                         
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response__c = 'yes');
           sprList.add(spr);  
          spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,
                                              Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Order__c=1.07,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.08,1.07;');                                                                                                                                                                          
          insert spq2;
                                                                           
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response__c = 'Yes');
           sprList.add(spr); 
          
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,
                                            Service_Prep_Parent_Question__c =spq2.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Order__c=1.08,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true );                                                                                                                                                                          
       insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
           sprList.add(spr); 

         /** Editorial questions test data**/                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',Order__c=1.038,Locale__c='US',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question',
                                             Sub_Question_Render__c = 'Yes=1.04,1.07;' );                                                                                                                                                                          
          insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' ,
                                              Service_Prep_Parent_Question__c =spq.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.40,Locale__c='US',active__c = true );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);
           
           
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' ,
                                              Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',Order__c=1.09,Locale__c='US',active__c = true,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.04,1.07;');                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);   
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                             Service_Prep_Parent_Question__c =spq.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                            Option_Values__c='Yes;No',Order__c=1.041,Locale__c='US',active__c = true );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr);
        
           
        // upsert spQList;
          
    
         insert sprList;
         
         /* meta data setup **/
       //  (List<PPW_SPthreeOrMore__mdt>) JSON.deserialize( '[{"Custom_Field__c":"1"}]', List<Custom_Metadata__mdt>.class )
    }

    @istest static void servicePrepFormtest() {
          test.startTest();
     loadTestData4();
     String services = '';
     test.stopTest();
     Service_Prep__c sp = [Select id ,Service_Id_s_Created__c,project__c, project__r.title__c from Service_Prep__c limit 1];
     PPW_ServicePrepFormController_lwc.servicePrepForm('Design', sp.id,  'Review and Complete');
     PPW_ServicePrepFormController_lwc.servicePrepForm('Acquisition', sp.id,  'Create Services');
     PPW_ServicePrepFormController_lwc.servicePrepForm('Editorial', sp.id,  'Review and Complete');
     Map<String,Service_Prep_Response__c> spr = new Map<String,Service_Prep_Response__c>([select id from Service_Prep_Response__c LIMIT 2]);
     PPW_ServicePrepFormController_lwc.saveForm1(spr);
      PPW_ServicePrepFormController_lwc.questionResponse qr = new PPW_ServicePrepFormController_lwc.questionResponse();
      qr.selectedName = 'Acquisition';
      Map<String,Service_Prep_Response__c> savequsRes = new Map<String,Service_Prep_Response__c>([SELECT id from Service_Prep_Response__c]);
      qr.selectedName = 'Acquisition';
      qr.saveQuestionsResponse = savequsRes;
      List<Project_Services__c> promotionalPss = new List<Project_Services__c>(); 
      List<String> cesharenewps = new List<String>();
      Map<String,Project_Services__c> pss = new Map<String,Project_Services__c>([SELECT id,Service__r.Name,project__r.Id FROM Project_Services__c]);
      String proId;
      List<Project_Services__c> notPromotional = new List<Project_Services__c>();
        for(Project_Services__c ps: pss.values()) {
            if(ps.Service__r.Name == 'Promo Text Creation') {
                promotionalPss.add(ps);
            } else notPromotional.add(ps); 
           
                  proId = ps.project__r.Id;
        cesharenewps.add(ps.id);    
        }
      qr.newPss = pss;
      List<Service_Prep_Question__c> spq = [SELECT Id,Render_Response__c,Transmittal_Mapping__c,Name,Delete_Render_Response__c
                                                ,Service_Prep_Parent_Question__c        FROM Service_Prep_Question__c ];
        
       
        Service_Prep_Question__c subq;
      map<String,List<Service_Prep_Question__c>> subQmap = new map<String,List<Service_Prep_Question__c>>();
        for(Service_Prep_Question__c sq: spq) {
            if(String.isNotBlank(sq.Service_Prep_Parent_Question__c)) {
                subq = sq;
                if(subQmap.containsKey(sq.id))
                    subQmap.get(sq.id).add(sq);
                else subQmap.put(sq.id, new List<Service_Prep_Question__c>{sq});
            }
        }
      qr.createCaseTitle = new Map<String, List<Service_Prep_Question__c>>{sp.project__r.title__c => spq};
      Service_Prep__c spp = [SELECT id FROM Service_Prep__c LIMIT 1];
      qr.sPrepform = spp;
      Map<String,String> acqQustionsResMap = new Map<String,String>();
      Service_Prep_Response__c sprr = [SELECT id,Service_Prep_Question__c FROM Service_Prep_Response__c LIMIT 1];
      qr.projectId = proId;
      acqQustionsResMap.put(sprr.Service_Prep_Question__c, sprr.id);
      qr.acqQustionsResMap = acqQustionsResMap;
      
      PPW_ServicePrepFormController_lwc.createupdatePs(JSON.serialize(qr));
      PPW_ServicePrepFormController_lwc.projectId = sp.project__c;
      PPW_ServicePrepFormController_lwc.promotionalTextUpdateService(pss.values(),promotionalPss);
       PPW_ServicePrepFormController_lwc.promotionalTextUpdateService(notPromotional ,promotionalPss);
      PPW_ServicePrepFormController_lwc.removingServices('Promo Text Creation', promotionalPss);
      censhareServiceMultiple();
      PPW_ServicePrepFormController_lwc.censhareCalloutStatus('Acquisition', cesharenewps, 'Create Services', spp.id);
       Map<String,List<String>> resServicesMap = new Map<String,List<String>>();
      PPW_ServicePrepFormController_lwc.promotionalTextService(promotionalPss);
       PPW_ServicePrepFormController_lwc.promotionalTextService(notPromotional);
        PPW_ServicePrepFormController_lwc.promotionalTextService(pss.values());
      // acquiringEditorStaticMail 
        
          Map<String,Set<String>> resServicesMap1 = new Map<String,Set<String>>();
        boolean TransmittalMapping;
          for(String s: spq[0].Render_Response__c.split(';')) {
                if(spq[0].Transmittal_Mapping__c)
                    TransmittalMapping = true;
                if(!String.isBlank(s)){
                    List<String> resServices = s.trim().split('=');
                    if(resServices.size()==2) {
                        List<String> SIds = new List<String>();
                        
                       // if(resServices[0].containsIgnoreCase(response) || response.containsIgnoreCase(resServices[0])) {
                            if(resServices[1].contains(',')) {
                                for(String str: resServices[1].trim().split(','))
                                    SIds.add(str.trim());
                            } else    SIds.add(resServices[1].removeEnd(';'));
                            
                            resServicesMap.put(resServices[0].trim(),SIds);
                       // }
                    } 
                }
            }
        
        PPW_ServicePrepFormController_lwc ppwlwc = new PPW_ServicePrepFormController_lwc();
        ppwlwc.createPSLogic('Yes', spq[0]);
       
         for(String s: spq[1].Delete_Render_Response__c.split(';')){
            if(!String.isBlank(s)){
                List<String> resServices = s.trim().split('=');
                if(resServices.size()==2){
                    set<String> SIds = new set<String>();
                    
                  //  if( (resServices[0].containsIgnoreCase(response) || response.containsIgnoreCase(resServices[0]))){
                        if(resServices[1].contains(',')){
                            for(String str: resServices[1].trim().split(','))
                                SIds.add(ID.valueOf(str.trim()));
                           // resServicesMap.put(resServices[0].trim(),SIds);
                        }// else   SIds.add(Id.valueOf(resServices[1].removeEnd(';')));
                        
                        resServicesMap1.put(resServices[0].trim(),SIds);
                        
                   // }
                }
            } 
        }
        
        ppwlwc.deletePSLogic('Yes', spq[1]);
        PPW_ServicePrepFormController_lwc.PPW_ServicePrepFormController_lwc1(sp.project__c);
      //  PPW_ServicePrepFormController_lwc.subQuestionsFrame(subQmap,subq, new PPW_ServicePrepFormController_lwc.SerResWrap());
     String serviceIdstoCreate = '';
     String splitServices = '';
       List<id> sids = new List<id>();
         List<Service__c> slist = [select id from service__c];
           for(Service__c s: slist)
            sids.add(s.id);
        
             splitServices = slist[0].id + '->'+slist[1].id+';'; 
            
          
         system.debug(splitServices);
          PPW_ServicePrepFormController_lwc.splitServices(splitServices);
    PPW_ServicePrepFormController_lwc.createPs(null);
     PPW_ServicePrepFormController_lwc.cancelPs(sids);
    
    }
    
    @future
    public static void censhareServiceMultiple() {
    
    
    }
    
      @istest static void servicePrepFormtest1() {
          test.startTest();
     loadTestData1();
     String services = '';
     test.stopTest();
     Service_Prep__c sp = [Select id ,Service_Id_s_Created__c,project__c, project__r.title__c from Service_Prep__c limit 1];
     PPW_ServicePrepFormController_lwc.servicePrepForm('Design', sp.id,  'Review and Complete');
     PPW_ServicePrepFormController_lwc.servicePrepForm('Acquisition', sp.id,  'Create Services');
     PPW_ServicePrepFormController_lwc.servicePrepForm('Editorial', sp.id,  'Review and Complete');
     Map<String,Service_Prep_Response__c> spr = new Map<String,Service_Prep_Response__c>([select id from Service_Prep_Response__c LIMIT 2]);
     PPW_ServicePrepFormController_lwc.saveForm1(spr);
      PPW_ServicePrepFormController_lwc.questionResponse qr = new PPW_ServicePrepFormController_lwc.questionResponse();
      qr.selectedName = 'Acquisition';
      Map<String,Service_Prep_Response__c> savequsRes = new Map<String,Service_Prep_Response__c>([SELECT id from Service_Prep_Response__c]);
      qr.selectedName = 'Acquisition';
      qr.saveQuestionsResponse = savequsRes;
      List<Project_Services__c> promotionalPss = new List<Project_Services__c>(); 
      List<String> cesharenewps = new List<String>();
      Map<String,Project_Services__c> pss = new Map<String,Project_Services__c>([SELECT id,Service__r.Name FROM Project_Services__c]);
        for(Project_Services__c ps: pss.values()) {
            if(ps.Service__r.Name == 'Promo Text Creation')
                promotionalPss.add(ps);
        cesharenewps.add(ps.id);    
        }
        pss.put('', new Project_Services__c());
      qr.newPss = pss;
      List<Service_Prep_Question__c> spq = [SELECT Id,Render_Response__c,Transmittal_Mapping__c,Name,Delete_Render_Response__c
                                                ,Service_Prep_Parent_Question__c,Question_Category__c,Sub_Question_Render__c,Sub_Category__c FROM Service_Prep_Question__c ];
        
       
        Service_Prep_Question__c subq;
        List<Service_Prep_Question__c> spParentQ = new List<Service_Prep_Question__c>();
        Set<Id> sParentQIds = new Set<Id>();
      map<String,List<Service_Prep_Question__c>> subQmap = new map<String,List<Service_Prep_Question__c>>();
        for(Service_Prep_Question__c sq: spq) {
            if(String.isNotBlank(sq.Service_Prep_Parent_Question__c)) {
                subq = sq;
                sParentQIds.add(sq.Service_Prep_Parent_Question__c);
                if(subQmap.containsKey(sq.id))
                    subQmap.get(sq.id).add(sq);
                else subQmap.put(sq.id, new List<Service_Prep_Question__c>{sq});
            }
        }
        for(Service_Prep_Question__c sq: spq) 
            if(sParentQIds.contains(sq.Id)) 
                  spParentQ.add(sq);
      qr.createCaseTitle = new Map<String, List<Service_Prep_Question__c>>{sp.project__r.title__c => spq};
      Service_Prep__c spp = [SELECT id FROM Service_Prep__c LIMIT 1];
      qr.sPrepform = spp;
      Map<String,String> acqQustionsResMap = new Map<String,String>();
      Service_Prep_Response__c sprr = [SELECT id,Service_Prep_Question__c FROM Service_Prep_Response__c LIMIT 1];
      qr.projectId = sp.project__c;
      acqQustionsResMap.put(sprr.Service_Prep_Question__c, sprr.id);
      qr.acqQustionsResMap = acqQustionsResMap;
      
  
        
        PPW_ServicePrepFormController_lwc ppwlwc = new PPW_ServicePrepFormController_lwc();
        ppwlwc.createPSLogic('Yes', spq[0]);
       
       PPW_ServicePrepFormController_lwc.getPSsRecords(pss.values(), new List<Project_Services__c>(), new List<Project_Services__c>());
       PPW_ServicePrepFormController_lwc.honorDependencies(pss.values());
       PPW_ServicePrepFormController_lwc.updateThreeOrMoreSameServices(pss.values());
       
        PPW_ServicePrepFormController_lwc.subQuestionsFrame(subQmap,subq, new PPW_ServicePrepFormController_lwc.SerResWrap());
         PPW_ServicePrepFormController_lwc.subQuestionsFrame(spParentQ,sParentQIds, new List<Service_Prep__c>{spp});
    
    }
    
       @istest static void servicePrepFormtest2() {
          test.startTest();
     loadTestData2();
     String services = '';
     test.stopTest();
     Service_Prep__c sp = [Select id ,Service_Id_s_Created__c,project__c, project__r.title__c from Service_Prep__c limit 1];
    
     Map<String,Service_Prep_Response__c> spr = new Map<String,Service_Prep_Response__c>([select id from Service_Prep_Response__c LIMIT 2]);
     PPW_ServicePrepFormController_lwc.saveForm1(spr);
    
      Map<String,Service_Prep_Response__c> savequsRes = new Map<String,Service_Prep_Response__c>([SELECT id from Service_Prep_Response__c]);
       PPW_ServicePrepFormController_lwc.proManager=nickname;
      List<Project_Services__c> promotionalPss = new List<Project_Services__c>(); 
      List<String> cesharenewps = new List<String>();
      Map<id,id> psids = new  Map<id,id>();
      Map<String,Project_Services__c> pss = new Map<String,Project_Services__c>([SELECT id,Service__r.Name,service__c FROM Project_Services__c]);
        for(Project_Services__c ps: pss.values()) {
            if(ps.Service__r.Name == 'Promo Text Creation')
                promotionalPss.add(ps);
                psids.put(ps.service__c,ps.id);
        cesharenewps.add(ps.id);    
        }
    
      Map<String,Service_Prep_Question__c> spq = new Map<String,Service_Prep_Question__c>([SELECT Id,Render_Response__c,Option_Values__c,Question_Type__c,(select id,Response__c from Service_Prep_Responses__r),Create_Case__c,Transmittal_Mapping__c,Name,Delete_Render_Response__c
                                                ,Service_Prep_Parent_Question__c,Question_Category__c,Sub_Question_Render__c,Sub_Category__c FROM Service_Prep_Question__c ]);
        
       
        Service_Prep_Question__c subq;
        List<Service_Prep_Question__c> spParentQ = new List<Service_Prep_Question__c>();
        Set<Id> sParentQIds = new Set<Id>();
      map<String,List<Service_Prep_Question__c>> subQmap = new map<String,List<Service_Prep_Question__c>>();
        for(Service_Prep_Question__c sq: spq.values()) {
            if(String.isNotBlank(sq.Service_Prep_Parent_Question__c)) {
                subq = sq;
                sParentQIds.add(sq.Service_Prep_Parent_Question__c);
                if(subQmap.containsKey(sq.Service_Prep_Parent_Question__c))
                    subQmap.get(sq.Service_Prep_Parent_Question__c).add(sq);
                else subQmap.put(sq.Service_Prep_Parent_Question__c , new List<Service_Prep_Question__c>{sq});
            }
        }
        for(Service_Prep_Question__c sq: spq.values()) 
            if(sParentQIds.contains(sq.Service_Prep_Parent_Question__c)) 
                  spParentQ.add(spq.get(sq.Service_Prep_Parent_Question__c));
     
      Service_Prep__c spp = [SELECT id,Project__r.Title__r.Name,
                              Project__r.Title__r.Marty_Title_ID__c,Project__r.Name FROM Service_Prep__c LIMIT 1];
      PPW_ServicePrepFormController_lwc.acquiringEditorStaticMail(spp);
      Map<String,String> acqQustionsResMap = new Map<String,String>();
      Service_Prep_Response__c sprr = [SELECT id,Service_Prep_Question__c FROM Service_Prep_Response__c LIMIT 1];

      acqQustionsResMap.put(sprr.Service_Prep_Question__c, sprr.id);
      try {
       for(Service_Prep_Question__c spq1: spq.values()) {
           if(subQmap.containsKey(spq1.id))
               PPW_ServicePrepFormController_lwc.subDependentQuestionsFrame(subQmap, spq1, new PPW_ServicePrepFormController_lwc.SerResWrap());
      
      } } catch(exception e) { }
      // PPW_ServicePrepFormController_lwc.mulitiSelectType(new PPW_ServicePrepFormController_lwc.SerResWrap(), );
      PPW_ServicePrepFormController_lwc.subQuestionType(subQmap.get(spParentQ[0].id)[0],  spParentQ[0]);
      for(Service_Prep_Question__c spq1: spq.values())
          PPW_ServicePrepFormController_lwc.getQuesNumber(new PPW_ServicePrepFormController_lwc.SerResWrap(), spq1);
      PPW_ServicePrepFormController_lwc.updatePs(psids);
       PPW_ServicePrepFormController_lwc.projectId = sp.project__c;
      PPW_ServicePrepFormController_lwc.removeDuplicatePs( pss.values());
      //User u = [select id from user where id=: userinfo.getUserId()];
      PPW_ServicePrepFormController_lwc.allUserIds=allUserIds;
    
      
    }
    
     @istest static void servicePrepFormtest3() {
          test.startTest();
     User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
    // tList[0].Current_Editor__c = u.CommunityNickname;
     // User u = [SELECT id,CommunityNickname FROM User WHERE ];
     loadTestData1();
     String services = '';
     test.stopTest();
     Service_Prep__c sp = [Select id ,Service_Id_s_Created__c,Acquistion_Tab_Static__c,project__c, project__r.title__c from Service_Prep__c limit 1];
    
     Map<String,Service_Prep_Response__c> spr = new Map<String,Service_Prep_Response__c>([select id from Service_Prep_Response__c LIMIT 2]);
     PPW_ServicePrepFormController_lwc.saveForm1(spr);
    
      Map<String,Service_Prep_Response__c> savequsRes = new Map<String,Service_Prep_Response__c>([SELECT id from Service_Prep_Response__c]);
       PPW_ServicePrepFormController_lwc.proManager=nickname;
      List<Project_Services__c> promotionalPss = new List<Project_Services__c>(); 
      List<String> cesharenewps = new List<String>();
      Map<id,id> psids = new  Map<id,id>();
      Map<String,Project_Services__c> pss = new Map<String,Project_Services__c>([SELECT id,Service__r.Name,service__c,status__c FROM Project_Services__c]);
        for(Project_Services__c ps: pss.values()) {
            if(ps.Service__r.Name == 'Promo Text Creation')
                promotionalPss.add(ps);
                psids.put(ps.service__c,ps.id);
        cesharenewps.add(ps.id);    
        }
    
      Map<String,Service_Prep_Question__c> spq = new Map<String,Service_Prep_Question__c>([SELECT Id,Render_Response__c,Option_Values__c,Question_Type__c,(select id,Response__c from Service_Prep_Responses__r),Create_Case__c,Transmittal_Mapping__c,Name,Delete_Render_Response__c
                                                ,Service_Prep_Parent_Question__c,Question_Category__c,Sub_Question_Render__c,Sub_Category__c FROM Service_Prep_Question__c ]);
        
       
        Service_Prep_Question__c subq;
        List<Service_Prep_Question__c> spParentQ = new List<Service_Prep_Question__c>();
        Set<Id> sParentQIds = new Set<Id>();
      map<String,List<Service_Prep_Question__c>> subQmap = new map<String,List<Service_Prep_Question__c>>();
        for(Service_Prep_Question__c sq: spq.values()) {
            if(String.isNotBlank(sq.Service_Prep_Parent_Question__c)) {
                subq = sq;
                sParentQIds.add(sq.Service_Prep_Parent_Question__c);
                if(subQmap.containsKey(sq.Service_Prep_Parent_Question__c))
                    subQmap.get(sq.Service_Prep_Parent_Question__c).add(sq);
                else subQmap.put(sq.Service_Prep_Parent_Question__c , new List<Service_Prep_Question__c>{sq});
            }
        }
        for(Service_Prep_Question__c sq: spq.values()) 
            if(sParentQIds.contains(sq.Service_Prep_Parent_Question__c)) 
                  spParentQ.add(spq.get(sq.Service_Prep_Parent_Question__c));
     
      Service_Prep__c spp = [SELECT id,Acquistion_Tab_Static__c FROM Service_Prep__c LIMIT 1];
     
      Map<String,String> acqQustionsResMap = new Map<String,String>();
      Service_Prep_Response__c sprr = [SELECT id,Service_Prep_Question__c FROM Service_Prep_Response__c LIMIT 1];

      acqQustionsResMap.put(sprr.Service_Prep_Question__c, sprr.id);
     
      PPW_ServicePrepFormController_lwc.allUserIds=allUserIds;
      PPW_ServicePrepFormController_lwc.acquiringEditorStaticMail(spp);
     // proManager  currentEditor    acquiringEditor
     PPW_ServicePrepFormController_lwc.acquiringEditor = u.CommunityNickname;
     PPW_ServicePrepFormController_lwc.createCaseMethod(new Map<String, List<Service_Prep_Question__c>>());
      PPW_ServicePrepFormController_lwc.proManager = u.CommunityNickname;
      PPW_ServicePrepFormController_lwc.createCaseMethod(new Map<String, List<Service_Prep_Question__c>>());
       PPW_ServicePrepFormController_lwc.currentEditor  = u.CommunityNickname;
     PPW_ServicePrepFormController_lwc.tabStatic(spp);
      PPW_ServicePrepFormController_lwc.acquiringEditor = u.CommunityNickname;
      PPW_ServicePrepFormController_lwc.createCaseMethod(new Map<String, List<Service_Prep_Question__c>>());
      PPW_ServicePrepFormController_lwc.questionStatic('Design', spr);
      PPW_ServicePrepFormController_lwc.updatestatusps(pss.values());
      
      
    }
    
     @istest static void createCaseMethodtest3() { 
         User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
         PPW_ServicePrepFormController_lwc.proManager = u.CommunityNickname;
          PPW_ServicePrepFormController_lwc.createCaseMethod(new Map<String, List<Service_Prep_Question__c>>());
           PPW_ServicePrepFormController_lwc.currentEditor  = u.CommunityNickname;
     
     }
     
      @istest static void createCaseMethodtest2() { 
         User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
           PPW_ServicePrepFormController_lwc.currentEditor  = u.CommunityNickname;
          PPW_ServicePrepFormController_lwc.createCaseMethod(new Map<String, List<Service_Prep_Question__c>>());
       
     
     }

}