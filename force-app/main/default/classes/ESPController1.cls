public class ESPController1 {
    
    
    
    //url parameters
    public String v = ApexPages.currentPage().getParameters().get('v');
    public String esp = ApexPages.currentPage().getParameters().get('esp');
    public String tId = ApexPages.currentPage().getParameters().get('titleId');
    public Vendor__c Vendor = new Vendor__c();
   // public List<Vendor__c> Vendor = new list<vendor__c>([SELECT id, name FROM Vendor__c WHERE id = :v AND Chinook_Access__c = True LIMIT 1]);
    public List<Title__c> Title = new List<Title__c> ();
    public List<ESP__c> ESPList = new List<ESP__C> ();
    
    //sObjects
    public ESP__c espN = new ESP__c();
   
    
    //Create Inputs
    public String TitleID { get; set; }
    public string martyid;
    
    //Key Page References
    public PageReference booter = new PageReference('http://www.google.com'); //boot bad users!
    
    /////Footer Links/////
    public String getV() {
        return v;
    }
    //////////////////////

    ////////////////////////
    /////Action Methods/////
    ////////////////////////
    
    public PageReference LookupVendor() {//function to check the url contains the correct vendor id, set as action for all pages to enable a check when the page is loaded!!!
        if(v == null || v== '') {
            v = [SELECT  Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__r.Chinook_Access__c = true AND id=:UserInfo.getUserId() LIMIT 1].Contact.Vendor__c;
           // v = Vendor.Id;
        }else {
            Vendor = [SELECT id, name FROM Vendor__c WHERE id = :v AND Chinook_Access__c = True LIMIT 1];
            v = Vendor.id;
         }   
        if (String.isEmpty(v)) {
            booter.setRedirect(true);
           // return booter;
            
        }
       //Vendor = v
        return null;
    }
    
       
    
    public PageReference goCreate() {
        PageReference goCreate = Page.espcreate;
        goCreate.getParameters().put('v',v);
        goCreate.setRedirect(true);
        return goCreate;
    }
    
    public PageReference goDash() {
        PageReference goDash = Page.espdashboard;
        goDash.getParameters().put('v',v);
        goDash.setRedirect(true);
        return goDash;
    }
    
    
    /////////////////////////
    /////ESP Create Page///// 
    /////////////////////////
    public PageReference LookupTitleID(){ //check that the supplied title ID works, if it does, create a new esp, and move to next step
        
        if (String.isEmpty(TitleID) || !TitleId.isNumeric()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please enter a valid Title Id.'));
            return null;
        }else{
            Title = [SELECT id, name FROM Title__c WHERE MARTY_TITLE_ID__C = :titleid LIMIT 1];
        }
        
        if (Title.size() == 1 ) { //valid title id, create the esp, insert, and move to the full form. 
            espN.Vendor__c = Vendor.id;
            espN.Title__c = Title.get(0).id;
            Group g = [SELECT id FROM Group WHERE DeveloperName =: Label.CommunityESPRecordOwner and type='Queue'];
            espN.ownerId = g.id; 
            try {
                insert(espN);
            } catch(DmlException e) {
                System.debug('The following exception has occurred while inserting the new ESP: ' + e.getMessage());
            }
            
            PageReference redirect = Page.esp;
            redirect.getParameters().put('v',vendor.Id);
            redirect.getParameters().put('id',espN.id);
            redirect.setRedirect(true);
            return redirect;
        }   else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please enter a valid Title ID.'));
            return null;
        }
        return null;
    }
    
    /////////////////////////
    /////ESP Dashboard/////// 
    /////////////////////////
    
    public List<ESP__c> getESPList() {
        ESPList = [SELECT id, name, Title__r.Marty_Title_Id__c, Title__r.Name, ESP_Status__c, CreatedDate 
                   FROM ESP__c 
                   WHERE Vendor__r.id=:v 
                   AND ESP_Status__c != 'Completed' 
                   AND ESP_Status__c != 'Cancelled'
                   ORDER BY Title__r.Name ASC];
        
        if (ESPList.isEmpty()){
            return null;
        }else{
            system.debug(ESPList);
            return ESPList;            
        }
        
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