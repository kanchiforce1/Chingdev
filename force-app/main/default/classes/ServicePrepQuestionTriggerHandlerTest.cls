@isTest
private class ServicePrepQuestionTriggerHandlerTest {
    
    
    
    private static void loadTestData2() {
        List<title__c> tList = PPW_TestDataFactory.gettitleData(5,'US');
        Insert tList;
        Asin__c asin = new Asin__c(title__c = tList[0].id);
        insert asin;
        User u = [SELECT CommunityNickname,Email, Id FROM User where isActive = true and Profile.Name=: Label.Test_userProfile limit 1];
        tList[0].Production_Manager__c = u.CommunityNickname;
        update tList[0];
        
        
        List<project__c> pList;// = PPW_TestDataFactory.getProjectData(5,tList[0].Id);
        pList = [select id from project__c];
        if(pList.isEmpty()) {
            for(title__c t: tList)
                pList.add(new project__c(title__c = t.id));
            
            insert pList;
        }
        List<Service_Prep__c> spList = new List<Service_prep__c>();
        spList = [Select id from Service_Prep__c limit 1];
        if(spList.isEmpty()) {
            for(project__c p: pList)
                spList.add(new Service_Prep__c(project__c = p.id));
            
            insert spList;
        }
        // List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
        //  Insert spList;
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
        
        List<Service_Prep_Response__c> sprList = new List<Service_Prep_Response__c>();
        Service_Prep_Response__c spr = new Service_Prep_Response__c();
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
        
        /** design main question tet data **/ // create ps
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', 
                                           Option_Values__c='Yes;No',
                                           Order__c=1.0,Locale__c='US',active__c = true,Render_type__c = 'Create PS',
                                           Render_Response__c='Yes='+s.id,
                                           Sub_Question_Render_Type__c = 'Render Sub Question', 
                                           Sub_Question_Render__c = 'Yes=1.01,10.02;');
        insert spq;
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id,Response__c = 'Yes');
        sprList.add(spr);
        
        /** sub question **/
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                           Option_Values__c='Yes;No',
                                           Order__c=1.01,Locale__c='US',active__c = true, 
                                           Service_Prep_Parent_Question__c = spq.id,
                                           Sub_Question_Render_Type__c = 'Render Sub Question', 
                                           Sub_Question_Render__c = 'Yes=1.03;');
        insert spq;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr);                                   
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.03,Locale__c='US',
                                           active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS', Render_Response__c='Yes='+s.id,
                                           Update_Render_Response__c='yes='+s.id+'->'+s1.id+','+s1.id+'->'+s.id+';');
        
        insert spq;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr); 
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.13,Locale__c='US',
                                           active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS', Render_Response__c='Yes='+s.id,
                                           Update_Render_Response__c='yes='+s.id+'->'+s1.id+';');
        
        insert spq;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr);
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.23,Locale__c='US',
                                           active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS');
        
        insert spq;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'No');
        sprList.add(spr); 
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Checkbox',Order__c=1.17,Locale__c='US',active__c = true,
                                           Delete_Render_type__c = 'Delete PS', Delete_Render_Response__c ='yes='+s.id);
        insert spq;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr);                                   
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',Order__c=1.11,Locale__c='US',
                                           Option_Values__c='Yes;No',active__c = true );
        insert spq;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
        sprList.add(spr); 
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.12,Locale__c='US',active__c = true );
        insert spq;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'yes');
        sprList.add(spr); 
        /** Acquistion questions test data**/                                   
        Service_Prep_Question__c spq1 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                                                     Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.13,Locale__c='US',
                                                                     Option_Values__c='Yes;No',active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                                                     Sub_Question_Render__c = 'Yes=1.06,1.07;1.09' ); 
        
        
        
        insert spq1;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq1.id, Response__c = '');
        sprList.add(spr);  
        Service_Prep_Question__c spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                                                     Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.06,Locale__c='US',
                                                                     Option_Values__c='Yes;No',
                                                                     active__c = true );                                                                                                                                                                          
        insert spq2;
        
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response__c = '');
        sprList.add(spr);  
        spq2 = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.07,Locale__c='US',Option_Values__c='Yes;No',
                                            active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', Sub_Question_Render__c = 'Yes=1.08,1.07;');                                                                                                                                                                          
        insert spq2;
        
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq2.id, Response_Number__c  = null);
        sprList.add(spr); 
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                           Order__c=1.08,Locale__c='US',Option_Values__c='Yes;No',
                                           active__c = true );                                                                                                                                                                          
        insert spq;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
        sprList.add(spr); 
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',Order__c=1.14,Locale__c='US',
                                           Option_Values__c='Yes;No',active__c = true );
        insert spq;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = '');
        sprList.add(spr);
        
        /** Editorial questions test data**/                                   
        spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',
                                           Option_Values__c='Yes;No',Order__c=1.16,Locale__c='US',
                                           active__c = true,Sub_Question_Render_Type__c = 'Render Sub Question', 
                                           Sub_Question_Render__c = 'Yes=1.04,1.07;' );                                                                                                                                                                          
        insert spq;                                                                   
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr); 
        spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' ,
                                           Service_Prep_Parent_Question__c =spq.id, 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                           Option_Values__c='Yes;No',
                                           Order__c=1.04,Locale__c='US',active__c = true );                                                                                                                                                                          
        
        
        insert spq;
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr);
        
        
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr); 
        spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                           Service_Prep_Parent_Question__c =spq1.id, 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                           Option_Values__c='Yes;No',
                                           Order__c=1.09,Locale__c='US',active__c = true,
                                           Sub_Question_Render_Type__c = 'Render Sub Question', 
                                           Sub_Question_Render__c = 'Yes=1.04,1.07;');                                                                                                                                                                          
        
        
        insert spq;
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr);   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' ,
                                           Service_Prep_Parent_Question__c =spq.id, 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',
                                           Option_Values__c='Yes;No',
                                           Order__c=1.041,Locale__c='US',active__c = true );                                                                                                                                                                          
        
        
        insert spq;
        spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq.id, Response__c = 'Yes');
        sprList.add(spr);
        
        
        // upsert spQList;
        
        
        insert sprList;
        
        /* meta data setup **/
        //  (List<PPW_SPthreeOrMore__mdt>) JSON.deserialize( '[{"Custom_Field__c":"1"}]', List<Custom_Metadata__mdt>.class )
    }
    
    
    
    
    
    
    @isTest static void projectCreationTest2() {
        
        test.startTest();
        loadTestData2();
        test.stopTest();
        
        List<Service_Prep__c> spList = [Select id from Service_Prep__c limit 1];
        
        Service_Prep_Question__c spq = [select id,locale__c from Service_Prep_Question__c limit 1];
        spq.locale__c = 'US;UK';
        update spq;
        spq.locale__c = 'US';
        update spq;
        spq.locale__c = 'UK';
        update spq;
        
        ServicePrepQuestionTriggerHandler.setReponses(spList[0].id,spq.id,new list<Service_Prep_Response__c>());
        
        ApexPages.StandardController sc = new ApexPages.StandardController(spList[0]);
        
        
        PageReference pageRef = Page.PPW_servicePrepForm;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOf(spList[0].Id));
        PPW_ServicePrepFormController sFormCont = new PPW_ServicePrepFormController(sc);
        sFormCont.btnName = 'CreatePs';
        sFormCont.currentTab ='Editorial';
        sFormCont.SaveForm();
        sFormCont.CreatePS();
        sFormCont.currentTab ='Design';
        sFormCont.SaveForm();
        // sFormCont.CreatePS();
        sFormCont.currentTab ='Acquisition';
        sFormCont.SaveForm();
        sFormCont.CreatePS();
        sFormCont.getQuesNumber('Yes=1.03,1.02,1.01;');
    }
    
    /* @isTest static void projectCreationTest1() {
title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
Production_Locale__c = 'US',Current_Word_Count__c = 10,Sub_Category__c= 'Historical',Internal_Imprint__c='Lake Union'

);
insert t;  

t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
Production_Locale__c = 'US',Current_Word_Count__c = 10,Sub_Category__c= 'Historical',Internal_Imprint__c='Lake Union'

);
insert t;       

List<Service_Prep__c> spList = [Select id,project__r.title__r.Production_Locale__c from Service_Prep__c where project__r.title__r.Production_Locale__c != null];

List<Service_Prep_Question__c> spqLstIn = new List<Service_Prep_Question__c>();
List<Service_Prep_Response__c> sresLstIn = new List<Service_Prep_Response__c >();

Service_Prep_Question__c spq1 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', 
Option_Values__c='Yes;No',
Order__c=1.0,Locale__c='US',active__c = true,Render_type__c = 'Create PS',
Render_Response__c='Yes=',
Sub_Question_Render_Type__c = 'Render Sub Question', 
Sub_Question_Render__c = 'Yes=1.01,10.02;');
spqLstIn.add(spq1);
Service_Prep_Response__c spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq1.id,Response__c = 'Yes');
sresLstIn.add(spr);

Service_Prep_Question__c spq2 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', 
Option_Values__c='Yes;No',
Order__c=1.0,Locale__c='US',active__c = true,Render_type__c = 'Create PS',
Render_Response__c='Yes=',
Sub_Question_Render_Type__c = 'Render Sub Question', 
Sub_Question_Render__c = 'Yes=1.01,10.02;');
spqLstIn.add(spq2);
spr = new Service_Prep_Response__c(Service_Prep__c = spList[1].id,Service_Prep_Question__c = spq2.id,Response__c = 'Yes');
sresLstIn.add(spr);

insert spqLstIn;
insert sresLstIn;


List<Service_Prep_Question__c> spqLst = new List<Service_Prep_Question__c>(); 
for(Service_Prep_Question__c spq : [select id,locale__c from Service_Prep_Question__c]) {
spq.locale__c = 'US';
spqLst.add(spq);

}    

update spqLst;

}
*/
    @isTest static void projectCreationTest3() {
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                  Production_Locale__c = 'US',Current_Word_Count__c = 10,Sub_Category__c= 'Historical',Internal_Imprint__c='Lake Union'
                                  
                                 );
        insert t;    
        
        
        
        List<project__c> pList;// = PPW_TestDataFactory.getProjectData(5,tList[0].Id);
        pList = [select id from project__c];
        if(pList.isEmpty()) {
            
            pList.add(new project__c(title__c = t.id));
            
            insert pList;
        }
        List<Service_Prep__c> spList = new List<Service_prep__c>();
        spList = [Select id,project__r.title__r.Production_Locale__c from Service_Prep__c where project__r.title__r.Production_Locale__c != null limit 1];
        if(spList.isEmpty()) {
            for(project__c p: pList)
                spList.add(new Service_Prep__c(project__c = p.id));
            
            insert spList;
        }
        
        Service_Prep_Question__c spq1 = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                                                     Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist', 
                                                                     Option_Values__c='Yes;No',
                                                                     Order__c=1.0,Locale__c='US',active__c = true,Render_type__c = 'Create PS',
                                                                     Render_Response__c='Yes=',
                                                                     Sub_Question_Render_Type__c = 'Render Sub Question', 
                                                                     Sub_Question_Render__c = 'Yes=1.01,10.02;');
        insert spq1;
        Service_Prep_Response__c spr = new Service_Prep_Response__c(Service_Prep__c = spList[0].id,Service_Prep_Question__c = spq1.id,Response__c = 'Yes');
        insert spr;
        
        Service_Prep_Question__c spq = [select id,locale__c from Service_Prep_Question__c where id=:spq1.id limit 1];
        spq.locale__c = 'US;UK';
        update spq;
        spq.locale__c = 'US';
        update spq;
        spq.locale__c = 'UK';
        update spq;
        
        
    }
}