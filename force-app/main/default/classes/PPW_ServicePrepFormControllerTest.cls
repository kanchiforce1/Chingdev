@isTest
private class PPW_ServicePrepFormControllerTest {
    
     @testVisible
    private static void loadTestData() {
     List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
     Insert tList;
     Asin__c asin = new Asin__c(title__c = tList[0].id);
 insert asin;
      User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
     tList[0].Acquiring_Editor__c = u.CommunityNickname;
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
                                            Option_Values__c='Yes;No',
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




    @isTest static void projectCreationTest() {
     
     test.startTest();
     loadTestData4();
     String services = '';
     test.stopTest();
     List<Service_Prep__c> spList = [Select id,Project__r.Title__r.Name,Project__r.Title__r.Marty_Title_ID__c,
                                      Project__r.Name,Status__c from Service_Prep__c limit 1];
     List<service__c> s = [SELECT id FROM service__c];
        List<Project_Services__c> psL = new List<Project_Services__c>();
        Project_Services__c ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c =s[0].id);
        psL.add(ps1);
        ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c = s[1].id);
        psL.add(ps1);
        insert psL;
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
         User u = [SELECT CommunityNickname,Email, Id FROM User WHERE id=:Userinfo.getUserId() Limit 1];
         
         sFormCont.getAllUser(new List<String>{u.CommunityNickname});
         sFormCont.proManager = u.CommunityNickname;
         sFormCont.currentTab ='Acquisition';
         sFormCont.CreatePS();
         sFormCont.SaveForm();
         sFormCont.CreatePS();
         sFormCont.createPsLogicforTabwise();
         sFormCont.currentTab ='Design';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
         sFormCont.acquiringEditorStaticMail(spList[0]);
         sFormCont.currentTab ='Acquisition';
         
         sFormCont.servicePrepForm(spList[0]);
         List<Project_Services__c> psList = [select id,Service__c from Project_Services__c];
         psList.add(new Project_Services__c());
         sFormCont.getPSsRecords(psList,new List<Project_Services__c>(),new List<Project_Services__c>());
         
         PPW_ServicePrepFormController.SerResWrap srw = new PPW_ServicePrepFormController.SerResWrap();
         srw.parentQustion = true;
         srw.responseType = 'test';
         srw.parentPrepResp = new Service_Prep_Response__c();
         srw.parentQuestion = new Map<String,PPW_ServicePrepFormController.SerResWrap>();
         srw.parentQResp = 'test';
         srw.pCat = 'test';
        srw.pSCat = 'test';
         
         for(Project_Services__c ps: psList){
           services = services+','+ps.Service__c;   
         
         }
         sFormCont.incrementCounter();
         Project_Services__c ps = new Project_Services__c(Project__c = null,Service__c =null);
         sFormCont.honorDependencies(new list<Project_Services__c> {ps});
         sFormCont.removingServices(services,psList);
         try{
        // sFormCont.censhareServicerMethod(psList);
         
         }catch(exception e){}
         
     
    }
    
    @isTest static void projectCreationTest4() {
     
     test.startTest();
     loadTestData2();
     test.stopTest();
     List<Service_Prep__c> spList = [Select id,project__c from Service_Prep__c limit 1];
      List<service__c> s = [SELECT id FROM service__c];
        List<Project_Services__c> psL = new List<Project_Services__c>();
        Project_Services__c ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c =s[0].id);
        psL.add(ps1);
        ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c = s[1].id);
        psL.add(ps1);
        insert psL;
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
         sFormCont.currentTab ='Acquisition';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
         sFormCont.createPsLogicforTabwise();
          sFormCont.currentTab ='Design';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
         List<Project_Services__c> psList = [select id,Service__c from Project_Services__c];
       
         try{
          ppw_censhareConnector cs = new ppw_censhareConnector();
         map<id, set<id>> dependencyIDs = new map<id, set<id>>();
         dependencyIDs.put(psList[0].service__c, new set<id> {psList[0].service__c});
         
        // cs.censhareXMLDependencyBuilder(psList[0],dependencyIDs,psList);
       //  sFormCont.censhareServicerMethod(psList);
        
         }catch(exception e){}
         
     
    }
    
     @isTest static void projectCreationTest3() {
     test.startTest();
     loadTestData1();
     test.stopTest();
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
     String serviceIdstoCreate = '';
     String splitServices = null;
     //List<Service__c> serList = 
     for(service__c s: [select id from service__c]) {//new Service__c
        serviceIdstoCreate = serviceIdstoCreate+s+','; 
     if(String.isBlank(splitServices))
         splitServices = s.id;
     else
         splitServices = splitServices+ '->'+s.id+';';        
     }   
     
     
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       spList = [Select id,Service_Id_s_Created__c,project__c from Service_Prep__c limit 1];
       spList[0].Service_Id_s_Created__c = serviceIdstoCreate;
       update spList[0];
        
         List<service__c> s = [SELECT id FROM service__c];
        List<Project_Services__c> psL = new List<Project_Services__c>();
        Project_Services__c ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c =s[0].id);
        psL.add(ps1);
        ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c = s[1].id);
        psL.add(ps1);
        insert psL;
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
        
          sFormCont.currentTab ='Design';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
         try {
         sFormCont.splitServices(splitServices);
         }catch(exception e ) {}
         sFormCont.scaffoldServices();
         sFormCont.autoSaveForm();
         //sFormCont.updatePSLogic();
    }
    
    
      @isTest static void projectCreationTest31() {
     test.startTest();
     loadTestData1();
     test.stopTest();
     List<Service_Prep__c> spList = [Select id,project__c from Service_Prep__c limit 1];
     
      List<service__c> s = [SELECT id FROM service__c];
        List<Project_Services__c> psL = new List<Project_Services__c>();
        Project_Services__c ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c =s[0].id);
        psL.add(ps1);
        ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c = s[1].id);
        psL.add(ps1);
        insert psL;
         String serviceIdstoCreate = '';
         String splitServices = null;
         //List<Service__c> serList = 
         for(service__c s1: [select id from service__c]) {//new Service__c
            serviceIdstoCreate = serviceIdstoCreate+s1+','; 
         if(String.isBlank(splitServices))
             splitServices = s1.id;
         else
             splitServices = splitServices+ '->'+s1.id+';';        
         }   
     
     
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       spList = [Select id,Service_Id_s_Created__c from Service_Prep__c limit 1];
       spList[0].Service_Id_s_Created__c = serviceIdstoCreate;
       update spList[0];
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
         sFormCont.currentTab ='Acquisition';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
         sFormCont.createPsLogicforTabwise();
         try {
         sFormCont.splitServices(splitServices);
         }catch(exception e) {}
         sFormCont.scaffoldServices();
         sFormCont.autoSaveForm();
         //sFormCont.updatePSLogic();
    }
    
    
     @isTest static void projectCreationTest5() {
     test.startTest();
     loadTestData();
     test.stopTest();
     List<Service_Prep__c> spList = [Select id,project__c from Service_Prep__c limit 1];
      List<service__c> s = [SELECT id FROM service__c];
        List<Project_Services__c> psL = new List<Project_Services__c>();
        Project_Services__c ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c =s[0].id);
        psL.add(ps1);
        ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c = s[1].id);
        psL.add(ps1);
        insert psL;
     String serviceIdstoCreate = '';
     //List<Service__c> serList = 
     for(service__c s1: [select id from service__c])//new Service__c
        serviceIdstoCreate = serviceIdstoCreate+s1+','; 
     
     
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       spList = [Select id,Service_Id_s_Created__c from Service_Prep__c limit 1];
       spList[0].Service_Id_s_Created__c = serviceIdstoCreate;
       update spList[0];
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
         sFormCont.currentTab ='Acquisition';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
         sFormCont.createPsLogicforTabwise();
    }
  
  /*   @isTest static void projectCreationTest6() {
     test.startTest();
    Service_Prep_Question__c spQ = new Service_Prep_Question__c(Order__c=1);
       title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = 'US',Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    PR_Tier__c= 'Yes',Internal_Imprint__c='Lake Union,Thomas & Merce'
                                    );
       insert t;
       
      String pid = [select id from project__c where title__C =:t.id limit 1].id;
     
     PPW_ServicePrepFormControllerHelper.pid = pid;
    
     PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,'Yes');
     PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,null);
     
                                 
   
    test.stopTest();
        
    } */
    
    @isTest static void projectCreationTest6_1() {
     test.startTest();
    
     Service_Prep_Question__c spQ = new Service_Prep_Question__c(Order__c=1);
     insert spq; 
      title__c t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = null,Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    PR_Tier__c= 'Yes',Internal_Imprint__c=null,
                                    External_Imprint__c = 'test',
                                    Content_Producer__c = 'test'
                                    );
       insert t;
       String pid ;
        List<project__c> pList = new List<project__c>();
         pList = [Select id from project__c where title__c =: t.id];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
         if(pList.isempty()) {
            
                 pList.add(new project__c(title__c = t.id));
            insert pList;     
          } else pid = pList[0].id;
       
     
       
    // String pid = p.id;//[select id from project__c where title__C =:t.id limit 1].id;  
      PPW_ServicePrepFormControllerHelper.pid     = pid;
   
     PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,'Yes');
      PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,null);
         
                                  
   
    test.stopTest();
        
    }
     
    @isTest static void projectCreationTest6_5() {
     test.startTest();
    
     Service_Prep_Question__c spQ = new Service_Prep_Question__c(Order__c=1);
     insert spq; 
      title__c t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = 'US',Internal_Imprint__c='Lake Union,Thomas & Mercer',Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    PR_Tier__c= 'Yes'
                                    );
       insert t;
       String pid ;
        List<project__c> pList = new List<project__c>();
         pList = [Select id from project__c where title__c =: t.id];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
         if(pList.isempty()) {
            
                 pList.add(new project__c(title__c = t.id));
            insert pList;     
          } else pid = pList[0].id;
      PPW_ServicePrepFormControllerHelper.pid = pid;
     system.debug(pId);
     PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,'Yes');
      PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,null);
         
                                  
   
    test.stopTest();
        
    }
    
    
     @isTest static void projectCreationTest6_2() {
     test.startTest();
    
     Service_Prep_Question__c spQ = new Service_Prep_Question__c(Order__c=1);
     insert spq; //c[select id from Service_Prep_Question__c limit 1];
      title__c t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = 'US',Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    PR_Tier__c= 'Yes',Internal_Imprint__c='Two Lions',
                                     External_Imprint__c = 'test',
                                    Content_Producer__c = 'test'
                                    );
       insert t;
         String pid ;
        List<project__c> pList = new List<project__c>();
         pList = [Select id from project__c where title__c =: t.id];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
         if(pList.isempty()) {
            
                 pList.add(new project__c(title__c = t.id));
            insert pList;     
          } else pid = pList[0].id;
      PPW_ServicePrepFormControllerHelper.pid     = pid;
     Map<String,List<SObject>> recordsMap = PPW_ServicePrepFormControllerHelper.recordsMap;
     List<Project__c> projectlist = PPW_ServicePrepFormControllerHelper.projectlist;
     List<ASIN__c> asinRecords = PPW_ServicePrepFormControllerHelper.asinRecords;
     PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,'Yes');
      PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,null);
         
                                  
   
    test.stopTest();
        
    }
    
    @isTest static void projectCreationTest6_6() {
     test.startTest();
    
     Service_Prep_Question__c spQ = new Service_Prep_Question__c(Order__c=1);
     insert spq; //c[select id from Service_Prep_Question__c limit 1];
       title__c t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = 'US',Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    PR_Tier__c= 'Yes',Internal_Imprint__c='Two Lions',Cover_Design_Credit__c = 'test',
                                     External_Imprint__c = 'test',
                                    Content_Producer__c = 'test'
                                    );
       insert t;
        String pid ;
        List<project__c> pList = new List<project__c>();
         pList = [Select id from project__c where title__c =: t.id];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
         if(pList.isempty()) {
            
                 pList.add(new project__c(title__c = t.id));
            insert pList;     
          } else pid = pList[0].id; 
      PPW_ServicePrepFormControllerHelper.pid     = pid;
     Map<String,List<SObject>> recordsMap = PPW_ServicePrepFormControllerHelper.recordsMap;
     List<Project__c> projectlist = PPW_ServicePrepFormControllerHelper.projectlist;
     List<ASIN__c> asinRecords = PPW_ServicePrepFormControllerHelper.asinRecords;
     PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,'Yes');
      PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,null);
         
                                  
   
    test.stopTest();
        
    }
    
     @isTest static void projectCreationTest6_7() {
     test.startTest();
    
     Service_Prep_Question__c spQ = new Service_Prep_Question__c(Order__c=1);
     insert spq; //c[select id from Service_Prep_Question__c limit 1];
       title__c t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = 'US',Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    PR_Tier__c= 'Yes',Internal_Imprint__c='Two Lions',Cover_Design_Credit__c = null,
                                     External_Imprint__c = 'test',
                                    Content_Producer__c = 'test'
                                    );
       insert t;
         String pid ;
        List<project__c> pList = new List<project__c>();
         pList = [Select id from project__c where title__c =: t.id];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
         if(pList.isempty()) {
            
                 pList.add(new project__c(title__c = t.id));
            insert pList;     
          } else pid = pList[0].id;
      PPW_ServicePrepFormControllerHelper.pid     = pid;
     Map<String,List<SObject>> recordsMap = PPW_ServicePrepFormControllerHelper.recordsMap;
     List<Project__c> projectlist = PPW_ServicePrepFormControllerHelper.projectlist;
     List<ASIN__c> asinRecords = PPW_ServicePrepFormControllerHelper.asinRecords;
     PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,'Yes');
      PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,null);
         
                                  
   
    test.stopTest();
        
    }
    
    @isTest static void projectCreationTest6_3() {
     test.startTest();
   Service_Prep_Question__c spQ = new Service_Prep_Question__c(Order__c=1);
     title__c t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = 'rt',Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    PR_Tier__c= null,Internal_Imprint__c='test'
                                    );
       insert t; 
        String pid ;
        List<project__c> pList = new List<project__c>();
         pList = [Select id from project__c where title__c =: t.id];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
         if(pList.isempty()) {
            
                 pList.add(new project__c(title__c = t.id));
            insert pList;     
          } else pid = pList[0].id;
    PPW_ServicePrepFormControllerHelper.pid = pid;
    // Map<String,List<SObject>> recordsMap = PPW_ServicePrepFormControllerHelper.recordsMap;
     PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,'Yes'); 
      PPW_ServicePrepFormControllerHelper.psMWCCreate(new List<project_services__c>(),spQ.id,null);                             
   
    test.stopTest();
        
    }
   
       @isTest static void projectCreationTest16() {
     test.startTest();
     loadTestData();
     test.stopTest();
     List<Service_Prep__c> spList = [Select id,project__c from Service_Prep__c limit 1];
      List<service__c> s = [SELECT id FROM service__c];
        List<Project_Services__c> psL = new List<Project_Services__c>();
        Project_Services__c ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c =s[0].id);
        psL.add(ps1);
        ps1 = new Project_Services__c(Project__c = spList[0].Project__c,Service__c = s[1].id);
        psL.add(ps1);
        insert psL;
     String serviceIdstoCreate = '';
     //List<Service__c> serList = 
     for(service__c s1: [select id from service__c])//new Service__c
        serviceIdstoCreate = serviceIdstoCreate+s1+','; 
     
     
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       spList = [Select id,Service_Id_s_Created__c from Service_Prep__c limit 1];
       spList[0].Service_Id_s_Created__c = serviceIdstoCreate;
       update spList[0];
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
        
          sFormCont.currentTab ='Design';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
        
    }
        
     @isTest static void projectCreationTest7() {
     test.startTest();
     loadTestData();
     test.stopTest();
     List<Service_Prep__c> spList = [Select id,project__c from Service_Prep__c limit 1];
     String serviceIdstoCreate = '';
     //List<Service__c> serList = 
     for(service__c s: [select id from service__c])//new Service__c
        serviceIdstoCreate = serviceIdstoCreate+s+','; 
     
     
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       spList = [Select id,Service_Id_s_Created__c from Service_Prep__c limit 1];
       spList[0].Service_Id_s_Created__c = serviceIdstoCreate;
       update spList[0];
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
         
         sFormCont.currentTab ='Editorial';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
    }
    
    @isTest static void projectCreationTest8() {
     test.startTest();
     loadTestData();
     test.stopTest();
     List<Service_Prep__c> spList = [Select id,project__c from Service_Prep__c limit 1];
     String serviceIdstoCreate = '';
     //List<Service__c> serList = 
     for(service__c s: [select id from service__c])//new Service__c
        serviceIdstoCreate = serviceIdstoCreate+s+','; 
     
     
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       spList = [Select id,Service_Id_s_Created__c from Service_Prep__c limit 1];
       spList[0].Service_Id_s_Created__c = serviceIdstoCreate;
       update spList[0];
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
         sFormCont.currentTab ='Acquisition';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
         sFormCont.createPsLogicforTabwise();
    }
    
    
     @isTest static void projectCreationTest9() {
     test.startTest();
     loadTestData1();
     
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
    
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
        
         sFormCont = new PPW_ServicePrepFormController(sc);
         sFormCont.btnName = 'CreatePs';
         sFormCont.currentTab ='Design';
         sFormCont.SaveForm();
        // sFormCont.CreatePS();
         sFormCont.Cancel();
        
        
         test.stopTest();
      
    }
    
     @isTest static void projectCreationTest91() {
     test.startTest();
     loadTestData1();
     
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
    
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
        
         sFormCont = new PPW_ServicePrepFormController(sc);
         sFormCont.btnName = 'CreatePs';
         sFormCont.currentTab ='Design';
         //sFormCont.SaveForm();
         sFormCont.CreatePS();
         sFormCont.Cancel();
        
        
         test.stopTest();
      
    }
    
     @isTest static void projectCreationTest12() {
     test.startTest();
      List<title__c> tList = PPW_TestDataFactory.gettitleData(1,'US');
      Insert tList;
      
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
     
     Service__c s = new Service__c(name='Promo Text Creation',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s;
     Service__c s1 = new Service__c(name='Promo Text Creation',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s1;
    
    List<Project_Services__c> psList = new List<Project_Services__c>();
    Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id);
    psList.add(ps);
    ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id);
    psList.add(ps);
    insert psList;
     
     // List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
     
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
        sFormCont.projectId =  pList[0].id;
         sFormCont = new PPW_ServicePrepFormController(sc);
         sFormCont.btnName = 'CreatePs';
         sFormCont.currentTab ='Design';
         //sFormCont.removeAllPromotionalTextService(psList);
        // sFormCont.onePromotionalTextService(psList);
        
        
         test.stopTest();
      
    }
    
     @isTest static void projectCreationTest10() {
     test.startTest();
     loadTestData1();
     
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
    
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
        
         sFormCont = new PPW_ServicePrepFormController(sc);
         sFormCont.btnName = 'CreatePs';
        
         sFormCont.currentTab ='Acquisition';
        // sFormCont.SaveForm();
         sFormCont.CreatePS();
         sFormCont.autoSaveForm();
         sFormCont.createPsLogicforTabwise();
         test.stopTest();
      
    }
    
     @isTest static void projectCreationTest11() {
     test.startTest();
     loadTestData1();
     
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
    
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
        
         sFormCont = new PPW_ServicePrepFormController(sc);
         sFormCont.btnName = 'CreatePs';
          sFormCont.digitPatternCheck('123');
         sFormCont.digitPatternCheck('aab');
         sFormCont.digitPatternCheck('');
         sFormCont.currentTab ='Editorial';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
         
         sFormCont.currentTab();
         test.stopTest();
      
    }
     @isTest static void projectCreationTest2() {
     
     test.startTest();
     loadTestData2();
     test.stopTest();
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
    
     ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
       
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
         sFormCont.btnName = 'CreatePs';
         sFormCont.currentTab ='Editorial';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
          sFormCont.currentTab ='Design';
         sFormCont.SaveForm();
      
          sFormCont.currentTab ='Acquisition';
         sFormCont.SaveForm();
         sFormCont.CreatePS();
         sFormCont.createPsLogicforTabwise();
         sFormCont.getQuesNumber('Yes=1.03,1.02,1.01;');
    }
   
   
    @testVisible
     @isTest static void ChildControllerTest() {
     
     test.startTest();
     loadTestData2();
     test.stopTest();
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
    
    
        
        List<Service_Prep_Response__c> sresplist = [Select id from Service_Prep_Response__c limit 1];
         PPW_ServicePrepFormChildController sFormCont = new PPW_ServicePrepFormChildController();
         sFormCont.sId = sresplist[0].id;
         sFormCont.inputType = 'Number';//svalue
         sFormCont.svalue = '12';
         sFormCont.dispFunc();
         
          sFormCont = new PPW_ServicePrepFormChildController();
         sFormCont.sId = sresplist[0].id;
         sFormCont.inputType = 'Number';//svalue
         sFormCont.svalue = '';
         sFormCont.dispFunc();
         sFormCont.digitPatternCheck('');
         
         sFormCont = new PPW_ServicePrepFormChildController();
         sFormCont.sId = sresplist[0].id;
         sFormCont.inputType = 'Text';//svalue
         sFormCont.svalue = '12';
         sFormCont.dispFunc();
         sFormCont = new PPW_ServicePrepFormChildController();
         sFormCont.sId = sresplist[0].id;
         sFormCont.inputType = 'Checkbox';//svalue
         sFormCont.svalue = 'on';
         sFormCont.dispFunc();
         sFormCont = new PPW_ServicePrepFormChildController();
         sFormCont.sId = sresplist[0].id;
         sFormCont.inputType = 'Checkbox';//svalue
         sFormCont.svalue = 'off';
         sFormCont.dispFunc();
         sFormCont.questions1 = null;
         
    } 
    
    }