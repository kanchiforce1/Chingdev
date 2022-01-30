@istest
private class ContactTriggerHandlerTest {

@testsetup
private static void loadTestData() {
    UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName =: Label.Test_userRole Limit 1];

    User adminUser = [Select Id, UserRoleId From User Where Profile.Name=: Label.Test_userProfile and isActive=true Limit 1];

    adminUser.UserRoleId = userRole.Id;
    update adminUser;
    System.runAs(adminUser) {
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
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v;
        
           Vendor__c v1 = new Vendor__c(Name='Adam Hall',Email__c='abce@gmail.com',
                                   First_Name__c='abc',Last_Name__c='abc');
        Insert v1;
        
          Account ac = new Account(name = Label.ApubsOps_Community_Account_Name) ;
        insert ac; 
     
        contact cont =new contact(LastName='TSEt',Email='TEST'+v.id+'@gmail.com',vendor__c = v1.id,accountid=ac.id);
        contact cont1 =new contact(LastName='TSEt',Email='TEST1'+v.id+'@gmail.com', ApubOps_Community_User__c = true,
        recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Vendor').getRecordTypeId());
        insert cont1;
     
        insert cont;
         cont1 = [SELECT id,accountid,recordtypeid,recordtype.name, 
         Name,Email,ApubOps_Community_User__c,LastName,Firstname,Community_User_TimeZone__c
                     FROM contact WHERE id=: cont.id];
        ContactTriggerHandler.updateAccount(new List<Contact> {cont1});
     
       ContactTriggerHandler.createCommunityUser(new List<Contact>{cont});
         }

}

  
    @isTest static void emailString() {
      
      contact c =[SELECT id,Name,Email,ApubOps_Community_User__c,LastName,Firstname,Community_User_TimeZone__c,
                      Community_User_Locale__c,Community_User_Language__c FROM contact LIMIT 1];
          ContactTriggerHandler.getEmailSubString('p@g.c');
       
    
    } 
   
    
    }