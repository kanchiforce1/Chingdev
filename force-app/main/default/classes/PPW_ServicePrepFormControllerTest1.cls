@isTest
private class PPW_ServicePrepFormControllerTest1 {
    
   @testVisible
    private static void loadTestData() {
     List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
     Insert tList;
     Asin__c asin = new Asin__c(title__c = tList[0].id);
 insert asin;
      User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
     tList[0].Acquiring_Editor__c = u.CommunityNickname;
     update tList[0];
     
     List<project__c> pList;// = PPW_TestDataFactory.getProjectData(5,tList[0].Id);
     pList = [select id from project__c];
     try{
    // Insert pList1;
      }catch(Exception e){}
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
   
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
     
     
     List<project__c> pList;// = PPW_TestDataFactory.getProjectData(5,tList[0].Id);
     pList = [select id from project__c];
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
   //  Insert spList;
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
     
     
   /// List<project__c> pList;// = PPW_TestDataFactory.getProjectData(5,tList[0].Id);
   //  pList = [select id from project__c];
      List<project__c> pList = new List<project__c>();
     pList = [Select id from project__c where title__c =: tList];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
    
      if(pList.isEmpty()) {
            for(title__c t: tList)
                pList.add(new project__c(title__c = t.id));
          
            insert pList;
        }
     
    // List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
     
      List<Service_Prep__c> spList = new List<Service_prep__c>();
     spList = [Select id from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: pList)
             spList.add(new Service_Prep__c(project__c = p.id));
     
         insert spList;
     }
   //  Insert spList;
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
     
    List<project__c> pList;// = PPW_TestDataFactory.getProjectData(5,tList[0].Id);
     pList = [select id from project__c];
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
   //  Insert spList;
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
    
       
    
    }