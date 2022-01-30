@isTest //(seeAllData=true)
public class Esp_Controller_lwctest {
    //tests the vendor view page controller...
    public static title__c t = new title__c();
    public static creative_brief__c cb = new creative_brief__c();
    public static creative_brief__c cb2 = new creative_brief__c();
    public static author_questionnaire__c aq = new author_questionnaire__c();
    public static book_questionnaire__c bq = new book_questionnaire__c();
    
     @testSetup
     private static void testdataSetup() {
        
        title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital',Marty_Title_ID__c = '123', Internal_Imprint__c = 'Two Lions' , Series__c = 'test');
        insert t;
        
        title__C t1 = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Digital1',Marty_Title_ID__c = '1234', Internal_Imprint__c = '47North');
        insert t1; 
        
        contact con = new contact(LastName = 'test');
        insert con;
        
        title_contact__c tc = new title_contact__c( Role__c='Illustrator', title__c = t.id, legal_name__c = con.id);
        insert tc; 
        
         title_contact__c tc1 = new title_contact__c( Role__c='Translator', title__c = t.id, legal_name__c = con.id);
        insert tc1; 
        
      
            
        Creative_brief__c cb= new Creative_brief__c(Title__c = t.id);
        insert cb;
          list<cbi__c> cbiList = new list<cbi__c>();
        cbi__c cbi1 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief');
        cbi__c cbi2 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief', image_section__c='Concept Imagery', priority__c=1, caption__c='test');
        cbi__c cbi3 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief', image_section__c='Concept Imagery', concept__c='1', priority__c=1, caption__c='test');
        cbi__c cbi4 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief', image_section__c='Concept Imagery', concept__c='2', priority__c=1, caption__c='test');
        cbi__c cbi5 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief', image_section__c='Concept Imagery', concept__c='3', priority__c=1, caption__c='test', delete__c=true);
        cbi__c cbi6 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief', image_section__c='Additional Related Visual', priority__c=1, caption__c='test');
        
        cbiList.add(cbi1);cbiList.add(cbi2);cbiList.add(cbi3);cbiList.add(cbi4);cbiList.add(cbi5);cbiList.add(cbi6);
        insert cbiList;
           
        
    }
    
    static testMethod void extViewPage() {
     
       Creative_brief__c  cb = [select id,title__c, title__r.Marty_Title_ID__c  from Creative_brief__c limit 1];
         
        test.startTest();
      
        Esp_Controller_lwc.getESPRecords(cb.title__r.Marty_Title_ID__c);
        //esp__c ep = new esp__c();
        Esp_Controller_lwc.newEspRecord(JSON.serialize(new esp__c(title__c = cb.title__c)));
       // insert ep;
      
        test.stopTest();
    }
    
   
    }