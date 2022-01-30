public with sharing class ESPExtensionClass {
    
    //url parameters
    public String v = ApexPages.currentPage().getParameters().get('v');
    public String esp = ApexPages.currentPage().getParameters().get('id');
    
    //key lists
    Vendor__c Vendor = [SELECT id, name FROM Vendor__c WHERE id = :v LIMIT 1];
    public List<ESP__c> ESPList = new List<ESP__C> ([SELECT id, name, Title__r.Marty_Title_ID__c FROM ESP__c WHERE id = :esp  LIMIT 1]);
    
    private final ESP__c espC;
    
    //returns
    public String TitleID;
    
    //Key Page References
    public PageReference booter = new PageReference('http://www.google.com'); //boot bad users!
    
    /////Footer Links/////
    public String getV() {
        return v;
    }
    
    public ESPExtensionClass(ApexPages.StandardController stdController) {
        this.espC = (ESP__c)stdController.getRecord();
    }
       
    
    public PageReference LookupESP() {//function to check the url contains the correct vendor id, set as action for all pages to enable a check when the page is loaded!!!
        if (String.isEmpty(v) || String.isEmpty(esp)) {
            booter.setRedirect(true);
            //return booter;
            
        }
       
        return null;
    }
    
    public PageReference UpdateESP() {
        espC.ESP_Status__c = 'Review in Progress';
        
        try {
            update(espC);
        } catch(DmlException e) {
            System.debug('The following exception has occurred while updating the current ESP record: ' + e.getMessage());
        }
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Your review has been saved!'));
        return null;
        
        
        
    }
    
    public PageReference CancelESP() {
        espC.ESP_Status__c = 'Cancelled';
        
        try {
            update(espC);
        } catch(DmlException e) {
            System.debug('The following exception has occurred while updating the current ESP record: ' + e.getMessage());
        }
        
        
        PageReference goDash = Page.espdashboard;
        goDash.getParameters().put('v',v);
        goDash.setRedirect(true);
        
        return goDash;
        
    }
    
    public PageReference CompleteESP() {
        espC.ESP_Status__c = 'Completed';
        
        try {
            update(espC);
        } catch(DmlException e) {
            System.debug('The following exception has occurred while updating the current ESP record: ' + e.getMessage());
        }
        
        
        PageReference goDash = Page.espdashboard;
        goDash.getParameters().put('v',v);
        goDash.setRedirect(true);
        
        return goDash;
    }
    
     public PageReference create() {
        PageReference goDash = Page.espcreate;
        goDash.getParameters().put('v',v);
        goDash.setRedirect(true);
        
        return goDash;
     }
     
      public PageReference chinook() {
        PageReference goDash = Page.esplanding;
        goDash.getParameters().put('v',v);
        goDash.setRedirect(true);
        
        return goDash;
     }
     
      public PageReference dashboard() {
        PageReference goDash = Page.espdashboard;
        goDash.getParameters().put('v',v);
        goDash.setRedirect(true);
        
        return goDash;
     }
    
}