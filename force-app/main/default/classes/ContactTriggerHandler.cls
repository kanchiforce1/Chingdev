/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Service Prep Form
Description: Creates Service Prep Form and checks for duplicate project
***********************************/
public class ContactTriggerHandler{
    
    /** Create or Update vendor community user record **/
 /*   @future
    public static void createVedorCommunityUser(list<Id> newlst) {
        List<Contact> conLst = new List<Contact>();
        List<User> inActiveContactids = new List<User>();
       List<User> ActiveContactids = new List<User>(); 
        List<Contact> conNewList = new List<Contact>();
        Map<String,User> contactUsersMap = new Map<String,User>();
        for(User u: [SELECT id,contactId FROM User WHERE Contactid =: newlst])
            contactUsersMap.put(u.contactid,u);
          system.debug(newlst);  
          system.debug(contactUsersMap);
          system.debug(trigger.isinsert);
          system.debug(trigger.isupdate);
       conNewList = [SELECT id,ApubOps_Community_User__c,Email,Firstname,LastName,Community_User_TimeZone__c,
                        Community_User_Locale__c,Community_User_Language__c FROM Contact WHERE id =: newlst];    
 
            for(Contact c: conNewList) {
                          
                        if(contactUsersMap.containsKey(c.id)) {      
                        if(c.ApubOps_Community_User__c) 
                           ActiveContactids.add(contactUsersMap.get(c.id));
                        else
                            inActiveContactids.add(contactUsersMap.get(c.id));
                        } else {
                                if(c.ApubOps_Community_User__c)
                                    conLst.add(c); 
                                  }  
                    }        
               
       try {
        if(!conLst.isEmpty())
            createCommunityUser(conLst);
        if(!inActiveContactids.isEmpty())
            inactiveCommunityUser(inActiveContactids);    
        if(!ActiveContactids.isEmpty())
            activeCommunityUser(ActiveContactids);  
            } catch(Exception e) {}   
     }    
    */
  public static void updateAccount(List<Contact> conLst) {
      List<Id> conIds= new List<id>();
      for(contact c: conlst)
          if(String.isBlank(c.accountid))
              conIds.add(c.id);
      if(!conIds.isEmpty()) {       
          List<Account> acc = [SELECT id FROM Account WHERE Name =: Label.ApubsOps_Community_Account_Name];
          if(!acc.isEmpty())
          for(Contact c: conLst) {
              system.debug(c.recordType.name);
              if(String.isBlank(c.Accountid) && c.recordTypeId == Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Vendor').getRecordTypeId() && c.ApubOps_Community_User__c == true)
                  c.AccountId = acc[0].id;
         
          }
      }
  
  }
   // create community user 
  public static void createCommunityUser(List<Contact> conLst) {
      //try {
  
      Profile portalProfile = [select Id from Profile where Name =: Label.Community_Vendor_Profile limit 1];
      List<User> uLst = new List<User>();
     
          
          
      for(Contact c: conLst) {
          system.debug(c);
            User theUser = new User(
                Username = c.Email+system.now().millisecond(),
                ContactId = c.Id,
                ProfileId = portalProfile.Id,
                FirstName = c.Firstname,
              communityNickname = getEmailSubString(c.Email), //c.Email.substringBefore('@').substring(0,5) + Integer.valueof((Math.random() * 1000000)) ,
                alias = getEmailSubString(c.Email), //c.Email.substringBefore('@').substring(0,5) + Integer.valueof((Math.random() * 1000000)),
                Email = c.Email,
                EmailEncodingKey = 'UTF-8',
                LastName = c.LastName,
               
                TimeZoneSidKey = 'America/Phoenix', // Required
                LocaleSidKey = 'en_US', // Required
               // EmailEncodingKey = 'ISO-8859-1', // Required
                LanguageLocaleKey = 'en_US' // Required
               // TimeZoneSidKey = c.Community_User_TimeZone__c,//'America/Los_Angeles',
               // LocaleSidKey = c.Community_User_Locale__c,
               // LanguageLocaleKey = c.Community_User_Language__c
            );
            uLst.add(theUser);
        }
        system.debug(uLst);
        database.Insert(uLst);
        permissionSetAssignments(uLst);
       // } catch(exception e) {system.debug(e.getmessage());}
    
  }  
  
  public Static String getEmailSubString(String em) {
     
      String sStr = em.substring(0, em.indexOf('@'));
      system.debug(sStr);
      if(sStr.length() > 7)
          
          return (sStr.substring(0,5) + Integer.valueof((Math.random() * 1000)));
      else {
           integer rlen = 9-sStr.length();
           
           integer rndom = Integer.valueof('1'.rightpad(rlen, '0'));
        system.debug(rndom);
           return (sStr + Integer.valueof(Math.random() * rndom));
      }      
  
  
  
  }  
  
  /*public static void inactiveCommunityUser(List<User> inUser) {
      List<User> UserList = new List<User>();
      for(user u: inUser) {
          u.isActive = false;
          UserList.add(u);
          system.debug(UserList);
      update UserList;
      
      }
      }
   public static void activeCommunityUser(List<User> inUser) {
      List<User> UserList = new List<User>();
      for(user u: inUser) {
          u.isActive = true;
          UserList.add(u);
      
      }   
      system.debug(UserList);
      database.update(UserList);
      permissionSetAssignments(inUser);
  
  } */
  
  public static void permissionSetAssignments(List<user> uIds) {
  
      List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
      List<String> permissionsetNames = Label.ApubOps_Permission_Set.trim().split(',');
      system.debug(permissionsetNames);
      List<PermissionSet> psLst = [SELECT id FROM Permissionset WHERE label =:permissionsetNames];
        for (User u : [SELECT ID,UserRole.Name,Profile.Name,IsActive FROM User WHERE IsActive = true AND id=:uIds]){ // Add fields as per your requirement...
            for(PermissionSet ps: psLst) {
                PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = ps.id, AssigneeId = u.Id);
                permissionSetList.add(psa);
        }
      database.insert(permissionSetList);   
  }
  
  }   
}