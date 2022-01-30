@istest
private class CreateCommuityUserTest {

@testsetup
private static void loadTestData() {
    UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName =: Label.Test_userRole Limit 1];

    User adminUser = [Select Id, UserRoleId From User Where Profile.Name=: Label.Test_userProfile and isActive=true Limit 1];

    adminUser.UserRoleId = userRole.Id;
    update adminUser;
    System.runAs(adminUser){
      profile pfile = [SELECT id FROM profile WHERE name = 'vendor partner community login user' LIMIT 1];
     
    title__c t = new title__C(Name='Test',Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),
                         Pre_Dev_Edit_Word_Count__c=80000,Post_Dev_Edit_Word_Count__c=2,Internal_Imprint__c='Lake Union,Thomas & Mercer'
                        );
        insert t;
        
      
      project__c p;   
     try {
     p = [select id from project__c where title__C =: t.id];
     } catch(QueryException e) {
         p = new project__c(title__c = t.id);
         insert p;
         
     }
        Service__c s = new Service__c(Name='Animating',
                                      Service_Rate_Type__c='Animating - Handdrawn');
        Insert s;                              
        Vendor__c v= new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc', Vendor_Status__c = 'Approved: Ok to Use');
        Insert v;
        
           Vendor__c v1 = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc', Vendor_Status__c = 'Approved: Ok to Use');
        Insert v1;
        
          Account ac = new Account(name = Label.ApubsOps_Community_Account_Name) ;
        insert ac; 
     
       //// contact cont =new contact(LastName='TSEt',Email='TEST'+v.id+'@gmail.com',vendor__c = v1.id,accountid=ac.id);
        contact cont1 =new contact(LastName='TSEt',Email='TEST1'+v.id+'@gmail.com', ApubOps_Community_User__c = true, vendor__c=v.id,
        recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Vendor').getRecordTypeId(),
        accountid=ac.id);
        insert cont1;
       // System.enqueueJob(new CreateCommuityUser(new List<contact> {cont1}));
        user user = new User(alias = 'TESTzzxx', email=cont1.Email,
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = pfile.id, country='United States',IsActive =true,
                             ContactId = cont1.Id,
                             timezonesidkey='America/Los_Angeles', username=cont1.Email+'@noemail.com');
       
        insert user;
     // System.enqueueJob(new CreateCommuityUser(new List<contact> {cont1}));
     
       
         }

}

  
    @isTest static void handlerforCalculationPerHour31() {
      
      contact c =[SELECT id,Name,Email,ApubOps_Community_User__c,LastName,Firstname,Community_User_TimeZone__c,
                      Community_User_Locale__c,Community_User_Language__c FROM contact WHERE vendor__r.vendor_status__c = 'Approved: Ok to Use' LIMIT 1];
          ContactTriggerHandler.getEmailSubString('p@g.c');
        //  System.enqueueJob(new CreateCommuityUser(new List<contact> {c}));
       //CreateCommuityUser 
    
    } 
    
      @isTest static void handlerforCalculationPerHour32() {
       UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName =: Label.Test_userRole Limit 1];

    User adminUser = [Select Id, UserRoleId From User Where Profile.Name=: Label.Test_userProfile and isActive=true Limit 1];

    adminUser.UserRoleId = userRole.Id;
    update adminUser;
       system.runas(adminUser) {
      Vendor__c v1 = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc', Vendor_Status__c = 'Approved: Ok to Use');
        Insert v1;
        
          Account ac = new Account(name = Label.ApubsOps_Community_Account_Name) ;
        insert ac; 
      
        
          contact cont1 =new contact(LastName='TSEt',Email='TEST1'+v1.id+'@gmail.com', ApubOps_Community_User__c = true, vendor__c=v1.id,
        recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Vendor').getRecordTypeId(),
        accountid=ac.id);
        insert cont1;
        // System.enqueueJob(new CreateCommuityUser(new List<contact> {cont1}));
          }
     
    } 
    
     @isTest static void shareServicessTest3() {
       test.startTest();
       User user = [SELECT id FROM User WHERE ContactId!=null limit 1];
      //  CreateCommuityUser.permissionSetAssignments(new List<User>{user});
        test.stopTest();
        //
         }
    
   
    
    }