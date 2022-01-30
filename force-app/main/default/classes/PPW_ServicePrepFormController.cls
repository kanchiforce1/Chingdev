/***********************************
Author:      Amazon Apub // kkolla@
Used By:     custom page controller used in PPW_servicePrepForm page
Description: Controller for PPW ServicePrepForm Form, linked to the project page
************************************/

public class PPW_ServicePrepFormController{
    
    public String currentTab{get;set;}
    public boolean acq_Tab_Static{get;set;}
    public boolean des_Tab_Static{get;set;}
    public boolean edi_Tab_Static{get;set;}
    public list<Service_Prep__c> serPrep{set;get;}
    public String pmessage{get;set;}
    public boolean roleuser{get;set;}
    public string btnName{get;set;}
    public string CreatePsBtnName{get;set;}
    public static Map<String,User> allUserIds = new Map<String,User>();
    public String acquiringEditor;  
    public String currentEditor;
    public Static boolean savemethodExecuteOnce=true;
    public set<String> subQuestions = new set<String>();
    public List<SerResWrap> allQuestions{get;set;}// = new List<SerResWrap>();
    map<id,Service_Prep_Response__c> responsesList;
    public map<String,Service__C> serivceName = new map<String,Service__C>();
    map<String,Service_Prep_Response__c> responseMap = new  map<String,Service_Prep_Response__c>();
    /** Indicate the current tab that user is in Service Prep Form **/
    public void currentTab() {
        System.debug('SetCurrent Tab'+currentTab);
        btnName = '';
    }
    /** Cancel service prep form **/  
    public PageReference Cancel() {
        return null;
    }
    /** Action poller tag apex action method  **/   
    public void autoSaveForm(){  
        System.debug('Auto Save');
        SaveForm();
    }
    
    /**  This method executes when the save button is clicked from the V.F page. Also executes 
         censhare callout method for sending new or exisitng records for tab is !=Acquisition, If tab is 
         Acquisition callout happens from the page when user confirms the tab static alert **/
    
    public void SaveForm() {  
        System.debug('currentTab'+currentTab);
        if(!currentTab.equalsignoreCase('Acquisition')) { 
            //CreatePS();
            //questionStatic();
            createPsLogicforTabwise(); //Executes censhare callout method for sending new or exisitng records when tab is !=acquisition
            System.debug('createPsLogicforTabwise');
            pollerEnabled = true;
            SaveFormMethod();
        } else {
            SaveFormMethod();
        }
    }
    
    /** To check for input text if it is a number or not   **/  
    public boolean digitPatternCheck(String str) {
        if(!String.isBlank(str)) {
            Pattern p = Pattern.compile('^[0-9,.]+$');
            Matcher m = p.matcher(str);
            return  m.matches();
        } else  return false;
     }
    
    /** Question static when user fill's the question in design and editorical tab **/
    @testvisible
    private void questionStatic() {
        map<id,Service_Prep_Response__c> responsesList = new map<id,Service_Prep_Response__c>();
        responseMap = new  map<String,Service_Prep_Response__c>();
        if(currentTab.equalsignoreCase('Acquisition')) 
            saveAcquistion(); 
        if(currentTab.equalsignoreCase('Design')) 
            saveDesign();
        if(currentTab.equalsignoreCase('Editorial')) 
            saveEditorial(); 
        system.debug(allQuestions); 
        
        for(SerResWrap sw : allQuestions) {
            system.debug(sw.serPrepQuestion.order__c);
            system.debug(sw.serPrepQuestion.Name);
            System.debug('sr.Response__c'+sw.serPrepResp.Response__c); 
            if(sw.serPrepQuestion.Question_Type__c == 'Number') { // Check response value of question is of number type
                
                sw.serPrepResp.Response__c = String.valueOf(sw.serPrepResp.Response_Number__c);
                if(sw.serPrepResp.Response_Number__c!=null)
                    sw.serPrepResp.Question_Static__c = true;
            }
            if(sw.serPrepQuestion.Question_Type__c == 'Checkbox') // Check response value of question is of checkbox type
                
                if(sw.serPrepResp.Response__c!=null)
                if(sw.serPrepResp.Response__c == 'true')
                sw.serPrepResp.Question_Static__c = true;                                            
            
            System.debug(sw.serPrepQuestion.Question_Type__c);
            if(sw.serPrepQuestion.Question_Type__c == 'Picklist (Multi-Select)') { //Check response value of question is of Picklist (Multi-Select) type
                system.debug(sw.serPrepQuestion.order__c);
                
                if(sw.selectedOpts!=null)
                    if(!sw.selectedOpts.isEmpty()) {
                        String repval = '';
                        for(String so : sw.selectedOpts) {
                            if(!String.isBlank(repval))
                                repval=repval+';'+so;
                            else repval = so;
                        }
                        
                    }
                if(sw.selectedOpts!=null)
                    if(!sw.selectedOpts.isEmpty())
                    sw.serPrepResp.Question_Static__c = true;
                
            } 
            //Check response value for types other than Number, Checkbox, Picklist (Multi-Select)
            if(sw.serPrepQuestion.Question_Type__c != 'Number' && sw.serPrepQuestion.Question_Type__c != 'Checkbox' && sw.serPrepQuestion.Question_Type__c != 'Picklist (Multi-Select)') {
                if(sw.serPrepResp.Response__c!=null && sw.serPrepResp.Response__c!='' && sw.serPrepResp.Response__c!=' ')
                    sw.serPrepResp.Question_Static__c = true;                                        
            }
            System.debug('sw.serPrepResp.Response__c'+sw.serPrepQuestion.name+',,,'+sw.serPrepResp.Response__c+sw.serPrepResp.Id);
            responsesList.put(sw.serPrepResp.id,sw.serPrepResp);
            
            if(sw.serPrepQuestion.Question_Type__c == 'Number') {
                if(responseMap!=null) 
                    if(responseMap.containskey(sw.serPrepResp.id)) {
                        System.debug(sw.serPrepResp.Response_Number__C);
                        if(responseMap.get(sw.serPrepResp.id).Response_Number__C!=null)
                            sw.serPrepResp.Question_Static__c = true;
                    }
            }
            
            if(responseMap!=null) 
                if(responseMap.containskey(sw.serPrepResp.id)) {
                    if(responseMap.get(sw.serPrepResp.id).Response__c!=null && responseMap.get(sw.serPrepResp.id).Response__c!='' && responseMap.get(sw.serPrepResp.id).Response__c!=' ')
                        sw.serPrepResp.Question_Static__c = true;
                    System.debug(sw.serPrepResp.Response__c);
                }
            responsesList.put(sw.serPrepResp.id,sw.serPrepResp);
            
            System.debug(sw.serPrepResp);   
        }
        update responsesList.values();   
    } 
    /** Method used to retrieve the responses from the vfpage to save it at database level **/
    @testvisible
    private PageReference SaveFormMethod() {  // Save logic method
        
        map<id,Service_Prep_Response__c> responsesList = new map<id,Service_Prep_Response__c>();
        responseMap = new  map<String,Service_Prep_Response__c>();
        
        if(currentTab.equalsignoreCase('Acquisition'))
            saveAcquistion(); // get's the acquisition tab responses
        if(currentTab.equalsignoreCase('Design'))
            saveDesign(); // get's the design tab responses
        if(currentTab.equalsignoreCase('Editorial'))
            saveEditorial(); // get's the Editorial tab responses
        if(!subQuestions.isEmpty())
            responseMap = new map<String,Service_Prep_Response__c>([Select id,Name,Response_Number__c,Response__c,Question_Static__c from Service_Prep_Response__c where id=:subQuestions ]);
        System.debug(responseMap);
        for(SerResWrap sw : allQuestions){
            
            if(!responseMap.containskey(sw.serPrepResp.id) || responseMap == null) { 
                if(sw.serPrepQuestion.Question_Type__c == 'Number' && sw.serPrepResp.Response_Number__c != null) {
                    sw.serPrepResp.Response__c = String.valueOf(sw.serPrepResp.Response_Number__c);
                }
                if(sw.serPrepQuestion.Question_Type__c == 'Checkbox') {
                    sw.serPrepResp.Response__c = String.valueOf((sw.serPrepResp.Response__c!=null)?
                                                                sw.serPrepResp.Response__c : 'false');
                    
                }                                                 
                
                if(sw.serPrepQuestion.Question_Type__c == 'Picklist (Multi-Select)') {
                    
                    if(sw.selectedOpts!=null)
                        if(!sw.selectedOpts.isEmpty()) {
                            String repval = '';
                            for(String so : sw.selectedOpts) {
                                if(!String.isBlank(repval))
                                    repval=repval+';'+so;
                                else repval = so;
                            }
                            sw.serPrepResp.Response__c = repval;     
                        }
                    
                    
                }
                if(sw.serPrepQuestion.Question_Type__c != 'Number' && sw.serPrepQuestion.Question_Type__c != 'Checkbox' && sw.serPrepQuestion.Question_Type__c != 'Picklist (Multi-Select)') 
                    sw.serPrepResp.Response__c = String.valueOf((sw.serPrepResp.Response__c!=null)?
                                                                sw.serPrepResp.Response__c : '');
                System.debug('sw.serPrepResp.Response__c'+sw.serPrepQuestion.name+',,,'+sw.serPrepResp.Response__c+sw.serPrepResp.Id);
                
                responsesList.put(sw.serPrepResp.id,sw.serPrepResp);
            } else{
                if(responseMap.containskey(sw.serPrepResp.id)) {
                    if(sw.serPrepQuestion.Question_Type__c == 'Number') {
                        sw.serPrepResp.Response_Number__C = responseMap.get(sw.serPrepResp.id).Response_Number__C;
                        sw.serPrepResp.Response__c = responseMap.get(sw.serPrepResp.id).Response_Number__C!=null? String.valueOf(responseMap.get(sw.serPrepResp.id).Response_Number__C) : '';
                        
                    } else {
                        if(sw.serPrepQuestion.Question_Type__c == 'Picklist (Multi-Select)') {
                            
                            if(sw.selectedOpts!=null)
                                if(!sw.selectedOpts.isEmpty()) {
                                    String repval = '';
                                    for(String so : sw.selectedOpts) {
                                        if(!String.isBlank(repval))
                                            repval=repval+';'+so;
                                        else repval = so;
                                    }
                                    sw.serPrepResp.Response__c = repval;     
                                }
                            
                        }
                        else {  
                            
                            sw.serPrepResp.Response__c = responseMap.get(sw.serPrepResp.id).Response__c;
                        }
                        
                    }
                    responsesList.put(sw.serPrepResp.id,sw.serPrepResp);
                }
                
            }
        }
        
        System.debug(responseMap);
        
        update responsesList.values();  // responses of the current tab are getting saved here
        getFormDetails(); //used to render the form to update system metadata fields
        savemethodExecuteOnce = false;
        return null; 
    }
    
    /* Pulls the responses specific to Acquisition tab */
    @testvisible
    private void saveAcquistion(){ 
        allQuestions = new List<SerResWrap>();
        subQuestions = new Set<String>();
        for(List<SerResWrap> sr : acquisitionQuestion.values())
            allQuestions.addall(sr);
        
        List<SerResWrap> allQTemp =new List<SerResWrap>(); 
        
        for(SerResWrap sw: allQuestions)
            if(sw.subQuestionsWrap!=null) 
            for(List<SerResWrap> sr : sw.subQuestionsWrap.values()) 
            for(SerResWrap s: sr) 
            if(serTypeSubQusMap!=null)
            if(serTypeSubQusMap.containskey(sw.serPrepQuestion.id))
            if(sw.serPrepQuestion.Question_Category__c==s.serPrepQuestion.Question_Category__c &&
               sw.serPrepQuestion.Sub_Category__c==s.serPrepQuestion.Sub_Category__c && 
               !String.isBlank(sw.serPrepQuestion.Sub_Question_Render__c) &&
               !String.isBlank(sw.serPrepResp.Response__c) &&
               sw.serPrepQuestion.Sub_Question_Render__c.contains(String.valueOf(s.serPrepQuestion.order__c))) {
                   
                   if(sw.serPrepQuestion.Question_Type__c == 'Picklist (Multi-Select)') {
                       
                       if(sw.selectedOpts!=null)
                           if(!sw.selectedOpts.isEmpty()) 
                           for(String so : sw.selectedOpts) 
                           if(sw.serPrepQuestion.Sub_Question_Render__c.contains(so))
                       {
                           allQTemp.add(s);  
                           subQuestions.add(s.serPrepResp.Id);
                           break;   
                       }
                       
                   } else{
                       
                       if(sw.serPrepQuestion.Sub_Question_Render__c.contains(String.valueOf(sw.serPrepResp.Response__c))) {
                           
                           allQTemp.add(s);  
                           subQuestions.add(s.serPrepResp.Id);                    
                       }
                   }
                   
               }
        
        allQuestions.addAll(allQTemp);
        
    }
    
    /* Pulls the responses specific to Design tab */ 
    @testvisible
    private void saveDesign(){
        allQuestions = new List<SerResWrap>();
        subQuestions = new Set<String>();
        
        
        for(List<SerResWrap> sr : DesignSQuestion.values())
            allQuestions.addall(sr);
        
        List<SerResWrap> allQTemp =new List<SerResWrap>(); 
        
        for(SerResWrap sw: allQuestions)
            if(sw.subQuestionsWrap!=null) 
            for(List<SerResWrap> sr : sw.subQuestionsWrap.values()) 
            for(SerResWrap s: sr) 
            if(serTypeSubQusMap!=null)
            if(serTypeSubQusMap.containskey(sw.serPrepQuestion.id))
            if(sw.serPrepQuestion.Question_Category__c==s.serPrepQuestion.Question_Category__c &&
               sw.serPrepQuestion.Sub_Category__c==s.serPrepQuestion.Sub_Category__c && 
               !String.isBlank(sw.serPrepQuestion.Sub_Question_Render__c) &&
               
               sw.serPrepQuestion.Sub_Question_Render__c.contains(String.valueOf(s.serPrepQuestion.order__c))) {
                   
                   if(sw.serPrepQuestion.Question_Type__c == 'Picklist (Multi-Select)') {
                       System.debug(sw.selectedOpts);
                       if(sw.selectedOpts!=null)
                           if(!sw.selectedOpts.isEmpty()) 
                           for(String so : sw.selectedOpts) 
                           if(sw.serPrepQuestion.Sub_Question_Render__c.contains(so))
                       {
                           allQTemp.add(s);  
                           subQuestions.add(s.serPrepResp.Id);
                           break;   
                       }
                       
                   } else{
                       if(!String.isBlank(sw.serPrepResp.Response__c))
                           if(sw.serPrepQuestion.Sub_Question_Render__c.contains(String.valueOf(sw.serPrepResp.Response__c))) {
                               
                               allQTemp.add(s);  
                               subQuestions.add(s.serPrepResp.Id);                    
                           }
                   }
                   
               }
        
        System.debug(subQuestions);
        allQuestions.addAll(allQTemp); 
        
        
    }
    
    /* Pulls the responses specific to editorial tab */
    @testvisible
    private void saveEditorial(){
        allQuestions = new List<SerResWrap>();
        subQuestions = new Set<String>();
        
        for(List<SerResWrap> sr : EditorialSQuestion.values())
            allQuestions.addall(sr);    
        
        List<SerResWrap> allQTemp =new List<SerResWrap>(); 
        
        for(SerResWrap sw: allQuestions)
            if(sw.subQuestionsWrap!=null) 
            for(List<SerResWrap> sr : sw.subQuestionsWrap.values()) 
            for(SerResWrap s: sr) 
            if(serTypeSubQusMap!=null)
            if(serTypeSubQusMap.containskey(sw.serPrepQuestion.id))
            if(sw.serPrepQuestion.Question_Category__c==s.serPrepQuestion.Question_Category__c &&
               sw.serPrepQuestion.Sub_Category__c==s.serPrepQuestion.Sub_Category__c && 
               !String.isBlank(sw.serPrepQuestion.Sub_Question_Render__c) &&
               !String.isBlank(sw.serPrepResp.Response__c) &&
               sw.serPrepQuestion.Sub_Question_Render__c.contains(String.valueOf(s.serPrepQuestion.order__c))) {
                   
                   if(sw.serPrepQuestion.Question_Type__c == 'Picklist (Multi-Select)') {
                       
                       if(sw.selectedOpts!=null)
                           if(!sw.selectedOpts.isEmpty()) 
                           for(String so : sw.selectedOpts) 
                           if(sw.serPrepQuestion.Sub_Question_Render__c.contains(so))
                       {
                           allQTemp.add(s);  
                           subQuestions.add(s.serPrepResp.Id);
                           break;  
                       }
                       
                   } else{
                       
                       if(sw.serPrepQuestion.Sub_Question_Render__c.contains(String.valueOf(sw.serPrepResp.Response__c))) {
                           
                           allQTemp.add(s);  
                           subQuestions.add(s.serPrepResp.Id);                    
                       }
                   }
                   
               }
        
        allQuestions.addAll(allQTemp);
    }
    
    /** Get all active user's emails based on nickname **/
    public void getAllUser(List<String> nickName) {
        for(User u : [SELECT CommunityNickname,Email, Id FROM User where isActive = true and CommunityNickname=:nickName limit 4999]) 
            allUserIds.put(u.CommunityNickname,u);
        
    }  
    
    /** Create a case based on the user response and assigns it to the Production manager for the respective title (internal imprint!=two lions)  **/ 
    public void createCaseMethod(SerResWrap caseSP){
        if(caseSP.serPrepResp.Response__c!=null)
            if(caseSP.serPrepResp.Response__c.equalsignoreCase('No')){
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
                } 
                
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
                List<Case> existingCases = [SELECT id,RecordTypeId from Case where (ownerId=:ownerId OR ownerId=:acqEditorQId) AND RecordTypeId =: Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Manuscript_Submission').getRecordTypeId() AND Title__c =: caseSP.serPrepResp.Service_Prep__r.Project__r.Title__c];
                if(existingCases.size()>0){} 
                else {
                    String description = 'Here are the details for the case origin \n'+'Category: '+caseSP.serPrepQuestion.Question_Category__c +'\n'+
                        'Sub Category: '+ caseSP.serPrepQuestion.Question_Category__c + '\n'+
                        'Question Number: '+caseSP.serPrepQuestion.name+'\n'+
                        'Question Name: '+caseSP.serPrepQuestion.Question__c+'\n';
                    
                    case ca = new Case(Title__c=caseSP.serPrepResp.Service_Prep__r.Project__r.Title__c,RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Manuscript_Submission').getRecordTypeId(),Priority='Medium',
                                       status='Open',subject='Service/Vendor Approval' , ownerId=ownerId,description1__c=description);
                    insert ca;
                }
            }
    }
    
    /* Not using */
    public map<String,list<String>> getQuesNumber(String str){
        map<String,list<String>> resServicesMap = new map<String,list<String>>();
        for(String s: str.split(';')){
            if(!String.isBlank(s)){
                List<String> resServices = s.trim().split('=');
                if(resServices.size()==2){
                    List<String> SIds = new List<String>();
                    for(String s1: resServices[1].trim().split(','))
                        SIds.add(s1.trim());
                    resServicesMap.put(resServices[0].trim(),SIds);
                } 
            }
        } 
        return resServicesMap;
    }
    
    /* Create's PS based on user response and field value in Literary_form__c in title object */
    @testvisible
    Private List<Project_Services__c> createPSLogicFormLiterary_Form(String Literaryval,String response,Service_Prep_Question__c serPrepQuestion){
        
        Map<String,List<String>> resServicesMap = new Map<String,List<String>>();
        List<Project_Services__c> createPsList = new List<Project_Services__c>();
        boolean TransmittalMapping = false;
        if(response!=null){
            if(!String.isBlank(serPrepQuestion.Title_Response_Value__c))
                for(String s: serPrepQuestion.Title_Response_Value__c.split(';')){
                    if(serPrepQuestion.Transmittal_Mapping__c)
                        TransmittalMapping = true;
                    if(!String.isBlank(s)){
                        List<String> resServices = s.trim().split('=');
                        if(resServices.size()==2){
                            List<String> SIds = new List<String>();
                            String[] litterVal = resServices[0].split('-');
                            System.debug(litterVal);
                            
                            if(litterVal.size() == 2) {
                                System.debug('-->>'+litterVal[1].trim());
                                System.debug('--->>'+response);
                                System.debug('-->>'+litterVal[0].trim());
                                System.debug('--->>'+Literaryval);
                                if( litterVal[1].trim().equalsIgnoreCase(response) && litterVal[0].trim().equalsIgnoreCase(Literaryval) ){
                                    System.debug('Literaryval'+Literaryval);
                                    if(resServices[1].contains(',')){
                                        for(String str: resServices[1].trim().split(','))
                                            SIds.add(str.trim());
                                    } else    SIds.add(resServices[1].removeEnd(';'));
                                    
                                    resServicesMap.put(resServices[0].trim(),SIds);
                                }
                            }   
                        } 
                    }
                }  
            
            for(String str: resServicesMap.keyset()){
                if((str.trim().containsIgnoreCase(response.trim()) || response.trim().containsIgnoreCase(str.trim())) && str.trim().containsIgnoreCase(Literaryval))
                    for(Id id1: resServicesMap.get(str)) {
                        if(serivceName.containskey(id1))
                            createPsList.add(new Project_Services__c(Project__c=ProjectId,Service__c=id1
                                                                    ));
                    }
                System.debug('str'+str);       
            }
        }
        
        System.debug('===='+createPsList);
        return createPsList;
    }
        
    public static boolean executeOnce=true;
    /** Update Service Prep metadata fields and makes the form readOnly **/
    public void servicePrepForm(Service_Prep__c spForm) { 
        executeOnce = false;
        System.debug(currentTab);
        System.debug(btnName);
        if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Acquisition')) {
            spForm.Acquistion_Tab_Static__c = true;
            acq_Tab_Static = true;
            des_Tab_Static = false;
            edi_Tab_Static = false;
            acquiringEditorStaticMail(spForm);
        }
        if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Design')) 
            if(!String.isBlank(btnName) && btnName.equalsIgnoreCase('CreatePs')){ //Design tab static when clicked on 'Review & Complete'
                spForm.Design_Scheduling_Tab_Static__c = true;
                des_Tab_Static = true;
            }
        if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Editorial')) 
            if(!String.isBlank(btnName) && btnName.equalsIgnoreCase('CreatePs')){ //Editorial tab static when clicked on 'Review & Complete'
                spForm.Editorial_Tab_static__c= true;    
                edi_Tab_Static = true;
            } 
        if(!String.isBlank(spForm.Status__c)  && spForm.Status__c.containsignoreCase('New')) //form status change 
            spForm.status__c='In Progress';
        if(spForm.Status__c.containsignoreCase('In Progress') && acq_Tab_Static
           && des_Tab_Static && edi_Tab_Static)
            spForm.status__c='Completed';
        
        updateSpMap.put(spForm.id,spForm);
       // update 
        System.debug(updateSpMap);
    }
    
    /** Editorial,Design tab static when acquistion is non-static**/
    public void tabStatic(Service_Prep__c spForm) {
        
        if(!spForm.Acquistion_Tab_Static__c) {
            des_Tab_Static = true;
            edi_Tab_Static = true;
        }
    }
    
    public Map<String,Service_Prep__c> updateSpMap = new Map<String,Service_Prep__c>();
    map<String,Project_Services__c> existingPSsmap = new map<String,Project_Services__c>();
    
    public  String proManager;
    /** Send email to production manager when acquisition tab has been made static  **/
    public void acquiringEditorStaticMail(Service_Prep__c spForm) {
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
    
    public Service_Prep__c serPrepFirstTimeServices = new  Service_Prep__c(); 
    
    
    /** Create PS Logic Method  */
    public string CreatePS() {
        censhareError = null;
        pollerEnabled = true;
        censhareStatus = true;
        allQuestions = new List<SerResWrap>();
        
        updateSpMap = new Map<String,Service_Prep__c>();
       
        if(currentTab.equalsignoreCase('Acquisition'))
            saveAcquistion();
        if(currentTab.equalsignoreCase('Design'))
            saveDesign();
        if(currentTab.equalsignoreCase('Editorial'))
            saveEditorial(); 
        
        pMessage = '';
        /** Update Service Prep for form readOnly **/
        responseMap = new  map<String,Service_Prep_Response__c>();
        if(currentTab.equalsignoreCase('Acquisition')) { // if current tab is acquisition, show the default alert message that all the questions are mandatory and form static alert message 
            responseMap = new map<String,Service_Prep_Response__c>([Select id,Response_Number__c,Response__c from Service_Prep_Response__c where id=:subQuestions ]);
            /** Acquisition section make it as readonly or show the modal message  **/ 
            
            for(SerResWrap sw : allQuestions) { 
                System.debug(sw.serPrepQuestion.name);
                System.debug(sw.serPrepResp.Response_Number__c );
                System.debug(sw.serPrepResp.Response__c);
                
                if(!responseMap.isempty()) {
                    if(responseMap.containsKey(sw.serPrepResp.Id)) {
                        Service_Prep_Response__c res = responseMap.get(sw.serPrepResp.Id);
                        if(sw.serPrepQuestion.Question_Type__c.containsIgnoreCase('Number')) {
                            if(res.Response_Number__c == null)
                            {
                                pMessage = Label.PPW_SPAcquisitionErrorMsg;//'Responses are mandatory for all the questions in the Acquisitions Tab, please ensure all questions have answers' ;
                                return null;
                            }
                        } else {
                            if(String.isBlank(res.Response__c) ){
                                pMessage = Label.PPW_SPAcquisitionErrorMsg;
                                return null;
                            } 
                        }
                    }  else {
                        if(sw.serPrepQuestion.Question_Type__c.containsIgnoreCase('Number')) {
                            if(sw.serPrepResp.Response_Number__c == null)
                            {
                                pMessage = Label.PPW_SPAcquisitionErrorMsg;
                                return null;
                            }
                        } else {
                            if(String.isBlank(sw.serPrepResp.Response__c) ){
                                pMessage = Label.PPW_SPAcquisitionErrorMsg;
                                return null;
                            } 
                        }
                        
                    }  
                }  else {
                    if(sw.serPrepQuestion.Question_Type__c.containsIgnoreCase('Number')) {
                        if(sw.serPrepResp.Response_Number__c == null)
                        {
                            pMessage = Label.PPW_SPAcquisitionErrorMsg;
                            return null;
                        }
                    } else {
                        if(String.isBlank(sw.serPrepResp.Response__c) ){
                            pMessage = Label.PPW_SPAcquisitionErrorMsg;
                            return null;
                        } 
                    }
                    
                } 
                
                if(sw.serPrepQuestion.Question_Type__c == 'Picklist (Multi-Select)') 
                    if(sw.selectedOpts.isEmpty()) {
                        pMessage = Label.PPW_SPAcquisitionErrorMsg;
                        return null;
                    }
            }
        }
        else{}
        return null;
        } 
    
    /** Create,update,delete PS logic  **/    
    public string createPsLogicforTabwise() {
        pollerEnabled = true; 
        censhareNewPs = new set<String>();
        psUpTypeQuestions = new Map<String,String>(); // this map can be used for store question numbers for define ps cupdate
        censhareError = null;
        List<Project_Services__c> newPSList = new List<Project_Services__c>(); 
        set<String> delPsSet = new set<String>(); 
        List<Project_Services__c> finalUpdate = new List<Project_Services__c>(); 
        Map<String,String> updatePswraperlist = new Map<String,String>(); 
        for(Service__c s: [SELECT id,name,Censhare_Template_ID__c,Service_Complexity_Value__c, 
                           Service_Rate_Type__c from Service__c where active__c = true]) 
            serivceName.put(s.Id,s); 
        SerResWrap caseSP = new SerResWrap(); 
        allQuestions = new List<SerResWrap>(); 
        if(currentTab.equalsignoreCase('Acquisition')) 
            saveAcquistion(); 
        if(currentTab.equalsignoreCase('Design')) 
            saveDesign(); 
        if(currentTab.equalsignoreCase('Editorial')) 
            saveEditorial(); 
        
        for(SerResWrap sw : allQuestions){
            if(sw.serPrep!=null && executeOnce)
                servicePrepForm(sw.serPrep);
           
            /** Create PS **/
            if(sw.serPrepQuestion.Render_type__c == 'Create PS') {
                System.debug('sw.serPrepQuestion.order__c'+sw.serPrepQuestion.order__c);
                System.debug('sw.serPrepResp.Response__c'+sw.serPrepResp.Response__c);
                if(!String.isBlank(sw.serPrepResp.Response__c) ){
                    
                    if(!String.isBlank(sw.serPrepResp.Service_Prep__r.Project__r.Title__r.Literary_Form__c)) {
                        newPSList.addall(createPSLogicFormLiterary_Form(sw.serPrepResp.Service_Prep__r.Project__r.Title__r.Literary_Form__c,sw.serPrepResp.Response__c,sw.serPrepQuestion));
                        if(!String.isBlank(sw.serPrepQuestion.Render_Response__c))
                            newPSList.addall(createPSLogic(sw.serPrepResp.Response__c,sw.serPrepQuestion));
                    } else {
                        if(!String.isBlank(sw.serPrepQuestion.Render_Response__c))
                            newPSList.addall(createPSLogic(sw.serPrepResp.Response__c,sw.serPrepQuestion));  
                    }
                }
            }
            System.debug('New Ps'+newPSList);
            
            /** Delete Ps **/
            if(sw.serPrepQuestion.Delete_Render_type__c == 'Delete PS') {
                System.debug('sw.serPrepQuestion.order__c'+sw.serPrepQuestion.order__c);
                System.debug('sw.serPrepResp.Response__c'+sw.serPrepResp.Response__c);
                if(!String.isBlank(sw.serPrepQuestion.Delete_Render_Response__c) && 
                   !String.isBlank(sw.serPrepResp.Response__c) )
                    delPsSet.addall(deletePSLogic(sw.serPrepResp.Response__c,sw.serPrepQuestion));
                
            }
            System.debug('Delete'+delPsSet); 
            
            /**  Create Case from title  **/        
            if(sw.serPrepQuestion.Create_Case__c)
                if(!String.isBlank(sw.serPrepResp.Response__c)){
                    System.debug(sw.serPrepResp.Response__c); 
                    if(sw.serPrepResp.Response__c.equalsIgnoreCase('No') && sw.serPrepResp.Service_Prep__r.Project__r.Title__r.Internal_Imprint__c!='Two Lions'){
                        caseSP= sw;//.serPrepResp;//.Service_Prep__r.Project__r.Title__r.Acquiring_Editor__c; 
                        System.debug(sw.serPrepResp.Service_Prep__r.Project__r.Title__r.Acquiring_Editor__c); 
                    } 
                }  
            
        }
       // PPW_ServicePrepFormControllerHelper serviceRepHelper =  new PPW_ServicePrepFormControllerHelper(); 
        PPW_ServicePrepFormControllerHelper.pid = ProjectId;
       
        /** Update PS action method  **/
        for(SerResWrap sw : allQuestions){
            System.debug(sw.serPrepQuestion.name);
            System.debug('+++'+sw.serPrepQuestion.Update_Render_Response__c);
            if(sw.serPrepQuestion.Update_Render_Type__c == 'Update PS') {
                System.debug('sw.serPrepQuestion.order__c'+sw.serPrepQuestion.order__c);
                System.debug('sw.serPrepResp.Response__c'+sw.serPrepResp.Response__c);
                if(!String.isBlank(sw.serPrepQuestion.Update_Render_Response__c) && 
                   !String.isBlank(sw.serPrepResp.Response__c) ) {
                    updatePswraperlist.putAll(updatePSLogic(sw.serPrepResp.Response__c,sw.serPrepQuestion));
                   // psUpTypeQuestions.put()
                    }
                
            } 
            // mwc create logic from custom meta data
          
           PPW_ServicePrepFormControllerHelper.psMWCCreate(newPSList,sw.serPrepQuestion.Id,sw.serPrepResp.Response__c); 
            system.debug('newPSList'+newPSList); 
        }
        System.debug('update'+updatePswraperlist);
        
        /** Start default Create Ps actions   **/
        if(!String.isBlank(Label.PPW_default_PS_create))
            if(currentTab == 'Acquisition')
            newPSList.addAll(PPW_ServicePrepFormControllerHelper.defaultpsCreate(Label.PPW_default_PS_create,serPrepFirstTimeServices,ProjectId));
        
        System.debug(newPSList);
        /** End default Create Ps Creation  **/
        
        /** Create ps from title and Asin  **/ 
        if(currentTab == 'Acquisition')
            newPSList.addAll(PPW_ServicePrepFormControllerHelper.psCreation(ProjectId,serPrepFirstTimeServices));
        
        existingPSsmap = new map<String,Project_Services__c>();
        getExistingPs(ProjectId);
        List<Project_Services__c> existingPSs = existingPSsmap.values();
        
        list<Project_Services__c> updateAllPS = new List<Project_Services__c>();  
        map<String,Project_Services__c> upsertPSs = new map<String,Project_Services__c>(); 
        
        System.debug(updatePswraperlist);
        
        List<Project_Services__c> delExistingList = new List<Project_Services__c>();
        for(Project_Services__c ps: existingPSs){
            if(updatePswraperlist != null && ps.Service__c != null)
            if(updatePswraperlist.containskey(String.valueOf(Id.valueOf(ps.Service__c)))) {
                ps.Service__c  = updatePswraperlist.get(String.valueOf(Id.valueOf(ps.Service__c)));
                if(psUpTypeQuestions.containsKey(String.valueOf(Id.valueOf(ps.Service__c))))
                ps.SPQ_Number__c = psUpTypeQuestions.get(String.valueOf(Id.valueOf(ps.Service__c)));
                }
            upsertPSs.put(ps.id,ps);
        }
        
        for(Project_Services__c ps: newPSList){
            if(updatePswraperlist.containskey(String.valueOf(Id.valueOf(ps.Service__c)))){
                System.debug(String.valueOf(Id.valueOf(ps.Service__c)));
                ps.Service__c  = updatePswraperlist.get(String.valueOf(Id.valueOf(ps.Service__c)));
                if(psUpTypeQuestions.containsKey(String.valueOf(Id.valueOf(ps.Service__c))))
                ps.SPQ_Number__c = psUpTypeQuestions.get(String.valueOf(Id.valueOf(ps.Service__c)));
                updateAllPS.add(ps);
            }else
                updateAllPS.add(ps);
        }
        
        System.debug('updateAllPS before mwc'+updateAllPS);  
        
        if(upsertPSs.keyset().size()>0)
            updateAllPS.addAll(upsertPSs.values());
        
        /** create ps or update from title mwc value **/     
        updateAllPS=PPW_ServicePrepFormControllerHelper.psMWCUpdate(ProjectId,updateAllPS);
        
        /** update ps from title internal imprint value **/     
        updateAllPS=PPW_ServicePrepFormControllerHelper.psInternalImprintupdate(ProjectId,updateAllPS);
        
        /** update ps based on value in subcategory field in title object  **/
        updateAllPS=PPW_ServicePrepFormControllerHelper.updatePsTileSubCategory(ProjectId,updateAllPS);
        
        System.debug('updateAllPS after mwc'+updateAllPS);
        
        updateAllPS = updateThreeOrMoreSameServices(updateAllPS);
        System.debug('before'+updateAllPS);
        updateAllPS = removeDuplicatePs(updateAllPS);
        System.debug('after'+updateAllPS);
        List<Project_Services__c> removedCreatePs = new LIst<Project_Services__c>();
        
        System.debug(delPsSet);
        System.debug('updateAllPS'+updateAllPS);
        
        /** Start Delete PS action method  **/
        if(delPsSet.size()>0) {
            for(Project_Services__c ps: updateAllPS)
                if(!delPsSet.contains(ID.valueOf(ps.Service__c)))
                removedCreatePs.add(ps); 
            if(!removedCreatePs.isEmpty())
                updateAllPS = removedCreatePs;
            
        }
        System.debug(updateAllPS);
        
        System.debug('updateAllPS after mwc1'+updateAllPS);
        honorDependencies(updateAllPS); //honor dependencies field update to true for newely created PS
        
       // censhareServicerMethod(updateAllPS); // call a web service for send ps details to censhare service
        
        /** Existing ps for delete or status to be update as Cancelled **/
        for(Project_Services__c ps: existingPSs)
            if(!delPsSet.isEmpty() && (ps.Service__c!=null))
            if(!string.isEmpty(ps.Service__c))
            if(delPsSet.contains(ID.valueOf(ps.Service__c))) {
                ps.status__c = 'Cancelled';
                delExistingList.add(ps);
                
            }    
        
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
        system.debug('updateAllPS $$'+ updateAllPS);
        getPSsRecords(updateAllPS,newPsLst,updatePsLst);
        //upsert updateAllPS;
        if(!updatePsLst.isEmpty())
              updatePsLst = promotionalTextUpdateService(updatePsLst,updateProTextPsLst);  // check promotional services for update pses
        // update record censhare call out
        if(!updatePsLst.isEmpty() && updatePsLst.size()>0) {
            system.debug(updatePsLst);
            for(Project_Services__c ps: updatePsLst) 
                ps.Censhare_XML_update_type__c = ''; 
            String existingPsxml = ppwCen.censhareXMLBuilder(updatePsLst); // xml builder for existing pses 
            system.debug('xml'+existingPsxml); 
            
            ppw_censhareConnector.resWrap rwrp;
            if(!test.isRunningTest())
            rwrp = ppw_censhareConnector.censhareServiceSync(existingPsxml); // censhare Callout for update 
            Map<String,Project_Services__c> psMap = new Map<String,Project_Services__c>(); 
            if(test.isRunningTest()) { 
                rwrp = new ppw_censhareConnector.resWrap(); 
                if(pollerEnabled == true) 
                    rwrp.resStatus = false; 
                else
                    rwrp.resStatus = true;
                updatePsLst = [SELECT id,Estimated_Start_Date__c,Service__r.Name,Estimated_Completion_Date__c,SPQ_Number__c,Censhare_XML_update_type__c, 
                               Censhare_Asset_ID__c FROM Project_Services__c where id=:updatePsLst]; 
                for(Project_Services__c ps: updatePsLst)
                    psMap.put(ps.id,ps);
                rwrp.resPs = psMap;
            }
            if(rwrp != null) {
                if(rwrp.resStatus == false) { 
                    pollerEnabled = false; 
                    censhareStatus = false;
                    if(rwrp.resErrorMes !=null) 
                    censhareError = rwrp.resErrorMes;
                    else
                    censhareError= 'Censhare Service Callout has been failed please contact your system administrator';
                    //censhareError= 'Job Failed';
                    for(Project_Services__c ps: updatePsLst)
                        if(ps.SPQ_Number__c!=null)
                            censhareError = censhareError + '\n' +ps.SPQ_Number__c ;
                    
                    system.debug(censhareError); 
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
                        } 
                }
                update updatePsLst; // update existing records after censhare call out
                update updateSpMap.values(); 
                questionStatic(); 
          }  // update censhare call out end   
        } else {  
                if((censhareError ==null || censhareError == '' || censhareError == ' ') && newPsLst.isempty()) {
                questionStatic();
                update updateSpMap.values();
                }
              }  
            insert newPsLst;
            system.debug('updateProTextPsLst'+ updateProTextPsLst);
            update updateProTextPsLst;
           newPsLst = promotionalTextService(newPsLst);  // check promotional services
        /** Restricts the initial PS creation based on service type to one time **/ 
        if(serPrep[0].Service_Id_s_Created__c==null || serPrep[0].Service_Id_s_Created__c=='') 
            newServicesUpdate(updateAllPS); 
        else updateAllPS = removingServices(serPrep[0].Service_Id_s_Created__c,updateAllPS); 
        system.debug(newPsLst);
        
        // new records censhare call out start
         if(!newPsLst.isEmpty())  { 
            for(Project_Services__c ps: newPsLst) {
                ps.Censhare_XML_update_type__c = 'New';
                ps.status__c = 'In Planning';  // set default status value
             }   
            
               String newPsxml = ppwCen.censhareXMLBuilder(newPsLst); // xml builder for new pses
               system.debug('xml'+newPsxml);
               
               for(Project_Services__c ps: newPsLst)
                   censhareNewPs.add(ps.id);//newPsLst;                
               system.debug(censhareNewPs);    
                if(!test.isRunningTest()) 
                 ppw_censhareConnector.censhareServiceMultiple(newPsxml,censhareNewPs); // censhare Callout for insert
            
        } // new records censhare call out end
        //else return null;
        update delExistingList;
        
        if(caseSP!=null)
            createCaseMethod(caseSP);
        SaveFormMethod(); 
       /* for(SerResWrap sw : allQuestions) { 
            if(sw.serPrep!=null && executeOnce) 
                servicePrepForm(sw.serPrep); 
            } */
        if(newPsLst.isEmpty() && updatePsLst.isEmpty())  {
             questionStatic();
             update updateSpMap.values();
        }
        
        return null;    
    }
    
    
     // check one or more promotinal text service exist or not for update
    public List<project_services__c>  promotionalTextUpdateService(List<Project_Services__c> upPsLst, List<Project_Services__c> updateProTextPsLst) {
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
    public List<project_services__c>  promotionalTextService(List<Project_Services__c> newPsLst) {
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
    public String incrementCounter() {
        try {
            //List<Project_services__c> delNewPs = new List<Project_services__c>();
            system.debug(censhareNewPs);
            system.debug(currentTab);
            if(censhareNewPs != null && !censhareNewPs.isEmpty()) {
                system.debug(censhareNewPs);
                AsyncApexJob asyncJob = [SELECT id,Status FROM AsyncApexJob WHERE MethodName='censhareServiceMultiple' AND JobType = 'Future' ORDER BY CompletedDate DESC LIMIT 1];
                if(asyncJob.Status == 'Completed') {
                    List<Project_services__c> cNewPs = [SELECT id,Censhare_XML_Error_Response__c,SPQ_Number__c ,Censhare_XML_update_type__c FROM Project_services__c WHERE id =: censhareNewPs];
                    if(cNewPs != null) {
                        if(cNewPs.size()>0) {
                            for(Project_services__c ps1 : cNewPS) {
                                if(ps1.Censhare_XML_Error_Response__c != null && ps1.Censhare_XML_Error_Response__c != '') {
                                    pollerEnabled = false;
                                    censhareStatus = false;
                                    if(ps1.Censhare_XML_Error_Response__c != 'Job Failed') {
                                        censhareError = 'There is some missing data that is required on censhare side, please contact your system adminstrator for more info.';
                                        censhareError = (!String.isBlank(currentTab) && currentTab.equalsignoreCase('Acquisition'))? censhareError : censhareError +' Specific questions failed are: \n'; 
                                        
                                    
                                    }else
                                        censhareError = ps1.Censhare_XML_Error_Response__c + ' - Empty body response received from censhare side' ; 
                                        
                                    for(Project_Services__c ps: cNewPs)
                                        if(ps.SPQ_Number__c!=null)
                                            censhareError = censhareError +  ps.SPQ_Number__c + ' , ' ;
                                    censhareError = censhareError.removeEnd(', ');
                                    censhareError = censhareError.removeEnd(' ,');
                                    censhareError = censhareError.removeEnd(' , ');
                                     if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Acquisition'))  
                                     acq_Tab_Static = false;
                                     if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Design')) 
                                     des_Tab_Static = false;
                                     if(!String.isBlank(currentTab) && currentTab.equalsignoreCase('Editorial')) 
                                     edi_Tab_Static = false;
                                               
                                       
                                } else{
                                     
                                    pollerEnabled = false;
                                    censhareStatus = false;
                                }
                            }
                            if(censhareError != null && censhareError !='') {
                                delete cNewPs;
                                return null;
                              } else {
                                  update updateSpMap.values();
                                  questionStatic(); 
                              
                              } 
                        } else {
                            pollerEnabled = false;
                            censhareStatus = false;
                            
                        } 
                    }  else {
                        pollerEnabled = false; 
                        censhareStatus = false; 
                        
                    }   
                } else {
                    
                    List<Project_services__c> cNewPs = [SELECT id,Censhare_XML_Error_Response__c ,SPQ_Number__c,Censhare_XML_update_type__c FROM Project_services__c WHERE id =: censhareNewPs LIMIT 1]; 
                    if(cNewPs != null) { 
                        if(cNewPs.size()>0) { 
                            pollerEnabled = true;
                            censhareStatus = true; 
                        }else{
                            pollerEnabled = false; 
                            censhareStatus = false;
                        }
                        }else {
                            pollerEnabled = false; 
                            censhareStatus = false;
                        }
                    }
                } else {
                   if((censhareError == null || censhareError == '' || censhareError == ' ') && pollerEnabled == false) {
                       //update updateSpMap.values();
                       //questionStatic(); 
                   }
                   if(currentTab != 'Acquisition')
                       pollerEnabled = false;
                    if(currentTab == 'Acquisition')
                       pollerEnabled = true;   
                   
                   return null;
               }
                
            } catch(Exception e) { 
                pollerEnabled = true;  //censhareError
                return null;
            }
          return null;  
        }
   // when censhare call out failed revert tab static
   public void tabStaticRevert() {
        acq_Tab_Static = false;
   }
   
   
    public boolean pollerEnabled{get;set;}  // censhareAction Poller
    public static boolean censhareStatus{get;set;}   //censhare Action poller Status  
   
    public set<String> censhareNewPs{get;set;}// = new set<String>();  // censhare new ps records
    public String censhareError{get;set;}
   
   // get PSs records for new and existing records
    @testVisible
    private void getPSsRecords(List<Project_Services__c> updateAllPS, List<Project_Services__c> newPsLst,List<Project_Services__c> updatePsLst ) {
        
        for(Project_Services__c ps: updateAllPS) {
            if(ps.id == null) {
                ps.Censhare_XML_update_type__c = 'New';
                newPsLst.add(ps);
            }   
            if(ps.id != null)
                updatePsLst.add(ps);    
        }                                                   
    }
   
    @testVisible 
    private List<Project_Services__c> updatestatusps(List<Project_services__c> updateAllPS){
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

    /** Save newly created PS in service prep form **/
    @testvisible
    private void newServicesUpdate(List<Project_Services__c> updateAllPS) {
        serPrepFirstTimeServices.id = serPrep[0].id;
        update serPrepFirstTimeServices;
        
    } 
    
    /** Remove newly created PSs in update all PS list **/
    @testvisible
    private List<Project_Services__c> removingServices(String services , List<Project_Services__c> updateAllPS) {
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
    private void honorDependencies(List<Project_Services__c> updateAllPS) {
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
    private void getExistingPs(String ProId) {
        if(existingPSsmap.isEmpty())
            existingPSsmap = new map<String,Project_Services__c>([Select id,Project__c,SPQ_Number__c,Service__r.Name,Service__c,status__c,Vendor__c, Honor_Dependencies__c from Project_Services__c
                                                                  where Project__c=:ProId]);
        System.debug(existingPSsmap);        
    }
    
    
    /** Update three or more Same services **/ 
    @testvisible
    private List<Project_Services__c> updateThreeOrMoreSameServices(List<Project_Services__c> psList1){
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
    private Map<String,String> splitServices(String str) {
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
    public List<Project_Services__c> removeDuplicatePs(List<Project_Services__c> psList1){
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
    
    public PageReference scaffoldServices() {
        return null;
    }
    
    /** Used to get metdata feilds for service prep form **/
    public void getFormDetails() {
        serPrep = [Select Id,Project__c,Acquistion_Tab_Static__c,Status__c,Project__r.Title__r.Name,Project__r.Name,
                   Project__r.Title__r.Production_Manager__c,Project__r.Title__r.Current_Editor__c,Project__r.Title__r.Marty_Title_ID__c,
                   LastModifiedBy.Name,LastModifiedDate, Design_Scheduling_Tab_Static__c,Editorial_Tab_static__c,Service_Id_s_Created__c
                   from Service_Prep__c where Id=:sId limit 1];
    }
    
    public String ProjectId;
    public String sId;
    
    public map<String,List<Service_Prep_Question__c>> serTypeSubQusMap  = new map<String,List<Service_Prep_Question__c>>();
    public map<String,List<Service_Prep_Question__c>> serTypeSubQuestionsMap{get;set;}
    
    public ApexPages.StandardController std{get;set;}
    
    /** Constructor, we are framing questions here for display **/
    public PPW_ServicePrepFormController(ApexPages.StandardController stdCon){ 
        
        std = stdCon;
        CreatePsBtnName = 'Create Services';
        List<String> roles = (Label.PPW_spRoleBsdBtnHde.contains(','))?Label.PPW_spRoleBsdBtnHde.split(','): new List<String>{Label.PPW_spRoleBsdBtnHde};
            List<String> profiles= (Label.PPW_spProfileBsdBtnHide.contains(','))?Label.PPW_spProfileBsdBtnHide.split(','): new List<String>{Label.PPW_spProfileBsdBtnHide};
                List<User> u = [SELECT id FROM user WHERE (UserRole.Name=: roles OR profile.Name =: profiles ) AND Id=:Userinfo.getUserId()];
        if(!u.isEmpty()) {
            roleuser = false;
            CreatePsBtnName = 'Review & Complete';
        }
        else 
            roleuser = true;       
        
        serTypeSubQuestionsMap = new map<String,List<Service_Prep_Question__c>>();
        
        acq_Tab_Static = false;
        des_Tab_Static = false;
        edi_Tab_Static = false;
        if(currentTab == null || currentTab == '')
            currentTab = 'Acquisition';
        
        serPrep = new list<Service_Prep__c>(); 
        
        sId = stdCon.getId();//ApexPages.currentPage().getParameters().get('id');
        if(!String.isBlank(sId))
            sId = ApexPages.currentPage().getParameters().get('id');
        If(!String.isBlank(sId))     
            getFormDetails();
        
        
        ProjectId = serPrep[0].Project__c;
        for(Service_Prep__c sp : serPrep) {
            acq_Tab_Static = sp.Acquistion_Tab_Static__c;
            des_Tab_Static = sp.Design_Scheduling_Tab_Static__c;
            edi_Tab_Static = sp.Editorial_Tab_static__c;
        }  
        
        tabStatic(serPrep[0]); //Editorial,design tab static when acquisition tab is non-static 
        
        Set<Id> questionids = new set<id>();
        System.debug('serPrep'+serPrep);
        list<Service_Prep_Response__c>  serPrepResp = [Select id,Service_Prep__c,Name,Service_Prep_Question__c,Question_Static__c ,Response_Number__c,
                                                       Response__c from Service_Prep_Response__c where Service_Prep__c=:serPrep];
        
        for(Service_Prep_Response__c sp : serPrepResp){
            if(sp.Service_Prep_Question__c!=null)
                questionids.add(sp.Service_Prep_Question__c);
            
        }
        questionsFraming(questionids,serPrep); // here questions are framing
    }
    
    public Map<String,List<Decimal>> questionsSort = new Map<String,List<Decimal>>();
    
    /** Sub questions frame **/
    public List<Service_Prep_Question__c> subQuestionsFrame(List<Service_Prep_Question__c> serPrepQuestion,set<Id> qIds,list<Service_Prep__c> serPrep) {
        
        return [Select id,Name,Active__c,Locale__c,Option_Values__c,Order__c,
                Question__c,Question_Category__c,Question_Type__c,Sub_Category__c,
                Render_type__c,Render_Response__c,Service_Prep_Parent_Question__c,Title_Response_Value__c,
                Create_Case__c, Update_Render_Type__c,Update_Render_Response__c,
                Delete_Render_type__c,Delete_Render_Response__c,Sub_Question_Render__c,
                Transmittal_Mapping__c,Help_Text__c,Help_Link__c,
                (Select id,Response__c,Response_Number__c,Name,
                 Service_Prep__r.Project__r.Title__c,Service_Prep__r.Project__r.Title__r.Acquiring_Editor__c,
                 Service_Prep__r.Project__r.Title__r.Production_Manager__c,
                 Service_Prep__r.Project__r.Title__r.Current_Editor__c, 
                 Service_Prep__r.Project__r.Title__r.Internal_Imprint__c,Question_Static__c ,
                 Service_Prep__r.Project__r.Title__r.Literary_Form__c
                 from Service_Prep_Responses__r where 
                 Service_Prep__c=:serPrep Limit 1)
                from Service_Prep_Question__c  where id=:qIds and 
                Service_Prep_Parent_Question__c=: serPrepQuestion and active__c = true order by Sub_Category__c,Order__c];
        
    }
    
    
    /** Framing all the questions into map  **/
    public void questionsFraming(set<Id> qIds,list<Service_Prep__c> serPrep){
        acqSubCat = new list<String>();
        desSubCat= new list<String>();
        ediSubCat= new list<String>();
        
        map<String,List<Service_Prep_Question__c>> serTypeQustions  = new map<String,List<Service_Prep_Question__c>>();
        serTypeSubQusMap  = new map<String,List<Service_Prep_Question__c>>();
        list<Service_Prep_Question__c> serPrepQuestion = [Select id,Active__c,Name,Locale__c,Option_Values__c,Order__c,
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
                                                          
                                                          where id=:qIds and (Service_Prep_Parent_Question__c ='' or Service_Prep_Parent_Question__c = null)
                                                          and active__c = true order by Sub_Category__c,Order__c];
        for(Service_Prep_Question__c s: serPrepQuestion) {
            acquiringEditor =  s.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Acquiring_Editor__c;
            proManager  =  s.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Production_Manager__c;
            //   System.debug(s);
        }
        
        System.debug(proManager);
        
        for(Service_Prep_Question__c sub : subQuestionsFrame( serPrepQuestion,qIds,serPrep)) {
            // Case owner Set as Production Manager
            acquiringEditor =  sub.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Acquiring_Editor__c;
            proManager  =  sub.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Production_Manager__c;
            currentEditor  =  sub.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Current_Editor__c;
            if(serTypeSubQusMap.containskey(sub.Service_Prep_Parent_Question__c))
                serTypeSubQusMap.get(sub.Service_Prep_Parent_Question__c).add(sub);
            else
                serTypeSubQusMap.put(sub.Service_Prep_Parent_Question__c ,new List<Service_Prep_Question__c>{sub});                                         
            
            
        }                                           
        for(Service_Prep_Question__c sub : subQuestionsFrame( subQuestionsFrame( serPrepQuestion,qIds,serPrep),qIds,serPrep)) {
            
            if(serTypeSubQusMap.containskey(sub.Service_Prep_Parent_Question__c))
                serTypeSubQusMap.get(sub.Service_Prep_Parent_Question__c).add(sub);
            else
                serTypeSubQusMap.put(sub.Service_Prep_Parent_Question__c ,new List<Service_Prep_Question__c>{sub});                                         
        }
        serTypeSubQuestionsMap =  serTypeSubQusMap; 
        acquisitionQuestion = new map<String,List<SerResWrap>>();
        DesignSQuestion = new map<String,List<SerResWrap>>(); 
        EditorialSQuestion = new map<String,List<SerResWrap>>(); 
        
        /** Main question order  **/
        for(Service_Prep_Question__c spq : serPrepQuestion){
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
            
            if(spq.Question_Category__c == 'Acquisition') //Questions frame by acquisition tab 
            {
                if(serTypeSubQusMap.containskey(spq.Id)) {
                    
                    swrap.subQuestionsWrap = subQuestionsFrame(serTypeSubQusMap,spq,swrap,
                                                               acquisitionQuestion,DesignSQuestion,EditorialSQuestion);
                    swrap.subQCat = spq.Sub_Category__c;
                    if(spq.Sub_Question_Render__c!=null)
                        getQuesNumber(swrap,spq);
                }
                swrap.serPrepQuestion =  spq;
                if(acquisitionQuestion.containskey(spq.Sub_Category__c))
                    acquisitionQuestion.get(spq.Sub_Category__c).add(swrap);
                else
                    acquisitionQuestion.put(spq.Sub_Category__c, new List<SerResWrap>{swrap});
                
            } 
            if(spq.Question_Category__c == 'Design Scheduling') //Questions frame by design tab
            {
                if(serTypeSubQusMap.containskey(spq.Id)) {
                    
                    swrap.subQuestionsWrap = subQuestionsFrame(serTypeSubQusMap,spq,swrap,acquisitionQuestion,DesignSQuestion,EditorialSQuestion);
                    System.debug(swrap.subQuestionsWrap);
                    swrap.subQCat = spq.Sub_Category__c;
                    if(spq.Sub_Question_Render__c!=null)
                        getQuesNumber(swrap,spq);
                }
                swrap.serPrepQuestion =  spq;
                if( DesignSQuestion.containskey(spq.Sub_Category__c))
                    DesignSQuestion.get(spq.Sub_Category__c).add(swrap);
                else
                    DesignSQuestion.put(spq.Sub_Category__c, new List<SerResWrap>{swrap});
                
            } 
            if(spq.Question_Category__c == 'Editorial Scheduling') //Questions frame by editorial tab
            {
                
                if(serTypeSubQusMap.containskey(spq.Id))  {
                    
                    swrap.subQuestionsWrap = subQuestionsFrame(serTypeSubQusMap,spq,swrap,acquisitionQuestion,DesignSQuestion,EditorialSQuestion);
                    swrap.subQCat = spq.Sub_Category__c;
                    if(spq.Sub_Question_Render__c!=null)
                        getQuesNumber(swrap,spq);
                }
                swrap.serPrepQuestion =  spq;
                if(EditorialSQuestion.containskey(spq.Sub_Category__c))
                    EditorialSQuestion.get(spq.Sub_Category__c).add(swrap);
                else
                    EditorialSQuestion.put(spq.Sub_Category__c, new List<SerResWrap>{swrap});
                
            }        
            
            if(swrap.subQuestionsWrap!=null && !swrap.subQuestionsWrap.keyset().isempty()){
                list<String> itemsAll = new list<String>();
                itemsAll.addAll(swrap.subQuestionsWrap.keyset());
                swrap.subQuestionCat =itemsAll[0];
            }
            
        } 
        
        /** Dependent Questions Order **/
        
        for(Service_Prep_Question__c spq : serPrepQuestion){
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
                    
                    subDependentQuestionsFrame(serTypeSubQusMap,spq,swrap,
                                               acquisitionQuestion,DesignSQuestion,EditorialSQuestion);
                    
                }
                
            } 
            if(spq.Question_Category__c == 'Design Scheduling')
            {
                if(serTypeSubQusMap.containskey(spq.Id)) {
                    
                    subDependentQuestionsFrame(serTypeSubQusMap,spq,swrap,acquisitionQuestion,DesignSQuestion,EditorialSQuestion);
                    
                }
                
                
            } 
            if(spq.Question_Category__c == 'Editorial Scheduling')
            {
                
                if(serTypeSubQusMap.containskey(spq.Id))  {
                    subDependentQuestionsFrame(serTypeSubQusMap,spq,swrap,acquisitionQuestion,DesignSQuestion,EditorialSQuestion);
                }
            } 
         } 
        
        System.debug('acquisitionQuestion'+acquisitionQuestion);
        if(acquisitionQuestion!=null) {
            acqSubCat.addall(acquisitionQuestion.keyset());
        }
        System.debug('DesignSQuestion'+DesignSQuestion);
        if( DesignSQuestion!=null) {
            desSubCat.addall(DesignSQuestion.keyset());
        }
        System.debug('EditorialSQuestion'+EditorialSQuestion);
        
        for(List<SerResWrap> s: EditorialSQuestion.values())
            for(SerResWrap s1: s)
            System.debug(s1.serPrepQuestion);
        
        
        if(EditorialSQuestion!=null) {
            ediSubCat.addall(EditorialSQuestion.keyset());
        }
        
        System.debug(acqSubCat+','+desSubCat+','+ediSubCat);
    }
    
    /** Framing sub questions wrapper **/
    public map<String,List<SerResWrap>> subQuestionsFrame(map<String,List<Service_Prep_Question__c>> subQmap,
                                                          Service_Prep_Question__c subQ,SerResWrap swrap,map<String,List<SerResWrap>> sWrapMap,map<String,List<SerResWrap>> sWrapMap1,map<String,List<SerResWrap>> sWrapMap2){
                                                              map<String,List<SerResWrap>> serSubQ = new map<string,List<SerResWrap>>();
                                                              
                                                              List<SerResWrap> subWrap = new List<SerResWrap>();
                                                              for(Service_Prep_Question__c sq: subQmap.get(subQ.id)){
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
    public void subDependentQuestionsFrame(map<String,List<Service_Prep_Question__c>> subQmap,Service_Prep_Question__c subQ,SerResWrap swrap,map<String,List<SerResWrap>> sWrapMap,map<String,List<SerResWrap>> sWrapMap1,map<String,List<SerResWrap>> sWrapMap2){
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
                    
                    dependentQ.subQuestionsWrap = subQuestionsFrame(serTypeSubQusMap,sq,swrap,
                                                                    acquisitionQuestion,DesignSQuestion,EditorialSQuestion);
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
                
                System.debug(sWrapMap.keyset());
                System.debug(sWrapMap1.keyset());
                System.debug(sWrapMap2.keyset());
                
                swrap.dependentQAns = subQ.Sub_Question_Render__c;
                if(sq.Question_Category__c.containsignorecase('Acquisition')) {//Acquisition dependent questions
                    
                    if(sWrapMap.containsKey(sq.Sub_Category__c)) {
                        sWrapMap.get(sq.Sub_Category__c).add(dependentQ);
                        sWrapMap = arrangeSorting(sWrapMap,dependentQ,sq.Sub_Category__c);
                        
                    } else  sWrapMap.put(sq.Sub_Category__c, new list<SerResWrap>{dependentQ});
                } else {
                    if(sq.Question_Category__c.containsignorecase('Design Scheduling')) {//Design dependent questions
                        
                        if(sWrapMap1.containsKey(sq.Sub_Category__c)) {
                            sWrapMap1.get(sq.Sub_Category__c).add(dependentQ);
                            sWrapMap1 = arrangeSorting(sWrapMap1,dependentQ,sq.Sub_Category__c);
                            //  sWrapMap1.get(sq.Sub_Category__c).add(dependentQ);
                        } else    sWrapMap1.put(sq.Sub_Category__c, new list<SerResWrap>{dependentQ});
                    } else 
                        if(sq.Question_Category__c.containsignorecase('Editorial Scheduling')) {//Editorial dependent questions
                            
                            if(sWrapMap2.containsKey(sq.Sub_Category__c)) {
                                sWrapMap2.get(sq.Sub_Category__c).add(dependentQ);
                                sWrapMap2 = arrangeSorting(sWrapMap2,dependentQ,sq.Sub_Category__c);
                            } else   
                                sWrapMap2.put(sq.Sub_Category__c, new list<SerResWrap>{dependentQ});
                        } 
                }          
            }
        }
    }
    
    /** Arrange sorting order for questions,sub question and dependent question  **/
    public map<string,List<SerResWrap>>  arrangeSorting(map<string,List<SerResWrap>> sWraMap,SerResWrap dependentQ,String sCat) {
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
        
    }
    
    public SerResWrap subQuestionType(Service_Prep_Question__c spq,Service_Prep_Question__c parentQ){
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
        public string oldServiceId{get;set;}
        public string newServiceId{get;set;}
        
    } 
    
    /** Multi Select type options  **/  
    public void mulitiSelectType(SerResWrap swp,Service_Prep_Question__c spq) {
        swp.selectedOpts = new List<string>();
        List<SelectOption> SelOptions = new List<SelectOption>();
        /** all option values  **/
        if(spq.Option_Values__c!=null){
            SelOptions.add(new SelectOption(' ','--Please Select--'));
            for(String str: spq.Option_Values__c.trim().split(';'))
                SelOptions.add(new SelectOption(str.trim(),str.trim()));
            
        }
        swp.resPicklistValues = SelOptions; 
        if(!String.isBlank(spq.Service_Prep_Responses__r[0].response__C)) {
            SelOptions = new List<SelectOption>();
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
    public void picklistType(SerResWrap swp,Service_Prep_Question__c spq) {
        List<SelectOption>SelOptions = new List<SelectOption>();
        if(spq.Option_Values__c!=null){
            SelOptions.add(new SelectOption(' ','--Please Select--')); //dont remove space in picklist backend value
            for(String str: spq.Option_Values__c.trim().split(';'))
                SelOptions.add(new SelectOption(str.trim(),str.trim()));
            
        }
        swp.resPicklistValues = SelOptions; 
        
    }
    
    public Map<String,String> psUpTypeQuestions = new Map<String,String>();
    @testvisible
    /** Split logic for update PS **/
    Private  map<String,String> updatePSLogic(String response,Service_Prep_Question__c serPrepQuestion) {
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
    }
    /**  Split logic for Order for sub question render type **/
    public  void getQuesNumber(SerResWrap swrap,Service_Prep_Question__c pSub){
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
    
    /** Wrapper used for framing different questions based on response type **/  
    public class SerResWrap {
        public Service_Prep__c serPrep{get;set;}
        public boolean parentQustion{get{return false;}set;}
        public Service_Prep_Response__c serPrepResp{get;set;}
        public Service_Prep_Question__c serPrepQuestion{get;set;}
        public boolean createCase{get{return false;}set;}
        public String responseType{get;set;}
        public List<SelectOption> resPicklistValues{get;set;}
        public List<String> selectedOpts{get;set;}
        public Map<String,List<SerResWrap>> subQuestionsWrap{get;set;}
        public String subQCat{get;set;}
        public String serResponse{get;set;}
        public String subQuestionOrder{get;set;}
        public Map<String,List<String>> subQOrderMap{get;set;}
        public String dependentRes{get;set;}
        public String subQuestionCat{get;set;}
        public boolean dependentQ{get;set;}
        public boolean dependentRenderQ{get;set;}
        public String dependentQId{get;set;}
        public String depRenderQId{get;set;}
        public String dependentQAns{get;set;}
        public Service_Prep_Response__c parentPrepResp{get;set;}
        public Map<String,SerResWrap> parentQuestion{get;set;}
        public String parentQResp{get;set;}
        public String pCat{get;set;}
        public String pSCat{get;set;}
        
    }
    
    public map<String,List<SerResWrap>> acquisitionQuestion{get;set;} 
    public map<String,List<SerResWrap>> DesignSQuestion{get;set;} 
    public map<String,List<SerResWrap>> EditorialSQuestion{get;set;} 
    public list<String> acqSubCat{get;set;}
    public list<String> desSubCat{get;set;}
    public list<String> ediSubCat{get;set;}
  }