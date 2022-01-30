@isTest
private class PPW_projectCreationfromTitleTest {
    @isTest static void projectCreationTest() {
    
    title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Test');
    insert t;
    
     t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0],Name='Test');
    insert t;
    
    project__c p;
     try {
     p =  [select id from project__c limit 1];//new project__c(title__C = t.id);
     } catch(exception e) {
        p = new project__c(title__c = t.id);
        insert p; 
     }
    
    t = new title__C(Status__c='TEST',Name='Test');
    insert t;
      
       t = [select id,Status__c from title__c where id=:t.id];
       t.status__c = String.valueOf(label.StatusCheckProjectCreation).split(',')[0];
       
       update t;
    }
}