@isTest
private class CreateShareCommuityUserTest {

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
        
      
        project__c p2 = new project__c(title__c = t1.id);
        insert p2;
          creative_brief__c cb = new creative_brief__c(title__c = t1.id);
        insert cb;
        
     s = new Service__c(name='Animating',Active__c = true,Service_Rate_Type__c = 'Animating - Handdrawn', Service_Grouping__c = 'Comic Book');
        insert s;
        Service__c s1 = new Service__c(name='Animating',Active__c = true,Service_Rate_Type__c = 'Animating - Handdrawn', Service_Grouping__c = 'Comic Book');
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

    
    @isTest static void shareServicessTest3() {
       test.startTest();
       Project_Services__c ps = [SELECT vendor__c FROM Project_Services__c LIMIT 1];
       contact cont = [SELECT Id,Email FROM Contact WHERE vendor__c =: ps.vendor__c];
       profile pfile = [SELECT id FROM profile WHERE name = 'vendor partner community login user' LIMIT 1];
     //  user u = [SELECT id FROM User WHERE contactid=: cont.Id];
        // List<String> vendorProfiles = Label.Community_Vendor_Profile.split(',');
       
       User u = [SELECT id FROM User WHERE profile.Name = 'System Administrator' AND isActive= true AND userRoleId != null LIMIT 1];
         User user = new User();
         system.runas(u) {
         user = new User(alias = 'TESTzzxx', email=cont.Email,
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = pfile.id, country='United States',IsActive =true,
                             ContactId = cont.Id,
                             timezonesidkey='America/Los_Angeles', username=cont.Email+'@noemail.com');
       
      //  insert user;
        }
         system.runas(u) {
         CreateCommuityUser.activeCommunityUser(new List<user> {u});
         System.enqueueJob(new CreateShareCommuityUser(new List<user> {u}));
         
         }
         }
    
    
   }