@isTest
private class ppw_censhareCompletedPSTest {
    
   @testsetup
private static void loadTestData() {
     title__c titleRec;
       
         titleRec = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = 'US',Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    Marty_Title_ID__c='1234');
        insert  titleRec;                           
      User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and profile.name='System Administrator' limit 1];
     titleRec.Acquiring_Editor__c = u.CommunityNickname;
    titleRec.status__c = String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim();
     update titleRec;
     
     List<project__c> pList = [Select id from project__c where title__c =: titleRec.id];
   
    if(pList.isEmpty()) {
           
                pList.add(new project__c(title__c = titleRec.id));
          
            insert pList;
        }
   
    // List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
  
       List<Service_Prep__c> spList = new List<Service_prep__c>();
     spList = [Select id from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: pList)
             spList.add(new Service_Prep__c(project__c = p.id));
     
         insert spList;
     }
  
     Service__c s = new Service__c(name='Developmental Edit',Active__c = true,Service_Rate_Type__c = 'Developmental Edit');
     insert s;
    Service__c s1 = new Service__c(name='Developmental Edit',Active__c = true,Service_Rate_Type__c = 'Developmental Edit');
     insert s1;
    
    List<Project_Services__c> psList = new List<Project_Services__c>();
    Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id,Honor_Dependencies__c = true,Estimated_Start_Date__c = date.today().addDays(36));
    psList.add(ps);
    ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id,Honor_Dependencies__c = true,Estimated_Start_Date__c = date.today().addDays(38));
    psList.add(ps);
    insert psList;
    
    List<Service_Dependency__c> sdList = new List<Service_Dependency__c>();
    Service_Dependency__c sd = new Service_Dependency__c(Dependent_Service__c = s.id,Parent_Service__c = s.id);
    sdList.add(sd);
    sd = new Service_Dependency__c(Dependent_Service__c = s1.id,Parent_Service__c = s1.id);
    sdList.add(sd);
    
    insert sdList;
     
    Vendor__c v = new Vendor__c(name='test',Email__c='test@test.com',First_Name__c='test',Last_Name__c='test')    ;
    insert v;
         
       }
    
    // create new service
     @isTest static void censhareConnectorTest() {
     
     List<service__c> sLst = [SELECT id FROM service__c];
     
    List<Project_Services__c> psList = [SELECT id,Censhare_XML_update_type__c,Service__c,Vendor__c,Project__c,Status__c,
                                        Honor_Dependencies__c
                                         FROM Project_Services__c limit 1];
     psList[0].Censhare_XML_update_type__c = 'New';
    // psList[1].service__c = sLst[0].id;
    set<String> psIds = new set<String>();
    for(Project_Services__c ps: psList)
        psIds.add(ps.id);
   
   test.startTest();
  // List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
      List<Service_Prep__c> spList = new List<Service_prep__c>();
     spList = [Select id from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: [SELECT id FROM Project__c])
             spList.add(new Service_Prep__c(project__c = p.id));
     
         insert spList;
     }
   
   
   ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
    ppw_censhareConnector cen = new ppw_censhareConnector();
    String xmlr = cen.censhareXMLBuilder(psList);
    system.debug('xmlr'+xmlr);
     Test.setMock(HttpCalloutMock.class, new MockHttpCenshareResponse(xmlr));
    ppw_censhareConnector.censhareService(xmlr,psList[0].id);
     PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
         PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
    
    sFormCont.incrementCounter();
    // sFormCont.incrementCounter();
    test.stopTest();
     }
     
        
     // update muitiple services with error 
      @isTest static void censhareConnectorTest3() {
     
    
   
   test.startTest();
   
     Test.setMock(HttpCalloutMock.class, new MockHttpCenshareCompletePsRes());
     ppw_censhareCompletedPS.excuteCallout(); //cps = new ppw_censhareCompletedPS();
   
    test.stopTest();
     }
   
 }