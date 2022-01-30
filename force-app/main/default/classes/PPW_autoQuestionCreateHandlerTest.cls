@isTest
private class PPW_autoQuestionCreateHandlerTest {
    
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
        
        
        /** design main question tet data **/ 
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
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Text Area',Order__c=1.034,Locale__c='US',
                                           active__c = true, Create_Case__c=true, Update_Render_Type__c = 'Update PS',
                                           Notification_Service__c = 'Developmental Edit',Notification_Window__c='Start');
        
        insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Checkbox',Order__c=1.0,Locale__c='US',active__c = true,
                                           Delete_Render_type__c = 'Delete PS', Delete_Render_Response__c ='yes='+s.id,Notification_Service__c = 'Developmental Edit',
                                           Notification_Window__c='Start');
        insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist (Multi-Select)',Order__c=1.011,Locale__c='US',
                                           Option_Values__c='Yes;No',active__c = true ,Notification_Service__c = 'Developmental Edit',
                                           Notification_Window__c='Start');
        insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Number',Order__c=1.012,Locale__c='US',active__c = true
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
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.088,Locale__c='US',Option_Values__c='Yes;No',
                                           active__c = true,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
        insert spq;                                                                   
        
        spq = new Service_Prep_Question__c(Question_Category__c ='Acquisition' ,Sub_Category__c= 'Services' ,Service_Prep_Parent_Question__c =spq2.id, 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Order__c=1.089,Locale__c='US',Option_Values__c='Yes;No',
                                           active__c = true,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
        insert spq;                                                                   
        
        
        
        /** Editorial questions test data**/                                   
        spq = new Service_Prep_Question__c(Question_Category__c ='Editorial Scheduling' ,Sub_Category__c= 'Legal' , 
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.015,Locale__c='US',
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
                                           Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist',Option_Values__c='Yes;No',Order__c=1.0412,Locale__c='US',active__c = true
                                           ,Notification_Service__c = 'Developmental Edit',Notification_Window__c='Schedule' );                                                                                                                                                                          
        
        
        insert spq;
        
        title__c t = new title__C(Status__c='Contracted1',Name='Test',
                                  Pre_Dev_Edit_Word_Count__c=80000
                                  );
        insert t;
        
        ASIN__c asin = new ASIN__c(Title__c = t.id);
        insert asin;
        Update new title__C(id=t.id,Status__c='Pre Acquisition',Production_Locale__c = 'US',  Internal_Imprint__c='Crossing', Literary_Form__c='Poetry');
        Update new title__C(id=t.id,Status__c='Pre Acquisition',Production_Locale__c = 'US',  Internal_Imprint__c='Two Lions', Literary_Form__c='Poetry');
        Update new title__C(id=t.id,Status__c='Pre Acquisition',Production_Locale__c = 'US',  Internal_Imprint__c='Poetry', Literary_Form__c='Poetry');
        Update new title__C(id=t.id,Status__c='Pre Acquisition',Production_Locale__c = 'US',  Internal_Imprint__c='Two Lions', Literary_Form__c='Poetry');
        
        project__c p;
        try {
        p = [select id from project__c where title__C =: t.id];
        } catch(exception e) {
            p = new project__c(title__c = t.id);
            insert p;
        
        }
        
    }
    
    @isTest static void PPW_autoQuestionCreate()
    {
        setupdate();
        String str ='';
        String str1 ='';
        
        
        title__c t1 = new title__C(Status__c='Contracted1',Name='Test',
                                   Pre_Dev_Edit_Word_Count__c=80000);
        
        insert t1;                  
        title__C  t2 = new title__C(Status__c='Contracted1',Name='Test',
                                    Pre_Dev_Edit_Word_Count__c=80000);
        insert t2;               
        title__C  t3 = new title__C(Status__c='Contracted1',Name='Test',
                                    Pre_Dev_Edit_Word_Count__c=80000);
        insert t3;
        
        ASIN__c asin = new ASIN__c(Title__c = t1.id);
        insert asin;
        ASIN__c asin1 = new ASIN__c(Title__c = t2.id);
        insert asin1;
        ASIN__c asin2 = new ASIN__c(Title__c = t3.id);
        insert asin2;
        Update new title__C(id=t1.id,Status__c='Pre Acquisition',Production_Locale__c = 'US',  Internal_Imprint__c='Crossing', Literary_Form__c='Poetry');
        Update new title__C(id=t2.id,Status__c='Pre Acquisition',Production_Locale__c = 'US',  Internal_Imprint__c='Two Lions', Literary_Form__c='Poetry');
        Update new title__C(id=t3.id,Status__c='Pre Acquisition',Production_Locale__c = 'US',  Internal_Imprint__c='Poetry', Literary_Form__c='Poetry');
        
        for(title__c t : [select id from title__c]) {
            str = ','+t.id;
            str1 = t.id;
        }
        PPW_autoQuestionCreateHandler.splitvalues(str);
        PPW_autoQuestionCreateHandler.splitvalues1(str1);
        
        PPW_autoQuestionCreateHandler.QuestionToCreate('Two Lions','Internal_Imprint__c');
        PPW_autoQuestionCreateHandler.QuestionToCreate('Two Lions,Lake Union','Internal_Imprint__c');
        PPW_autoQuestionCreateHandler.QuestionToCreate('Two Lions','Internal_Imprint__c');
    }
}