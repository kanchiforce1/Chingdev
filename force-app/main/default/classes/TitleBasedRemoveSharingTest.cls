@isTest
private class TitleBasedRemoveSharingTest {

 private static User usr;
 private static String usrEmail;
 private static Project__c p;
 private static Vendor__c v;
 private static Service__c s;
     @TestSetup  
      private static void setup() {  
      
        Account a = new Account(Name = 'test');
        database.insert(a);
      
           v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com', Chinook_Access__c = true,
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK', vendor_status__c= 'Approved: Ok to Use', Comic_Design__c = true);
            database.insert(v);                       
        Contact con = new Contact(LastName = 'test', vendor__c = v.id, Accountid = a.id,Email='TEST'+v.id+'@gmail.com', ApubOps_Community_User__c = true);
        insert con;
        
        
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital',Marty_Title_ID__c = '123');
        insert t;
        
         title__C t1 = new title__C(Status__c= 'In Production' ,Name='Digital',Marty_Title_ID__c = '1235');
        insert t1;
       
         List<title_contact__c> tcl = new List<title_contact__c>();
        title_contact__c tc = new title_contact__c(role__c = 'Author', Legal_Name__c = con.id ,title__c = t.id);  
        tcl.add(tc);
        
        tc = new title_contact__c(role__c = 'Translator', Legal_Name__c = con.id, title__c = t1.id);  
        tcl.add(tc);
        insert tcl;
      
              
        Asin__c a3 = new Asin__c(title__c = t.id, Initial_Page_Count__c= 10, Name = 'Paperback');
        List<ASIN__c> asList1 = new List<ASIN__c>();
        asList1.add(a3);
     
        Asin__c a1 = new Asin__c(title__c = t1.id, Initial_Page_Count__c= 10, Name = 'Paperback');
        asList1.add(a1);
        insert asList1;  
          
        List<esp__c> spLst = new List<esp__c>();  
        esp__c esp =  new esp__c(title__c = t1.id, vendor__c = v.id);
        spLst.add(esp); 
        esp =  new esp__c(title__c = t1.id, vendor__c = v.id);
        spLst.add(esp); 
        insert esp;
            
        project__c p2 = new project__c(title__c = t1.id);
        insert p2;
          creative_brief__c cb = new creative_brief__c(title__c = t1.id);
        insert cb;
        
     s = new Service__c(name='Animating',Active__c = true,Service_Rate_Type__c = 'Animating - Handdrawn', Service_Grouping__c = 'Comic Book;Cover Design');
        insert s;
        Service__c s1 = new Service__c(name='Animating',Active__c = true,Service_Rate_Type__c = 'Animating - Handdrawn', Service_Grouping__c = 'Comic Book;Cover Design');
        insert s1;   
       p =  [select id from project__c limit 1];
        
        Vendor__c v1 = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK', vendor_status__c= 'Ok to Use', Comic_Design__c = true);
        insert v1;        
        Rate__c r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Page',
                                Rate_Amount__c = 1000,Service__c=s.id,Vendor__c=v1.id,Minimum_Fee__c=0,
                                active_rate__c=true);
        r.Minimum_Fee__c=20000;
        insert r;
        
        r = new Rate__c(Rate_Currency__c='USD',Rate_Multiplier__c='Per Hour',
                        Rate_Amount__c = 1000,Service__c=s1.id,Vendor__c=v.id,Minimum_Fee__c=0,
                        active_rate__c=true);
        r.Minimum_Fee__c=20000;
        insert r;
      
        
        List<Project_Services__c> psList = new List<Project_Services__c>();
        Project_Services__c ps = new Project_Services__c(Project__c = p.id,Service__c =s.id,vendor__c= v.id,Estimated_Start_Date__c = date.today(),
                                                         Estimated_Completion_Date__c = date.today(),Actual_Start_Date__c=date.today(),Actual_Completion_Date__c= date.today()
                                                             );
        psList.add(ps);
        insert psList;
     }

  
        
        @isTest static void removeAllShare() { // from titletrigger
          title__c t3 = [select id,(select id from projects__r) from title__c where status__c = 'In Production' limit 1];
          t3.status__c = 'Published';
          update t3;
          database.executeBatch(new TitleBasedRemoveSharing(), 1);
        
        } 
        
          @isTest static void removeAllShare1() { // from titletrigger
          title__c t3 = [select id,(select id from projects__r) from title__c where status__c = 'In Production' limit 1];
          t3.status__c = 'Published';
          update t3;
         database.executeBatch(new TitleBasedRemoveSharing(new List<String>{t3.id}),1);
        
        } 
        
         
         @isTest static void removeAllShareSch() { 
          title__c t3 = [select id,(select id from projects__r) from title__c where status__c = 'In Production' limit 1];
          t3.status__c = 'Published';
          update t3;
          
             TitleBasedRemoveSharing myClass = new TitleBasedRemoveSharing();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);
         
        }     
   }