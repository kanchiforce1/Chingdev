@isTest(seeAllData=false)
public class cb_create_test {
    public static PageReference createPage = Page.cb_create;
    
    public static title__c t = new title__c(name='Test Title');
    public static creative_brief__c cb = new creative_brief__c();
    public static creative_brief__c cb2 = new creative_brief__c();
    public static author_questionnaire__c aq = new author_questionnaire__c();
    public static book_questionnaire__c bq = new book_questionnaire__c();
    
    static testMethod void basicCreate(){
        insert (t);
        aq.Title__c = t.id;
        bq.Title__c = t.id;
        insert aq;
        insert bq;
        
        cb.Title__c = t.id;
        cb2.Title__c = t.id;
        
        test.startTest();
        //insert the singular CB
        insert(cb);
        
        try{
            //insert another one to create a duplicate scenario
            insert(cb2);
        }catch(Exception e){
            Boolean expectedExceptionThrown =  false;
            if (e.getMessage().contains('This title already contains a Creative Brief(')){
                expectedExceptionThrown = true;
            }
            
            System.AssertEquals(expectedExceptionThrown, true);  
        } 
        
        
        test.stopTest();
        
    }
    
    static testMethod void stdCreateVFPage(){
        
        //insert the title
        insert t;
        aq.Title__c = t.id;
        bq.Title__c = t.id;
        insert aq;
        insert bq;
        
        cb.Title__c = t.id;
        
        test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.cb_create'));
        System.currentPageReference().getParameters().put('CF00N0Z00000GP596_lkid', t.id);
        
        Apexpages.StandardController sc = new Apexpages.StandardController(cb);
        cb_createController cbCreate = new cb_createController(sc);
        
        system.debug(cbCreate);
        
        PageReference result = cbCreate.validateCreate();
        PageReference goback = cbCreate.goBack();
        
        test.stopTest();
        
        system.assertNotEquals(result, null);
        system.assertNotEquals(goBack, null);
    }
    
    static testMethod void dupeCreateVFPage(){
        //insert the title
        insert t;
        aq.Title__c = t.id;
        bq.Title__c = t.id;
        insert aq;
        insert bq;
        
        cb.Title__c = t.id;
        insert cb;
        
        test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.cb_create'));
        System.currentPageReference().getParameters().put('CF00N0U000000LgEJ_lkid', t.id);
        
        Apexpages.StandardController sc = new Apexpages.StandardController(cb2);
        cb_createController cbCreate = new cb_createController(sc);
        
        system.debug(cbCreate);
        
        PageReference result = cbCreate.validateCreate();
        //PageReference goback = cbCreate.goBack();
        
        test.stopTest();
    }
}