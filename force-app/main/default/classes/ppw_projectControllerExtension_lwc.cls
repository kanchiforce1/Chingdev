/***********************************
Author: Amazon Apub // michatem@, kkolla@
Visualforce Page Extended:  PPW_Project_Default.vfp
Description: Controller Extension for PPW_Project_Default
************************************/

public class ppw_projectControllerExtension_lwc{
    //Standard Project / Controller Variables
  
  public class responseWrp {
      @AuraEnabled public title__c title{get;set;}
      @AuraEnabled public Series__c series{get;set;}
      @AuraEnabled public project__c project{get;set;}
      @AuraEnabled public Map<String,String> seriestitlesCB{get;set;}
      @AuraEnabled public Map<String,project__c> seriestitleprojects{get;set;}
    
  }
  
  
  @AuraEnabled
    public static responseWrp getProject(String pId) {
    responseWrp rw = new responseWrp();
      rw.project = [SELECT id,title__c,title__r.production_locale__c,title__r.Full_Title_Name__c,title__r.Marty_Title_ID__c,
                    title__r.Status__c,name, Censhare_Project_ID__c FROM project__c WHERE id=: pId];
      return rw;
        
    }
    
      @AuraEnabled
    public static void resetChatterCountInternal(String pId) {
        project__c p = new project__c(Id=pid, Chatter_Count_Internal__c= null);
        update p;
    
    }
   
    @AuraEnabled//(cacheable=true)
     public static boolean getppw_censhareConnect_PSUpdate(String pId) {
         boolean censharePsUpdate = false;
        Map<String,Project_Services__c> psLst = new Map<String,Project_Services__c>();
        psLst = new Map<String,Project_Services__c>([SELECT id,Service__c,Vendor__c, project__c,project__r.title__r.Marty_Title_ID__c,Service__r.name,
                                                               Estimated_Start_Date__c, Estimated_Completion_Date__c,
                                                            Service__r.Censhare_Template_ID__c,service__r.Service_Complexity_Value__c
                                                             ,Honor_Dependencies__c,status__c,Vendor__r.name,Censhare_XML_update_type__c 
                                     
                                     FROM Project_Services__c WHERE project__c=: pId AND status__c = 'In Planning' AND (NOT Service__r.Name LIKE 'Promo Text Creation')]);
        Map<String,Project_Services__c> masterPIpsLst = new Map<String,Project_Services__c>([SELECT id,Service__c,Vendor__c, project__c,project__r.title__r.Marty_Title_ID__c,Service__r.name,
                                                               Estimated_Start_Date__c, Estimated_Completion_Date__c,
                                                            Service__r.Censhare_Template_ID__c,service__r.Service_Complexity_Value__c
                                                             ,Honor_Dependencies__c,status__c,Vendor__r.name,Censhare_XML_update_type__c 
                                     
                                     FROM Project_Services__c WHERE project__c=: pId AND status__c = 'In Planning' AND Service__r.Name LIKE 'Promo Text Creation' AND Master_PT_Service__c = true]);
        if(!masterPIpsLst.isEmpty()) {
            psLst.putall(masterPIpsLst);
        }
        
      
        if(!psLst.isEmpty()) {
           // psInplanningCount = psLst.size();
            ppw_censhareConnect_PSUpdate pc = new ppw_censhareConnect_PSUpdate();
            
            String xmlBody = pc.censhareXMLBuilder(psLst.values());
            system.debug('xml'+ xmlBody);
            ppw_censhareConnect_PSUpdate.resWrap rw = new  ppw_censhareConnect_PSUpdate.resWrap();
            rw = ppw_censhareConnect_PSUpdate.censhareServiceSync(xmlBody, psLst);
            system.debug( rw);
            if(rw.psStatus)
                censharePsUpdate = true;
            else
                censharePsUpdate = false; 
            if (rw.psList != null)
                update rw.psList;
          
        }
    
        return censharePsUpdate;
    }
    

 @AuraEnabled
    public static string createBundleSerivces(List<Project_Services__c> psList) {
        List< Bundled_Project_Service__c> newBundlePs = new List< Bundled_Project_Service__c>();
       Map<String,String> service_Bundlemap = new Map<String,String>();
        for(Project_Services__c ps: psList) 
                   service_Bundlemap.put(ps.Service__r.Name, ps.Service__r.Bundled_Service__c);
       Set<string> existingBundleServices = new Set<String>();
        for(Bundled_Project_Service__c bps: [SELECT Name FROM Bundled_Project_Service__c WHERE Name=: service_Bundlemap.keyset()])
            existingBundleServices.add(bps.Name);
        
        
        for(String s: service_Bundlemap.keyset()) 
            if(!existingBundleServices.contains(s))
              newBundlePs.add(new Bundled_Project_Service__c( Bundled_Service__c = service_Bundlemap.get(s)));
        
        insert newBundlePs;
        Map<String,String> newbundlespsMap = new Map<String,String>();
        for(Bundled_Project_Service__c bps: newBundlePs)
            newbundlespsMap.put(bps.Bundled_Service__c, bps.Id);
        
        List<Project_Services__c> updatebundlepsfiled = new List<Project_Services__c>();
        for(Project_Services__c ps: psList) 
            if(service_Bundlemap.containsKey(ps.Service__r.Name)) {
                ps.Bundled_Container__c = newbundlespsMap.get(service_Bundlemap.get(ps.Service__r.Name));
                ps.Bundled_PS__c = true;
            }
          
        update psList;
        if(!newBundlePs.isEmpty())
          return 'Bundled Sericess created successfully';
        else return 'Bundled Serivces already there';
        
    }
    
    
    
    @AuraEnabled
    public static responseWrp getProject1(String pId) {
    responseWrp rw = new responseWrp();
      rw.project = [SELECT id, recordType.Name, Chatter_Count_Internal__c,title__c,Series__c,title__r.Name,title__r.Full_Title_Name__c,title__r.production_locale__c, (select id from Service_Preps__r)  title__r.Full_Title_Name__c,title__r.Marty_Title_ID__c,
                    title__r.author__c,title__r.Status__c,name,Censhare_Project_ID__c,series__r.Name,series__r.Wombat_Series_ID__c,series__r.Series_Title__c
                    FROM project__c WHERE id=: pId ];
        
      if(rw.project.recordType.Name == 'Title Project')
            rw.title = [SELECT id,Name,(SELECT id FROM Creative_Briefs__r), Marty_Title_ID__c,Full_Title_Name__c,Status__c,Digital_Publication_Date__c,External_Imprint__c,Internal_Imprint__c,
                  Category__c,Sub_Category__c,Literary_Form__c,Manuscript_Delivery_Date__c,Production_Locale__c,Pre_Dev_Edit_Word_Count__c,
                  Acquiring_Editor__c,Current_Editor__c,Production_Manager__c,Art_Director__c,Marketing_Manager__c
                  FROM title__c WHERE id=: rw.project.title__c];
        
        if(rw.project.recordType.Name == 'Series Project') {
            rw.series = [SELECT Acquiring_Editor__c, (SELECT id,Full_Title_Name__c,Marty_Title_ID__c,Status__c FROM titles__r ORDER BY Number_in_Series__c ASC) 
                         Art_Director__c,
                         Author_Relations_Manager__c,Content_Producer__c,Current_Editor__c,
                         KiM_Art_Director__c,Marketing_Manager__c,PR_Manager__c,Production_Locale__c, Production_Manager__c,Series_Title__c,
                         Wombat_Series_ID__c,Id,Name 
                      FROM Series__c WHERE id=: rw.project.Series__c];
            Map<String,String> seriestitlesCB = new Map<String,String>();
            Map<String,project__c> seriestitleprojects = new Map<String,project__c>();
            for(Creative_Brief__c cb: [SELECT id,title__c FROM Creative_Brief__c WHERE title__c=: rw.series.titles__r])
                seriestitlesCB.put(cb.title__c, cb.Id);
            rw.seriestitlesCB = seriestitlesCB;
            for(project__c p: [SELECT id,Censhare_Project_ID__c,title__c FROM project__c WHERE title__c=: rw.series.titles__r])
                seriestitleprojects.put(p.title__c, p);
            rw.seriestitleprojects = seriestitleprojects;
        }
      return rw;
        
    }
    
   @AuraEnabled
   public static List<Project_Services__c> getVendorPSs(String vId, String prodLocale, String projectID) {
        set<string> tempSet = new set<string>();
       List<Project_Services__c> psList =new LIst<Project_Services__c>();
     
        //prodLocale = PPW_Utils.makeListIncludesType(prodLocale);
        
       //List<String> pLocalee = PPW_Utils.splitString(prodLocale);
       List<String> pLocalee = PPW_StaticUtils.splitString(prodLocale);

        set<string> vendorStatusSet = new set<string>();
        vendorStatusSet.addAll(label.PPW_vendorStatus.split(','));
   
            for(rate__c r: [SELECT Vendor__c, vendor__r.name,service__c,vendor__r.approved_locale__c FROM rate__c 
                            WHERE vendor__r.vendor_status__c IN :vendorStatusSet
                            AND vendor__r.approved_locale__c != null
                            AND vendor__c =: vId
                            AND active_rate__c = true
                            ORDER BY name ASC]) 
            {
                for(String s: pLocalee)
                    if(r.vendor__r.approved_locale__c.containsIgnoreCase(s))
                        tempSet.add(r.service__c);
            }
                                
     
            for(Project_Services__c s: [SELECT id, name,  Service__c, Service__r.name, Rate__r.name,Actual_Completion_Date__c,Actual_Start_Date__c, Service_Type_Complexity__c,
            service__r.Service_Grouping_String__c, Estimated_Completion_Date__c,Estimated_Start_Date__c, Total_Rate_Amount__c,
            Status__c,Vendor__r.name ,Service_Name__c,Master_PT_Service__c,Chatter_Count_Internal__c,Chatter_Count_External__c
            FROM Project_Services__c 
           
            WHERE Project__c=:projectID AND vendor__c!=: vId AND service__c =: tempSet AND Status__c = 'In Planning' 
            ORDER BY estimated_start_date__c ASC NULLS LAST]) 
             if(s.Service_Name__c == 'Promo Text Creation') {
                            if(s.Master_PT_Service__c == true)
                                psList.add(s);
             } else psList.add(s);              
    
    return psList;
   }
   
    @AuraEnabled
   public static List<Vendor__c> getAllVendors(String prodLocale) {
       set<string> tempSet = new set<string>();
        //prodLocale = PPW_Utils.makeListIncludesType(prodLocale);
       //List<String> pLocalee = PPW_Utils.splitString(prodLocale);
        List<String> pLocalee = PPW_StaticUtils.splitString(prodLocale);

        set<string> vendorStatusSet = new set<string>();
        vendorStatusSet.addAll(label.PPW_vendorStatus.split(','));
   
            for(rate__c r: [SELECT Vendor__c, vendor__r.name,vendor__r.approved_locale__c FROM rate__c
                            WHERE vendor__r.vendor_status__c IN :vendorStatusSet
                            AND vendor__r.approved_locale__c != null
                            AND active_rate__c = true
                            ORDER BY name ASC])
            {
                for(String s: pLocalee)
                    if(r.vendor__r.approved_locale__c.containsIgnoreCase(s))
                        tempSet.add(r.vendor__c);
            }
       
     return [select id, name, vendor_status__c from vendor__c where Id=:tempSet ORDER BY name ASC];
    }
    
    public class titleDetails {
    @AuraEnabled
    public title__c title{get;set;}
    @AuraEnabled
    public series__c series{get;set;}
    @AuraEnabled
    public project__c project{get;set;}
    @AuraEnabled
    public List<Vendor__c> vendors{get;set;}
    }
    
       @AuraEnabled
    public static Map<String,Bundled_Project_Service__c> getBundleSerivcesDetails(String projectID) {
        List<String> bundledIds = new List<String>();
        system.debug(projectId);
        for(Project_Services__c ps: [SELECT Bundled_Container__c FROM Project_Services__c  WHERE project__c=: projectID AND Bundled_Container__c!=null])
            if(String.isNotBlank(ps.Bundled_Container__c))
                bundledIds.add(ps.Bundled_Container__c);
        Map<String, Bundled_Project_Service__c> bundlerPsMap = new Map<String,Bundled_Project_Service__c>([SELECT Id,name, Actual_Completion_Date__c ,Actual_Start_Date__c ,
                                                                                                           Bundled_Service__c ,Bundled_Service_Name__c ,Estimated_Completion_Date__c ,
                                                                                                           Estimated_Start_Date__c ,Service_Complexity_Value__c ,Status__c ,Total_Rate_Amount_with_Currency__c 
                                                                                                           FROM Bundled_Project_Service__c WHERE Id =: bundledIds]);
        return bundlerPsMap;
        
    }
    
    @AuraEnabled
    public static Map<String,List<Project_Services__c>> getBundleSerivces(String projectID) {
        Map<String, String> bundleServices = new Map<String, String>();
        Map<String,List<Project_Services__c>> bundlePsMap = new Map<String,List<Project_Services__c>>();
        for(Service__c s: [SELECT id,Name,Bundled_Service__r.Name FROM Service__c WHERE Bundled_Service__c!=null])
            bundleServices.put(s.Id, s.Name);
         Set<string> existingBundleServices = new Set<String>();
        for(Bundled_Project_Service__c bps: [SELECT Name FROM Bundled_Project_Service__c WHERE Name=: bundleServices.values()])
            existingBundleServices.add(bps.Name);
        
        for(Project_Services__c ps: [SELECT id, name,  Service__c, Service__r.Name ,service__r.Bundled_Service__c, Actual_Completion_Date__c,Actual_Start_Date__c, Service_Type_Complexity__c,
                                     Estimated_Completion_Date__c,Estimated_Start_Date__c, Total_Rate_Amount__c,
                                     Status__c,Service_Name__c,Master_PT_Service__c 
                                     FROM Project_Services__c 
                                     WHERE Project__c=:projectID AND vendor__c!=null AND service__r.Name!=:existingBundleServices AND service__c =: bundleServices.keyset() AND (Status__c = 'In Planning' OR Status__c='Confirming')
                                     ORDER BY estimated_start_date__c ASC NULLS LAST]) {
                                         String sName;
                                         if(bundleServices.containsKey(ps.service__c))
                                            sName = bundleServices.get(ps.service__c);
                                         if(bundlePsMap.containsKey(sName))
                                             bundlePsMap.get(sName).add(ps);
                                         else bundlePsMap.put(sName, new List<Project_Services__c> {ps});
                                     }
        return bundlePsMap;
    }
    
    @AuraEnabled(cacheable=true)
   public static titleDetails getTitleDetails(String martyid) {
      titleDetails td = new titleDetails();
      List<id> vIds = new List<Id>();
      List<title__c> titles = [SELECT id, Production_Locale__c,Marty_Title_ID__c,(SELECT id,Name,Title__r.Full_Title_Name__c,Title__r.Marty_Title_ID__c,Title__r.Status__c FROM projects__r), Name FROM title__c WHERE Marty_Title_ID__c=: martyId];
      td.title = titles.size()>0? titles[0]: null;
      td.project = titles.size()>0? titles[0].projects__r.size()>0? titles[0].projects__r[0]: null : null;
      for(Project_Services__c ps: [SELECT vendor__c,id FROM Project_Services__c WHERE project__r.title__r.Marty_Title_ID__c=: martyid])
          vIds.add(ps.vendor__c);
          
      td.vendors = [SELECT id,name,vendor_status__c FROM vendor__c WHERE id=: vIds];
             
     return td;
    }
    
     @AuraEnabled(cacheable=true)
   public static titleDetails getSeriesDetails(String seriesid) {
      titleDetails td = new titleDetails();
      List<id> vIds = new List<Id>();
      List<series__c> series = [SELECT id, Production_Locale__c,Wombat_Series_ID__c,Series_Title__c,(SELECT id,Name,series__r.Series_Title__c,
                                series__r.Wombat_Series_ID__c,
                                Title__r.Status__c FROM projects__r), Name FROM series__c WHERE Wombat_Series_ID__c=: seriesid];
      td.series = series.size()>0? series[0]: null;
      td.project = series.size()>0? series[0].projects__r.size()>0? series[0].projects__r[0]: null : null;
      for(Project_Services__c ps: [SELECT vendor__c,id FROM Project_Services__c WHERE project__r.series__r.Wombat_Series_ID__c=: seriesid])
          vIds.add(ps.vendor__c);
          
      td.vendors = [SELECT id,name,vendor_status__c FROM vendor__c WHERE id=: vIds];
             
     return td;
    }
    
    
  

 
     @AuraEnabled
    public static List<lookupOptions> getServices() {
      List<lookupOptions> lpts = new List<lookupOptions>();
      Map<String,String> services = new Map<String,String>();
        for(Service__c s: [SELECT id,name,Service_Rate_Type__c,Description__c FROM service__c WHERE 
                           active__c=true 
                           ORDER BY name ASC]) 
              services.put(s.Name, s.Id);
        for(String s: services.keyset())
              lpts.add(new lookupOptions(s, services.get(s)));   
       
      return lpts;

    }
    
      @AuraEnabled
    public static List<lookupOptions> getAllTitles() {
      List<lookupOptions> lpts = new List<lookupOptions>();
      
        for(title__c t: [SELECT id,Marty_Title_ID__c,Name FROM title__c WHERE (status__c = 'Pre Acquisition' OR status__c = 'Contracted') order by Digital_Publication_Date__c ASC])  
           // if(String.isnotBlank(t.title__r.Marty_Title_ID__c))            
                lpts.add(new lookupOptions((String.isnotBlank(t.Marty_Title_ID__c)? t.Marty_Title_ID__c + ' - ' : '') + t.name, String.isNotBlank(t.Marty_Title_ID__c)? t.Marty_Title_ID__c: ''));                 
                          
      lpts.addAll(getAllSeries());
       
      return lpts;

    }
    
      @AuraEnabled
    public static List<lookupOptions> getAllSeries() {
      List<lookupOptions> lpts = new List<lookupOptions>();
      
        for(series__c t: [SELECT id,Wombat_Series_ID__c,Series_Title__c FROM series__c])  
           // if(String.isnotBlank(t.title__r.Marty_Title_ID__c))            
                lpts.add(new lookupOptions((String.isnotBlank(t.Wombat_Series_ID__c)? t.Wombat_Series_ID__c + ' - ' : '') + t.Series_Title__c, String.isNotBlank(t.Wombat_Series_ID__c)? t.Wombat_Series_ID__c: '' , true));                 
                          
      
       
      return lpts;

    }
    
    
    public class lookupOptions {
    @AuraEnabled public String label{get;set;}
    @AuraEnabled public String value{get;set;}
    @AuraEnabled public boolean isSeries{get;set;}
    @AuraEnabled public String statusStyle{get;set;}
    @AuraEnabled public String statusIcon{get;set;}
    @AuraEnabled public String vendorStatus{get;set;}
    @AuraEnabled public String vendorBadge{get;set;}
    @AuraEnabled public String serviceDescription{get;set;}
    @AuraEnabled public String wikiAdditionalnfo{get;set;}
    
      
       public lookupOptions(String l, String v, string s, string s1, string v1,string v2) { label =l;value=v; statusStyle=s; statusIcon=s1; vendorStatus=v1; vendorBadge= v2;}
       public lookupOptions(String l, String v) { label =l;value=v; }
       public lookupOptions(String l, String v, boolean s) { label =l;value=v;isSeries=s; }
       public lookupOptions(String l, String v, String sd, String wikiALink) { label =l;value=v;serviceDescription=sd; wikiAdditionalnfo=wikiALink;}
    
    }
    
    
    @AuraEnabled
    public static List<lookupOptions> getServicetype(String serviceGroup) {
          List<lookupOptions> lpts = new List<lookupOptions>();
       
        for(Service__c s: [SELECT id,name,Service_Rate_Type__c,Description__c,Wiki_Additional_Information__c  FROM service__c WHERE 
                           active__c=true AND Name=:serviceGroup
                           ORDER BY name ASC]) 
           lpts.add(new lookupOptions(s.Service_Rate_Type__c,s.Id,s.Description__c,s.Wiki_Additional_Information__c));
        
      return lpts;

    }
    
    @AuraEnabled
    public static rate__c loadRates(String serviceGroup, string serviceType, string vendor, String prodLocale) {
       set<string> vendorStatusSet = new set<string>();
        vendorStatusSet.addAll(label.PPW_vendorStatus.split(','));
         system.debug(serviceGroup);
        system.debug(serviceType);
        system.debug(prodLocale);
         system.debug(vendor);
        
        //prodLocale = PPW_Utils.makeListIncludesType(prodLocale);
        //List<String> pLocalee = PPW_Utils.splitString(prodLocale);
          List<String> pLocalee = PPW_StaticUtils.splitString(prodLocale);

        List<rate__c> r = [SELECT id, Rate_Amount__c, Rate_Currency__c, Rate_Multiplier__c FROM rate__c 
                            WHERE vendor__r.vendor_status__c IN :vendorStatusSet
                            AND vendor__r.vendor_services_codes__c includes ( :serviceGroup )
                            AND service__c = :serviceType
                            AND vendor__c =: vendor
                            AND vendor__r.approved_locale__c != null
                            AND active_rate__c = true
                            ORDER BY name ASC LIMIT 1];
        
    
        return r.size()>0? r[0] : null;

    }
    
   
    
    
   @auraenabled public static List<lookupOptions> loadServiceVendorOptions(string serviceGroup, string serviceType, string prodLocale) {
       ///vendorwrap vrp = new vendorwrap();
        List<lookupOptions> lpts = new List<lookupOptions>();
        system.debug(serviceGroup);
        system.debug(serviceType);
        system.debug(prodLocale);
       //  prodLocale = PPW_Utils.makeListIncludesType(prodLocale);
        
       // List<String> pLocalee = PPW_Utils.splitString(prodLocale);
       List<String> pLocalee = PPW_StaticUtils.splitString(prodLocale);
       
       system.debug(pLocalee);
        set<string> tempSet = new set<string>();
        Map<String,vendor__c> vMap =new Map<String,vendor__c>();
        set<string> vendorStatusSet = new set<string>();
        vendorStatusSet.addAll(label.PPW_vendorStatus.split(','));
        system.debug(vendorStatusSet);
        if(serviceGroup!=null && serviceType !='') 
            for(rate__c r: [SELECT Vendor__c, vendor__r.name,vendor__r.approved_locale__c FROM rate__c 
                            WHERE vendor__r.vendor_status__c IN :vendorStatusSet
                            AND vendor__r.vendor_services_codes__c includes ( :serviceGroup )
                            AND service__c = :serviceType
                            AND vendor__r.approved_locale__c != null
                            AND active_rate__c = true
                            ORDER BY name ASC]) {
                for(String s: pLocalee)
                    if(r.vendor__r.approved_locale__c.containsIgnoreCase(s))
                        tempSet.add(r.vendor__c);
                    //vrp.rate = r;  
             }             
           
            for(vendor__c v : [select id, name, vendor_status__c from vendor__c where id in :tempSet ORDER BY name ASC]) {
             String vstatus = '';
                 String vicon = '';
               if(v.Vendor_Status__c == 'Approved: Ok to Use') {
                                vstatus =  'iconStyle iconColorGreen';
                                 vicon = '/utility-sprite/svg/symbols.svg#success';
                             } else {
                                 vstatus = 'iconStyle iconColor1';
                                 vicon = '/utility-sprite/svg/symbols.svg#warning';
                             }
                            // this.vendorStatus = vendorStatus;
                             String vendorBadge = v.Vendor_Status__c == 'Approved: Ok to Use'? 'slds-text-color_success': 'warningColor';
                            lpts.add(new lookupOptions(v.Name, v.id, vstatus, vicon, v.Vendor_Status__c, vendorBadge));
          
        }
      
        return lpts;
    } 
    
    public class projectServiceUpdate {
    public string projectID{get;set;}
    public string serviceTypeSelection{get;set;}
    public string serviceVendorSelection{get;set;}
    public decimal rushFee{get;set;}
    public decimal additionalRateInput{get;set;}
    public string externalVendorNote{get;set;}
    public string internalVendorNote{get;set;}
    public boolean honorDependencies{get;set;}
    public string rateAmount{get;set;}
    public string psAmount{get;set;}
    public string serviceActionType{get;set;}
    public rate__c rateRecord{get;set;}
    public Project_services__c thisProjectService{get;set;}
    
    }
    
    @AuraEnabled
     public static calloutStatusRes projectServiceHandler(String res) {
       calloutStatusRes csr = new calloutStatusRes();
       csr.pollerEnabled = true;
       
       projectServiceUpdate psu = new projectServiceUpdate();
       psu =(projectServiceUpdate)JSON.deserialize(
               res, projectServiceUpdate.class);
       
        boolean promotionalFlg = false;
        //compare the current context of the service to the new one.
        Project_services__c tps = new Project_services__c();
        map<string, string> psXMLDataMap = new map<string, string>(); //container for the outbound XML body
        list<map<string,string>> psMapList = new list<map<string,string>>();
        ppw_censhareConnector ppw_cc = new ppw_censhareConnector();
        boolean transmitToCenshare = false;
        string response;
        
        if(psu.serviceActionType == 'create') {
            //we are creating a single ala carte service, therefore we can assume some things before building the XML Payload
            tps.Project__c = psu.projectID;
            tps.Service__c = psu.serviceTypeSelection;
            tps.Vendor__c = psu.serviceVendorSelection;
            tps.Rush_Fee__c = psu.rushFee;
            tps.Additional_Rate_Input__c = psu.additionalRateInput;
            tps.Vendor_Notes_RT__c = psu.externalVendorNote;
            tps.Internal_Service_Notes__c = psu.internalVendorNote;
            tps.Honor_Dependencies__c = psu.honorDependencies!=null?psu.honorDependencies:false;
            tps.Status__c = 'In Planning';
      
            if(psu.rateAmount!=null)
                if(psu.rateRecord.Rate_Multiplier__c == 'Custom Quote') { 
                    tps.Custom_Quote_Amount__c = digitPatternCheck(psu.rateAmount)? decimal.valueOf(psu.rateAmount) : tps.Custom_Quote_Amount__c; // update Custom quote amount in ps record when rate mulitiplier is Custom Quote 
                   // update tps;
                    update psu.rateRecord; 
                }  
               
            insert(tps); 
          
            if(psu.serviceTypeSelection!=null)
            if(allServiceDetailsMap.get(psu.serviceTypeSelection).Name.equalsIgnoreCase('Promo Text Creation'))
                promotionalFlg = promotionalTextService(psu.projectID);
            if(promotionalFlg)  {
                // no censhare call out for more than one promotional text service
               //  pollerEnabled = false;
               //  censhareStatus = false;
            } else {
            tps.Censhare_XML_update_type__c = 'New'; 
            tps.Honor_Dependencies__c = psu.honorDependencies!=null?psu.honorDependencies:false;
            tps.Honor_Dependencies__c = psu.honorDependencies;//true; 
           // censhareNewPs = tps; 
            censhareServerInsert(tps, false, false);
            
          csr.psRecord = tps;
            }
         }
        
        if(psu.serviceActionType =='edit') {
            //remove after censhare config
          // boolean transmitToCenshare=false;
            //remove after censhare config
            if( !transmitToCenshare) {
                boolean closeConfirmation = false; 
                psu.thisProjectService.Service__c = psu.serviceTypeSelection;
                psu.thisProjectService.Vendor__c = psu.serviceVendorSelection;
                psu.thisProjectService.Rush_Fee__c = psu.rushFee;
                psu.thisProjectService.Additional_Rate_Input__c = psu.additionalRateInput;
                psu.thisProjectService.Vendor_Notes_RT__c = psu.externalVendorNote;
                psu.thisProjectService.Internal_Service_Notes__c = psu.internalVendorNote;
                psu.thisProjectService.Honor_Dependencies__c = psu.honorDependencies;
                
            
                User u = [Select UserRole.Name from user WHERE id =: Userinfo.getUserId() LIMIT 1]; 
                if(u.UserRole != null) { 
                if(psu.thisProjectService.status__c == 'Killed' && psu.psAmount!=null && killServiceRolesSet.containsIgnoreCase(u.UserRole.Name)) 
                    psu.thisProjectService.User_Input_Rate_Amount__c = digitPatternCheck(psu.psAmount) ? Decimal.valueOf(psu.psAmount) : psu.thisProjectService.User_Input_Rate_Amount__c;
                 
                if(psu.psAmount!=null && amountChangeRolesSet.containsIgnoreCase(u.UserRole.Name)) 
                    psu.thisProjectService.User_Input_Rate_Amount__c = digitPatternCheck(psu.psAmount) ? Decimal.valueOf(psu.psAmount) : psu.thisProjectService.User_Input_Rate_Amount__c;
                }
                System.debug('thisProjectService'+psu.thisProjectService); 
                Boolean censhareCall = false;
                //defind censhare call out
                project_services__c thisps = [SELECT id,Service__c,Vendor__c,User_Input_Rate_Amount__c,Has_Been_Kicked_Off__c ,rate_Amount__c,Amount__c ,Service_Type_Complexity__c,status__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,Word_Count_Completed__c, Base_Amount__c,
                                                Base_Amount_with_Currency__c,Rate_Currency__c,MBO_Fee__c,Rush_Fee__c,Total_Rate_Amount__c, Service_Name__c ,project__c,
                                              Service__r.Service_rate_type__c,Vendor__r.name,MBO_Fee_with_Currency__c, Master_PT_Service__c,
                                              Word_Count_Cancelled__c ,Honor_Dependencies__c,Additional_Rate_Input__c,Custom_Quote_Amount__c 
                                              FROM project_services__c WHERE id=: psu.thisProjectService.id]; 
                if(thisps.Service__c != psu.thisProjectService.Service__c || thisps.Vendor__c != psu.thisProjectService.Vendor__c || 
                   thisps.Service_Type_Complexity__c != psu.thisProjectService.Service_Type_Complexity__c || 
                   thisps.status__c != psu.thisProjectService.status__c || thisps.Honor_Dependencies__c != psu.thisProjectService.Honor_Dependencies__c) 
                                              
                    censhareCall = true;
                // status change to inplanning and not has been kick off
                if((thisps.Vendor__c !=psu.thisProjectService.Vendor__c || thisps.Service__c != psu.thisProjectService.Service__c ||
                    thisps.Rush_Fee__c != psu.thisProjectService.Rush_Fee__c || thisps.Additional_Rate_Input__c != psu.thisProjectService.Additional_Rate_Input__c ||
                    thisps.Custom_Quote_Amount__c != psu.thisProjectService.Custom_Quote_Amount__c || 
                    thisps.User_Input_Rate_Amount__c != psu.thisProjectService.User_Input_Rate_Amount__c || thisps.status__c != psu.thisProjectService.status__c) && thisps.status__c != 'In Planning' && (thisps.Has_Been_Kicked_Off__c == false)) {
                        psu.thisProjectService.status__c = 'In Planning'; 
                        
                        censhareCall = true;
                    }
                // ps status change from schedule to confirming and create new confirmation and has not been kicked off
                if((thisps.Service__c != psu.thisProjectService.Service__c || thisps.Vendor__c != psu.thisProjectService.Vendor__c || 
                    thisps.Service_Type_Complexity__c != psu.thisProjectService.Service_Type_Complexity__c  ||
                    thisps.Rush_Fee__c != psu.thisProjectService.Rush_Fee__c || thisps.Additional_Rate_Input__c != psu.thisProjectService.Additional_Rate_Input__c ||
                    thisps.Custom_Quote_Amount__c != psu.thisProjectService.Custom_Quote_Amount__c || 
                    thisps.User_Input_Rate_Amount__c != psu.thisProjectService.User_Input_Rate_Amount__c) && thisps.status__c == 'Scheduled' && (thisps.Has_Been_Kicked_Off__c == false)) {
                        censhareCall = true;
                        psu.thisProjectService.status__c = 'Confirming';
                    
              // this confirmation create process has been moved to ps trigger 
             
                    
                    }
                    
                    // make censhare callout false for service is not primary promo text creation services 
                    if(thisps.Service_Name__c == 'Promo Text Creation' && thisps.Master_PT_Service__c == false) 
                    censhareCall = false; 
                if(censhareCall) {
                    psu.thisProjectService.Censhare_XML_update_type__c = 'Update'; 
                   
                    if(psu.rateAmount!=null) 
                    if(psu.rateRecord.Rate_Multiplier__c == 'Custom Quote')  // set custom quote value before call out 
                        psu.thisProjectService.Custom_Quote_Amount__c = digitPatternCheck(psu.rateAmount) ? decimal.valueOf(psu.rateAmount) : psu.thisProjectService.Custom_Quote_Amount__c; // update Custom quote amount in ps recordwhen rate mulitiplier is Custom Quote 
                    
                   
                   csr = censhareServerUpdate(psu.thisProjectService);
                     if(psu.rateAmount!=null) 
                    if(psu.rateRecord.Rate_Multiplier__c == 'Custom Quote')  
                         update psu.rateRecord; // update custom quote rate amount after call out
                     
                     
              }  else update(psu.thisProjectService);
            
             csr.updatedpsRecord = projectservicesquery1(thisps.Id) ;
            }
           
        }
        
        
     
    return csr;
    }
    
    @AuraEnabled
    public static void internalCloseConfirmation(project_services__c thisProjectService,string internalCloseID) {
      //  thisProjectService = allProjectServiceMap.get(psRec); 
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
  
    }
   
   
    public static calloutStatusRes censhareServerUpdate(project_services__c cPS) {
     calloutStatusRes csr = new calloutStatusRes();
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
                            csr.censhareError= rwrp.resPs.values()[0].Censhare_XML_Error_Response__c; 
                            system.debug(csr.censhareError);
                            project_services__c ps = new project_services__c(id=cPS.id,Censhare_XML_Error_Response__c=rwrp.resPs.values()[0].Censhare_XML_Error_Response__c); 
                            update(ps); 
                                } else { 
                                    csr.censhareError = 'empty XML received from censhare, please refresh the page'; 
                                    system.debug(csr.censhareError); 
                                    project_services__c ps = new project_services__c(id=cPS.id,Censhare_XML_Error_Response__c = csr.censhareError); 
                                    update(ps); 
                                }
                            }
                            else {
                                csr.censhareError = 'empty XML received from censhare, please refresh the page'; 
                                system.debug(csr.censhareError); 
                                project_services__c ps = new project_services__c(id=cPS.id,Censhare_XML_Error_Response__c = csr.censhareError); 
                                update(ps); 
                           } 
                           csr.censhareStatus = rwrp.resStatus;
                            return csr;
                        }
            if(rwrp.resPs != null) 
                if(rwrp.resStatus == true && !rwrp.resPs.isEmpty()) { 
                    if(rwrp.resPs.containsKey(cPS.id)) {
                        cPS.Estimated_Start_Date__c = rwrp.resPs.get(cPS.id).Estimated_Start_Date__c; 
                        cPS.Estimated_Completion_Date__c = rwrp.resPs.get(cPS.id).Estimated_Completion_Date__c; 
                        if(cPs!=null) { 
                        update(cPS);
                         csr.censhareStatus = rwrp.resStatus;
                        return csr;
                            } else 
                                return csr; 
                    } else return csr;
                }
             return csr;   
             }  
        return csr; 
   }
   
    public static Map<String,calloutStatusRes> censhareBulkServerUpdate(List<project_services__c> cPS) {
         
         Map<String,calloutStatusRes> csrMap = new Map<String,calloutStatusRes>();
        if(cPS != null) {
            List<project_services__c> updatePs = new List<project_services__c>();
                ppw_censhareConnector ppwCen = new ppw_censhareConnector();
                    String xml = ppwCen.censhareXMLBuilder(cPS);
                system.debug('xml'+xml);
                Map<String,ppw_censhareConnector.resWrap> rwrpMap = new Map<String,ppw_censhareConnector.resWrap>();
                if(!test.isrunningTest())
                    rwrpMap = ppw_censhareConnector.censhareBulkServiceSync(xml); // censhare Callout for update 
                    if(test.isrunningTest()) 
                    rwrpMap = PPW_TestDataFactory.setPasitiveTestDataPsList(cPS); 
                 system.debug('rwrpMap'+rwrpMap);
        for(project_services__c psr: cPS) {
                 calloutStatusRes csr = new calloutStatusRes();
                 if(rwrpMap.containsKey(psr.Id)) {
                 ppw_censhareConnector.resWrap rwrp = rwrpMap.get(psr.Id);
                 
                      if(rwrp.resProjectService != null) { 
                        if(rwrp.resStatus == false) { 
                            // censhareError= 'Censhare Service has been failed please connect with system administrator';
                            if(rwrp.resProjectService != null) { 
                                csr.censhareError= rwrp.resProjectService.Censhare_XML_Error_Response__c; 
                                system.debug(csr.censhareError);
                                project_services__c ps = new project_services__c(id=psr.id,Censhare_XML_Error_Response__c=rwrp.resProjectService.Censhare_XML_Error_Response__c); 
                               // update(ps); 
                               updatePs.add(ps);
                             } else { 
                                    csr.censhareError = 'empty XML received from censhare, please refresh the page'; 
                                    system.debug(csr.censhareError); 
                                    project_services__c ps = new project_services__c(id=psr.Id,Censhare_XML_Error_Response__c = csr.censhareError); 
                                
                                   updatePs.add(ps);
                                }
                            
                           
                           csr.censhareStatus = rwrp.resStatus;
                          
                        }
               
                    if(rwrp.resStatus == true && rwrp.resProjectService!=null) { 
                      
                           psr.Estimated_Start_Date__c = rwrp.resProjectService.Estimated_Start_Date__c; 
                           psr.Estimated_Completion_Date__c = rwrp.resProjectService.Estimated_Completion_Date__c; 
                            if(psr!=null) { 
                            updatePs.add(psr);
                          
                             csr.censhareStatus = rwrp.resStatus;
                      
                                }
                    }
              
                 } 
                 
              } else csr.censhareStatus = false;
              
                 csr.psRecord = psr;
               csrMap.put(psr.id,csr);  
             } 
             update updatePs;
         }
        return csrMap; 
   }
   
   
    
    
    
      public class calloutStatusRes {
         
        @AuraEnabled public String censhareError{get;set;}
        @AuraEnabled public boolean pollerEnabled{get;set;}
        @AuraEnabled public boolean censhareStatus{get;set;}
        @AuraEnabled public set<String> censhareNewPs{get;set;}
        @AuraEnabled public project_services__c psRecord{get;set;}
        @AuraEnabled public project_services__c updatedpsRecord{get;set;}
        
    }
    
    private static void censhareServerInsert(project_services__c cPS, boolean pollerEnabled, boolean censhareStatus) {
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
    
    @AuraEnabled
      public static  calloutStatusRes censhareCalloutStatus(Project_services__c censhareNewPs) {
      calloutStatusRes res =new calloutStatusRes();
        try {
            if(censhareNewPs != null) {
                AsyncApexJob asyncJob = [SELECT id,Status FROM AsyncApexJob WHERE MethodName='censhareService' AND JobType = 'Future' LIMIT 1];
                if(asyncJob.Status== 'Completed') {
                    List<Project_services__c> cNewPs = [SELECT id,Censhare_XML_Error_Response__c ,Censhare_XML_update_type__c FROM Project_services__c WHERE id =: censhareNewPs.id LIMIT 1];
                    if(cNewPs != null) {
                        if(cNewPs.size()>0) {
                            if(String.isNotBlank(cNewPs[0].Censhare_XML_Error_Response__c) && cNewPs[0].Censhare_XML_Error_Response__c != ' ') {
                                res.pollerEnabled = false;
                                res.censhareStatus = false;
                                res.censhareError = cNewPs[0].Censhare_XML_Error_Response__c;
                                delete cNewPs;
                            } else {
                                res.pollerEnabled = false;
                                res.censhareStatus = false;
                            } 
                        }  else {
                            res.pollerEnabled = true;  
                            res.censhareStatus = true; 
                        }
                    } else {
                        res.pollerEnabled = true; 
                        res.censhareStatus = true; 
                        }
                    } else {
                        res.pollerEnabled = true;
                        res.censhareStatus = true; 
                    }
                }
            } catch(Exception e) { 
            //delete tps;   censhareError
          }
          return res;
        }
        
        public class kickedOffResponse {
           @AuraEnabled public project_services__c psRec{get;set;}
           @AuraEnabled public string resErrorMes{get;set;}
        
        
        }
       
        @AuraEnabled
     public static List<calloutStatusRes> bulkKickOffService(List<project_services__c> psList) {
         // kickedOffResponse kres = new kickedOffResponse();
        date timeStamp = date.today();
        List<project_services__c> psconsolidatedLst = new List<project_services__c>();
        Map<String,calloutStatusRes> csrMap = new Map<String,calloutStatusRes>();
        
        for(project_services__c x: psList) {
            x.Status__c = 'Kicked Off';
            x.has_been_kicked_off__c = true;
            x.Actual_Start_Date__c = timeStamp;
            x.Censhare_XML_update_type__c = 'Update'; 
            psconsolidatedLst.add(x);
        }
        ppw_censhareConnector ppwCen = new ppw_censhareConnector();
            String xml = ppwCen.CenshareXMLBuilder(psconsolidatedLst);
        system.debug('xml'+xml);
        
        
        /// csrMap = censhareBulkServerUpdate(psconsolidatedLst);
       
            //if(!test.isrunningTest())
              csrMap = censhareBulkServerUpdate(psconsolidatedLst);
            List<project_services__c> psUpdate = new List<project_services__c>();  
              for(project_services__c ps: psconsolidatedLst) {
                  calloutStatusRes csr = csrMap.get(ps.id);
                  if(csr.censhareStatus) 
                      psUpdate.add(ps);
               }   
          
            return csrMap.values();
    }
    
            @AuraEnabled
     public static List<calloutStatusRes> bulkVendorService(List<project_services__c> psList, String vId) {
       
        List<project_services__c> psconsolidatedLst = new List<project_services__c>();
        Map<String,calloutStatusRes> csrMap = new Map<String,calloutStatusRes>();
        
        for(project_services__c x: psList) {
            x.vendor__c = vId;
            x.Censhare_XML_update_type__c = 'Update'; 
            psconsolidatedLst.add(x);
        }
        ppw_censhareConnector ppwCen = new ppw_censhareConnector();
            String xml = ppwCen.CenshareXMLBuilder(psconsolidatedLst);
        system.debug('xml'+xml);
        
            //if(!test.isrunningTest())
              csrMap = censhareBulkServerUpdate(psconsolidatedLst);
            List<project_services__c> psUpdate = new List<project_services__c>();  
              for(project_services__c ps: psconsolidatedLst) {
                  calloutStatusRes csr = csrMap.get(ps.id);
                  if(csr.censhareStatus) 
                      psUpdate.add(ps);
               }   
          
            return csrMap.values();
    }
    
        
        
    @AuraEnabled
     public static kickedOffResponse kickOffService(project_services__c x) {
          kickedOffResponse kres = new kickedOffResponse();
        date timeStamp = date.today();
     
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
              
                    if(rwrp.resStatus == false) 
                         kres.resErrorMes = 'Censhare Service has been failed please connect with system administrator';
                     
           
        
        
       project_services__c kickOffPS = [SELECT id,project__c,project__r.title__c,project__r.title__r.Status__c,status__c,project__r.series__r.Wombat_Series_ID__c
                                        FROM project_services__c WHERE id=:x.id LIMIT 1];// = 'Scheduling'];
        
         
            if(kickOffPS.project__c !=null) {
                if(kickOffPS.project__r.series__r.Wombat_Series_ID__c!=null)
                    update(x);
                else {  if(kickOffPS.project__r.title__c!=null)
                        if(kickOffPS.project__r.title__r.Status__c == 'Contracted' && kickOffPS.status__c == 'Scheduled')// && censharekickOffPS)   // for time being censhare kick off status not required    
                        update(x);
                     }
            }
            kres.psRec = projectservicesquery1(x.id);
            return kres;
    
    }
    
   @AuraEnabled public static void forceKickOffService(project_services__c x, String forceKickOffReason) {
        date timeStamp = date.today();
       
        x.Status__c = 'Kicked Off';
        x.Force_Kickoff_Reason__c = forceKickOffReason;
        x.has_been_kicked_off__c = true;
        x.Actual_Start_Date__c = timeStamp;
        //calloutStatusRes csr
        calloutStatusRes csr = censhareServerUpdate(x);
         if(csr.censhareStatus) 
             update(x); 
     
    }
    
    
     // check one more promotinal text service exist or not
    public static boolean promotionalTextService(String projectId) {
        
        List<project_services__c> psLst = [SELECT id,Service__r.Name FROM project_services__c WHERE Service__r.Name like 'Promo Text Creation' AND Project__c =: ProjectId];
        if(!psLst.isEmpty()) {
            if(psLst.size() == 1)
                return false;
            else
                return true;     
        } else
              return false;
    }
    
       //Roles who can modify amount in PS with custom rate amount and have access to Kill Service functionality
    public static String killServiceRolesSet { 
        get{
            return label.PPW_vmKillService; 
        } set;
    } 
    
       // Roles who can modify amount in Ps with custom rate amount
    public static String amountChangeRolesSet { 
        get{ 
            return label.PPW_MmKillService; // super user whoe have access do change the amount in ps
        } set;
    }
     public static boolean digitPatternCheck(String str) { 
        if(!String.isBlank(str)) { 
            Pattern p = Pattern.compile('\\d+.\\d+'); 
            Matcher m = p.matcher(str); 
            return m.matches(); 
        } else return false; 
    } 
     public static map<id, Service__c> allServiceDetailsMap{
        get{
            map<id, Service__c> tempMap = new map<id, Service__c>([SELECT id, name, Service_rate_Type__c, description__c,Wiki_Additional_Information__c, Censhare_Template_ID__c, Service_complexity_value__c FROM Service__c]);
            return tempMap;
        }
        set;
    }
    
    
    
  public class projectservicesResponse {
     @AuraEnabled public list<String> statusKeys{get;set;}
     @AuraEnabled public map<String,map<string,set<String>>> serviceRateType {get;set;}//= new map<String,map<string,set<String>>>();
     @AuraEnabled public string serviceActionType{get;set;}
      @AuraEnabled  public string prodLocale {get;set;}
      @AuraEnabled  public string projectID;
     @AuraEnabled   public string titleID;
      @AuraEnabled  public string currentTabPs{get;set;}
      @AuraEnabled  public string currentTabName{get;set;}
      @AuraEnabled  public string currentTabId{get;set;} 
      @AuraEnabled  public string collapsTargetAll{get;set;} // get collapse target all ID's for open All or close All link 
      @AuraEnabled  public List<string> activePsIds{get;set;} 
      @AuraEnabled  public List<string> completePsIds = new List<string>();
     // @AuraEnabled  public List<string> cancelPsIds{get {return cancelPsIds;}set;}
     @AuraEnabled  public List<string> cancelPsIds = new List<string>();
      @AuraEnabled  public string openedPanelPs{get;set;}
      @AuraEnabled  public set<string> confirmationTblHeaders{get;set;}
      @AuraEnabled  public string openConfirmation{get;set;} // open confirmation field
      @AuraEnabled  public string createConfirmation{get;set;} // open confirmation field 
       @AuraEnabled public set<string> openedPanels{get { return openedPanels;}set;}
      @AuraEnabled  public String rateAmount{get;set;} // value used to change custom quote rate amount
      @AuraEnabled  public String psAmount{get;set;} // ps amount changed by VM/MM superuser functionality
       @AuraEnabled public String textAreaTemp{get;set;}
        @AuraEnabled  public project_services__c tps {get;set;} // 'this' project service for the current version
     @AuraEnabled public boolean censhareConnectPsUpdate {get {return censhareConnectPsUpdate;}
                                            set;}
   
    @AuraEnabled public project__c p{get;set;}
      @AuraEnabled public boolean cConnectPsUpdateStop {get { return cConnectPsUpdateStop;}
                                            set;}                                        
                                            
     @AuraEnabled public integer psInplanningCount{get;set;}
     @AuraEnabled public project_services__c ops {get;set;} // 'old' project service for comparisons
      @AuraEnabled public project_services__c thisProjectService {get;set;}
    
      @AuraEnabled public boolean api_error {get;set;}
      @AuraEnabled public string api_message {get;set;}
      @AuraEnabled public String killServiceRolesSet { 
        get{
            return label.PPW_vmKillService; 
        } set;
    } 
        
    //Active status values
   @AuraEnabled public string activeSet{
        get{
            return label.Project_Service_Active_Status;
        }
        set;
    }
    //Completed status values
   @AuraEnabled public string completedSet{
        get{
            return label.Project_Service_Completed_Status;
        }
        set;
    }
    //Cancelled Status Values
   @AuraEnabled public string CancelledSet{
        get{
            return label.Project_Service_Cancelled_Status;
        }
        set;
    }
      //Navigation ID Variables
   @AuraEnabled public string cbid{
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
   @AuraEnabled public string spid{
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
    
     @AuraEnabled public integer activeCount {get; set;}
   @AuraEnabled public integer completedCount {get; set;}
   @AuraEnabled  public integer cancelledCount {get; set;}
  
     @AuraEnabled public string serviceSelection {get; set;}
   @AuraEnabled public string serviceTypeSelection {get; set;}
   @AuraEnabled public String serviceVendorselection{get;set;}
    
   @AuraEnabled public string serviceDescription {get; set;}
   @AuraEnabled public string externalVendorNote {get; set;}
   @AuraEnabled public string externalVendorNoteLong {get; set;}
   @AuraEnabled public string internalVendorNote {get; set;}
   @AuraEnabled public decimal rushFee{get;set;}
    
   @AuraEnabled public vendor__c vendorRecord {get; set;}
   @AuraEnabled public rate__c rateRecord {get; set;}
   @AuraEnabled public service__c serviceRecord {get; set;}
   @AuraEnabled public boolean vendorDisabled{get;set;}
    
   @AuraEnabled public string estStartDate {get; set;}
   @AuraEnabled public String vendorNoteRichText{get; set;} 
   @AuraEnabled public string estCompletedDate {get; set;}
   @AuraEnabled public string accStartDate {get; set;}
   @AuraEnabled public string accCompletedDate {get; set;}
    
    @AuraEnabled public boolean honorDependencies {get; set;}
    
    //Service Action Modal option Lists
   @AuraEnabled public list<selectOption> serviceGroupOptions {get; set;}
   @AuraEnabled public list<selectOption> serviceTypeOptions {
        get{
            list<selectOption> tempSOList = new list<selectOption>();
           // tempSOList = loadServiceTypeOptions(serviceSelection);
            return tempSOList;
        }
        set;
    }
   @AuraEnabled public list<selectOption> serviceVendorOptions {
        get{
            list<selectOption> tempSOList = new list<selectOption>();
           // tempSOList = loadServiceVendorOptions(serviceSelection, serviceTypeSelection);
            return tempSOList;
        }
        set;
    }
    
 
   
      @AuraEnabled   public map<String,set<String>> serviceNames{get;set;}
   // public map<String,map<string,set<String>>>    serviceRateType{get;set;}
   @AuraEnabled  public boolean confirmationButtonCheck {get; set;}
   @AuraEnabled  public boolean confirmationTableCheck {get; set;}
   @AuraEnabled  public boolean rushFeeFlg{get; set;} 
   @AuraEnabled  public map<string, map<string, map<string,list<projectServiceWrapper>>>> psMegaMap {
        get;
        set;
    }
  }
  
   public list<String> statusKeys{get;set;}
    public class projectServiceWrapper{
        @AuraEnabled public project_services__c ps {get; set;}
        @AuraEnabled  public list<string> serviceAlerts {get; set;}
        @AuraEnabled  public boolean editCheck {get;set;}
        @AuraEnabled  public boolean confirmationCheck {get;set;}
        @AuraEnabled  public boolean kickOffCheck {get;set;}         
        @AuraEnabled public boolean cancelCheck {get;set;}
        @AuraEnabled  public boolean ptfCheck {get;set;}
        @AuraEnabled  public boolean completeCheck {get;set;}
      //  @AuraEnabled public  
            }
      @AuraEnabled
   public static List<Confirmation__c> getAllConfirmation(String psRec) {
       
        list<confirmation__c> allCons1 = new list<confirmation__c>();
        Map<integer, confirmation__c> allCons2 = new Map<integer ,confirmation__c>();
      
         allCons1 = [SELECT id, name, confirmation__c, Project_Services__r.Status__c, Status__c, Confirmed_Amount__c, Confirmed_Rate_Amount__c ,
                             Confirmed_Service__c, Confirmed_Vendor__c,Confirmed_Rush_Fee__c, date_of_confirmation__c, 
                             rejection_reason__c, createdDate,Reason_for_Review__c,open_confirmation__c,Confirmed_Base_Amount__c,
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
    
   
    
    
    
     //Create a new confirmation...
   @AuraEnabled public static void createConfirmation(project_services__c ps, String ConfirmationText) {
        boolean censhareFlg = false;
        calloutStatusRes csr;
   
        if(ps.Status__c != 'Confirming')
            censhareFlg = true;
        if(ps.Service_Name__c == 'Promo Text Creation' && ps.Master_PT_Service__c == false) 
            censhareFlg = false;
         
        if(censhareFlg && ps.Has_Been_Kicked_Off__c == false) { //has been kicked off false
            ps.Status__c = 'Confirming';
            ps.Censhare_XML_update_type__c = 'Update'; 
          
              csr = censhareServerUpdate(ps);
         
            if(csr.censhareStatus) {
          
            ps = [SELECT id,Status__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,Word_Count_Completed__c, 
                  Word_Count_Cancelled__c,Amount__c,Base_Amount__c,Rate_Amount__c,Base_Amount_with_Currency__c,Rate_Currency__c,MBO_Fee__c,Rush_Fee__c,Total_Rate_Amount__c,
                  Service__r.Service_rate_type__c,Vendor__r.name,MBO_Fee_with_Currency__c,(select id from Confirmation__r where status__c = 'Open')
                  FROM project_services__c WHERE id =: ps.id]; 
                if(ps.Confirmation__r.isEmpty()) {
            confirmation__c cnew = new confirmation__c(
                project_services__c=ps.id,
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
         
           } 
       
       } else { // has been kicked off true section
         
         
            ppw_handlerforCalculation rates1 = new ppw_handlerforCalculation();
            List<Project_Services__c> psLst = rates1.ratecalc(new List<Project_Services__c> {ps});
            update psLst; 
            
              String ConfirmationText1 = ConfirmationText;//openConfirmation!= '' ? openConfirmation : createConfirmation!=null ? createConfirmation:''; 
            ps = [SELECT id,Status__c,Word_Count_In_Planning__c,(select id from Confirmation__r where status__c = 'Open'),Word_Count_Confirming__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,Word_Count_Completed__c, 
                  Word_Count_Cancelled__c,Amount__c,Base_Amount__c,Rate_Amount__c,Base_Amount_with_Currency__c,Rate_Currency__c,MBO_Fee__c,Rush_Fee__c,Total_Rate_Amount__c,
                  Service__r.Service_rate_type__c,Vendor__r.name,MBO_Fee_with_Currency__c,Service_Name__c ,Master_PT_Service__c,Has_Been_Kicked_Off__c
                  FROM project_services__c WHERE id =: ps.id]; 
            confirmation__c cnew = new confirmation__c(
                project_services__c=ps.id,
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
          
        }   
       }
    
    // create bundle service container
      @AuraEnabled public static List<calloutStatusRes> createbundleService(List<project_services__c> psList) {
          system.debug(psList);
            for(project_services__c ps: psList) {
                
            }
          return null;
      }
    
     //Create a new confirmation...
   @AuraEnabled public static List<calloutStatusRes> createBulkConfirmation(List<project_services__c> psList) {
        boolean censhareFlg = false;
        Map<String,calloutStatusRes> csrMap = new Map<String,calloutStatusRes>();
        List<project_services__c> psListconsolidate = new List<project_services__c>();
         
         List<confirmation__c> conList = new List<confirmation__c>();
      
       Map<String,project_services__c> psMap = new Map<String,project_services__c>([SELECT id,(select id from Confirmation__r where status__c = 'Open')
                  FROM project_services__c WHERE id =: psList]);
       
       
        for(project_services__c ps: psList) {
            if(ps.Status__c != 'Confirming')
                censhareFlg = true;
            if(ps.Service_Name__c == 'Promo Text Creation' && ps.Master_PT_Service__c == false) 
                censhareFlg = false;
             
            if(censhareFlg && ps.Has_Been_Kicked_Off__c == false) { //has been kicked off false
                ps.Status__c = 'Confirming';
                ps.Censhare_XML_update_type__c = 'Update'; 
                psListconsolidate.add(ps);
             } 
         }  
         if(!psListconsolidate.isEmpty()) {
              csrMap = censhareBulkServerUpdate(psListconsolidate);
              system.debug(csrMap);
              system.debug(psListconsolidate);
              for(project_services__c ps: psListconsolidate) {
              calloutStatusRes csr = csrMap.get(ps.id);
         
            if(csr.censhareStatus) {
          
           /* ps = [SELECT id,Status__c,Word_Count_In_Planning__c,Word_Count_Confirming__c,Word_Count_Scheduled__c,Word_Count_Kicked_Off__c,Word_Count_Completed__c, 
                  Word_Count_Cancelled__c,Amount__c,Base_Amount__c,Rate_Amount__c,Base_Amount_with_Currency__c,Rate_Currency__c,MBO_Fee__c,Rush_Fee__c,Total_Rate_Amount__c,
                  Service__r.Service_rate_type__c,Vendor__r.name,MBO_Fee_with_Currency__c,(select id from Confirmation__r where status__c = 'Open')
                  FROM project_services__c WHERE id =: ps.id]; */
                if(ps.Confirmation__r.isEmpty()) {
            confirmation__c cnew = new confirmation__c(
                project_services__c=ps.id,
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
               // open_confirmation__c = ConfirmationText,
                Confirmed_Word_Count__c = getPredevValue(ps)//ps.Word_Count_Confirming__c
            );
            
            conList.add(cnew);
           // insert(cnew);
                }
          
           } 
       
       } 
     }
       insert conList;
       return csrMap.values();
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
    
    
    
  @AuraEnabled public static calloutStatusRes cancelService(project_services__c x, string cancelSelection) {
       // errorCancelCheck=false;
       // cancelStatusFlg = false;
      calloutStatusRes csr = new calloutStatusRes();
        //project_services__c x = new project_services__c(); 
        project_services__c y;// = new project_services__c(); 
        //x = allProjectServiceMap.get(psRec);
       // if(cancelSelection == 'None' ){
           // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Please select an option.'));
            //errorCancelCheck=true;
        //}
        
        if(cancelSelection == '1') {
            x.Status__c = 'Cancelled';
            x.Censhare_XML_update_type__c = 'Update';  
           // updateList.add(x);
        }
        
        if(cancelSelection == '2') {
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
        //system.debug(errorCancelCheck);
        
       
              if(x!=null) { 
              boolean promotext = false; 
              if(x.Service_Name__c == 'Promo Text Creation' && x.Master_PT_Service__c == false) 
                  promotext = true; // secondary promo text 
              boolean censhareUpdateStatus = false; 
              if(promotext == false) 
                   csr = censhareServerUpdate(x);
                  if(censhareUpdateStatus == true || promotext == true) { // when censhare update is true or secondary promo text service update 
                  
                      Group gp;   // for time being commented
                      String defaultOwnerid;
                      String prodLocale = x.project__r.Title__r.Production_Locale__c;
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
                            }
                     
                      if(y != null) {
                          insert y;    
                          censhareServerInsert(y);
                          csr.psRecord = y;
                       
                      }
                   
           return csr;  
    }
    
     private static void censhareServerInsert(project_services__c cPS) {
        if(cPS != null) {
            try { 
           ppw_censhareConnector ppwCen = new ppw_censhareConnector();
             String xml = ppwCen.censhareXMLBuilder(new List<project_services__c>{cPS});
            system.debug('xml'+xml);
            //if(!test.isrunningTest())
            ppw_censhareConnector.censhareService(xml,cPS.id); 
               // pollerEnabled = true; 
               // censhareStatus = true; 
            } catch(Exception e) {
                //delete tps;
            } 
        } 
   
   }
   
   @AuraEnabled public static List<project_services__c> getservices(String projectId) {
   system.debug(projectId);
       return projectservicesquery(projectID);
   
   }
   
   
   
   
   @AuraEnabled public static map<string, map<string, map<String,list<projectServiceWrapper>>>> getterpsMegaMap(String projectId) {
        projectservicesResponse psres = new projectservicesResponse();
        psres.statusKeys = new  list<String>();
        psres.activePsIds = new List<string>();
        psres.p = [SELECT id,title__r.production_locale__c, title__c, title__r.marty_title_id__c from project__c where id=:projectID];
        psres.serviceRateType = new map<String,map<string,set<String>>>();
        psres.serviceNames = new map<String,set<String>>();
        set<string> activeSet = new set<string>();
        set<string> completedSet = new set<string>();
        set<string> cancelledSet = new set<string>();
        psres.activeCount=0;
        psres.completedCount=0;
        psres.cancelledCount=0;           
        
        map<string, map<string, map<string,list<projectServiceWrapper>>>> tempMegaMap = new map<string, map<string, map<String,list<projectServiceWrapper>>>>();
        map<string, map<string,list<projectServiceWrapper>>> activeInteriorMap = new map<string, map<string,list<projectServiceWrapper>>>();
        map<string, map<string,list<projectServiceWrapper>>> completeInteriorMap = new map<string, map<string,list<projectServiceWrapper>>>();
        map<string, map<string,list<projectServiceWrapper>>> cancelledInteriorMap = new map<string, map<string,list<projectServiceWrapper>>>();
        
        activeSet.addAll(label.Project_Service_Active_Status.split(','));
        completedSet.addAll(label.Project_Service_Completed_Status.split(','));
        cancelledSet.addAll(label.Project_Service_Cancelled_Status.split(','));
        
        list<project_services__c> serviceList = new list<project_services__c>(projectservicesquery(projectID)
        );
        // psInplanningCount = psLst.size();
        system.debug(activeSet);
         integer inplanningCount =0;
       //getBudnlerInformation()
       Set<String> budlerIds = new Set<String>();
        if(!serviceList.isEmpty())   
            for(project_services__c ps : serviceList) 
                if(String.isNotBlank(ps.Bundled_Container__c))
                    budlerIds.add(ps.Bundled_Container__c);
            
       
       
       
        if(!serviceList.isEmpty()) {  
            for(project_services__c ps : serviceList) {
           system.debug(ps.status__c);
                if(ps.status__c == 'In Planning')
                    inplanningCount = inplanningCount +1;
                
                addInteriorMap(activeSet,ps,activeInteriorMap);
                addInteriorMap(completedSet,ps,completeInteriorMap);
                addInteriorMap(cancelledSet,ps,cancelledInteriorMap);
                
            } //close the inner builder
        }//close the main if statement
       // psInplanningCount = inplanningCount;
     //  system.debug(activeInteriorMap);
      //  system.debug('activeInteriorMap: '+activeInteriorMap.get('Art and Illustrations'));
        
        if(!activeInteriorMap.isEmpty()) {
            psres.statusKeys.add('Active');
            tempMegaMap.put('Active', activeInteriorMap);
            
            for(String s: activeInteriorMap.keyset()) {
                if(psres.serviceRateType.containsKey('Active')){
                    if(psres.serviceRateType.get('Active').containsKey(s)) {
                        //  serviceRateType.get('Active').get(s).addall(activeInteriorMap.keyset());//new map<String,set<string>>{s=>activeInteriorMap.keyset()});    
                    }  else
                        if(s!=null)
                        psres.serviceRateType.get('Active').put(s, activeInteriorMap.get(s).keyset());
                } else
                    if(s!=null)
                    psres.serviceRateType.put('Active',new map<String,set<string>>{s=>activeInteriorMap.get(s).keyset()});
                if(psres.serviceNames.containskey('Active'))
                    psres.serviceNames.get('Active').add(s);
                else            
                    psres.serviceNames.put('Active', new set<String>{s});
                
             }
        }
        
        
        if(!completeInteriorMap.isEmpty()) {
            psres.statusKeys.add('Completed');
            
            for(String s: completeInteriorMap.keyset()) {
                if(psres.serviceRateType.containsKey('Completed')) {
                    if(psres.serviceRateType.get('Completed').containsKey(s)) {
                        //psres.serviceRateType.get('Completed').get(s).addall(completeInteriorMap.keyset());//new map<String,set<string>>{s=>activeInteriorMap.keyset()});    
                    }else
                        psres.serviceRateType.get('Completed').put(s, completeInteriorMap.get(s).keyset());
                } else
                    psres.serviceRateType.put('Completed',new map<String,set<string>>{s=>completeInteriorMap.get(s).keyset()});
                
                if(psres.serviceNames.containskey('Completed'))
                    psres.serviceNames.get('Completed').add(s);
                else            
                    psres.serviceNames.put('Completed', new set<String>{s});
            }
            
            
            tempMegaMap.put('Completed', completeInteriorMap);
        }
        
        
        if(!cancelledInteriorMap.isEmpty()) {
            psres.statusKeys.add('Cancelled');
            // InteriorKeys.put('Cancelled',cancelledInteriorMap.keyset());
            
            for(String s: cancelledInteriorMap.keyset()) {
                if(psres.serviceRateType.containsKey('Cancelled')){
                    if(psres.serviceRateType.get('Cancelled').containsKey(s)) {
                        //    psres.serviceRateType.get('Cancelled').get(s).addall(cancelledInteriorMap.keyset());//new map<String,set<string>>{s=>activeInteriorMap.keyset()});    
                    } else
                        psres.serviceRateType.get('Cancelled').put(s, cancelledInteriorMap.get(s).keyset());
                } else
                    psres.serviceRateType.put('Cancelled',new map<String,set<string>>{s=>cancelledInteriorMap.get(s).keyset()});
                if(psres.serviceNames.containskey('Cancelled'))
                    psres.serviceNames.get('Cancelled').add(s);
                else            
                    psres.serviceNames.put('Cancelled', new set<String>{s});
            }
            tempMegaMap.put('Cancelled', cancelledInteriorMap);
        }
        
        System.debug('tempMegaMap'+tempMegaMap);
        psres.psMegaMap =  tempMegaMap;
        
        if(!tempMegaMap.isempty() && tempMegaMap.containsKey('Active'))
            for(String s: tempMegaMap.get('Active').keyset()) 
            for(string st : tempMegaMap.get('Active').get(s).keyset()) {
                psres.activeCount += tempMegaMap.get('Active').get(s).get(st).size();
                for(projectServiceWrapper pw: tempMegaMap.get('Active').get(s).get(st))
                    psres.activePsIds.add(pw.ps.id); 
            }
        if(!tempMegaMap.isempty() && tempMegaMap.containsKey('Completed'))
            for(String s: tempMegaMap.get('Completed').keyset())
            for(string st : tempMegaMap.get('Completed').get(s).keyset()) {
                psres.completedCount += tempMegaMap.get('Completed').get(s).get(st).size();
                for(projectServiceWrapper pw: tempMegaMap.get('Completed').get(s).get(st)) 
                    psres.completePsIds.add(pw.ps.id); 
            }
        if(!tempMegaMap.isEmpty() && tempMegaMap.containsKey('Cancelled'))
            for(String s: tempMegaMap.get('Cancelled').keyset()) 
            for(string st : tempMegaMap.get('Cancelled').get(s).keyset()){
                psres.cancelledCount += tempMegaMap.get('Cancelled').get(s).get(st).size();
                for(projectServiceWrapper pw: tempMegaMap.get('Cancelled').get(s).get(st)) 
                    psres.cancelPsIds.add(pw.ps.id); 
            }   
          
        return tempMegaMap;
        
    }
    
    public static List<Project_Services__c> projectservicesquery(String projectID) {
    
   return [
            SELECT id, name, Chatter_Count_Internal__c,Chatter_Count_External__c,Vendor_Notes_RT__c, Service__c, Service__r.name, Rate__r.name,Actual_Completion_Date__c,Actual_Start_Date__c, 
            service__r.Service_Grouping_String__c, Internal_Service_Notes__c,Estimated_Completion_Date__c,Estimated_Start_Date__c,service__r.Description__c, service__r.Wiki_Additional_Information__c,
            Status__c,Vendor__r.name,Vendor__r.Vendor_Status__c, Project__r.Title__r.Status__c, Service_Type_Complexity__c, service__r.service_rate_type__c,Rate_Amount__c, rush_fee__c, LastModifiedDate, LastModifiedBy.Name, 
            has_been_kicked_off__c,Amount__c,rate__r.Rate_Multiplier__c,rate__r.Rate_Amount__c,Base_Amount__c,Service_Name__c,
            Project__r.Series__r.Wombat_Series_ID__c, Project__r.Series__r.Series_Title__c,Bundled_Container__c, Bundled_Container__r.Bundled_Service_Name__c,  Bundled_PS__c,
            MBO_Fee__c,Total_Rate_Amount_with_MBO_Fee__c ,Total_Rate_Amount__c,User_Input_Rate_Amount__c,Master_PT_Service__c, project__r.title__r.production_locale__c,
            Base_Amount_with_Currency__c, Additional_Rate_Input__c, Honor_Dependencies__c, Custom_Quote_Amount__c ,MBO_Fee_with_Currency__c,project__c,
            project__r.title__c,project__r.title__r.Marty_Title_ID__c
            FROM Project_Services__c 
            WHERE Project__c=:projectID 
            ORDER BY estimated_start_date__c ASC NULLS LAST];
    
    }
    
     public static Project_Services__c projectservicesquery1(String psId) {
    
   return [
            SELECT id, name, Chatter_Count_Internal__c,Chatter_Count_External__c, Vendor_Notes_RT__c, Service__c, Service__r.name, Rate__r.name,Actual_Completion_Date__c,Actual_Start_Date__c, 
            service__r.Service_Grouping_String__c, Internal_Service_Notes__c,Estimated_Completion_Date__c,Estimated_Start_Date__c,service__r.Description__c,
            Status__c,Vendor__r.name,Vendor__r.Vendor_Status__c,Project__r.Title__r.Status__c, Service_Type_Complexity__c, service__r.service_rate_type__c,Rate_Amount__c, 
            rush_fee__c, LastModifiedDate, LastModifiedBy.Name, Bundled_Container__r.Bundled_Service_Name__c,
            has_been_kicked_off__c,Amount__c,rate__r.Rate_Multiplier__c,rate__r.Rate_Amount__c,Base_Amount__c,Service_Name__c,
            Project__r.Series__r.Wombat_Series_ID__c, Project__r.Series__r.Series_Title__c,Bundled_Container__c,Bundled_PS__c,
            MBO_Fee__c,Total_Rate_Amount_with_MBO_Fee__c ,Total_Rate_Amount__c,User_Input_Rate_Amount__c,Master_PT_Service__c, project__r.title__r.production_locale__c,
            Base_Amount_with_Currency__c, Additional_Rate_Input__c, Honor_Dependencies__c, Custom_Quote_Amount__c ,MBO_Fee_with_Currency__c,
            project__c,project__r.title__c,project__r.title__r.Marty_Title_ID__c
            FROM Project_Services__c 
            WHERE Id=:psId 
            ORDER BY estimated_start_date__c ASC NULLS LAST];
    
    }
    
    public static Map<String,Bundled_Project_Service__c> getBudnlerInformation(Set<String> bIds) {
   
       return new Map<String,Bundled_Project_Service__c>([SELECT Name FROM Bundled_Project_Service__c WHERE Id IN: bIds]);
    
    }
    
     public static projectServiceWrapper pswCreator(project_services__c px) {
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
    private static void addInteriorMap(set<string> statusSet,project_services__c ps, map<string, 
                                       map<string,list<projectServiceWrapper>>> interiorMap
                                      ) {
                                          projectServiceWrapper psw = new projectServiceWrapper();
                                          psw = pswCreator(ps);
                                          // getBudnlerInformation()
                                          
                                          if(statusSet.contains(ps.status__c)) { //we have an active service
                                              if(ps.Bundled_PS__c) { // add bundle project services
                                                  if(interiorMap.containsKey(ps.service__r.name)){
                                                      if(interiorMap.get(ps.service__r.name).containsKey(ps.service__r.Service_Rate_Type__c))
                                                          interiorMap.get(ps.service__r.name).get(ps.service__r.Service_Rate_Type__c).add(psw);
                                                      else
                                                          if(ps.service__r.Service_Rate_Type__c!=null) 
                                                          interiorMap.get(ps.service__r.name).put(ps.service__r.Service_Rate_Type__c, new List<projectServiceWrapper>{psw});       
                                                  } else
                                                      if(ps.service__r.name!=null && ps.service__r.Service_Rate_Type__c!=null) 
                                                      interiorMap.put(ps.service__r.name, new map<string,List<projectServiceWrapper>>{ps.service__r.Service_Rate_Type__c => new List<projectServiceWrapper>{psw}});       
                                              } else {
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
                                      }   
    
    public list<string> activeServiceGroups{ // list of active service groups
        get{
            return null;
        }
        set;
    }
    
   


}