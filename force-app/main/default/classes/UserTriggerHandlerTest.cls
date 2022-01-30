@isTest
private class UserTriggerHandlerTest {
    
    private static void testdataSetup() {
        
        
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital');
        insert t;
        
        insert new ASIN__c(title__c = t.id);
        insert new Creative_Brief__c(title__c = t.id);
        project__c p;
        try {
         p =  [select id from project__c limit 1];
        } catch(exception e) {
            p = new project__c(title__c = t.id);
            insert p;
        }
        
        
        try { 
            insert new project__c(title__c = t.id);
            List<project__c> pList = new List<project__c>();
            pList.add(new project__c(title__c = t.id));
            pList.add(new project__c(title__c = t.id));
            
            insert pList;
        } catch(Exception e) {system.debug(e);}
        
        Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service',Service_Grouping__c = 'Cover Design');
        insert s;
        Service__c s1 = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service',Service_Grouping__c = 'Cover Design');
        insert s1;   
        p =  [select id from project__c limit 1];
        
        Vendor__c v = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',Chinook_Access__c=true,
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK', Vendor_Status__c = 'Ok to Use');
        insert v; 
        insert new esp__c(vendor__c = v.id, Title__c = t.id);
        insert new esp__c(vendor__c = v.id, Title__c = t.id);
        
        Account ac = new Account(name ='TEST'+v.id) ;
        insert ac;  
        contact cont =new contact(LastName='TSEt',Email='TEST'+v.id+'@gmail.com',vendor__c = v.id,accountid=ac.id, ApubOps_Community_User__c = true);
        insert cont;
        contact cont1 =new contact(LastName='TSEt1',Email='TEST1'+v.id+'@gmail.com',vendor__c = v.id,accountid=ac.id, ApubOps_Community_User__c = true);
        insert cont1;     
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v.id,Minimum_Fee__c=0,
                                active_rate__c=true);
        r.Minimum_Fee__c=20000;
        insert r;
        
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                        Rate_Amount__c = 1000,Service__c=s1.id,Vendor__c=v.id,Minimum_Fee__c=0,
                        active_rate__c=true);
        r.Minimum_Fee__c=20000;
        insert r;
        
        List<Project_Services__c> psList = new List<Project_Services__c>();
        Project_Services__c ps = new Project_Services__c(Project__c = p.id,Service__c =s.id,vendor__c= v.id);
        psList.add(ps);
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,vendor__c= v.id);
        psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Completed',vendor__c= v.id);
        psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Cancelled',vendor__c= v.id);
        psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Cancelled',vendor__c= v.id);
        psList.add(ps);
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Completed',vendor__c= v.id);
        psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Active',vendor__c= v.id);
        //  psList.add(ps);
        
        //Killed
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Active',vendor__c= v.id);
        //   psList.add(ps);
        
        ps = new Project_Services__c(Project__c = p.id,Service__c =s1.id,status__c = 'Killed',vendor__c= v.id);
        psList.add(ps);
        
        
        insert psList;
        Confirmation__c con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=psList[0].id,
                                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0 );
        insert con;
        
        con = new Confirmation__c(Confirmation__c='Yes',Project_Services__c=psList[0].id,
                                  Confirmed_Vendor__c = v.name,Confirmed_Rush_Fee__c = 1.0 );
        insert con; 
        
        ASIN__c asin = new ASIN__c(Name='Paperback',Initial_Page_Count__c=2,Title__c=t.id);
        insert asin;
        asin = new ASIN__c(Name='Digital',Initial_Page_Count__c=2,Title__c=t.id);
        insert asin; 
        
        List<Service_Prep_Response__c> sprList = new List<Service_Prep_Response__c>();
        Service_Prep_Response__c spr = new Service_Prep_Response__c();
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
       // List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
        
         List<Service_prep__c> spList = new List<Service_prep__c>();
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
        insert sprList;
    }
    
    @isTest static void projectCreationTest() {
        
        testdataSetup();
        List<contact> cLst =[SELECT id,Name,Email FROM contact];
        
     
        esp__c ep = [select id from esp__c limit 1];
        UserTriggerHandler uh = new UserTriggerHandler();
        uh.shareESPRecords(ep);
        Map<Id,Project_Services__c> psMap = new Map<Id,Project_Services__c>([select id from Project_Services__c]);
        UserTriggerHandler.removecbShare(psMap.keyset());
    }
    
     @isTest static void disableCommUserTest() {
         testdataSetup();
          contact cont = [SELECT LastName,id, ApubOps_Community_User__c FROM Contact WHERE ApubOps_Community_User__c = true LIMIT 1];
          cont.ApubOps_Community_User__c = false;
          Update cont;
     
     }
    
    
}