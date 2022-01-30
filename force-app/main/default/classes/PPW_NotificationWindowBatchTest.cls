@isTest
private class PPW_NotificationWindowBatchTest {

private static void loadTestData() {
     List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
     Insert tList;
      User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
     tList[0].Acquiring_Editor__c = u.CommunityNickname;
     tList[0].status__c = String.valueOf(label.StatusCheckProjectCreation.trim()).split(',')[0].trim();
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
     
   //  Insert spList;
     Service__c s = new Service__c(name='Developmental Edit',Active__c = true,Service_Rate_Type__c = 'Developmental Edit',Service_Grouping__c = 'Cover Design');
     insert s;
    Service__c s1 = new Service__c(name='Developmental Edit',Active__c = true,Service_Rate_Type__c = 'Developmental Edit',Service_Grouping__c = 'Cover Design');
     insert s1;
    
    List<Project_Services__c> psList = new List<Project_Services__c>();
    Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id,Estimated_Start_Date__c = date.today().addDays(36));
    psList.add(ps);
    ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id,Estimated_Start_Date__c = date.today().addDays(38));
    psList.add(ps);
    insert psList;
     
        List<Service_Prep_Response__c> sprList = new List<Service_Prep_Response__c>();
        Service_Prep_Response__c spr = new Service_Prep_Response__c();
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.08,Locale__c='US',
                                            Option_Values__c='Yes;No',  active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.01,1.15;',Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');                                                                                                                                                                          
       insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'None');
           sprList.add(spr); 
        
        /** design main question tet data **/ // create ps
        Service_Prep_Question__c spq3 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', Option_Values__c='Yes;No', Service_Prep_Parent_Question__c = spq.id,
                                            Order__c=1.15,Locale__c='US',active__c = true,Render_type__c = 'Create PS',Render_Response__c='Yes='+s.id,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.01,1.05,1.10;',Notification_Service__c = 'Developmental Edit'
                                            ,Notification_Window__c='Start');
           insert spq3;
           spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq3.id,Response__c = 'Yes');
           sprList.add(spr);
           
           /** sub question **/
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', Option_Values__c='Yes;No',
                                            Order__c=1.01,Locale__c='US',active__c = true, Service_Prep_Parent_Question__c = spq3.id,
                                             Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.03;',
                                             Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr);                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.03,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS', Render_Response__c='Yes='+s.id,
                                            Update_Render_Response__c='yes='+s.id+'->'+s1.id+';',Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr); 
           
           
           spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.031,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS',
                                            Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');
                                             
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr); 
                                              
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Checkbox',Order__c=1.0,Locale__c='US',active__c = true,
                                            Delete_Render_type__c = 'Delete PS', Delete_Render_Response__c ='yes='+s.id,Notification_Service__c = 'Developmental Edit',
                                            Notification_Window__c='Start');
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr);                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',Order__c=1.021,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true ,Notification_Service__c = 'Developmental Edit',
                                            Notification_Window__c='Start');
           insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr); 
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.012,Locale__c='US',active__c = true
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start' );
         insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'None');
           sprList.add(spr); 
         /** Acquistion questions test data**/                                   
         Service_Prep_Question__c spq1 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , Service_Prep_Parent_Question__c =spq3.id,
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.10,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.06;',Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start' ); 
          
                                                                                                                                                                                                                     
          
          insert spq1;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq1.id, Response__c = 'None');
           sprList.add(spr);  
        Service_Prep_Question__c spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.06,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');                                                                                                                                                                          
          insert spq2;
                                                                         
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response__c = '');
           sprList.add(spr);  
          spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.07,Locale__c='US',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.08,1.07;'
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');                                                                                                                                                                          
          insert spq2;
                                                                           
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response_Number__c  = null);
           sprList.add(spr); 
          
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq2.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.088,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
       insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr); 
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq2.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.081,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
       insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr); 
        
        
        
        
         /** Editorial questions test data**/                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.0,Locale__c='US',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.04,1.07;'
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
          insert spq;                                                                   
          spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
           sprList.add(spr); 
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , Service_Prep_Parent_Question__c =spq.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.04,Locale__c='US',active__c = true
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr);
           
       
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.09,Locale__c='US',active__c = true,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.04,1.07;',
                                            Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule');                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr);   
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , Service_Prep_Parent_Question__c =spq.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.041,Locale__c='US',active__c = true
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
       
                                             
        insert spq;
         spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
           sprList.add(spr);
        
           
        // upsert spQList;
          
    
         insert sprList;
         
         /* meta data setup **/
       //  (List<PPW_SPthreeOrMore__mdt>) JSON.deserialize( '[{"Custom_Field__c":"1"}]', List<Custom_Metadata__mdt>.class )
    }
    
     @isTest static void projectCreationTest() {
     
    
     test.startTest();
     loadTestData();
     String services = '';
     test.stopTest();
     database.executeBatch(new PPW_NotificationWindowBatch());
     
     List<String> prIds = new List<String>();
     for(project__c p : [Select id from project__c])
         prIds.add(p.id);
     // project__c pr = [Select id from project__c limit 1];
      
      
     database.executeBatch(new PPW_NotificationWindowBatch(prIds));
     }

}