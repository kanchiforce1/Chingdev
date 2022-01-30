@isTest
private class ppw_projectControllerExtensionTest1 {
    
    private static void testdataSetup() {
        
        //VM_EU_Internal
        Group g1 = new Group(Name='group name', type='Queue',developerName='VM_EU_Internal');
           // insert g1;
            QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType='Case');
           // insert q1;
         Group g2 = new Group(Name='group name', type='Queue',developerName='VM_US_Internal');
           // insert g2;
            QueuesObject q2 = new QueueSObject(QueueID = g2.id, SobjectType='Case');
           // insert q2;
        
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital',Marty_Title_ID__c = '123');
        insert t;
        
        Asin__c asin1 = new Asin__c(title__c = t.id, Initial_Page_Count__c= 10, Name = 'Paperback');
        insert asin1;
      
        project__c p;
        
        try {
        p =  [select id from project__c limit 1];
        } catch(exception e) {
            p = new project__c(title__c=t.id);
            insert p;
        
        }
      
        Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
        insert s;
        Service__c s1 = new Service__c(name='Promo Text Creation',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
        insert s1;   
       // p =  [select id from project__c limit 1];
        
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK');
        insert v;        
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0,
                                active_rate__c=true);
        r.Minimum_Fee__c=20000;
        insert r;
        
       /* r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                        Rate_Amount__c = 1000,Service__c=s1.id,Vendor__c=v.id,Minimum_Fee__c=0,
                        active_rate__c=true);
        r.Minimum_Fee__c=20000;
        insert r; */
        
        
        
        
        
        List<Project_Services__c> psList = new List<Project_Services__c>();
        Project_Services__c ps = new Project_Services__c(Project__c = p.id,Service__c =s.id,vendor__c= v.id,Estimated_Start_Date__c = date.today(),
                                                         Estimated_Completion_Date__c = date.today(),Actual_Start_Date__c=date.today(),Actual_Completion_Date__c= date.today()
                                                             );
        psList.add(ps);
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,vendor__c= v.id, rate__c = r.id);
        psList.add(ps);
                
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Completed',vendor__c= v.id, rate__c = r.id);
        psList.add(ps);
    
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Cancelled',vendor__c= v.id, rate__c = r.id);
        psList.add(ps);
        
      //  ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Cancelled',vendor__c= v.id, rate__c = r.id);
       // psList.add(ps);
      //  ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Completed',vendor__c= v.id, rate__c = r.id);
       // psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'In Planning',vendor__c= v.id, rate__c = r.id);
        //  psList.add(ps);
        
        //Killed
       // ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'In Planning',vendor__c= v.id, rate__c = r.id);
        //   psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Killed',vendor__c= v.id, rate__c = r.id);
        psList.add(ps);
        
        
        insert psList;
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=psList[0].id,status__c ='Confirmed',
                                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0,Confirmed_Base_Amount_With_Currency__c = 'USD',
                                                  Confirmed_Rate_Amount__c = '123',Confirmed_MBO_Fee__c=123,Confirmed_Total_Rate_Amount__c='123' );
        insert con;
        
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=psList[0].id,
                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0,Confirmed_Base_Amount_With_Currency__c = 'USD',
                                                  Confirmed_Rate_Amount__c = '123',Confirmed_MBO_Fee__c=123,Confirmed_Total_Rate_Amount__c='123' );
        insert con; 
        
       /* List<ASIN__c> asList = new List<ASIN__c>();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c=t.id);
        asList.add(asin);
       
        asin = new ASIN__c(Name='Digital',Initial_Page_Count__c=2,Title__c=t.id);
        asList.add(asin);
        
         asin = new ASIN__c(Name='Hardcover',Initial_Page_Count__c=2,Title__c=t.id);
        asList.add(asin);
        
         asin = new ASIN__c(Name='Digital',Initial_Page_Count__c=2,Title__c=t.id);
        asList.add(asin);
        
        insert asList; */
        
        List<Service_Prep_Response__c> sprList = new List<Service_Prep_Response__c>();
        Service_Prep_Response__c spr = new Service_Prep_Response__c();
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
       // List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
        
         List<Service_Prep__c> spList = new List<Service_prep__c>();
     spList = [Select id from Service_Prep__c limit 1];
     if(spList.isEmpty()) 
       
             spList.add(new Service_Prep__c(project__c = p.id));
     
         
        
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.08,
                                           Locale__c='US',
                                           Option_Values__c='Yes;No',  active__c = true,
                                           Sub_Question_Render_Type__c = 'Render Sub Question', 
                                           Sub_Question_Render__c = 'Yes=1.01,1.15,1.02;',
                                           transmittal_mapping__c = true,Transmittal_Label__c='copy edit'
                                          );                                                                                                                                                                          
        insert spq; 
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr); 
        insert sprList;
          
    }
    
    @isTest static void projectCreationTest1() {
        
        testdataSetup();
        
       project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1];
        ppw_pro.psRec = ps.id;
        
        map<string, list<project_services__c>> allProjectServicesListMap = ppw_pro.allProjectServicesListMap;
        String amountChangeRolesSet = ppw_pro.amountChangeRolesSet;
        String killServiceRolesSet = ppw_pro.killServiceRolesSet;
     
        ppw_pro.testmet();
        
        for(Project_Services__c ps1 : [SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, Project__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c
                                FROM Project_Services__c 
                                ]) {
            ppw_pro.serviceTypeSelection = ps1.Service__c;
            ppw_pro.serviceVendorSelection = ps1.Vendor__c;
             
            ppw_pro.changedVendor();
            ppw_pro.openServiceActionModal();
            ppw_pro.getAsinInitailPageCount();
        }
          
    }
    
}