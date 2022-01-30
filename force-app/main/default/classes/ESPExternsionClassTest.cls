@isTest(seeAllData=true)
public class ESPExternsionClassTest {
    
    static testMethod void ExtLoad(){
        Vendor__c v = [SELECT id from Vendor__c WHERE Name = 'Girl Friday Productions LLC' Limit 1];
        
        Title__c t = new Title__c();
        t.Name = 'Memior';
        t.Marty_Title_Id__c = '123456';
        t.Status__c = 'Production';
        insert t;
        
        ESP__c espN = new ESP__c();
        espN.Title__c = t.Id;
        espN.Vendor__c = v.id;
        insert (espN);
        
        
        PageReference pageRef = Page.espcreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('v', v.Id);
        ApexPages.currentPage().getParameters().put('id', espN.Id);
        
        ApexPages.StandardController stdESP = new ApexPages.StandardController(espN);
        ESPExtensionClass espX = new ESPExtensionClass(stdESP);
        espX.LookupESP();
        espX.getV();
        espX.CancelESP();
        espX.CompleteESP();
        espX.UpdateESP();
        espX.create();
        espX.chinook();
        espX.dashboard();
        
        
    }
    
    static TestMethod void BadURL() {
        Vendor__c v = [SELECT id from Vendor__c WHERE Name = 'Girl Friday Productions LLC' Limit 1];
        
        Title__c t = new Title__c();
        t.Name = 'Memior';
        t.Marty_Title_Id__c = '123456';
        t.Status__c = 'Production';
        insert t;
        
        ESP__c espN = new ESP__c();
        espN.Title__c = t.Id;
        espN.Vendor__c = v.id;
        insert (espN);
        
        
        PageReference pageRef = Page.espcreate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('v', 'asdasdas');
        ApexPages.currentPage().getParameters().put('id', '23412341');
        
        ApexPages.StandardController stdESP = new ApexPages.StandardController(espN);
        try {
            ESPExtensionClass espX = new ESPExtensionClass(stdESP);
            espX.LookupESP();
        } catch(exception e) {system.debug('Nagetive senario');}
      
        
    }
    
    static TestMethod void EmptyURL() {
        Vendor__c v = [SELECT id from Vendor__c WHERE Name = 'Girl Friday Productions LLC' Limit 1];
        
        Title__c t = new Title__c();
        t.Name = 'Memior';
        t.Marty_Title_Id__c = '123456';
        t.Status__c = 'Production';
        insert t;
        
        ESP__c espN = new ESP__c();
        espN.Title__c = t.Id;
        espN.Vendor__c = v.id;
        insert (espN);
        
        
        PageReference pageRef = Page.espcreate;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController stdESP = new ApexPages.StandardController(espN);
        try {
        ESPExtensionClass espX = new ESPExtensionClass(stdESP);
        espX.LookupESP();
        } catch(exception e) { system.debug('Nagetive Senarios');}
      
        
    }
    
}