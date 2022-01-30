/***********************************
Author: Amazon Apub // michatem@, kkolla@
Visualforce Page Extended:  PPW_Project_Default.vfp
Description: Controller Extension for PPW_Project_Default
************************************/

public class ppw_projectControllerExtension{
    //Standard Project / Controller Variables
    public project__c p {get;set;}
    public String psRec{get {
    if(String.isNotBlank(psRec))
        return psRec;
    else
        return '';     
    }set;}
    public string serviceActionType{get;set;}
    public string prodLocale {get;set;}
    public string projectID;
    public string titleID;
    public string currentTabPs{get;set;}
    public string currentTabName{get;set;}
    public string currentTabId{get;set;} 
    public string collapsTargetAll{get;set;} // get collapse target all ID's for open All or close All link 
    public List<string> activePsIds{get {return activePsIds;}set;} 
    public List<string> completePsIds{get {return completePsIds;}set;}
    public List<string> cancelPsIds{get {return cancelPsIds;}set;}
    public string openedPanelPs{get;set;}
    public set<string> confirmationTblHeaders{get;set;}
    public string openConfirmation{get;set;} // open confirmation field
    public string createConfirmation{get;set;} // open confirmation field 
    public set<string> openedPanels{get { return openedPanels;}set;}
    public String rateAmount{get;set;} // value used to change custom quote rate amount
    public String psAmount{get;set;} // ps amount changed by VM/MM superuser functionality
    public String textAreaTemp{get;set;}
    
    public project_services__c tps {get;set;} // 'this' project service for the current version
    public boolean censhareConnectPsUpdate {get {return censhareConnectPsUpdate;}
                                            set;}
   
    
     public boolean cConnectPsUpdateStop {get { return cConnectPsUpdateStop;}
                                            set;}                                        
                                            
    public integer psInplanningCount{get;set;}
    public project_services__c ops {get;set;} // 'old' project service for comparisons
    public project_services__c thisProjectService {get;set;}
    
    public boolean api_error {get;set;}
    public string api_message {get;set;}
    
    //set current Tab Name
    public void setCurrentTabName(){
        system.debug('currentTabName' + currentTabName);
    }
 
    
    //stop censhare ps update
    public void stopCensharePSUpdate(){
        cConnectPsUpdateStop = true;
          getterpsMegaMap(); 
    }
    
    // collapse target all panels
    public void collapsAll() {
        if(collapsTargetAll == 'Open All') {
            if(currentTabName == 'Active')
                openedPanels.addAll(activePsIds);
            if(currentTabName == 'Completed')
                openedPanels.addAll(completePsIds);
            if(currentTabName == 'Cancelled')
                openedPanels.addAll(cancelPsIds);        
            
        }
        
        if(collapsTargetAll == 'Close All') {
            openedPanelPs = ''; 
            if(currentTabName == 'Active'){
                openedPanels = new set<string>();// openedPanels.addAll(activePsIds);
                activePsIds = new List<String>(); 
            }
            if(currentTabName == 'Completed'){
                openedPanels = new set<string>();
                completePsIds = new List<string>(); 
            }
            if(currentTabName == 'Cancelled'){
                openedPanels = new set<string>(); 
                cancelPsIds = new List<string>(); 
            } 
        }
    }
    
    //set current tab panel
    public void setOpenedPanels(){
        if(openedPanels.contains(currentTabPs)){
            openedPanels.remove(currentTabPs);
        }
        else
            openedPanels.add(currentTabPs);
            openedPanelPS = string.join(new List<string>(openedPanels),',');
        }
    
    // Roles who can modify amount in Ps with custom rate amount
    public String amountChangeRolesSet { 
        get{ 
            return label.PPW_MmKillService; // super user whoe have access do change the amount in ps
        } set;
    }
    
    //Roles who can modify amount in PS with custom rate amount and have access to Kill Service functionality
    public String killServiceRolesSet { 
        get{
            return label.PPW_vmKillService; 
        } set;
    } 
        
    //Active status values
    public string activeSet{
        get{
            return label.Project_Service_Active_Status;
        }
        set;
    }
    //Completed status values
    public string completedSet{
        get{
            return label.Project_Service_Completed_Status;
        }
        set;
    }
    //Cancelled Status Values
    public string CancelledSet{
        get{
            return label.Project_Service_Cancelled_Status;
        }
        set;
    }
    //Navigation ID Variables
    public string cbid{
        get{
            string title = p.Title__c;
            string cb;
            list<creative_brief__c> cb_query = new list<creative_brief__c>([select id from creative_brief__c where title__c = :title limit 1]);
            if(!cb_query.isEmpty()){
                cb = string.valueOf(cb_query.get(0).id);
            }
            return cb;
        }
        set;
    }
    public string spid{
        get{
            string sp;
            list<service_prep__c> sp_query = new list<service_prep__c>([select id from service_prep__c where project__c = :projectID limit 1]);
            if(!sp_query.isEmpty()){
                sp = string.valueOf(sp_query.get(0).id);
            }
            return sp;
        }
        set;
    }
    
    //Project Service Lists
    public integer activeCount {get; set;}
    public integer completedCount {get; set;}
    public integer cancelledCount {get; set;}
    public void setRichText() { 
        textAreaTemp = vendorNoteRichText;
        system.debug('richtext area' + textAreaTemp);
        system.debug('richtext area' + vendorNoteRichText);
    }
    public map<string, list<project_services__c>> allProjectServicesListMap{
        get{
            set<string> activeSet = new set<string>();
            set<string> completedSet = new set<string>();
            set<string> cancelledSet = new set<string>();
            
            activeSet.addAll(label.Project_Service_Active_Status.split(','));
            completedSet.addAll(label.Project_Service_Completed_Status.split(','));
            cancelledSet.addAll(label.Project_Service_Cancelled_Status.split(','));
            
            map<string, list<project_services__c>> tempMap = new map<string, list<project_services__c>>();
            list<project_services__c> serviceList = new list<project_services__c>([
                SELECT id, name,Vendor_Notes_RT__c, Service__c, Service__r.name, Rate__r.name,Actual_Completion_Date__c,Actual_Start_Date__c, service__r.Service_Grouping_String__c, Internal_Service_Notes__c,
                Estimated_Completion_Date__c,Estimated_Start_Date__c,Status__c,Vendor__r.name, service__r.service_rate_type__c,Rate_Amount__c, rush_fee__c, LastModifiedDate, LastModifiedBy.Name,
                Amount__c, rate__r.Rate_Multiplier__c,Base_Amount__c,Base_Amount_with_Currency__c,MBO_Fee_with_Currency__c,project__c,project__r.title__c,project__r.title__r.Marty_Title_ID__c,
                rate__r.rate_amount__c
                FROM Project_Services__c 
                WHERE Project__c=:projectID 
                ORDER BY estimated_start_date__c DESC
            ]);
            
            list<project_services__c> fillerList1 = new list<project_services__c>();
            list<project_services__c> fillerList2 = new list<project_services__c>();
            list<project_services__c> fillerList3 = new list<project_services__c>();
            tempMap.put('Active', fillerList1);
            tempMap.put('Completed', fillerList2);
            tempMap.put('Cancelled', fillerList3);
            
            if(!serviceList.isEmpty()){
                for(project_services__c sp : serviceList){
                    if(activeSet.contains(sp.status__c)){ //active service
                        if(tempMap.containsKey('Active')){
                            list<project_services__c> activeList = tempMap.get('Active');
                            if(activeList.size() > 0){
                                activeList.add(0,sp);
                            }else{
                                activeList.add(sp);
                            }
                            tempMap.put('Active',activeList);
                        }else{
                            List<project_services__c> activeList = new List<project_services__c>();
                            activeList.add(sp);
                            tempMap.put('Active',activeList);
                        }
                        continue;
                    }
                    if(completedSet.contains(sp.status__c)){ //completed service
                        if(tempMap.containsKey('Completed')){
                            list<project_services__c> temp = tempMap.get('Completed');
                            if(temp.size() > 0){
                                temp.add(0,sp);
                            }else{
                                temp.add(sp);
                            } 
                            tempMap.put('Completed',temp);
                        }else{
                            List<project_services__c> temp = new List<project_services__c>();
                            temp.add(sp);
                            tempMap.put('Completed',temp);
                        }
                        continue;                        
                    }
                    if(cancelledSet.contains(sp.status__c)){ //cancelled service
                        if(tempMap.containsKey('Cancelled')){
                            list<project_services__c> temp = tempMap.get('Cancelled');
                            if(temp.size() > 0){
                                temp.add(0,sp);
                            }else{
                                temp.add(sp);
                            }
                            tempMap.put('Cancelled',temp);
                        }else{
                            List<project_services__c> temp = new List<project_services__c>();
                            temp.add(sp);
                            tempMap.put('Cancelled',temp);
                        }  
                        continue;
                    }
                }
            }
            
            activeCount = tempMap.get('Active').size();
            completedCount = tempMap.get('Completed').size();
            cancelledCount = tempMap.get('Cancelled').size();
            
            return tempMap;
        }
        set;
    }
    
    public boolean digitPatternCheck(String str) { 
        if(!String.isBlank(str)) { 
            Pattern p = Pattern.compile('\\d+.\\d+'); 
            Matcher m = p.matcher(str); 
            return m.matches(); 
        } else return false; 
    } 
    
    //Service Action Modal Variables
    public string serviceSelection {get; set;}
    public string serviceTypeSelection {get; set;}
    public String serviceVendorselection{get;set;}
    
    public string serviceDescription {get; set;}
    public string externalVendorNote {get; set;}
    public string externalVendorNoteLong {get; set;}
    public string internalVendorNote {get; set;}
    public decimal rushFee{get;set;}
    
    public vendor__c vendorRecord {get; set;}
    public rate__c rateRecord {get; set;}
    public service__c serviceRecord {get; set;}
    public boolean vendorDisabled{get;set;}
    
    public string estStartDate {get; set;}
    public String vendorNoteRichText{get; set;} 
    public string estCompletedDate {get; set;}
    public string accStartDate {get; set;}
    public string accCompletedDate {get; set;}
    
    public boolean honorDependencies {get; set;}
    
    //Service Action Modal option Lists
    public list<selectOption> serviceGroupOptions {get; set;}
    public list<selectOption> serviceTypeOptions {
        get{
            list<selectOption> tempSOList = new list<selectOption>();
            tempSOList = loadServiceTypeOptions(serviceSelection);
            return tempSOList;
        }
        set;
    }
    public list<selectOption> serviceVendorOptions {
        get{
            list<selectOption> tempSOList = new list<selectOption>();
            tempSOList = loadServiceVendorOptions(serviceSelection, serviceTypeSelection);
            return tempSOList;
        }
        set;
    }
    
    //Confirmation Lists
    public list<confirmation__c> allConfirmations {
        get{
            
            list<confirmation__c> allCons1 = new list<confirmation__c>();
            Map<integer, confirmation__c> allCons2 = new Map<integer ,confirmation__c>();
          
             allCons1 = [SELECT id, name, confirmation__c, Project_Services__r.Status__c, Status__c, Confirmed_Amount__c, Confirmed_Rate_Amount__c ,
                                 Confirmed_Service__c, Confirmed_Vendor__c,Confirmed_Rush_Fee__c, date_of_confirmation__c, 
                                 rejection_reason__c, createddate,Reason_for_Review__c,open_confirmation__c,Confirmed_Base_Amount__c,
                                 Confirmed_Base_Amount_With_Currency__c,Confirmed_MBO_Fee_with_Currency__c
                            FROM Confirmation__c 
                            WHERE Project_Services__c = :psRec
                            ORDER BY LastModifiedDate DESC];
               if(!allCons1.isEmpty()) 
                   for(integer i=0; i<  allCons1.size(); i++)          
                      if(allCons1[i].status__c == 'Open')
                          allCons2.put(0 ,allCons1[i]);
                      else
                          allCons2.put(i ,allCons1[i]);    
                return allCons2.values();
                
        } 
        set;}
    public boolean confirmationButtonCheck {get; set;}
    public boolean confirmationTableCheck {get; set;}
    public boolean rushFeeFlg{get; set;} 
    
    //Confirmation action modal
    public void confirmationBuildAction(){
        censhareError= null;
        rushFeeFlg = false;
        openConfirmation = '';
        createConfirmation = '';
         
        system.debug('Confirmation PSREC: '+psRec);
        confirmationButtonCheck = true;
        confirmationTableCheck = false;
        confirmationTblHeaders = new set<string>{'Status','Sent','Service','Amount','Vendor'};
        
        if(!allConfirmations.isEmpty()){
            confirmationTableCheck=true;
        }
        
        for(confirmation__c c: allConfirmations){
            system.debug(c.Confirmed_rush_fee__c);
            if(c.Confirmed_Rush_Fee__c !=0 && c.Confirmed_Rush_Fee__c != null && c.Confirmed_Rush_Fee__c !=0.00 ) {
                confirmationTblHeaders.add('Rush Fee'); 
                rushFeeFlg = true; 
            } 
            if(c.status__c=='Open'){
                confirmationButtonCheck=false;
            }
        }
        
    }
    
    //Create a new confirmation...
    public void createConfirmation() {
        boolean censhareFlg = false;
        
        project_services__c ps = String.isNotBlank(psRec)? allProjectServiceMap.get(psRec): new project_services__c();
        if(ps.Status__c != 'Confirming')
            censhareFlg = true;
        if(ps.Service_Name__c == 'Promo Text Creation' && ps.Master_PT_Service__c == false) 
        censhareFlg = false;
         
        if(censhareFlg && ps.Has_Been_Kicked_Off__c == false) { //has been kicked off false
            ps.Status__c = 'Confirming';
            ps.Censhare_XML_update_type__c = 'Update'; 
          
              boolean censhareUpdateStatus = censhareServerUpdate(ps);
         
            if(censhareUpdateStatus) {
            String ConfirmationText = openConfirmation!= '' ? openConfirmation : createConfirmation!=null ? createConfirmation:''; 
            //update(ps); 
            ps = [SELECT id,Status__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,Word_Count_Completed__c, 
                  Word_Count_Cancelled__c,Amount__c,Base_Amount__c,Rate_Amount__c,Base_Amount_with_Currency__c,Rate_Currency__c,MBO_Fee__c,Rush_Fee__c,Total_Rate_Amount__c,
                  Service__r.Service_rate_type__c,Vendor__r.name,MBO_Fee_with_Currency__c,(select id from Confirmation__r where status__c = 'Open')
                  FROM project_services__c WHERE id =: ps.id]; 
                if(ps.Confirmation__r.isEmpty()) {
            confirmation__c cnew = new confirmation__c(
                project_services__c=psRec,
                confirmed_service__c = ps.Service__r.Service_rate_type__c,
                confirmed_vendor__c = ps.Vendor__r.name,
                Confirmed_Base_Amount__c = ps.Base_Amount__c,
                Confirmed_Base_Amount_With_Currency__c = ps.Base_Amount_with_Currency__c,
                confirmed_rush_fee__c = ps.Rush_Fee__c,
                Confirmed_Amount__c = ps.Amount__c,//Rate_Currency__c
                Confirmed_Rate_Amount__c = ps.Rate_Amount__c,
                Confirmed_Rate_Currency__c = ps.Rate_Currency__c,
                Confirmed_MBO_Fee__c = ps.MBO_Fee__c,
                Confirmed_MBO_Fee_with_Currency__c = ps.MBO_Fee_with_Currency__c,
                Confirmed_Total_Rate_Amount__c = ps.Total_Rate_Amount__c,
                open_confirmation__c = ConfirmationText,
                Confirmed_Word_Count__c = getPredevValue(ps)//ps.Word_Count_Confirming__c
            );
            
            insert(cnew);
                }
            confirmationBuildAction(); 
            getterpsMegaMap(); 
           } 
       
       } else { // has been kicked off true section
         
           /* if(ps.Service_Name__c == 'Promo Text Creation' && ps.Master_PT_Service__c == false && ps.Has_Been_Kicked_Off__c == false) { 
                ps.Status__c = 'Confirming'; // make status as confirming when status kicked off false 
                update ps; 
            }*/
            // rate calculation for when kicked off true i.e this special case for rate calcualation
            
            ppw_handlerforCalculation rates1 = new ppw_handlerforCalculation();
            List<Project_Services__c> psLst = rates1.ratecalc(new List<Project_Services__c> {ps});
            update psLst; 
            
              String ConfirmationText1 = openConfirmation!= '' ? openConfirmation : createConfirmation!=null ? createConfirmation:''; 
            ps = [SELECT id,Status__c,Word_Count_In_Planning__c,(select id from Confirmation__r where status__c = 'Open'),Word_Count_Confirming__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,Word_Count_Completed__c, 
                  Word_Count_Cancelled__c,Amount__c,Base_Amount__c,Rate_Amount__c,Base_Amount_with_Currency__c,Rate_Currency__c,MBO_Fee__c,Rush_Fee__c,Total_Rate_Amount__c,
                  Service__r.Service_rate_type__c,Vendor__r.name,MBO_Fee_with_Currency__c,Service_Name__c ,Master_PT_Service__c,Has_Been_Kicked_Off__c
                  FROM project_services__c WHERE id =: ps.id]; 
            confirmation__c cnew = new confirmation__c(
                project_services__c=psRec,
                confirmed_service__c = ps.Service__r.Service_rate_type__c,
                confirmed_vendor__c = ps.Vendor__r.name,
                Confirmed_Base_Amount__c = ps.Base_Amount__c,
                Confirmed_Base_Amount_With_Currency__c = ps.Base_Amount_with_Currency__c,
                confirmed_rush_fee__c = ps.Rush_Fee__c,
                Confirmed_Amount__c = ps.Amount__c,//Rate_Currency__c
                Confirmed_Rate_Amount__c = ps.Rate_Amount__c,
                Confirmed_Rate_Currency__c = ps.Rate_Currency__c,
                Confirmed_MBO_Fee__c = ps.MBO_Fee__c,
                Confirmed_MBO_Fee_with_Currency__c = ps.MBO_Fee_with_Currency__c,
                Confirmed_Total_Rate_Amount__c = ps.Total_Rate_Amount__c,
                open_confirmation__c = ConfirmationText1,
                Confirmed_Word_Count__c = getPredevValue(ps)//ps.Word_Count_Confirming__c
            );
            
            if(ps.Confirmation__r.isEmpty())
                insert(cnew);
            confirmationBuildAction(); 
            getterpsMegaMap(); 
           
       }
    }
    
    public static decimal getPredevValue(Project_Services__c ps) { 
        system.debug(ps); 
        if(ps.Status__c == 'In Planning') 
            return ps.Word_Count_In_Planning__c; 
        if(ps.Status__c == 'Confirming') 
            return ps.Word_Count_Confirming__c; 
        if(ps.Status__c == 'Scheduled') 
            return ps.Word_Count_Scheduled__c; 
        if(ps.Status__c == 'Kicked Off') 
            return ps.Word_Count_Kicked_Off__c; 
        if(ps.Status__c == 'Completed') { 
            if(ps.Word_Count_Completed__c > ps.Word_Count_Kicked_Off__c) 
                return ps.Word_Count_Completed__c; 
            else 
                return ps.Word_Count_Kicked_Off__c;
        } 
        if(ps.Status__c == 'Cancelled') 
            return ps.Word_Count_Cancelled__c; 
        return 0; 
    }
        
    //internally close a confirmation button
    public string internalCloseID {get; set;}
    public void internalCloseConfirmation(){
        thisProjectService = allProjectServiceMap.get(psRec); 
        datetime timeStamp = datetime.now();
        confirmation__c cClosed = new confirmation__c(
            id=internalCloseID,
            status__c='Internal Closed',
            Date_of_Confirmation__c=timeStamp
        );
        if(thisProjectService.Has_Been_Kicked_Off__c == false) // no status change when status is kicked off. 
            thisProjectService.status__c = 'In Planning'; 
        
        update(cClosed);
        update thisProjectService; 
        confirmationBuildAction(); 
        getterpsMegaMap(); 
    }
    
    //Constructor
    public ppw_projectControllerExtension(ApexPages.StandardController con) {
        activePsIds = new List<string>(); 
        completePsIds = new List<string>(); 
        cancelPsIds = new List<string>(); 
        cancelStatusFlg = false; 
        confirmationCheckFlg = false; 
        perPageSelectionFlg = false; 
        if(currentTabId ==null)
        currentTabId = 'active-tab'; 
        openedPanelPs = '';
        currentTabPs = '';
        currentTabName='Active';
        if(openedPanels == null)
        openedPanels = new set<string>();
        p = (project__c)con.getrecord();
        projectID = string.valueOf(p.id);
        p = [SELECT id,title__r.production_locale__c, title__c, title__r.marty_title_id__c from project__c where id=:projectID];
        
       
        
        
        
        prodLocale = p.title__r.production_locale__c;
        titleID = p.title__r.marty_title_id__c;
        getterpsMegaMap();
    }
    
    public PageReference getppw_censhareConnect_PSUpdate() {
        Map<String,Project_Services__c> psLst = new Map<String,Project_Services__c>();
        psLst = new Map<String,Project_Services__c>([SELECT id,Service__c,Vendor__c, project__c,project__r.title__r.Marty_Title_ID__c,Service__r.name,
                                                               Estimated_Start_Date__c, Estimated_Completion_Date__c,
                                                            Service__r.Censhare_Template_ID__c,service__r.Service_Complexity_Value__c
                                                             ,Honor_Dependencies__c,status__c,Vendor__r.name,Censhare_XML_update_type__c 
                                     
                                     FROM Project_Services__c WHERE project__c=: projectID AND status__c = 'In Planning' AND (NOT Service__r.Name LIKE 'Promo Text Creation')]);
        Map<String,Project_Services__c> masterPIpsLst = new Map<String,Project_Services__c>([SELECT id,Service__c,Vendor__c, project__c,project__r.title__r.Marty_Title_ID__c,Service__r.name,
                                                               Estimated_Start_Date__c, Estimated_Completion_Date__c,
                                                            Service__r.Censhare_Template_ID__c,service__r.Service_Complexity_Value__c
                                                             ,Honor_Dependencies__c,status__c,Vendor__r.name,Censhare_XML_update_type__c 
                                     
                                     FROM Project_Services__c WHERE project__c=: projectID AND status__c = 'In Planning' AND Service__r.Name LIKE 'Promo Text Creation' AND Master_PT_Service__c = true]);
        if(!masterPIpsLst.isEmpty()) {
            psLst.putall(masterPIpsLst);
        }
        
      
        if(!psLst.isEmpty()) {
            psInplanningCount = psLst.size();
            ppw_censhareConnect_PSUpdate pc = new ppw_censhareConnect_PSUpdate();
            
            String xmlBody = pc.censhareXMLBuilder(psLst.values());
            system.debug('xml'+ xmlBody);
            ppw_censhareConnect_PSUpdate.resWrap rw = new  ppw_censhareConnect_PSUpdate.resWrap();
            rw = ppw_censhareConnect_PSUpdate.censhareServiceSync(xmlBody, psLst);
            system.debug( rw);
            if(rw.psStatus)
                censhareConnectPsUpdate = true;
            else
                censhareConnectPsUpdate = false; 
            if (rw.psList != null)
            update rw.psList;
          
        }
    
        return null;
    }
    
    
    //Reference Maps
    public map<id, Service__c> allServiceDetailsMap{
        get{
            map<id, Service__c> tempMap = new map<id, Service__c>([SELECT id, name, Service_rate_Type__c, description__c,Wiki_Additional_Information__c, Censhare_Template_ID__c, Service_complexity_value__c FROM Service__c]);
            return tempMap;
        }
        set;
    }
    
    public map<id, project_services__c> allProjectServiceMap{
        get{
            map<id, project_services__c> tempMap = new map<id, project_services__c>([
                SELECT id, Name, Service__c, Vendor__c, Rate__c,Vendor_Notes_RT__c ,Has_Been_Kicked_Off__c, Project__c, Rush_Fee__c, Amount__c,
                Service__r.Name, Service__r.Service_Rate_Type__c, Internal_Service_Notes__c,Project__r.Title__c, Service_Name__c,
                Vendor__r.Name,status__c,Service_Type_Complexity__c,Rate_Currency__c,Censhare_XML_update_type__c ,
                Project__r.Title__r.Marty_Title_ID__c, Honor_dependencies__c, Estimated_Start_Date__c, Estimated_Completion_Date__c, 
                Actual_Completion_Date__c, Actual_Start_Date__c, additional_rate_input__c,rate__r.Rate_Multiplier__c,rate__r.Rate_Currency__c,
                rate__r.Rate_Amount__c,Custom_Quote_Amount__c,Base_Amount__c,User_Input_Rate_Amount__c,Word_Count_In_Planning__c,Word_Count_Confirming__c, 
                Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,Word_Count_Completed__c ,Master_PT_Service__c, Word_Count_Cancelled__c,Base_Amount_with_Currency__c,
                MBO_Fee_with_Currency__c
                FROM Project_Services__c 
                WHERE Project__c = : projectID]);
            
            return tempMap;
        }
        set;
    }
    
    public map<id, vendor__c> allVendorMap{
        get{
            map<id, vendor__c> tempMap = new map<id, vendor__c>([
                SELECT id, Name, vendor_status__c, website__c
                FROM vendor__c ]);
            
            return tempMap;
        }
        set;
    }
    
    public map<string, rate__c> allRatesMap{
        get{
            map<string, rate__c> tempMap = new map<string, rate__c>();
            for(rate__c r : [SELECT id, name, vendor__c, service__c, rate_multiplier__c, rate_amount__c, rate_notes__c, Rate_Currency__c
                             FROM rate__c 
                             WHERE active_rate__c=true 
                            ]){
                                string concatID = string.valueof(r.Vendor__c)+string.valueof(r.Service__c);
                                tempMap.put(concatID, r);
                            }
            
            return tempMap;
        }
        set;
    }
    
    public map<id, confirmation__c> activeConfirmationsMap{
        get{
            map<id, confirmation__c> acm = new map<id, confirmation__c>([
                SELECT id, name,Reason_for_Review__c
                FROM Confirmation__c
                WHERE Project_Services__r.Project__c = :projectID]);
            
            return acm;
        }
        set;
    }
    
    
    //Loaders & Changers
    public list<SelectOption> loadServiceGroupOptions(){
        list<selectOption> tempList = new list<selectOption>();
        set<string> tempSet = new set<string>();
        
        for(Service__c s: [SELECT id,name FROM service__c WHERE 
                           active__c=true 
                           ORDER BY name ASC]){
            tempSet.add(s.name);
        }
        
        for(String sg: tempSet){
            tempList.add(new SelectOption(sg,sg));
        }
        return tempList;
    }
    
    public list<SelectOption> loadServiceTypeOptions(string serviceGroup){
        serviceTypeOptions = new list<selectOption>();
        list<selectOption> tempList = new list<selectOption>();
        set<string> tempSet = new set<string>();
        
        if(serviceGroup!='' && serviceGroup!=null){
            tempList.add(new SelectOption('', 'Select a '+serviceGroup+' Type'));
            for(Service__c s: [SELECT id,name, service_rate_type__c FROM service__c WHERE name=:serviceGroup AND 
                               active__c=true 
                               ORDER BY service_rate_type__c ASC]){
                tempList.add(new SelectOption(s.id, s.Service_Rate_Type__c));
            }
        }
        
        return tempList;
    }
    
    public list<SelectOption> loadServiceVendorOptions(string serviceGroup, string serviceType){
        serviceVendorOptions = new list<selectOption>();
        list<selectOption> tempList = new list<selectOption>();
        set<string> tempSet = new set<string>();
        
        set<string> vendorStatusSet = new set<string>();
        vendorStatusSet.addAll(label.PPW_vendorStatus.split(','));
        
        
        if(serviceGroup!=null && serviceType !=''){
            for(rate__c r: [SELECT Vendor__c, vendor__r.name FROM rate__c 
                            WHERE vendor__r.vendor_status__c IN :vendorStatusSet
                            AND vendor__r.vendor_services_codes__c includes ( :serviceGroup )
                            AND service__c = :serviceType
                            AND vendor__r.approved_locale__c includes ( :prodLocale )
                            AND active_rate__c = true
                            ORDER BY name ASC]){
                                tempSet.add(r.vendor__c);
                            }
            tempList.add(new SelectOption('', 'Select a Vendor'));
            for(vendor__c v : [select id, name from vendor__c where id in :tempSet ORDER BY name ASC]){
                tempList.add(new SelectOption(v.id, v.name));
            }
        }
        return tempList;
    }
    
    public void changedServiceGroup(){
        //we changed the group so we null the vendors, and disable on UX...
        vendorDisabled = true;
        serviceVendorOptions = null;
        serviceVendorSelection = null;
        
        rateRecord = new rate__c();
        vendorRecord = null;
        serviceRecord = null;
        psAmount = null; 
    }
    
    public void changedServiceType(){
        vendorDisabled = false;
        serviceVendorSelection = null;
        serviceVendorOptions = loadServiceVendorOptions(serviceSelection, serviceTypeSelection);
        
        serviceRecord = allServiceDetailsMap.get(serviceTypeSelection);
        vendorRecord = allVendorMap.get(serviceVendorSelection);
    }
    
    public decimal asinInitailPageCount{get;set;} // initail page count for show message for must fill initail page count in asin
    public boolean perPageSelectionFlg{get;set;}
    public void changedVendor() {
        vendorDisabled = false;
        vendorRecord = allVendorMap.get(serviceVendorSelection);
        
        string concatID = string.valueOf(serviceVendorSelection) + string.valueOf(serviceTypeSelection);
        rateRecord = allRatesMap.get(concatID);
        if(rateRecord != null)
        if(rateRecord.rate_multiplier__c == 'Per Page') {
            perPageSelectionFlg = true;
            List<ASIN__c> aList = [SELECT id,Initial_Page_Count__c,Name FROM ASIN__c WHERE (Name = 'Paperback' or Name = 'Hardcover') AND title__r.Marty_Title_ID__c =: titleId LIMIT 1];
            if(!aList.isEmpty()) {
                for(ASIN__c asin: aList)
                    
                    if(asin.Name == 'Paperback')
                    asinInitailPageCount = asin.Initial_Page_Count__c;
                else
                    asinInitailPageCount = asin.Initial_Page_Count__c;
                
            } else 
                asinInitailPageCount = null;
            
        } else
            perPageSelectionFlg = false;
        additionalRateInput = null;
    }
    
    public void getAsinInitailPageCount() {
    if(rateRecord != null) 
        if(rateRecord.rate_multiplier__c == 'Per Page') {
            List<ASIN__c> aList = [SELECT id,Initial_Page_Count__c,Name FROM ASIN__c WHERE (Name = 'Paperback' or Name = 'Hardcover') AND title__r.Marty_Title_ID__c=: titleId LIMIT 1];
            if(!aList.isEmpty()) {
                for(ASIN__c asin: aList)           
                    if(asin.Name == 'Paperback')
                    asinInitailPageCount = asin.Initial_Page_Count__c;
                else
                    asinInitailPageCount = asin.Initial_Page_Count__c;
            } else
                asinInitailPageCount = null;
        } else
            perPageSelectionFlg = false;
        system.debug(titleId);
        system.debug('asinInitailPageCount'+asinInitailPageCount);
    }
    
    public void testmet() { 
    system.debug('TEST'); 
    }
    
    //Modal Openers
    public void openServiceActionModal() {
         cancelStatusFlg = false;
         confirmationCheckFlg = false; 
         censhareError = null;
         
        system.debug('openServiceActionModal'); 
        if(pollerEnabled != true) 
            pollerEnabled = false; 
        system.debug('serviceActionType'+serviceActionType); 
        if(serviceActionType == 'edit') {
            system.debug('we are editing a service on the ui');
            if(allProjectServiceMap.containsKey(psRec)) {
                thisProjectService = allProjectServiceMap.get(psRec);
            }
            
            if(thisProjectService != null) {
                Project_Services__c ps = [SELECT id,status__c FROM Project_Services__c WHERE id=: thisProjectService.Id limit 1]; 
                if(ps.status__c == 'Confirming') 
                    confirmationCheckFlg = true;
                else
                    confirmationCheckFlg = false; 
                /*List<Confirmation__c> conLst =  [SELECT id FROM Confirmation__c WHERE Project_Services__c =: thisProjectService.Id limit 1];
                if(conLst!= null && !conLst.isEmpty())
                    confirmationCheckFlg = true;
                else
                    confirmationCheckFlg = false;    */
                serviceSelection = thisProjectService.service__r.name;
                serviceTypeSelection = thisProjectService.service__c;
                servicevendorSelection = thisProjectService.vendor__c;
                rateAmount = null; 
                psAmount = null; 
                
                serviceGroupOptions = loadServiceGroupOptions();
                serviceTypeOptions = loadServiceTypeOptions(serviceSelection);
                serviceVendorOptions = loadServiceVendorOptions(serviceSelection, serviceTypeSelection);
                
                serviceRecord = allServiceDetailsMap.get(thisProjectService.service__c);
                vendorRecord = allVendorMap.get(thisProjectService.vendor__c);
                
                string concatID = string.valueOf(serviceVendorSelection) + string.valueOf(serviceTypeSelection);
                rateRecord = allRatesMap.get(concatID);
                
                honorDependencies = thisProjectService.honor_dependencies__c;
                
                estStartDate = string.valueOf(thisProjectService.Estimated_Start_Date__c);
                estCompletedDate = string.valueOf(thisProjectService.Estimated_Completion_Date__c);
                accStartDate = string.valueOf(thisProjectService.Actual_Start_Date__c);
                accCompletedDate = string.valueOf(thisProjectService.Actual_Completion_Date__c);
                vendorNoteRichText = thisProjectService.Vendor_Notes_RT__c;
                
                rushFee = thisProjectService.rush_fee__c;
                
                internalVendorNote = thisProjectService.Internal_Service_Notes__c;
                externalVendorNote = thisProjectService.Vendor_Notes_RT__c;
                
                additionalRateInput = thisProjectService.Additional_Rate_Input__c;
                
            }
        }else {
            thisProjectService = new project_services__c(); 
            samResetValues();
            serviceGroupOptions = new list<selectOption>();
            serviceGroupOptions.add(new SelectOption('', 'Select a Group'));
            serviceGroupOptions.addAll(loadServiceGroupOptions());
        }
    }
    
    public void samResetValues(){
       // censhareError = null;
        //remove values from selections and options
        serviceGroupOptions = null;
        serviceTypeOptions = null;
        serviceVendorOptions = null;
        
        serviceSelection = null;
        serviceTypeSelection = null;
        servicevendorSelection = null;
        
        rateRecord = null;
        rateAmount = null;
        psAmount = null; 
        
        vendorRecord = null;
        serviceRecord = null;
        
        externalVendorNote = null; 
        internalVendorNote = null; 
        rushFee = 0;
        
        estStartDate =null;
        estCompletedDate = null;
        accStartDate = null;
        accCompletedDate = null;
        vendorNoteRichText = null;
        
        honorDependencies = false;
        
        additionalRateInput = null;
        
    }
    
    
    public string csXMLBody {get; set;}
    public map<string,string> psXMLDataMap {get; set;}
    public list<map<string, string>> psMapList {get; set;}
    public map<id, set<id>> serviceDependencyMap {
        get{
            //service__c | set<service_dependency__c>
            map<id, set<id>> tempMap = new map<id, set<id>>();
            for(service_dependency__c sd : [SELECT id, Dependent_Service__c, Parent_Service__c from service_dependency__c where parent_service__r.active__c = true]){
                if(tempMap.containsKey(sd.Dependent_Service__c)){
                    set<id> tempSet = tempMap.get(sd.Dependent_Service__c);
                    tempSet.add(sd.Parent_Service__c );
                    tempMap.put(sd.Dependent_Service__c,tempSet);
                }else{
                    set<id> tempSet = new set<id>();
                    tempSet.add(sd.parent_service__c);
                    tempMap.put(sd.Dependent_Service__c,tempSet);
                }
            }
            return tempMap;
        }
        set;
    }
    public map<id,id> psServiceMap {
        get{
            map<id,id> tempMap = new map<id,id>();
            for(project_services__c x : [select id, service__c FROM project_services__c WHERE project__c=:projectID AND service__c != null]){
                tempMap.put(x.id, x.service__c);
            }
            return tempMap;
        }
        set;}
    public Project_services__c censhareNewPs; 
    Boolean promotionalFlg;
    public String censhareError{get;set;}
    public void projectServiceHandler() {
        promotionalFlg = false;
        //compare the current context of the service to the new one.
        tps = new Project_services__c();
        psXMLDataMap = new map<string, string>(); //container for the outbound XML body
        psMapList = new list<map<string,string>>();
        ppw_censhareConnector ppw_cc = new ppw_censhareConnector();
        boolean transmitToCenshare = false;
        string response;
        
        if(serviceActionType == 'create') {
            //we are creating a single ala carte service, therefore we can assume some things before building the XML Payload
            tps.Project__c = projectID;
            tps.Service__c = serviceTypeSelection;
            tps.Vendor__c = serviceVendorSelection;
            tps.Rush_Fee__c = rushFee;
            tps.Additional_Rate_Input__c = additionalRateInput;
            tps.Vendor_Notes_RT__c = externalVendorNote;
            tps.Internal_Service_Notes__c = internalVendorNote;
            tps.Honor_Dependencies__c = honorDependencies!=null?honorDependencies:false;
            tps.Status__c = 'In Planning';
            
            tps.Estimated_Start_Date__c = (string.isEmpty(estStartDate) ? null :  date.valueOf(estStartDate));
            tps.Estimated_Completion_Date__c = (string.isEmpty(estCompletedDate) ? null :  date.valueOf(estCompletedDate));
            tps.Actual_Start_Date__c = (string.isEmpty(accStartDate) ? null :  date.valueOf(accStartDate));
            tps.Actual_Completion_Date__c = (string.isEmpty(accCompletedDate) ? null :  date.valueOf(accCompletedDate));
            tps.Vendor_Notes_RT__c = textAreaTemp;
            
            system.debug('richtext area' + textAreaTemp);
            if(rateAmount!=null)
                if(rateRecord.Rate_Multiplier__c == 'Custom Quote') { 
                    tps.Custom_Quote_Amount__c = digitPatternCheck(rateAmount)? decimal.valueOf(rateAmount) : tps.Custom_Quote_Amount__c; // update Custom quote amount in ps record when rate mulitiplier is Custom Quote 
                   // update thisProjectService;
                    update rateRecord; 
                }  
               
            insert(tps); 
             //
            if(serviceTypeSelection!=null)
            if(allServiceDetailsMap.get(serviceTypeSelection).Name.equalsIgnoreCase('Promo Text Creation'))
                promotionalFlg = promotionalTextService();
            if(promotionalFlg)  {
                // no censhare call out for more than one promotional text service
                 pollerEnabled = false;
                 censhareStatus = false;
            } else {
            tps.Censhare_XML_update_type__c = 'New'; 
            tps.Honor_Dependencies__c = honorDependencies!=null?honorDependencies:false;
            //tps.Honor_Dependencies__c = honorDependencies;//true; 
            censhareNewPs = tps; 
            censhareServerInsert(tps);
            
           /* try { 
            ppw_censhareConnector ppwCen = new ppw_censhareConnector();
                String xml = ppwCen.censhareXMLBuilder(new List<project_services__c>{tps});
            system.debug('xml'+xml);
            if(!test.isrunningTest())
            ppw_censhareConnector.censhareService(xml,tps.id); 
                pollerEnabled = true; 
                censhareStatus = true; 
            } catch(Exception e) {
                //delete tps;
            } */
            }
         }
        
        if(serviceActionType =='edit'){
            //remove after censhare config
            transmitToCenshare=false;
            //remove after censhare config
            if(!string.isEmpty(response) || !transmitToCenshare){
                boolean closeConfirmation = false; 
                thisProjectService.Service__c = serviceTypeSelection;
                thisProjectService.Vendor__c = serviceVendorSelection;
                thisProjectService.Rush_Fee__c = rushFee;
                thisProjectService.Additional_Rate_Input__c = additionalRateInput;
                thisProjectService.Vendor_Notes_RT__c = externalVendorNote;
                thisProjectService.Internal_Service_Notes__c = internalVendorNote;
                thisProjectService.Honor_Dependencies__c = honorDependencies;
                
                thisProjectService.Estimated_Start_Date__c = (string.isEmpty(estStartDate) ? null :  date.valueOf(estStartDate));
                thisProjectService.Estimated_Completion_Date__c = (string.isEmpty(estCompletedDate) ? null :  date.valueOf(estCompletedDate));
                thisProjectService.Actual_Start_Date__c = (string.isEmpty(accStartDate) ? null :  date.valueOf(accStartDate));
                thisProjectService.Actual_Completion_Date__c = (string.isEmpty(accCompletedDate) ? null :  date.valueOf(accCompletedDate));
                thisProjectService.Vendor_Notes_RT__c  = textAreaTemp;
                
                system.debug('richtext area' + vendorNoteRichText);
                system.debug('richtext area' + textAreaTemp);
                system.debug(thisProjectService);
                System.debug('psAmount'+psAmount); 
               
                User u = [Select UserRole.Name from user WHERE id =: Userinfo.getUserId() LIMIT 1]; 
                if(u.UserRole != null) { 
                if(thisProjectService.status__c == 'Killed' && psAmount!=null && killServiceRolesSet.containsIgnoreCase(u.UserRole.Name)) 
                    thisProjectService.User_Input_Rate_Amount__c = digitPatternCheck(psAmount) ? Decimal.valueOf(psAmount) : thisProjectService.User_Input_Rate_Amount__c;
                 
                if(psAmount!=null && amountChangeRolesSet.containsIgnoreCase(u.UserRole.Name)) 
                    thisProjectService.User_Input_Rate_Amount__c = digitPatternCheck(psAmount) ? Decimal.valueOf(psAmount) : thisProjectService.User_Input_Rate_Amount__c;
                }
                System.debug('thisProjectService'+thisProjectService); 
                Boolean censhareCall = false;
                //defind censhare call out
                project_services__c thisps = [SELECT id,Service__c,Vendor__c,User_Input_Rate_Amount__c,Has_Been_Kicked_Off__c ,rate_Amount__c,Amount__c ,Service_Type_Complexity__c,status__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,Word_Count_Completed__c, Base_Amount__c,
                                                Base_Amount_with_Currency__c,Rate_Currency__c,MBO_Fee__c,Rush_Fee__c,Total_Rate_Amount__c, Service_Name__c ,
                                              Service__r.Service_rate_type__c,Vendor__r.name,MBO_Fee_with_Currency__c, Master_PT_Service__c,
                                              Word_Count_Cancelled__c ,Honor_Dependencies__c,Additional_Rate_Input__c,Custom_Quote_Amount__c 
                                              FROM project_services__c WHERE id=: thisProjectService.id]; 
                if(thisps.Service__c != thisProjectService.Service__c || thisps.Vendor__c != thisProjectService.Vendor__c || 
                   thisps.Service_Type_Complexity__c != thisProjectService.Service_Type_Complexity__c || 
                   thisps.status__c != thisProjectService.status__c || thisps.Honor_Dependencies__c != thisProjectService.Honor_Dependencies__c) 
                                              
                    censhareCall = true;
                // status change to inplanning and not has been kick off
                if((thisps.Vendor__c !=thisProjectService.Vendor__c || thisps.Service__c !=thisProjectService.Service__c ||
                    thisps.Rush_Fee__c != thisProjectService.Rush_Fee__c || thisps.Additional_Rate_Input__c != thisProjectService.Additional_Rate_Input__c ||
                    thisps.Custom_Quote_Amount__c != thisProjectService.Custom_Quote_Amount__c || 
                    thisps.User_Input_Rate_Amount__c != thisProjectService.User_Input_Rate_Amount__c || thisps.status__c != thisProjectService.status__c) && thisps.status__c != 'In Planning' && (thisps.Has_Been_Kicked_Off__c == false)) {
                        thisProjectService.status__c = 'In Planning'; 
                        
                        censhareCall = true;
                    }
                // ps status change from schedule to confirming and create new confirmation and has not been kicked off
                if((thisps.Service__c != thisProjectService.Service__c || thisps.Vendor__c != thisProjectService.Vendor__c || 
                    thisps.Service_Type_Complexity__c != thisProjectService.Service_Type_Complexity__c  ||
                    thisps.Rush_Fee__c != thisProjectService.Rush_Fee__c || thisps.Additional_Rate_Input__c != thisProjectService.Additional_Rate_Input__c ||
                    thisps.Custom_Quote_Amount__c != thisProjectService.Custom_Quote_Amount__c || 
                    thisps.User_Input_Rate_Amount__c != thisProjectService.User_Input_Rate_Amount__c) && thisps.status__c == 'Scheduled' && (thisps.Has_Been_Kicked_Off__c == false)) {
                        censhareCall = true;
                        thisProjectService.status__c = 'Confirming';
                    
              // this confirmation create process has been moved to ps trigger 
              /*  confirmation__c cnew = new confirmation__c(
                project_services__c=psRec,
                confirmed_service__c = thisps.Service__r.Service_rate_type__c,
                confirmed_vendor__c = thisps.Vendor__r.name,
                Confirmed_Base_Amount__c = thisps.Base_Amount__c,
                Confirmed_Base_Amount_With_Currency__c = thisps.Base_Amount_with_Currency__c,
                confirmed_rush_fee__c = thisps.Rush_Fee__c,
                Confirmed_Amount__c = thisps.Amount__c,//Rate_Currency__c
                Confirmed_Rate_Amount__c = thisps.Rate_Amount__c,
                Confirmed_Rate_Currency__c = thisps.Rate_Currency__c,
                Confirmed_MBO_Fee__c = thisps.MBO_Fee__c,
                Confirmed_MBO_Fee_with_Currency__c = thisps.MBO_Fee_with_Currency__c,
                Confirmed_Total_Rate_Amount__c = thisps.Total_Rate_Amount__c,
                open_confirmation__c = '',
                Confirmed_Word_Count__c = getPredevValue(thisps)//ps.Word_Count_Confirming__c
            );
            
            insert(cnew);  
                    */
                    
                    }
                    
                    // make censhare callout false for service is not primary promo text creation services 
                    if(thisps.Service_Name__c == 'Promo Text Creation' && thisps.Master_PT_Service__c == false) 
                    censhareCall = false; 
                if(censhareCall) {
                    thisProjectService.Censhare_XML_update_type__c = 'Update'; 
                   
                    if(rateAmount!=null) 
                    if(rateRecord.Rate_Multiplier__c == 'Custom Quote')  // set custom quote value before call out 
                        thisProjectService.Custom_Quote_Amount__c = digitPatternCheck(rateAmount) ? decimal.valueOf(rateAmount) : thisProjectService.Custom_Quote_Amount__c; // update Custom quote amount in ps recordwhen rate mulitiplier is Custom Quote 
                    
                   
                    censhareServerUpdate(thisProjectService);
                     if(rateAmount!=null) 
                    if(rateRecord.Rate_Multiplier__c == 'Custom Quote')  
                         update rateRecord; // update custom quote rate amount after call out
                     
                    
                      //getterpsMegaMap();
                       /* thisProjectService.Censhare_XML_update_type__c = 'Update'; 
                        ppw_censhareConnector ppwCen = new ppw_censhareConnector();
                            String xml = ppwCen.censhareXMLBuilder(new List<project_services__c>{thisProjectService});
                        system.debug('xml'+xml);
                        ppw_censhareConnector.resWrap rwrp = new ppw_censhareConnector.resWrap();
                        if(!test.isrunningTest())
                        rwrp = ppw_censhareConnector.censhareServiceSync(xml); // censhare Callout for update 
                            system.debug('rwrp'+rwrp); 
                                if(rwrp.resStatus == false) { 
                                    // censhareError= 'Censhare Service has been failed please connect with system administrator';
                                    censhareError= rwrp.resPs.values()[0].Censhare_XML_Error_Response__c; 
                                    system.debug(censhareError);
                                    project_services__c ps = new project_services__c(id=thisProjectService.id,Censhare_XML_Error_Response__c=rwrp.resPs.values()[0].Censhare_XML_Error_Response__c); 
                                    update(ps); 
                                }
                        if(rwrp.resStatus == true) { 
                            thisProjectService.Estimated_Start_Date__c = rwrp.resPs.get(thisProjectService.id).Estimated_Start_Date__c; 
                            thisProjectService.Estimated_Completion_Date__c = rwrp.resPs.get(thisProjectService.id).Estimated_Completion_Date__c; 
                            update(thisProjectService);
                        } */
              }  else update(thisProjectService);
              /*  if(rateAmount!=null) 
                    if(rateRecord.Rate_Multiplier__c == 'Custom Quote') { 
                        thisProjectService.Custom_Quote_Amount__c = digitPatternCheck(rateAmount) ? decimal.valueOf(rateAmount) : thisProjectService.Custom_Quote_Amount__c; // update Custom quote amount in ps recordwhen rate mulitiplier is Custom Quote 
                        update thisProjectService; 
                    }
                    */
            }
        }
        getterpsMegaMap();
    }
    // check one more promotinal text service exist or not
    public boolean promotionalTextService() {
        
        List<project_services__c> psLst = [SELECT id,Service__r.Name FROM project_services__c WHERE Service__r.Name like 'Promo Text Creation' AND Project__c =: ProjectId];
        if(!psLst.isEmpty()) {
            if(psLst.size() == 1)
                return false;
            else
                return true;     
        } else
              return false;
    }
    
    public void projectPageRefresh() {
       
        getterpsMegaMap();
    }
    public void refreshEditServicePanel() {
       
         cancelStatusFlg = false;
    }
    
    public static boolean pollerEnabled{get;set;}
    public static boolean censhareStatus{get;set;}
    
    // Censhare action poller action method 
    
    
    public void incrementCounter() {
        try {
            if(censhareNewPs != null) {
                AsyncApexJob asyncJob = [SELECT id,Status FROM AsyncApexJob WHERE MethodName='censhareService' AND JobType = 'Future' LIMIT 1];
                if(asyncJob.Status== 'Completed') {
                    List<Project_services__c> cNewPs = [SELECT id,Censhare_XML_Error_Response__c ,Censhare_XML_update_type__c FROM Project_services__c WHERE id =: censhareNewPs.id LIMIT 1];
                    if(cNewPs != null) {
                        if(cNewPs.size()>0) {
                            if(String.isNotBlank(cNewPs[0].Censhare_XML_Error_Response__c) && cNewPs[0].Censhare_XML_Error_Response__c != ' ') {
                                pollerEnabled = false;
                                censhareStatus = false;
                                censhareError = cNewPs[0].Censhare_XML_Error_Response__c;
                                delete cNewPs;
                            } else {
                                pollerEnabled = false;
                                censhareStatus = false;
                            } 
                        }  else {
                            pollerEnabled = true;  
                            censhareStatus = true; 
                        }
                    } else {
                        pollerEnabled = true; 
                        censhareStatus = true; 
                    }
                    } else {
                    pollerEnabled = true;
                    censhareStatus = true; 
                    }
                }
            } catch(Exception e) { 
            //delete tps;   censhareError
          }
        }
    public void refreshPSPanel(){
   
        getterpsMegaMap();
    } 
    public static string censhareServiceStatus{get;set;} 
    @testVisible 
    private String getCurrency(String rateCurrency) { 
        switch on rateCurrency { 
            when 'USD' { 
                return '$'; 
            } 
            when 'EUR' { 
                return '€'; 
            } 
            when 'GBP' { 
                return '£'; 
            } 
            when 'JPY' { 
                return '¥'; 
            } 
            when else { 
                return ''; 
            }
        }
    }
    public void callCenshareAPI_create(){
        //ppw_censhareConnector cs_callout = new ppw_censhareConnector();
        //string response = cs_callout.censhareAPIWebCall (csXMLBody);
        //system.debug('Payload Response: '+response);
        if(promotionalFlg)
        pollerEnabled = false;
        else 
        pollerEnabled = true;
        getterpsMegaMap();
    }
    public project_services__c kickOffPS{get;set;}
    public Boolean censharekickOffPS{get;set;}
    public String forceKickOffReason{get;set;}
    
    public void forceKickOffService() {
        date timeStamp = date.today();
        project_services__c x = new project_services__c(); 
        system.debug(psRec);
        system.debug(x);
        x = allProjectServiceMap.get(psRec);
        x.Status__c = 'Kicked Off';
        x.Force_Kickoff_Reason__c = forceKickOffReason;
        x.has_been_kicked_off__c = true;
        x.Actual_Start_Date__c = timeStamp;
        boolean censhareUpdateStatus = censhareServerUpdate(x);
         if(censhareUpdateStatus) 
             update(x); 
       
      //  update(x);
        getterpsMegaMap();
    }
    
    
    public void kickOffServiceDummy() {
         system.debug('KO PSREC: '+psRec);
         project_services__c  x = allProjectServiceMap.get(psRec);
         kickOffPS = [SELECT id,project__c,project__r.title__c,project__r.title__r.Status__c,status__c FROM project_services__c WHERE id=:x.id LIMIT 1];// = 'Scheduling'];
         //getterpsMegaMap();
     }
    
    public void kickOffService() {
        system.debug('KO PSREC: '+psRec);
        censharekickOffPS = false;
        date timeStamp = date.today();
        project_services__c x = new project_services__c(); 
        x = allProjectServiceMap.get(psRec);
        system.debug(allProjectServiceMap.get(psRec)); 
        system.debug(psRec);
        x.Status__c = 'Kicked Off';
        x.has_been_kicked_off__c = true;
        x.Actual_Start_Date__c = timeStamp;
        ppw_censhareConnector ppwCen = new ppw_censhareConnector();
        x.Censhare_XML_update_type__c = 'Update'; 
            String xml = ppwCen.CenshareXMLBuilder(new List<project_services__c>{x});
        system.debug('xml'+xml);
        
         ppw_censhareConnector.resWrap rwrp = new ppw_censhareConnector.resWrap();
            if(!test.isrunningTest())
            rwrp = ppw_censhareConnector.censhareServiceSync(xml); // censhare Callout for update 
                system.debug('rwrp'+rwrp); 
                    if(rwrp.resStatus == false) { 
                        // censhareError= 'Censhare Service has been failed please connect with system administrator';
                        censharekickOffPS =  rwrp.kickOffRes;     
                    }
            if(rwrp.resStatus == true) {
                censharekickOffPS =  rwrp.kickOffRes;
               
            }
        
        
        kickOffPS = [SELECT id,project__c,project__r.title__c,project__r.title__r.Status__c,status__c FROM project_services__c WHERE id=:x.id LIMIT 1];// = 'Scheduling'];
        if(kickOffPS.project__c !=null && kickOffPS.project__r.title__c!=null)
        if(kickOffPS.project__r.title__r.Status__c == 'Contracted' && kickOffPS.status__c == 'Scheduled')// && censharekickOffPS)   // for time being censhare kick off status not required    
            update(x);
        getterpsMegaMap(); // get udpated data when clicked on kick off service
    }
    public void completeService(){
        system.debug('Completed PSREC: '+psRec);
        censhareError= null;
        date timeStamp = date.today();
        project_services__c ps = new project_services__c();
        ps = allProjectServiceMap.get(psRec);
        ps.Status__c = 'Completed';
        ps.Actual_Completion_Date__c = timeStamp;
        ppw_censhareConnector ppwCen = new ppw_censhareConnector();
        ps.Censhare_XML_update_type__c = 'Update'; 
            String xml = ppwCen.CenshareXMLBuilder(new List<project_services__c>{ps});
        system.debug('xml'+xml);
           
        
        update(ps);
        getterpsMegaMap(); // get udpated data when clicked on Complete service 
    }
    public string cancelSelection {get;set;} 
   /* public list<selectOption> cancelOptions {
        get
        {
            list<selectOption> options = new list<selectOption>();
            options.add(new SelectOption('None', 'Select a Cancel Reason'));
            options.add(new SelectOption('1', 'Cancel Service Only'));
            options.add(new SelectOption('2', 'Cancel and Create a New Service'));
            //options.add(new SelectOption('3', 'Cancel and Kill the Service'));
            return options;
        }
        set;
    } */
        
        public boolean killCancelService{get;set;}
        public void openCancelModal() {
           
            cancelSelection = null;
            censhareError = null;
            list<selectOption> options = new list<selectOption>();
            options.add(new SelectOption('None', 'Select a Cancel Reason'));
            options.add(new SelectOption('1', 'Cancel Service Only'));
            options.add(new SelectOption('2', 'Cancel and Create a New Service'));
            User u = [Select UserRole.Name from user WHERE id =: Userinfo.getUserId() LIMIT 1];
            project_services__c ps = [select id, service__c,status__c FROM project_services__c WHERE id=: psRec LIMIT 1];
            system.debug(ps.status__c); 
            if(ps.status__c == 'Kicked Off' && killServiceRolesSet.containsIgnoreCase(u.UserRole.Name))
            {
                options.add(new SelectOption('3', 'Cancel Service and Initiate Kill Fee')); 
                killCancelService = true;
            }
            cancelOptions = options;
        } 
        public list<selectOption> cancelOptions { 
            get; 
            set; 
        }
        
    public boolean errorCancelCheck {get; set;}
    public boolean cancelStatusFlg {get; set;}  // if tab is cancel canclestatusFlg is making true    
    public boolean confirmationCheckFlg {get; set;} // if confirmation has created confirmationCheckFlg is making true -> change:-when ps status is != confirmation the flg is making false    
    public void cancelService() {
        errorCancelCheck=false;
        cancelStatusFlg = false;
     
        project_services__c x = new project_services__c(); 
        project_services__c y;// = new project_services__c(); 
        x = allProjectServiceMap.get(psRec);
        if(cancelSelection == 'None' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Please select an option.'));
            errorCancelCheck=true;
        }
        
        if(cancelSelection == '1'){
            x.Status__c = 'Cancelled';
            x.Censhare_XML_update_type__c = 'Update';  
           // updateList.add(x);
        }
        
        if(cancelSelection == '2'){
            x.Status__c = 'Cancelled';
            x.Censhare_XML_update_type__c = 'Update'; 
          //  updateList.add(x);
            
            y = x.clone(false,false,false,false);
            y.Status__c = 'In Planning';
            y.Vendor__c = null;
            y.rate__c = null;
            y.Base_Amount__c = null;
            y.Actual_Start_Date__c = null;
            y.Actual_Completion_Date__c = null;
            y.Actual_Start_Date__c = null;
            y.Additional_Rate_Input__c = null;
            y.Amount__c = null;
            //y.Amount_with_currency__c = null;
           // y.Base_Amount_with_Currency__c = null;
            y.Censhare_Asset_ID__c = null;
            y.Censhare_XML_Error_Response__c = null;
            y.Censhare_XML_update_type__c = null;
            y.Custom_Quote_Amount__c = null;
            y.Estimated_Completion_Date__c = null;
            y.Estimated_Start_Date__c = null;
            y.Estimated_Cost__c = null;
            y.Force_Kickoff_Reason__c = null;
            y.Has_Been_Kicked_Off__c = False;
            y.Honor_Dependencies__c = False;
            y.Internal_Service_Notes__c = null;
            y.MBO_Fee__c = null;
            y.Rate_Amount__c = null;
            y.Rate_Currency__c = null;
            y.Rush_Fee__c = null;
            y.SPQ_Number__c = null;
            y.Total_Rate_Amount__c = null;
            y.Total_Rate_Amount_with_MBO_Fee__c = null;
            y.User_Input_Rate_Amount__c = null;
            y.Vendor_Notes_RT__c = null;
            y.Word_Count_Cancelled__c = null;
            y.Word_Count_Completed__c = null;
            y.Word_Count_Confirming__c = null;
            y.Word_Count_In_Planning__c = null;
            y.Word_Count_Kicked_Off__c = null;
            y.Word_Count_Killed__c = null;
            y.Word_Count_Scheduled__c = null;
            
            y.Censhare_XML_update_type__c = 'New'; 
            
          //  insertList.add(y);
        }
        if(cancelSelection == '3'){ 
            x.Status__c = 'Killed'; 
            x.Censhare_XML_update_type__c = 'Update'; 
           /* Group gp;   // for time being commented
            RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType='Case' AND Name='Kill Submissions'];
            if(prodLocale == 'US')
                gp = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName='VM_US_Internal']; 
            if(prodLocale == 'EU' || prodLocale == 'DE' || prodLocale == 'ES' || prodLocale == 'FR' || prodLocale == 'IN' || prodLocale == 'IT' || prodLocale == 'JP' || prodLocale == 'UK') 
                gp = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName='VM_EU_Internal']; 
            case ca = new Case(Project__c = projectID,RecordTypeId=rt.id,Priority='Medium',Project_Service__c = x.id, Service__c = x.service__r.name,Service_Type__c = x.service__r.Service_Rate_Type__c,status='Open', ownerId=gp.id);
            insert ca; */
           // updateList.add(x); 
        }
        system.debug(errorCancelCheck);
        
       
              if(x!=null) { 
              boolean promotext = false; 
              if(x.Service_Name__c == 'Promo Text Creation' && x.Master_PT_Service__c == false) 
              promotext = true; // secondary promo text 
              boolean censhareUpdateStatus = false; 
              if(promotext == false) 
                  censhareUpdateStatus = censhareServerUpdate(x);
                  if(censhareUpdateStatus == true || promotext == true) { // when censhare update is true or secondary promo text service update 
                  
                      Group gp;   // for time being commented
                      String defaultOwnerid;
                      RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType='Case' AND Name='Kill Submissions'];
                      if(prodLocale != null) {
                          if(prodLocale.equalsIgnoreCase('US')) 
                              gp = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName='VM_US_Internal']; 
                          else 
                              if(prodLocale.equalsIgnoreCase('EU') || prodLocale.equalsIgnoreCase('DE') || prodLocale.equalsIgnoreCase('ES') || prodLocale.equalsIgnoreCase('FR') || prodLocale.equalsIgnoreCase('IN') || prodLocale.equalsIgnoreCase('IT') || prodLocale.equalsIgnoreCase('JP') || prodLocale.equalsIgnoreCase('UK')) 
                              gp = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName='VM_EU_Internal'];
                          else
                              defaultOwnerid = [SELECT Id FROM User WHERE alias='kkolla'].id;    
                      } else       
                          defaultOwnerid = [SELECT Id FROM User WHERE alias='kkolla'].id;
                      case ca = new Case(RecordTypeId=rt.id,Priority='Medium',
                                         Title__c = x.Project__r.title__r.id,Project__c = x.Project__c,
                                         Project_Service__c = x!=null? x.id : null,Service__c = x.service__c!=null?x.service__r.name : '',
                                         Service_Type__c = x.service__c!=null?x.service__r.Service_Rate_Type__c : '', 
                                         Vendor__c = x.Vendor__c!=null? x.Vendor__r.id : null,
                                         status='Open',
                                            ownerId= gp!=null? gp.id : defaultOwnerid);
                                    insert ca;
                                    if(promotext == true) // update PSs for only promo text services 
                                    update x; 
                                    // create clone ps for when ps is promo text or call out is success 
                                    if(y != null) { 
                                    insert y; 
                                    if(promotext == false) // promo text secondary services only 
                                    censhareServerInsert(y); 
                                    }
                            }
                            } else
                     
                      if(y != null) {
                          insert y;    
                          censhareServerInsert(y);
                          getterpsMegaMap();
                      }
                      getterpsMegaMap(); // refresh project services data with new data 
                      
             
    }
   
   public Boolean censhareServerUpdate(project_services__c cPS) {
        if(cPS != null) {
                ppw_censhareConnector ppwCen = new ppw_censhareConnector();
                    String xml = ppwCen.censhareXMLBuilder(new List<project_services__c>{cPS});
                system.debug('xml'+xml);
                ppw_censhareConnector.resWrap rwrp = new ppw_censhareConnector.resWrap();
                if(!test.isrunningTest())
                rwrp = ppw_censhareConnector.censhareServiceSync(xml); // censhare Callout for update 
            if(test.isrunningTest())
                rwrp = PPW_TestDataFactory.setPasitiveTestData(cPS);
                 system.debug('rwrp'+rwrp); 
                        if(rwrp.resStatus == false) { 
                            // censhareError= 'Censhare Service has been failed please connect with system administrator';
                            if(rwrp.resPs != null) { 
                                if(!rwrp.resPs.values().isEmpty()){ 
                            censhareError= rwrp.resPs.values()[0].Censhare_XML_Error_Response__c; 
                            system.debug(censhareError);
                            project_services__c ps = new project_services__c(id=cPS.id,Censhare_XML_Error_Response__c=rwrp.resPs.values()[0].Censhare_XML_Error_Response__c); 
                            update(ps); 
                                } else { 
                                    censhareError = 'empty XML received from censhare, please refresh the page'; 
                                    system.debug(censhareError); 
                                    project_services__c ps = new project_services__c(id=cPS.id,Censhare_XML_Error_Response__c = censhareError); 
                                    update(ps); 
                                }
                            }
                            else {
                                censhareError = 'empty XML received from censhare, please refresh the page'; 
                                system.debug(censhareError); 
                                project_services__c ps = new project_services__c(id=cPS.id,Censhare_XML_Error_Response__c = censhareError); 
                                update(ps); 
                           } 
                            return rwrp.resStatus;
                        }
            if(rwrp.resPs != null) 
                if(rwrp.resStatus == true && !rwrp.resPs.isEmpty()) { 
                    if(rwrp.resPs.containsKey(cPS.id)) {
                        cPS.Estimated_Start_Date__c = rwrp.resPs.get(cPS.id).Estimated_Start_Date__c; 
                        cPS.Estimated_Completion_Date__c = rwrp.resPs.get(cPS.id).Estimated_Completion_Date__c; 
                        if(cPs!=null) { 
                        update(cPS);
                        return rwrp.resStatus;
                            } else 
                                return false; 
                    } else return false;
                }
             return false;   
             }  
        return false; 
   }
   
   
    private void censhareServerInsert(project_services__c cPS) {
        if(cPS != null) {
            try { 
           ppw_censhareConnector ppwCen = new ppw_censhareConnector();
             String xml = ppwCen.censhareXMLBuilder(new List<project_services__c>{cPS});
            system.debug('xml'+xml);
            if(!test.isrunningTest())
            ppw_censhareConnector.censhareService(xml,cPS.id); 
                pollerEnabled = true; 
                censhareStatus = true; 
            } catch(Exception e) {
                //delete tps;
            } 
        } 
   
   }
   
    
    public decimal additionalRateInput {get; set;}
    public map<string, string> additionalRateStringMap {
        get{
            map<string, string> tempMap = new map<string, string>();
            
            for(rate__c r : [select id, rate_multiplier__c from rate__c where rate_multiplier__c!=null]){
                string x;
                x = r.rate_multiplier__c.remove('Per ');
                tempMap.put(r.id, x);
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
            
            for(rate__c r : [select id, rate_multiplier__c from rate__c where rate_multiplier__c!=null]){
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
    
    public class projectServiceWrapper{
        public project_services__c ps {get; set;}
        public list<string> serviceAlerts {get; set;}
        public boolean editCheck {get;set;}
        public boolean confirmationCheck {get;set;}
        public boolean kickOffCheck {get;set;}         
        public boolean cancelCheck {get;set;}
        public boolean ptfCheck {get;set;}
        public boolean completeCheck {get;set;}
    }
    
    public projectServiceWrapper pswCreator(project_services__c px){
        projectServiceWrapper tempPSW = new projectServiceWrapper();
        list<string> alerts = new list<string>();
        tempPSW.ps=px;
        
        if(px.Status__c=='In Planning'){
            tempPSW.editCheck=true;
            if(px.Estimated_Start_Date__c!=null && px.Vendor__c!=null){
                
            }
            //alerts.add('Test alert');
        }
        if(px.Status__c=='Confirming'){
            
        }
        if(px.Status__c=='Scheduled'){
            
        }
        if(px.Status__c=='Kicked Off'){
            
        }
        if(px.Status__c=='Cancelled'){
            
        }
        if(px.Status__c=='Complete'){
            
        }
        
        
        tempPSW.serviceAlerts = alerts;
        return tempPSW;
    }

    public list<String> statusKeys{get;set;}
    public map<String,set<String>> serviceNames{get;set;}
    public map<String,map<string,set<String>>> serviceRateType{get;set;}
    
   // public Map<String,set<String>> InteriorKeys {get;set;}
   // public Map<String,set<String>> getInteriorKeys() {return null;}
   // public void setInteriorKeys() {}
    
    
    public map<string, map<string, map<string,list<projectServiceWrapper>>>> psMegaMap {
        get;
        set;
    }
    
  //  public

    private map<string, map<string, map<String,list<projectServiceWrapper>>>> getterpsMegaMap() {
        statusKeys = new  list<String>();
        serviceRateType = new map<String,map<string,set<String>>>();
        serviceNames = new map<String,set<String>>();
        set<string> activeSet = new set<string>();
        set<string> completedSet = new set<string>();
        set<string> cancelledSet = new set<string>();
        activeCount=0;
        completedCount=0;
        cancelledCount=0;           
        
        map<string, map<string, map<string,list<projectServiceWrapper>>>> tempMegaMap = new map<string, map<string, map<String,list<projectServiceWrapper>>>>();
        map<string, map<string,list<projectServiceWrapper>>> activeInteriorMap = new map<string, map<string,list<projectServiceWrapper>>>();
        map<string, map<string,list<projectServiceWrapper>>> completeInteriorMap = new map<string, map<string,list<projectServiceWrapper>>>();
        map<string, map<string,list<projectServiceWrapper>>> cancelledInteriorMap = new map<string, map<string,list<projectServiceWrapper>>>();
        
        activeSet.addAll(label.Project_Service_Active_Status.split(','));
        completedSet.addAll(label.Project_Service_Completed_Status.split(','));
        cancelledSet.addAll(label.Project_Service_Cancelled_Status.split(','));
        
        list<project_services__c> serviceList = new list<project_services__c>([
            SELECT id, name, Vendor_Notes_RT__c, Service__c, Service__r.name, Rate__r.name,Actual_Completion_Date__c,Actual_Start_Date__c, 
            service__r.Service_Grouping_String__c, Internal_Service_Notes__c,Estimated_Completion_Date__c,Estimated_Start_Date__c,
            Status__c,Vendor__r.name, service__r.service_rate_type__c,Rate_Amount__c, rush_fee__c, LastModifiedDate, LastModifiedBy.Name, 
            has_been_kicked_off__c,Amount__c,rate__r.Rate_Multiplier__c,rate__r.Rate_Amount__c,Base_Amount__c,Service_Name__c,
            MBO_Fee__c,Total_Rate_Amount_with_MBO_Fee__c ,Total_Rate_Amount__c,User_Input_Rate_Amount__c,Master_PT_Service__c,
            Base_Amount_with_Currency__c,MBO_Fee_with_Currency__c,project__c,project__r.title__c,project__r.title__r.Marty_Title_ID__c
            FROM Project_Services__c 
            WHERE Project__c=:projectID 
            ORDER BY estimated_start_date__c ASC NULLS LAST
        ]);
        // psInplanningCount = psLst.size();
        
         integer inplanningCount =0;
        if(!serviceList.isEmpty()){  
            for(project_services__c ps : serviceList){
            system.debug(ps.status__c);
                if(ps.status__c == 'In Planning')
                    inplanningCount = inplanningCount +1;
                addInteriorMap(activeSet,ps,activeInteriorMap);
                addInteriorMap(completedSet,ps,completeInteriorMap);
                addInteriorMap(cancelledSet,ps,cancelledInteriorMap);
                
            } //close the inner builder
        }//close the main if statement
       // psInplanningCount = inplanningCount;
        system.debug('activeInteriorMap: '+activeInteriorMap.get('Art and Illustrations'));
        
        if(!activeInteriorMap.isEmpty()){
            statusKeys.add('Active');
            tempMegaMap.put('Active', activeInteriorMap);
            
            for(String s: activeInteriorMap.keyset()) {
                if(serviceRateType.containsKey('Active')){
                    if(serviceRateType.get('Active').containsKey(s)) {
                        //  serviceRateType.get('Active').get(s).addall(activeInteriorMap.keyset());//new map<String,set<string>>{s=>activeInteriorMap.keyset()});    
                    }  else
                        if(s!=null)
                        serviceRateType.get('Active').put(s, activeInteriorMap.get(s).keyset());
                } else
                    if(s!=null)
                    serviceRateType.put('Active',new map<String,set<string>>{s=>activeInteriorMap.get(s).keyset()});
                if(serviceNames.containskey('Active'))
                    serviceNames.get('Active').add(s);
                else            
                    serviceNames.put('Active', new set<String>{s});
                
             }
        }
        
        
        if(!completeInteriorMap.isEmpty()) {
            statusKeys.add('Completed');
            
            for(String s: completeInteriorMap.keyset()) {
                if(serviceRateType.containsKey('Completed')) {
                    if(serviceRateType.get('Completed').containsKey(s)) {
                        //serviceRateType.get('Completed').get(s).addall(completeInteriorMap.keyset());//new map<String,set<string>>{s=>activeInteriorMap.keyset()});    
                    }else
                        serviceRateType.get('Completed').put(s, completeInteriorMap.get(s).keyset());
                } else
                    serviceRateType.put('Completed',new map<String,set<string>>{s=>completeInteriorMap.get(s).keyset()});
                
                if(serviceNames.containskey('Completed'))
                    serviceNames.get('Completed').add(s);
                else            
                    serviceNames.put('Completed', new set<String>{s});
            }
            
            
            tempMegaMap.put('Completed', completeInteriorMap);
        }
        
        
        if(!cancelledInteriorMap.isEmpty()) {
            statusKeys.add('Cancelled');
            // InteriorKeys.put('Cancelled',cancelledInteriorMap.keyset());
            
            for(String s: cancelledInteriorMap.keyset()) {
                if(serviceRateType.containsKey('Cancelled')){
                    if(serviceRateType.get('Cancelled').containsKey(s)) {
                        //    serviceRateType.get('Cancelled').get(s).addall(cancelledInteriorMap.keyset());//new map<String,set<string>>{s=>activeInteriorMap.keyset()});    
                    } else
                        serviceRateType.get('Cancelled').put(s, cancelledInteriorMap.get(s).keyset());
                } else
                    serviceRateType.put('Cancelled',new map<String,set<string>>{s=>cancelledInteriorMap.get(s).keyset()});
                if(serviceNames.containskey('Cancelled'))
                    serviceNames.get('Cancelled').add(s);
                else            
                    serviceNames.put('Cancelled', new set<String>{s});
            }
            tempMegaMap.put('Cancelled', cancelledInteriorMap);
        }
        
        System.debug('tempMegaMap'+tempMegaMap);
        psMegaMap =  tempMegaMap;
        
        if(!tempMegaMap.isempty() && tempMegaMap.containsKey('Active'))
            for(String s: tempMegaMap.get('Active').keyset()) 
            for(string st : tempMegaMap.get('Active').get(s).keyset()) {
                activeCount += tempMegaMap.get('Active').get(s).get(st).size();
                for(projectServiceWrapper pw: tempMegaMap.get('Active').get(s).get(st))
                    activePsIds.add(pw.ps.id); 
            }
        if(!tempMegaMap.isempty() && tempMegaMap.containsKey('Completed'))
            for(String s: tempMegaMap.get('Completed').keyset())
            for(string st : tempMegaMap.get('Completed').get(s).keyset()) {
                completedCount += tempMegaMap.get('Completed').get(s).get(st).size();
                for(projectServiceWrapper pw: tempMegaMap.get('Completed').get(s).get(st)) 
                    completePsIds.add(pw.ps.id); 
            }
        if(!tempMegaMap.isEmpty() && tempMegaMap.containsKey('Cancelled'))
            for(String s: tempMegaMap.get('Cancelled').keyset()) 
            for(string st : tempMegaMap.get('Cancelled').get(s).keyset()){
                cancelledCount += tempMegaMap.get('Cancelled').get(s).get(st).size();
                for(projectServiceWrapper pw: tempMegaMap.get('Cancelled').get(s).get(st)) 
                    cancelPsIds.add(pw.ps.id); 
            }   
          
        return tempMegaMap;
        
    }
    private void addInteriorMap(set<string> statusSet,project_services__c ps, map<string, 
                                map<string,list<projectServiceWrapper>>> interiorMap
                               ) {
                                   projectServiceWrapper psw = new projectServiceWrapper();
                                   psw = pswCreator(ps);
                                   
                                   if(statusSet.contains(ps.status__c)){ //we have an active service
                                       if(interiorMap.containsKey(ps.service__r.name)){
                                           if(interiorMap.get(ps.service__r.name).containsKey(ps.service__r.Service_Rate_Type__c))
                                               interiorMap.get(ps.service__r.name).get(ps.service__r.Service_Rate_Type__c).add(psw);
                                           else
                                               if(ps.service__r.Service_Rate_Type__c!=null) 
                                               interiorMap.get(ps.service__r.name).put(ps.service__r.Service_Rate_Type__c, new List<projectServiceWrapper>{psw});       
                                       } else
                                           if(ps.service__r.name!=null && ps.service__r.Service_Rate_Type__c!=null) 
                                           interiorMap.put(ps.service__r.name, new map<string,List<projectServiceWrapper>>{ps.service__r.Service_Rate_Type__c => new List<projectServiceWrapper>{psw}});       
                                       
                                       
                                   }
                               }   
    
    public list<string> activeServiceGroups{ // list of active service groups
        get{
            return null;
        }
        set;
    }
    
    public map<string, list<projectServiceWrapper>> psWrapperMap{
        get{
          /*  
             set<string> activeSet = new set<string>();
            set<string> completedSet = new set<string>();
            set<string> cancelledSet = new set<string>();
            
            activeSet.addAll(label.Project_Service_Active_Status.split(','));
            completedSet.addAll(label.Project_Service_Completed_Status.split(','));
            cancelledSet.addAll(label.Project_Service_Cancelled_Status.split(','));
            
            map<string, list<project_services__c>> tempMap = new map<string, list<project_services__c>>();
            list<project_services__c> serviceList = new list<project_services__c>([
                SELECT id, name, Vendor_Notes_RT__c, Service__c, Service__r.name, Rate__r.name,Actual_Completion_Date__c,Actual_Start_Date__c, service__r.Service_Grouping_String__c, Internal_Service_Notes__c,
                Estimated_Completion_Date__c,Estimated_Start_Date__c,Status__c,Vendor__r.name, service__r.service_rate_type__c,Rate_Amount__c, rush_fee__c, LastModifiedDate, LastModifiedBy.Name
                FROM Project_Services__c 
                WHERE Project__c=:projectID 
                ORDER BY estimated_start_date__c DESC
            ]);
            
            list<project_services__c> fillerList1 = new list<project_services__c>();
            list<project_services__c> fillerList2 = new list<project_services__c>();
            list<project_services__c> fillerList3 = new list<project_services__c>();
            tempMap.put('Active', fillerList1);
            tempMap.put('Completed', fillerList2);
            tempMap.put('Cancelled', fillerList3);
            
            if(!serviceList.isEmpty()){
                for(project_services__c sp : serviceList){
                    if(activeSet.contains(sp.status__c)){ //active service
                        if(tempMap.containsKey('Active')){
                            list<project_services__c> activeList = tempMap.get('Active');
                            if(activeList.size() > 0){
                                activeList.add(0,sp);
                            }else{
                                activeList.add(sp);
                            }
                            tempMap.put('Active',activeList);
                        }else{
                            List<project_services__c> activeList = new List<project_services__c>();
                            activeList.add(sp);
                            tempMap.put('Active',activeList);
                        }
                        continue;
                    }
                    if(completedSet.contains(sp.status__c)){ //completed service
                        if(tempMap.containsKey('Completed')){
                            list<project_services__c> temp = tempMap.get('Completed');
                            if(temp.size() > 0){
                                temp.add(0,sp);
                            }else{
                                temp.add(sp);
                            } 
                            tempMap.put('Completed',temp);
                        }else{
                            List<project_services__c> temp = new List<project_services__c>();
                            temp.add(sp);
                            tempMap.put('Completed',temp);
                        }
                        continue;                        
                    }
                    if(cancelledSet.contains(sp.status__c)){ //cancelled service
                        if(tempMap.containsKey('Cancelled')){
                            list<project_services__c> temp = tempMap.get('Cancelled');
                            if(temp.size() > 0){
                                temp.add(0,sp);
                            }else{
                                temp.add(sp);
                            }
                            tempMap.put('Cancelled',temp);
                        }else{
                            List<project_services__c> temp = new List<project_services__c>();
                            temp.add(sp);
                            tempMap.put('Cancelled',temp);
                        }  
                        continue;
                    }
                }
            }
            
            activeCount = tempMap.get('Active').size();
            completedCount = tempMap.get('Completed').size();

            cancelledCount = tempMap.get('Cancelled').size();
            
            return tempMap;
*/
            return null;
        }
        set;
    }


}