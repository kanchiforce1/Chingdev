/***********************************
Author: Amazon Apub // michatem@, kkolla@
Visualforce Page Extended:  PPW_Transmittal.vfp
Description: Controller for the PPW TRansmittal Form
************************************/

public with sharing class PPW_transmittalController {
    public string v;
    public string vendorName;
    //public string v = 'a09i000000C2Ekz';
    public string tId;//=ApexPages.currentPage().getParameters().get('titleId'); //project service id
    //public string ps = 'a0r1g000001175YAAQ';
    public set<string> confirmationTblHeaders{get;set;}
    public boolean rushFeeFlg{get; set;} 
    
    public boolean renderTransmittalData {get; set;}
    public string titleID {get; set;}
    public string projectID {get; set;}
    
    //gets and sets
    public integer openConfirmationCount {get; set;}
    public integer confirmedConfirmationCount {get; set;}
    public list<confirmation__c> allRelatedConfirmationCheck {get; set;}
    
    public map<string, list<confirmation__c>> confirmationListsMap {
        get;
        set;
    }
    
    public list<string> confirmationStatusList {
        get;
        set;
    }
    
    public void doinit() { 
        tId = ApexPages.currentPage().getParameters().get('titleId'); //project service id 
        v = ApexPages.currentPage().getParameters().get('v'); 
        } 
    
    public Map<String,List<confirmation__c>> serviceBasedConfirmationMap {get;set;}
    public map<string, List<confirmation__c>> serviceBasedMostActionConMap{get;set;}
    public Map<String,set<string>> statusName{get;set;}
    public set<string> serviceName{get;set;}
    public Map<String,String> serviceNameId{get;set;}
    public Set<String> serviceNameHistorys{get;set;}
    public string serviceNamesCheck{get;set;}
    
    public void getConfirmationMap() {
        confirmationListsMap = new map<string, list<confirmation__c>>();
        serviceBasedActionCon = new map<String,Boolean>();
        serviceBasedCon = new map<String,Boolean>();
        confirmationStatusList = new list<string>();
        serviceName = new set<string>();
        serviceNameId = new Map<String,String>();
        confirmationTblHeaders = new set<String>{'Status','Sent','Confirmed Date','Service','Amount'}; 
        //  serviceName1 = new set<string>();
        
        serviceBasedConfirmationMap = new Map<String,List<confirmation__c>>();
        serviceBasedMostActionConMap= new map<string, List<confirmation__c>>(); //Custom Quote
        
        for(confirmation__c c: [
            select id, name, project_services__c, status__c, confirmation__c, date_of_confirmation__c, confirmed_amount__c, confirmed_service__c, confirmed_vendor__c, rejection_reason__c,
            project_services__r.Additional_Rate_Input__c, project_services__r.estimated_start_date__c, project_services__r.estimated_completion_date__c, project_services__r.actual_start_date__c, 
            project_services__r.actual_completion_date__c, project_services__r.mbo_fee__c, project_services__r.rate__r.rate_amount__c, project_services__r.rate__r.rate_multiplier__c, project_services__r.rate_amount__c, project_services__r.rate__c,
            project_services__r.rate_currency__c, project_services__r.rush_fee__c, project_services__r.service__r.service_rate_type__c, project_services__r.vendor_notes_RT__c, project_services__r.status__c,
            project_services__r.vendor__c, project_services__r.vendor__r.name, project_services__r.Service_Type_Complexity__c,Confirmed_Currency_Amount__c,Confirmed_Rate_Amount__c,
            confirmed_rush_fee__c, confirmed_addl_rate_input__c,Reason_for_Review__c,open_confirmation__c,CreatedDate,project_services__r.project__r.Title__r.Pre_Dev_Edit_Word_Count__c,project_services__r.Custom_Quote_Amount__c, 
            Project_Services__r.Word_Count_In_Planning__c,Project_Services__r.Word_Count_Confirming__c,Project_Services__r.Word_Count_Scheduled__c,
            Project_Services__r.Word_Count_Completed__c,Project_Services__r.Word_Count_Kicked_Off__c,Project_Services__r.Word_Count_Cancelled__c,Confirmed_Base_Amount__c,confirmed_word_count__c,
            Confirmed_Total_Rate_Amount__c,Confirmed_Base_Amount_With_Currency__c,Confirmed_MBO_Fee_with_Currency__c,project_services__r.Base_Amount__c,project_services__r.User_Input_Rate_Amount__c,
             Confirmed_MBO_Fee__c 
            from confirmation__c 
            where project_services__r.project__c=:projectID 
            AND Confirmed_Vendor__c =: vendorName AND project_services__r.status__c!='Cancelled' AND status__c !='Internal Closed' 
            ORDER BY 
            project_services__r.service__r.service_rate_type__c,LastModifieddate DESC
        ]) {
            //String sType = c.project_services__c;
            String sType = c.project_services__r.service__r.service_rate_type__c;
            if(sType!=null) {
            serviceNameId.put(sType, c.project_services__r.service__r.service_rate_type__c);
                if(!serviceBasedMostActionConMap.containsKey(sType)) {
                    if(c.status__c=='Confirmed' && c.confirmation__c=='No'){ 
                        serviceBasedMostActionConMap.put(sType,new List<confirmation__c>());
                    } else 
                        serviceBasedMostActionConMap.put(sType, new List<confirmation__c>{c});
                    serviceBasedConfirmationMap.put(sType,new List<confirmation__c>{c}); 
                }else {
                    if(serviceBasedConfirmationMap.containsKey(sType))
                        
                        serviceBasedConfirmationMap.get(sType).add(c);
                    else
                        serviceBasedConfirmationMap.put(sType,new List<confirmation__c>{c});
                }
                if(c.Confirmed_Rush_Fee__c !=0 && c.Confirmed_Rush_Fee__c != null && c.Confirmed_Rush_Fee__c !=0.00 ) {
                    confirmationTblHeaders.add('Rush Fee');
                    rushFeeFlg = true; 
                    
                } 
            } 
        }          
        
        
        
        if(!serviceBasedConfirmationMap.isEmpty()) {
            // confirmationListsize = true;
            serviceBasedConfirmation = true;
            
        }
        
        if(!serviceBasedMostActionConMap.isEmpty()) {
            // confirmationListsize = true;
            // serviceBasedConfirmation = true;
            serviceBasedMostActionCon = true;
        }
        if(!serviceBasedConfirmationMap.isEmpty() || !serviceBasedMostActionConMap.isEmpty()){
            serviceName.addAll(serviceBasedConfirmationMap.keyset());
            serviceName.addAll(serviceBasedMostActionConMap.keyset());
            for(string s: serviceName) {
                if(serviceBasedConfirmationMap.containskey(s))
                    serviceBasedCon.put(s,true);
                else
                    serviceBasedCon.put(s,false) ;
                
                if(serviceBasedMostActionConMap.containskey(s)){
                    if(serviceBasedMostActionConMap.get(s).size()>0)
                    serviceBasedActionCon.put(s,true);
                else
                    serviceBasedActionCon.put(s,false) ;
                    }else
                    serviceBasedActionCon.put(s,false) ;
            }
            
        } 
        
        System.debug(serviceBasedConfirmationMap);
        System.debug(serviceBasedMostActionConMap);
        
    }
    public map<String,Boolean> serviceBasedCon{get;set;}
    public map<String,Boolean> serviceBasedActionCon{get;set;}
    public boolean confirmationListsize{get;set;}
    public boolean serviceBasedConfirmation{get;set;}
    public boolean serviceBasedMostActionCon{get;set;}
    
    public map<string, list<ASIN__c>> formatListsMap {
        get{ //grab all relative formats to use in the format listing
            map<string, list<asin__c>> tempFormatMap = new map<string, list<asin__c>>();
            list<asin__c> allRelatedFormats = new list<asin__c>([
                select id, name, isbn_13__c, asin__c, trim_height__c, trim_width__c, apub_publish_date__c, initial_page_count__c, interior_paper_stock__c
                from asin__c 
                where title__c = :titleID AND name IN ('Digital', 'Paperback', 'Hardcover')
            ]);
            
            if(!allRelatedFormats.isEmpty()){
                for(asin__c f : allRelatedFormats){
                    if(tempFormatMap.containsKey(f.name)){
                        List<asin__c> temp = tempFormatMap.get(f.name);
                        temp.add(f);
                        tempFormatMap.put(f.name,temp);
                    }else{
                        List<asin__c> temp = new List<asin__c>();
                        temp.add(f);
                        tempFormatMap.put(f.name,temp);
                    }
                }
            }
            system.debug(tempFormatMap);
            return tempFormatMap;
        }
        set;
    }
    
    public list<string> formatNameList {
        get{
            set<string> tempSet = new set<string>();
            for(asin__c a : [select id, name from asin__c where title__c = :titleID AND name IN ('Digital', 'Paperback', 'Hardcover')]){
                tempSet.add(a.name);
            }
            
            list<string> tempList = new list<string>();
            tempList.addAll(tempSet);
            return tempList;
        }
        set;
    }
    
    public map<string, list<service_prep_response__c>> servicePrepListsMap {
        get{
            map<string, list<service_prep_response__c>> tempMap = new map<string, list<service_prep_response__c>>();
            list<service_prep_response__c> allNeededResponses = new list<service_prep_response__c>([
                select id, name, service_prep__r.Name, service_prep_question__r.question__c, response__c, service_prep_question__r.Sub_Category__c, service_prep_question__r.transmittal_label__c
                from service_prep_response__c 
                where service_prep__c in (select id from service_prep__c where project__c = :projectID) and service_prep_question__r.transmittal_mapping__c =true and response__c !=null
            ]);
            
            if(!allNeededResponses.isEmpty()){
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
        set;
    }
    public map<string, string> subCatMap {
        get
        {
            map<string, string> tempSubCatMap = new map<string, string>();
            for(service_prep_response__c spr : [
                select service_prep_question__r.Sub_Category__c 
                from service_prep_response__c  
                where service_prep__c in (select id from service_prep__c where project__c = :projectID) 
                and service_prep_question__r.transmittal_mapping__c =true and response__c !=null order by service_prep_question__r.Sub_Category__c ASC]){
                    string cleanString = spr.service_prep_question__r.Sub_Category__c.remove('(');
                    cleanstring = cleanstring.remove(')');
                    cleanstring = cleanstring.remove(',');
                    tempSubCatMap.put(spr.service_prep_question__r.Sub_Category__c, cleanString.deleteWhitespace());
                }
            
            return tempSubCatMap;
        }
        set;
    }
    
    
    public string authorString {
        get{
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
                    a = String.isNotBlank(tc.pen_name1__c)?  tc.pen_name1__c+' ('+tc.role__c+')': '';
                    break;
                }
                if(authors.size() > 1){
                    if(currentCount == 0 || (currentCount > 0 && currentCount < (authors.size()-1))){
                        a += String.isNotBlank(tc.pen_name1__c)?  tc.pen_name1__c+' ('+tc.role__c+')'+', ': '';
                        currentCount ++;
                        continue;
                    }else{
                        a += String.isNotBlank(tc.pen_name1__c)? tc.pen_name1__c +' ('+tc.role__c+')': '';
                    }
                }
            }
            return a;
        }
        set;
    }
    
    public string relatedTitles {
        get{ //return a comma separated list of related titles to either the series or the author... should this be maxed?
            return 'Need to return a nicely formatted string of the related titles...';
        }
        set;
    }
    
    public title__c currentTitle {
        get{
            title__c t = new title__c ();
            t=[
                select id, name, full_title_name__c, sub_title__c, marty_title_id__c, external_imprint__c, category__c, sub_category__c, Pre_Dev_Edit_Word_Count__c, 
                //Post_Dev_Edit_Word_Count__c,
                series__c
                from title__c 
                where id = :titleID limit 1
            ];
            
            return t;
        }
        set;
    }
    
    public project_services__c psToUpdate;// = new project_services__c(); 
    public ppw_transmittalController() { //constructor
        additionalRateInput = null;
        customQuote = null;
        tId = ApexPages.currentPage().getParameters().get('titleId'); //project service id 
        v = ApexPages.currentPage().getParameters().get('v'); 
        psToUpdate = new project_services__c(); 
        User u = [SELECT contact.vendor__c FROM User WHERE id=: Userinfo.getUserId()];
        if(u.contact.vendor__c!=null)
            v = u.contact.vendor__c;//ApexPages.currentPage().getParameters().get('v');
        //else
           // v = ApexPages.currentPage().getParameters().get('v');
        system.debug(v); //getCurrentRequestUrl()
        system.debug(url.getCurrentRequestUrl());  //EncodingUtil 
        system.debug(EncodingUtil.urlDecode(String.valueOf(url.getCurrentRequestUrl()),'UTF-8'));
        system.debug(v);
        if(v!=null) 
        vendorName = [Select Name from vendor__c where id=:v limit 1].Name;
        renderTransmittalData = false;
        confirmationListsize = false;
        confirmationListsMap = new map<string, list<confirmation__c>>();
        confirmationStatusList = new list<string>();
        psToUpdate = new project_services__c(); 
       /* psToUpdate = [select id, rate__c,rate__r.rate_multiplier__c,rate__r.rate_amount__c,Censhare_XML_update_type__c ,Project__r.Title__r.Marty_Title_ID__c, Honor_dependencies__c, Estimated_Start_Date__c, Estimated_Completion_Date__c, 
                Actual_Completion_Date__c, Actual_Start_Date__c, Service__c, Vendor__c, amount__c, status__c, Additional_Rate_Input__c,
                     Custom_Quote_Amount__c,Base_Amount__c,has_been_kicked_off__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,
                     Word_Count_Kicked_Off__c,Word_Count_Completed__c ,Word_Count_Cancelled__c  from project_services__c where id = :ps]; 
       */
       system.debug(tId);
        list<project__c> currentProject = new list<project__c>([
            select id, title__c from project__c where title__r.Marty_Title_ID__c=:tId limit 1
        ]);
        
        if (currentProject.size()==1){
            projectID = currentProject.get(0).id;
            titleID = currentProject.get(0).title__c;
            System.debug('v'+v);
            allRelatedConfirmationCheck=[
                select id, status__c from confirmation__c 
                where project_services__r.project__c=:projectID 
                and project_services__r.vendor__c =:v 
                and (confirmation__c = 'Yes' OR status__c = 'Open') 
                and project_services__r.status__c not in ('Cancelled', 'Completed', 'In Planning')
                ORDER BY project_services__r.estimated_start_date__c ASC];
            
            List<Marketplace__c> aList = [SELECT id,Amazon_Street_Date__c from Marketplace__c WHERE Amazon_Street_Date__c <= TODAY AND Format__r.Title__c =: titleID AND Format__r.Name = 'Digital']; 
            system.debug(titleID); 
            if(allRelatedConfirmationCheck.size() > 0){
                renderTransmittalData=true;
            }
            if(aList == null) { 
                // renderTransmittalData=false; 
            } else {
                if(!aList.isEmpty()) 
                    renderTransmittalData=false; 
            }
        }
        getConfirmationMap();
    }
    
    public String psID{get;set;}
    public String cID{get;set;}
    public String confirmChoice{get;set;}
    public string rejectionReason {get; set;}
    public string reviewReason {get; set;}
    public string rejectionReasonInput {get; set;}
    
    public string additionalRateInput {get; set;}
    public string customQuote {get; set;} //this is the value for enter quote amount in ps record
    public Map<String,rate__c> ratePsMap;
    public boolean additionalRateInputCheck {get; set;}
    public map<string, string> additionalRateStringMap {
        get{
            map<string, string> tempMap = new map<string, string>();
            
            for(project_services__c ps : [select rate__c,rate__r.rate_multiplier__c,id from project_services__c where project__c = :projectID]){ 
                string x;
                if(ps.rate__c!=null) {
                x = ps.rate__r.rate_multiplier__c.remove('Per ');
                tempMap.put(ps.rate__c, x);
            }
            }
            return tempMap;
        }
        set;
    }
    
    public map<string, boolean> additionalRateInputMap {
        get{
            set<string> multiplierSet = new set<string>();
            map<string, boolean> tempMap = new map<string, boolean>();
            multiplierSet.addAll(label.ppw_addlInput_rateTypes.split(','));
            for(rate__c r : [select id, rate_multiplier__c from rate__c]){
                if(multiplierSet.contains(r.rate_multiplier__c)){
                    tempMap.put(r.id, true);
                }else{
                    tempMap.put(r.id, false);
                }
            }
            return tempMap;
        }
        set;
    }
    
    public map<string, boolean> additionalRateInputMap_vendor {
        get{
            set<string> multiplierSet = new set<string>();
            map<string, boolean> tempMap = new map<string, boolean>();
            multiplierSet.addAll(label.ppw_addlInput_rateTypes_vendor.split(','));
            for(rate__c r : [select id, rate_multiplier__c from rate__c]){
                if(multiplierSet.contains(r.rate_multiplier__c)){
                    tempMap.put(r.id, true);
                }else{
                    tempMap.put(r.id, false);
                }
            }
            return tempMap;
        }
        set;
    }
    
    public void processConfirmation() { //action to capture the confirmation, saves and rerenders the page on return..
        //  project_services__c psToUpdate = new project_services__c();
         psToUpdate = [select id, rate__c,rate__r.rate_multiplier__c,rate__r.rate_amount__c,Censhare_XML_update_type__c ,Project__r.Title__r.Marty_Title_ID__c, 
         Honor_dependencies__c, Estimated_Start_Date__c, Estimated_Completion_Date__c, 
                Actual_Completion_Date__c, Actual_Start_Date__c, Service__c, Vendor__c, amount__c, status__c, Additional_Rate_Input__c,Service_Name__c ,Master_PT_Service__c ,
                User_Input_Rate_Amount__c,
                     Custom_Quote_Amount__c,Base_Amount__c,has_been_kicked_off__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,
                     Word_Count_Kicked_Off__c,Word_Count_Completed__c ,Word_Count_Cancelled__c  from project_services__c where id = :psId]; 
       
        confirmation__c confirmToUpdate = new confirmation__c();
        
        datetime timeStamp = datetime.now();
        // boolean censhareUpdateStatus = false;
        
        if(confirmChoice == 'accept' && psToUpdate != null) {
            //if we are accepting, we need to determine if the adidtional rate is coming into play...
            //if it is the PS needs to be updated first so we can get the new values for the confirmation and replug the confirmed values...
            
            if(psToUpdate.has_been_kicked_off__c) {
                psToUpdate.Status__c = 'Kicked Off';
            }else{
                psToUpdate.Status__c = 'Scheduled';
            }
        
            
            psToUpdate.Censhare_XML_update_type__c = 'Update';
            System.debug(additionalRateInput);
            system.debug('psToUpdate'+psToUpdate);
            psToUpdate.Additional_Rate_Input__c = additionalRateInput!=null&&additionalRateInput!=''?decimal.valueOf(additionalRateInput):psToUpdate.Additional_Rate_Input__c;
            if(psToUpdate.rate__r.rate_multiplier__c == 'Custom Quote') 
                psToUpdate.Custom_Quote_Amount__c = customQuote !=null && customQuote !=''? decimal.valueOf(customQuote) : psToUpdate.Custom_Quote_Amount__c; 
           
           boolean promotext = false; 
           if(psToUpdate.Service_Name__c == 'Promo Text Creation' && psToUpdate.Master_PT_Service__c == false) 
           promotext = false; 
           else 
           promotext = true; 
           boolean censhareUpdateStatus = false; 
           if(promotext) 
            //ppw_projectControllerExtension pcontr = new ppw_projectControllerExtension();
            censhareUpdateStatus = censhareServerUpdate(psToUpdate);
            if(censhareUpdateStatus || promotext == false) { 
                           
               //update psToUpdate;
                psToUpdate =[select id, rate__c, amount__c, Additional_Rate_Input__c, status__c,Base_Amount__c from project_services__c where id = :psID];
                
                confirmToupdate.Confirmed_Amount__c = psToupdate.Amount__c; 
                confirmToupdate.Confirmed_Base_Amount__c = psToupdate.Base_Amount__c; 
                confirmToUpdate.Date_of_Confirmation__c = timeStamp; 
                confirmToUpdate.id = cID;
                confirmToUpdate.Confirmation__c = 'Yes';
                confirmToUpdate.Status__c = 'Confirmed';
                confirmToUpdate.Confirmed_Addl_Rate_Input__c = additionalRateInput!=null&&additionalRateInput!=''?decimal.valueOf(additionalRateInput):psToUpdate.Additional_Rate_Input__c;
                update(confirmToupdate); 
            }
            if(psToUpdate.Status__c == 'Kicked Off') { // whens ps status is kiccked of we dont need to check call out status 
                
                confirmToupdate.Confirmed_Amount__c = psToupdate.Amount__c;
                confirmToupdate.Confirmed_Base_Amount__c = psToupdate.Base_Amount__c; 
                confirmToUpdate.Date_of_Confirmation__c = timeStamp;
                confirmToUpdate.id = cID;
                confirmToUpdate.Confirmation__c = 'Yes';
                confirmToUpdate.Status__c = 'Confirmed';
                confirmToUpdate.Confirmed_Addl_Rate_Input__c = additionalRateInput!=null&&additionalRateInput!=''?decimal.valueOf(additionalRateInput):psToUpdate.Additional_Rate_Input__c;
                
                update(confirmToupdate); 
            } 
            
        }
        
        if(confirmChoice == 'reject') {
            psToUpdate.Id = psID;
            psToUpdate.Status__c = 'In Planning';
            psToUpdate.Censhare_XML_update_type__c = 'Update';
            confirmToUpdate.Date_of_Confirmation__c = timeStamp;
            confirmToUpdate.id = cID;
            confirmToUpdate.Confirmation__c = 'No';
            confirmToUpdate.Status__c = 'Confirmed';
            confirmToupdate.Rejection_Reason__c = rejectionReason;
            
            additionalRateInput = null; //reset the value of the incoming field
            boolean promotext = false; 
            if(psToUpdate.Service_Name__c == 'Promo Text Creation' && psToUpdate.Master_PT_Service__c == false) 
                promotext = false; 
            else 
                promotext = true; 
            boolean censhareUpdateStatus = false; 
            if(promotext) 
            censhareUpdateStatus = censhareServerUpdate(psToUpdate);
                if(censhareUpdateStatus || promotext == false) {                
                update(psToUpdate);
                update(confirmToupdate);
            }
        }
        if(confirmChoice == 'review') {
            confirmToUpdate.id = cID;
            confirmToUpdate.Status__c = 'Review Requested';
            confirmToupdate.Reason_for_Review__c = reviewReason;
            
            update(confirmToupdate);
        }
        
        psToUpdate =[select id, rate__c, amount__c, project__r.Title__r.Name,project__r.Title__r.PR_Manager__c,
                     project__r.name, project__r.Title__r.Marty_Title_ID__c,status__c, Censhare_XML_update_type__c , Honor_dependencies__c, Estimated_Start_Date__c, Estimated_Completion_Date__c, 
                     Service__c, Vendor__c, 
                     Additional_Rate_Input__c, has_been_kicked_off__c,MBO_Fee__c,
                     Actual_Completion_Date__c,Actual_Start_Date__c ,Service__r.Name, Service__r.Confirmation_Notifications__c,
                     project__r.Title__r.Production_Manager__c,project__r.Title__r.Acquiring_Editor__c,project__r.Title__r.Art_Director__c,
                     project__r.Title__r.Author_Relations_Manager__c,project__r.Title__r.Current_Editor__c,project__r.Title__r.KiM_Art_Director__c,
                     project__r.Title__r.Marketing_Manager__c,project__r.Title__r.Content_Producer__c,User_Input_Rate_Amount__c,
                     rate__r.Rate_Multiplier__c,rate__r.Rate_Currency__c,
                     rate__r.Rate_Amount__c,Service_Type_Complexity__c
                     from project_services__c where id = :psID];
        if(confirmToupdate.id!=null)             
            sendEmail(psToUpdate ,confirmToupdate.id);
        getConfirmationMap(); // get updated confirmation records
    }
    
    public String censhareError{get;set;}
    public Boolean censhareServerUpdate(project_services__c cPS) {
        if(cPS != null) {
            ppw_censhareConnector ppwCen = new ppw_censhareConnector();
            String xml = ppwCen.censhareXMLBuilder(new List<project_services__c>{cPS});
            system.debug('xml'+xml);
            ppw_censhareConnector.resWrap rwrp = new ppw_censhareConnector.resWrap();
            if(!test.isrunningTest())
                rwrp = ppw_censhareConnector.censhareServiceSync(xml); // censhare Callout for update    
            system.debug('rwrp'+rwrp); 
            if(rwrp != null){
            if(rwrp.resStatus == false && !rwrp.resPs.isEmpty()) { 
                // censhareError= 'Censhare Service has been failed please connect with system administrator';
                censhareError= rwrp.resPs.values()[0].Censhare_XML_Error_Response__c; 
                system.debug(censhareError);
                project_services__c ps = new project_services__c(id=cPS.id,Censhare_XML_Error_Response__c=rwrp.resPs.values()[0].Censhare_XML_Error_Response__c); 
                update(ps); 
                return rwrp.resStatus;
            }
            if(rwrp.resStatus == true) { 
                cPS.Estimated_Start_Date__c = rwrp.resPs.get(cPS.id).Estimated_Start_Date__c; 
                cPS.Estimated_Completion_Date__c = rwrp.resPs.get(cPS.id).Estimated_Completion_Date__c; 
                update(cPS);
                return rwrp.resStatus;
            }
            }
            return false;  
            
        }  
        return false; 
    }
    
    @testvisible
    private void sendEmail(project_services__c ps,String cid) {
        Messaging.SingleEmailMessage[] Messages =   new List<Messaging.SingleEmailMessage>();
        confirmation__c cRec= [Select id,Name,Confirmed_Amount__c,Confirmed_Rush_Fee__c,Status__c,confirmation__c,Confirmed_Currency_Amount__c,
                               Confirmed_MBO_Fee__c,Confirmed_Base_Amount_With_Currency__c,Confirmed_MBO_Fee_with_Currency__c, Confirmed_Total_Rate_Amount__c,Confirmed_Rate_Amount__c
                               from confirmation__c  where id=:cId limit 1];
        Map<String,String> AliasEmailIds = new Map<String,String>();
        for(User u : [SELECT alias, Id, Email FROM User where isActive=true]) 
            AliasEmailIds.put(u.alias,u.Email);
        
        String status = ((cRec.status__c=='Confirmed' && cRec.confirmation__c=='Yes')? 'Accepted' : ((cRec.status__c=='Review Requested' && cRec.confirmation__c=='Yes') ? 'Review Requested' : (cRec.status__c=='Confirmed' && cRec.confirmation__c=='No')? 'Rejected' : ''));
        String eBody='';
        eBody+= 'The project service "'+ ps.Service_Type_Complexity__c + '" for title ['+ps.project__r.Title__r.Name+']' + '(' + ps.project__r.Title__r.Marty_Title_ID__c + ')' +' has been ' + status;
        eBody+= '<br/>' + 'Details are below for specific action.'+ '<br/>';
        ebody+= '<br/>'+ 'Project:['+ ps.project__r.Name +']';
        eBody += '<br/>' + 'Salesforce Project Link <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ps.project__c+'">'+ ps.project__r.Name + '</a>'+'<br/>';
       // eBody += '<br/>' + 'Censhare Project Link <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+ps.project__c+'">'+ ps.project__r.Name + '</a>'+'<br/>';
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
        if(cRec.Confirmed_Rate_Amount__c!=null)
            eBody += ' Service Amount : '+ cRec.Confirmed_Rate_Amount__c +'<br/>';
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
        ps.project__r.Title__r.Acquiring_Editor__c != null? ps.project__r.Title__r.Acquiring_Editor__c : 'kkolla';
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
    }
    
    // get notify users for based on service record have notify field value
    public set<String> getNotifyUser(Project_Services__c ps) {
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
            if(ps.getSobject('project__r').getSobject('Title__r').get(s)!=null)
                nUser = String.valueOf(ps.getSobject('project__r').getSobject('Title__r').get(s));
            if(nUser!=null)
                notifyUser.add(nUser);
        }
        
        if(!titleFields.isEmpty())
            if(notifyUser.isEmpty())
            notifyUser.add('kkolla');
        
        return notifyUser;
    }
    
    
    @testvisible
    private string getDate(dateTime dtime) {
        return date.newInstance(dtime.year(), dtime.month(), dtime.day()).format();
    } 
        
    public Messaging.SingleEmailMessage sendEmailToNotifier(String serRepId, List<String> notfiIds, List<String> ccNotfiIds,String emailTempBody,String status,project_services__c ps) {
        String subject = status +' Confirmation notification for Title : '+ps.project__r.Title__r.Name +'(' + ps.project__r.Title__r.Marty_Title_ID__c + ')'; 
        
        OrgWideEmailAddress[] orgEmail = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress where address = 'apub-sfdc-notifications@apub.amazon.com'];
        Messaging.SingleEmailMessage message1 = new Messaging.SingleEmailMessage();
        message1.toAddresses = notfiIds;
        message1.ccAddresses = ccNotfiIds; 
        message1.HtmlBody = emailTempBody; 
        message1.subject = subject; 
        if(!orgEmail.isEmpty())
            message1.OrgWideEmailAddressId = orgEmail[0].id;
        return message1;
        
    }
    
    public map<id, project_services__c> allProjectServiceMap{
        get{
            map<id, project_services__c> tempMap = new map<id, project_services__c>([
                SELECT id, Name, Service__c, Vendor__c, vendor__r.Name,amount__c, Service__r.Service_Rate_Type__c
                FROM Project_Services__c 
                WHERE Project__c = : projectID]);
            
            return tempMap;
        }
        set;
    }
    
    public void renderPanel() {
    
    }
    //the page should only render data if.. 
    //vendor id, and project service id both exist
    //the vendor has services awaiting confirmation, or has services already confirmed on the project
    //confirmations wrapper class should pull in and display all services related to that vendor on the project despite the parameter being from one project service
    //other data on the page should come from the transmittal, service prep questions, and other format records. 
    
    
    
}