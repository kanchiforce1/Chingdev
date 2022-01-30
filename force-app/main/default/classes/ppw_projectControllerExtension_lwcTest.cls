@isTest
private class ppw_projectControllerExtension_lwcTest {
    
    public static List<service_prep__c> sp = new List<service_prep__c>();
    public static project__c p = new project__c();
    public static Project_Services__c ps = new Project_Services__c();
    public static rate__c rateRecord = new rate__c();
    public static vendor__c v = new vendor__c();
    public static service__c ser = new service__c();
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
     
        Service__c s = new Service__c(name='Acquisition Service',Active__c = true,  Service_Rate_Type__c = 'Acquisition Service');
        insert s;
        Service__c s1 = new Service__c(name='Promo Text Creation',Active__c = true, Service_Rate_Type__c = 'Acquisition Service');
        insert s1;   
       
       //p =  [select id from project__c limit 1];
        
         v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com', vendor_status__c= 'Approved: Ok to Use', 
                          vendor_services_codes__c = 'Animating',
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK');
        insert v; 
         vendor__c v1= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com', vendor_status__c= 'Approved: Consult w VM', 
                          vendor_services_codes__c = 'Animating',
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK');
        insert v1;   
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0,
                                active_rate__c=true);
        r.Minimum_Fee__c=20000;
        insert r;
         Rate__c r1 = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Custom Quote',
                                Rate_Amount__c = 1000,Service__c=s1.id,Vendor__c=v1.id,Minimum_Fee__c=0,
                                active_rate__c=true);
        //r.Minimum_Fee__c=20000;
        insert r1;
        
        
        rateRecord = r;
     
        List<Project_Services__c> psList = new List<Project_Services__c>();
        Project_Services__c ps = new Project_Services__c(Project__c = p.id,Service__c =s.id,vendor__c= v.id,Estimated_Start_Date__c = date.today(),
                                                         Estimated_Completion_Date__c = date.today(),Actual_Start_Date__c=date.today(),Actual_Completion_Date__c= date.today()
                                                             );
        psList.add(ps);
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,vendor__c= v.id);
        psList.add(ps);
                
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Completed',vendor__c= v1.id);
        psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Cancelled',vendor__c= v.id);
        psList.add(ps);
       
         ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Scheduled',vendor__c= v.id);
        psList.add(ps);
        
        //Killed Scheduled
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id, Master_PT_Service__c = true, status__c = 'In Planning',vendor__c= v.id);
          psList.add(ps);
        
          ps = new Project_Services__c(Project__c = p.id,Service__c =s.id,  status__c = 'In Planning',vendor__c= v1.id);
          psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Killed',vendor__c= v.id);
        psList.add(ps);
        
        
        insert psList;
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=psList[0].id,status__c ='Confirmed',
                                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0,Confirmed_Base_Amount_With_Currency__c = 'USD',
                                                  Confirmed_Rate_Amount__c = '123',Confirmed_MBO_Fee__c=123,Confirmed_Total_Rate_Amount__c='123' );
        insert con;
        cnew = con;
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=psList[1].id,
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
    
    @isTest static void getvalues() {
        system.debug(ppw_projectControllerExtension_lwc.killServiceRolesSet);
       system.debug(ppw_projectControllerExtension_lwc.amountChangeRolesSet);
        ppw_projectControllerExtension_lwc.projectservicesResponse psr = new ppw_projectControllerExtension_lwc.projectservicesResponse();
       system.debug(psr.serviceActionType);
       system.debug(psr.prodLocale);
         system.debug(psr.currentTabPs);
         system.debug(psr.currentTabName);
         system.debug(psr.currentTabId);
         system.debug(psr.collapsTargetAll);
         system.debug(psr.openedPanelPs);
         system.debug(psr.confirmationTblHeaders);
         system.debug(psr.openConfirmation);
         system.debug(psr.createConfirmation);
         system.debug(psr.openedPanels);
         system.debug(psr.rateAmount);
         system.debug(psr.psAmount);
         system.debug(psr.textAreaTemp);
         system.debug(psr.tps);
         system.debug(psr.censhareConnectPsUpdate);
         system.debug(psr.cConnectPsUpdateStop);
         system.debug(psr.psInplanningCount);
         system.debug(psr.ops);
         system.debug(psr.thisProjectService);
         system.debug(psr.api_error);
         system.debug(psr.api_message);
         system.debug(psr.killServiceRolesSet);
         system.debug(psr.activeSet);
         system.debug(psr.completedSet);
         system.debug(psr.cbid);
         system.debug(psr.spid);
         system.debug(psr.serviceSelection);
         system.debug(psr.serviceTypeSelection);
         system.debug(psr.serviceVendorselection);
        system.debug(psr.serviceDescription);
        system.debug(psr.externalVendorNote);
        system.debug(psr.externalVendorNoteLong);
        system.debug(psr.internalVendorNote);
        system.debug(psr.rushFee);
        system.debug(psr.vendorRecord);
        system.debug(psr.rateRecord);
        system.debug(psr.serviceRecord);
        system.debug(psr.vendorDisabled);
        system.debug(psr.estStartDate);
        system.debug(psr.vendorNoteRichText);
         system.debug(psr.estCompletedDate);
         system.debug(psr.accStartDate);
         system.debug(psr.accCompletedDate);
         system.debug(psr.honorDependencies);
          system.debug(psr.serviceGroupOptions);
          system.debug(psr.serviceTypeOptions);
          system.debug(psr.serviceVendorOptions);
          system.debug(psr.confirmationButtonCheck);
         system.debug(psr.confirmationTableCheck);
            system.debug(psr.rushFeeFlg);
            system.debug(psr.statusKeys);
      //  system.debug(psr.confirmationCheck);
      //  system.debug(psr.kickOffCheck);
      //  system.debug(psr.cancelCheck);
       // system.debug(psr.ptfCheck);
       //  system.debug(psr.completeCheck);
        // system.debug(psr.ptfCheck);
       //  system.debug(psr.ptfCheck);
       //  system.debug(psr.ptfCheck);
    }
    
 @isTest static void getCustomQuote() {
        
        testdataSetup();
  
         List<Project_Services__c> psl=[SELECT id, Name, Service__c, Vendor__c,Censhare_XML_update_type__c, vendor__r.Approved_Locale__c, Rate__r.Rate_Multiplier__c, Rate__c, Vendor_Notes__c,Has_Been_Kicked_Off__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, Project__c,Rush_Fee__c,Additional_Rate_Input__c,Estimated_Start_Date__c,Estimated_Completion_Date__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c,Vendor_Notes_RT__c,Internal_Service_Notes__c
                                                                 FROM Project_Services__c WHERE (status__c = 'Scheduled' OR status__c = 'In Planning') 
                                ]; 
      rate__c r = [SELECT id,Rate_Multiplier__c FROM rate__c WHERE Rate_Multiplier__c = 'Custom Quote'];
    ps.Censhare_XML_update_type__c = 'Update';
      Service__c s1 = [SELECT id FROM service__c WHERE id !=: ps.Service__c limit 1];
     List<ppw_projectControllerExtension_lwc.projectServiceUpdate> psul = new List<ppw_projectControllerExtension_lwc.projectServiceUpdate>();
     
     for(Project_Services__c ps: psl) {
     		ppw_projectControllerExtension_lwc.projectServiceUpdate psu = new ppw_projectControllerExtension_lwc.projectServiceUpdate();
            psu.projectID = ps.Project__c;
            psu.serviceTypeSelection = ps.Service__c ;
            psu.serviceVendorSelection = ps.Vendor__c;
            psu.rushFee = ps.Rush_Fee__c;
            psu.additionalRateInput = ps.Additional_Rate_Input__c;
            psu.externalVendorNote = ps.Vendor_Notes_RT__c;
            psu.internalVendorNote =  ps.Internal_Service_Notes__c;
            psu.honorDependencies = ps.Honor_Dependencies__c;
     		psu.serviceActionType = 'create';
     		psu.rateRecord= r;
     		psu.rateAmount = '1234.99';
     		//ps.Service__c = s1.Id;
     		ps.Custom_Quote_Amount__c = 123.90;
     		psu.thisProjectService = ps;
     		psul.add(psu);
     }
        
    String bxml = new ppw_censhareConnector().censhareXMLBuilder(psl);
    system.debug('bxml&&'+bxml);
   
      
              
        Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpCenshareResponse(bxml));
      // ppw_projectControllerExtension_lwc.getppw_censhareConnect_PSUpdate(p.Id);
        
         //censhareConnectorServiceMock1.createKickOffServiceps();
      //  Test.stopTest();
       for(ppw_projectControllerExtension_lwc.projectServiceUpdate psu: psul)
       		ppw_projectControllerExtension_lwc.projectServiceHandler(JSON.serialize(psu));
       Test.stopTest();
     for(ppw_projectControllerExtension_lwc.projectServiceUpdate psu: psul) {
         psu.serviceActionType = 'edit';
         ppw_projectControllerExtension_lwc.projectServiceHandler(JSON.serialize(psu));
     }
    
 }
    
    @isTest static void getProjectTest() {
        
        testdataSetup();
     ppw_projectControllerExtension_lwc.getProject(p.Id);
         Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, vendor__r.Approved_Locale__c, Rate__c, Vendor_Notes__c,Has_Been_Kicked_Off__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, Project__c,Rush_Fee__c,Additional_Rate_Input__c,Estimated_Start_Date__c,Estimated_Completion_Date__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c,Vendor_Notes_RT__c,Internal_Service_Notes__c
                                                                 FROM Project_Services__c 
                                limit 1]; 
      
    ps.Censhare_XML_update_type__c = 'Update';
      Service__c s1 = [SELECT id FROM service__c WHERE id !=: ps.Service__c limit 1];
     ppw_projectControllerExtension_lwc.projectServiceUpdate psu = new ppw_projectControllerExtension_lwc.projectServiceUpdate();
            psu.projectID = ps.Project__c;
            psu.serviceTypeSelection = ps.Service__c ;
            psu.serviceVendorSelection = ps.Vendor__c;
            psu.rushFee = ps.Rush_Fee__c;
            psu.additionalRateInput = ps.Additional_Rate_Input__c;
            psu.externalVendorNote = ps.Vendor_Notes_RT__c;
            psu.internalVendorNote =  ps.Internal_Service_Notes__c;
            psu.honorDependencies = ps.Honor_Dependencies__c;
     		psu.serviceActionType = 'create';
     		psu.rateAmount = '1234.99';
     		//ps.Service__c = s1.Id;
     		psu.thisProjectService = ps;
     		
        
    String bxml = new ppw_censhareConnector().censhareXMLBuilder(new List<Project_Services__c> {ps});
    system.debug('bxml&&'+bxml);
   
      
              
        Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpCenshareResponse(bxml));
       ppw_projectControllerExtension_lwc.getppw_censhareConnect_PSUpdate(p.Id);
        
         //censhareConnectorServiceMock1.createKickOffServiceps();
        Test.stopTest();
        vendor__c v1 = [SELECT Id FROM vendor__c WHERE id !=: ps.vendor__c];
     ppw_projectControllerExtension_lwc.getProject1(p.Id);
     ppw_projectControllerExtension_lwc.getVendorPSs(v1.id, ps.vendor__r.Approved_Locale__c, p.Id);
      ppw_projectControllerExtension_lwc.getVendorPSs(ps.Vendor__c, ps.vendor__r.Approved_Locale__c, p.Id);
     ppw_projectControllerExtension_lwc.getAllVendors(ps.vendor__r.Approved_Locale__c);
     ppw_projectControllerExtension_lwc.getTitleDetails(t.Marty_Title_ID__c);
      ppw_projectControllerExtension_lwc.getServices();
      ppw_projectControllerExtension_lwc.getAllTitles();
      ppw_projectControllerExtension_lwc.getServicetype('Acquisition Service');
        ppw_projectControllerExtension_lwc.loadRates('Animating', ps.service__c, ps.vendor__c, ps.vendor__r.Approved_Locale__c);
       ppw_projectControllerExtension_lwc.loadServiceVendorOptions('Animating',  ps.service__c, ps.vendor__r.Approved_Locale__c);
       ppw_projectControllerExtension_lwc.projectServiceHandler(JSON.serialize(psu));
      psu.serviceActionType = 'edit';
       ppw_projectControllerExtension_lwc.projectServiceHandler(JSON.serialize(psu));
            psu.projectID = ps.Project__c;
            psu.serviceTypeSelection = s1.Id ;
            psu.serviceVendorSelection = ps.Vendor__c;
            psu.rushFee = ps.Rush_Fee__c;
            psu.additionalRateInput = ps.Additional_Rate_Input__c;
            psu.externalVendorNote = ps.Vendor_Notes_RT__c;
            psu.internalVendorNote =  ps.Internal_Service_Notes__c;
            psu.honorDependencies = ps.Honor_Dependencies__c;
     		//psu.serviceActionType = 'create';
     		//ps.Service__c = s1.Id;
     		psu.thisProjectService = ps;
     		psu.rateAmount = '1234.99';
       psu.serviceActionType = 'edit';
       ppw_projectControllerExtension_lwc.projectServiceHandler(JSON.serialize(psu));
    
 }
    
    @isTest static void getProjectTest1() {
        
        testdataSetup();
        ppw_projectControllerExtension_lwc.getProject(p.Id);
        Project_Services__c ps=[SELECT id, Name, Service__c,Word_Count_Completed__c, Word_Count_Kicked_Off__c, Word_Count_Cancelled__c, Vendor__c, Word_Count_In_Planning__c, Word_Count_Scheduled__c, vendor__r.Approved_Locale__c, Rate__c, Vendor_Notes__c,Has_Been_Kicked_Off__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c,Service_Name__c, Project__c,Rush_Fee__c,Additional_Rate_Input__c,Estimated_Start_Date__c,Estimated_Completion_Date__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c,Vendor_Notes_RT__c,Internal_Service_Notes__c
                                FROM Project_Services__c 
                                limit 1]; 
        
        ps.Censhare_XML_update_type__c = 'Update';
        ppw_projectControllerExtension_lwc.projectServiceUpdate psu = new ppw_projectControllerExtension_lwc.projectServiceUpdate();
        psu.projectID = ps.Project__c;
        psu.serviceTypeSelection = ps.Service__c ;
        psu.serviceVendorSelection = ps.Vendor__c;
        psu.rushFee = ps.Rush_Fee__c;
        psu.additionalRateInput = ps.Additional_Rate_Input__c;
        psu.externalVendorNote = ps.Vendor_Notes_RT__c;
        psu.internalVendorNote =  ps.Internal_Service_Notes__c;
        psu.honorDependencies = ps.Honor_Dependencies__c;
        psu.serviceActionType = 'create';
        psu.thisProjectService = ps;
        
        String bxml = new ppw_censhareConnector().censhareXMLBuilder(new List<Project_Services__c> {ps});
        system.debug('bxml&&'+bxml);
        
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCenshareResponse(bxml));
        ppw_projectControllerExtension_lwc.censhareCalloutStatus(ps);
        
        
        
        ppw_projectControllerExtension_lwc.internalCloseConfirmation(ps, cnew.id);
        ppw_projectControllerExtension_lwc.censhareServerUpdate(ps);
        ppw_projectControllerExtension_lwc.censhareServerUpdate(null);
        
        
        ppw_projectControllerExtension_lwc.kickOffService(ps);
        ppw_projectControllerExtension_lwc.forceKickOffService(ps, 'force kick off');
        ppw_projectControllerExtension_lwc.getAllConfirmation(ps.Id);
        ps.Has_Been_Kicked_Off__c = false;
        ppw_projectControllerExtension_lwc.createConfirmation(ps, 'test');
         ps.Has_Been_Kicked_Off__c = true;
        ppw_projectControllerExtension_lwc.createConfirmation(ps, 'test');
        
        ps.Status__c = 'In Planning';
         ppw_projectControllerExtension_lwc.getPredevValue(ps);
        ps.Status__c = 'Scheduled';
         ppw_projectControllerExtension_lwc.getPredevValue(ps);
        ps.Status__c = 'Kicked Off';
         ppw_projectControllerExtension_lwc.getPredevValue(ps);
        ps.Status__c = 'Completed';
         ppw_projectControllerExtension_lwc.getPredevValue(ps);
          ps.Word_Count_Completed__c = 1200.00;
        ps.Word_Count_Kicked_Off__c = 100.00;
         ppw_projectControllerExtension_lwc.getPredevValue(ps);
        ps.Status__c = 'Cancelled';
         ppw_projectControllerExtension_lwc.getPredevValue(ps);
        ps.Status__c = '';
         ppw_projectControllerExtension_lwc.getPredevValue(ps);
      
        
        ppw_projectControllerExtension_lwc.getPredevValue(ps);
        ppw_projectControllerExtension_lwc.promotionalTextService(ps.id);
        Test.stopTest();
        
        
    }
  
       @isTest static void censhareBulkServerUpdateTest() {
        
        testdataSetup();
     ppw_projectControllerExtension_lwc.getProject(p.Id);
         Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, vendor__r.Approved_Locale__c, Rate__c, Vendor_Notes__c,Has_Been_Kicked_Off__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c,Service_Name__c, Project__c,Rush_Fee__c,Additional_Rate_Input__c,Estimated_Start_Date__c,Estimated_Completion_Date__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c,Vendor_Notes_RT__c,Internal_Service_Notes__c
                                                                 FROM Project_Services__c 
                                limit 1]; 
      
    ps.Censhare_XML_update_type__c = 'Update';
     ppw_projectControllerExtension_lwc.projectServiceUpdate psu = new ppw_projectControllerExtension_lwc.projectServiceUpdate();
            psu.projectID = ps.Project__c;
            psu.serviceTypeSelection = ps.Service__c ;
            psu.serviceVendorSelection = ps.Vendor__c;
            psu.rushFee = ps.Rush_Fee__c;
            psu.additionalRateInput = ps.Additional_Rate_Input__c;
            psu.externalVendorNote = ps.Vendor_Notes_RT__c;
            psu.internalVendorNote =  ps.Internal_Service_Notes__c;
            psu.honorDependencies = ps.Honor_Dependencies__c;
     		psu.serviceActionType = 'create';
     		psu.thisProjectService = ps;
        
    String bxml = new ppw_censhareConnector().censhareXMLBuilder(new List<Project_Services__c> {ps});
    system.debug('bxml&&'+bxml);
   
      
              
        Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpCenshareResponse(bxml));
      ppw_projectControllerExtension_lwc.censhareBulkServerUpdate(new List<Project_Services__c>{ps});
           
       }
    
      @isTest static void bulkKickOffServiceTest() {
        
        testdataSetup();
     ppw_projectControllerExtension_lwc.getProject(p.Id);
         Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, vendor__r.Approved_Locale__c, Rate__c, Vendor_Notes__c,Has_Been_Kicked_Off__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c,Service_Name__c, Project__c,Rush_Fee__c,Additional_Rate_Input__c,Estimated_Start_Date__c,Estimated_Completion_Date__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c,Vendor_Notes_RT__c,Internal_Service_Notes__c
                                                                 FROM Project_Services__c 
                                limit 1]; 
      
    ps.Censhare_XML_update_type__c = 'Update';
     ppw_projectControllerExtension_lwc.projectServiceUpdate psu = new ppw_projectControllerExtension_lwc.projectServiceUpdate();
            psu.projectID = ps.Project__c;
            psu.serviceTypeSelection = ps.Service__c ;
            psu.serviceVendorSelection = ps.Vendor__c;
            psu.rushFee = ps.Rush_Fee__c;
            psu.additionalRateInput = ps.Additional_Rate_Input__c;
            psu.externalVendorNote = ps.Vendor_Notes_RT__c;
            psu.internalVendorNote =  ps.Internal_Service_Notes__c;
            psu.honorDependencies = ps.Honor_Dependencies__c;
     		psu.serviceActionType = 'create';
     		psu.thisProjectService = ps;
        
    String bxml = new ppw_censhareConnector().censhareXMLBuilder(new List<Project_Services__c> {ps});
    system.debug('bxml&&'+bxml);
   
      
              
        Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpCenshareResponse(bxml));
      ppw_projectControllerExtension_lwc.bulkKickOffService(new List<Project_Services__c>{ps});
           
       }
      @isTest static void bulkVendorServiceTest() {
        
        testdataSetup();
     ppw_projectControllerExtension_lwc.getProject(p.Id);
         Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, vendor__r.Approved_Locale__c, Rate__c, Vendor_Notes__c,Has_Been_Kicked_Off__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c,Service_Name__c, Project__c,Rush_Fee__c,Additional_Rate_Input__c,Estimated_Start_Date__c,Estimated_Completion_Date__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c,Vendor_Notes_RT__c,Internal_Service_Notes__c
                                                                 FROM Project_Services__c 
                                limit 1]; 
      
    ps.Censhare_XML_update_type__c = 'Update';
     ppw_projectControllerExtension_lwc.projectServiceUpdate psu = new ppw_projectControllerExtension_lwc.projectServiceUpdate();
            psu.projectID = ps.Project__c;
            psu.serviceTypeSelection = ps.Service__c ;
            psu.serviceVendorSelection = ps.Vendor__c;
            psu.rushFee = ps.Rush_Fee__c;
            psu.additionalRateInput = ps.Additional_Rate_Input__c;
            psu.externalVendorNote = ps.Vendor_Notes_RT__c;
            psu.internalVendorNote =  ps.Internal_Service_Notes__c;
            psu.honorDependencies = ps.Honor_Dependencies__c;
     		psu.serviceActionType = 'create';
     		psu.thisProjectService = ps;
        
    String bxml = new ppw_censhareConnector().censhareXMLBuilder(new List<Project_Services__c> {ps});
    system.debug('bxml&&'+bxml);
   
      
              
        Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpCenshareResponse(bxml));
      ppw_projectControllerExtension_lwc.bulkVendorService(new List<Project_Services__c>{ps}, v.id);
           
       }
      @isTest static void getProjectTest2() {
        
        testdataSetup();
     ppw_projectControllerExtension_lwc.getProject(p.Id);
         Project_Services__c ps=[SELECT id, Name, Word_Count_Completed__c, Service__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c, Vendor__c, vendor__r.Approved_Locale__c, Rate__c, Amount__c,Rate_Amount__c,Rate_Currency__c,MBO_Fee__c,MBO_Fee_with_Currency__c,Total_Rate_Amount__c, Base_Amount_with_Currency__c, Base_Amount__c, Vendor_Notes__c,Has_Been_Kicked_Off__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c,Service_Name__c, Project__c,Rush_Fee__c,Additional_Rate_Input__c,Estimated_Start_Date__c,Estimated_Completion_Date__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c,Vendor_Notes_RT__c,Internal_Service_Notes__c
                                                                 FROM Project_Services__c 
                                limit 1]; 
      
    ps.Censhare_XML_update_type__c = 'Update';
     ppw_projectControllerExtension_lwc.projectServiceUpdate psu = new ppw_projectControllerExtension_lwc.projectServiceUpdate();
            psu.projectID = ps.Project__c;
            psu.serviceTypeSelection = ps.Service__c ;
            psu.serviceVendorSelection = ps.Vendor__c;
            psu.rushFee = ps.Rush_Fee__c;
            psu.additionalRateInput = ps.Additional_Rate_Input__c;
            psu.externalVendorNote = ps.Vendor_Notes_RT__c;
            psu.internalVendorNote =  ps.Internal_Service_Notes__c;
            psu.honorDependencies = ps.Honor_Dependencies__c;
     		psu.serviceActionType = 'create';
     		psu.thisProjectService = ps;
        
    String bxml = new ppw_censhareConnector().censhareXMLBuilder(new List<Project_Services__c> {ps});
    system.debug('bxml&&'+bxml);
             
        Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpCenshareResponse(bxml));
       ppw_projectControllerExtension_lwc.getppw_censhareConnect_PSUpdate(p.Id);
       
      ppw_projectControllerExtension_lwc.createBulkConfirmation(new List<Project_Services__c>{ps} );
      ppw_projectControllerExtension_lwc.cancelService(ps, '1'); 
           ppw_projectControllerExtension_lwc.cancelService(ps, '2'); 
           ppw_projectControllerExtension_lwc.cancelService(ps, '3'); 
     ppw_projectControllerExtension_lwc.getservices(ps.Project__c);
             Test.stopTest();
    
 }
    
       @isTest static void getProjectTest3() {
        
        testdataSetup();
     ppw_projectControllerExtension_lwc.getProject(p.Id);
         Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, vendor__r.Approved_Locale__c, Rate__c, Vendor_Notes__c,Has_Been_Kicked_Off__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c,Service_Name__c, Project__c,Rush_Fee__c,Additional_Rate_Input__c,Estimated_Start_Date__c,Estimated_Completion_Date__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,Honor_Dependencies__c,Vendor_Notes_RT__c,Internal_Service_Notes__c
                                                                 FROM Project_Services__c 
                                limit 1]; 
      
    ps.Censhare_XML_update_type__c = 'Update';
     ppw_projectControllerExtension_lwc.projectServiceUpdate psu = new ppw_projectControllerExtension_lwc.projectServiceUpdate();
            psu.projectID = ps.Project__c;
            psu.serviceTypeSelection = ps.Service__c ;
            psu.serviceVendorSelection = ps.Vendor__c;
            psu.rushFee = ps.Rush_Fee__c;
            psu.additionalRateInput = ps.Additional_Rate_Input__c;
            psu.externalVendorNote = ps.Vendor_Notes_RT__c;
            psu.internalVendorNote =  ps.Internal_Service_Notes__c;
            psu.honorDependencies = ps.Honor_Dependencies__c;
     		psu.serviceActionType = 'create';
     		psu.thisProjectService = ps;
        
    String bxml = new ppw_censhareConnector().censhareXMLBuilder(new List<Project_Services__c> {ps});
    system.debug('bxml&&'+bxml);
   
      
              
        Test.startTest();
       Test.setMock(HttpCalloutMock.class, new MockHttpCenshareResponse(bxml));
     
     ppw_projectControllerExtension_lwc.getterpsMegaMap(ps.Project__c);
             Test.stopTest();
     
     
 }

    
}