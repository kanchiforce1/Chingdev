@isTest
private class PPW_ServicePrepFormControllerHelperTest {


public static void setupdate(){
    
     Service__c s = new Service__c(name='Developmental Edit',Active__c = true,Service_Rate_Type__c = 'Developmental Edit');
     insert s;
    Service__c s1 = new Service__c(name='Developmental Edit',Active__c = true,Service_Rate_Type__c = 'Developmental Edit');
     insert s1;
     
     
     List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.08,Locale__c='US',
                                            Option_Values__c='Yes;No',  active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.01,1.15;',Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');                                                                                                                                                                          
       insert spq;                                                                   
         
        
        /** design main question tet data **/ // create ps
        Service_Prep_Question__c spq3 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', Option_Values__c='Yes;No', Service_Prep_Parent_Question__c = spq.id,
                                            Order__c=1.15,Locale__c='US',active__c = true,Render_type__c = 'Create PS',Render_Response__c='Yes='+s.id,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.01,1.05,1.10;',Notification_Service__c = 'Developmental Edit'
                                            ,Notification_Window__c='Start');
           insert spq3;
          
           
           /** sub question **/
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', Option_Values__c='Yes;No',
                                            Order__c=1.01,Locale__c='US',active__c = true, Service_Prep_Parent_Question__c = spq3.id,
                                             Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.03;',
                                             Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');
           insert spq;                                                                   
                                          
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.03,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS', Render_Response__c='Yes='+s.id,
                                            Update_Render_Response__c='yes='+s.id+'->'+s1.id+';',Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');
                                             
           insert spq;                                                                   
        
           
           spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.0301,Locale__c='US',
                                            active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS',
                                            Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');
                                             
           insert spq;                                                                   
                        
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Checkbox',Order__c=1.0,Locale__c='US',active__c = true,
                                            Delete_Render_type__c = 'Delete PS', Delete_Render_Response__c ='yes='+s.id,Notification_Service__c = 'Developmental Edit',
                                            Notification_Window__c='Start');
           insert spq;                                                                   
                                          
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',Order__c=1.001,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true ,Notification_Service__c = 'Developmental Edit',
                                            Notification_Window__c='Start');
           insert spq;                                                                   
        
          spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.002,Locale__c='US',active__c = true
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start' );
         insert spq;                                                                   
      
         /** Acquistion questions test data**/                                   
         Service_Prep_Question__c spq1 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , Service_Prep_Parent_Question__c =spq3.id,
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.10,Locale__c='US',
                                            Option_Values__c='Yes;No',active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                            Sub_Question_Render__c = 'Yes=1.06;',Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start' ); 
          
                                                                                                                                                                                                                     
          
          insert spq1;                                                                   
          
        Service_Prep_Question__c spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.06,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');                                                                                                                                                                          
          insert spq2;
                                                                         
           
          spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.07,Locale__c='US',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.08,1.07;'
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');                                                                                                                                                                          
          insert spq2;
                                                                           
         
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq2.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.0888,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
       insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq2.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.089,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
       insert spq;                                                                   
         
        
        
         /** Editorial questions test data**/                                   
          spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.003,Locale__c='US',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.04,1.07;'
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
          insert spq;                                                                   
         
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , Service_Prep_Parent_Question__c =spq.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.04,Locale__c='US',active__c = true
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
       
                                             
        insert spq;
       
       
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , Service_Prep_Parent_Question__c =spq1.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.09,Locale__c='US',active__c = true,
                                            Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.04,1.07;',
                                            Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule');                                                                                                                                                                          
       
                                             
        insert spq;
        
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , Service_Prep_Parent_Question__c =spq.id, 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.0401,Locale__c='US',active__c = true
                                            ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
       
                                             
        insert spq;
        
      


 title__c t = new title__C(Status__c='Pre Acquisition',Name='Test',
                     Pre_Dev_Edit_Word_Count__c=80000,Post_Dev_Edit_Word_Count__c=2);
    insert t;
   
   ASIN__c asin = new ASIN__c(Title__c = t.id);
   insert asin;
   Update new title__C(id=t.id,Status__c='Pre Acquisition',Production_Locale__c = 'US',  Internal_Imprint__c='Crossing', Literary_Form__c='Poetry');
    Update new title__C(id=t.id,Status__c='Pre Acquisition',Production_Locale__c = 'US',  Internal_Imprint__c='Two Lions', Literary_Form__c='Poetry');
     Update new title__C(id=t.id,Status__c='Pre Acquisition',Production_Locale__c = 'US',  Internal_Imprint__c='Poetry', Literary_Form__c='Poetry');
   
   
    project__c p;   
     try {
     p = [select id from project__c where title__C =: t.id];
     } catch(QueryException e) {
         p = new project__c(title__c = t.id);
         insert p;
         
     }
    
    
    
}
 //static String serviceIdstoCreate = '';

@isTest static void PPW_autoQuestionCreate()
{
setupdate();
String str ='';
String str1 ='';
String serviceIdstoCreate = '';
for(title__c t : [select id from title__c]) {
str = ','+t.id;
str1 = t.id;
}
String splitServices = '';
String splitServices1 = '';
     //List<Service__c> serList = 
     
     for(service__c s: [select id from service__c]) {//new Service__c
       // serviceIdstoCreate = serviceIdstoCreate+s.id+',';
        if(String.isBlank(splitServices1))
         splitServices1 = s.id;
         else {
         splitServices1 = splitServices1+ '->'+s.id+';';
         break;}
        }
     for(service__c s: [select id from service__c]) {//new Service__c
        serviceIdstoCreate = serviceIdstoCreate+s.id+',';
      if(String.isBlank(splitServices))
         splitServices = s.id;
     else
         splitServices = splitServices+ '->'+s.id+',';        
     }   
    splitServices = splitServices + ';';
    
   
PPW_autoQuestionCreateHandler.splitvalues(str);
PPW_autoQuestionCreateHandler.splitvalues1(str1);


PPW_autoQuestionCreateHandler.QuestionToCreate('Two Lions,Lake Union','Internal_Imprint__c');

PPW_ServicePrepFormControllerHelper serContHelper = new PPW_ServicePrepFormControllerHelper();
 serContHelper.getQueryMetaData();
PPW_ServicePrepFormControllerHelper.splitvalues(serviceIdstoCreate);
PPW_ServicePrepFormControllerHelper.splitvalues1(serviceIdstoCreate);
PPW_ServicePrepFormControllerHelper.psToCreate('Lake Union','Internal_Imprint__c');
PPW_ServicePrepFormControllerHelper.psToCreate('Two Lions,Lake Union','Internal_Imprint__c');
PPW_ServicePrepFormControllerHelper.updateSplitLogic(splitServices);
PPW_ServicePrepFormControllerHelper.updateSplitLogic(splitServices1);
PPW_ServicePrepFormControllerHelper.psToCreate('Lake Union','Internal_Imprint__c');
PPW_ServicePrepFormControllerHelper.psToCreate('Two Lions,Lake Union','Internal_Imprint__c');



}

@isTest static void PPW_autoQuestionCreate1()
{
setupdate();
String splitServices = '';
String splitServices1 = '';
String serviceIdstoCreate = '';
     
     for(service__c s: [select id from service__c]) {//new Service__c
       
        if(String.isBlank(splitServices1))
         splitServices1 = s.id;
         else {
         splitServices1 = splitServices1+ '->'+s.id+';';
         break;}
        }
     for(service__c s: [select id from service__c]) {//new Service__c
        serviceIdstoCreate = serviceIdstoCreate+s.id+',';
      if(String.isBlank(splitServices))
         splitServices = s.id;
     else
         splitServices = splitServices+ '->'+s.id+',';        
     }   
    splitServices = splitServices + ';';



 List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
     Insert tList;
 Asin__c asin = new Asin__c(title__c = tList[0].id);
 insert asin;    
 List<project__c> pList = new List<project__c>();
 pList = [Select id from project__c where title__c =: tList];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
 if(pList.isempty()) {
     for(title__c t: tList)
         pList.add(new project__c(title__c = t.id));
    insert pList;     
  }       
   //  Insert pList;
     List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
 Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s;
    Service__c s1 = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s1;
    
    List<Project_Services__c> psList = new List<Project_Services__c>();
    Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id);
    psList.add(ps);
    ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id);
    psList.add(ps);
    insert psList;

    psList = [Select id,Project__c,Service__c from Project_Services__c];
    PPW_ServicePrepFormControllerHelper serContHelper = new PPW_ServicePrepFormControllerHelper();
     serContHelper.getQueryMetaData();
   ///  serContHelper.getTitleAsinRecords(pList[0].id);
     PPW_ServicePrepFormControllerHelper.digitPatternCheck('123');
     PPW_ServicePrepFormControllerHelper.digitPatternCheck('aab');
    PPW_ServicePrepFormControllerHelper.psMWCUpdate(pList[0].id,psList);
    LIst<Project_Services__c> psUpdateList = PPW_ServicePrepFormControllerHelper.createPSLogicFromTitle(pList[0].id,serviceIdstoCreate);
    PPW_ServicePrepFormControllerHelper.updatePSLogic(splitServices ,psUpdateList);
    PPW_ServicePrepFormControllerHelper.updatePSLogic(splitServices ,psUpdateList);
    serContHelper.updateStanToComplex(psUpdateList);
    serContHelper.getProofComplexServiceId('psUpdateList');
    PPW_ServicePrepFormControllerHelper.updatePsTileSubCategory(splitServices ,psUpdateList);
    PPW_ServicePrepFormControllerHelper.psInternalImprintupdate(pList[0].id,psList);
    PPW_ServicePrepFormControllerHelper.psInternalImprintupdate(pList[0].id,psUpdateList);

}


@isTest static void PPW_autoQuestionCreate2()
{
setupdate();
String splitServices = '';
String splitServices1 = '';
String serviceIdstoCreate = '';
String serviceIdstoCreate1 = '';
String serviceIdstoCreate2 = '';
     
     LIst<service__c> slist = [select id from service__c];
     for(service__c s: slist) {//new Service__c
       
        if(String.isBlank(splitServices1))
         splitServices1 = s.id;
         else {
         splitServices1 = splitServices1+ '->'+s.id+';';
         break;}
        }
        
        for(service__c s: slist) {//new Service__c
        serviceIdstoCreate1 = serviceIdstoCreate1+s.id+';';
        serviceIdstoCreate2 = serviceIdstoCreate2 + s.id;
        break;
        }
     for(service__c s: slist) {//new Service__c
        serviceIdstoCreate = serviceIdstoCreate+s.id+',';
      if(String.isBlank(splitServices))
         splitServices = s.id;
     else
         splitServices = splitServices+ '->'+s.id+',';        
     }   
    splitServices = splitServices + ';';



 List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
     Insert tList;
 Asin__c asin = new Asin__c(title__c = tList[0].id);
 insert asin;    
 List<project__c> pList = new List<project__c>();
 pList = [Select id from project__c where title__c =: tList];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
 if(pList.isempty()) {
     for(title__c t: tList)
         pList.add(new project__c(title__c = t.id));
    insert pList;     
  }
     List<Service_Prep__c> spList = new List<Service_Prep__c>();
     spList = [Select id from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: pList)
             spList.add(new Service_Prep__c(project__c = p.id));    
     
     insert spList;
     
     }
     
     
 Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s;
    Service__c s1 = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s1;
    
    List<Project_Services__c> psList = new List<Project_Services__c>();
    Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id);
    psList.add(ps);
    ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id);
    psList.add(ps);
    insert psList;

    psList = [Select id,Service__C from Project_Services__c];
    
    psList = [Select id,Project__c,Service__c from Project_Services__c];
    PPW_ServicePrepFormControllerHelper serContHelper = new PPW_ServicePrepFormControllerHelper();
     serContHelper.getQueryMetaData();
    // serContHelper.getTitleAsinRecords(pList[0].id);
     PPW_ServicePrepFormControllerHelper.digitPatternCheck('123');
     PPW_ServicePrepFormControllerHelper.digitPatternCheck('aab');
    PPW_ServicePrepFormControllerHelper.psMWCUpdate(pList[0].id,psList);
    LIst<Project_Services__c> psUpdateList = PPW_ServicePrepFormControllerHelper.createPSLogicFromTitle(pList[0].id,serviceIdstoCreate);
    LIst<Project_Services__c> psUpdateList1 = PPW_ServicePrepFormControllerHelper.createPSLogicFromTitle(pList[0].id,serviceIdstoCreate1);
    PPW_ServicePrepFormControllerHelper.splitvalues1(serviceIdstoCreate1);
    PPW_ServicePrepFormControllerHelper.splitvalues(serviceIdstoCreate2);
    PPW_ServicePrepFormControllerHelper.updatePSLogic(splitServices ,psUpdateList);
    PPW_ServicePrepFormControllerHelper.updatePSLogic(splitServices ,psList);
    serContHelper.updateStanToComplex(psUpdateList);
    serContHelper.getProofComplexServiceId('psUpdateList');
    PPW_ServicePrepFormControllerHelper.updatePsTileSubCategory(splitServices ,psUpdateList);
    PPW_ServicePrepFormControllerHelper.psInternalImprintupdate(pList[0].id,psList);
    PPW_ServicePrepFormControllerHelper.psInternalImprintupdate(pList[0].id,psUpdateList);

}

@isTest static void PPW_autoQuestionCreate3()
{
//setupdate();
Service__c s = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s;
    Service__c s1 = new Service__c(name='Acquisition Service',Active__c = true,Service_Rate_Type__c = 'Acquisition Service');
     insert s1;
String splitServices = '';
String splitServices1 = '';
String serviceIdstoCreate = '';
String serviceIdstoCreate1 = '';
String serviceIdstoCreate2 = '';
     
     LIst<service__c> slist = [select id from service__c];
     for(service__c s2: slist) {//new Service__c
       
        if(String.isBlank(splitServices1))
         splitServices1 = s2.id;
         else {
         splitServices1 = splitServices1+ '->'+s2.id+';';
         break;}
        }
        
        for(service__c s2: slist) {//new Service__c
        serviceIdstoCreate1 = serviceIdstoCreate1+s2.id+';';
        serviceIdstoCreate2 = serviceIdstoCreate2 + s2.id;
        break;
        }
     for(service__c s2: slist) {//new Service__c
        serviceIdstoCreate = serviceIdstoCreate+s2.id+',';
      if(String.isBlank(splitServices))
         splitServices = s2.id;
     else
         splitServices = splitServices+ '->'+s2.id+',';        
     }   
    splitServices = splitServices + ';';



 List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
     Insert tList;
 Asin__c asin = new Asin__c(title__c = tList[0].id);
 insert asin;    
List<project__c> pList = new List<project__c>();
 pList = [Select id from project__c where title__c =: tList];//PPW_TestDataFactory.getProjectData(5,tList[0].Id);
 if(pList.isempty()) {
     for(title__c t: tList)
         pList.add(new project__c(title__c = t.id));
    insert pList;     
  }
    // List<Service_Prep__c> spList = [Select id,Service_Id_s_Created__c from Service_Prep__c limit 1];
      List<Service_Prep__c> spList = new List<Service_Prep__c>();
     spList = [Select id ,Service_Id_s_Created__c from Service_Prep__c limit 1];
     if(spList.isEmpty()) {
         for(project__c p: pList)
             spList.add(new Service_Prep__c(project__c = p.id));    
     
     insert spList;
     
     }
    
    List<Project_Services__c> psList = new List<Project_Services__c>();
    Project_Services__c ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s.id);
    psList.add(ps);
    ps = new Project_Services__c(Project__c = pList[0].id,Service__c =s1.id);
    psList.add(ps);
    insert psList;

    psList = [Select id,Service__C from Project_Services__c];
    
    psList = [Select id,Project__c,Service__c from Project_Services__c];
    PPW_ServicePrepFormControllerHelper serContHelper = new PPW_ServicePrepFormControllerHelper();
    //PPW_ServicePrepFormControllerHelper.getServices();
     serContHelper.getQueryMetaData();
   //  serContHelper.getTitleAsinRecords(pList[0].id);
     PPW_ServicePrepFormControllerHelper.digitPatternCheck('123');
     PPW_ServicePrepFormControllerHelper.digitPatternCheck('aab');
     PPW_ServicePrepFormControllerHelper.digitPatternCheck('');
    PPW_ServicePrepFormControllerHelper.psMWCUpdate(pList[0].id,psList);
    LIst<Project_Services__c> psUpdateList = PPW_ServicePrepFormControllerHelper.createPSLogicFromTitle(pList[0].id,serviceIdstoCreate);
    LIst<Project_Services__c> psUpdateList1 = PPW_ServicePrepFormControllerHelper.createPSLogicFromTitle(pList[0].id,serviceIdstoCreate1);
    PPW_ServicePrepFormControllerHelper.splitvalues1(serviceIdstoCreate1);
    PPW_ServicePrepFormControllerHelper.splitvalues(serviceIdstoCreate2);
    PPW_ServicePrepFormControllerHelper.updatePSLogic(splitServices ,psUpdateList);
    PPW_ServicePrepFormControllerHelper.updatePSLogic(splitServices ,psList);
    serContHelper.updateStanToComplex(psUpdateList);
    serContHelper.getProofComplexServiceId('psUpdateList');
    PPW_ServicePrepFormControllerHelper.updatePsTileSubCategory(splitServices ,psUpdateList);
    PPW_ServicePrepFormControllerHelper.titlesList = new List<Title__c>();
    PPW_ServicePrepFormControllerHelper.updatePsTileSubCategory(splitServices ,psUpdateList);
    PPW_ServicePrepFormControllerHelper.psInternalImprintupdate(pList[0].id,psList);
    PPW_ServicePrepFormControllerHelper.psInternalImprintupdate(pList[0].id,psUpdateList);
    spList[0].Service_Id_s_Created__c = 'test';
    PPW_ServicePrepFormControllerHelper.defaultpsCreate('test',spList[0],pList[0].id);
    
    PPW_StaticUtils.dynamicQueryListType('Project_Services__c', null, null);

}

}