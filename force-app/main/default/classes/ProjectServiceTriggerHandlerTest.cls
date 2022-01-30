@isTest
private class ProjectServiceTriggerHandlerTest {
    public static title__C t;
    public static project__c p;
    static Service__c s = new Service__c();
    static Vendor__c v= new Vendor__c();
    static Rate__c r = new Rate__c();
    static Project_Services__c ps = new Project_Services__c();
    static Confirmation__c con = new Confirmation__c();
    
    
    public static void setupdate(){
        
        
        Service__c s = new Service__c(name='Promotional Text',Active__c = true, Service_Grouping__c = 'Promotional Text',Service_Rate_Type__c = 'Developmental Edit');
        insert s;
        Service__c s1 = new Service__c(name='Promotional Text',Active__c = true,Service_Grouping__c = 'Promotional Text',Service_Rate_Type__c = 'Developmental Edit');
        insert s1;
      
       
        
        
        
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
        
     
    
        
        Creative_Brief__c cb = new Creative_Brief__c(title__c=t.id);
        insert cb;
        Update new title__C(id=t.id,Status__c='Pre Acquisition',Production_Locale__c = 'US');
    
        
       // p = [select id from project__c where title__C =: t.id];
        project__c p1 = new Project__c(title__c = t.id);
        try {
        insert p1;
        } catch(Exception e) {
            PPW_StaticUtils.txThrowAuraException(e,'ProjectCreate','Duplicate Error','','','');
        }
        p = [select id from project__c where title__C =: t.id];
         Service_Prep__c sp; 
      try { 
          sp = [select id from Service_Prep__c limit 1];
      } catch(exception e) {
         sp = new Service_Prep__c(project__c = p1.id);
         insert sp;
      
      }
        Service_Prep_Response__c spr = new Service_Prep_Response__c(Service_Prep__c = sp.id,Service_Prep_Question__c = spq.id,Response__c = 'Yes');
       insert spr;
        
        
        
        
    }
     @testsetup
      public static void setupdate1(){
        
        
        Service__c s = new Service__c(name='Promo Text Creation',Active__c = true, Service_Grouping__c = 'Promotional Text',Service_Rate_Type__c = 'Developmental Edit');
        insert s;
        Service__c s1 = new Service__c(name='Promo Text Creation1',Active__c = true,Service_Grouping__c = 'Promotional Text',Service_Rate_Type__c = 'Developmental Edit');
        insert s1;
        
       title__c t1 = new title__C(Name='Test',Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),
                         Pre_Dev_Edit_Word_Count__c=80000,Post_Dev_Edit_Word_Count__c=2,Internal_Imprint__c='Lake Union,Thomas & Mercer'
                         // Pre_Dev_Edit_Word_Count__c= 1000
                        );
        insert t1;
         Asin__c asin = new Asin__c(title__c = t1.id);
        insert asin;
        
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
        try {
         p = [select id from project__c where title__C =: t1.id];
         } catch(exception e) {
             p = new project__c(title__c = t1.id);
             insert p;
         
         }
         
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',Chinook_Access__c = true);
        Insert v;
        
         Vendor__c v1 = new Vendor__c(Name='Adam Hall1',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v1;
       Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);                        
        Insert r1;  
    
       Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0, status__c = 'Confirming',
                                                         Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps; 
        
        Confirmation__c con1 = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id,status__c='Open');
        
        insert con1; 
        
        Project_Services__c ps1 = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0, status__c = 'In Planning',
                                                         Service__c=s1.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps1; 
        
    }
    
    
   public static testmethod void service_VendorTestdata() {
         List<Project_Services__c> psUpdate = new List<Project_Services__c>();
       Vendor__c v1 = [SELECT id,Name FROM Vendor__c WHERE Name = 'Adam Hall1'];
       service__c sn = [SELECT id FROM service__c WHERE name = 'Promo Text Creation' LIMIT 1];
      for(Project_Services__c ps : [SELECT id,status__c,vendor__c FROM Project_Services__c where vendor__r.name != 'Adam Hall1']) {
          ps.vendor__c = v1.id;
          ps.service__c = sn.id;
          ps.status__c = 'Completed';
          ps.Master_PT_Service__c = true;
          psUpdate.add(ps);
      }
      
     // User u = [SELECT id,contact.vendor__c FROM User WHERE contact.vendor__c != null];
      update psUpdate;
    
        
    }
    
     public static testmethod void service_VendorTestdata1() {
         List<Project_Services__c> psUpdate = new List<Project_Services__c>();
       Vendor__c v1 = [SELECT id,Name FROM Vendor__c WHERE Name = 'Adam Hall1'];
      for(Project_Services__c ps : [SELECT id,status__c,vendor__c FROM Project_Services__c where vendor__r.name != 'Adam Hall1']) {
          ps.vendor__c = v1.id;
          ps.status__c = 'Cancelled';
          psUpdate.add(ps);
      }
      
     // User u = [SELECT id,contact.vendor__c FROM User WHERE contact.vendor__c != null];
      update psUpdate;
    
        
    }
    
   static testmethod void handlerforCalculationPerHour() {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Animating - Handdrawn',Service_Grouping__c = 'Promotional Text');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',Chinook_Access__c = true);
        Insert v;
        
         Vendor__c v1 = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v1;
        
        esp__c ep = new esp__c(vendor__c = v.id, title__c = t.id);
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
        ps.vendor__c = v1.id;
        update ps;
        
          con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
       
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;
       
        
        
    }
    
    @isTest static void handlerforCalculationPerHour2() {
       setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Animating - Handdrawn');
        Insert s; 
        Service__c s1 = new Service__c(Name='Promo Text Creation',
                                      Service_Rate_Type__c='Animating - Handdrawn');
        Insert s1;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        
          Vendor__c v1 = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v1;
         Account ac = new Account(name ='TEST'+v.id) ;
        insert ac;  
        contact cont =new contact(LastName='TSEt',Email='TEST'+v.id+'@gmail.com',vendor__c = v.id,accountid=ac.id, ApubOps_Community_User__c = true);
        insert cont;
        
          profile pfile = [SELECT id FROM profile WHERE name = 'vendor partner community login user' LIMIT 1];
         User user = new User(alias = 'TESTzzxx', email=cont.Email,
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = pfile.id, country='United States',IsActive =true,
                             ContactId = cont.Id,
                             timezonesidkey='America/Los_Angeles', username=cont.Email+'@noemail.com');
       
        insert user;
         
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id, vendor__c = v.id,service__c = s.id);
        Insert ps; 
        
        Project_Services__c ps1 = new Project_Services__c(Project__c=p.id, vendor__c = v.id,service__c = s1.id);
        Insert ps1;
        
        ps1.Master_PT_Service__c = true;
        ps1.Status__c = 'Completed';
        Update ps1;
         
        
        
        ps.Status__c = 'Completed';
        update ps;
        Confirmation__c con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        delete ps1;
      //  ProjectServiceTriggerHandler.deletePromotextServices(); 
        
        
    }
    
     @isTest static void handlerforCalculationPerHour21() {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Developmental Edit');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        
          Vendor__c v1 = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v1;
         Account ac = new Account(name ='TEST'+v.id) ;
        insert ac;  
        contact cont =new contact(LastName='TSEt',Email='TEST'+v.id+'@gmail.com',vendor__c = v.id,accountid=ac.id, ApubOps_Community_User__c = true);
        insert cont;
         
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id, vendor__c = v.id,service__c = s.id);
        Insert ps; 
        
        ps.Status__c = 'Cancelled';
        ps.Vendor__c  = v.id;
        update ps;
        Confirmation__c con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        
        
    }
    
      @isTest static void confirmingStatusChange() {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Developmental Edit');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        
          Vendor__c v1 = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v1;
         Account ac = new Account(name ='TEST'+v.id) ;
        insert ac;  
        contact cont =new contact(LastName='TSEt',Email='TEST'+v.id+'@gmail.com',vendor__c = v.id,accountid=ac.id, ApubOps_Community_User__c = true);
        insert cont;
         
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id, vendor__C = v.id, service__c = s.id);
        Insert ps; 
       // [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: newPsShareVendorIds AND isActive = true]
        ps.Status__c = 'confirming';
        ps.Vendor__c  = v.id;
        update ps;
        Confirmation__c con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        
        
    }
    
    
    @isTest static void handlerforCalculationPerHour3()
    {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Animating - Handdrawn');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        
           Vendor__c v1 = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v1;
        
          Account ac = new Account(name ='TEST'+v.id) ;
        insert ac;  
        contact cont =new contact(LastName='TSEt',Email='TEST'+v.id+'@gmail.com',vendor__c = v1.id,accountid=ac.id,ApubOps_Community_User__c = true);
        insert cont;
       // User u = [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND isActive = true]; 
       // system.debug('uVendor'+ u);
       
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,vendor__c = v.id,service__c=s.id);
        Insert ps; 
         ps.vendor__c = v1.id;
        update ps;
        
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        
        
    }
    
    
  
    
   
    @isTest static void handlerforCalcPerHourSliding()
    {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Developmental Edit');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Caitlin Alexander',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        Rate__c r = new Rate__c(Rate_Currency__c='GBP',Rate_Multiplier__c='Flat Fee',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Flat Fee',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,User_Input_Rate_Amount__c = 90,
                                                         Service__c=s.id,Vendor__c=v.id,Service_Type_Complexity__c='Light Developmental Edit',Additional_Rate_Input__c = 3);
        Insert ps; 
        
        
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        insert r;                         
        r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                         Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);                        
        Insert r1;  
        
        
         Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;
        Project_Services__c ps1 = new Project_Services__c(id= ps.id,
                                                          Service__c=s.id,Vendor__c=v.id,Rush_Fee__c = 900);
        
        ps1.status__c = 'Confirming';
        update ps1;  
        
        
        
        
        
    }
    
    @isTest static void handlerforCalcPerHourSliding2()
    {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Caitlin Alexander',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        Rate__c r = new Rate__c(Rate_Currency__c='GBP',Rate_Multiplier__c='Flat Fee',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Flat Fee',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                                         Service__c=s.id,Vendor__c=v.id,Service_Type_Complexity__c='Light Developmental Edit',Additional_Rate_Input__c = 3);
        Insert ps; 
        
        
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        insert r;                         
        r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                         Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);                        
        Insert r1;  
        
        Project_Services__c ps1 = new Project_Services__c(id= ps.id,
                                                          Service__c=s.id,Vendor__c=null);
        
       // update ps1;  
        
        
        
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        
    }
    
    
    
    
    @isTest static void handlerforCalcPerHourSliding1()
    {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Caitlin Alexander',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        Rate__c r = new Rate__c(Rate_Currency__c='GBP',Rate_Multiplier__c='Flat Fee',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Flat Fee',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                                         Service__c=s.id,Vendor__c=v.id,Service_Type_Complexity__c='Light Developmental Edit',
                                                         Additional_Rate_Input__c = 3);
        Insert ps; 
        
        
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        
    }
    
    
    @isTest static void handlerforCalculationFlatFee()
    {
        setupdate();
        // Flat Fee
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='EUR',Rate_Multiplier__c='Flat Fee',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps; 
        
    }
    @isTest static void handlerforCalculationPerImage()
    {
        setupdate();
        //Per Image
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Image',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;  
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id );
        
        insert con;
        
    }
    @isTest static void handlerforCalculationPerImage2()
    { 
        
        setupdate();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c=t.id);// from ASIN__c where title__c =: titleIds])
        insert asin;
        
        asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=3,Title__c=t.id);// from ASIN__c where title__c =: titleIds])
        insert asin;
        
        //Per Image
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='JPY',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con;                                                       
        
    }
    @isTest static void handlerforCalculationPerWord()
    {   
        setupdate();
        //Per Word
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='',Rate_Multiplier__c='Per Word',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
    }
    @isTest static void handlerforCalculationPerChapter()
    {    
        setupdate();
        //Per Chapter
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Chapter',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
    }
    
    
    @isTest static void handlerforCalculationPerIssue()
    { 
        setupdate();
        //Per Issue
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Issue',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
    }
    @isTest static void handlerforCalculationPerImage3()
    { 
        setupdate();
        //Per Image
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Image',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
    }
    @isTest static void handlerforCalculationPerIssue1()
    { 
        setupdate();
        //Per Issue
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Issue',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;                           
    }
    @isTest static void handlerforCalculationPerWord1()
    {  
        setupdate();
        //Per Word
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Word',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=200000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        Project_Services__c ps = [select id,Rush_Fee__c,Rate__r.Minimum_Fee__c,Rate__c,Rate__r.Rate_Amount__c,
                                  Additional_Rate_Input__c,Rate__r.Rate_Multiplier__c from Project_Services__c limit 1];
        
       //// ppw_handlerforCalculation ph = new ppw_handlerforCalculation();
        ppw_handlerforCalculation.ratecalculationFinal(r,ps);
        
    }
    @isTest static void handlerforCalculationPerPage()
    {  
        setupdate();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c=t.id);// from ASIN__c where title__c =: titleIds])
        insert asin;
        
        //Per Page
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        Project_Services__c ps = [select id,Rush_Fee__c,Rate__r.Minimum_Fee__c,Rate__c,Rate__r.Rate_Amount__c,
                                  Additional_Rate_Input__c,Rate__r.Rate_Multiplier__c from Project_Services__c limit 1];
        
        //ppw_handlerforCalculation ph = new ppw_handlerforCalculation();
        ppw_handlerforCalculation.ratecalculationFinal(r,ps);  
    }
    @isTest static void handlerforCalculationPerMinute()
    {
        setupdate();
        
        //Per Minute
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Minute',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id );
        
        insert con;   
        
    }
    @isTest static void handlerforCalculationPerChapter1()
    {   
        setupdate();
        //Per Month
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Month',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id );
        
        insert con;   
        
        
    }
    
    @isTest static void handlerforCalculation1PerHour()
    {
        setupdate();
        
        
        Service__c s = new Service__c(Name='Animating',
                                      Service_Rate_Type__c='Animating - Handdrawn');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        insert r;                        
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);                        
        Insert r1;  
        r.Minimum_Fee__c=20000;
        update r;                      
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                                         Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps; 
        Confirmation__c con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        ps.Rate__c=r1.id;
        update ps; 
    }
    @isTest static void handlerforCalculation1FlatFee()
    {
        setupdate();
        // Flat Fee
        s = new Service__c(Name='Copy Editing',
                           Service_Rate_Type__c='Copy Editing - standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='EUR',Rate_Multiplier__c='Flat Fee',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps; 
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
    }
    @isTest static void handlerforCalculation1PerImage()
    {
        setupdate();
        //Per Image
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Image',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
    }
    @isTest static void handlerforCalculation1PerPage4()
    {
        setupdate();
        
        //Per Page
        s = new Service__c(Name='Copyediting',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con;
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
    }
    @isTest static void handlerforCalculation1PerWord()
    {
        setupdate();
        //Per Word
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Word',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
    }
    @isTest static void handlerforCalculation1PerWord3()
    {
        setupdate();
        //Per Word
        s = new Service__c(Name='Animating',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Word',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
    }
    
    @isTest static void handlerforCalculation1PerChapter()
    {   
        setupdate();
        //Per Chapter
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Chapter',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id );
        
        insert con; 
    }
    @isTest static void handlerforCalculation1PerImage2()
    { 
        setupdate();
        //Per Image
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Image',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
    }
    @isTest static void handlerforCalculation1PerIssue()
    { 
        setupdate();
        //Per Issue
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Issue',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
    }
    
    @isTest static void handlerforCalculation1PerIssue1()
    {  
        setupdate();
        //Per Issue
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Issue',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con;                           
        
    }
    @isTest static void handlerforCalculation1PerWord1()
    {   
        setupdate();
        //Per Word
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Word',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con;   
        
    }
    @isTest static void handlerforCalculation1PerPage()
    {  
        setupdate();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c=t.id);// from ASIN__c where title__c =: titleIds])
        insert asin;
        
        //Per Page
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id );
        
        insert con;   
        
    }
    
    
    @isTest static void handlerforCalculation1PerPage5() {
        
        setupdate();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c=t.id);// from ASIN__c where title__c =: titleIds])
        insert asin;
        
        //Per Page
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s; 
        
        Service__c s1 = new Service__c(Name='Developmental Edit',
                                       Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s1;                                                           
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s1.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;  
        
        //Status__c
        
        ps.Status__c = 'Cancelled';  
        ps.Service__c = s1.id;
        update ps;
        ProjectServiceTriggerHandler.getPredevValue(ps);
        ps.Status__c = 'Confirming';
        ps.Service__c = s1.id;  
        update ps;
        ProjectServiceTriggerHandler.getPredevValue(ps);
        ps.Status__c = 'Completed';
        ps.Service__c = s1.id;  
        update ps;
        ProjectServiceTriggerHandler.getPredevValue(ps);
        ps.Status__c = 'Scheduled';
        ps.Service__c = s1.id;  
        update ps;
        ProjectServiceTriggerHandler.getPredevValue(ps);
        ps.Status__c = 'Kicked Off';
        ps.Service__c = s1.id;  
        update ps;
        ProjectServiceTriggerHandler.getPredevValue(ps);
        ps.Status__c = 'Killed'; 
        ps.Service__c = s1.id; 
        update ps;
        ProjectServiceTriggerHandler.getPredevValue(ps);
        
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;   
        
    }
    
    @isTest static void handlerforCalculation1PerPage51() {
        
        setupdate();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c=t.id);// from ASIN__c where title__c =: titleIds])
        insert asin;
        
        //Per Page
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s; 
        
        Service__c s1 = new Service__c(Name='Developmental Edit',
                                       Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s1;                                                           
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s1.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;  
        
        //Status__c
        
        ps.Status__c = 'Cancelled';  
        ps.Service__c = s1.id;
        update ps;
       
        ps.Status__c = 'Confirming';
        ps.Service__c = s1.id;  
        update ps;
        ps.Status__c = 'Completed';
        ps.Service__c = s1.id;  
        update ps;
        ps.Status__c = 'Scheduled';
        ps.Service__c = s1.id;  
        update ps;
        ps.Status__c = 'Kicked Off';
        ps.Service__c = s1.id;  
        ps.Vendor__c = null;
        update ps;
        ps.Status__c = 'Killed'; 
        ps.Service__c = s1.id; 
        update ps;
        
               
    } 
    
     @isTest static void handlerforCalculation1PerPage52() {
        
        setupdate();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c=t.id);// from ASIN__c where title__c =: titleIds])
        insert asin;
        
        //Per Page
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s; 
        
        Service__c s1 = new Service__c(Name='Developmental Edit',
                                       Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s1;                                                           
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;                       
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s1.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r;
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,Status__c = 'Scheduled',
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;  
        
        //Status__c
        
        ps.Status__c = 'Confirming';  
        ps.Service__c = s1.id;
        update ps;
                     
              
    }
    
      @isTest static void handlerforCalculation1PerPage53() {
        
        setupdate();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c=t.id);// from ASIN__c where title__c =: titleIds])
        insert asin;
        

        //Per Page
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s; 
        
        Service__c s1 = new Service__c(Name='Developmental Edit',
                                       Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s1;                                                           
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r1;                       
        rate__c r2 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                        Rate_Amount__c = 1000,Service__c=s1.id,Vendor__c=v.id,Minimum_Fee__c=0);
        Insert r2;
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r1.id,Rush_Fee__c=0,Status__c = 'Scheduled',
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3,User_Input_Rate_Amount__c = null);
        Insert ps; 
        Confirmation__c con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id,status__c = 'Open');
        
        insert con;  
        
        //Status__c
       
        ps.rate__c = r2.id;
        update ps;
                     
              
    }
    
  
    
}