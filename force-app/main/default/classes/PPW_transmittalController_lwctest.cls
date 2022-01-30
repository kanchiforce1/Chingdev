@isTest
private class PPW_transmittalController_lwctest{
    
    
    private static void testdataSetup() {
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital',Marty_Title_ID__c = '123', Production_Manager__c = 'pika');
        insert t;
         
        contact cont = new contact(LastName = 'test');
        insert cont;
        List<title_contact__c> tcl = new List<title_contact__c>();
        title_contact__c tc = new title_contact__c(role__c = 'Author', Legal_Name__c = cont.id ,title__c = t.id);  
        tcl.add(tc);
        
        tc = new title_contact__c(role__c = 'Translator', Legal_Name__c = cont.id, title__c = t.id);  
        tcl.add(tc);
        insert tcl;
         
        Asin__c a3 = new Asin__c(title__c = t.id, Initial_Page_Count__c= 10, Name = 'Paperback');
        List<ASIN__c> asList1 = new List<ASIN__c>();
        asList1.add(a3);
        
        project__c p;
        try { 
        p =  [select id from project__c limit 1];
        
        } catch(exception e) {
            p = new project__c(title__c = t.id);
            insert p;    
        
        }
        Asin__c a1 = new Asin__c(title__c = t.id, Initial_Page_Count__c= 10, Name = 'Paperback');
        asList1.add(a1);
        insert asList1;
     
        Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service', Confirmation_Notifications__c = 'Acquiring_Editor__c;Production_Manager__c');
        insert s;
        Service__c s1 = new Service__c(name='Promo Text Creation',Active__c = true,Service_Rate_Type__c = 'Acquisition Service', Confirmation_Notifications__c = 'Production_Manager__c');
        insert s1;   
      
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK');
        insert v;        
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Word',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0,
                                active_rate__c=true);
        r.Minimum_Fee__c=20000;
        insert r;
      
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
     
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'In Planning',vendor__c= v.id);
        psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Killed',vendor__c= v.id);
        psList.add(ps);
        
        insert psList;
        List<Confirmation__c> conLst =  new List<Confirmation__c>();
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=psList[0].id,status__c ='Confirmed',
                                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0,Confirmed_Base_Amount_With_Currency__c = 'USD',
                                                  Confirmed_Rate_Amount__c = '123',Confirmed_MBO_Fee__c=123,Confirmed_Total_Rate_Amount__c='123' );
        conLst.add(con);
        //insert con;
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=psList[0].id,
                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0,Confirmed_Base_Amount_With_Currency__c = 'USD',
                                  Confirmed_Rate_Amount__c = '123',Confirmed_MBO_Fee__c=123,Confirmed_Total_Rate_Amount__c='123' );
        conLst.add(con);
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=psList[0].id,
                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0,Confirmed_Base_Amount_With_Currency__c = 'USD',
                                  Confirmed_Rate_Amount__c = '123',Confirmed_MBO_Fee__c=123,Confirmed_Total_Rate_Amount__c='123' );
        conLst.add(con);
        con = new Confirmation__c(Confirmation__c='No',Project_Services__c=psList[0].id,
                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0,Confirmed_Base_Amount_With_Currency__c = 'USD',
                                  Confirmed_Rate_Amount__c = '123',Confirmed_MBO_Fee__c=123,Confirmed_Total_Rate_Amount__c='123' );
        conLst.add(con);
        insert conLst; 
        
        List<Service_Prep_Response__c> sprList = new List<Service_Prep_Response__c>();
        Service_Prep_Response__c spr = new Service_Prep_Response__c();
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
       // List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
          List<Service_Prep__c> spList = new List<Service_prep__c>();
         spList = [Select id from Service_Prep__c limit 1];
         if(spList.isEmpty()) {
             
                 spList.add(new Service_Prep__c(project__c = p.id));
         
             insert spList;
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
         
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr);
        Service_Prep_Response__c spr1 = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr1); 
        insert sprList;
    }
    
     private static void testdataSetup1() {
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital',Marty_Title_ID__c = '123');
        insert t;
         
        contact cont = new contact(LastName = 'test');
        insert cont;
        List<title_contact__c> tcl = new List<title_contact__c>();
        title_contact__c tc = new title_contact__c(role__c = 'Author', Legal_Name__c = cont.id ,title__c = t.id);  
        tcl.add(tc);
       
        insert tcl;
        
    }
    
      private static void testdataSetup2() {
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital',Marty_Title_ID__c = '123');
        insert t;
         
        contact cont = new contact(LastName = 'test');
        insert cont;
        List<title_contact__c> tcl = new List<title_contact__c>();
        title_contact__c tc = new title_contact__c(role__c = 'Author', Legal_Name__c = cont.id ,title__c = t.id);  
        tcl.add(tc);
       
        insert tcl;
        
    }
    /*

@isTest static void transimitterControllerTest() {

testdataSetup();
List<confirmation__c> c = [
select id, name, project_services__r.project__c,Confirmed_Vendor__c,project_services__r.status__c
FROM confirmation__c]; 

system.debug('pavanTest'+c);
Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
limit 1];
ps.status__c = 'Kicked Off';
Update ps;

PPW_transmittalController_lwc.trasmittalWrpData trData = new PPW_transmittalController_lwc.trasmittalWrpData();

PPW_transmittalController_lwc cslwc = new PPW_transmittalController_lwc(); 



con = [Select id,Project_Services__c, Project_Services__r.project__c , Project_Services__r.project__r.title__r.Marty_Title_ID__c, Project_Services__r.project__r.title__c, project_services__r.vendor__c,Confirmed_Vendor__c 
from Confirmation__c where project_services__r.project__c=: ps.project__c AND project_services__c =: ps.id limit 1];


PPW_transmittalController_lwc.getTrasmittlaData(con.Project_Services__r.project__r.title__r.Marty_Title_ID__c , con.project_services__r.vendor__c);
PPW_transmittalController_lwc.picklistValues('Project_Services__c','Status__c', con.Project_Services__c);
PPW_transmittalController_lwc.titleID = con.Project_Services__r.project__r.title__c;
PPW_transmittalController_lwc.authorString();
PPW_transmittalController_lwc.getsubCatMap();


} 

@isTest static void transimitterControllerTest_1() {

testdataSetup();

Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
limit 1];
ps.status__c = 'Kicked Off';
Update ps;

PPW_transmittalController_lwc.trasmittalWrpData trData = new PPW_transmittalController_lwc.trasmittalWrpData();

PPW_transmittalController_lwc cslwc = new PPW_transmittalController_lwc(); 



con = [Select id,Project_Services__c, Project_Services__r.project__c , Project_Services__r.project__r.title__r.Marty_Title_ID__c, Project_Services__r.project__r.title__c, project_services__r.vendor__c,Confirmed_Vendor__c 
from Confirmation__c where project_services__r.project__c=: ps.project__c AND project_services__c =: ps.id limit 1];


contact cont = new contact(LastName = 'test');
insert cont;

List<title_contact__c> tcl = new List<title_contact__c>();

title_contact__c tc = new title_contact__c(role__c = 'Author', Legal_Name__c = cont.id ,title__c = con.Project_Services__r.project__r.title__c);  
tcl.add(tc);
/// insert tc; 

tc = new title_contact__c(role__c = 'Translator', Legal_Name__c = cont.id, title__c = con.Project_Services__r.project__r.title__c);  
tcl.add(tc);
insert tcl;


PPW_transmittalController_lwc.reqWrap rw = new PPW_transmittalController_lwc.reqWrap();
rw.psId = con.Project_Services__c;
rw.cId = con.id;
rw.confirmChoice = 'accept';
rw.additionalRateInput = '100';
rw.customQuote = '10';
rw.rejectionReason = 'test';
rw.reviewReason = 'test';
String ser = JSON.serialize(rw);

PPW_transmittalController_lwc.processConfirmation(ser);





}  */
    
     @isTest static void transimitterControllerTest4() {
         testdataSetup1();
     
     }
    
    @isTest static void transimitterControllerTest1() {
        test.starttest();
        testdataSetup();
        List<confirmation__c> c = [
            select id, name, project_services__r.project__c,Confirmed_Vendor__c,project_services__r.status__c
            FROM confirmation__c]; 
        
        system.debug('pavanTest'+c);
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
                                limit 1];
        
        
        PPW_transmittalController_lwc.trasmittalWrpData trData = new PPW_transmittalController_lwc.trasmittalWrpData();
         trData.projectID = ps.project__c;
        PPW_transmittalController_lwc cslwc = new PPW_transmittalController_lwc(); 
        PPW_transmittalController_lwc.tsmWrapData = trData;
        con = [Select id,Project_Services__c, Project_Services__r.project__c , Project_Services__r.project__r.title__r.Marty_Title_ID__c, Project_Services__r.project__r.title__c, project_services__r.vendor__c,Confirmed_Vendor__c 
               from Confirmation__c where project_services__r.project__c=: ps.project__c limit 1];
        
        List<ASIN__c> asList = new List<ASIN__c>();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin);
        
        ASIN__c asin1 = new ASIN__c(Name='Digital',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin1);
        insert asList;
        contact cont = new contact(LastName = 'test');
        insert cont;
        title_contact__c tc = new title_contact__c(role__c = 'Author', Legal_Name__c = cont.id , title__c = con.Project_Services__r.project__r.title__c);  
        insert tc; 
        
        tc = new title_contact__c(role__c = 'Translator',Legal_Name__c = cont.id , title__c = con.Project_Services__r.project__r.title__c);  
        insert tc;
        
       // PPW_transmittalController_lwc.getTrasmittlaData(con.Project_Services__r.project__r.title__r.Marty_Title_ID__c , con.project_services__r.vendor__c);
       // PPW_transmittalController_lwc.getTrasmittlaData(con.Project_Services__r.project__r.title__r.Marty_Title_ID__c , null);// nagetive
        PPW_transmittalController_lwc.picklistValues('Project_Services__c','Status__c', con.Project_Services__c);
        PPW_transmittalController_lwc.titleID = con.Project_Services__r.project__r.title__c;
        PPW_transmittalController_lwc.authorString();
        PPW_transmittalController_lwc.getTitleData(con.Project_Services__r.project__r.title__c);
        PPW_transmittalController_lwc.getsubCatMap();
        test.stopTest();
    }
    @isTest static void transimitterControllerTest1_1() {
        
        testdataSetup();
        List<confirmation__c> c = [
            select id, name, project_services__r.project__c,Confirmed_Vendor__c,project_services__r.status__c
            FROM confirmation__c]; 
        
        system.debug('pavanTest'+c);
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
                                limit 1];
        
        
        PPW_transmittalController_lwc.trasmittalWrpData trData = new PPW_transmittalController_lwc.trasmittalWrpData();
        trData.projectID = ps.project__c;
        PPW_transmittalController_lwc cslwc = new PPW_transmittalController_lwc(); 
        
        con = [Select id,Project_Services__c, Project_Services__r.project__c , Project_Services__r.project__r.title__r.Marty_Title_ID__c, Project_Services__r.project__r.title__c, project_services__r.vendor__c,Confirmed_Vendor__c 
               from Confirmation__c where project_services__r.project__c=: ps.project__c limit 1];
        
        List<ASIN__c> asList = new List<ASIN__c>();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin);
        
        ASIN__c asin1 = new ASIN__c(Name='Digital',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin1);
        insert asList;
        contact cont = new contact(LastName = 'test');
        insert cont;
        title_contact__c tc = new title_contact__c(role__c = 'Author', Legal_Name__c = cont.id , title__c = con.Project_Services__r.project__r.title__c);  
        insert tc; 
        
        tc = new title_contact__c(role__c = 'Translator',Legal_Name__c = cont.id , title__c = con.Project_Services__r.project__r.title__c);  
        insert tc;
        
        
        PPW_transmittalController_lwc.reqWrap rw = new PPW_transmittalController_lwc.reqWrap();
        
        rw = new PPW_transmittalController_lwc.reqWrap();
        rw.psId = con.Project_Services__c;
        rw.cId = con.id;
        rw.confirmChoice = 'reject';
        rw.additionalRateInput = '100';
        rw.customQuote = '10';
        rw.rejectionReason = 'test';
        rw.reviewReason = 'test';
        String ser = JSON.serialize(rw);
        
        PPW_transmittalController_lwc.processConfirmation(ser);
        
        
    }
    
    @isTest static void transimitterControllerTest2() {
        
        testdataSetup();
        List<confirmation__c> c = [
            select id, name, project_services__r.project__c,Confirmed_Vendor__c,project_services__r.status__c
            FROM confirmation__c]; 
        
        system.debug('pavanTest'+c);
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
                                limit 1];
        
        
        PPW_transmittalController_lwc.trasmittalWrpData trData = new PPW_transmittalController_lwc.trasmittalWrpData();
        
        PPW_transmittalController_lwc cslwc = new PPW_transmittalController_lwc(); 
        
        con = [Select id,Project_Services__c, Project_Services__r.project__c , Project_Services__r.project__r.title__r.Marty_Title_ID__c, Project_Services__r.project__r.title__c, project_services__r.vendor__c,Confirmed_Vendor__c 
               from Confirmation__c where project_services__r.project__c=: ps.project__c limit 1];
        
        List<ASIN__c> asList = new List<ASIN__c>();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin);
        
        ASIN__c asin1 = new ASIN__c(Name='Digital',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin1);
        insert asList;
        contact cont = new contact(LastName = 'test');
        insert cont;
        
        title_contact__c tc = new title_contact__c(role__c = 'Author', Legal_Name__c = cont.id, title__c = con.Project_Services__r.project__r.title__c);  
        insert tc; 
        
        tc = new title_contact__c(role__c = 'Translator', Legal_Name__c = cont.id, title__c = con.Project_Services__r.project__r.title__c);  
        insert tc;
        
      //  PPW_transmittalController_lwc.getTrasmittlaData(con.Project_Services__r.project__r.title__r.Marty_Title_ID__c , con.project_services__r.vendor__c);
        PPW_transmittalController_lwc.picklistValues('Project_Services__c','Status__c', con.Project_Services__c);
        PPW_transmittalController_lwc.titleID = con.Project_Services__r.project__r.title__c;
        PPW_transmittalController_lwc.authorString();
        
        
        
    }
    
      @isTest static void authorStringTest2() {
        
      
        PPW_transmittalController_lwc.tsmWrapData = null;
        PPW_transmittalController_lwc.additionalRateStringMap();
        
        
        
        PPW_transmittalController_lwc cslwc = new PPW_transmittalController_lwc(); 
        PPW_transmittalController_lwc.trasmittalWrpData twrpData = new PPW_transmittalController_lwc.trasmittalWrpData();
       // twrpData.tsmWrapData.
        
        
        // = new PPW_transmittalController_lwc.trasmittalWrpData();
        twrpData.openConfirmationCount = 0;
        twrpData.confirmedConfirmationCount = 0;
        twrpData.statusName = new Map<String,set<string>>();
        twrpData.serviceNamesCheck = '';
        twrpData.confirmationListsize = false;
       twrpData.projectService = new title__c();
       twrpData.rejectionReason = '';
       twrpData.reviewReason = ''; 
       twrpData.rejectionReasonInput = '';
       twrpData.customQuote = '';
       twrpData.additionalRateInputCheck = false;
    }
    
    @isTest static void transimitterControllerTest2_1() {
        
        testdataSetup();
        List<confirmation__c> c = [
            select id, name, project_services__r.project__c,Confirmed_Vendor__c,project_services__r.status__c
            FROM confirmation__c]; 
        
        system.debug('pavanTest'+c);
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
                                limit 1];
        
        
        PPW_transmittalController_lwc.trasmittalWrpData trData = new PPW_transmittalController_lwc.trasmittalWrpData();
        
        PPW_transmittalController_lwc cslwc = new PPW_transmittalController_lwc(); 
        
        con = [Select id,Project_Services__c, Project_Services__r.project__c , Project_Services__r.project__r.title__r.Marty_Title_ID__c, Project_Services__r.project__r.title__c, project_services__r.vendor__c,Confirmed_Vendor__c 
               from Confirmation__c where project_services__r.project__c=: ps.project__c limit 1];
        
        List<ASIN__c> asList = new List<ASIN__c>();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin);
        
        ASIN__c asin1 = new ASIN__c(Name='Digital',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin1);
        insert asList;
        contact cont = new contact(LastName = 'test');
        insert cont;
        
        title_contact__c tc = new title_contact__c(role__c = 'Author', Legal_Name__c = cont.id, title__c = con.Project_Services__r.project__r.title__c);  
        insert tc; 
        
        tc = new title_contact__c(role__c = 'Translator', Legal_Name__c = cont.id, title__c = con.Project_Services__r.project__r.title__c);  
        insert tc;
        
        PPW_transmittalController_lwc.reqWrap rw = new PPW_transmittalController_lwc.reqWrap();
        rw.psId = con.Project_Services__c;
        
        
        rw = new PPW_transmittalController_lwc.reqWrap();
        rw.psId = con.Project_Services__c;
        rw.cId = con.id;
        rw.confirmChoice = 'review';
        rw.additionalRateInput = '100';
        rw.customQuote = '10';
        rw.rejectionReason = 'test';
        rw.reviewReason = 'test';
        String ser = JSON.serialize(rw);
        
        PPW_transmittalController_lwc.processConfirmation(ser);
        
        
        
    }
    @isTest static void transimitterControllerTest3() {
        
        testdataSetup();
        List<confirmation__c> c = [
            select id, name, project_services__r.project__c,Confirmed_Vendor__c,project_services__r.status__c
            FROM confirmation__c]; 
        
        system.debug('pavanTest'+c);
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
                                limit 1];
        ps.status__c = 'Kicked Off';
        ps.has_been_kicked_off__c = true;
        Update ps;
        
        PPW_transmittalController_lwc.trasmittalWrpData trData = new PPW_transmittalController_lwc.trasmittalWrpData();
        
        PPW_transmittalController_lwc cslwc = new PPW_transmittalController_lwc(); 
        
        
        
        con = [Select id,Project_Services__c, Project_Services__r.project__c , Project_Services__r.project__r.title__r.Marty_Title_ID__c, Project_Services__r.project__r.title__c, project_services__r.vendor__c,Confirmed_Vendor__c 
               from Confirmation__c where project_services__r.project__c=: ps.project__c AND project_services__c =: ps.id limit 1];
        
        List<ASIN__c> asList = new List<ASIN__c>();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin);
        
        ASIN__c asin1 = new ASIN__c(Name='Digital',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin1);
        insert asList;
        
        contact cont = new contact(LastName = 'test');
        insert cont;
        title_contact__c tc = new title_contact__c(role__c = 'Author',Legal_Name__c = cont.id, title__c = con.Project_Services__r.project__r.title__c);  
        insert tc; 
        
        tc = new title_contact__c(role__c = 'Translator', Legal_Name__c = cont.id, title__c = con.Project_Services__r.project__r.title__c);  
        insert tc;
        
      //  PPW_transmittalController_lwc.getTrasmittlaData(con.Project_Services__r.project__r.title__r.Marty_Title_ID__c , con.project_services__r.vendor__c);
        PPW_transmittalController_lwc.picklistValues('Project_Services__c','Status__c', con.Project_Services__c);
        PPW_transmittalController_lwc.titleID = con.Project_Services__r.project__r.title__c;
        PPW_transmittalController_lwc.authorString();
        
        
        
    }
    
    @isTest static void transimitterControllerTest3_1() {
        
        testdataSetup();
        List<confirmation__c> c = [
            select id, name, project_services__r.project__c,Confirmed_Vendor__c,project_services__r.status__c
            FROM confirmation__c]; 
        
        system.debug('pavanTest'+c);
        Confirmation__c con = [Select id,Project_Services__c,Project_Services__r.project__c from Confirmation__c where status__c = 'Confirmed'  limit 1];
        Project_Services__c ps=[SELECT id, Name, Service__c, Vendor__c, Rate__c, Vendor_Notes__c,
                                Service__r.Name, Service__r.Service_Rate_Type__c, has_been_kicked_off__c,Additional_Rate_Input__c,
                                Custom_Quote_Amount__c,rate__r.rate_multiplier__c,Honor_Dependencies__c,
                                Vendor__r.Name,status__c,Service_Type_Complexity__c,project__c
                                FROM Project_Services__c  where Vendor__c!=null and id=: con.Project_Services__c
                                limit 1];
        ps.status__c = 'Confirming';
        ps.has_been_kicked_off__c = true;
        Update ps;
        
        PPW_transmittalController_lwc.trasmittalWrpData trData = new PPW_transmittalController_lwc.trasmittalWrpData();
        
        PPW_transmittalController_lwc cslwc = new PPW_transmittalController_lwc(); 
        
        
        
        con = [Select id,Project_Services__c, Project_Services__r.project__c , Project_Services__r.project__r.title__r.Marty_Title_ID__c, Project_Services__r.project__r.title__c, project_services__r.vendor__c,Confirmed_Vendor__c 
               from Confirmation__c where project_services__r.project__c=: ps.project__c AND project_services__c =: ps.id limit 1];
        
        List<ASIN__c> asList = new List<ASIN__c>();
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin);
        
        ASIN__c asin1 = new ASIN__c(Name='Digital',Initial_Page_Count__c=2,Title__c= con.Project_Services__r.project__r.title__c);
        asList.add(asin1);
        insert asList;
        
        contact cont = new contact(LastName = 'test');
        insert cont;
        title_contact__c tc = new title_contact__c(role__c = 'Author',Legal_Name__c = cont.id, title__c = con.Project_Services__r.project__r.title__c);  
        insert tc; 
        
        tc = new title_contact__c(role__c = 'Translator', Legal_Name__c = cont.id, title__c = con.Project_Services__r.project__r.title__c);  
        insert tc;
        
        PPW_transmittalController_lwc.reqWrap rw = new PPW_transmittalController_lwc.reqWrap();
        
        rw.psId = con.Project_Services__c;
        rw.cId = con.id;
        rw.confirmChoice = 'accept';
        rw.additionalRateInput = '100';
        rw.customQuote = '10';
        rw.rejectionReason = 'test';
        rw.reviewReason = 'test';
        String ser = JSON.serialize(rw);
        
        PPW_transmittalController_lwc.processConfirmation(ser);
        // all are nagitive senorios
        PPW_transmittalController_lwc.censhareServerUpdate(null);
        PPW_transmittalController_lwc.sendEmail(null,null);    
        PPW_transmittalController_lwc.getNotifyUser(null);    
        PPW_transmittalController_lwc.sendEmailToNotifier(null,null,null,null,null,null);    
        
        
        
    }
    
    
    
    
}