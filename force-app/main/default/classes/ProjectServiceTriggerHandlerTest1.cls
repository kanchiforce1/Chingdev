@isTest
private class ProjectServiceTriggerHandlerTest1 {
    public static title__C t;
    public static project__c p;
    static Service__c s = new Service__c();
    static Vendor__c v= new Vendor__c();
    static Rate__c r = new Rate__c();
    static Project_Services__c ps = new Project_Services__c();
    static Confirmation__c con = new Confirmation__c();
    
    @testsetup
    public static void setupdate() {
        
     
        
        
        t = new title__C(Name='Test',Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),
                         Pre_Dev_Edit_Word_Count__c=80000,Post_Dev_Edit_Word_Count__c=2,Internal_Imprint__c='Lake Union,Thomas & Mercer'
                         // Pre_Dev_Edit_Word_Count__c= 1000
                        );
        insert t;
         Asin__c asin = new Asin__c(title__c = t.id);
        insert asin;
        
         Service_Prep_Question__c spq;
       
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Title Data' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.0865,Locale__c='US',
                                           Option_Values__c='Yes;No',  active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                           Sub_Question_Render__c = 'Yes=1.01,1.15;',Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');                                                                                                                                                                          
        insert spq;                                                                   
        
        project__c p;
        try {
            p = [SELECT id from project__c limit 1];
          } catch(exception e) {  
                p = new project__c(title__c = t.id);
                insert p;
        }
        
        
      Service_Prep__c sp; 
      try {  
      sp = [select id from Service_Prep__c limit 1];
      } catch(exception e) {
          sp = new Service_Prep__c(project__c = p.id);
          insert sp;
      
      }
      Service_Prep_Response__c spr = new Service_Prep_Response__c(Service_Prep__c = sp.id,Service_Prep_Question__c = spq.id,Response__c = 'Yes');
       insert spr;
        
        
        Creative_Brief__c cb = new Creative_Brief__c(title__c=t.id);
        insert cb;
        Update new title__C(id=t.id,Status__c='Pre Acquisition',Production_Locale__c = 'US');
        
       
       s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Animating - Handdrawn',Service_Grouping__c = 'Promotional Text');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',Chinook_Access__c = true);
        Insert v;
        
         Vendor__c v1 = new Vendor__c(Name='Adam Hall1',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v1;
        
        esp__c ep = new esp__c(vendor__c = v.id,title__c=t.id);
        insert ep;
        
         Account ac = new Account(name ='TEST'+v.id) ;
        insert ac;  
        contact cont =new contact(LastName='TSEt',Email='TEST'+v.id+'@gmail.com',vendor__c = v.id,accountid=ac.id);
        insert cont;
         profile pfile = [SELECT id FROM profile WHERE name = 'vendor partner community login user' LIMIT 1];
         User user = new User(alias = 'TESTzzxx', email=cont.Email,
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = pfile.id, country='United States',IsActive =true,
                             ContactId = cont.Id,
                             timezonesidkey='America/Los_Angeles', username=cont.Email+'@noemail.com');
       
        insert user;
     p = [select id from project__c limit 1];
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);                        
        Insert r1;  
        
         con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id,status__c='Open');
        
        insert con; 
       
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0, status__c = 'Confirming',
                                                         Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps; 
      
          con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
       
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;
        
        
        
    }
    
  
    
    @isTest static void handlerforCalculationPerHour2() {
        List<Project_Services__c> psUpdate = new List<Project_Services__c>();
       Vendor__c v1 = [SELECT id,Name FROM Vendor__c WHERE Name = 'Adam Hall1'];
      for(Project_Services__c ps : [SELECT id,status__c,vendor__c FROM Project_Services__c]) {
          ps.vendor__c = v1.id;
          ps.status__c = 'Completed';
          psUpdate.add(ps);
      }
      update psUpdate;
    
        
    }
    
    }