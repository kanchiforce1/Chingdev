@isTest(seeAllData=true)
public class ESPController1Test {
    
    
    
    static testMethod void CreateGoodTitle() {//test method for Main Controller Class
        Vendor__c v = [SELECT id from Vendor__c WHERE Name = 'Girl Friday Productions LLC' Limit 1];
        Title__c t = new Title__c();
        t.Name = 'Memior';
        t.Marty_Title_Id__c = '123456';
        t.Status__c = 'Production';
        insert t;
        
        PageReference pageRef = Page.espcreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('v', v.Id);
        
        ESPController1 esp1 = new ESPController1();
        esp1.TitleID = t.Marty_Title_ID__c;
        esp1.getV();
        esp1.LookupVendor();
        esp1.goCreate();
        esp1.Create();
        esp1.chinook();
        esp1.dashboard();
        esp1.goDash();
        esp1.LookupTitleID();
        esp1.getESPList();
    }
    
    static testMethod void CreateBadTitle() {
        Vendor__c v = [SELECT id from Vendor__c WHERE Name = 'Girl Friday Productions LLC' Limit 1];
        Title__c t = new Title__c();
        
        t.Name = 'Memior2';
        t.Marty_Title_Id__c = '987654';
        t.Status__c = 'Published';
        insert t;
        
        PageReference pageRef = Page.espcreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('v', v.Id);
        
        ESPController1 esp1 = new ESPController1();
        esp1.TitleID = t.Marty_Title_ID__c;
        esp1.getV();
        esp1.LookupVendor();
        esp1.goCreate();
         esp1.Create();
        esp1.chinook();
        esp1.dashboard();
        esp1.goDash();
        esp1.LookupTitleID();
        
    }
    
    static testMethod void NoTitle() {
        Vendor__c v = [SELECT id from Vendor__c WHERE Name = 'Girl Friday Productions LLC' Limit 1];
        
        PageReference pageRef = Page.espcreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('v', v.Id);
        
        ESPController1 esp1 = new ESPController1();
        esp1.TitleID = '';
        esp1.getV();
        esp1.LookupVendor();
        esp1.goCreate();
         esp1.Create();
        esp1.chinook();
        esp1.dashboard();
        esp1.goDash();
        esp1.LookupTitleID(); 
        
    }
    
    static testMethod void NoNumericTitle() {
        Vendor__c v = [SELECT id from Vendor__c WHERE Name = 'Girl Friday Productions LLC' Limit 1];
        
        PageReference pageRef = Page.espcreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('v', v.Id);
        
        ESPController1 esp1 = new ESPController1();
        esp1.TitleID = 'ABC';
        esp1.getV();
        esp1.LookupVendor();
        esp1.goCreate();
         esp1.Create();
        esp1.chinook();
        esp1.dashboard();
        esp1.goDash();
        esp1.LookupTitleID(); 
        
    }
    
    static testMethod void NoURL() {
        PageReference pageRef = Page.espcreate;
        Test.setCurrentPage(pageRef);
        
        ESPController1 esp1 = new ESPController1();
        try {
        esp1.LookupVendor();
        } catch(exception e) {system.debug('Nagetive senario');}
        
    }
    
    static testMethod void BadURL() {
        String v = 'sasdfasdfa';
        PageReference pageRef = Page.espcreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('v', v);
        
        ESPController1 esp1 = new ESPController1();
        try {
        esp1.LookupVendor();
        }catch(Exception e) {system.debug('Nagetive senario');}
        
        
    }    
    
}