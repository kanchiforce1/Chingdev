/***********************************
Author:      Amazon Apub // kkolla@
Used By:     Service Prep Form
Description: Batch class to send out Emails to A.E which contains the information about the unfilled questions in the service prep form with respective to title.
             Contains 30 day PXM notification logic as well
***********************************/

global class PPW_NotificationWindowBatch implements Database.Batchable<sObject>
{
    
    List<String> projectIds = new List<String>();
    Map<String,OrgWideEmailAddress> orgEmailAddresss = new Map<String,OrgWideEmailAddress>();
    Map<String,map<String,Date>> projectPSs_Schedule = new  Map<String,map<String,Date>>();// here it can store earliest Est. Dates for Question with notification window Scheduled
    Map<String,map<String,Date>> projectPSs_Start = new  Map<String,map<String,Date>>();// here it can store earliest Est. Dates for Question with notification window Start
    Map<String,String> Acquiring_EditorEmailIds = new Map<String,String>();
    map<String,List<Service_Prep_Question__c>> SubQusMap  = new map<String,List<Service_Prep_Question__c>>();
    map<String,Service_Prep_Question__c> getQusMap  = new map<String,Service_Prep_Question__c>();
    map<String,Service_Prep_Question__c> MainQusMap  = new map<String,Service_Prep_Question__c>();
    
    /** constructor method, executes with respective to project **/
    public PPW_NotificationWindowBatch(List<String> pIds) {
        projectIds = pIds;
        
        notificationWindowEstDate();
        PXMnotificationWindow();
    }
    
    public PPW_NotificationWindowBatch() {
        notificationWindowEstDate();
    }
    
    /** Start method, get's all the project records **/ 
    global Database.QueryLocator start(Database.BatchableContext bc)
    {   
         for(OrgWideEmailAddress orgA: [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress LIMIT 10000])
            orgEmailAddresss.put(orgA.Address,orgA);
        
        if(!projectIds.isempty()) 
            return Database.getQueryLocator(
                'SELECT ID, Name,Title__r.Acquiring_Editor__c,Title__r.Production_Manager__c,Title__r.Name, Title__r.Marty_Title_ID__c,Title__r.Internal_Imprint__c, (select id from Service_Preps__r LIMIT 1) FROM Project__c where  (Title__r.Acquiring_Editor__c!=null or Title__r.Production_Manager__c != null) and id=:projectIds' );
        else
            return Database.getQueryLocator(
                'SELECT ID,Name,Title__r.Acquiring_Editor__c,Title__r.Production_Manager__c,Title__r.Name, Title__r.Marty_Title_ID__c,Title__r.Internal_Imprint__c, (select id from Service_Preps__r LIMIT 1) FROM Project__c where  (Title__r.Acquiring_Editor__c!=null or Title__r.Production_Manager__c != null)' );
        
    }
    
    /** Execute method **/ 
    global void execute(Database.BatchableContext bc, List<Project__c> proList)  
    {
        System.debug(projectPSs_Schedule);
        System.debug(projectPSs_Start);
        System.debug(proList);
        set<String> scheduledSIds = new set<String>();
        set<String> startSIds = new set<String>();
        List<String> sePrepIds = new List<String>();
       // Map<String,OrgWideEmailAddress> orgEmailAddresss = new Map<String,OrgWideEmailAddress>();
        //for(OrgWideEmailAddress orgA: [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress LIMIT 10000])
          //  orgEmailAddresss.put(orgA.Address,orgA);
        
        Set<String> proIds = new set<String>();
        if(!projectPSs_Schedule.isEmpty())
            proIds.addAll(projectPSs_Schedule.keyset());
        if(!projectPSs_Start.isEmpty())
            proIds.addAll(projectPSs_Start.keyset());
        for(Project__c p: [Select id,Name, (select id from Service_Preps__r LIMIT 1) FROM Project__c where id=: proIds])
            if(p.Service_Preps__r!=null)
            for(Service_Prep__c sp: p.Service_Preps__r)
            sePrepIds.add(sp.Id);
        getSubQuestions(sePrepIds);
        
        
        
        if(!projectPSs_Schedule.isEmpty())
            scheduledSIds.addAll(projectPSs_Schedule.keyset());
        if(!projectPSs_Start.isEmpty())
            startSIds.addAll(projectPSs_Start.keyset());   
        
        
        
        //System.debug
        
        Messaging.SingleEmailMessage[] Messages =   new List<Messaging.SingleEmailMessage>();
        Messaging.SendEmailResult[] results;// = new Messaging.SendEmailResult();//Messaging.sendEmail(messages);
        Map<String,String> scheduledSPrep = new Map<String,String>(); // send mail require Check
        Map<String,String> startSPrep = new Map<String,String>(); // send mail require Check
        Map<String,Set<String>> sePrepFormServices = new Map<String,Set<String>>();
        set<String> sPrepIds = new set<String>();
        for(Project__c p: proList) 
            if(!p.Service_Preps__r.isEmpty() && !String.isBlank(p.Title__r.Acquiring_Editor__c) && scheduledSIds.contains(p.id) || startSIds.contains(p.id)) 
            for(Service_Prep__c sp : p.Service_Preps__r) {
                sPrepIds.add(sp.Id);
                if(projectPSs_Schedule.containsKey(p.Id)) 
                    sePrepFormServices.put(sp.Id,projectPSs_Schedule.get(p.Id).keyset());
                if(projectPSs_Start.containsKey(p.Id)) 
                    sePrepFormServices.put(sp.Id,projectPSs_Start.get(p.Id).keyset());
            }
        System.debug(sPrepIds);
        
        /** Scheduled Messages reqired check */
        scheduledSPrep = notificationWindowController(sPrepIds,'Schedule',sePrepFormServices);
        startSPrep = notificationWindowController(sPrepIds,'Start' , sePrepFormServices);
        
        System.debug(scheduledSPrep);
        System.debug(startSPrep);
        System.debug(Acquiring_EditorEmailIds);
        
        /** Scheduled Messages  **/
        for(Project__c p: proList)
            if(scheduledSIds.contains(p.id)) 
            if(!p.Service_Preps__r.isEmpty()) 
            for(Service_Prep__c sp : p.Service_Preps__r) {
                System.debug(sp);
                System.debug(p.Title__r.Acquiring_Editor__c);
                if(!String.isBlank(p.Title__r.Acquiring_Editor__c)) 
                    if(!String.isBlank(scheduledSPrep.get(sp.id)) && !String.isBlank(Acquiring_EditorEmailIds.get(p.Title__r.Acquiring_Editor__c.trim()))) {
                        messages.add(sendEmailToNotifier( sp.id,Acquiring_EditorEmailIds.get(p.Title__r.Acquiring_Editor__c),scheduledSPrep.get(sp.id),Label.PPW_spNFWSchedSub+'('+p.Title__r.Name+')'));  
                        System.debug(messages); 
                        
                    }
            }  
        
        /** Scheduled Messages **/
        for(Project__c p: proList) 
            if(startSIds.contains(p.id))
            if(!p.Service_Preps__r.isEmpty()) 
            for(Service_Prep__c sp : p.Service_Preps__r) {
                System.debug(sp);
                System.debug(p.Title__r.Acquiring_Editor__c);
                if(!String.isBlank(p.Title__r.Acquiring_Editor__c)) {
                    System.debug(startSPrep.get(sp.id));
                    System.debug(Acquiring_EditorEmailIds.get(p.Title__r.Acquiring_Editor__c.trim()));
                    if(!String.isBlank(startSPrep.get(sp.id)) && !String.isBlank(Acquiring_EditorEmailIds.get(p.Title__r.Acquiring_Editor__c.trim()))) {
                        messages.add(sendEmailToNotifier( sp.id,Acquiring_EditorEmailIds.get(p.Title__r.Acquiring_Editor__c),startSPrep.get(sp.id),Label.PPW_spNFWStartSub+'('+p.Title__r.Name+')'));  
                        System.debug(messages);
                        
                    }
                }
            }
        
        /** PXM notification widnow **/
        List<Project__c> updatePro = new List<Project__c>();
        String spForm;
        System.debug(pxmNofitication);
        System.debug(pxmNofitication);
        for(Project__c p: proList)  {
            if(pxmNofitication.contains(p.Id)){
                for(Service_Prep__c sp : p.Service_Preps__r) { 
                    spForm = sp.id;
                    break;}
                String eBody='';
                eBody+='Service review remainder for'+'<br/>' +'<br/>'+ 'Title Name : '+ p.Title__r.Name +'<br/>' + 'Title Id : '+ p.Title__r.Marty_Title_ID__c + '<br/>' + 'Project Name : '+ p.Name + '<br/>'+'Acquiring Editor : ' + p.Title__r.Acquiring_Editor__c +'<br/>'+'Internal Imprint : '+p.Title__r.Internal_Imprint__c+'<br/>'+'<br/>';
                //eBody+= 'Here is the link to the Service Prep Form<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+ '/apex/PPW_servicePrepForm?id=' +spForm.id+'"> Service Prep Form </a> <br/>';
                eBody += 'Here is the Link to the Project <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+p.id+'">'+'<br/>'+ p.Name + '</a>';
                messages.add(sendEmailToNotifier( null,Acquiring_EditorEmailIds.get(p.Title__r.Production_Manager__c), eBody ,'Service Review Reminder: ' + p.Title__r.Name + '/'+p.Title__r.Marty_title_ID__c));
                p.X30_Days_Pxm_Notification__c = true;
                updatePro.add(p);
            }
            System.debug(p.id);
            
        }
        Update updatePro; 
        
        System.debug(messages);
        if(!messages.isEmpty())
            results = Messaging.sendEmail(messages);  
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
    }
    Set<String> pxmNofitication = new Set<String>();
    /** get project service records using query **/
    public void PXMnotificationWindow() {
        Date lastMonthday = Date.Today().addDays(-30);
        for(Project_Services__c ps: [Select id,Project__c,Estimated_Start_Date__c,Service__r.name from Project_Services__c where Estimated_Start_Date__c <=: lastMonthday and project__r.X30_Days_Pxm_Notification__c = false]) {
            pxmNofitication.add(ps.Project__c);
            
        }
    }
    
    /** get estimated date calculation for notificatino window */ 
    public void notificationWindowEstDate() {
        for(Project_Services__c ps: [Select id,Project__c,Estimated_Start_Date__c,Service__r.name from Project_Services__c where Estimated_Start_Date__c >= today and Estimated_Start_Date__c <= NEXT_N_DAYS:40]) {
            if(ps.Estimated_Start_Date__c!=null)
                if(projectPSs_Schedule.containsKey(ps.Project__c)) {  
                    if(projectPSs_Schedule.get(ps.Project__c).containskey(ps.Service__r.name)) {}
                    else {
                        projectPSs_Schedule.get(ps.Project__c).put(ps.Service__r.name,ps.Estimated_Start_Date__c);
                    }
                } else {
                    projectPSs_Schedule.put(ps.Project__c,new map<String,Date>{ps.Service__r.name=>ps.Estimated_Start_Date__c});     
                }   
            
        }
        
        for(Project_Services__c ps: [Select id,Project__c,Estimated_Start_Date__c,Service__r.name from Project_Services__c where Estimated_Start_Date__c >= NEXT_N_DAYS:35 and Estimated_Start_Date__c <= NEXT_N_DAYS:40]) {
            if(ps.Estimated_Start_Date__c!=null)
                if(projectPSs_Start.containsKey(ps.Project__c)) {  
                    if(projectPSs_Start.get(ps.Project__c).containskey(ps.Service__r.name)) {}
                    else {
                        projectPSs_Start.get(ps.Project__c).put(ps.Service__r.name,ps.Estimated_Start_Date__c);
                    }
                } else {
                    projectPSs_Start.put(ps.Project__c,new map<String,Date>{ps.Service__r.name=>ps.Estimated_Start_Date__c});     
                }   
            
        } 
        for(User u : [SELECT CommunityNickname, Id, Email FROM User]) 
            Acquiring_EditorEmailIds.put(u.CommunityNickname,u.Email);    
        
    } 
    
    /** send emali notification method **/
    public Messaging.SingleEmailMessage sendEmailToNotifier(String serRepId,String notifierMailId,String emailTempBody,String subject) {
        Messaging.SingleEmailMessage message1 = new Messaging.SingleEmailMessage();
        if(orgEmailAddresss != null) 
            if(orgEmailAddresss.containsKey('kpav321@gmail.com'))
                 message1.OrgWideEmailAddressId = orgEmailAddresss.get('kpav321@gmail.com').id; 
        message1.toAddresses = new String[] { notifierMailId };
        message1.HtmlBody = emailTempBody; 
        message1.subject = subject; 
        
        
        return message1;
        
    }
    
    /** generate email body to send email to PXM and AE managers **/
    public Map<String,String> notificationWindowController(set<String> sPrepId,String nType, Map<String,Set<String>> sePrepFormServices) {
        
        Map<String,Map<String,Map<String,Map<String,List<String>>>>> serPreRespList = new Map<String,Map<String,Map<String,Map<String,List<String>>>>>();
        map<String,List<Service_Prep_Question__c>> serTypeSubQusMap  = new map<String,List<Service_Prep_Question__c>>();
        Map<String,String> proidsMap = new Map<String,String>();
        Map<String,String> serPrepMap = new Map<String,String>();
        List<String> estdateServices = new List<String>();
        for(Set<String> ser: sePrepFormServices.values())
            estdateServices.addAll(ser);
        
        Map<String,Service_Prep_Response__c> serPrepResp = new map<String,Service_Prep_Response__c>([Select id,Name,Response__c,Service_Prep__c,Service_Prep__r.Project__c,Service_Prep_Question__c,Response_Number__c,
                                                                                                     Service_Prep_Question__r.Question_Type__c,Service_Prep_Question__r.Name,Service_Prep_Question__r.Notification_Service__c,
                                                                                                     Service_Prep_Question__r.Question_Category__c,Service_Prep_Question__r.Sub_Category__c,  Service_Prep_Question__r.Sub_Question_Render__c
                                                                                                     
                                                                                                     From Service_Prep_Response__c where (Response__c=null OR Response__c='' OR Response__c LIKE '%None%' OR Response_Number__c=null) AND 
                                                                                                     (Service_Prep__c=:sPrepId AND Service_Prep_Question__r.Notification_Window__c = :nType AND 
                                                                                                      Service_Prep_Question__r.Notification_Service__c =:estdateServices)
                                                                                                     AND ((Service_Prep_Question__r.Question_Category__c = 'Acquisition' AND  Service_Prep__r.Acquistion_Tab_Static__c = false) OR 
                                                                                                          (Service_Prep_Question__r.Question_Category__c = 'Design Scheduling' AND  Service_Prep__r.Design_Scheduling_Tab_Static__c = false) OR 
                                                                                                          (Service_Prep_Question__r.Question_Category__c = 'Editorial Scheduling' AND  Service_Prep__r.Editorial_Tab_static__c = false)) 
                                                                                                     order by Service_Prep__c]);
        System.debug(serPrepResp);
        System.debug(MainQusMap);
        System.debug(SubQusMap);
        
        if(!serPrepResp.isEmpty())
            for(Service_Prep_Response__c spr: serPrepResp.values()) {
                if(MainQusMap.containsKey(spr.Service_Prep_Question__c)) {
                    if(!String.isBlank(spr.Response__c)) {
                        if(spr.Response__c.containsIgnoreCase('None') && (spr.Response_Number__c==null))
                            questionsAppendingEmailBody(spr, serPreRespList);   
                        
                    } else {
                        questionsAppendingEmailBody(spr, serPreRespList);
                    }
                    
                }   if(SubQusMap.containsKey(spr.Service_Prep_Question__c))   // sub question appending into the email body
                    if(!String.isBlank(spr.Service_Prep_Question__r.Sub_Question_Render__c) && !String.isBlank(spr.Response__c)) 
                    if(spr.Service_Prep_Question__r.Sub_Question_Render__c.containsIgnoreCase(spr.Response__c))  
                    for(Service_Prep_Question__c sq : SubQusMap.get(spr.Service_Prep_Question__c)) {
                        System.debug(sq);
                        System.debug(sq.Service_Prep_Responses__r);
                        spr = serPrepResp.get(sq.Service_Prep_Responses__r[0].id);
                        System.debug(spr);
                        if(spr!=null)
                            if(spr.Response__c!=null) {
                                if(spr.Response__c.containsIgnoreCase('None') && (spr.Response_Number__c==null)) 
                                    questionsAppendingEmailBody(spr, serPreRespList);
                            } else questionsAppendingEmailBody(spr, serPreRespList);
                    }     
                
                
                
                if(spr!=null)                     
                    proidsMap.put(spr.Service_Prep__c,spr.Service_Prep__r.Project__c);
            }                     
        
        System.debug(serPreRespList);    
        return generateEmailBody(serPreRespList,proidsMap);
        
    }
    
    /** framing map logic for non response questions **/
    private void questionsAppendingEmailBody(Service_Prep_Response__c spr,Map<String,Map<String,Map<String,Map<String,List<String>>>>> serPreRespList) {
        if(getQuestionNumber(spr)!=null) {  //general questions appeding into the email body
            if(serPreRespList.containsKey(spr.Service_Prep__c)) { 
                if(serPreRespList.get(spr.Service_Prep__c).Containskey(spr.Service_Prep_Question__r.Notification_Service__c)) {
                    if(serPreRespList.get(spr.Service_Prep__c).get(spr.Service_Prep_Question__r.Notification_Service__c).containsKey(spr.Service_Prep_Question__r.Question_Category__c)) {
                        if(serPreRespList.get(spr.Service_Prep__c).get(spr.Service_Prep_Question__r.Notification_Service__c).get(spr.Service_Prep_Question__r.Question_Category__c).containsKey(spr.Service_Prep_Question__r.Sub_Category__c)) {
                            serPreRespList.get(spr.Service_Prep__c).get(spr.Service_Prep_Question__r.Notification_Service__c).get(spr.Service_Prep_Question__r.Question_Category__c).get(spr.Service_Prep_Question__r.Sub_Category__c).add(spr.Service_Prep_Question__c);
                        } else serPreRespList.get(spr.Service_Prep__c).get(spr.Service_Prep_Question__r.Notification_Service__c).get(spr.Service_Prep_Question__r.Question_Category__c).put(spr.Service_Prep_Question__r.Sub_Category__c,new List<String>{spr.Service_Prep_Question__c});   
                    } else serPreRespList.get(spr.Service_Prep__c).get(spr.Service_Prep_Question__r.Notification_Service__c).put(spr.Service_Prep_Question__r.Question_Category__c,new map<String,List<String>>{spr.Service_Prep_Question__r.Sub_Category__c=> new List<String>{spr.Service_Prep_Question__c}});
                } else serPreRespList.get(spr.Service_Prep__c).put(spr.Service_Prep_Question__r.Notification_Service__c,new Map<String,Map<String,List<String>>>{spr.Service_Prep_Question__r.Question_Category__c=>new map<String,List<String>>{spr.Service_Prep_Question__r.Sub_Category__c=> new List<String>{spr.Service_Prep_Question__c}}});
            } else serPreRespList.put(spr.Service_Prep__c,new Map<String,Map<String,Map<String,List<String>>>>{spr.Service_Prep_Question__r.Notification_Service__c=> new Map<String,Map<String,List<String>>>{spr.Service_Prep_Question__r.Question_Category__c=>new map<String,List<String>>{spr.Service_Prep_Question__r.Sub_Category__c=> new List<String>{spr.Service_Prep_Question__c}}}});     
        } 
        
    }
    
    
    /** Gets the  qestion number to display in email body **/
    public String getQuestionNumber(Service_Prep_Response__c spr) {
        if(spr.Service_Prep_Question__r.Question_Type__c.contains('Number')) {
            if(spr.Response_Number__c == null) {
                return spr.Service_Prep_Question__c;
                
            }
        } else { if(String.isBlank(spr.Response__c))
            return spr.Service_Prep_Question__c;   
                else if(spr.Response__c.containsIgnoreCase('None')) 
                    return spr.Service_Prep_Question__c;   
               }
        return null;         
    } 
    
    /** Generate mail body logic **/
    public Map<String,String> generateEmailBody(Map<String,Map<String,Map<String,Map<String,List<String>>>>> serPreRespList,Map<String,String> proidsMap) {
        Map<String,String> serPrepIdMailBody = new Map<String,String>();
        if(!serPreRespList.isEmpty()) {
            
            for(String s: serPreRespList.keyset())  {
                String proId = proidsMap.get(s);
                String eBody='<html> <head><style>table {  border-collapse: collapse;}table, td, th {  border: 1px solid black;}</style> </head><body>';
                eBody+='Here is the Link to the Service Prep Form : <br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+ '/apex/PPW_servicePrepForm?id=' +s+'"> Service Prep Form </a><br/> <br/>';
                eBody +='<table style="border-collapse: collapse;">';
                if(serPreRespList.containskey(s)) { 
                    for(String sName : serPreRespList.get(s).keyset()) {
                        if(!String.isBlank(sName)) {
                            eBody +='<tr><td width="20%" colspan="2" bgcolor="#ababab"> <b>Service Type: </b>'+ sName+ '</td></tr>';
                            if(serPreRespList.get(s).containsKey(sName)) {
                                for(String cName : serPreRespList.get(s).get(sName).keyset()) {
                                    eBody +='<tr><td width="20%" colspan="2"> <b>Category:</b>'+ cName+'</td></tr>';
                                    if(serPreRespList.get(s).get(sName).containsKey(cName)) {
                                        for(String scName : serPreRespList.get(s).get(sName).get(cName).keyset()) {
                                            eBody +='<tr><td width="20%" colspan="2"> <b>Sub Category : </b>'+ scName + '</td></tr>';
                                            if(serPreRespList.get(s).get(sName).get(cName).containsKey(scName))  {
                                                eBody += '<tr><th width="20%"> Question Number : </th> <th width="20%"> Question : </th></tr>';
                                                for(String qName : serPreRespList.get(s).get(sName).get(cName).get(scName)) {
                                                    if(!getQusMap.isEmpty() && getQusMap.containsKey(qName)) {
                                                        eBody += '<tr><td>' + getQusMap.get(qName).Name + '</td>';
                                                        eBody += '<td>' + getQusMap.get(qName).Question__c + '</td></tr>';
                                                    }
                                                    
                                                } 
                                            }  // sub Cat 
                                        }
                                    }  // Cat  
                                } 
                            } //service
                        } //service blank   
                    }
                }  // service prep form   
                eBody +='</table> </body></html>'; 
                serPrepIdMailBody.put(s,eBody);  
            }                         
            
        }
        System.debug(serPrepIdMailBody);
        return serPrepIdMailBody;
        
    }
    
    /** Subquestions logic **/
    private void getSubQuestions(List<String> sePrepIds) {
        SubQusMap  = new map<String,List<Service_Prep_Question__c>>();
        list<Service_Prep_Question__c> serPrepQuestion = [Select id,Name, Service_Prep_Parent_Question__c,(Select id,Service_Prep_Question__r.name,Response__c,Response_Number__c from Service_Prep_Responses__r where Service_Prep__c=:sePrepIds) from 
                                                          Service_Prep_Question__c WHERE (Service_Prep_Parent_Question__c !='' OR Service_Prep_Parent_Question__c != null) 
                                                          AND active__c = true  order by Sub_Category__c,Order__c];
        for(Service_Prep_Question__c sub: serPrepQuestion) { 
            if(SubQusMap.containskey(sub.Service_Prep_Parent_Question__c))
                SubQusMap.get(sub.Service_Prep_Parent_Question__c).add(sub);
            else
                SubQusMap.put(sub.Service_Prep_Parent_Question__c ,new List<Service_Prep_Question__c>{sub});    
            
        }  
        MainQusMap = new map<String,Service_Prep_Question__c>([SELECT id,Name, Service_Prep_Parent_Question__c,(Select id,Service_Prep_Question__r.name,Response__c,Response_Number__c
                                                                                                                from Service_Prep_Responses__r) from Service_Prep_Question__c WHERE (Service_Prep_Parent_Question__c ='' OR Service_Prep_Parent_Question__c = null) 
                                                               AND active__c = true  order by Sub_Category__c,Order__c]);                                                 
        getQusMap  = new map<String,Service_Prep_Question__c>([SELECT id,Name,Question__c FROM Service_Prep_Question__c WHERE active__c = true  ORDER BY Sub_Category__c,Order__c ]);                                                 
    }
}