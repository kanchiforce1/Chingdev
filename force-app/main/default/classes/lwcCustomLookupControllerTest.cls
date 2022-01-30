@isTest
private class lwcCustomLookupControllerTest {

 private static User usr;
 private static String usrEmail;
     @TestSetup  
      private static void setup() {  
      
        Account a = new Account(Name = 'test');
        database.insert(a);
    
           Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com', Chinook_Access__c = true,Comic_Design__c = true,Comic_Editing__c=true,
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK', vendor_status__c= 'Ok to Use');
            database.insert(v);                       
        Contact con = new Contact(LastName = 'test', vendor__c = v.id, Accountid = a.id,Email='TEST'+v.id+'@gmail.com', ApubOps_Community_User__c = true);
        insert con;
        
        
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital',Marty_Title_ID__c = '123');
        insert t;
        
         Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service', Service_Grouping__c= 'Comic Book');
        insert s;
        Service__c s1 = new Service__c(name='Promo Text Creation',Active__c = true,Service_Rate_Type__c = 'Acquisition Service', Service_Grouping__c= 'Comic Book');
        insert s1;
        project__c p; 
        try {  
       p =  [select id from project__c limit 1];
       } catch(exception e) {
           p = new project__c(title__c = t.id);
           insert p;
       
       }
        
        Vendor__c v1 = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com', Chinook_Access__c = true,Comic_Editing__c=true, Comic_Design__c=true,
                                   First_Name__c='abc',Last_Name__c='abc',approved_locale__c='US;UK', vendor_status__c= 'Ok to Use');
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
           Comic_Book_Service__c cb = new Comic_Book_Service__c(Project__c = p.id, Vendor__c = v.id, Service__c = s.id);
        insert cb;
          esp__c ep = new esp__c(title__c = t.id );
          insert ep;
    
  
   /* Cover_Service__c cs = new Cover_Service__c(Project__c = p.id);
    insert cs;
    Full_Color_Service__c fcs = new Full_Color_Service__c(Project__c = p.id);
    insert fcs;
    Interior_Service__c fs = new Interior_Service__c(Project__c = p.id);
    insert fs;
    Promotional_Text_Service__c pt = new Promotional_Text_Service__c(Project__c = p.id);
    insert pt; */
        
        
        
        
        List<Project_Services__c> psList = new List<Project_Services__c>();
        Project_Services__c ps = new Project_Services__c(Project__c = p.id,Service__c =s.id,vendor__c= v.id,Estimated_Start_Date__c = date.today(),
                                                         Estimated_Completion_Date__c = date.today(),Actual_Start_Date__c=date.today(),Actual_Completion_Date__c= date.today()
                                                             );
        psList.add(ps);
        insert psList;
     }

  @isTest static void lwcCustomLookupContrTest() {
   test.startTest();
       Project_Services__c ps = [SELECT vendor__c,project__r.title__c, project__r.title__r.Marty_Title_ID__c FROM Project_Services__c LIMIT 1];
       contact cont = [SELECT Id,Email,vendor__r.Chinook_Access__c FROM Contact WHERE vendor__c =: ps.vendor__c and vendor__r.Chinook_Access__c = true];
       profile pfile = [SELECT id FROM profile WHERE name = 'vendor partner community login user' LIMIT 1];
       User u = [SELECT id FROM User WHERE profile.Name = 'System Administrator' AND isActive= true AND userRoleId != null LIMIT 1];
         User user = new User();
        esp__c e = [SELECT id FROM esp__c limit 1];
        system.debug('cont++'+ cont.vendor__r.Chinook_Access__c); 
            system.runas(u) {
         user = new User(alias = 'TESTzzxx', email=cont.Email,
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = pfile.id, country='United States',IsActive =true,
                             ContactId = cont.Id,
                             timezonesidkey='America/Los_Angeles', username=cont.Email+'@noemail.com');
       
        insert user;
               
            insert UserTriggerHandler.shareRecords(user.id,e.id, 'Edit','esp__Share');
        
        }
        
       esp__c ep = [SELECT id FROM esp__c WHERE Title__r.Marty_Title_ID__c =: ps.project__r.title__r.Marty_Title_ID__c AND Title__r.Marty_Title_ID__c != null];
        // User u = [SELECT id FROM User where contactId =: cont.id AND isActive = true limit 1];
     
         System.runAs(user) {
        
        lwcCustomLookupController.checkBtnsAccess('123');
        lwcCustomLookupController.getVendorId();
       
         }
     lwcCustomLookupController.getAddtionalEspLogic('123');
  lwcCustomLookupController.getResults('title__c', ' Marty_Title_ID__c , Is_In_Series__c, Full_Title_Name__c', ' Marty_Title_ID__c ', '123', 'Marty_Title_ID__c' , 'Marty_Title_ID__c');       
  lwcCustomLookupController.getResults('title__c', '  Marty_Title_ID__c , Is_In_Series__c, Full_Title_Name__c ', ' Marty_Title_ID__c ', '', 'Marty_Title_ID__c' , 'Marty_Title_ID__c');       
  lwcCustomLookupController.getTitleIdResults('123'); 
        test.stopTest();
        }
        
         @isTest static void lwcCustomLookupContrTest1() {
           lwcCustomLookupController.getVendorId();
         
         }
        
  /* @isTest static void inactiveCommunityUsertest() {
        
       // testdataSetup();
        contact cLst =[SELECT id,Name,Email FROM contact WHERE ApubOps_Community_User__c = true];
        cLst.ApubOps_Community_User__c = false;
        update cLst;
        
        
        }   */  
   }