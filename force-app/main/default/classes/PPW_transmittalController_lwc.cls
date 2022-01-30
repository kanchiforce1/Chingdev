/***********************************
Author: Amazon Apub // michatem@, kkolla@
Lightning Component Extended:  PPW_transmittalComponent.vfp
Description: Controller for the PPW_transmittalComponent LWC
************************************/

public with sharing class PPW_transmittalController_lwc {     
    public static string v;
    public static string vendorName;
    
    public static string tId;// = ApexPages.currentPage().getParameters().get('titleId'); //project service id
    
    public static string titleID {get; set;}
    public static string projectID {get; set;}
    
    
    public static trasmittalWrpData tsmWrapData{get;set;}
    
    public class trasmittalWrpData {
        @AuraEnabled
        public set<string> confirmationTblHeaders{get;set;}// = new set<string>();
        @AuraEnabled
        public boolean rushFeeFlg{get; set;} 
        @AuraEnabled
        public boolean renderTransmittalData {get; set;}
        @AuraEnabled
        public string titleID {get; set;}
        @AuraEnabled
        public map<string, list<confirmation__c>> confirmationListsMap = new map<string, list<confirmation__c>>();
        @AuraEnabled
        public string projectID {get; set;}
        @AuraEnabled
        public integer openConfirmationCount {get; set;}
        @AuraEnabled
        public integer confirmedConfirmationCount {get; set;}
        @AuraEnabled
        public list<confirmation__c> allRelatedConfirmationCheck = new list<confirmation__c>();
        @AuraEnabled
        public list<string> confirmationStatusList = new list<string>();//{get; set;}
        @AuraEnabled
        public Map<String,List<confirmation__c>> serviceBasedConfirmationMap = new Map<String,List<confirmation__c>>();
        @AuraEnabled
        public map<string, List<confirmation__c>> serviceBasedMostActionConMap = new map<string, List<confirmation__c>>();
        @AuraEnabled
        public Map<String,set<string>> statusName{get;set;}// = new Map<String,set<string>>();
        @AuraEnabled
        public set<string> serviceName{get;set;}// = new set<string>();
        @AuraEnabled
        public string serviceNamesCheck{get;set;}
        @AuraEnabled
        public map<String,Boolean> serviceBasedCon = new map<String,Boolean>();
        @AuraEnabled
        public map<String,Boolean> serviceBasedActionCon = new map<String,Boolean>();
        @AuraEnabled
        public boolean confirmationListsize{get;set;}
        @AuraEnabled
        public boolean serviceBasedConfirmation{get;set;}
        @AuraEnabled
        public boolean serviceBasedMostActionCon{get;set;}
        @AuraEnabled
        public title__c currentTitle{get;set;}
        @AuraEnabled
        public title__c projectService{get;set;}
        
        
        // @AuraEnabled
        //public String cID{get;set;}
        // @AuraEnabled
        // public String confirmChoice{get;set;}
        @AuraEnabled
        public string rejectionReason {get; set;}
        @AuraEnabled
        public string reviewReason {get; set;}
        @AuraEnabled
        public string rejectionReasonInput {get; set;}
        // @AuraEnabled
        // public string additionalRateInput {get; set;}
        @AuraEnabled
        public string customQuote {get; set;} //this is the value for enter quote amount in ps record
        @AuraEnabled
        public Map<String,rate__c> ratePsMap = new Map<String,rate__c>();
        @AuraEnabled
        public boolean additionalRateInputCheck {get; set;}
        @AuraEnabled
        public list<ASIN__c> formatListsMap = new list<ASIN__c>();
        @AuraEnabled
        public list<string> formatNameList = new list<string>();
        @AuraEnabled
        public map<string, list<service_prep_response__c>> servicePrepListsMap = new map<string, list<service_prep_response__c>>();
        @AuraEnabled
        public set<string> subCatMap{get;set;}// = new set<string>();//, string>();
        @AuraEnabled
        public string authorString{get;set;}
        @AuraEnabled
        public string relatedTitles{get;set;}
        // @AuraEnabled
        /// public title__c currentTitle = new title__c();
        @AuraEnabled
        public map<string, string> additionalRateStringMap = new map<string, string>();
        @AuraEnabled
        public map<string, boolean> additionalRateInputMap = new map<string, boolean>();
        @AuraEnabled
        public map<string, boolean> additionalRateInputMap_vendor = new map<string, boolean>();
        @AuraEnabled
        public map<id, project_services__c> allProjectServiceMap = new map<id, project_services__c>();
        
    }  
    
    @AuraEnabled
    public static resWrap picklistValues(String objectName, String fieldName, String recordId) {
        List<String> values = new List<String>();
        
        List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(new List<String>{objectName});
        
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {
                    values.add(entry.getLabel());
                }
            }
        }
        resWrap rw = new resWrap();
        if(String.isNotBlank(recordId)) {
            String query = 'select '+ fieldName + ' FROM '+ objectName + ' where id= \''+recordId + '\'';
            system.debug(query);
            SObject sObj = database.query(query);
            rw.recData = sObj;
        }
        rw.fieldsLst = values;
        
        
        return rw;
    }
    
    public class resWrap {
        @AuraEnabled
        public SObject recData{get;set;}
        @AuraEnabled
        public List<String> fieldsLst{get;set;}    
        
    }
    
    @AuraEnabled
    public static void resetChatterCount(String psId) {
        project_services__c ps = new project_services__c(Id=psid, Chatter_Count_External__c= null);
        update ps;
    
    }
    
      @AuraEnabled
    public static void resetChatterCountInternal(String psId) {
        project_services__c ps = new project_services__c(Id=psid, Chatter_Count_Internal__c= null);
        update ps;
    
    }
    
    
    /* gets the confirmation records */
    public static void getConfirmationMap() {
        tsmWrapData.confirmationTblHeaders = new set<String>{'Status','Sent','Confirmed Date','Service','Amount'}; 
            tsmWrapData.serviceBasedConfirmationMap = new Map<String,List<confirmation__c>>();
        system.debug(vendorName);
        system.debug(tsmWrapData.projectID);
        for(confirmation__c c: [
            select id, name, project_services__c, status__c, confirmation__c, date_of_confirmation__c, confirmed_amount__c, confirmed_service__c, confirmed_vendor__c, rejection_reason__c,project_services__r.Chatter_Count_External__c,
            project_services__r.Additional_Rate_Input__c, project_services__r.estimated_start_date__c, project_services__r.estimated_completion_date__c, project_services__r.actual_start_date__c, 
            project_services__r.actual_completion_date__c, project_services__r.mbo_fee__c, project_services__r.rate__r.rate_amount__c,project_services__r.rate__r.Rate_Currency__c, project_services__r.rate__r.rate_multiplier__c, project_services__r.rate_amount__c, project_services__r.rate__c,
            project_services__r.rate_currency__c, project_services__r.rush_fee__c, project_services__r.service__r.service_rate_type__c, project_services__r.vendor_notes_RT__c, project_services__r.status__c,
            project_services__r.vendor__c, project_services__r.vendor__r.name, project_services__r.Service_Type_Complexity__c,Confirmed_Currency_Amount__c,Confirmed_Rate_Amount__c,
            confirmed_rush_fee__c,Confirmed_Amount_with_Currency__c, confirmed_addl_rate_input__c,Reason_for_Review__c,open_confirmation__c,CreatedDate,project_services__r.project__r.Title__r.Pre_Dev_Edit_Word_Count__c,project_services__r.Custom_Quote_Amount__c, 
            Project_Services__r.Word_Count_In_Planning__c,Project_Services__r.Word_Count_Confirming__c,Project_Services__r.Word_Count_Scheduled__c,
            Project_Services__r.Word_Count_Completed__c,Project_Services__r.Word_Count_Kicked_Off__c,Project_Services__r.Word_Count_Cancelled__c,Confirmed_Base_Amount__c,confirmed_word_count__c,
            Confirmed_Total_Rate_Amount__c,Confirmed_Base_Amount_With_Currency__c,Confirmed_MBO_Fee_with_Currency__c,project_services__r.Base_Amount__c,project_services__r.User_Input_Rate_Amount__c,
            Confirmed_MBO_Fee__c 
            FROM confirmation__c 
            WHERE project_services__r.project__c=: tsmWrapData.projectID 
            AND Confirmed_Vendor__c =: vendorName AND project_services__r.status__c!='Cancelled' AND status__c !='Internal Closed'
            ORDER BY 
            project_services__r.service__r.service_rate_type__c,LastModifieddate DESC
        ]) {
            //String sType = c.project_services__c;//c.project_services__r.service__r.service_rate_type__c; 
            String sType = c.project_services__r.service__r.service_rate_type__c;
            if(sType!=null ) {
                if(!tsmWrapData.serviceBasedMostActionConMap.containsKey(sType)) {
                    if(c.status__c=='Confirmed' && c.confirmation__c == 'No') { 
                        tsmWrapData.serviceBasedMostActionConMap.put(sType,new List<confirmation__c>());
                    } else 
                        tsmWrapData.serviceBasedMostActionConMap.put(sType, new List<confirmation__c>{c});
                    tsmWrapData.serviceBasedConfirmationMap.put(sType,new List<confirmation__c>{c}); 
                } else {
                    if(tsmWrapData.serviceBasedConfirmationMap.containsKey(sType))
                        tsmWrapData.serviceBasedConfirmationMap.get(sType).add(c);
                    else
                        tsmWrapData.serviceBasedConfirmationMap.put(sType,new List<confirmation__c>{c});
                }
                if(c.Confirmed_Rush_Fee__c !=0 && c.Confirmed_Rush_Fee__c != null && c.Confirmed_Rush_Fee__c !=0.00 ) {
                    tsmWrapData.confirmationTblHeaders.add('Rush Fee');
                    tsmWrapData.rushFeeFlg = true; 
                    
                } 
            } 
        }          
        
        
        
        if(!tsmWrapData.serviceBasedConfirmationMap.isEmpty()) {
            tsmWrapData.serviceBasedConfirmation = true;
            
        }
        
        if(!tsmWrapData.serviceBasedMostActionConMap.isEmpty()) {
            
            tsmWrapData.serviceBasedMostActionCon = true;
        }
        tsmWrapData.serviceName = new set<String>();
        if(!tsmWrapData.serviceBasedConfirmationMap.isEmpty() || !tsmWrapData.serviceBasedConfirmationMap.isEmpty()) {
            tsmWrapData.serviceName.addAll(tsmWrapData.serviceBasedConfirmationMap.keyset());
            tsmWrapData.serviceName.addAll(tsmWrapData.serviceBasedConfirmationMap.keyset());
            for(string s: tsmWrapData.serviceName) {
                if(tsmWrapData.serviceBasedConfirmationMap.containskey(s))
                    tsmWrapData.serviceBasedCon.put(s,true);
                else
                    tsmWrapData.serviceBasedCon.put(s,false) ;
                
                if(tsmWrapData.serviceBasedMostActionConMap.containskey(s)) {
                    if(tsmWrapData.serviceBasedMostActionConMap.get(s).size()>0)
                        tsmWrapData.serviceBasedActionCon.put(s,true);
                    else
                        tsmWrapData.serviceBasedActionCon.put(s,false) ;
                }else
                    tsmWrapData.serviceBasedActionCon.put(s,false) ;
            }
            
        } 
        
        
        
    }
    
    
    /*gets the ASIN level records for the title */
    public static list<ASIN__c> getformatListsMap() {
        
        Map<String,List<asin__c>> asinsMap = new Map<String,List<asin__c>>();
        List<asin__c> asinArange = new List<asin__c>();
        
        list<asin__c> allRelatedFormats = new list<asin__c>([
            select id, name, isbn_13__c, title__c, asin__c, trim_height__c, trim_width__c, apub_publish_date__c, initial_page_count__c, interior_paper_stock__c
            from asin__c 
            where title__c =:  tsmWrapData.titleID AND name IN ('Digital', 'Paperback', 'Hardcover') AND title__c !=null ORDER BY apub_publish_date__c
        ]);
        for(asin__C a : allRelatedFormats) {
            if(asinsMap.containsKey(a.Name))
                asinsMap.get(a.Name).add(a);
            else
                asinsMap.put(a.Name, new List<asin__c>{a});    
        }
        if(asinsMap.containsKey('Digital')) {
            asinArange.addAll(asinsMap.get('Digital'));
            asinsMap.remove('Digital');
        }  
        
        
        for(String s: asinsMap.keyset())
            asinArange.addAll(asinsMap.get(s));
        
        
        return asinArange;
    }
    
    public static list<string> getformatNameList() {
        set<string> tempSet = new set<string>();
        for(asin__c a : [select id, name from asin__c where title__c =:  tsmWrapData.titleID AND name IN ('Digital', 'Paperback', 'Hardcover') AND title__c != null]){
            tempSet.add(a.name);
        }
        
        list<string> tempList = new list<string>();
        tempList.addAll(tempSet);
        return tempList;
        
    }
    
    /* Service prep responses to display data to the vendors in PTF */
    public static map<string, list<service_prep_response__c>> getservicePrepListsMap() {
        
        map<string, list<service_prep_response__c>> tempMap = new map<string, list<service_prep_response__c>>();
        list<service_prep_response__c> allNeededResponses = new list<service_prep_response__c>([
            select id, name, service_prep__r.Name, service_prep_question__r.question__c, response__c, service_prep_question__r.Sub_Category__c, service_prep_question__r.transmittal_label__c
            from service_prep_response__c 
            where service_prep__c in (select id from service_prep__c where project__c = : tsmWrapData.projectID) and service_prep_question__r.transmittal_mapping__c =true and response__c !=null
        ]);
        
        if(!allNeededResponses.isEmpty()) {
            for(service_prep_response__c spr : allNeededResponses){
                if(tempMap.containsKey(spr.service_prep_question__r.Sub_Category__c)){
                    List<service_prep_response__c> temp = tempMap.get(spr.service_prep_question__r.Sub_Category__c);
                    temp.add(spr);
                    tempMap.put(spr.service_prep_question__r.Sub_Category__c,temp);
                }else{
                    List<service_prep_response__c> temp = new List<service_prep_response__c>();
                    temp.add(spr);
                    tempMap.put(spr.service_prep_question__r.Sub_Category__c,temp);
                }
            }
        }
        return tempMap;
        
    }
    public static map<string, string> getsubCatMap() {
        
        map<string, string> tempSubCatMap = new map<string, string>();
        for(service_prep_response__c spr : [
            select service_prep_question__r.Sub_Category__c 
            from service_prep_response__c  
            where service_prep__c in (select id from service_prep__c where project__c = : tsmWrapData.projectID) 
            and service_prep_question__r.transmittal_mapping__c =true and response__c !=null order by service_prep_question__r.Sub_Category__c ASC]){
                string cleanString = spr.service_prep_question__r.Sub_Category__c.remove('(');
                cleanstring = cleanstring.remove(')');
                cleanstring = cleanstring.remove(',');
                tempSubCatMap.put(spr.service_prep_question__r.Sub_Category__c, cleanString.deleteWhitespace());
            }
        
        return tempSubCatMap;
        
    }
    
    
    public static string authorString() {
        
        string a = '';
        list<title_contact__c> authors = new list<title_contact__c>([
            select pen_name1__c, role__c 
            from title_contact__c 
            where role__c IN ('Author', 'Translator', 'Illustrator') 
            and title__c=:titleID order by legal_name__r.pen_last__c ASC
        ]);
        
        integer currentCount = 0;
        
        for (title_contact__c tc : authors){
            if(authors.size() == 1){
                a = tc.pen_name1__c+' ('+tc.role__c+')';
                break;
            }
            if(authors.size() > 1){
                if(currentCount == 0 || (currentCount > 0 && currentCount < (authors.size()-1))){
                    a += tc.pen_name1__c+' ('+tc.role__c+')'+', ';
                    currentCount ++;
                    continue;
                }else{
                    a += tc.pen_name1__c+' ('+tc.role__c+')';
                }
            }
        }
        return a;
        
    }
    
    public static string relatedTitles() {
        //return a comma separated list of related titles to either the series or the author... should this be maxed?
        return 'Need to return a nicely formatted string of the related titles...';
        
    }
    
    public static title__c currentTitle() {
        
        title__c t = new title__c ();
        if(tsmWrapData.titleID != null)
            t=[
                select id, name, full_title_name__c, sub_title__c, marty_title_id__c, external_imprint__c, category__c, sub_category__c, Pre_Dev_Edit_Word_Count__c , 
                //Post_Dev_Edit_Word_Count__c,
                series__c
                from title__c 
                where id = : tsmWrapData.titleID limit 1
            ];
        
        return t;
        
    }
    
    public project_services__c psToUpdate;// = new project_services__c(); 
    public ppw_transmittalController_lwc() {
        
    }
    
    @AuraEnabled 
    public static title__c getTitleData( String titleId) { 
        return [SELECT id,status__c, Digital_Publication_Date__c, Marty_Title_ID__c, Name, Internal_Imprint__c FROM title__c WHERE id=: titleId limit 1]; 
    }

     @AuraEnabled 
    public static Series__c getSeriesData( String seriesId) { 
        return [SELECT id,Series_Title__c,Wombat_Series_ID__c FROM Series__c WHERE id=: seriesId limit 1]; 
    }
    
    
    @AuraEnabled
    public static trasmittalWrpData getTrasmittalData( String titleId, String seriesId, String v1) {
        tsmWrapData = new trasmittalWrpData();
        system.debug(v1);
        if(v1!=null)
            v = v1;
        else {
            User u = [SELECT contact.vendor__c FROM User WHERE id=: userinfo.getUserId()];
            v = u.contact.vendor__c;
            
        }    
        List<project__c> currentProject = new List<project__c>();
        if(v!=null)
            vendorName = [Select Name from vendor__c where id=:v limit 1].Name;
        if(String.isNotBlank(titleId)) 
           currentProject = [
                select id, title__c,(select id,rate__c,rate__r.rate_multiplier__c from Project_Services__r) from project__c where title__r.Marty_Title_ID__c=: titleId limit 1
            ];
        if(String.isNotBlank(seriesId))
               currentProject = [
                    select id, title__c,(select id,rate__c,rate__r.rate_multiplier__c from Project_Services__r) from project__c where series__r.Wombat_Series_ID__c=:seriesId limit 1
                ];
        set<string> multiplierSet = new set<string>();
        map<string, boolean> tempMap = new map<string, boolean>();
        multiplierSet.addAll(label.ppw_addlInput_rateTypes.split(','));
        for(project__c p: currentProject) 
            for(project_services__c ps: p.project_services__r) {
                if(multiplierSet.contains(ps.rate__r.rate_multiplier__c)) {
                    tempMap.put(ps.rate__c, true);
                } else {
                    tempMap.put(ps.rate__c, false);
                }
            }
        
        tsmWrapData.additionalRateInputMap = tempMap;//additionalRateInputMap();
        multiplierSet = new set<string>();
        tempMap = new map<string, boolean>();
        multiplierSet.addAll(label.ppw_addlInput_rateTypes_vendor.split(','));
        for(project__c p: currentProject) 
            for(project_services__c ps: p.project_services__r) {
                if(multiplierSet.contains(ps.rate__r.rate_multiplier__c)) {
                    tempMap.put(ps.rate__c, true);
                } else {
                    tempMap.put(ps.rate__c, false);
                }
            }
        
        
        tsmWrapData.additionalRateInputMap_vendor = tempMap;//additionalRateInputMap_vendor();  
        
        if (currentProject.size()==1) {
            tsmWrapData.projectID = currentProject.get(0).id;
            tsmWrapData.titleID = currentProject.get(0).title__c;
            
            
            tsmWrapData.allRelatedConfirmationCheck = [
                select id, status__c from confirmation__c 
                where project_services__r.project__c=: tsmWrapData.projectID 
                and project_services__r.vendor__c =:v 
                and (confirmation__c = 'Yes' OR status__c = 'Open') 
                and project_services__r.status__c not in ('Cancelled', 'Completed', 'In Planning')
                ORDER BY project_services__r.estimated_start_date__c ASC];
            
            List<Marketplace__c> aList = [SELECT id,Amazon_Street_Date__c from Marketplace__c WHERE Amazon_Street_Date__c <= TODAY AND Format__r.Title__c =: titleID AND Format__r.Name = 'Digital']; 
            system.debug(titleID); 
            if(tsmWrapData.allRelatedConfirmationCheck.size() > 0) {
                tsmWrapData.renderTransmittalData=true;
            }
            if(aList == null) { 
                // renderTransmittalData=false; 
            } else {
                if(!aList.isEmpty()) 
                    tsmWrapData.renderTransmittalData=false; 
            }
        }
        getConfirmationMap();
        tsmWrapData.subCatMap = new set<string>();
        tsmWrapData.formatListsMap = getformatListsMap();
        tsmWrapData.formatNameList = getformatNameList();
        tsmWrapData.servicePrepListsMap = getservicePrepListsMap();
        tsmWrapData.subCatMap = tsmWrapData.servicePrepListsMap!=null? tsmWrapData.servicePrepListsMap.keyset() : null;
        tsmWrapData.authorString = authorString();
        tsmWrapData.relatedTitles = relatedTitles();
        
        tsmWrapData.currentTitle = currentTitle();
        tsmWrapData.additionalRateStringMap = additionalRateStringMap();
        
        
        tsmWrapData.allProjectServiceMap = allProjectServiceMap();
        // tsmWrapData.currentTitle = currentTitle();
        return tsmWrapData;
        
    }
    
    
    public Map<String,rate__c> ratePsMap;
    
    
    public static map<string, string> additionalRateStringMap() {
        
        try {
            map<string, string> tempMap = new map<string, string>();
            
            for(project_services__c ps : [select rate__c,rate__r.rate_multiplier__c,id from 
                                          project_services__c where project__c = : tsmWrapData.projectID]) { 
                                              string x;
                                              if(ps.rate__c!=null) 
                                                  if(ps.rate__r.rate_multiplier__c!=null) {
                                                      x = ps.rate__r.rate_multiplier__c.contains('Per ')? ps.rate__r.rate_multiplier__c.remove('Per '): ps.rate__r.rate_multiplier__c;
                                                      tempMap.put(ps.rate__c, x);
                                                  }
                                          }
            return tempMap;
        } catch (Exception e) {
            PPW_StaticUtils.txThrowAuraException(e,'PPW_transmittalController','additionalRateStringMap','Transmittal-Form',tId,v);
            return null;
        }
        
    }
    
    
    
    public class reqWrap {
        public String psId{get;set;}
        public String cId{get;set;}
        public String confirmChoice{get;set;}
        public  String additionalRateInput{get;set;}
        public String customQuote{get;set;}
        public String rejectionReason{get;set;}
        public String reviewReason{get;set;}
        
    }
    
    @AuraEnabled
    public static ppw_censhareConnector.resWrap processConfirmation(String serviceReq) { //action to capture the confirmation, saves and rerenders the page on return..
        ppw_censhareConnector.resWrap rwrp = new ppw_censhareConnector.resWrap();
        if(serviceReq != null) {
            system.debug(serviceReq);
            reqWrap req =   (reqWrap)System.JSON.deserialize(serviceReq, reqWrap.class);
            //  try {
            project_services__c psToUpdate = [select id, rate__c,rate__r.rate_multiplier__c,rate__r.rate_amount__c,Censhare_XML_update_type__c ,Project__r.Title__r.Marty_Title_ID__c, Honor_dependencies__c, Estimated_Start_Date__c, Estimated_Completion_Date__c, 
                                              Actual_Completion_Date__c, Chatter_Count_Internal__c,Chatter_Count_External__c, Actual_Start_Date__c, Service__c, Vendor__c, amount__c, status__c, Additional_Rate_Input__c,
                                              Service_Name__c, Master_PT_Service__c,
                                              Custom_Quote_Amount__c,Base_Amount__c,has_been_kicked_off__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,
                                              Word_Count_Kicked_Off__c,Word_Count_Completed__c ,Word_Count_Cancelled__c,User_Input_Rate_Amount__c   from project_services__c where id = : req.psId]; 
            
            confirmation__c confirmToUpdate = new confirmation__c();
            
            datetime timeStamp = datetime.now();
            // boolean censhareUpdateStatus = false;
            
            if(req.confirmChoice == 'accept' && psToUpdate != null) {
                //if we are accepting, we need to determine if the adidtional rate is coming into play...
                //if it is the PS needs to be updated first so we can get the new values for the confirmation and replug the confirmed values...
                
                if(psToUpdate.has_been_kicked_off__c ) {
                    psToUpdate.Status__c = 'Kicked Off';
                }else{
                    psToUpdate.Status__c = 'Scheduled';
                }
                
                
                
                System.debug(req.additionalRateInput);
                system.debug('psToUpdate'+psToUpdate);
                psToUpdate.Additional_Rate_Input__c = req.additionalRateInput!=null&& req.additionalRateInput!=''?decimal.valueOf(req.additionalRateInput):psToUpdate.Additional_Rate_Input__c;
                if(psToUpdate.rate__r.rate_multiplier__c == 'Custom Quote') 
                    psToUpdate.Custom_Quote_Amount__c = req.customQuote !=null && req.customQuote !=''? decimal.valueOf(req.customQuote) : psToUpdate.Custom_Quote_Amount__c; 
                
                //ppw_projectControllerExtension pcontr = new ppw_projectControllerExtension();
                
                boolean promotext = false; 
                if(psToUpdate.Service_Name__c == 'Promo Text Creation' && psToUpdate.Master_PT_Service__c == false) 
                    promotext = false; 
                else 
                    promotext = true; 
                //boolean censhareUpdateStatus = false; 
                if(promotext && psToUpdate.has_been_kicked_off__c == false) {
                    psToUpdate.Censhare_XML_update_type__c = 'Update';
                    rwrp = censhareServerUpdate(psToUpdate);
                    if(rwrp.resStatus == true) {
                        
                        
                        update psToUpdate;
                        psToUpdate =[select id, rate__c, amount__c, Additional_Rate_Input__c, status__c,Base_Amount__c,
                                     Base_Amount_with_Currency__c,Rate_Amount_with_Currency__c,Rate_Amount__c
                                     
                                     from project_services__c where id = : req.psID];
                        
                        confirmToupdate.Confirmed_Amount__c = psToupdate.Amount__c;
                        confirmToupdate.Confirmed_Base_Amount__c = psToupdate.Base_Amount__c;
                        confirmToupdate.Confirmed_Base_Amount_With_Currency__c  = psToupdate.Base_Amount_with_Currency__c;
                        confirmToupdate.Confirmed_Amount_with_Currency__c  = psToupdate.Rate_Amount_with_Currency__c ;
                        confirmToupdate.Confirmed_Rate_Amount__c  = psToupdate.Rate_Amount_with_Currency__c ;
                        confirmToUpdate.Date_of_Confirmation__c = timeStamp;
                        confirmToUpdate.id = req.cID;
                        confirmToUpdate.Confirmation__c = 'Yes';
                        confirmToUpdate.Status__c = 'Confirmed';
                        confirmToUpdate.Confirmed_Addl_Rate_Input__c = req.additionalRateInput!=null&& req.additionalRateInput!=''?decimal.valueOf(req.additionalRateInput):psToUpdate.Additional_Rate_Input__c;
                        
                        update(confirmToupdate);
                        
                        //  rwrp.resStatus = true; 
                    } 
                } else {  // kicked off true
                    //if(psToUpdate.Status__c == 'Kicked Off') { // whens ps status is kiccked of we dont need to check call out status
                    update psToUpdate; // ps update for additional rate and custom quote.
                    ppw_handlerforCalculation rates1 = new ppw_handlerforCalculation();
                    List<Project_Services__c> psLst = rates1.ratecalc(new List<Project_Services__c> {psToUpdate});
                    update psLst; 
                    psToUpdate = [select id, rate__c,rate__r.rate_multiplier__c,rate__r.rate_amount__c,Censhare_XML_update_type__c ,Project__r.Title__r.Marty_Title_ID__c, Honor_dependencies__c, Estimated_Start_Date__c, Estimated_Completion_Date__c, 
                                  Actual_Completion_Date__c, Chatter_Count_Internal__c,Chatter_Count_External__c, Actual_Start_Date__c, Service__c, Vendor__c, amount__c, status__c, Additional_Rate_Input__c,
                                  Service_Name__c, Master_PT_Service__c,
                                  Custom_Quote_Amount__c,Base_Amount__c,has_been_kicked_off__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,
                                  Word_Count_Kicked_Off__c,Word_Count_Completed__c ,Word_Count_Cancelled__c,User_Input_Rate_Amount__c   from project_services__c where id = : req.psId];
                    
                    confirmToupdate.Confirmed_Amount__c = psToupdate.Amount__c;
                    confirmToupdate.Confirmed_Base_Amount__c = psToupdate.Base_Amount__c; 
                    confirmToUpdate.Date_of_Confirmation__c = timeStamp;
                    confirmToUpdate.id = req.cID;
                    confirmToUpdate.Confirmation__c = 'Yes';
                    confirmToUpdate.Status__c = 'Confirmed';
                    confirmToUpdate.Confirmed_Addl_Rate_Input__c = req.additionalRateInput!=null && req.additionalRateInput!=''?decimal.valueOf(req.additionalRateInput):psToUpdate.Additional_Rate_Input__c;
                    
                    update(confirmToupdate); 
                    rwrp.resStatus = true; 
                }
                
            }
            
            if(req.confirmChoice == 'reject') {
                confirmToUpdate.Date_of_Confirmation__c = timeStamp;
                confirmToUpdate.id = req.cID;
                confirmToUpdate.Confirmation__c = 'No';
                confirmToUpdate.Status__c = 'Confirmed';
                confirmToupdate.Rejection_Reason__c = req.rejectionReason;
                
                boolean promotext = false; 
                if(psToUpdate.Service_Name__c == 'Promo Text Creation' && psToUpdate.Master_PT_Service__c == false) 
                    promotext = false; 
                else 
                    promotext = true; 
                if(promotext && psToUpdate.has_been_kicked_off__c == false) { // kicked off false
                    psToUpdate.Id = req.psID;
                    psToUpdate.Status__c = 'In Planning';
                    psToUpdate.Censhare_XML_update_type__c = 'Update';
                    rwrp = censhareServerUpdate(psToUpdate);
                    if(rwrp.resStatus == true || promotext == false) {
                        update(psToUpdate);
                        update(confirmToupdate);
                        if(promotext == false) 
                            rwrp.resStatus = true; 
                    }
                } else { // kicked off true
                    update(confirmToupdate);
                    rwrp.resStatus = true; 
                }
            }
            if(req.confirmChoice == 'review') {
                confirmToUpdate.id = req.cID;
                confirmToUpdate.Status__c = 'Review Requested';
                confirmToupdate.Reason_for_Review__c = req.reviewReason;
                
                update(confirmToupdate);
                rwrp.resStatus = true;
            }
            
            psToUpdate =[select id, rate__c, amount__c, project__r.Title__r.Name,project__r.Title__r.PR_Manager__c,
                         project__r.name, project__r.Title__r.Marty_Title_ID__c,status__c, Censhare_XML_update_type__c , Honor_dependencies__c, Estimated_Start_Date__c, Estimated_Completion_Date__c, 
                         Service__c, Vendor__c, 
                         Additional_Rate_Input__c, has_been_kicked_off__c,MBO_Fee__c,
                         Actual_Completion_Date__c,Chatter_Count_Internal__c,Chatter_Count_External__c,Actual_Start_Date__c ,Service__r.Name, Service__r.Confirmation_Notifications__c,
                         project__r.Title__r.Production_Manager__c,project__r.Title__r.Acquiring_Editor__c,project__r.Title__r.Art_Director__c,
                         project__r.Title__r.Author_Relations_Manager__c,project__r.Title__r.Current_Editor__c,project__r.Title__r.KiM_Art_Director__c,
                         project__r.Title__r.Marketing_Manager__c,project__r.Title__r.Content_Producer__c,
                         project__r.Series__r.Production_Manager__c,project__r.Series__r.Acquiring_Editor__c,project__r.Series__r.Art_Director__c,
                         project__r.Series__r.Author_Relations_Manager__c,project__r.Series__r.Current_Editor__c,project__r.Series__r.KiM_Art_Director__c,
                         project__r.Series__r.Marketing_Manager__c,project__r.Series__r.Content_Producer__c, project__r.Series__r.Series_Title__c, project__r.Series__r.Wombat_Series_ID__c,
                         User_Input_Rate_Amount__c,
                         rate__r.Rate_Multiplier__c,
                         rate__r.Rate_Amount__c,rate__r.Rate_Currency__c ,Service_Type_Complexity__c
                         from project_services__c where id = : req.psID];
            if(confirmToupdate.id!=null)             
                sendEmail(psToUpdate ,confirmToupdate.id);
            
        } 
        return rwrp;    
    }
    
    
    
    public static ppw_censhareConnector.resWrap censhareServerUpdate(project_services__c cPS) {
        //  try {
        ppw_censhareConnector.resWrap rwrp = new ppw_censhareConnector.resWrap();
        if(cPS != null) {
            ppw_censhareConnector ppwCen = new ppw_censhareConnector();
            String xml = ppwCen.censhareXMLBuilder(new List<project_services__c>{cPS});
            system.debug('xml'+xml);
            // ppw_censhareConnector.resWrap rwrp = new ppw_censhareConnector.resWrap();
            if(!test.isrunningTest())
                rwrp = ppw_censhareConnector.censhareServiceSync(xml); // censhare Callout for update
            if(test.isrunningTest())
                rwrp = PPW_TestDataFactory.setPasitiveTestData(cPS);        
            system.debug('rwrp'+rwrp); 
            if(rwrp.resStatus == false && !rwrp.resPs.isEmpty()) { 
                
                project_services__c ps = new project_services__c(id=cPS.id,Censhare_XML_Error_Response__c=rwrp.resPs.values()[0].Censhare_XML_Error_Response__c); 
                update(ps); 
                //  return rwrp.resStatus;
                return rwrp;
            }
            if(rwrp.resStatus == true) { 
                cPS.Estimated_Start_Date__c = rwrp.resPs.get(cPS.id).Estimated_Start_Date__c; 
                cPS.Estimated_Completion_Date__c = rwrp.resPs.get(cPS.id).Estimated_Completion_Date__c; 
                update(cPS);
                //return rwrp.resStatus;
                return rwrp;
            }
            return rwrp;   
        }  
        return rwrp; 
        /* } catch (Exception e) {
PPW_StaticUtils.txThrowAuraException(e,'PPW_transmittalController','censhareServerUpdate','Transmittal-Form',tId,v);
return null;
} */
    }
    @testvisible
    private static void sendEmail(project_services__c ps,String cid) {
        try {
            Messaging.SingleEmailMessage[] Messages =   new List<Messaging.SingleEmailMessage>();
            confirmation__c cRec= [Select id,Name,Confirmed_Amount__c,Confirmed_Rush_Fee__c,Confirmed_Amount_with_Currency__c,Status__c,confirmation__c,Confirmed_Currency_Amount__c,
                                   Confirmed_MBO_Fee__c,Confirmed_Base_Amount_With_Currency__c,Confirmed_MBO_Fee_with_Currency__c, Confirmed_Total_Rate_Amount__c,Confirmed_Rate_Amount__c
                                   from confirmation__c  where id=:cId limit 1];
            Map<String,String> AliasEmailIds = new Map<String,String>();
            for(User u : [SELECT alias, Id, Email FROM User where isActive=true]) 
                AliasEmailIds.put(u.alias,u.Email);
            
            String status = ((cRec.status__c=='Confirmed' && cRec.confirmation__c=='Yes')? 'Accepted' : ((cRec.status__c=='Review Requested' && cRec.confirmation__c=='Yes') ? 'Review Requested' : (cRec.status__c=='Confirmed' && cRec.confirmation__c=='No')? 'Rejected' : ''));
            String eBody='';
            if(ps.project__r.Series__r!=null)
                eBody+= 'The project service "'+ ps.Service_Type_Complexity__c + '" for title ['+ ps.project__r.Series__r.Series_Title__c+']' + '(' + ps.project__r.Series__r.Wombat_Series_ID__c + ')' +' has been ' + status;
            else    
                eBody+= 'The project service "'+ ps.Service_Type_Complexity__c + '" for title ['+ps.project__r.Title__r.Name+']' + '(' + ps.project__r.Title__r.Marty_Title_ID__c + ')' +' has been ' + status;
            eBody+= '<br/>' + 'Details are below for specific action.'+ '<br/>';
            ebody+= '<br/>'+ 'Project:['+ ps.project__r.Name +']';
            eBody += '<br/>' + 'Salesforce Project Link <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ps.project__c+'">'+ ps.project__r.Name + '</a>'+'<br/>';
            //eBody += '<br/>' + 'Censhare Project Link <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ps.project__c+'">'+ ps.project__r.Name + '</a>'+'<br/>';
            eBody += '<br/><b> Confirmation/Service Details : </b> <br/>'; // relatedTo.project_services__r.status__c
            eBody += 'Project Service :' + ps.Service_Type_Complexity__c + '<br/>';
            eBody += ' Project Service Status:'+ps.status__c+ '<br/>';
            if(ps.status__c!=null)
                eBody += ' Confirmation Status :'+ cRec.status__c +'<br/>';
            if(ps.Estimated_Start_Date__c!=null)
                eBody += ' Estimated Start Date : '+ getDate(ps.Estimated_Start_Date__c)+' <br/>';
            if(ps.Estimated_Completion_Date__c!=null)
                eBody += ' Estimated Completion Date : '+ getDate(ps.Estimated_Completion_Date__c) +'<br/>';
            if(ps.Actual_Start_Date__c!=null)
                eBody += ' Actual Start Date : '+ getDate(ps.Actual_Start_Date__c) +'<br/>';
            if(ps.Actual_Completion_Date__c!=null)
                eBody += ' Actual Completion Date : '+ getDate(ps.Actual_Completion_Date__c) +'<br/>';
            if(ps.rate__r.Rate_Amount__c!=null)
                eBody += ' Your Service Rate : '+ ps.rate__r.Rate_Amount__c +'('+ps.rate__r.Rate_Multiplier__c +')' +'<br/>';  
            if(cRec.Confirmed_Base_Amount_With_Currency__c!=null)
                eBody += ' Service Base Amount : '+ cRec.Confirmed_Base_Amount_With_Currency__c +'<br/>';
            if(cRec.Confirmed_Rush_Fee__c!=null && cRec.Confirmed_Rush_Fee__c!=0)   
                eBody += ' Rush Fee : '+ cRec.Confirmed_Rush_Fee__c + '%'+'<br/>';
            if(cRec.Confirmed_Amount_with_Currency__c!=null)   
                eBody += ' Service Amount : '+ cRec.Confirmed_Amount_with_Currency__c + '%'+'<br/>';
            //  if(cRec.Confirmed_Rate_Amount__c!=null)
            // eBody += ' Service Amount : '+ cRec.Confirmed_Rate_Amount__c +'<br/>';
            if(cRec.Confirmed_MBO_Fee__c !=null && cRec.Confirmed_MBO_Fee__c != 0.00)
                eBody += ' MBO Fee : '+ cRec.Confirmed_MBO_Fee_with_Currency__c +'<br/>';
            if(cRec.Confirmed_Total_Rate_Amount__c!=null)
                eBody += ' Total Rate Amount : '+ cRec.Confirmed_Total_Rate_Amount__c +'<br/>';
            
            
            List<String> notfiIds = new List<String>();
            List<String> ccNotfiIds = new List<String>();
            for(String e: getNotifyUser(ps)) 
                if(AliasEmailIds.containsKey(e))
                notfiIds.add(AliasEmailIds.get(e));
            
            system.debug(notfiIds);
            /* notfiId = ps.project__r.Title__r.Production_Manager__c!= null? ps.project__r.Title__r.Production_Manager__c : 
ps.project__r.Title__r.Acquiring_Editor__c != null? ps.project__r.Title__r.Acquiring_Editor__c : 'pika';
notfiId = AliasEmailIds.get(notfiId);           
if(Label.PPW_prConfNotif.containsIgnoreCase(ps.Service__r.Name) && ps.project__r.Title__r.PR_Manager__c != null) {
ccNotfiId = AliasEmailIds.get(notfiId);
notfiId = AliasEmailIds.get(ps.project__r.Title__r.PR_Manager__c);
}
*/
            if(!notfiIds.isEmpty()) {
                messages.add(sendEmailToNotifier( null,notfiIds, ccNotfiIds ,eBody,status,ps));
                if(!messages.isEmpty())
                    Messaging.sendEmail(messages); 
            } 
        } catch (Exception e) {
            PPW_StaticUtils.txThrowAuraException(e,'PPW_transmittalController','sendEmail','Transmittal-Form',tId,v);
            // return null;
        }    
    }
    
    // get notify users for based on service record have notify field value
    public static set<String> getNotifyUser(Project_Services__c ps) {
        try {
            set<String> notifyUser = new set<String>();
            List<String> titleFields = new List<String>();
            String str = ps.Service__r.Confirmation_Notifications__c;
            if(str!=null) 
                if(str.contains(';'))
                titleFields = str.split(';');
            else
                titleFields.add(str);     
            
            for(String s: titleFields) {
                String nUser;
                if(ps.getSobject('project__r').getSobject('Series__r')!=null) {
                    if(ps.getSobject('project__r').getSobject('Series__r').get(s)!=null)
                        nUser = String.valueOf(ps.getSobject('project__r').getSobject('Series__r').get(s));
                } else  { 
                    if(ps.getSobject('project__r').getSobject('Title__r').get(s)!=null)
                        nUser = String.valueOf(ps.getSobject('project__r').getSobject('Title__r').get(s));
                   }     
                if(nUser!=null)
                    notifyUser.add(nUser);
            }
            
            if(!titleFields.isEmpty())
                if(notifyUser.isEmpty())
                notifyUser.add('pika');
            
            return notifyUser;
        } catch (Exception e) {
            PPW_StaticUtils.txThrowAuraException(e,'PPW_transmittalController','getNotifyUser','Transmittal-Form',tId,v);
            return null;
        }  
    }
    
    
    @testvisible
    private static string getDate(dateTime dtime) {
        return date.newInstance(dtime.year(), dtime.month(), dtime.day()).format();
    } 
    
    public static Messaging.SingleEmailMessage sendEmailToNotifier(String serRepId, List<String> notfiIds, List<String> ccNotfiIds,String emailTempBody,String status,project_services__c ps) {
        try {
            String subject = status +' Confirmation notification for Title : '+ps.project__r.Title__r.Name +'(' + ps.project__r.Title__r.Marty_Title_ID__c + ')'; 
            
            OrgWideEmailAddress[] orgEmail = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where address = 'kpav321@gmail.com'];
            Messaging.SingleEmailMessage message1 = new Messaging.SingleEmailMessage();
            message1.toAddresses = notfiIds;
            message1.ccAddresses = ccNotfiIds; 
            message1.HtmlBody = emailTempBody; 
            message1.subject = subject; 
            if(!orgEmail.isEmpty())
                message1.OrgWideEmailAddressId = orgEmail[0].id;
            return message1;
        } catch (Exception e) {
            PPW_StaticUtils.txThrowAuraException(e,'PPW_transmittalController','sendEmailToNotifier','Transmittal-Form',tId,v);
            return null;
        }  
        
    }
    
    public static map<id, project_services__c> allProjectServiceMap() {
        
        map<id, project_services__c> tempMap = new map<id, project_services__c>([
            SELECT id, Name, Service__c, Vendor__c, vendor__r.Name,amount__c, Service__r.Service_Rate_Type__c
            FROM Project_Services__c 
            WHERE Project__c = : projectID]);
        
        return tempMap;
        
    }
    
      @AuraEnabled(cacheable=true)
   public static String getSessionId() {
    return UserInfo.getSessionId();
  }
    
    
    
}