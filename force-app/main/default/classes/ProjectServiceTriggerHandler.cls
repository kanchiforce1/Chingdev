/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Service Prep Form
Description: Populates calculated rate when vendor or service changes
***********************************/
public class ProjectServiceTriggerHandler implements Queueable{
    
    /** Rate population when user changes the service or vendor  **/
    
    public static map<String,rate__C> rates = new map<String,rate__C>();
    public static map<String,rate__C> rateMap = new map<String,rate__C>(); 
    public static map<String,Service__c> services = new map<String,Service__c>();
    public static Map<String,project__c> projectMap;
    
    /** Get rates using rate object query **/ 
    public static void rate_Confirmations(){
        
        if(rates.isEmpty())
            for(rate__C r : [Select id,Service__c,Vendor__c,Rate_Currency__c,Vendor__r.MBO_Program__c,
                             Rate_Amount__c,Rate_Multiplier__c from rate__c where Active_rate__c = true]){
                                 if(r.Service__c!=null&&r.Vendor__c!=null)
                                     rates.put(r.Service__c+'__'+r.Vendor__c,r);
                                 rateMap.put(r.id,r); 
                                 
                             }
    }
    
    /** Get rates  **/ 
    public static void getRates(List<Project_Services__c> newMap) {
        List<String> Sids = new List<String>();
        for(Project_Services__c ps: newMap)
            if(ps.Service__c!=null) 
            Sids.add(ps.Service__c);
        if(services.isEmpty()) 
            services = new map<String,Service__c>([Select id,name,Service_Complexity_Value__c,Service_Rate_Type__c from Service__c]);
    }
    
    /** Rate population when ps record updates **/
    public static void rate_CalcBeforeUpdate(Map<Id,Project_Services__c> newMap,Map<Id,Project_Services__c> oldMap) {
        rate_Confirmations();
        getRates(newMap.values());
        set<Id> tIds = new set<Id>();
        List<Project_Services__c> psLsit = new list<Project_Services__c>();
        for(Project_Services__c ps: newMap.values()) {
            if(ps.Service__c != oldMap.get(ps.id).Service__c || ps.Vendor__c != oldMap.get(ps.id).Vendor__c) //Vendor__c
                psLsit.add(ps);
            if(oldMap.get(ps.id).status__c != ps.status__c)    
                tIds.add(ps.project__c); 
        }
        System.debug(tIds);
        if(!tIds.isempty() &&  projectMap == null)
            projectMap  = new Map<String,project__c>([SELECT id,title__r.Pre_Dev_Edit_Word_Count__c  from project__c where id=: tIds]);
        
        for(Project_Services__c p: newMap.values()) {
            if(services!= null && p.Service__c != null)
                if(services.containsKey(p.Service__c)) 
                if(Label.Word_Count_Services.containsIgnoreCase(services.get(p.Service__c).Name)) 
                if(projectMap!=null) 
                if(projectMap.containsKey(p.project__c)) {
                    if(p.Status__c == 'Cancelled')
                        p.Word_Count_Cancelled__c =  projectMap.get(p.project__c).title__r.Pre_Dev_Edit_Word_Count__c ;
                    if(p.Status__c == 'In Planning')
                        p.Word_Count_In_Planning__c =  projectMap.get(p.project__c).title__r.Pre_Dev_Edit_Word_Count__c ;
                    if(p.Status__c == 'Confirming')
                        p.Word_Count_Confirming__c =  projectMap.get(p.project__c).title__r.Pre_Dev_Edit_Word_Count__c ;
                    if(p.Status__c == 'Completed')
                        p.Word_Count_Completed__c =  projectMap.get(p.project__c).title__r.Pre_Dev_Edit_Word_Count__c ;           
                    if(p.Status__c == 'Scheduled')
                        p.Word_Count_Scheduled__c =  projectMap.get(p.project__c).title__r.Pre_Dev_Edit_Word_Count__c ;
                    if(p.Status__c == 'Kicked Off')
                        p.Word_Count_Kicked_Off__c =  projectMap.get(p.project__c).title__r.Pre_Dev_Edit_Word_Count__c ;       
                    if(p.Status__c == 'Killed')
                        p.Word_Count_Killed__c =  projectMap.get(p.project__c).title__r.Pre_Dev_Edit_Word_Count__c ;        
                }        
        }
        
        for(Project_Services__c ps: psLsit) {
        
            if(ps.Service__c!=null && ps.Vendor__c!=null) {
                if(rates.containskey(ps.Service__c+'__'+ps.Vendor__c)){
                    ps.Rate__c = rates.get(ps.Service__c+'__'+ps.Vendor__c).id;
                    ps.Rate_Currency__c = rates.get(ps.Service__c+'__'+ps.Vendor__c).Rate_Currency__c;
                    if(services.containsKey(ps.Service__c))
                        ps.Service_Type_Complexity__c = services.get(ps.Service__c).Service_Rate_Type__c;
                } 
            }else {
                if(ps.Service__c!=null) {
                    ps.Rate__c = null;
                    ps.Rate_Currency__c = ''; 
                    ps.Amount__c = 0;
                    ps.Rate_Amount__c = '';
                    if(services!=null && services.containsKey(ps.Service__c))
                        ps.Service_Type_Complexity__c = (services.get(ps.Service__c).Service_Rate_Type__c!=null ? services.get(ps.Service__c).Service_Rate_Type__c : '');
                } 
            }
        } 
        
    }
    
    /**  Populate rate currency and service rate type when ps recrod is inserting **/
    public static void rate_CalcBeforeInsert(List<Project_Services__c> newMap) {
        List<Project_Services__c> psLsit = new list<Project_Services__c>();
        set<Id> tIds = new set<Id>(); 
        rate_Confirmations();
        getRates(newMap);
        for(Project_Services__c ps: newMap) {
            if(ps.Service__c !=null || ps.Vendor__c != null) 
                psLsit.add(ps);
            tIds.add(ps.project__c); 
        } 
        System.debug(tids);
        projectMap = new Map<String,project__c>([SELECT id,title__r.Pre_Dev_Edit_Word_Count__c  from project__c where id=: tIds]);
        for(Project_Services__c ps: psLsit)
        {
            if(ps.Service__c!=null && ps.Vendor__c!=null)
                if(rates.containskey(ps.Service__c+'__'+ps.Vendor__c)){
                    ps.Rate__c = rates.get(ps.Service__c+'__'+ps.Vendor__c).id;
                    ps.Rate_Currency__c = rates.get(ps.Service__c+'__'+ps.Vendor__c).Rate_Currency__c;
                    
                }
            if(ps.Service__c!=null && services.containsKey(ps.Service__c)) {
                ps.Service_Type_Complexity__c = services.get(ps.Service__c).Service_Rate_Type__c;   
            if(projectMap.containsKey(ps.project__c))
                if(Label.Word_Count_Services.containsIgnoreCase(services.get(ps.Service__c).Name))
                    ps.Word_Count_In_Planning__c = projectMap.get(ps.project__c).title__r.Pre_Dev_Edit_Word_Count__c ;
            }
        }  
        
    }
    
    /** Rate amount calculation when Rush fee changes **/
    public static void rate_CalcAfterUpdate(Map<Id,Project_Services__c> newMap,Map<Id,Project_Services__c> oldMap) {
        List<Project_Services__c> psLsit = new list<Project_Services__c>();
        rate_Confirmations();
        list<Project_Services__c> pserList = new list<Project_Services__c>();
        list<Project_Services__c> pserList1 = new list<Project_Services__c>(); 
        for(Project_Services__c p: newMap.values()){
            if(p.rate__C!=null)
                
                if((oldMap.get(p.id).rate__c!=p.rate__C || oldMap.get(p.id).Rush_Fee__c!=p.Rush_Fee__c 
                    ||p.Additional_Rate_Input__c != oldMap.get(p.id).Additional_Rate_Input__c 
                    || p.Custom_Quote_Amount__c != oldMap.get(p.id).Custom_Quote_Amount__c 
                    || oldMap.get(p.id).status__c!=p.status__c )&& (p.User_Input_Rate_Amount__c == null || p.User_Input_Rate_Amount__c == 0.000 || p.User_Input_Rate_Amount__c == 0))
                pserList.add(p);
            /*  commenting the ABOVE CODE  to trigger ratye calculation even though user_input_rate_amount has value in it  */
            /*  if((oldMap.get(p.id).Rush_Fee__c!=p.Rush_Fee__c 
||p.Additional_Rate_Input__c != oldMap.get(p.id).Additional_Rate_Input__c 
|| p.Custom_Quote_Amount__c != oldMap.get(p.id).Custom_Quote_Amount__c 
|| oldMap.get(p.id).status__c!=p.status__c )&& (p.User_Input_Rate_Amount__c == null || p.User_Input_Rate_Amount__c == 0.000 || p.User_Input_Rate_Amount__c == 0))
pserList.add(p);
else {
if(oldMap.get(p.id).rate__c!=p.rate__C)
pserList.add(p);
}  */  
            
            
        }
        
        if(!pserList.isempty()){
            ppw_handlerforCalculation rates1 = new ppw_handlerforCalculation();
            List<Project_Services__c> psLst = rates1.ratecalc(pserList);
            update psLst; 
        }
    }
    
    /** Rate calculation when we insert the ps records with vendor and service  **/ 
    public static void rate_CalcAfterInsert(Map<Id,Project_Services__c> newMap,Map<Id,Project_Services__c> oldMap) {
        List<Project_Services__c> psLsit = new list<Project_Services__c>();
        rate_Confirmations();
        list<Project_Services__c> pserList = new list<Project_Services__c>();
        for(Project_Services__c p: newMap.values()){
            if(p.rate__C!=null)
                pserList.add(p);
        }
        if(!pserList.isempty()) {
            ppw_handlerforCalculation rates1 = new ppw_handlerforCalculation();
            List<Project_Services__c> psLst = rates1.ratecalc(pserList);
            update psLst;              
        }
    }
    
    /** Update estimated start and End date for primary promotext services  **/ 
    public static void updatePromotextStartEnd(Map<Id,Project_Services__c> newMap,Map<Id,Project_Services__c> oldMap) {
        set<String> pIds = new set<String>();
        Map<Id,Project_Services__c> psMap = new Map<Id,Project_Services__c>();
        for(Project_Services__c p: newMap.values()) 
            if((oldMap.get(p.id).Master_PT_Service__c != p.Master_PT_Service__c || oldMap.get(p.id).Status__c != p.Status__c || oldMap.get(p.id).Estimated_Start_Date__c != p.Estimated_Start_Date__c || oldMap.get(p.id).Estimated_Completion_Date__c != p.Estimated_Completion_Date__c) && 
               p.Service_Name__c == 'Promo Text Creation' && p.Master_PT_Service__c == true) {
                   pIds.add(p.project__c);
                   psMap.put(p.project__c, p);
               }        
        List<Project_Services__c> updatePs = new List<Project_Services__c>();
        for(Project_Services__c ps1: [SELECT Master_PT_Service__c,Status__c,project__c,Actual_Start_Date__c,Actual_Completion_Date__c,Service_Name__c,Estimated_Start_Date__c,Estimated_Completion_Date__c
                                      FROM Project_Services__c WHERE Service_Name__c = 'Promo Text Creation' AND Project__c =: pIds AND Master_PT_Service__c = false]) {
                                          
                                          ps1.Estimated_Start_Date__c = psMap.get(ps1.Project__c).Estimated_Start_Date__c;   
                                          ps1.Estimated_Completion_Date__c = psMap.get(ps1.Project__c).Estimated_Completion_Date__c;
                                          if(psMap.get(ps1.Project__c).Status__c == 'Kicked Off' || psMap.get(ps1.Project__c).Status__c == 'Completed') {
                                              ps1.Status__c = psMap.get(ps1.Project__c).Status__c; 
                                              ps1.Actual_Start_Date__c = psMap.get(ps1.Project__c).Actual_Start_Date__c;
                                              if(psMap.get(ps1.Project__c).Status__c == 'Completed')
                                                 ps1.Actual_Completion_Date__c = psMap.get(ps1.Project__c).Actual_Completion_Date__c;
                                              
                                          }   
                                          updatePs.add(ps1);
                                          
                                      } 
        database.update(updatePs);   
    }
    
    /** delete remaing promo text services when primary PT censhare call is failed **/ 
    public static void deletePromotextServices(List<Project_Services__c> oldList) {
        set<String> pIds = new set<String>();
        
        for(Project_Services__c p: oldList)
            if(p.Service_Name__c == 'Promo Text Creation')
            pIds.add(p.project__c);
        List<Project_Services__c> primarypTServices = [SELECT id FROM Project_Services__c WHERE Master_PT_Service__c = true AND Project__c =: pIds];     
        if(primarypTServices.isEmpty()) {
            List<Project_Services__c> pTServices = [SELECT Master_PT_Service__c,Status__c,Service_Name__c,Estimated_Start_Date__c,Estimated_Completion_Date__c
                                                    FROM Project_Services__c WHERE Service_Name__c = 'Promo Text Creation' AND Project__c =: pIds AND Master_PT_Service__c = false];
            
            
            delete pTServices;
        }
    }
    
    
    /** Insert estimated start and End date for primary promotext services  **/ 
    public static void insertPromotextStartEnd(List<Project_Services__c> newList) {
        set<String> pIds = new set<String>();
        
        for(Project_Services__c p: newList)
            
            if(p.Service_Name__c == 'Promo Text Creation')
            pIds.add(p.project__c);
        
        List<Project_Services__c> updatePs = new List<Project_Services__c>();
        List<Project_Services__c> ps1 = [SELECT Master_PT_Service__c,Status__c,Service_Name__c,Estimated_Start_Date__c,Estimated_Completion_Date__c
                                         FROM Project_Services__c WHERE Service_Name__c = 'Promo Text Creation' AND Project__c =: pIds AND Master_PT_Service__c = true LIMIT 1];
        if(!ps1.isEmpty())
            for(Project_Services__c p: newList) 
            if(p.Service_Name__c == 'Promo Text Creation') {
                p.Estimated_Start_Date__c = ps1[0].Estimated_Start_Date__c;   
                p.Estimated_Completion_Date__c = ps1[0].Estimated_Completion_Date__c;
                // updatePs.add(p);
                
            }    
        
        // database.update(updatePs);   
    }
    
    
    /** Mark the open confirmation as internally closed whenever Rate, service, service type or vendor changes  **/ 
    public static void closeOpenConfirmation(Map<Id,Project_Services__c> newMap,Map<Id,Project_Services__c> oldMap) {
        set<String> psIds = new set<String>();
        List<Confirmation__c> updateConfirmations = new List<Confirmation__c>();
        for(Project_Services__c p: newMap.values())
            
            if((oldMap.get(p.id).Vendor__c !=p.Vendor__c || oldMap.get(p.id).Service__c !=p.Service__c ||
                oldMap.get(p.id).Rush_Fee__c !=p.Rush_Fee__c || oldMap.get(p.id).Additional_Rate_Input__c !=p.Additional_Rate_Input__c ||
                oldMap.get(p.id).Custom_Quote_Amount__c !=p.Custom_Quote_Amount__c || 
                oldMap.get(p.id).rate_Amount__c !=p.rate_Amount__c || oldMap.get(p.id).status__c !=p.status__c))
            psIds.add(p.id);
        for(Confirmation__c c : [SELECT id,status__C,Date_of_Confirmation__c FROM Confirmation__c WHERE status__c = 'Open' AND Project_Services__c =:psIds]) {
            c.status__c = 'Internal Closed';
            c.Date_of_Confirmation__c = Date.today(); 
            updateConfirmations.add(c);
            
        }
        update updateConfirmations;
    }
    /** change total mbo amount value when new amount gets updated to calculate new mbo value as well */
    public static void MBOTotalAmountUpdate(Map<Id,Project_Services__c> newMap) {
        rate_Confirmations();
        for(Project_Services__c ps: newMap.values()) {
            if(ps.User_Input_Rate_Amount__c != null && ps.User_Input_Rate_Amount__c !=0 && ps.rate__c != null){ // when User input is given by super user we need to update the Amount, Rate Amount
                ps.Rate_Amount__c = ppw_handlerforCalculation.getCurrency(rateMap.get(ps.rate__c).Rate_Currency__c) + '' + ps.User_Input_Rate_Amount__c.divide(1, 3) + ' ('+rateMap.get(ps.rate__c).Rate_Multiplier__c+')';
                ps.Amount__c = ps.User_Input_Rate_Amount__c; 
            }
            Decimal Amount = (ps.Amount__c != null ? ps.Amount__c : 0);
            ps.MBO_Fee__c = ppw_handlerforCalculation.updateMBOValue(ps); 
            Decimal MBOFee = (ps.MBO_Fee__c != null ? ps.MBO_Fee__c : 0);
            ps.Total_Rate_Amount_with_MBO_Fee__c = Amount + MBOFee;
            if(rateMap != null) { 
                if(rateMap.containsKey(ps.rate__c))   
                    ps.Total_Rate_Amount__c =  ppw_handlerforCalculation.getCurrency(rateMap.get(ps.rate__c).Rate_Currency__c) + '' + ps.Total_Rate_Amount_with_MBO_Fee__c+ ' ('+ rateMap.get(ps.rate__c).Rate_Multiplier__c + ')';
                else
                    ps.Total_Rate_Amount__c = ps.Total_Rate_Amount_with_MBO_Fee__c+ '';    
            } 
        }
    }
    
    // creating confirmation records when status is change to scheduled to confirm
    public static void createConfirmation(Map<Id,Project_Services__c> newMap,Map<Id,Project_Services__c> oldMap) {
        rate_Confirmations();
        Map<String,project_services__c> thispsMap = new Map<String,project_services__c>([SELECT id,Service__c,Vendor__c,rate_Amount__c,Amount__c ,Service_Type_Complexity__c,status__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,Word_Count_Completed__c, Base_Amount__c,
                                                                                         Base_Amount_with_Currency__c,Rate_Currency__c,MBO_Fee__c,Rush_Fee__c,Total_Rate_Amount__c, Rate_Amount_with_Currency__c,Total_Rate_Amount_with_Currency__c,
                                                                                         Service__r.Service_rate_type__c,Vendor__r.name,MBO_Fee_with_Currency__c,(select id from Confirmation__r where status__c = 'Open'),
                                                                                         Word_Count_Cancelled__c ,Honor_Dependencies__c,Additional_Rate_Input__c,Custom_Quote_Amount__c
                                                                                         FROM project_services__c WHERE id=: newMap.keySet()]);
        List<Confirmation__c> conList = new List<Confirmation__c>();
        for(Project_Services__c ps: newMap.values()) {
            if(((ps.Status__c != oldMap.get(ps.id).Status__c && 
                 ps.Status__c == 'Confirming' && oldMap.get(ps.id).Status__c == 'Scheduled') && (ps.Has_Been_Kicked_Off__c == false )) // creating confirmation records when status is change to scheduled to confirm
               
               || 
               
               (oldMap.get(ps.id).Vendor__c !=ps.Vendor__c || oldMap.get(ps.id).Service__c !=ps.Service__c ||
                oldMap.get(ps.id).Rush_Fee__c !=ps.Rush_Fee__c || oldMap.get(ps.id).Additional_Rate_Input__c !=ps.Additional_Rate_Input__c ||
                oldMap.get(ps.id).Custom_Quote_Amount__c !=ps.Custom_Quote_Amount__c || 
                oldMap.get(ps.id).rate_Amount__c !=ps.rate_Amount__c ||  oldMap.get(ps.id).User_Input_Rate_Amount__c  !=ps.User_Input_Rate_Amount__c ||
                oldMap.get(ps.id).Service_Type_Complexity__c != ps.Service_Type_Complexity__c) && (ps.Has_Been_Kicked_Off__c == true)  //creating confirmation records when chanes happended above fields confirm
               
              )  
                if(thispsMap.containsKey(ps.id)) {
                    project_services__c thisps = thispsMap.get(ps.id);
                    if(thisps.Confirmation__r.isEmpty()) {
                    confirmation__c cnew = new confirmation__c(
                        project_services__c= ps.id,
                        confirmed_service__c = thisps.Service__r.Service_rate_type__c,
                        confirmed_vendor__c = thisps.Vendor__r.name,
                        Confirmed_Base_Amount__c = thisps.Base_Amount__c,
                        Confirmed_Base_Amount_With_Currency__c = thisps.Base_Amount_with_Currency__c,
                        confirmed_rush_fee__c = thisps.Rush_Fee__c,
                        Confirmed_Amount__c = thisps.Amount__c,//Rate_Currency__c
                        Confirmed_Amount_with_Currency__c  = thisps.Rate_Amount_with_Currency__c,
                        Confirmed_Rate_Amount__c = thisps.Rate_Amount__c,
                        Confirmed_Rate_Currency__c = thisps.Rate_Currency__c,
                        Confirmed_MBO_Fee__c = thisps.MBO_Fee__c,
                        Confirmed_MBO_Fee_with_Currency__c = thisps.MBO_Fee_with_Currency__c,
                        Confirmed_Total_Rate_Amount_with_Currenc__c = thisps.Total_Rate_Amount_with_Currency__c ,
                        Confirmed_Total_Rate_Amount__c = thisps.Total_Rate_Amount__c,
                        open_confirmation__c = '',
                        Confirmed_Word_Count__c = getPredevValue(thisps)//ps.Word_Count_Confirming__c
                    );
                    
                    conList.add(cnew);
                    }                    
                }
            
        }          
        insert conList;   
        
    }
    
    
    /*
    // creating confirmation records when status is change to scheduled to confirm
    public static void createConfirmation(Map<Id,Project_Services__c> newMap,Map<Id,Project_Services__c> oldMap) {
        rate_Confirmations();
        Map<String,project_services__c> thispsMap = new Map<String,project_services__c>([SELECT id,Service__c,Vendor__c,rate_Amount__c,Amount__c ,Service_Type_Complexity__c,status__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,Word_Count_Completed__c, Base_Amount__c,
                                                                                         Base_Amount_with_Currency__c,Rate_Currency__c,MBO_Fee__c,Rush_Fee__c,Total_Rate_Amount__c,
                                                                                         Service__r.Service_rate_type__c,Vendor__r.name,MBO_Fee_with_Currency__c,(select id from Confirmation__r where status__c = 'Open'),
                                                                                         Word_Count_Cancelled__c ,Honor_Dependencies__c,Additional_Rate_Input__c,Custom_Quote_Amount__c
                                                                                         FROM project_services__c WHERE id=: newMap.keySet()]);
        List<Confirmation__c> conList = new List<Confirmation__c>();
        for(Project_Services__c ps: newMap.values()) {
            if(
               ((ps.Status__c != oldMap.get(ps.id).Status__c && 
                 ps.Status__c == 'Confirming' && oldMap.get(ps.id).Status__c == 'Scheduled') && 
                 ps.Has_Been_Kicked_Off__c == false )
                  // creating confirmation records when status is change to scheduled to confirm
               
               || 
               
               ((oldMap.get(ps.id).Vendor__c !=ps.Vendor__c || oldMap.get(ps.id).Service__c !=ps.Service__c ||
                oldMap.get(ps.id).Rush_Fee__c !=ps.Rush_Fee__c || oldMap.get(ps.id).Additional_Rate_Input__c !=ps.Additional_Rate_Input__c ||
                oldMap.get(ps.id).Custom_Quote_Amount__c !=ps.Custom_Quote_Amount__c || 
                oldMap.get(ps.id).rate_Amount__c !=ps.rate_Amount__c ||  oldMap.get(ps.id).User_Input_Rate_Amount__c  !=ps.User_Input_Rate_Amount__c ||
                oldMap.get(ps.id).Service_Type_Complexity__c != ps.Service_Type_Complexity__c)
                && ps.Has_Been_Kicked_Off__c == true)  
                //creating confirmation records when chanes happended above fields confirm
               
              )  
                
                if(thispsMap.containsKey(ps.id)) {
                    project_services__c thisps = thispsMap.get(ps.id);
                    
                    if(thisps.Confirmation__r.isEmpty()) {
                        confirmation__c cnew = new confirmation__c(
                            project_services__c= ps.id,
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
                        conList.add(cnew);
                    }
                    
                }
            
        }          
        insert conList;   
        
    }
    */
  
    
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
    
  
    // update title published check false when ps update as confirmed
   @future public static void updatetitlePublishedCheck(set<Id> pids) {
        List<title__c> utLst = new List<title__c>();
      
        for(title__c t: [SELECT Id,ApubOps_Previously_Published__c FROM title__c WHERE id IN (SELECT title__c FROM project__c WHERE id=:pids) AND ApubOps_Previously_Published__c = true]) {
            t.ApubOps_Previously_Published__c = false;
            utLst.add(t);
        }
        update utLst;    
        
    }
    
    // record sharing for community vendor users
    public static void sharePSRecords(Map<Id,Project_Services__c> newMap,Map<Id,Project_Services__c> oldMap) { 
        Set<Id> userIds = new Set<id>();// vendor user ids
        Set<Id> pIds = new Set<id>();// project ids
        Set<Id> titlepIds = new Set<id>();// project ids for udpate published check box field
        // List<Id> vendorIds = new List<id>();// vendor user ids
        Set<String> newPsShareVendorIds = new Set<String>();
        Set<String> removePsShareVendorIds = new Set<String>();
        Set<String> newCBShareVendorIds = new Set<String>();
        Set<String> removeCBShareVendorIds = new Set<String>();
         Set<String> removeESPShareVendorIds = new Set<String>();
        Set<String> serviceIds = new Set<String>();
        for(Project_Services__c ps: newMap.values()) {
            serviceIds.add(ps.service__c);
            pIds.add(ps.project__c);
            
        }  
        
        Map<String,Service__c> servicesMap = new Map<String,Service__c>([SELECT id,Name,Service_Grouping__c FROM Service__c WHERE id=:serviceIds]);
        
        if(trigger.isupdate) {
            for(Project_Services__c ps: newMap.values()) {
                if(oldMap.get(ps.id).Vendor__c !=ps.Vendor__c)
                    if(ps.vendor__c!=null && ps.Status__c == 'Confirming')
                    newPsShareVendorIds.add(ps.vendor__c);
                if(oldMap.get(ps.id).Status__c != ps.Status__c) {        
                    if((ps.status__c != 'Cancelled' && ps.status__c != 'Killed')) {
                        if(oldMap.get(ps.id).Status__c == 'In Planning' && ps.Status__c == 'Confirming') {
                            newPsShareVendorIds.add(ps.vendor__c);
                            titlepIds.add(ps.project__c);
                        }    
                      
                    }else {
                        removePsShareVendorIds.add(ps.vendor__c);
                        if(String.isNotBlank(ps.Service__c)) { // remove esp records share
                            Set<String> espServices = new Set<String>();
                            if(Label.CommunityESPServices.contains(','))
                                espServices.addAll(Label.CommunityESPServices.split(','));
                            else
                                espServices.add(Label.CommunityESPServices);    
                            if(espServices.contains(servicesMap.get(ps.Service__c).Name))
                                removeESPShareVendorIds.add(ps.vendor__c);
                            
                        }
                        
                    }
                } 
                if(ps.Service__c!=null && !servicesMap.isEmpty()) { // share only cb records
                    if((oldMap.get(ps.id).Status__c !=ps.Status__c || oldMap.get(ps.id).Service__c !=ps.Service__c) && 
                       servicesMap.containsKey(ps.service__c) && String.isNotBlank(servicesMap.get(ps.service__c).Service_Grouping__c)) {
                           
                           if((ps.status__c != 'Cancelled' && ps.status__c != 'Killed') && 
                              (servicesMap.get(ps.service__c).Service_Grouping__c.containsIgnoreCase('Design') || 
                               servicesMap.get(ps.service__c).Service_Grouping__c.containsIgnoreCase('Promotional'))) {
                                   if(oldMap.get(ps.id).Status__c == 'In Planning' && ps.Status__c == 'Confirming')
                                       newCBShareVendorIds.add(ps.vendor__c);
                               } else
                                   removeCBShareVendorIds.add(ps.vendor__c); 
                       } else
                           removeCBShareVendorIds.add(ps.vendor__c);        
                } else
                    removeCBShareVendorIds.add(ps.vendor__c); 
                
                pIds.add(ps.project__c);             
            }
            if(!system.isBatch())
                updatetitlePublishedCheck(titlepIds);
        }
        
        if(trigger.isInsert) {
            
            for(Project_Services__c ps: newMap.values()) {
                if(ps.vendor__c!=null) 
                    if(ps.Status__c == 'Confirming')
                    newPsShareVendorIds.add(ps.vendor__c);
                if(ps.service__c!=null && !servicesMap.isEmpty()) { // only cb share logic
                    if(servicesMap.containsKey(ps.service__c) && servicesMap.get(ps.service__c).Service_Grouping__c != null) {
                        if((ps.status__c != 'Cancelled' && ps.status__c != 'Killed') && 
                           (servicesMap.get(ps.service__c).Service_Grouping__c.containsIgnoreCase('Design') || 
                            servicesMap.get(ps.service__c).Service_Grouping__c.containsIgnoreCase('Promotional'))) {
                                if(ps.Status__c == 'Confirming')
                                    newCBShareVendorIds.add(ps.vendor__c);
                            } else
                                removeCBShareVendorIds.add(ps.vendor__c); 
                    } else
                        removeCBShareVendorIds.add(ps.vendor__c);        
                }
            }    
            
        }
        // execute enqueue job for give access for all the ps related records
        if(!newPsShareVendorIds.isEmpty()) { 
            for(User u: [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: newPsShareVendorIds AND isActive = true]) 
                System.enqueueJob(new ProjectServiceTriggerHandler(u, newMap.keyset()));
            
        }  
        
        // execute enqueue job for give access for cd records for related ps
        if(!newCBShareVendorIds.isEmpty()) { 
            for(User u: [SELECT  id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: newPsShareVendorIds AND isActive = true]) 
                System.enqueueJob(new ProjectServiceTriggerHandler(u, newMap.keyset(),newCBShareVendorIds,pIds));
            
        }  
        // remove ps related sharing
        if(!removePsShareVendorIds.isEmpty()) {
            
            Set<String> titlesId = new Set<String>();
            Set<String> seriesId = new Set<String>();
            Set<String> psIds = new Set<String>();
            // check all ps reocrds status should be canelled or kill
            for(project_services__c ps: [select id,status__c from project_services__c where project__c =: pIds and 
                                            status__C != 'Cancelled' and status__c !='Killed']) {
                psIds.add(ps.id);
                system.debug(ps.status__C); 
            }
            //get title ids for delete
            for(project_services__c ps: [select id,project__r.title__c,project__r.series__c from project_services__c where id=:newMap.keyset() and project__c =: pids]) {
                titlesId.add(ps.project__r.title__c);
                seriesId.add(ps.project__r.series__c);
            }
            
            List<Project__Share> psShrList = new List<Project__Share>();
            List<title__Share> tShrList = new List<title__Share>();
            List<Series__Share> sShrList = new List<Series__Share>();
            if(psIds.isEmpty()) {
                psShrList = [SELECT id FROM Project__Share WHERE parentid in (SELECT id FROM Project__c WHERE title__c=:titlesId) AND UserOrGroupId IN 
                             (SELECT  id FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: removePsShareVendorIds AND isActive = true)];   
                delete psShrList; 
                 tShrList = [SELECT id FROM title__Share WHERE parentid =: titlesId AND UserOrGroupId IN 
                             (SELECT  id FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: removePsShareVendorIds AND isActive = true)];   
                delete tShrList;
                  sShrList = [SELECT id FROM Series__Share WHERE parentid =: seriesId AND UserOrGroupId IN 
                             (SELECT  id FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: removePsShareVendorIds AND isActive = true)];   
                delete sShrList; 
            }  
            
        } 
        // remove cb related sharing
        if(!removeCBShareVendorIds.isEmpty()) {
            
            Set<String> titlesId = new Set<String>();
            Set<String> psIds1 = new Set<String>();
            // check all ps reocrds status should be canelled or kill if any one of ps have status confirmed dont delete cb sharing record
            for(project_services__c ps: [select id,status__c,service__r.Service_Grouping__c from project_services__c where project__c =: pIds
                                           ]) {
                if(String.isNotBlank(ps.Service__r.Service_Grouping__c))                           
                    if((ps.status__c != 'Cancelled' && ps.status__c != 'Killed') && (ps.Service__r.Service_Grouping__c.containsIgnoreCase('Design') || ps.Service__r.Service_Grouping__c.containsIgnoreCase('Promotional')))
                        psIds1.add(ps.id);
                
            }
            //get title ids for delete
            for(project_services__c ps: [select id,project__r.title__c from project_services__c where id=:newMap.keyset() and project__c =: pids]) 
                titlesId.add(ps.project__r.title__c);
            Set<String> cbIds = new Set<String>();
            // Set<String> userIds = new Set<String>();
            List<Creative_Brief__Share> cbShrList = new List<Creative_Brief__Share>();
            if(psIds1.isEmpty()) {
                cbShrList = [SELECT id FROM Creative_Brief__Share WHERE parentid in (SELECT id FROM Creative_Brief__c WHERE title__c=:titlesId) AND 
                             UserOrGroupId IN (SELECT  id FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: removeCBShareVendorIds AND isActive = true)];   
                delete cbShrList; 
            }
        }  
        
         // remove ESP related sharing
        if(!removeESPShareVendorIds.isEmpty()) {
            
            Set<String> titlesId = new Set<String>();
           
            //get title ids for delete
            for(project_services__c ps: [select id,project__r.title__c from project_services__c where id=:newMap.keyset() and project__c =: pids]) 
                titlesId.add(ps.project__r.title__c);
            Set<String> cbIds = new Set<String>();

            List<esp__Share> espShrList = new List<esp__Share>();
           
                espShrList = [SELECT id FROM ESP__Share WHERE parentid in (SELECT id FROM ESP__c WHERE title__c=:titlesId) AND 
                             UserOrGroupId IN (SELECT  id FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: removeESPShareVendorIds AND isActive = true)];   
                delete espShrList; 
           
        }  
        
        
        
    }
    public ProjectServiceTriggerHandler() {}
    private User uId;
    private set<Id> psIds;
    private set<Id> pIds;
    private Set<String> newCBShareVendorIds = new Set<String>();
    private Set<String> removeCBShareVendorIds = new Set<String>();
    private Set<Id> titlepIds = new Set<id>();// project ids for udpate published check box field
    public ProjectServiceTriggerHandler(User uId , set<Id> psIds) {
        this.uId = uId;
        this.psIds = psIds;
        
    } 
    
    public ProjectServiceTriggerHandler(User uId , set<Id> psIds, Set<String> newCBShareVendorIds,set<Id> pIds) {
        this.uId = uId;
        this.psIds = psIds;
        this.pIds = pIds;
        this.newCBShareVendorIds = newCBShareVendorIds;
        // this.removeCBShareVendorIds = removeCBShareVendorIds;
        
    } 
    
    // quable enqueue method
    public void execute(QueueableContext context) {
        
        sharingRecalc(psIds, uId);
        if(!newCBShareVendorIds.isEmpty() || !removeCBShareVendorIds.isEmpty())
            shareAdditionalTitles(uId.Id,newCBShareVendorIds,psIds,pIds);
        // createVedorCommunityUser(cons);
    }
    
    
    // additional titles,asin,title contact share for while giving cb share
    //@future
    public static void shareAdditionalTitles(id uid,Set<String> newCBShareVendorIds,
                                             set<Id> psids,   set<Id> pIds) {
                                                 Set<String> titlesId = new Set<String>();
                                                 // List<User> uList =  new List<User>();
                                                 if(!newCBShareVendorIds.isEmpty()) {
                                                     //  uList = [SELECT id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: newCBShareVendorIds AND
                                                     //               isActive = true]; 
                                                     
                                                     
                                                     List<SObject> CBShare = new List<Sobject>();
                                                     Set<String> cbIds = new Set<String>();
                                                     for(project_services__c ps: [select id,project__r.title__c from project_services__c where id=:psids])
                                                         titlesId.add(ps.project__r.title__c);
                                                     //  ServiceTriggerHandler.shareCBRecords(newCBShareVendorIds,titlesId);  // re use code for service trigger
                                                     // shareAdditionalTitles(titlesId ,u.id); // create share record for additional title related asins and title contact
                                                     List<Creative_Brief__c> cbList = [SELECT id FROM Creative_Brief__c WHERE title__c=:titlesId];          
                                                     
                                                     // for(User u: [SELECT id,Contact.Vendor__c FROM USER WHERE ContactId!=null AND Contact.Vendor__c!=null AND Contact.Vendor__c =: newCBShareVendorIds AND
                                                     //   isActive = true])
                                                     for(Creative_Brief__c e: cbList)           
                                                         CBShare.add(UserTriggerHandler.shareRecords(uid,e.id, 'Read','Creative_Brief__Share'));
                                                     system.debug(CBShare);
                                                     insert CBShare;  
                                                     
                                                     
                                                 }
                                                 
                                                 List<SObject> tcShare = new List<Sobject>();
                                                 List<SObject> asinShare = new List<Sobject>();
                                                 set<String> tseries = new set<String>();
                                                 List<String> legalNameContacts = new List<String>();
                                                 for(title__c t: [SELECT id,Series__c FROM title__c WHERE id=:titlesId])
                                                     legalNameContacts.add(t.Series__c);
                                                 for(Title_Contact__c tc1: [SELECT id,Legal_Name__c  FROM Title_Contact__c 
                                                                            WHERE Role__c='Author' AND Title__c=: titlesId]) 
                                                     legalNameContacts.add(tc1.Legal_Name__c);
                                                 
                                                 List<Title_Contact__c> tc = [SELECT id ,title__c
                                                                              FROM Title_Contact__c 
                                                                              WHERE Legal_Name__c=: legalNameContacts AND Title_Status__c IN ('In Production', 'Contracted') AND Title_Series__c = :legalNameContacts AND Title__c != :titlesId AND Name = 'Digital'
                                                                             ];
                                                 List<String> tIds = new List<String>();           
                                                 // for(User uid: uList)            
                                                 for(Title_Contact__c c : tc) {          
                                                     tcShare.add(UserTriggerHandler.shareRecords(uid,c.id, 'Read','Title_Contact__share')); 
                                                     tIds.add(c.title__c);
                                                 }              
                                                 insert tcShare;
                                                 List<ASIN__c> aList = [SELECT id 
                                                                        FROM ASIN__c 
                                                                        WHERE Title__c=: 
                                                                        tIds];
                                                 // for(User uid: uList)
                                                 for(ASIN__c a : aList)           
                                                     asinShare.add(UserTriggerHandler.shareRecords(uid,a.id, 'Read','ASIN__share'));           
                                                 insert asinShare;
                                                 
                                             }
    
    
    public static void sharingRecalc(set<Id> psIds, User usr) {
        
        Map<String,set<String>> UsersVendorMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoPsMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoProjectMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoTitleMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoSeriesMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoTitleContactMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoAsinMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoConfirmationMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoMarketPlaceMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoSerivcePrepMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoSerivcePrepResMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoSerivcePrepQueMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoRateMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoServiceMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoCreativeBriefMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoTitleContactsMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoAuthorQuesMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoBookQuesMap = new Map<String,Set<String>>();
        // Map<String,Set<String>> vendortoESPMap = new Map<String,Set<String>>();
        Map<String,Set<String>> vendortoEspMap = new Map<String,Set<String>>();
        List<String> vendorProfiles = Label.Community_Vendor_Profile.split(',');
        
        List<String> profileIds = new List<String>();
        set<String> vendorIds = new set<String>();
        set<String> titleIds = new set<String>();
        set<String> projectIds = new set<String>();
        
        // for(User u: [SELECT  Contact.Vendor__c FROM USER WHERE id=:newMap AND profileId =: profileIds AND ContactId!=null AND Contact.Vendor__c!=null AND isActive = true]) {
        vendorIds.add(usr.Contact.Vendor__c);   
        UsersVendorMap.put(usr.id, new Set<String>{usr.Contact.Vendor__c});    
        
        if(!vendorIds.isEmpty()) {
            
            Set<String> cbTitleIds = new Set<String>();
            Set<String> espTitleIds = new Set<String>();
            Map<String,List<Project_Services__c>> titleToPSs = new Map<String,List<Project_Services__c>>();
            // project related records sharing
            for(Project_Services__c ps : [SELECT Id,(SELECT id FROM Confirmation__r),Rate__c,Service__c,status__c,Service__r.Name,
                                          Service__r.Service_Grouping__c,Vendor__c,Project__c,Project__r.Title__c,Project__r.Series__c  FROM Project_Services__c WHERE Vendor__c=:vendorIds AND id=: psIds]) {
                                              UserTriggerHandler.frameKeyValuesMap(ps.Vendor__c,ps.id,vendortoPsMap);
                                              UserTriggerHandler.frameKeyValuesMap(ps.Vendor__c,ps.Rate__c,vendortoRateMap);
                                              UserTriggerHandler.frameKeyValuesMap(ps.Vendor__c,ps.Service__c,vendortoServiceMap);
                                              UserTriggerHandler.frameKeyValuesMap(ps.Vendor__c,ps.Project__c,vendortoProjectMap);
                                              UserTriggerHandler.frameKeyValuesMap(ps.Vendor__c,ps.Project__r.Title__c,vendortoTitleMap);
                                              UserTriggerHandler.frameKeyValuesMap(ps.Vendor__c,ps.Project__r.Series__c,vendortoSeriesMap);
                                              for(Confirmation__c c: ps.Confirmation__r)
                                                  UserTriggerHandler.frameKeyValuesMap(ps.Vendor__c,c.id,vendortoConfirmationMap);    
                                              titleIds.add(ps.Project__r.Title__c);
                                              
                                              if(ps.Service__r.Service_Grouping__c != null) {
                                                  if(ps.Service__r.Service_Grouping__c.containsIgnoreCase('Design') || ps.Service__r.Service_Grouping__c.containsIgnoreCase('Promotional') && (ps.status__c != 'Cancelled' && ps.status__c != 'Killed'))
                                                      cbTitleIds.add(ps.Project__r.Title__c);
                                                  
                                              }
                                              if(String.isNotBlank(ps.Service__c)) {
                                                  Set<String> espServices = new Set<String>();
                                                  if(Label.CommunityESPServices.contains(','))
                                                      espServices.addAll(Label.CommunityESPServices.split(','));
                                                  else
                                                      espServices.add(Label.CommunityESPServices);    
                                                  if(espServices.contains(ps.Service__r.Name))
                                                      espTitleIds.add(ps.Project__r.Title__c);
                                                  
                                              }
                                              
                                              projectIds.add(ps.Project__c);      
                                          }
            
            // share ESP records
            for(esp__c e: [SELECT id,Vendor__c FROM esp__c WHERE Vendor__c =:vendorIds AND title__c =: espTitleIds AND Vendor__r.Chinook_Access__c=true]) {
                if(vendortoEspMap.containsKey(e.Vendor__c))
                    vendortoEspMap.get(e.Vendor__c).add(e.id);
                else
                    vendortoEspMap.put(e.Vendor__c, new Set<String>{e.id});    
            }
            
            
            
            
            // title related records sharing
            for(Title__c t : [SELECT Id,(SELECT id FROM ASINs__r), (SELECT id FROM Creative_Briefs__r),(SELECT id FROM Title_Contacts__r)   FROM Title__c WHERE id=:titleIds]) {
                for(String v : vendortoTitleMap.keyset()) {
                    if(vendortoTitleMap.get(v).contains(t.id)) {
                        for(ASIN__c a: t.ASINs__r) // Asin records share
                            UserTriggerHandler.frameKeyValuesMap(v,a.id,vendortoAsinMap); 
                        for(Title_Contact__c tc: t.Title_Contacts__r) // Title contact records share
                            UserTriggerHandler.frameKeyValuesMap(v,tc.id,vendortoTitleContactMap); 
                    }    
                    
                    
                }
                
            }
            // share project,service prep,service prep response,service prep questions
            for(Service_Prep_Response__c spr : [SELECT Id,Service_Prep__c,Service_Prep__r.Project__c,Service_Prep_Question__c  FROM Service_Prep_Response__c WHERE Service_Prep__r.Project__c =:projectIds AND Service_Prep__r.Project__c!=NULL AND Service_Prep_Question__c!=NULL]) {
                for(String v : vendortoTitleMap.keyset()) 
                    if(vendortoProjectMap.get(v).contains(spr.Service_Prep__r.Project__c)) {
                        UserTriggerHandler.frameKeyValuesMap(v,spr.id,vendortoSerivcePrepResMap); 
                        UserTriggerHandler.frameKeyValuesMap(v,spr.Service_Prep__c,vendortoSerivcePrepMap); 
                        UserTriggerHandler.frameKeyValuesMap(v,spr.Service_Prep_Question__c,vendortoSerivcePrepQueMap); 
                    }           
                
            }
            
            
            List<Sobject> createShareList = new List<Sobject>();
            List<Sobject> createShareList1 = new List<Sobject>();
            List<Sobject> createShareList2 = new List<Sobject>();
            List<Sobject> createShareList3 = new List<Sobject>(); 
            List<Sobject> createShareList4 = new List<Sobject>();    
            List<Sobject> createShareList5 = new List<Sobject>();     
            List<Sobject> createShareList6 = new List<Sobject>();    
            List<Sobject> createShareList7 = new List<Sobject>();    
            List<Sobject> createShareList8 = new List<Sobject>();    
            List<Sobject> createShareList9 = new List<Sobject>();    
            List<Sobject> createShareList10 = new List<Sobject>();                
            List<Sobject> createShareList11 = new List<Sobject>();
            
            if(!UsersVendorMap.isEmpty()) {
                
                // vendor share
                for(String u: UsersVendorMap.keyset())
                    for(String vendor : UsersVendorMap.get(u)) {
                        createShareList.add(UserTriggerHandler.shareRecords(u,vendor,'Read','Vendor__Share'));
                        UserTriggerHandler.getAllCreateShareRecords(vendortoProjectMap,u,vendor,'Project__Share','Edit',createShareList);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoTitleMap,u,vendor,'Title__Share','Read',createShareList1);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoSeriesMap,u,vendor,'Series__Share','Read',createShareList1);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoTitleContactMap,u,vendor,'Title_Contact__Share','Read',createShareList2);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoAsinMap,u,vendor,'Asin__Share','Read',createShareList3);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoConfirmationMap,u,vendor,'Confirmation__Share','Edit',createShareList4);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoSerivcePrepMap,u,vendor,'Service_Prep__Share','Read',createShareList5);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoSerivcePrepQueMap,u,vendor,'Service_Prep_Question__Share','Read',createShareList6);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoSerivcePrepResMap,u,vendor,'Service_Prep_Response__Share','Read',createShareList7);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoRateMap,u,vendor,'Rate__Share','Read',createShareList8);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoServiceMap,u,vendor,'Service__Share','Read',createShareList9);
                        // UserTriggerHandler.getAllCreateShareRecords(vendortoCreativeBriefMap,u,vendor,'Creative_Brief__Share','Read',createShareList2);
                        UserTriggerHandler.getAllCreateShareRecords(vendortoEspMap,u,vendor,'ESP__Share','Edit',createShareList10);
                        
                        
                        
                    }
                system.debug(createShareList);
                system.debug(createShareList1);
                database.insert(createShareList,true);
                database.insert(createShareList1,true);
                database.insert(createShareList2,true);
                database.insert(createShareList3,  true);
                database.insert(createShareList4,  true);
                database.insert(createShareList5,  true);
                database.insert(createShareList6,  true);
                database.insert(createShareList7,  true);
                database.insert(createShareList8,  true);
                database.insert(createShareList9,  true);
                database.insert(createShareList10,  true);
                database.insert(createShareList11,  true);
                // Insert createShareList;  // share vendor records
                // Insert createShareList1;  // share vendor records
            }  
        }
    }
    
  
}