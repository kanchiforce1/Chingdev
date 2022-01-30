@isTest(SeeAllData=false)
public class ProjectScaffolderClassTest {
    
    
    static Service__c MasterService = new Service__c(Name='Master Service', Service_Rate_Type__c='Master Service Type', 
                                            Multiplier_Type__c='Flat Fee', Two_Lions_Standard__c=True,
                                                     JCC_Standard__c=True, Day_One_Standard__c=True, 
                                                     US_Standard__c=True, EU_Standard__c=True, 
                                                     Service_Grouping__c='Cover Design; Editorial; Interior Design; Promotional Text; Full Color; Comic Book');
    
    static List<Project__c> pL = new List<Project__c>();
    
    static ProjectScaffolderClass psc = new ProjectScaffolderClass();
    
       
     static testmethod void StandardProjectInsert2() {
        
     
        title__c t15 = new title__c(Production_Locale__c='US',marty_title_id__c='x1290');
        insert t15;
       
       
      
        Project__c p10 = new Project__c(Title__c=t15.Id);
       
             
        insert(MasterService);
      
        insert p10;
      
          }  
          
           static testmethod void StandardProjectInsert3() {
        
     
        title__c t18 = new title__c(Production_Locale__c='UK',marty_title_id__c='x1242',Internal_Imprint__c='APub UK');
        insert t18;
       
       
      
        Project__c p13 = new Project__c(Title__c=t18.Id);
      
             
        insert(MasterService);
      
        insert p13;
      
          }  
          
           static testmethod void StandardProjectInsert4() {
        
     
        title__c t20 = new title__c(Production_Locale__c='DE',marty_title_id__c='x1244',Internal_Imprint__c='Apub DE');
        insert t20;
       
      
        Project__c p15 = new Project__c(Title__c=t20.Id);
             
        insert(MasterService);
     
        insert p15;
          }  
    
    static testmethod void StandardProjectInsert1() {
        
       
        
        title__c t10 = new title__c(Production_Locale__c='FR',marty_title_id__c='x1234',Internal_Imprint__c='Jet City Comics');
        insert t10;
      
      
        
        
   
        Project__c p10 = new Project__c(Title__c=t10.Id);
       
        
        
        insert MasterService;       
    
        insert p10;
       
      
    }  
     static testmethod void StandardProjectInsert5() {
        
       
        
      
        title__c t11 = new title__c(Production_Locale__c='IT',marty_title_id__c='x1235',Internal_Imprint__c='Two Lions');
        insert t11;
         
   
        Project__c p11 = new Project__c(Title__c=t11.Id);
        
        
        insert MasterService;       
    
        insert p11;
      
      
    }  
    
     static testmethod void StandardProjectInsert6() {
        
       
     
        title__c t12 = new title__c(Production_Locale__c='ES',marty_title_id__c='x1236',Internal_Imprint__c='Storyfront');
        insert t12;
      
      
        Project__c p12 = new Project__c(Title__c=t12.Id);
        
        
        insert MasterService;       
    
        insert p12;
      
      
    }  
    
}