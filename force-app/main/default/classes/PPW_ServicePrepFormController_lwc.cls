/***********************************
Author:      Amazon Apub // kkolla@
Used By:     custom page controller used in PPW_servicePrepForm page
Description: Controller for PPW ServicePrepForm Form, linked to the project page
************************************/

public class PPW_ServicePrepFormController_lwc{
    
    public static String currentTab{get;set;}
  
    public static Service_Prep__c serPrep{set;get;}
    public static String pmessage{get;set;}
    public static boolean roleuser{get;set;}
    //public static string btnName{get;set;}
    public static string CreatePsBtnName{get;set;}
    public static Map<String,User> allUserIds = new Map<String,User>();
    public static String acquiringEditor;  
    public static String currentEditor;
    public static boolean savemethodExecuteOnce=true;
    public static set<String> subQuestions = new set<String>();
    public static List<SerResWrap> allQuestions{get;set;}// = new List<SerResWrap>();
    static map<id,Service_Prep_Response__c> responsesList;
    public static map<String,Service__C> serivceName = new map<String,Service__C>();
    static map<String,Service_Prep_Response__c> responseMap = new  map<String,Service_Prep_Response__c>();
    
    
    public class questionResponse {
        public String selectedName{get;set;}
        public Map<String, Service_Prep_Response__c> saveQuestionsResponse{get;set;}
        public Map<String, Project_Services__c> newPss{get;set;}
        public Map<Id,Id> updatePss{get;set;}
        public Map<String, List<Service_Prep_Question__c>> createCaseTitle{get;set;}
        public List<Id> cancelPs{get;set;}
        public Service_Prep__c sPrepform{get;set;}
        public Map<String,String> acqQustionsResMap{get;set;}
        public String projectId{get;set;}
        
    }
    
     public class calloutStatusRes {
         
        @AuraEnabled public String censhareError{get;set;}
        @AuraEnabled public boolean pollerEnabled{get;set;}
        @AuraEnabled public boolean censhareStatus{get;set;}
        @AuraEnabled public set<String> censhareNewPs{get;set;}
          @AuraEnabled public Map<String, List<String>> censhareUpdatePs{get;set;}
         
       
        
    }
    
    @AuraEnabled
    public static void saveForm1(Map<String, Service_Prep_Response__c> saveQuestionsResponse) {
        system.debug(saveQuestionsResponse);  
        if(saveQuestionsResponse!=null)
            update saveQuestionsResponse.values();
      
    }
    
  
     public static List<Project_Services__c> createPs(Map<String, Project_Services__c> newPss) {  
         if(newPss != null)
             return newPss.values();
         else
             return new List<Project_Services__c>();
         
    }
    
    @AuraEnabled
    public static calloutStatusRes createupdatePs(String request) {  
        questionResponse res = (questionResponse)JSON.deserialize(
            request , questionResponse.class);
          List<Project_Services__c> psList = new List<Project_Services__c>(); 
        saveForm1(res.saveQuestionsResponse);
        psList.addAll(cancelPs(res.cancelPs));
        psList.addAll(updatePs(res.updatePss));
        psList.addAll(createPs(res.newPss));
        // createCaseMethod(res.createCaseTitle);
        return createPsLogicforTabwise(res.selectedName, res.acqQustionsResMap, res.projectId, res.sPrepform, res.createCaseTitle, res.saveQuestionsResponse);
    }
    
    
    public static List<Project_Services__c> cancelPs(List<Id> cancelPs) {  
        
        List<Project_Services__c> updateps =  new List<Project_Services__c>();
        system.debug(cancelPs);
        if(cancelPs!=null) 
            for(project_services__c ps: [SELECT id,service__c,status__c FROM project_services__c WHERE service__c =: cancelPs]) {
                
                ps.status__c = 'Cancelled';
                updateps.add(ps);
            }  
   
          return updateps;
        
    }
    
    
    public static List<Project_Services__c> updatePs(Map<Id,Id> updatePss) {  
        List<Project_Services__c> updateps =  new List<Project_Services__c>();
        system.debug(updatePss);
        if(updatePss !=null) 
            if(!updatePss.isEmpty()) 
            for(project_services__c ps: [SELECT id,service__c FROM project_services__c WHERE service__c =: updatePss.keyset()]) {
                
                system.debug(ps);
                if(updatePss.containsKey(ps.service__c)) {
                    ps.service__c = updatePss.get(ps.service__c);
                    updateps.add(ps);
                }  
            }    

        system.debug(updateps);
        return updateps;
        
    }
  
  
  
  
    /** Get all active user's emails based on nickname **/
    public static void getAllUser(List<String> nickName) {
        for(User u : [SELECT CommunityNickname,Email, Id FROM User where isActive = true and CommunityNickname=:nickName limit 4999]) 
            allUserIds.put(u.CommunityNickname,u);
        
    }  
    
    /** Create a case based on the user response and assigns it to the Production manager for the respective title (internal imprint!=two lions)  **/ 
    @AuraEnabled
    public static void createCaseMethod(Map<String, List<Service_Prep_Question__c>> casetitles) {
        if(casetitles!=null) {
        
                String acqEditorQId = Label.PPW_spAECaseReroute;
                String ownerId='';
                System.debug('proManager'+proManager);
                List<String> caseOwners = new List<String>();
                if(acquiringEditor!=null) 
                    caseOwners.add(acquiringEditor);
                if(proManager  !=null) 
                    caseOwners.add(proManager  );
                if(currentEditor  !=null) 
                    caseOwners.add(currentEditor  );
                if(allUserIds.isEmpty()) {
                    getAllUser(caseOwners);
                 
            
                
                /** Get ownder ids based on priority from title record from Production Manager,Acquiring Editor and Current Editor **/
                if(proManager!=null){
                    if(allUserIds.containsKey(proManager))
                        ownerId = allUserIds.get(proManager).Id; 
                } else {
                    if(currentEditor != null){
                        if(allUserIds.containsKey(currentEditor))
                            ownerId = allUserIds.get(currentEditor).Id; 
                    } else {
                        if(acquiringEditor != null) 
                            if(allUserIds.containsKey(acquiringEditor))
                            ownerId = allUserIds.get(acquiringEditor).Id; 
                        
                    }   
                }     
                
                if(String.isBlank(ownerId)) 
                    ownerId = acqEditorQId; 
                System.debug(ownerId);     
                System.debug(allUserIds);
               List<Case> existingCases = [SELECT id,RecordTypeId from Case where (ownerId=:ownerId OR ownerId=:acqEditorQId) AND RecordTypeId =: Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Manuscript_Submission').getRecordTypeId() AND Title__c =: casetitles.keyset()];
                List<Case> newCaes = new List<Case>();
                if(!(existingCases.size()>0)) 
                    for(String t: casetitles.keyset()) { 
                        for(Service_Prep_Question__c sq: casetitles.get(t)) {
                        String description = 'Here are the details for the case origin \n'+'Category: '+sq.Question_Category__c +'\n'+
                        'Sub Category: '+ sq.Question_Category__c + '\n'+
                        'Question Number: '+sq.name+'\n'+
                        'Question Name: '+sq.Question__c+'\n';
                    
                    case ca = new Case(Title__c=t,RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Manuscript_Submission').getRecordTypeId(),Priority='Medium',
                                       status='Open',subject='Service/Vendor Approval' , ownerId=ownerId,description1__c=description);
                   newCaes.add(ca);
                        }
                   //     insert ca;
                }
        insert newCaes;
            }
    }
    }
  
  
        
   // public static boolean executeOnce=true;
    /** Update Service Prep metadata fields and makes the form readOnly **/
    @AuraEnabled
    public static void servicePrepForm(String currentTab, String spFormId, String btnName) { 
     //   executeOnce = false;
        System.debug(currentTab);
        System.debug(btnName);
        boolean acq_Tab_Static=false;
        boolean des_Tab_Static=false;
        boolean edi_Tab_Static=false;
         Service_Prep__c spForm = [Select Id,Project__c,Acquistion_Tab_Static__c,Status__c,Project__r.Title__r.Name,Project__r.Name,
                 Project__r.Title__r.Production_Manager__c,Project__r.Title__r.Current_Editor__c,Project__r.Title__r.Marty_Title_ID__c,
                 LastModifiedBy.Name,LastModifiedDate, Design_Scheduling_Tab_Static__c,Editorial_Tab_static__c,Service_Id_s_Created__c
                 from Service_Prep__c where id=:spFormId limit 1];
        if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Acquisition')) {
            spForm.Acquistion_Tab_Static__c = true;
            acq_Tab_Static = true;
            des_Tab_Static = false;
            edi_Tab_Static = false;
            acquiringEditorStaticMail(spForm);
        }
        if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Design'))  //if(btnName == 'Create Services' || btnName == 'Review and Complete')
            if(btnName == 'Review and Complete') { //Design tab static when clicked on 'Review & Complete'
                spForm.Design_Scheduling_Tab_Static__c = true;
                des_Tab_Static = true;
            }
        if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Editorial')) 
            if(btnName == 'Review and Complete') { //Editorial tab static when clicked on 'Review & Complete'
                spForm.Editorial_Tab_static__c= true;    
                edi_Tab_Static = true;
            } 
        if(!String.isBlank(spForm.Status__c)  && spForm.Status__c.containsignoreCase('New')) //form status change 
            spForm.status__c='In Progress';
        if(spForm.Status__c.containsignoreCase('In Progress') && acq_Tab_Static
           && des_Tab_Static && edi_Tab_Static)
            spForm.status__c='Completed';
        update spForm;
       // updateSpMap.put(spForm.id,spForm);
       // update 
        System.debug(updateSpMap);
    }
    
    /** Editorial,Design tab static when acquistion is non-static**/
    public static void tabStatic(Service_Prep__c spForm) {
        
        if(!spForm.Acquistion_Tab_Static__c) {
            lwcRes.des_Tab_Static = true;
            lwcRes.edi_Tab_Static = true;
        }
    }
    
    public static Map<String,Service_Prep__c> updateSpMap = new Map<String,Service_Prep__c>();
    static map<String,Project_Services__c> existingPSsmap = new map<String,Project_Services__c>();
    
    public static String proManager;
    /** Send email to production manager when acquisition tab has been made static  **/
    public static void acquiringEditorStaticMail(Service_Prep__c spForm) {
        System.debug( proManager);
        if(proManager !=null && proManager !='' && allUserIds.isEmpty()) {
            getAllUser(new List<String>{proManager});
        } 
        String emailId;
        String eBody='';
        
        if(allUserIds.containsKey(proManager))
            emailId = allUserIds.get(proManager).Email; 
        System.debug(emailId);
        if(emailId!=null) {
            eBody+='Acquistion Questions has been answered and initial services have been scaffolded <br/>';            
            eBody+='Title Name: '+ spForm.Project__r.Title__r.Name +'<br/>' + 'Title Id: '+ spForm.Project__r.Title__r.Marty_Title_ID__c + '<br/>' + 'Project Name: '+ spForm.Project__r.Name;
            eBody+= '<br/> Here is the link to the Service Prep Form<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+ '/apex/PPW_servicePrepForm?id=' +spForm.id+'"> Service Prep Form </a>';
            Messaging.SingleEmailMessage message1 = new Messaging.SingleEmailMessage();
            OrgWideEmailAddress[] orgEmail = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where address = 'kpav321@gmail.com']; 
            message1.toAddresses = new String[] { emailId };
                message1.HtmlBody = eBody; 
            message1.subject = 'Acquisition Services Scaffold'; 
            if(!orgEmail.isEmpty())
                message1.OrgWideEmailAddressId = orgEmail[0].id; 
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message1}); 
        }
    } 
    
    public static Service_Prep__c serPrepFirstTimeServices = new  Service_Prep__c(); 
    
  /** Question static when user fill's the question in design and editorical tab **/
    @testvisible
    private static void questionStatic(String currentTab, Map<String, Service_Prep_Response__c> saveQuestionsResponse) {
        List<Service_Prep_Response__c> resList = new List<Service_Prep_Response__c>();
        if(saveQuestionsResponse!=null) {
            if(!currentTab.equalsignoreCase('Acquisition'))
            for(Service_Prep_Response__c spr: saveQuestionsResponse.values()) {
                spr.Question_Static__c = true;
                resList.add(spr);
            }
         }   
        update resList;
    }
    /** Create,update,delete PS logic  **/    
    public static calloutStatusRes createPsLogicforTabwise(String ctab, Map<String,String> acqQustionsResMap , String projectId, Service_Prep__c sprep, Map<String,
                                                                            List<Service_Prep_Question__c>>createCaseTitle , Map<String, Service_Prep_Response__c> saveQuestionsResponse) {
        calloutStatusRes cres = new calloutStatusRes();
        currentTab = ctab;
        cres.pollerEnabled = true; 
        cres.censhareError = null;
        cres.censhareStatus = true; 
        // censhareError = null;
        cres.censhareNewPs = new set<String>();
        serPrep = sprep;
        psUpTypeQuestions = new Map<String,String>(); // this map can be used for store question numbers for define ps cupdate
        // cres.censhareError = null;
        List<Project_Services__c> newPSList = new List<Project_Services__c>(); 
        set<String> delPsSet = new set<String>(); 
        List<Project_Services__c> finalUpdate = new List<Project_Services__c>(); 
        Map<String,String> updatePswraperlist = new Map<String,String>(); 
        for(Service__c s: [SELECT id,name,Censhare_Template_ID__c,Service_Complexity_Value__c, 
                           Service_Rate_Type__c from Service__c where active__c = true]) 
            serivceName.put(s.Id,s); 
        SerResWrap caseSP = new SerResWrap(); 
        allQuestions = new List<SerResWrap>(); 
      
        
       // if(sprep!=null)// && executeOnce)
           // servicePrepForm(ctab, sprep.id);  // form static 
        
        PPW_ServicePrepFormControllerHelper.pid = ProjectId;
        
        /** Update PS action method  **/
        if(acqQustionsResMap != null) 
            for(String sw : acqQustionsResMap.keyset())
            // mwc create logic from custom meta data
            PPW_ServicePrepFormControllerHelper.psMWCCreate(newPSList,sw, acqQustionsResMap.get(sw)); 
        
        /** Start default Create Ps actions   **/
        if(!String.isBlank(Label.PPW_default_PS_create))
            if(currentTab == 'Acquisition')
            newPSList.addAll(PPW_ServicePrepFormControllerHelper.defaultpsCreate(Label.PPW_default_PS_create,serPrepFirstTimeServices,ProjectId));
        
        
        /** Create ps from title and Asin  **/ 
        if(currentTab == 'Acquisition')
            newPSList.addAll(PPW_ServicePrepFormControllerHelper.psCreation(ProjectId,serPrepFirstTimeServices));
        
        
        list<Project_Services__c> updateAllPS = new List<Project_Services__c>();  
        map<String,Project_Services__c> upsertPSs = new map<String,Project_Services__c>(); 
        
        List<Project_Services__c> delExistingList = new List<Project_Services__c>();
        
        if(upsertPSs.keyset().size()>0)
            updateAllPS.addAll(upsertPSs.values());
        
        /** create ps or update from title mwc value **/     
        updateAllPS=PPW_ServicePrepFormControllerHelper.psMWCUpdate(ProjectId,updateAllPS);
        
        /** update ps from title internal imprint value **/     
        updateAllPS=PPW_ServicePrepFormControllerHelper.psInternalImprintupdate(ProjectId,updateAllPS);
        
        /** update ps based on value in subcategory field in title object  **/
        updateAllPS=PPW_ServicePrepFormControllerHelper.updatePsTileSubCategory(ProjectId,updateAllPS);
        
        updateAllPS = updateThreeOrMoreSameServices(updateAllPS);
        
        updateAllPS = removeDuplicatePs(updateAllPS);
        
        List<Project_Services__c> removedCreatePs = new LIst<Project_Services__c>();
        
        /** Start Delete PS action method  **/
        if(delPsSet.size()>0) {
            for(Project_Services__c ps: updateAllPS)
                if(!delPsSet.contains(ID.valueOf(ps.Service__c)))
                removedCreatePs.add(ps); 
            if(!removedCreatePs.isEmpty())
                updateAllPS = removedCreatePs;
            
        }
        
        honorDependencies(updateAllPS); //honor dependencies field update to true for newely created PS
        
        
        updateAllPS = updateStatusps(updateAllPS); // update ps only for status 'In Planning'
        
        List<project_services__c> centurePss = new List<project_services__c>();
        if(updateAllPS != null)
            centurePss.addall(updateAllPS);
        if(delExistingList != null)
            centurePss.addall(delExistingList);
        
        ppw_censhareConnector ppwCen = new ppw_censhareConnector();
        
        List<Project_Services__c> newPsLst = new List<Project_Services__c>();
        List<Project_Services__c> updatePsLst = new List<Project_Services__c>();
        List<Project_Services__c> updateProTextPsLst = new List<Project_Services__c>();
       // Map<String, List<Service_Prep_Question__c>> updatePsMap = new Map<String, List<String>>();
            
            
        getPSsRecords(updateAllPS,newPsLst,updatePsLst);
        //upsert updateAllPS;
        if(!updatePsLst.isEmpty())
            updatePsLst = promotionalTextUpdateService(updatePsLst,updateProTextPsLst);  // check promotional services for update pses
        // update record censhare call out
        if(!updatePsLst.isEmpty() && updatePsLst.size()>0) {
            
            for(Project_Services__c ps: updatePsLst) 
                ps.Censhare_XML_update_type__c = ''; 
            String existingPsxml = ppwCen.censhareXMLBuilder(updatePsLst); // xml builder for existing pses 
            ppw_censhareConnector.resWrap rwrp;
            system.debug(existingPsxml);
            if(!test.isRunningTest())
                rwrp = ppw_censhareConnector.censhareServiceSync(existingPsxml); // censhare Callout for update 
            Map<String,Project_Services__c> psMap = new Map<String,Project_Services__c>(); 
            if(test.isRunningTest()) { 
                rwrp = new ppw_censhareConnector.resWrap(); 
                if(cres.pollerEnabled == true) 
                    rwrp.resStatus = false; 
                else
                    rwrp.resStatus = true;
                updatePsLst = [SELECT id,Estimated_Start_Date__c,Service__r.Name,Estimated_Completion_Date__c,SPQ_Number__c,Censhare_XML_update_type__c, 
                               Censhare_Asset_ID__c, Project__r.title__c FROM Project_Services__c where id=:updatePsLst]; 
                for(Project_Services__c ps: updatePsLst)
                    psMap.put(ps.id,ps);
                rwrp.resPs = psMap;
            }
            if(rwrp != null) {
                if(rwrp.resStatus == false) { 
                    cres.pollerEnabled = false; 
                    cres.censhareStatus = false;
                    if(rwrp.resErrorMes !=null) 
                        cres.censhareError = rwrp.resErrorMes;
                    else
                        cres.censhareError= 'Censhare Service Callout has been failed please contact your system administrator';
                    //censhareError= 'Job Failed';
                    for(Project_Services__c ps: updatePsLst)
                        if(ps.SPQ_Number__c!=null)
                        cres.censhareError = cres.censhareError + '\n' +ps.SPQ_Number__c ;
                    
                    system.debug(cres.censhareError); 
                    return null; 
                }
                for(Project_Services__c ps: updatePsLst) { 
                    if(rwrp != null) 
                        if(rwrp.resPs != null) 
                        if(rwrp.resPs.containsKey(ps.id)) { 
                            ps.Estimated_Start_Date__c = rwrp.resPs.get(ps.id).Estimated_Start_Date__c; 
                            ps.Estimated_Completion_Date__c = rwrp.resPs.get(ps.id).Estimated_Completion_Date__c ; 
                            ps.Censhare_XML_update_type__c = rwrp.resPs.get(ps.id).Censhare_XML_update_type__c ; 
                            ps.Censhare_Asset_ID__c = rwrp.resPs.get(ps.id).Censhare_Asset_ID__c ; 
                           // if(updatePsMap.containsKey(ps.Project__r.title__c))
                           //   updatePsMap.get(ps.Project__r.title__c).add(ps.Id);
                           // else
                            //    updatePsMap.put(ps.Project__r.title__c, new List<String> {ps.Id});
                        } 
                }
                update updatePsLst; // update existing records after censhare call out
               // if(btnName == 'Review and Complete')
                //    servicePrepForm(cTab, sprep.id);
               // update updateSpMap.values(); 
                 questionStatic(currentTab, saveQuestionsResponse); 
            }  // update censhare call out end   
        } else {  
            //if((cres.censhareError ==null || cres.censhareError == '' || cres.censhareError == ' ') && newPsLst.isempty()) {
                questionStatic(currentTab, saveQuestionsResponse); 
               // update updateSpMap.values();
            //}
        }  
        insert newPsLst;
        
        update updateProTextPsLst;
        newPsLst = promotionalTextService(newPsLst);  // check promotional services
        /** Restricts the initial PS creation based on service type to one time **/ 
        if(serPrep.Service_Id_s_Created__c==null || serPrep.Service_Id_s_Created__c=='') 
            newServicesUpdate(updateAllPS); 
        else updateAllPS = removingServices(serPrep.Service_Id_s_Created__c,updateAllPS); 
        
        // new records censhare call out start
        if(!newPsLst.isEmpty())  { 
            for(Project_Services__c ps: newPsLst) {
                ps.Censhare_XML_update_type__c = 'New';
                ps.status__c = 'In Planning';  // set default status value
            }   
            
            String newPsxml = ppwCen.censhareXMLBuilder(newPsLst); // xml builder for new pses
            system.debug(newPsxml);
            for(Project_Services__c ps: newPsLst)
                cres.censhareNewPs.add(ps.id);//newPsLst;                
            if(!test.isRunningTest()) 
                ppw_censhareConnector.censhareServiceMultiple(newPsxml,cres.censhareNewPs); // censhare Callout for insert
            
        } // new records censhare call out end
        //else return null;
        update delExistingList;
        
         if(createCaseTitle!=null)
            createCaseMethod(createCaseTitle);
       // cres.censhareUpdatePs = updatePsMap;
        
        
        if(newPsLst.isEmpty() && updatePsLst.isEmpty())  {
            questionStatic(currentTab, saveQuestionsResponse); 
            update updateSpMap.values();
        }
        
        return cres;    
    }
    
      @testVisible 
    private static List<Project_Services__c> updatestatusps(List<Project_services__c> updateAllPS){
        List<Project_services__c> finalUpdateAllPs = new List<Project_Services__c>();
        for(Project_services__c ps : updateAllPS) { // update ps only for status 'In Planning'
            if(ps.id !=null) { 
                if(ps.status__c == 'In Planning') 
                    finalUpdateAllPs.add(ps); 
            } else
                finalUpdateAllPs.add(ps); 
        }
        return finalUpdateAllPs; 
    }
    
     // check one or more promotinal text service exist or not for update
    public static List<project_services__c>  promotionalTextUpdateService(List<Project_Services__c> upPsLst, List<Project_Services__c> updateProTextPsLst) {
       List<project_services__c> updatedPsLst = new List<project_services__c>();
        List<project_services__c> psLst = [SELECT id,Service__r.Name,Project__c,SPQ_Number__c,Service__c,status__c,Vendor__c, Honor_Dependencies__c FROM project_services__c WHERE Service__r.Name like 'Promo Text Creation' AND Project__c =: ProjectId AND id !=: upPsLst]; // remove all services
        set<String> sIds = new set<String>();
        for(Project_Services__c ps : upPsLst)
           sIds.add(ps.service__c);
           
        Map<String,String> serviceNameMap = new Map<String,String>();
        for(Service__c s: [select id,name from Service__c where id=: sIds])
            serviceNameMap.put(s.id,s.Name);
        
        
        if(!psLst.isEmpty()) { // remove more than one ps
             for(project_services__c ps: upPsLst) { 
                system.debug(ps.Service__r.Name);
               if(serviceNameMap.get(ps.Service__c).Contains('Promo Text Creation')) {
                   updateProTextPsLst.add(ps);
                  system.debug(serviceNameMap.get(ps.Service__c));  
               } else
                   updatedPsLst.add(ps);
             }      
        } else { // keep one ps
            integer keepone = 0;
       
                 for(project_services__c ps: upPsLst) {
                     if(ps.Service__r.Name.Contains('Promo Text Creation')) {
                       if(keepone != 1) {
                            updatedPsLst.add(ps);
                            keepone = 1; 
                        } else {
                            updateProTextPsLst.add(ps);
                          } 
                      } else 
                            updatedPsLst.add(ps);
             
                    }
              
                } 
   
      return updatedPsLst;
    
   }
   
    // check one more promotinal text service exist or not
    public static List<project_services__c>  promotionalTextService(List<Project_Services__c> newPsLst) {
       List<project_services__c> updatedPsLst = new List<project_services__c>();
       List<project_services__c> promoPsLst = new List<project_services__c>();
        List<project_services__c> psLst = [SELECT id,Service__r.Name,Project__c,SPQ_Number__c,Service__c,status__c,Vendor__c, Honor_Dependencies__c FROM project_services__c WHERE Service__r.Name like 'Promo Text Creation' AND Project__c =: ProjectId AND id !=: newPsLst]; // remove all services
        if(!psLst.isEmpty()) { // remove more than one ps
             for(project_services__c ps: [SELECT id,Service__r.Name,Project__c,SPQ_Number__c,Service__c,status__c,Vendor__c, Honor_Dependencies__c FROM project_services__c WHERE id =: newPsLst]) { 
                system.debug(ps.Service__r.Name);
               if(ps.Service__r.Name.Contains('Promo Text Creation')) {
                  system.debug(ps.Service__r.Name);  
               } else
                   updatedPsLst.add(ps);
             }      
        } else { // keep one ps
            integer keepone = 0;
        
            List<project_services__c> newpsProLst = [SELECT id,Service__r.Name,Project__c,SPQ_Number__c,Service__c,status__c,Vendor__c, Service_Type_Complexity__c, 
                                                     Honor_Dependencies__c FROM project_services__c WHERE id =: newPsLst Order by Service__r.Name]; // new ps list query for keep
            if(!newpsProLst.isEmpty()) {
                if(newpsProLst.size() == 1 || newpsProLst.size() == 0) {
                     return newPsLst; 
                 } else {
                      for(project_services__c ps: newpsProLst) 
                         if('Book Tsglines - copyediting, crewation'.equalsIgnoreCase(ps.Service_Type_Complexity__c) && ps.Service__r.Name.Contains('Promo Text Creation'))
                             updatedPsLst.add(ps); //adding promo text service based on service complexity
                     
                          if(updatedPsLst.isEmpty()) { // if promo text is empty than go with normal way add random
                               for(project_services__c ps: newpsProLst) {
                                 if(ps.Service__r.Name.Contains('Promo Text Creation')) {
                                   if(keepone != 1) {
                                        updatedPsLst.add(ps);
                                        keepone = 1; 
                                    }  
                                  } else 
                                        updatedPsLst.add(ps);
                         
                                }
                            } else { // if already added promote text skip other promo text services
                                 for(project_services__c ps: newpsProLst) 
                                    if(ps.Service__r.Name != 'Promo Text Creation') 
                                        updatedPsLst.add(ps);
                               
                               }
                           
                    }    
                }
            } 
   
      return updatedPsLst;
    
   }
   
   
   //censhare call out action poller action method
   @AuraEnabled
    public static calloutStatusRes censhareCalloutStatus(String cTab, List<String> censhareNewPs , String btnName, String servicePrepId) {
             calloutStatusRes cres = new calloutStatusRes();
        try {
     
        currentTab = ctab;
        cres.pollerEnabled = true; 
        cres.censhareError = null;
     
          
            if(censhareNewPs != null && !censhareNewPs.isEmpty()) {
                system.debug(censhareNewPs);
                AsyncApexJob asyncJob = [SELECT id,Status FROM AsyncApexJob WHERE MethodName='censhareServiceMultiple' AND JobType = 'Future' ORDER BY CompletedDate DESC LIMIT 1];
                if(asyncJob.Status == 'Completed') {
                    List<Project_services__c> cNewPs = [SELECT id,Censhare_XML_Error_Response__c,SPQ_Number__c ,Censhare_XML_update_type__c FROM Project_services__c WHERE id =: censhareNewPs];
                    if(cNewPs != null) {
                        if(cNewPs.size()>0) {
                            for(Project_services__c ps1 : cNewPS) {
                                if(String.isNotBlank(ps1.Censhare_XML_Error_Response__c)) {
                                    cres.pollerEnabled = false;
                                   
                                    if(ps1.Censhare_XML_Error_Response__c != 'Job Failed') {
                                        cres.censhareError = 'There is some missing data that is required on censhare side, please contact your system adminstrator for more info.';
                                        cres.censhareError = (!String.isBlank(currentTab) && currentTab.equalsignoreCase('Acquisition'))? cres.censhareError : cres.censhareError +' Specific questions failed are: \n'; 
                                        
                                    
                                    }else
                                        cres.censhareError = ps1.Censhare_XML_Error_Response__c + ' - Empty body response received from censhare side' ; 
                                        
                                    for(Project_Services__c ps: cNewPs)
                                        if(ps.SPQ_Number__c!=null)
                                            cres.censhareError = cres.censhareError +  ps.SPQ_Number__c + ' , ' ;
                                    cres.censhareError = cres.censhareError.removeEnd(', ');
                                    cres.censhareError = cres.censhareError.removeEnd(' ,');
                                    cres.censhareError = cres.censhareError.removeEnd(' , ');
                                   /*  if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Acquisition'))  
                                     acq_Tab_Static = false;
                                     if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Design')) 
                                     des_Tab_Static = false;
                                     if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Editorial')) 
                                     edi_Tab_Static = false; */
                                               
                                       
                                } else{
                                    if(btnName == 'Create Services' || btnName == 'Review and Complete')
                                        servicePrepForm(cTab, servicePrepId, btnName);
                                    cres.pollerEnabled = false;
                                   
                                }
                            }
                            if(cres.censhareError != null && cres.censhareError !='') {
                                delete cNewPs;
                                return null;
                              } else {
                                  update updateSpMap.values();
                                  //questionStatic(); 
                              
                              } 
                        } else {
                            cres.pollerEnabled = false;
                           
                            
                        } 
                    }  else {
                        cres.pollerEnabled = false; 
                     
                        
                    }   
                } else {
                    
                    List<Project_services__c> cNewPs = [SELECT id,Censhare_XML_Error_Response__c ,SPQ_Number__c,Censhare_XML_update_type__c FROM Project_services__c WHERE id =: censhareNewPs LIMIT 1]; 
                    if(cNewPs != null) { 
                        if(cNewPs.size()>0) { 
                            cres.pollerEnabled = true;
                           
                        }else{
                            cres.pollerEnabled = false; 
                           
                        }
                        }else {
                            cres.pollerEnabled = false; 
                          
                        }
                    }
                } else {
                  
                
                       cres.pollerEnabled = false;
                  
                   return cres;
               }
                
            } catch(Exception e) { 
                cres.pollerEnabled = true;  //censhareError
                return cres;
            }
          return cres;  
        }
  
   
   //Service_Prep__c sprep
   // public static boolean pollerEnabled{get;set;}  // censhareAction Poller
   // public static boolean censhareStatus{get;set;}   //censhare Action poller Status  
   
   // public static set<String> censhareNewPs{get;set;}// = new set<String>();  // censhare new ps records
   // public static String censhareError{get;set;}
   
   // get PSs records for new and existing records
    @testVisible
    private static void getPSsRecords(List<Project_Services__c> updateAllPS, List<Project_Services__c> newPsLst,List<Project_Services__c> updatePsLst ) {
        
        for(Project_Services__c ps: updateAllPS) {
            if(ps.id == null) {
                ps.Censhare_XML_update_type__c = 'New';
                newPsLst.add(ps);
            }   
            if(ps.id != null)
                updatePsLst.add(ps);    
        }                                                   
    }
   
   /* @testVisible 
    private static List<Project_Services__c> updatestatusps(List<Project_services__c> updateAllPS){
        List<Project_services__c> finalUpdateAllPs = new List<Project_Services__c>();
        for(Project_services__c ps : updateAllPS) { // update ps only for status 'In Planning'
            if(ps.id !=null) { 
                if(ps.status__c == 'In Planning') 
                    finalUpdateAllPs.add(ps); 
            } else
                finalUpdateAllPs.add(ps); 
        }
        return finalUpdateAllPs; 
    }*/

    /** Save newly created PS in service prep form **/
    @testvisible
    private static void newServicesUpdate(List<Project_Services__c> updateAllPS) {
        serPrepFirstTimeServices.id = serPrep.id;
        update serPrepFirstTimeServices;
        
    } 
    
    /** Remove newly created PSs in update all PS list **/
    @testvisible
    private static List<Project_Services__c> removingServices(String services , List<Project_Services__c> updateAllPS) {
        Set<String> createdServices = new Set<String>();
        List<Project_Services__c> finalList = new List<Project_Services__c>();
        if(services.contains(','))
            createdServices.addAll(services.split(','));
        else createdServices = new Set<String>{services};
            for(Project_Services__c ps: updateAllPS) 
            if(!createdServices.contains(ps.service__c))
            finalList.add(ps);
        if(!finalList.isEmpty())
            updateAllPS = finalList;   
        return updateAllPS;          
        
    } 
    
    /** Update Honor Dependencies **/
    @testvisible
    private static void honorDependencies(List<Project_Services__c> updateAllPS) {
        List<Project_Services__c> updateHonorPsList = new List<Project_Services__c>();  //
        for(Project_Services__c ps : updateAllPS) {
            if(ps.id==null)
                ps.Honor_Dependencies__c = true;
            updateHonorPsList.add(ps);
            
        }
        System.debug(updateHonorPsList);
    }
    
    
    /** Get existing ps map **/
    @testvisible
    private static void getExistingPs(String ProId) {
        if(existingPSsmap.isEmpty())
            existingPSsmap = new map<String,Project_Services__c>([Select id,Project__c,SPQ_Number__c,Service__r.Name,Service__c,status__c,Vendor__c, Honor_Dependencies__c from Project_Services__c
                                                                  where Project__c=:ProId]);
        System.debug(existingPSsmap);        
    }
    
    
    /** Update three or more Same services **/ 
    @testvisible
    private static List<Project_Services__c> updateThreeOrMoreSameServices(List<Project_Services__c> psList1){
        List<Project_Services__c> updateSameServices = new List<Project_Services__c>();
        map<String,String> updateServiceMap = new map<String,String>();
        map<String,integer> countServices = new map<String,integer>();
        map<String,String> services = new map<String,String>();
        map<String,String> needsToUpdateServices = new map<String,String>();
        List<Project_Services__c> psAdditionalList = new List<Project_Services__c>();
        map<String,Project_Services__c> psExistingList = new map<String,Project_Services__c>();
        
        for(Project_Services__c p: psList1)
            if(!String.isBlank(p.id))
            psExistingList.put(p.id,p);   
        
        List<PPW_SPthreeOrMore__mdt> threeorMoreData = [Select id,PS_Greater_Than__c,PS_Less_Than__c,Service_Id_to_Compare__c,Update_Service_to_ID__c
                                                        from PPW_SPthreeOrMore__mdt];
        
        getExistingPs(ProjectId);
        
        if(!psList1.isEmpty())
            psAdditionalList.addAll(psList1);                                                      
        if(!existingPSsmap.isEmpty()) 
            psAdditionalList.addAll(existingPSsmap.values());
        
        
        for(Project_Services__c ps: psAdditionalList) {
            if(countServices.containskey(ps.Service__c))
                countServices.put(ps.Service__c,countServices.get(ps.Service__c)+1);
            else
                countServices.put(ps.Service__c,0);        
        }
        
        System.debug('Three count services'+countServices);
        for(PPW_SPthreeOrMore__mdt pst : threeorMoreData) {
            if(countServices.containsKey(Id.valueOf(pst.Service_Id_to_Compare__c))) {
                System.debug(countServices.get(Id.valueOf(pst.Service_Id_to_Compare__c)));
                System.debug(pst.PS_Greater_Than__c);
                
                if(countServices.get(Id.valueOf(pst.Service_Id_to_Compare__c))>=pst.PS_Greater_Than__c) {
                    services = splitServices(pst.Update_Service_to_ID__c);
                    System.debug('services'+services);   
                    for(Project_Services__c ps: psAdditionalList)
                        if(services.containsKey(ps.Service__c)) 
                        needsToUpdateServices.put(ps.Service__c,services.get(ps.Service__c));
                    
                    
                }
            }
        }
        System.debug('needToUpdateServices'+needsToUpdateServices);
        if(!needsToUpdateServices.isEmpty()) {
            for(Project_Services__c ps: psAdditionalList) 
                if(needsToUpdateServices.containsKey(ps.Service__c)) {
                    ps.Service__c = needsToUpdateServices.get(ps.Service__c);   
                    updateSameServices.add(ps);   
                    
                } else {
                    if(!String.isBlank(ps.id)) {   
                        if(psExistingList.containsKey(ps.id))
                            updateSameServices.add(ps);
                    } else  updateSameServices.add(ps);  
                    
                }
        }   
        System.debug(updateSameServices);        
        System.debug(psList1);
        if(!updateSameServices.isEmpty())
            return updateSameServices;
        else return psList1;
        
        
    }
    
    /** Split(not logic) for Update PS service type **/
    @testvisible
    private static Map<String,String> splitServices(String str) {
        map<String,String> updateServiceMap = new map<String,String>();
        for(String s: str.trim().split(';'))
        {
            List<String> serList = s.trim().split('->');
            if(serList.size()>1) 
                updateServiceMap.put(Id.valueOf(serList[0]),Id.valueOf(serList[1]));
        }    
        return updateServiceMap;
    }
    
    
    /** Remove duplicate logic  **/
    public static List<Project_Services__c> removeDuplicatePs(List<Project_Services__c> psList1){
        set<String> serDuplications = new set<String>();
        
        map<String,Project_Services__c> servicPs = new map<String,Project_Services__c>();
        map<String,Project_Services__c> servicExistingPs = new map<String,Project_Services__c>();
        List<Project_Services__c> PsRemoveDuplications = new List<Project_Services__c>();
        
        for(Project_Services__c ps : psList1)
            servicPs.put(ps.Service__c,ps);
        
        existingPSsmap = new map<String,Project_Services__c>([Select id,Project__c,Service__c,status__c,vendor__c,SPQ_Number__c from Project_Services__c
                                                              where Project__c=:ProjectId]);
        
        
        for(Project_Services__c ps : existingPSsmap.values())          
            if(ps.Service__c != null) 
            servicExistingPs.put(Id.valueOf(ps.Service__c),ps);
        
        for(Project_Services__c ps : servicPs.values())
            if(!servicExistingPs.keyset().isEmpty() && ps.Service__c != null) {
                if(servicExistingPs.containskey(id.valueOf(ps.Service__c)))
                {  
                    
                } else 
                    PsRemoveDuplications.add(ps);    
                
            } else
                PsRemoveDuplications.add(ps);
        
        
        System.debug(PsRemoveDuplications);
        return PsRemoveDuplications;
    }
    
    /** Create ps split logic **/  
    @testvisible
    private List<Project_Services__c> createPSLogic(String response,Service_Prep_Question__c serPrepQuestion) {
        
        System.debug(response);
        System.debug(serPrepQuestion.Name);
        Map<String,List<String>> resServicesMap = new Map<String,List<String>>();
        List<Project_Services__c> createPsList = new List<Project_Services__c>();
        boolean TransmittalMapping = false;
        if(response!=null){
            for(String s: serPrepQuestion.Render_Response__c.split(';')) {
                if(serPrepQuestion.Transmittal_Mapping__c)
                    TransmittalMapping = true;
                if(!String.isBlank(s)){
                    List<String> resServices = s.trim().split('=');
                    if(resServices.size()==2){
                        List<String> SIds = new List<String>();
                        
                        if(resServices[0].containsIgnoreCase(response) || response.containsIgnoreCase(resServices[0])) {
                            if(resServices[1].contains(',')){
                                for(String str: resServices[1].trim().split(','))
                                    SIds.add(str.trim());
                            } else    SIds.add(resServices[1].removeEnd(';'));
                            
                            resServicesMap.put(resServices[0].trim(),SIds);
                        }
                    } 
                }
            }  
            
            for(String str: resServicesMap.keyset()){
                if(str.trim().equalsIgnoreCase(response.trim()) || response.trim().containsIgnoreCase(str.trim()))
                    for(Id id1: resServicesMap.get(str)) {
                        if(serivceName.containskey(id1))
                            createPsList.add(new Project_Services__c(Project__c=ProjectId,Service__c=id1,SPQ_Number__c =serPrepQuestion.Name));
                    }
                System.debug('str'+str);       
            }
        }
        
        System.debug('===='+createPsList);
        return createPsList;
        
    }
    
    
    /** Delete PS split logic **/
    @testvisible 
    Private set<String> deletePSLogic(String response,Service_Prep_Question__c serPrepQuestion){
        Map<String,set<String>> resServicesMap = new Map<String,set<String>>();
        List<Project_Services__c> createPsList = new List<Project_Services__c>();
        for(String s: serPrepQuestion.Delete_Render_Response__c.split(';')){
            if(!String.isBlank(s)){
                List<String> resServices = s.trim().split('=');
                if(resServices.size()==2){
                    set<String> SIds = new set<String>();
                    
                    if( (resServices[0].containsIgnoreCase(response) || response.containsIgnoreCase(resServices[0]))){
                        if(resServices[1].contains(',')){
                            for(String str: resServices[1].trim().split(','))
                                SIds.add(ID.valueOf(str.trim()));
                            resServicesMap.put(resServices[0].trim(),SIds);
                        } else   SIds.add(Id.valueOf(resServices[1].removeEnd(';')));
                        
                        resServicesMap.put(resServices[0].trim(),SIds);
                        
                    }
                }
            } 
        }
        
        
        set<String> serSet = new set<String>();
        for(String s: resServicesMap.keyset())
            serSet.addAll(resServicesMap.get(s));
        
        return serSet;
        
    }
    
   
    
    /** Used to get metdata feilds for service prep form **/
    public static List<Service_Prep__c> getFormDetails() {
       return [Select Id,Project__c,Acquistion_Tab_Static__c,Status__c,Project__r.Title__r.Name,Project__r.Name,
                   Project__r.Title__r.Production_Manager__c,Project__r.Title__r.Current_Editor__c,Project__r.Title__r.Marty_Title_ID__c,
                   LastModifiedBy.Name,LastModifiedDate, Design_Scheduling_Tab_Static__c,Editorial_Tab_static__c,Service_Id_s_Created__c
                   from Service_Prep__c where project__c =:sId limit 1];
    }
    
    public static String ProjectId;
    public static String sId;
    
    public static map<String,List<Service_Prep_Question__c>> serTypeSubQusMap  = new map<String,List<Service_Prep_Question__c>>();
    public map<String,List<Service_Prep_Question__c>> serTypeSubQuestionsMap{get;set;}
   
    
    public class lwcResponseWrp {
    @AuraEnabled public String currentTab{get;set;}
    @AuraEnabled public boolean acq_Tab_Static{get;set;}
    @AuraEnabled public boolean des_Tab_Static{get;set;}
    @AuraEnabled public boolean edi_Tab_Static{get;set;}
    @AuraEnabled public list<Service_Prep__c> serPrep{set;get;}
    @AuraEnabled public list<Service__c> services{set;get;}
    @AuraEnabled public String pmessage{get;set;}
    @AuraEnabled public boolean roleuser{get;set;}
    @AuraEnabled public string btnName{get;set;}
    @AuraEnabled public string CreatePsBtnName{get;set;}
    @AuraEnabled public List<SerResWrap> allQuestions{get;set;}// = new List<SerResWrap>();
    @AuraEnabled public boolean pollerEnabled{get;set;}  // censhareAction Poller
    @AuraEnabled public boolean censhareStatus{get;set;}   //censhare Action poller Status  
    @AuraEnabled public map<String,List<Service_Prep_Question__c>> serTypeSubQuestionsMap{get;set;}
    @AuraEnabled public ApexPages.StandardController std{get;set;}
    @AuraEnabled public map<String,Map<String,SerResWrap>> acquisitionQuestion{get;set;} 
    @AuraEnabled public map<String, Map<String,SerResWrap>> DesignSQuestion{get;set;} 
    @AuraEnabled public map<String, Map<String,SerResWrap>> EditorialSQuestion{get;set;} 
    @AuraEnabled public list<String> acqSubCat{get;set;}
    @AuraEnabled public list<String> desSubCat{get;set;}
    @AuraEnabled public list<String> ediSubCat{get;set;}
    }
     
    
    public static lwcResponseWrp lwcRes = new lwcResponseWrp();//{get;set;}
   // @AuraEnabled public lwcResponseWrp lwcRes1{get;set;}
    /** Constructor, we are framing questions here for display **/
    @AuraEnabled
    public static lwcResponseWrp PPW_ServicePrepFormController_lwc1(String Sid1) { 
       lwcResponseWrp lwcRes1 = new lwcResponseWrp();
       sid = sid1;
    
        lwcRes.CreatePsBtnName = 'Create Services';
        List<String> roles = (Label.PPW_spRoleBsdBtnHde.contains(','))?Label.PPW_spRoleBsdBtnHde.split(','): new List<String>{Label.PPW_spRoleBsdBtnHde};
            List<String> profiles= (Label.PPW_spProfileBsdBtnHide.contains(','))?Label.PPW_spProfileBsdBtnHide.split(','): new List<String>{Label.PPW_spProfileBsdBtnHide};
                List<User> u = [SELECT id FROM user WHERE (UserRole.Name=: roles OR profile.Name =: profiles ) AND Id=:Userinfo.getUserId()];
        if(!u.isEmpty()) {
            lwcRes.roleuser = false;
            lwcRes.CreatePsBtnName = 'Review & Complete';
        }
        else 
            lwcRes.roleuser = true;       
        
        lwcRes.serTypeSubQuestionsMap = new map<String,List<Service_Prep_Question__c>>();
        
        lwcRes.acq_Tab_Static = false;
        lwcRes.des_Tab_Static = false;
        lwcRes.edi_Tab_Static = false;
        if(lwcRes.currentTab == null || lwcRes.currentTab == '')
            lwcRes.currentTab = 'Acquisition';
        
        lwcRes.serPrep = new list<Service_Prep__c>(); 
       
        If(!String.isBlank(sId))     
           lwcRes.serPrep = getFormDetails();
        
        system.debug(lwcRes);
        if(!lwcRes.serPrep.isEmpty()) {
        for(Service_Prep__c sp : lwcRes.serPrep) {
            lwcRes.acq_Tab_Static = sp.Acquistion_Tab_Static__c;
            lwcRes.des_Tab_Static = sp.Design_Scheduling_Tab_Static__c;
            lwcRes.edi_Tab_Static = sp.Editorial_Tab_static__c;
        }  
        lwcRes.services =  [SELECT id,name,Censhare_Template_ID__c,Service_Complexity_Value__c, 
                           Service_Rate_Type__c from Service__c where active__c = true];
        tabStatic(lwcRes.serPrep[0]); //Editorial,design tab static when acquisition tab is non-static 
        
        Set<Id> questionids = new set<id>();
        System.debug('serPrep'+lwcRes.serPrep);
        list<Service_Prep_Response__c>  serPrepResp = [Select id,Service_Prep__c,Name,Service_Prep_Question__c,Question_Static__c ,Response_Number__c,
                                                       Response__c from Service_Prep_Response__c where Service_Prep__c=: lwcRes.serPrep];
        
        for(Service_Prep_Response__c sp : serPrepResp){
            if(sp.Service_Prep_Question__c!=null)
                questionids.add(sp.Service_Prep_Question__c);
            
        }
      
        questionsFraming(questionids,lwcRes.serPrep); // here questions are framing
        system.debug(lwcRes);
        lwcRes1 = lwcRes;
        }
     //   return JSON.serialize(lwcRes1);
        return lwcRes1;
    }
    
    public static Map<String,List<Decimal>> questionsSort = new Map<String,List<Decimal>>();
    
    /** Sub questions frame **/
    public static List<Service_Prep_Question__c> subQuestionsFrame(List<Service_Prep_Question__c> serPrepQuestion,set<Id> qIds,list<Service_Prep__c> serPrep) {
        
        return [Select id,Name,Active__c,Locale__c,Option_Values__c,Order__c,
                Question__c,Question_Category__c,Question_Type__c,Sub_Category__c,
                Render_type__c,Render_Response__c,Service_Prep_Parent_Question__c,Title_Response_Value__c,
                Create_Case__c, Update_Render_Type__c,Update_Render_Response__c,
                Delete_Render_type__c,Delete_Render_Response__c,Sub_Question_Render__c,
                Transmittal_Mapping__c,Help_Text__c,Help_Link__c, Order_Text__c,
                (Select id,Response__c,Response_Number__c,Name,
                 Service_Prep__r.Project__r.Title__c,Service_Prep__r.Project__r.Title__r.Acquiring_Editor__c,
                 Service_Prep__r.Project__r.Title__r.Production_Manager__c,
                 Service_Prep__r.Acquistion_Tab_Static__c,
                 Service_Prep__r.Editorial_Tab_static__c,
                 Service_Prep__r.Design_Scheduling_Tab_Static__c,
                 Service_Prep__r.Project__r.Title__r.Current_Editor__c, 
                 Service_Prep__r.Project__r.Title__r.Internal_Imprint__c,Question_Static__c ,
                 Service_Prep__r.Project__r.Title__r.Literary_Form__c
                 from Service_Prep_Responses__r where 
                 Service_Prep__c=:serPrep Limit 1)
                from Service_Prep_Question__c  where id=:qIds and 
                Service_Prep_Parent_Question__c=: serPrepQuestion and active__c = true order by Sub_Category__c,Order__c];
        
    }
    
    
    /** Framing all the questions into map  **/
    public static void questionsFraming(set<Id> qIds,list<Service_Prep__c> serPrep) {
        lwcRes.acqSubCat = new list<String>();
        lwcRes.desSubCat= new list<String>();
        lwcRes.ediSubCat= new list<String>();
        
        map<String,List<Service_Prep_Question__c>> serTypeQustions  = new map<String,List<Service_Prep_Question__c>>();
        serTypeSubQusMap  = new map<String,List<Service_Prep_Question__c>>();
        list<Service_Prep_Question__c> serPrepQuestion = [Select id,Active__c,Name,Locale__c,Option_Values__c,Order__c,
                                                          Question__c,Question_Category__c,Question_Type__c,Sub_Category__c,
                                                          Render_type__c,Render_Response__c,Service_Prep_Parent_Question__c,Title_Response_Value__c,
                                                          Create_Case__c, Update_Render_Type__c,Update_Render_Response__c,
                                                          Delete_Render_type__c,Delete_Render_Response__c,Sub_Question_Render__c,
                                                          Transmittal_Mapping__c,Help_Text__c,Help_Link__c, Order_Text__c,
                                                          (Select id,Response__c,Response_Number__c,Service_Prep__r.Project__r.Title__c,
                                                           Service_Prep__r.Project__r.Title__r.Acquiring_Editor__c,Question_Static__c , 
                                                           Service_Prep__r.Project__r.Title__r.Production_Manager__c,Name,
                                                           Service_Prep__r.Project__r.Title__r.Current_Editor__c,
                                                            Service_Prep__r.Acquistion_Tab_Static__c,
                                                             Service_Prep__r.Editorial_Tab_static__c,
                                                             Service_Prep__r.Design_Scheduling_Tab_Static__c,
                                                           Service_Prep__r.Project__r.Title__r.Literary_Form__c,Service_Prep__r.Project__r.Title__r.Internal_Imprint__c
                                                           from Service_Prep_Responses__r where Service_Prep__c=:serPrep Limit 1)
                                                          from Service_Prep_Question__c
                                                          
                                                          where id=:qIds and active__c = true order by Sub_Category__c,Order__c];
                                                          
         
       /*  list<Service_Prep_Question__c> serPrepQuestion1 = [Select id,Active__c,Name,Locale__c,Option_Values__c,Order__c,
                                                          Question__c,Question_Category__c,Question_Type__c,Sub_Category__c,
                                                          Render_type__c,Render_Response__c,Service_Prep_Parent_Question__c,Title_Response_Value__c,
                                                          Create_Case__c, Update_Render_Type__c,Update_Render_Response__c,
                                                          Delete_Render_type__c,Delete_Render_Response__c,Sub_Question_Render__c,
                                                          Transmittal_Mapping__c,Help_Text__c,Help_Link__c,
                                                          (Select id,Response__c,Response_Number__c,Service_Prep__r.Project__r.Title__c,
                                                           Service_Prep__r.Project__r.Title__r.Acquiring_Editor__c,Question_Static__c , 
                                                           Service_Prep__r.Project__r.Title__r.Production_Manager__c,Name,
                                                           Service_Prep__r.Project__r.Title__r.Current_Editor__c,
                                                           Service_Prep__r.Project__r.Title__r.Literary_Form__c,Service_Prep__r.Project__r.Title__r.Internal_Imprint__c
                                                           from Service_Prep_Responses__r where Service_Prep__c=:serPrep Limit 1)
                                                          from Service_Prep_Question__c
                                                          
                                                          where id=:qIds
                                                          and active__c = true order by Sub_Category__c,Order__c];                                                 
                                                          
                               */                           
                                                          
                                                          
                                                          
        for(Service_Prep_Question__c s: serPrepQuestion) {
            acquiringEditor =  s.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Acquiring_Editor__c;
            proManager  =  s.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Production_Manager__c;
            //   System.debug(s);
        }
        
        System.debug(proManager);
        
        for(Service_Prep_Question__c sub : serPrepQuestion) {
            // Case owner Set as Production Manager
            acquiringEditor =  sub.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Acquiring_Editor__c;
            proManager  =  sub.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Production_Manager__c;
            currentEditor  =  sub.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Current_Editor__c;
            if(String.isNotBlank(sub.Service_Prep_Parent_Question__c))
            if(serTypeSubQusMap.containskey(sub.Service_Prep_Parent_Question__c))
                serTypeSubQusMap.get(sub.Service_Prep_Parent_Question__c).add(sub);
            else
                serTypeSubQusMap.put(sub.Service_Prep_Parent_Question__c ,new List<Service_Prep_Question__c>{sub});                                         
            
            
        }                                           
      
        lwcRes.serTypeSubQuestionsMap =  serTypeSubQusMap; 
        lwcRes.acquisitionQuestion = new map<String,map<String,SerResWrap>>();
        lwcRes.DesignSQuestion = new map<String,map<String,SerResWrap>>(); 
        lwcRes.EditorialSQuestion = new map<String,map<String,SerResWrap>>();
        
        /** Main question order  **/
        for(Service_Prep_Question__c spq : serPrepQuestion) {
            questionsSort.put(spq.Sub_Category__c, new List<Decimal>{spq.order__c});
            SerResWrap swrap = new SerResWrap();
            swrap.dependentQ = false;
            
            if(spq.Create_Case__c)
                swrap.createCase= spq.Create_Case__c;
            
            if(spq.Service_Prep_Responses__r.size()>0)
                swrap.serPrepResp = spq.Service_Prep_Responses__r[0];
            swrap.serPrep = serPrep[0];
            
            /** Question type Picklist value **/
            if(spq.Question_Type__c=='Picklist')
            {
                picklistType(swrap,spq);
            }
            /** Question type MulitiSelect Picklist value **/
            if(spq.Question_Type__c=='Picklist (Multi-Select)')
            {
                mulitiSelectType(swrap,spq);
            }
            
            /** Question type number  **/
            if(spq.Question_Type__c=='Number')
            {
                swrap.serPrepResp.Response__c = String.valueOf(swrap.serPrepResp.Response_Number__c);
            }
             swrap.isDisplay =  String.isNotBlank(spq.Service_Prep_Parent_Question__c)? false : true;
            if(spq.Question_Category__c == 'Acquisition') {//Questions frame by acquisition tab 
             
                swrap.serPrepQuestion =  spq;
               
                if(lwcRes.acquisitionQuestion.containskey(spq.Sub_Category__c))
                    lwcRes.acquisitionQuestion.get(spq.Sub_Category__c).put(spq.id, swrap);
                else
                    lwcRes.acquisitionQuestion.put(spq.Sub_Category__c, new Map<String,SerResWrap> { spq.id => swrap});
                
            } 
            if(spq.Question_Category__c == 'Design Scheduling') {//Questions frame by design tab
               
                swrap.serPrepQuestion =  spq;
                if( lwcRes.DesignSQuestion.containskey(spq.Sub_Category__c))
                    lwcRes.DesignSQuestion.get(spq.Sub_Category__c).put(spq.id, swrap);
                else
                    lwcRes.DesignSQuestion.put(spq.Sub_Category__c, new Map<String,SerResWrap> { spq.id => swrap});
                
                
            } 
            if(spq.Question_Category__c == 'Editorial Scheduling') { //Questions frame by editorial tab
              
                swrap.serPrepQuestion =  spq;
                if(lwcRes.EditorialSQuestion.containskey(spq.Sub_Category__c))
                    lwcRes.EditorialSQuestion.get(spq.Sub_Category__c).put(spq.id, swrap);
                else
                    lwcRes.EditorialSQuestion.put(spq.Sub_Category__c, new Map<String,SerResWrap> { spq.id => swrap});
                
            }        
            
            if(swrap.subQuestionsWrap!=null && !swrap.subQuestionsWrap.keyset().isempty()) {
                list<String> itemsAll = new list<String>();
                itemsAll.addAll(swrap.subQuestionsWrap.keyset());
                swrap.subQuestionCat =itemsAll[0];
            }
            
        } 
        
        /** Dependent Questions Order **/
        
        for(Service_Prep_Question__c spq : serPrepQuestion) {
            SerResWrap swrap = new SerResWrap();
            swrap.dependentQ = false;
            
            if(spq.Create_Case__c)
                swrap.createCase= spq.Create_Case__c;
            
            if(spq.Service_Prep_Responses__r.size()>0)
                swrap.serPrepResp = spq.Service_Prep_Responses__r[0];
            swrap.serPrep = serPrep[0];
            
            
            if(spq.Question_Type__c=='Picklist')
            {
                picklistType(swrap,spq);
            }
            
            if(spq.Question_Type__c=='Picklist (Multi-Select)')
            {
                mulitiSelectType(swrap,spq);
            }
            
            if(spq.Question_Type__c=='Number')
            {
                swrap.serPrepResp.Response__c = String.valueOf(swrap.serPrepResp.Response_Number__c);
            }
            
            if(spq.Question_Category__c == 'Acquisition')
            {
                if(serTypeSubQusMap.containskey(spq.Id)) {
                    
                    subDependentQuestionsFrame(serTypeSubQusMap,spq,swrap);
                    
                }
                
            } 
            if(spq.Question_Category__c == 'Design Scheduling')
            {
                if(serTypeSubQusMap.containskey(spq.Id)) {
                    
                    subDependentQuestionsFrame(serTypeSubQusMap,spq,swrap);
                    
                }
                
                
            } 
            if(spq.Question_Category__c == 'Editorial Scheduling')
            {
                
                if(serTypeSubQusMap.containskey(spq.Id))  {
                    subDependentQuestionsFrame(serTypeSubQusMap,spq,swrap);
                }
            } 
         } 
        
       // System.debug('acquisitionQuestion'+acquisitionQuestion);
        if(lwcRes.acquisitionQuestion!=null) {
            lwcRes.acqSubCat.addall(lwcRes.acquisitionQuestion.keyset());
        }
        //System.debug('DesignSQuestion'+DesignSQuestion);
        if( lwcRes.DesignSQuestion!=null) {
            lwcRes.desSubCat.addall(lwcRes.DesignSQuestion.keyset());
        }
        System.debug('EditorialSQuestion'+ lwcRes.EditorialSQuestion);
        
       // for(List<SerResWrap> s: lwcRes.EditorialSQuestion.values())
           // for(SerResWrap s1: s)
           // System.debug(s1.serPrepQuestion);
        
        
        if(lwcRes.EditorialSQuestion!=null) {
            lwcRes.ediSubCat.addall(lwcRes.EditorialSQuestion.keyset());
        }
        
      //  System.debug(acqSubCat+','+desSubCat+','+ediSubCat);
    }
    
    /** Framing sub questions wrapper **/
    public static map<String,List<SerResWrap>> subQuestionsFrame(map<String,List<Service_Prep_Question__c>> subQmap,
                                                          Service_Prep_Question__c subQ,SerResWrap swrap ){
                                                             
                                                           //  lwcRes.acquisitionQuestion,lwcRes.DesignSQuestion,lwcRes.EditorialSQuestion
                                                              map<String,List<SerResWrap>> serSubQ = new map<string,List<SerResWrap>>();
                                                              
                                                              List<SerResWrap> subWrap = new List<SerResWrap>();
                                                              if(subQmap.containsKey(subQ.id))
                                                                  for(Service_Prep_Question__c sq: subQmap.get(subQ.id)) {
                                                                      if(sq.Question_Category__c==subQ.Question_Category__c && sq.Sub_Category__c==subQ.Sub_Category__c && 
                                                                         !String.isBlank(subQ.Sub_Question_Render__c) && subQ.Sub_Question_Render__c.contains(String.valueOf(sq.order__c))) {
                                                                             if(serSubQ.containskey(subQ.Sub_Category__c))
                                                                                 serSubQ.get(subQ.Sub_Category__c).add(subQuestionType(sq,subQ));
                                                                             else
                                                                                 serSubQ.put(subQ.Sub_Category__c, new List<SerResWrap>{subQuestionType(sq,subQ)});     
                                                                             System.debug('serSubQ'+serSubQ);   
                                                                         }  else {
                                                                             swrap.dependentRes = 'Dependent';
                                                                             swrap.dependentQAns = subQ.Sub_Question_Render__c;
                                                                             swrap.dependentQId = sq.Id;
                                                                             swrap.depRenderQId = sq.Id;
                                                                         }
                                                                      }
                                                              return  serSubQ;  
                                                          }
    
    
    /** Framing sub dependent questions wrapper **/
    public static void subDependentQuestionsFrame(map<String,List<Service_Prep_Question__c>> subQmap,Service_Prep_Question__c subQ,SerResWrap swrap){
        map<String,List<SerResWrap>> serSubQ = new map<string,List<SerResWrap>>();
        
        List<SerResWrap> subWrap = new List<SerResWrap>();
        SerResWrap dependentQ = new SerResWrap();
        for(Service_Prep_Question__c sq: subQmap.get(subQ.id)){
            if(sq.Question_Category__c==subQ.Question_Category__c && sq.Sub_Category__c==subQ.Sub_Category__c) {
                
            } else{
                System.debug('DependentPavan');
                dependentQ = subQuestionType(sq,subQ);
                dependentQ.dependentQ = true;
                if(!String.isBlank(subQ.Service_Prep_Responses__r[0].Response__c) && !String.isBlank(subQ.Sub_Question_Render__c) &&
                   subQ.Sub_Question_Render__c.containsignoreCase(subQ.Service_Prep_Responses__r[0].Response__c))
                    dependentQ.dependentRenderQ = false;
                else
                    dependentQ.dependentRenderQ = true;
                
                
                dependentQ.serPrepResp = sq.Service_Prep_Responses__r[0]; 
                if(serTypeSubQusMap.containskey(sq.Id)) {
                    
                    dependentQ.subQuestionsWrap = subQuestionsFrame(serTypeSubQusMap,sq,swrap
                                                                   );
                    dependentQ.subQCat = sq.Sub_Category__c;
                    if(sq.Sub_Question_Render__c!=null)
                        getQuesNumber(dependentQ,sq);
                } 
                
                if(dependentQ.subQuestionsWrap!=null && !dependentQ.subQuestionsWrap.keyset().isempty()) {
                    list<String> itemsAll = new list<String>();
                    itemsAll.addAll(dependentQ.subQuestionsWrap.keyset());
                    dependentQ.subQuestionCat =itemsAll[0];
                }
                
                swrap.dependentQId = sq.Id;
                dependentQ.depRenderQId = sq.Id;
               
                
                swrap.dependentQAns = subQ.Sub_Question_Render__c;
                if(sq.Question_Category__c.containsignorecase('Acquisition')) {//Acquisition dependent questions
                    //acquisitionQuestion,DesignSQuestion,EditorialSQuestion
                  //  if(lwcRes.acquisitionQuestion.containsKey(sq.Sub_Category__c)) {
                      //  lwcRes.acquisitionQuestion.get(sq.Sub_Category__c).add(dependentQ);
                      //  lwcRes.acquisitionQuestion = arrangeSorting(lwcRes.acquisitionQuestion,dependentQ,sq.Sub_Category__c);
                        
                   // } else  lwcRes.acquisitionQuestion.put(sq.Sub_Category__c, new list<SerResWrap>{dependentQ});
                } else {
                    if(sq.Question_Category__c.containsignorecase('Design Scheduling')) {//Design dependent questions
                        
                        if(lwcRes.DesignSQuestion.containsKey(sq.Sub_Category__c)) {
                          //  lwcRes.DesignSQuestion.get(sq.Sub_Category__c).add(dependentQ);
                           // lwcRes.DesignSQuestion = arrangeSorting(lwcRes.DesignSQuestion,dependentQ,sq.Sub_Category__c);
                            //  sWrapMap1.get(sq.Sub_Category__c).add(dependentQ);
                        } //else    lwcRes.DesignSQuestion.put(sq.Sub_Category__c, new list<SerResWrap>{dependentQ});
                    } else 
                        if(sq.Question_Category__c.containsignorecase('Editorial Scheduling')) {//Editorial dependent questions
                            
                            if(lwcRes.EditorialSQuestion.containsKey(sq.Sub_Category__c)) {
                             //   lwcRes.EditorialSQuestion.get(sq.Sub_Category__c).add(dependentQ);
                              ////  lwcRes.EditorialSQuestion = arrangeSorting(lwcRes.EditorialSQuestion,dependentQ,sq.Sub_Category__c);
                            } //else   
                               // lwcRes.EditorialSQuestion.put(sq.Sub_Category__c, new list<SerResWrap>{dependentQ});
                        } 
                }          
            }
        }
    }
    
    /** Arrange sorting order for questions,sub question and dependent question  **/
  /*  public static map<string,List<SerResWrap>>  arrangeSorting(map<string,List<SerResWrap>> sWraMap,SerResWrap dependentQ,String sCat) {
        List<SerResWrap> slist = new List<SerResWrap>();
        for(SerResWrap s: sWraMap.get(sCat))
            slist.add(s);
        
        integer iterationsize = slist.size();
        SerResWrap temp;
        
        for(integer i=0; i < iterationsize; i++){
            for(integer j=1; j < (iterationsize-i); j++){
                
                if(slist[j-1].serPrepQuestion.order__C > slist[j].serPrepQuestion.order__C){
                    temp = slist[j-1];
                    slist[j-1] = slist[j];
                    slist[j] = temp;
                }
            }
        }
        sWraMap.put(sCat,slist);
        return sWraMap;
        
    } */
    
    public static SerResWrap subQuestionType(Service_Prep_Question__c spq,Service_Prep_Question__c parentQ){
        SerResWrap swrap = new SerResWrap();
        
        if(spq.Create_Case__c)
            swrap.createCase= spq.Create_Case__c;
        
        if(spq.Service_Prep_Responses__r.size()>0)
            swrap.serPrepResp = spq.Service_Prep_Responses__r[0];
        swrap.serPrepQuestion =  spq;
        /** Question type Picklist value **/
        if(spq.Question_Type__c=='Picklist')
        {
            picklistType(swrap,spq);
        }
        /** Question type MulitiSelect Picklist value **/
        if(spq.Question_Type__c=='Picklist (Multi-Select)')
        {
            mulitiSelectType(swrap,spq);
        }
        if(spq.Question_Type__c=='Number')
        {
            swrap.serPrepResp.Response__c = String.valueOf(swrap.serPrepResp.Response_Number__c);
        }
        
        return swrap;
    }
    
    public class updatePswrap{
        @AuraEnabled public string oldServiceId{get;set;}
        @AuraEnabled public string newServiceId{get;set;}
        
    } 
    
    /** Multi Select type options  **/  
    public static void mulitiSelectType(SerResWrap swp,Service_Prep_Question__c spq) {
        swp.selectedOpts = new List<string>();
        List<CustomSelectOptions> SelOptions = new List<CustomSelectOptions>();
        /** all option values  **/
        if(spq.Option_Values__c!=null) {
            SelOptions.add(new CustomSelectOptions(' ','--Please Select--'));
            for(String str: spq.Option_Values__c.trim().split(';'))
                SelOptions.add(new CustomSelectOptions(str.trim(),str.trim()));
            
        }
        //swp.resPicklistValues = SelOptions; 
        if(!String.isBlank(spq.Service_Prep_Responses__r[0].response__C)) {
            SelOptions = new List<CustomSelectOptions>();
            String res;
            if(spq.Service_Prep_Responses__r[0].response__c!=null)
                res = spq.Service_Prep_Responses__r[0].response__c.remove('[').remove(']');
            if(res!=null) {
                if(res.contains(';')){
                    for(String s: res.split(';'))
                        swp.selectedOpts.add(s.trim());
                } else   swp.selectedOpts.add(res);
            }
        }
    }
    /** Picklist type options  **/ 
    public static void picklistType(SerResWrap swp,Service_Prep_Question__c spq) {
        List<CustomSelectOptions>SelOptions = new List<CustomSelectOptions>();
        if(spq.Option_Values__c!=null) {
            SelOptions.add(new CustomSelectOptions(' ','--Please Select--')); //dont remove space in picklist backend value
            for(String str: spq.Option_Values__c.trim().split(';'))
                SelOptions.add(new CustomSelectOptions(str.trim(),str.trim()));
            
        }
       // swp.resPicklistValues = SelOptions; 
        
    }
    
    public static Map<String,String> psUpTypeQuestions = new Map<String,String>();
    @testvisible
    /** Split logic for update PS **/
  /*  Private  map<String,String> updatePSLogic(String response,Service_Prep_Question__c serPrepQuestion) {
        map<String,String> upPslist = new map<String,String>();
        updatePswrap ups = new updatePswrap();
        
        List<updatePswrap> tempwrap = new List<updatePswrap>();
        for(String s: serPrepQuestion.Update_Render_Response__c.split(';')){
            if(!String.isBlank(s)){
                List<String> resServices = s.trim().split('=');
                if(resServices.size()==2){
                    List<String> SIds = new List<String>();
                    if(resServices[0].equalsignoreCase(response)){
                        if(resServices[1].contains(',')){
                            for(String str: resServices[1].trim().split(','))
                            {
                                ups = new updatePswrap();
                                List<String> serList = str.trim().split('->');
                                ups.oldServiceId = Id.valueOf(serList[0]);
                                ups.newServiceId = Id.valueOf(serList[1]);
                                System.debug(ups);
                                tempwrap.add(ups);
                            } 
                        } else {
                            resServices[1].trim().removeend(';');
                            ups = new updatePswrap();
                            List<String> serList = resServices[1].split('->');
                            ups.oldServiceId = Id.valueOf(serList[0]);
                            ups.newServiceId = Id.valueOf(serList[1]);
                            System.debug(ups);
                            tempwrap.add(ups);
                            
                        }
                        
                    }   
                    
                }
            }
        } 
        
        System.debug(tempwrap); 
        for( updatePswrap up : tempwrap) {
            upPslist.put(up.oldServiceId,up.newServiceId);
            psUpTypeQuestions.put(up.oldServiceId,serPrepQuestion.Name); 
            }
        System.debug('----'+upPslist);
        return upPslist;
    } */
    /**  Split logic for Order for sub question render type **/
    public static void getQuesNumber(SerResWrap swrap,Service_Prep_Question__c pSub){
        map<String,list<String>> resServicesMap = new map<String,list<String>>();
        System.debug(pSub.Sub_Question_Render__c);
        if(pSub.Sub_Question_Render__c!=null)
            for(String s: pSub.Sub_Question_Render__c.split(';')){
                resServicesMap = new map<String,list<String>>();
                if(!String.isBlank(s)){
                    List<String> resServices = s.trim().split('=');
                    if(resServices.size()==2){
                        
                        List<String> SIds = new List<String>();
                        if(resServices[1].contains(','))
                            for(String s1: resServices[1].trim().split(','))
                            SIds.add(s1.trim());
                        else 
                            SIds.add(resServices[1].trim().removeend(';'));
                        
                        resServicesMap.put(resServices[0].trim(),SIds);
                        if(swrap.serResponse!=null && swrap.serResponse!='')
                            swrap.serResponse = swrap.serResponse.trim()+','+resServices[0].trim();
                        else
                            swrap.serResponse = resServices[0].trim();
                        
                        swrap.subQuestionOrder = resServices[1].trim();
                        swrap.subQOrderMap = resServicesMap;
                    } 
                }
            } 
    }
    
    public class CustomSelectOptions {
    @AuraEnabled public String label {get;set;}
    @AuraEnabled public String value {get;set;}

    public CustomSelectOptions() {
        this.label = '';
        this.value = '';
    }

    public CustomSelectOptions(String lab, String val) {
        this.label = lab;
        this.value = val;
    }
    }
    
    /** Wrapper used for framing different questions based on response type **/  
    public class SerResWrap {
        @AuraEnabled public Service_Prep__c serPrep{get;set;}
       // @AuraEnabled public boolean parentQustion{get{return false;}set;}
        @AuraEnabled public Service_Prep_Response__c serPrepResp{get;set;}
        @AuraEnabled public Service_Prep_Question__c serPrepQuestion{get;set;}
       // @AuraEnabled public boolean isDisplay{get {return false;}set { isDisplay = value;}}
         @AuraEnabled public boolean isDisplay{get;set;}
        @AuraEnabled public boolean createCase{get{return false;}set;}
        @AuraEnabled public String responseType{get;set;}
        @AuraEnabled public List<CustomSelectOptions> resPicklistValues{get;set;}
        @AuraEnabled public List<String> selectedOpts{get;set;}
        @AuraEnabled public Map<String,List<SerResWrap>> subQuestionsWrap{get;set;}
        @AuraEnabled public String subQCat{get;set;}
        @AuraEnabled public String serResponse{get;set;}
        @AuraEnabled public String subQuestionOrder{get;set;}
        @AuraEnabled public Map<String,List<String>> subQOrderMap{get;set;}
        @AuraEnabled public String dependentRes{get;set;}
        @AuraEnabled public String subQuestionCat{get;set;}
        @AuraEnabled public boolean dependentQ{get;set;}
        @AuraEnabled public boolean dependentRenderQ{get;set;}
        @AuraEnabled public String dependentQId{get;set;}
        @AuraEnabled public String depRenderQId{get;set;}
        @AuraEnabled public String dependentQAns{get;set;}
        @AuraEnabled public Service_Prep_Response__c parentPrepResp{get;set;}
        @AuraEnabled public Map<String,SerResWrap> parentQuestion{get;set;}
        @AuraEnabled public String parentQResp{get;set;}
        @AuraEnabled public String pCat{get;set;}
        @AuraEnabled public String pSCat{get;set;} 
        
    }
    
  
  }