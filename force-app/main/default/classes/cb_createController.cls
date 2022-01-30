public class cb_createController {
    //extends base standard controller on cb_create.vfp 
    //controls the look up, validation, and creation of the creative brief. 
    //if validated and created successfully, the page will navitgate to the default "edit" page.
    //creation will trigger the pull down of AQ/BQ repsonses into the initial brief, as well as any logic to prevent multiple briefs...
    
    private final Creative_Brief__c cb;
    
    public id relatedTitleID {get;set;}
    public string errorMsg {get;set;}
    
    public cb_createController(ApexPages.StandardController sc){
        this.cb = (Creative_Brief__c)sc.getRecord();
        relatedTitleID = ApexPages.currentPage().getParameters().get('');//id for the title lookup field in the current enviroment... may need update for prod
        system.debug(relatedtitleID);
      
        cb.Title__c = relatedTitleID;
    }
    
    public PageReference validateCreate(){
        try{
            insert(cb);
            system.debug(cb);
        } catch (Exception e){
            System.debug('ERRORSS:' + e); 
        }
        if(cb.Id != null){
            PageReference pageRef = new ApexPages.StandardController(cb).edit();
            pageRef.getParameters().put('cbid', cb.id);
            pageRef.setRedirect(true);
            return pageRef;
        }else{
            errorMsg = 'This title already has a Creative Brief record. Please go back to the title and edit the existing Creative Brief.';
            return null;
        }
        
    }
    
    public PageReference goBack(){
        PageReference pageTitle = new PageReference('/'+relatedTitleID);
        pageTitle.setRedirect(true);
        return pageTitle;
    }

}