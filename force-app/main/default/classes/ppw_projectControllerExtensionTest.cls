@isTest
private class ppw_projectControllerExtensionTest {
    
    public static List<service_prep__c> sp = new List<service_prep__c>();
    public static project__c p = new project__c();
    public static Project_Services__c ps = new Project_Services__c();
    public static rate__c rateRecord = new rate__c();
    public static confirmation__c cnew = new confirmation__c();
    public static title__C t = new title__C();
    
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
        
        t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital',Marty_Title_ID__c = '123');
        insert t;
        
         Asin__c asin1 = new Asin__c(title__c = t.id, Initial_Page_Count__c= 10, Name = 'Paperback');
        insert asin1;
        try {
         p =  [select id from project__c limit 1];
         
        } catch(exception e) {
            p = new project__c(title__c = t.id);
            insert p;
        } 
     
        Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
        insert s;
        Service__c s1 = new Service__c(name='Promo Text Creation',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
        insert s1;   
       //p =  [select id from project__c limit 1];
        
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK');
        insert v;        
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0,
                                active_rate__c=true);
        r.Minimum_Fee__c=20000;
        insert r;
        rateRecord = r;
     
        List<Project_Services__c> psList = new List<Project_Services__c>();
        Project_Services__c ps = new Project_Services__c(Project__c = p.id,Service__c =s.id,vendor__c= v.id,Estimated_Start_Date__c = date.today(),
                                                         Estimated_Completion_Date__c = date.today(),Actual_Start_Date__c=date.today(),Actual_Completion_Date__c= date.today()
                                                             );
        psList.add(ps);
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,vendor__c= v.id);
        psList.add(ps);
                
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Completed',vendor__c= v.id);
        psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Cancelled',vendor__c= v.id);
        psList.add(ps);
       
        
        //Killed
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'In Planning',vendor__c= v.id);
          psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Killed',vendor__c= v.id);
        psList.add(ps);
        
        
        insert psList;
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=psList[0].id,status__c ='Confirmed',
                                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0,Confirmed_Base_Amount_With_Currency__c = 'USD',
                                                  Confirmed_Rate_Amount__c = '123',Confirmed_MBO_Fee__c=123,Confirmed_Total_Rate_Amount__c='123' );
        insert con;
        cnew = con;
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=psList[0].id,
                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0,Confirmed_Base_Amount_With_Currency__c = 'USD',
                                                  Confirmed_Rate_Amount__c = '123',Confirmed_MBO_Fee__c=123,Confirmed_Total_Rate_Amount__c='123' );
        insert con; 
     
        
        List<Service_Prep_Response__c> sprList = new List<Service_Prep_Response__c>();
        Service_Prep_Response__c spr = new Service_Prep_Response__c();
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
        
      //  sp  = [Select id from Service_Prep__c];
        
         sp = [Select id from Service_Prep__c ];
         if(sp.isEmpty()) {
             
                 sp.add(new Service_Prep__c(project__c = p.id));
         
             insert sp;
         }
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.08,
                                           Locale__c='US',
                                           Option_Values__c='Yes;No',  active__c = true,
                                           Sub_Question_Render_Type__c = 'Render Sub Question', 
                                           Sub_Question_Render__c = 'Yes=1.01,1.15,1.02;',
                                           transmittal_mapping__c = true,Transmittal_Label__c='copy edit'
                                          );                                                                                                                                                                          
        insert spq; 
        
        
        
        
        spr = new Service_Prep_Response__c(Service_Prep__c = sp[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr); 
        insert sprList;
     
    }
    
    
   @isTest static void projectCreationTest() {
        
        testdataSetup();
        
        
        //project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, Project__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c
                                FROM Project_Services__c 
                                limit 1]; 
        censhareConnectorServiceMock.getCaseById();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
      
      
    req.requestURI = '/services/apexrest/ProjectServices/';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    ps.Censhare_XML_update_type__c = 'Update';
    Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK');
        insert v; 
   // vendor__c v = [select id from vendor__c where id!=: ps.vendor__c limit 1];
    ps.vendor__c = v.Id;
    String bxml = new ppw_censhareConnector().censhareXMLBuilder(new List<Project_Services__c> {ps});
    system.debug('bxml&&'+bxml);
    req.requestBody = Blob.valueof(bxml);
    //req.requestBody = Blob.valueof('<xml></xml>');
    RestContext.request = req;
    RestContext.response= res;
      
              
        Test.startTest();
        censhareConnectorServiceMock.createps();
         //censhareConnectorServiceMock1.createKickOffServiceps();
        Test.stopTest();
        
                                
        ppw_pro.psRec = ps.id;
        
        map<string, list<project_services__c>> allProjectServicesListMap = ppw_pro.allProjectServicesListMap;
        String amountChangeRolesSet = ppw_pro.amountChangeRolesSet;
        String killServiceRolesSet = ppw_pro.killServiceRolesSet;
        // String killServiceRolesSet = ppw_pro.killServiceRolesSet;
        String activeSet = ppw_pro.activeSet;
        String completedSet = ppw_pro.completedSet;
        String cancelledSet = ppw_pro.cancelledSet;
        String cbid = ppw_pro.cbid;     
        String spid = ppw_pro.spid;     
        String csXMLBody = ppw_pro.csXMLBody;     
        map<id, set<id>> serviceDependencyMap = ppw_pro.serviceDependencyMap; 
        map<id,id> psServiceMap =  ppw_pro.psServiceMap; 
    
        map<string, rate__c> allRatesMap =  ppw_pro.allRatesMap;
       
        
        
        ppw_pro.changedServiceGroup();
        ppw_pro.changedServiceType();
        ppw_pro.changedVendor();
        ppw_pro.loadServiceGroupOptions();
       
        
        
    }
   
     @isTest static void projectCreationTest16() {
        
        testdataSetup();
        
        
        //project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, Project__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c
                                FROM Project_Services__c 
                                limit 1]; 
        censhareConnectorServiceMock.getCaseById();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
      
      
    req.requestURI = '/services/apexrest/ProjectServices/';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    ps.Censhare_XML_update_type__c = 'Update';
    Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK');
        insert v; 
   // vendor__c v = [select id from vendor__c where id!=: ps.vendor__c limit 1];
    ps.vendor__c = v.Id;
    String bxml = new ppw_censhareConnector().censhareXMLBuilder(new List<Project_Services__c> {ps});
    system.debug('bxml&&'+bxml);
    req.requestBody = Blob.valueof(bxml);
    //req.requestBody = Blob.valueof('<xml></xml>');
    RestContext.request = req;
    RestContext.response= res;
      
              
        Test.startTest();
        censhareConnectorServiceMock.createps();
         //censhareConnectorServiceMock1.createKickOffServiceps();
        Test.stopTest();
        
                                
        ppw_pro.psRec = ps.id;
        
        map<string, list<project_services__c>> allProjectServicesListMap = ppw_pro.allProjectServicesListMap;
        String amountChangeRolesSet = ppw_pro.amountChangeRolesSet;
        String killServiceRolesSet = ppw_pro.killServiceRolesSet;
        // String killServiceRolesSet = ppw_pro.killServiceRolesSet;
        String activeSet = ppw_pro.activeSet;
        String completedSet = ppw_pro.completedSet;
        String cancelledSet = ppw_pro.cancelledSet;
        String cbid = ppw_pro.cbid;     
        String spid = ppw_pro.spid;     
        String csXMLBody = ppw_pro.csXMLBody;     
        map<id, set<id>> serviceDependencyMap = ppw_pro.serviceDependencyMap; 
        map<id,id> psServiceMap =  ppw_pro.psServiceMap; 
    
        map<string, rate__c> allRatesMap =  ppw_pro.allRatesMap;
      
        
       
        ppw_pro.collapsTargetAll = 'Open All';
        ppw_pro.currentTabName = 'Active';
        ppw_pro.collapsAll(); 
        
        ppw_pro.collapsTargetAll = 'Open All';
        ppw_pro.currentTabName = 'Completed';
        ppw_pro.collapsAll();
        
        ppw_pro.collapsTargetAll = 'Open All';
        ppw_pro.currentTabName = 'Cancelled';
        ppw_pro.collapsAll();
        
        ppw_pro.collapsTargetAll = 'Close All';
        ppw_pro.currentTabName = 'Active';
        ppw_pro.collapsAll();
        
        ppw_pro.collapsTargetAll = 'Close All';
        ppw_pro.currentTabName = 'Completed';
        ppw_pro.collapsAll();
        
        ppw_pro.collapsTargetAll = 'Close All';
        ppw_pro.currentTabName = 'Cancelled';
        ppw_pro.collapsAll();
        
        ppw_projectControllerExtension.projectServiceWrapper psw = new ppw_projectControllerExtension.projectServiceWrapper();
        psw.confirmationCheck = false;
        psw.kickOffCheck = false;
        psw.cancelCheck = false;
        psw.ptfCheck = false;
        psw.completeCheck = false;
       
        
        
    }
    
    
  
    @isTest static void projectCreationTest1() {
        
        testdataSetup();
        
        //project__c p =  [select id from project__c limit 1];
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
     
        
        
        
        ppw_pro.changedServiceGroup();
        ppw_pro.changedServiceType();
        ppw_pro.changedVendor();
        ppw_pro.getAsinInitailPageCount();
        
      
        
    }
    
    @isTest static void projectCreationTest17() {
        
        testdataSetup();
        
        //project__c p =  [select id from project__c limit 1];
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
     
     
     
     
       // ppw_pro.createConfirmation();
        ppw_pro.promotionalTextService();
        ppw_pro.refreshPSPanel();
        ppw_pro.refreshEditServicePanel();
        list<string>  asg = ppw_pro.activeServiceGroups;
        map<string, list<ppw_projectControllerExtension.projectServiceWrapper>> spwra =  ppw_pro.psWrapperMap;
        map<id, confirmation__c> conMap = ppw_pro.activeConfirmationsMap;
        
    }
    
    
     @isTest static void projectCreationTest1_1() {
        
        testdataSetup();
        
        //project__c p =  [select id from project__c limit 1];
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
     
       ps.status__c = 'Confirming';
        update ps;
        ppw_pro.createConfirmation();
        
        
    }
    
    
    @isTest static void projectCreationTest2() {
        
        testdataSetup();
        
       // project__c p =  [select id from project__c limit 1];
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
     
       
        
        
        
        ppw_pro.openServiceActionModal();
        ppw_pro.serviceActionType = 'edit';
        ppw_pro.openServiceActionModal();
        
        ppw_pro.samResetValues();
        //rate__c rateRecord = [select id from rate__c limit 1];
        rateRecord.Rate_Multiplier__c = 'Custom Quote';
        ppw_pro.rateRecord = rateRecord;
        ppw_pro.rateAmount = '1000';
        ppw_pro.projectServiceHandler();
        
       
        
        
    }
    
      @isTest static void projectCreationTest19() {
        
        testdataSetup();
        
       // project__c p =  [select id from project__c limit 1];
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
        
         ppw_pro.samResetValues();
        //rate__c rateRecord = [select id from rate__c limit 1];
        rateRecord.Rate_Multiplier__c = 'Custom Quote';
        ppw_pro.rateRecord = rateRecord;
        ppw_pro.serviceActionType = 'create';
        ppw_pro.rateAmount = '@#';
        ppw_pro.projectServiceHandler();
        
        
    }
    
    
    
   @isTest static void projectCreationTest3() {
        
        testdataSetup();
        
       // project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        ppw_pro.projectID = p.id;
        ppw_pro.prodLocale = 'UK';
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1]; 
        ppw_pro.psRec = ps.id;
        
        map<string, list<project_services__c>> allProjectServicesListMap = ppw_pro.allProjectServicesListMap;
        String amountChangeRolesSet = ppw_pro.amountChangeRolesSet;
        String killServiceRolesSet = ppw_pro.killServiceRolesSet;
      
        
        
        
        
        ppw_pro.changedServiceGroup();
        ppw_pro.changedServiceType();
        ppw_pro.changedVendor();
        
       // ppw_pro.serviceActionType = 'create';
      //  ppw_pro.projectServiceHandler();
        
      
        
    } 
    
     @isTest static void projectCreationTest31() {
        
        testdataSetup();
        
        //project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        ppw_pro.projectID = p.id;
        ppw_pro.prodLocale = 'UK';
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1]; 
        ppw_pro.psRec = ps.id;
        
        map<string, list<project_services__c>> allProjectServicesListMap = ppw_pro.allProjectServicesListMap;
        String amountChangeRolesSet = ppw_pro.amountChangeRolesSet;
        String killServiceRolesSet = ppw_pro.killServiceRolesSet;
      
     
        ppw_pro.serviceActionType = 'create';
        ppw_pro.projectServiceHandler();
        
        ppw_pro.callCenshareAPI_create();  
        ppw_pro.kickOffService(); 
      
        
    } 
    
      @isTest static void projectCreationTest32() {
        
        testdataSetup();
        
       // project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        ppw_pro.projectID = p.id;
        ppw_pro.prodLocale = 'UK';
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1]; 
        ppw_pro.psRec = ps.id;
        
        map<string, list<project_services__c>> allProjectServicesListMap = ppw_pro.allProjectServicesListMap;
        String amountChangeRolesSet = ppw_pro.amountChangeRolesSet;
        String killServiceRolesSet = ppw_pro.killServiceRolesSet;
      
     
        ppw_pro.serviceActionType = 'create';
        ppw_pro.projectServiceHandler();
        
        ppw_pro.forceKickOffService(); 
        ppw_pro.completeService();
        ppw_pro.setCurrentTabName(); 
        
    } 
    
     @isTest static void projectCreationTest6() {
        
        testdataSetup();
        
        //project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        ppw_pro.projectID = p.id;
        ppw_pro.prodLocale = 'UK';
        
       Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1]; 
        ppw_pro.psRec = ps.id;
        
        map<string, list<project_services__c>> allProjectServicesListMap = ppw_pro.allProjectServicesListMap;
        String amountChangeRolesSet = ppw_pro.amountChangeRolesSet;
        String killServiceRolesSet = ppw_pro.killServiceRolesSet;
        // String killServiceRolesSet = ppw_pro.killServiceRolesSet;
        String activeSet = ppw_pro.activeSet;
        String completedSet = ppw_pro.completedSet;
        String cancelledSet = ppw_pro.cancelledSet;
        String cbid = ppw_pro.cbid;     
        String spid = ppw_pro.spid;     
        String csXMLBody = ppw_pro.csXMLBody;     
      
       
        
       
        
        ppw_pro.serviceActionType = 'create';
        ppw_pro.projectServiceHandler();
        
        ppw_pro.openCancelModal(); 
        ppw_pro.cancelService(); 
        ppw_pro.projectPageRefresh();
        ppw_pro.setRichText();
    } 
    
    
    
    @isTest static void projectCreationTest4() {
        test.StartTest();
        testdataSetup();
        
       // project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        ppw_pro.projectID = p.id;
        ppw_pro.prodLocale = 'US';
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1]; 
      
        ppw_pro.psRec = ps.id;
        
      
         
          
        
        ppw_pro.serviceActionType = 'create';
        ppw_pro.projectServiceHandler();
        
       
        
       
        test.StopTest();
    }
    
    @isTest static void projectCreationTest41() {
        test.StartTest();
        testdataSetup();
        
       // project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        ppw_pro.projectID = p.id;
        ppw_pro.prodLocale = 'US';
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1]; 
      
        ppw_pro.psRec = ps.id;
        
      
        
        
      
        ppw_pro.cancelSelection = '3'; 
        ppw_pro.cancelService();
        
       
        test.StopTest();
    }
    
      @isTest static void projectCreationTest44() {
        test.StartTest();
        testdataSetup();
        
       // project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        ppw_pro.projectID = p.id;
        ppw_pro.prodLocale = 'US';
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1]; 
      
        ppw_pro.psRec = ps.id;
        
      
        
        
      
        ppw_pro.cancelSelection = '2'; 
        ppw_pro.cancelService();
        
       
        test.StopTest();
    }
    
     @isTest static void projectCreationTest14() {
        test.StartTest();
        testdataSetup();
        
       // project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        ppw_pro.projectID = p.id;
        ppw_pro.prodLocale = 'US';
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1];
      
        ppw_pro.psRec = ps.id;
        
      
       
        
        ppw_pro.serviceActionType = 'create';
        ppw_pro.projectServiceHandler();
        
      
      
        
       
        test.StopTest();
    }
    
     @isTest static void projectCreationTest15() {
        test.StartTest();
        testdataSetup();
        
        //project__c p =  [select id from project__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        ppw_pro.projectID = p.id;
        ppw_pro.prodLocale = 'US';
        
       Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1];
      
        ppw_pro.psRec = ps.id;
        
      
      
        
        ppw_pro.cancelSelection = 'None';
        ppw_pro.cancelService(); 
        ppw_pro.cancelSelection = '1';
        ppw_pro.cancelService(); 
      
        
       
        test.StopTest();
    }
    
    
    
     @isTest static void projectCreationTest5() {
        test.StartTest();
        testdataSetup();
        
       // project__c p =  [select id from project__c limit 1];
        //title__C t = [SELECT id,Name FROM title__c limit 1];//(Status__c='TEST',Name='Digital');
        t.Name = 'Digital';
        update t;
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ppw_projectControllerExtension ppw_pro = new ppw_projectControllerExtension(sc);
        
        ppw_pro.projectID = p.id;
        ppw_pro.prodLocale = 'US';
        
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, 
                                Vendor__r.Name,status__c,Service_Type_Complexity__c
                                FROM Project_Services__c 
                                limit 1]; 
      
        ppw_pro.psRec = ps.id;
        
        map<string, list<project_services__c>> allProjectServicesListMap = ppw_pro.allProjectServicesListMap;
        String amountChangeRolesSet = ppw_pro.amountChangeRolesSet;
        String killServiceRolesSet = ppw_pro.killServiceRolesSet;
        
            
     
      
        
       
       // confirmation__c cnew = [select id from confirmation__c limit 1];
        
        ppw_pro.internalCloseID = cnew.id;
        ppw_pro.internalCloseConfirmation(); 
        ppw_pro.getCurrency('USD');
        ppw_pro.getCurrency('EUR');
        ppw_pro.getCurrency('GBP');
        ppw_pro.getCurrency('JPY');
        ppw_pro.getCurrency('');
        ppw_pro.digitPatternCheck('123');
        ppw_pro.digitPatternCheck('aab');
        ppw_pro.digitPatternCheck('');
        
        map<string, string> additionalRateStringMap = ppw_pro.additionalRateStringMap;
        map<string, boolean> additionalRateInputMap =  ppw_pro.additionalRateInputMap;
        
        List<Service_Dependency__c> sdList = new List<Service_Dependency__c>();
        sdList.add(new Service_Dependency__c(Dependent_Service__c=ps.service__c,Parent_Service__c=ps.service__c));
        sdList.add(new Service_Dependency__c(Dependent_Service__c=ps.service__c,Parent_Service__c=ps.service__c));
        insert sdList;
        map<id, set<id>> sIdsMap = ppw_pro.serviceDependencyMap;
        
        ps = new Project_Services__c();
        ps.Status__c = 'In Planning';
        ppw_projectControllerExtension.getPredevValue(ps);
        ps.Status__c = 'Confirming';
        ppw_projectControllerExtension.getPredevValue(ps);
        ps.Status__c = 'Scheduled';
        ppw_projectControllerExtension.getPredevValue(ps);
        ps.Status__c = 'Kicked Off';
        ppw_projectControllerExtension.getPredevValue(ps);
        ps.Status__c = 'Completed';
        ppw_projectControllerExtension.getPredevValue(ps);
        ps.Status__c = 'Cancelled';
        ppw_projectControllerExtension.getPredevValue(ps);
        ps.Status__c = '';
        ppw_projectControllerExtension.getPredevValue(ps);
        ps.Word_Count_Completed__c = 2;
        ps.Word_Count_Kicked_Off__c = 1;
        ppw_projectControllerExtension.getPredevValue(ps);
        
        //ppw_pro.getPredevValue();
        
        
        ppw_pro.incrementCounter();
        test.StopTest();
    }
    
     
   
    
    @isTest static void transimitterControllerTest() {
        
        testdataSetup();
      
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
        Project_Services__c ps =[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c, project__r.title__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
                                limit 1]; 
        
        PageReference pageRef = Page.PPW_Transmittal;
        Test.setCurrentPage(pageRef);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('ps',ps.id);
        ApexPages.currentPage().getParameters().put('titleId',ps.project__r.title__c);
        ApexPages.currentPage().getParameters().put('v',ps.Vendor__c);
        
        
        PPW_transmittalController  cs = new PPW_transmittalController(); 
        
        cs.psID = con.Project_Services__c;
        cs.openConfirmationCount = 0;
         cs.confirmedConfirmationCount = 0;
         cs.statusName = new  Map<String,set<string>>();
          cs.serviceNamesCheck = 'test';
           cs.openConfirmationCount = 0;
        cs.cId = con.id;
        cs.psToUpdate  = ps;
      
            cs.projectID = con.Project_Services__r.project__c;
        con = [Select id,Project_Services__c,Project_Services__r.project__c,Confirmed_Vendor__c 
               from Confirmation__c where project_services__r.project__c=:cs.projectID limit 1];
        
        cs.getConfirmationMap();
        cs.confirmChoice = 'accept';
        cs.processConfirmation();
      
       
        
    }
    
     @isTest static void transimitterControllerTest_1() {
        
        testdataSetup();
       
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c, project__r.title__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
                                limit 1]; 
        
        PageReference pageRef = Page.PPW_Transmittal;
        Test.setCurrentPage(pageRef);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('ps',ps.id);
        ApexPages.currentPage().getParameters().put('titleId',ps.project__r.title__c);
        ApexPages.currentPage().getParameters().put('v',ps.Vendor__c);
        
        
        PPW_transmittalController  cs = new PPW_transmittalController(); 
        
        cs.psID = con.Project_Services__c;
        cs.openConfirmationCount = 0;
         cs.confirmedConfirmationCount = 0;
         cs.statusName = new  Map<String,set<string>>();
          cs.serviceNamesCheck = 'test';
           cs.openConfirmationCount = 0;
        cs.cId = con.id;
        cs.psToUpdate  = ps;
            cs.projectID = con.Project_Services__r.project__c;
        con = [Select id,Project_Services__c,Project_Services__r.project__c,Confirmed_Vendor__c 
               from Confirmation__c where project_services__r.project__c=:cs.projectID limit 1];
        
        cs.getConfirmationMap();
    
        cs.confirmChoice = 'reject';
        cs.processConfirmation();
       
        
    }
   
   
     @isTest static void transimitterControllerTest2() {
       testdataSetup();
      
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
      Project_Services__c ps =[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,project__r.title__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
                                limit 1]; 
        
        PageReference pageRef = Page.PPW_Transmittal;
        Test.setCurrentPage(pageRef);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('ps',ps.id);
        ApexPages.currentPage().getParameters().put('titleId',ps.project__r.title__c);
        ApexPages.currentPage().getParameters().put('v',ps.Vendor__c);
     
          PPW_transmittalController  cs = new PPW_transmittalController();
          cs.getConfirmationMap();
           map<string, string> additionalRateStringMap = cs.additionalRateStringMap;
        map<string, boolean> additionalRateInputMap = cs.additionalRateInputMap;
        map<string, boolean> additionalRateInputMap_vendor = cs.additionalRateInputMap_vendor;
        //  map<string, boolean> additionalRateInputMap_vendor = cs.additionalRateInputMap_vendor;
          //cs.
     }
    
     @isTest static void transimitterControllerTest6() {
        
        testdataSetup();
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c limit 1];
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c, project__r.title__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c 
                                limit 1]; 
        
        PageReference pageRef = Page.PPW_Transmittal;
        Test.setCurrentPage(pageRef);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('ps',ps.id);
        ApexPages.currentPage().getParameters().put('titleId',ps.project__r.title__c);
        ApexPages.currentPage().getParameters().put('v',ps.Vendor__c);
        
        
        PPW_transmittalController  cs = new PPW_transmittalController(); 
        cs.renderPanel();
       // cs.sendEmailToNotifier(null,null,null,null,null,null);
       // cs.getNotifyUser(null);
      //  cs.sendEmail(null,null);
        cs.censhareError = 'test';
        cs.censhareServerUpdate(null);
        cs.censhareServerUpdate(new project_services__c());
        cs.psID = con.Project_Services__c;
        cs.cId = con.id;
        cs.psToUpdate  = ps;
       
            cs.projectID = con.Project_Services__r.project__c;
        con = [Select id,Project_Services__c,Project_Services__r.project__c,Confirmed_Vendor__c 
               from Confirmation__c where project_services__r.project__c=:cs.projectID limit 1];
      
        
        ASIN__c asin = [select id,title__c from ASIN__c where name= 'Paperback' limit 1];
       // cs.titleID  = asin.title__c;
        
        cs.confirmChoice = 'reject';
        cs.processConfirmation();
        
        cs.confirmChoice = 'review';
        cs.processConfirmation();
        cs.doinit();
         
    }
    
    
    @isTest static void transimitterControllerTest1() {
        
        testdataSetup();
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c ,Project_Services__r.project__r.title__c
                               from Confirmation__c limit 1];
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,project__r.title__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c 
                                limit 1];
        
        PageReference pageRef = Page.PPW_Transmittal;
        Test.setCurrentPage(pageRef);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('ps',ps.id);
        ApexPages.currentPage().getParameters().put('titleId',ps.project__r.title__c);
        ApexPages.currentPage().getParameters().put('v',ps.Vendor__c);
        
        
        PPW_transmittalController  cs = new PPW_transmittalController(); 
        
        cs.psID = con.Project_Services__c;
        cs.cId = con.id;
        cs.psToUpdate  = ps;
        //cs.titleID = con.Project_Services__r.project__r.title__c;
            cs.projectID = con.Project_Services__r.project__c;
       /* con = [Select id,Project_Services__c,Project_Services__r.project__c,Confirmed_Vendor__c ,
               Project_Services__r.project__r.title__c
               from Confirmation__c where project_services__r.project__c=:cs.projectID limit 1];
        System.debug(con);
        System.debug(con.Project_Services__r.project__c); */
        
        cs.getConfirmationMap();
       
        Map<String,List<ASIN__c>> asMap = new Map<String,List<ASIN__c>>();
        for(ASIN__c a: [select id,title__c from Asin__c]) 
            if(asMap.containskey(a.title__c))
                asMap.get(a.title__c).add(a);
            else
                asMap.put(a.title__c, new List<Asin__c>{a});    
        for(String s: asMap.keyset()) 
            if(asMap.get(s).size()>=2) {
                 cs.titleID  = asMap.get(s)[0].title__c;
                 
                 // cs.formatListsMap =  new map<string, list<ASIN__c>>();
            } 
            
         map<string, list<ASIN__c>> formatListsMap = cs.formatListsMap;       
        
       // map<string, list<ASIN__c>> formatListsMap = cs.formatListsMap;
        contact con12 =new contact(Lastname = 'test');
        insert con12;
        title_contact__c tc = new title_contact__c(role__c = 'Author',Legal_Name__c=con12.id,title__c=  cs.titleID);
        insert tc;
        
        String authorString= cs.authorString;
        contact con13 = new contact(Lastname = 'test');
        insert con13;
        tc = new title_contact__c(role__c = 'Author',Legal_Name__c=con13.id,title__c=  cs.titleID);
        insert tc;
        authorString= cs.authorString;
        
        String relatedTitles = cs.relatedTitles;
       // title__c currentTitle = cs.currentTitle;
        map<string, string> additionalRateStringMap = cs.additionalRateStringMap;
        map<string, boolean> additionalRateInputMap = cs.additionalRateInputMap;
        map<string, boolean> additionalRateInputMap_vendor = cs.additionalRateInputMap_vendor;
        
        
        system.debug(con.Project_Services__r.project__c);
       
        system.debug(sp);
      
         cs.projectID = con.Project_Services__r.project__c;
        cs.getDate(system.now());
        map<string, list<service_prep_response__c>> servicePrepListsMap = cs.servicePrepListsMap;
      
        servicePrepListsMap = cs.servicePrepListsMap;
        list<string> formatNameList = cs.formatNameList;
        map<id, project_services__c> allProjectServiceMap = cs.allProjectServiceMap;
        map<string, string> subCatMap = cs.subCatMap;
      
    }
    
    
     @isTest static void transimitterControllerTest3() {
        
        testdataSetup();
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c,
                               Project_Services__r.project__r.title__c from Confirmation__c limit 1];
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,project__r.title__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c 
                                limit 1];
        
        PageReference pageRef = Page.PPW_Transmittal;
        Test.setCurrentPage(pageRef);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('ps',ps.id);
        ApexPages.currentPage().getParameters().put('titleId',ps.project__r.title__c);
        ApexPages.currentPage().getParameters().put('v',ps.Vendor__c);
        
        
        PPW_transmittalController  cs = new PPW_transmittalController(); 
        
        cs.psID = con.Project_Services__c;
        cs.cId = con.id;
        cs.psToUpdate  = ps;
        cs.titleID = con.Project_Services__r.project__r.title__c;
            cs.projectID = con.Project_Services__r.project__c;
     
        
        cs.getConfirmationMap();
       
        Map<String,List<ASIN__c>> asMap = new Map<String,List<ASIN__c>>();
        for(ASIN__c a: [select id,title__c from Asin__c]) 
            if(asMap.containskey(a.title__c))
                asMap.get(a.title__c).add(a);
            else
                asMap.put(a.title__c, new List<Asin__c>{a});    
        for(String s: asMap.keyset()) 
            if(asMap.get(s).size()>=2) {
                 cs.titleID  = asMap.get(s)[0].title__c;
              
            } 
            
           map<string, list<ASIN__c>> formatListsMap = cs.formatListsMap;        
        
     
        
        String authorString= cs.authorString;
      
        authorString= cs.authorString;
        
        String relatedTitles = cs.relatedTitles;
        title__c currentTitle = cs.currentTitle;
        map<string, string> additionalRateStringMap = cs.additionalRateStringMap;
        map<string, boolean> additionalRateInputMap = cs.additionalRateInputMap;
        map<string, boolean> additionalRateInputMap_vendor = cs.additionalRateInputMap_vendor;
     
      //  cs.projectID = sp[1].project__c;
          cs.projectID = con.Project_Services__r.project__c;
        cs.getDate(system.now());
        map<string, list<service_prep_response__c>> servicePrepListsMap = cs.servicePrepListsMap;
      //  cs.projectID = sp[0].project__c;
        servicePrepListsMap = cs.servicePrepListsMap;
        list<string> formatNameList = cs.formatNameList;
        map<id, project_services__c> allProjectServiceMap = cs.allProjectServiceMap;
        map<string, string> subCatMap = cs.subCatMap;
        cs = new PPW_transmittalController(); 
    }
    
    
}