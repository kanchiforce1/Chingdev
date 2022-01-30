@isTest
private class ppw_handlerforCalculationTest {
    public static title__C t;
    public static project__c p;
    static Service__c s = new Service__c();
    static Vendor__c v= new Vendor__c();
    static Rate__c r = new Rate__c();
    static Project_Services__c ps = new Project_Services__c();
    static Confirmation__c con = new Confirmation__c();
    
    
    public static void setupdate(){
        
        
        Service__c s = new Service__c(name='Developmental Edit',Active__c = true,Service_Rate_Type__c = 'Developmental Edit');
        insert s;
        Service__c s1 = new Service__c(name='Developmental Edit',Active__c = true,Service_Rate_Type__c = 'Developmental Edit');
        insert s1;
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
        
        List<Service_Prep_Question__c> spq14 = [select id,Order__c from Service_Prep_Question__c];
        system.debug('__________'+spq14);
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.0865,Locale__c='US',
                                           Option_Values__c='Yes;No',  active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                           Sub_Question_Render__c = 'Yes=1.01,1.15;',Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');                                                                                                                                                                          
        insert spq;                                                                   
        
        
        /** design main question tet data **/ // create ps
        Service_Prep_Question__c spq3 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                                                     Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', Option_Values__c='Yes;No', Service_Prep_Parent_Question__c = spq.id,
                                                                     Order__c=1.15,Locale__c='US',active__c = true,Render_type__c = 'Create PS',Render_Response__c='Yes='+s.id,
                                                                     Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.01,1.05,1.10;',Notification_Service__c = 'Developmental Edit'
                                                                     ,Notification_Window__c='Start');
        insert spq3;
        
        
        /** sub question **/
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', Option_Values__c='Yes;No',
                                           Order__c=1.01,Locale__c='US',active__c = true, Service_Prep_Parent_Question__c = spq3.id,
                                           Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.03;',
                                           Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');
        insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.03,Locale__c='US',
                                           active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS', Render_Response__c='Yes='+s.id,
                                           Update_Render_Response__c='yes='+s.id+'->'+s1.id+';',Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');
        
        insert spq;                                                                   
        
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.031,Locale__c='US',
                                           active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS',
                                           Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');
        
        insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Checkbox',Order__c=1.0,Locale__c='US',active__c = true,
                                           Delete_Render_type__c = 'Delete PS', Delete_Render_Response__c ='yes='+s.id,Notification_Service__c = 'Developmental Edit',
                                           Notification_Window__c='Start');
        insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',Order__c=1.015,Locale__c='US',
                                           Option_Values__c='Yes;No',active__c = true ,Notification_Service__c = 'Developmental Edit',
                                           Notification_Window__c='Start');
        insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.012,Locale__c='US',active__c = true
                                           ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start' );
        insert spq;                                                                   
        
        /** Acquistion questions test data**/                                   
        Service_Prep_Question__c spq1 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , Service_Prep_Parent_Question__c =spq3.id,
                                                                     Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.10,Locale__c='US',
                                                                     Option_Values__c='Yes;No',active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                                                     Sub_Question_Render__c = 'Yes=1.06;',Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start' ); 
        
        
        
        insert spq1;                                                                   
        
        Service_Prep_Question__c spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq1.id, 
                                                                     Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.06,Locale__c='US',Option_Values__c='Yes;No',
                                                                     active__c = true ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');                                                                                                                                                                          
        insert spq2;
        
        
        spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.07,Locale__c='US',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.08,1.07;'
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');                                                                                                                                                                          
        insert spq2;
        
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq2.id, 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.083,Locale__c='US',Option_Values__c='Yes;No',
                                           active__c = true,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
        insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq2.id, 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.081,Locale__c='US',Option_Values__c='Yes;No',
                                           active__c = true,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
        insert spq;                                                                   
        
        
        
        /** Editorial questions test data**/                                   
        spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.014,Locale__c='US',
                                           active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.04,1.07;'
                                           ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
        insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , Service_Prep_Parent_Question__c =spq.id, 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.04,Locale__c='US',active__c = true
                                           ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
        
        
        insert spq;
        
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , Service_Prep_Parent_Question__c =spq1.id, 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.09,Locale__c='US',active__c = true,
                                           Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.04,1.07;',
                                           Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule');                                                                                                                                                                          
        
        
        insert spq;
        
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , Service_Prep_Parent_Question__c =spq.id, 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.043,Locale__c='US',active__c = true
                                           ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
        
        
        insert spq;
        
        
        
        
        t = new title__C(Status__c='Contracted1',Name='Test',
                         Pre_Dev_Edit_Word_Count__c=80000,Post_Dev_Edit_Word_Count__c=2
                         // Pre_Dev_Edit_Word_Count__c= 1000
                        );
        insert t;
        
        Update new title__C(id=t.id,Status__c= 'Pre Acquisition',Production_Locale__c = 'US');
        
        // insert new project__c(title__c = t.id);
         try {
         insert new project__c(title__c = t.id);
         } catch(Exception e){}
        p = [select id from project__c where title__C =: t.id];
        
        
        
        
    }
    
    
    public void service_VendorTestdata(){
        setupdate();
       
        
    }
    
    static testmethod void handlerforCalculationPerHour()
    {
        setupdate();
        //Per Hour
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
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                                         Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps; 
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        // ppw_handlerforCalculation.updateMBOValue();
        
        
    }
    
    @isTest static void handlerforCalculationPerHour2()
    {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Animating',
                                      Service_Rate_Type__c='Animating - Handdrawn');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                                         Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps; 
        Confirmation__c con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        
        
    }
    
    @isTest static void handlerforCalculationPerHour3()
    {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Animating',
                                      Service_Rate_Type__c='Animating - Handdrawn');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);
        insert r;                         
        Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                                 Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0);                        
        Insert r1;  
        
        Project_Services__c ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                                         Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps; 
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        
        
    }
    
    
    @isTest static void handlerforCalcPerHourSliding()
    {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Animating - Handdrawn'
                                      );
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
                                                         Service__c=s.id,Vendor__c=v.id,
                                                         Service_Type_Complexity__c='Light Developmental Edit',
                                                         Additional_Rate_Input__c = 3);
        Insert ps; 
        
        
        s = new Service__c(Name='Animating',
                           Service_Rate_Type__c='Animating - Handdrawn');
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
        
        Project_Services__c ps1 = new Project_Services__c(id= ps.id, rate__c = r1.id,
                                                          Service__c=s.id,Vendor__c=v.id);
        
        update ps1;  
        
        
        
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        
    }
    
    @isTest static void handlerforCalcPerHourSliding2() {
    
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Animating - Handdrawn');
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
        
        
        s = new Service__c(Name= 'Developmental Edit',
                           Service_Rate_Type__c='Animating - Handdrawn');
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
        
        //update ps1;  
        
        
        
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        ps1 = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps1.id];
        ppw_handlerforCalculation.updateMBOValue(ps1);
        //ppw_handlerforCalculation.slidingRateCalc(r1, ps1);
        ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
        phandler.ratecalc(new List<Project_Services__c> {ps1});
        ppw_handlerforCalculation.slidingRateCalc(r1, ps1);
        ppw_handlerforCalculation.rateFlatFeeCalc('r1', ps1);
        ppw_handlerforCalculation.rateCustomQuoteCalc('r1', ps1);
        ppw_handlerforCalculation.rateCalculation(r1, ps1);
       
        
        ps1.status__c = 'Confirming';
        ppw_handlerforCalculation.getPredevValue(ps1);
        ps1.status__c = 'Scheduled';
        ppw_handlerforCalculation.getPredevValue(ps1);
        ps1.status__c = 'Kicked Off';
        ppw_handlerforCalculation.getPredevValue(ps1);
        ps1.status__c = 'Completed';
        ppw_handlerforCalculation.getPredevValue(ps1);
         ps1.status__c = 'Cancelled';
        ppw_handlerforCalculation.getPredevValue(ps1);
         ps1.status__c = 'Completed';
        ppw_handlerforCalculation.getPredevValue(ps1);
        
    }
    
    
    
    
    @isTest static void handlerforCalcPerHourSliding1()
    {
        setupdate();
        //Per Hour
        Service__c s = new Service__c(Name='Developmental Edit',
                                      Service_Rate_Type__c='Animating - Handdrawn');
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
       //  ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r1, ps);
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        
    }
    
    
    @isTest static void handlerforCalculationFlatFee()
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
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps; 
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
         //ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);
        
    }
    
     @isTest static void handlerforCalculationCustomQuote()
    {
        setupdate();
        // Flat Fee
        s = new Service__c(Name='Copy Editing',
                           Service_Rate_Type__c='Copy Editing - standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='EUR',Rate_Multiplier__c='Custom Quote',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3,
                                     Custom_Quote_Amount__c = 90.00);
        Insert ps; 
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);
        
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                     
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;  
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
         //ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                     
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                      
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                       
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                      
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                      
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                       
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        Project_Services__c ps = [select id,Rush_Fee__c,Rate__r.Minimum_Fee__c,Rate__c,Rate__r.Rate_Amount__c,
                                  Additional_Rate_Input__c,Rate__r.Rate_Multiplier__c from Project_Services__c limit 1];
        
       // ppw_handlerforCalculation ph = new ppw_handlerforCalculation();
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                       
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        Project_Services__c ps = [select id,Rush_Fee__c,Rate__r.Minimum_Fee__c,Rate__c,Rate__r.Rate_Amount__c,
                                  Additional_Rate_Input__c,Rate__r.Rate_Multiplier__c from Project_Services__c limit 1];
        
       // ppw_handlerforCalculation ph = new ppw_handlerforCalculation();
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                      
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con;   
        
        
    }
    
    @isTest static void handlerforCalculation1PerHour()
    {
        setupdate();
        
        /** creating services,vendor,rate and project services records data **/
        //Per Hour
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps); 
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps); 
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                      
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                      
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                     
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                      
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
          ps = [Select id,Service__c,Vendor__c,rate__c,Rate_Amount__c,
                                            Project__r.Title__r.Pre_Dev_Edit_Word_Count__c,Service__r.Name,
                                            Service_Type_Complexity__c,
                                            Project__r.Title__r.ASIN_page_cal__c,Rate__r.Rate_Multiplier__c,
                                            Rate__r.Rate_Amount__c, Amount__c, Rate__r.Minimum_Fee__c,User_Input_Rate_Amount__c,
                                            Rush_Fee__c,Vendor__r.name,Additional_Rate_Input__c,Custom_Quote_Amount__c,
                                            Word_Count_Cancelled__c,Word_Count_Completed__c,Word_Count_Confirming__c,Word_Count_In_Planning__c,
                                            Word_Count_Kicked_Off__c,Word_Count_Killed__c,Word_Count_Scheduled__c,MBO_Fee__c,Status__c
                                            from Project_Services__c where id=:ps.id];
        // ppw_handlerforCalculation phandler = new ppw_handlerforCalculation();
         ppw_handlerforCalculation.rateCalculation(r, ps);                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
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
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
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
        update ps;
        ps.Status__c = 'Killed'; 
        ps.Service__c = s1.id; 
        update ps;
        
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;   
        
    }
    
    @isTest static void handlerforCalculation1PerMinute()
    { 
        setupdate();
        //Per Minute
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='GBP',Rate_Multiplier__c='Per Minute',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=20000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con;  
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;   
        
    }
    @isTest static void handlerforCalculation1PerMonth()
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
    
    @isTest static void handlerforCalculation1PerCharacter()
    { 
        setupdate();
        //Per Character
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Character',
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
    
    @isTest static void handlerforCalculationPerCharacter()
    { 
        setupdate();
        //Per Character
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Month',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=2000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;   
        
    }
    
    @isTest static void handlerforCalculation1PerRound()
    { 
        setupdate();
        //Per Round
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Round',
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
    
    @isTest static void handlerforCalculation1PerRound1()
    { 
        setupdate();
        //Per Round
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Round1',
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
    
    
    @isTest static void handlerforCalculationPerRound()
    { 
        setupdate();
        //Per Round
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Round',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=2000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps;                                                      
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id );
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;   
        
    }
    
    
    @isTest static void handlerforMinimumFeeChange()
    { 
        setupdate();
        //Per Round
        s = new Service__c(Name='Developmental Edit',
                           Service_Rate_Type__c='Developmental Edit - Standard');
        Insert s;                              
        v= new Vendor__c(Name='Brian Covalt dba Moving Colour, Inc.',Email__c='abce@gmail.com',
                         First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Round',
                        Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=2000);
        Insert r;                       
        ps = new Project_Services__c(Project__c=p.id,Rate__c=r.id,Rush_Fee__c=0,
                                     Service__c=s.id,Vendor__c=v.id,Additional_Rate_Input__c = 3);
        Insert ps; 
        Rate__c r1 = new Rate__c(id=r.id,Minimum_Fee__c=200);
        update r1; 
        
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=ps.id);
        
        insert con; 
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=ps.id);
        
        insert con;   
        
    }
    
    
    
    
}