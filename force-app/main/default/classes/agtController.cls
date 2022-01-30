/***********************************
Author: Amazon Apub // michatem@, kkolla@
Visualforce Page Extended:  Acquisition_Goal_Tracker
Description: Controller Extension for Acquisition_Goal_Tracker
************************************/

Public class agtController {
    
    public List<SelectOption> yearOptions{get;set;}
    //public List<SelectOption> internalImprintOptions{get;set;} //need to replace with custom get and a standard setter...
    public String yearSel{get;set;}
    public List<String> internalImprintsSel{get;set;}
    public static string val;
    public boolean summaryFlag{get;set;}
    public boolean dataFlag{get;set;}
    public boolean initializationFlag{get;set;}
    public boolean titleDetailsFlag{get;set;}
    
    public String tier{get;set;}
    public String month{get;set;}
    public list<Title__c> titleRecords{get;set;}
    public summaryRecord acqGoals{get;set;}
    
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public Map <String, Schema.SObjectField> fieldMap = schemaMap.get('Acquisition_Goals__c').getDescribe().fields.getMap();
    public Map <String, Schema.SObjectField> fieldMap1 = schemaMap.get('Title__c').getDescribe().fields.getMap();
    
    public Acquisition_Goals__c acquisitionGoalRecord{get;set;}
    public Acquisition_Goals__c acquisitionGoal{get;set;}
    
    public agtController(){ //constructor
        //set flags for UX/UI renderings
        summaryFlag = false;
        dataFlag = false;
        initializationFlag = true;
        titleDetailsFlag = false;
        
        //set the year to the current calendar year for the dropdown. 
        yearSel = String.valueOf(system.today().year());
        
        set<String> yearOpts = new set<String>();
        yearOptions = new List<SelectOption>();    /* get Year picklist values using global describe schema model */
        for(Acquisition_Goals__c impVal : [SELECT Year_as_Number__c FROM Acquisition_Goals__c ORDER BY Year_as_Number__c ASC LIMIT 49999]) 
            yearOpts.add(String.valueOf(impVal.Year_as_Number__c));
        for(String s: yearOpts) 
            yearOptions.add(new SelectOption(s, s));
    }
    
    //catlogExportMethod
    
    public void catlogExport()
    {
        //agtExportCsvFuture agt = new agtExportCsvFuture();
        //agt.formCSV(yearSel);
        val=yearSel;
        agtExportCsvFuture.formCSV(val);
    }
    
    //save method for single AGT
    //should save the new values, and reRender the data
    
    public void saveAGT()
    {
        try{
            update(acquisitionGoalRecord);
        }catch(exception e){
            
        }
        
    }
    
    
    //Internal Imprint Filter based on Year
    
    // get/set for the imprint options select list
    public List<SelectOption> internalImprintOptions{
        get {
            List<SelectOption> imprintSelectOptions = new List<SelectOption>();
            if( yearSel != null ){
                integer agYearval = Integer.valueOf(yearSel); 
                for(Acquisition_Goals__c  impVal : [SELECT id, Internal_Imprint__c FROM  Acquisition_Goals__c WHERE Year_as_Number__c = :agYearval and Internal_Imprint__c!= null and Internal_Imprint__c!='' ORDER BY Internal_Imprint__c ASC]){
                    imprintSelectOptions.add(new SelectOption(impVal.Internal_Imprint__c, impVal.Internal_Imprint__c));
                    System.debug('imprintLoop: '+imprintSelectOptions);
                }
                System.debug('Year: '+agYearVal+ ' | Returned List: '+imprintSelectOptions);
                return imprintSelectOptions;
            }
            return imprintSelectOptions;
        }
        //standard setter
        set;
    }       
    
    public void getBgSummary(){
        //for getBGSummary(), it needs to identify:
        //How many imprints are being selected by the user in the UX? If there is only one then the following should happen:
        //We query the AGT object to obtain the actual goal record that the user can then edit on the page. This will allow <apex:inputField> mappings to those "Planned" goal values, and an easy save method.
        //We always want to run the wrapper class roll-ups regardless of how many imprints are selected by the user because those fields are read only and this will allow for only 1 row of each table to be dynamic, not the entire tables. Easier markup on the VF side...
        
        initializationFlag = false; //remove the greeting card and render the data tables
        
        list<Acquisition_Goals__c> acquisitionGoallist = new list<Acquisition_Goals__c>();
        String query = 'SELECT ';
        if(yearSel!=null && internalImprintsSel!=null){ //we have values for both the year and imprint
            integer agYearval = Integer.valueOf(yearSel); // here we should use convert text to integer, this should required for querying recrods
            for(String sfield : fieldMap.keyset()){
                query = query+sfield+',';
            }
            query = query.removeend(',');  // Dynamic Query String, it has all the field values using schema describe
            System.debug('query'+query);
            System.debug('internalImprintsSel'+internalImprintsSel);
            
            /* Acquistion object dymanic query **/
            query = query+' FROM Acquisition_Goals__c WHERE Year_as_Number__c = '+agYearval+' AND Internal_Imprint__c =:internalImprintsSel';
            System.debug('query'+query);
            system.debug(internalImprintsSel.size());
            {
                //check how many imprints are selected, if there are only 1 then fill in the solo record acquisitionGoalRecord, and flag the VF page accordingly
                if(internalImprintsSel.size()==1){
                    acquisitionGoalRecord = new Acquisition_Goals__c();
                    acquisitionGoalRecord = database.query(query);
                    dataFlag = true;
                    summaryFlag = false;
                }else{ // multi selection internal imprint
                    summaryFlag = true;
                    dataFlag = false;
                }
                system.debug('dataFlag:'+dataFlag+' || summaryFlag:'+summaryFlag); //double-check that the flags are correct...
                acquisitionGoallist = database.query(query);
                acqGoals = new summaryRecord();
                for(Acquisition_Goals__c aq: acquisitionGoallist){
                    //A+ Tier Roll-Ups
                    { 
                        //Finance/Business Goal Numbers
                        acqGoals.apjanT = acqGoals.apjanT+(aq.Business_Goal_Ap1__c!=null?aq.Business_Goal_Ap1__c:0);
                        acqGoals.apfebT = acqGoals.apfebT+(aq.Business_Goal_Ap2__c!=null?aq.Business_Goal_Ap2__c:0);
                        acqGoals.apmarT = acqGoals.apmarT+(aq.Business_Goal_Ap3__c!=null?aq.Business_Goal_Ap3__c:0);
                        acqGoals.apaprT = acqGoals.apaprT+(aq.Business_Goal_Ap4__c!=null?aq.Business_Goal_Ap4__c:0);
                        acqGoals.apmayT = acqGoals.apmayT+(aq.Business_Goal_Ap5__c!=null?aq.Business_Goal_Ap5__c:0);
                        acqGoals.apjuneT = acqGoals.apjuneT+(aq.Business_Goal_Ap6__c!=null?aq.Business_Goal_Ap6__c:0);
                        acqGoals.apjulyT = acqGoals.apjulyT+(aq.Business_Goal_Ap7__c!=null?aq.Business_Goal_Ap7__c:0);
                        acqGoals.apaugT = acqGoals.apaugT+(aq.Business_Goal_Ap8__c!=null?aq.Business_Goal_Ap8__c:0);
                        acqGoals.apsepT = acqGoals.apsepT+(aq.Business_Goal_Ap9__c!=null?aq.Business_Goal_Ap9__c:0);
                        acqGoals.apoctT = acqGoals.apoctT+(aq.Business_Goal_Ap10__c!=null?aq.Business_Goal_Ap10__c:0);
                        acqGoals.apnovT = acqGoals.apnovT+(aq.Business_Goal_Ap11__c!=null?aq.Business_Goal_Ap11__c:0);
                        acqGoals.apdecT = acqGoals.apdecT+(aq.Business_Goal_Ap12__c!=null?aq.Business_Goal_Ap12__c:0);
                        
                        //Live/Planned Goal Numbers
                        acqGoals.apjanLG = acqGoals.apjanLG+(aq.Live_Goal_Ap1__c!=null?aq.Live_Goal_Ap1__c:0);
                        acqGoals.apfebLG = acqGoals.apfebLG+(aq.Live_Goal_Ap2__c!=null?aq.Live_Goal_Ap2__c:0);
                        acqGoals.apmarLG = acqGoals.apmarLG+(aq.Live_Goal_Ap3__c!=null?aq.Live_Goal_Ap3__c:0);
                        acqGoals.apaprLG = acqGoals.apaprLG+(aq.Live_Goal_Ap4__c!=null?aq.Live_Goal_Ap4__c:0);
                        acqGoals.apmayLG = acqGoals.apmayLG+(aq.Live_Goal_Ap5__c!=null?aq.Live_Goal_Ap5__c:0);
                        acqGoals.apjuneLG = acqGoals.apjuneLG+(aq.Live_Goal_Ap6__c!=null?aq.Live_Goal_Ap6__c:0);
                        acqGoals.apjulyLG = acqGoals.apjulyLG+(aq.Live_Goal_Ap7__c!=null?aq.Live_Goal_Ap7__c:0);
                        acqGoals.apaugLG = acqGoals.apaugLG+(aq.Live_Goal_Ap8__c!=null?aq.Live_Goal_Ap8__c:0);
                        acqGoals.apsepLG = acqGoals.apsepLG+(aq.Live_Goal_Ap9__c!=null?aq.Live_Goal_Ap9__c:0);
                        acqGoals.apoctLG = acqGoals.apoctLG+(aq.Live_Goal_Ap10__c!=null?aq.Live_Goal_Ap10__c:0);
                        acqGoals.apnovLG = acqGoals.apnovLG+(aq.Live_Goal_Ap11__c!=null?aq.Live_Goal_Ap11__c:0);
                        acqGoals.apdecLG = acqGoals.apdecLG+(aq.Live_Goal_Ap12__c!=null?aq.Live_Goal_Ap12__c:0);
                        
                        //Acquired Goal Numbers
                        acqGoals.apjanAG= acqGoals.apjanAG+(aq.Acquired_Titles_ap1__c!=null?aq.Acquired_Titles_ap1__c:0);
                        acqGoals.apfebAG= acqGoals.apfebAG+(aq.Acquired_Titles_ap2__c!=null?aq.Acquired_Titles_ap2__c:0);
                        acqGoals.apmarAG= acqGoals.apmarAG+(aq.Acquired_Titles_ap3__c!=null?aq.Acquired_Titles_ap3__c:0);
                        acqGoals.apaprAG= acqGoals.apaprAG+(aq.Acquired_Titles_ap4__c!=null?aq.Acquired_Titles_ap4__c:0);
                        acqGoals.apmayAG= acqGoals.apmayAG+(aq.Acquired_Titles_ap5__c!=null?aq.Acquired_Titles_ap5__c:0);
                        acqGoals.apjuneAG= acqGoals.apjuneAG+(aq.Acquired_Titles_ap6__c!=null?aq.Acquired_Titles_ap6__c:0);
                        acqGoals.apjulyAG= acqGoals.apjulyAG+(aq.Acquired_Titles_ap7__c!=null?aq.Acquired_Titles_ap7__c:0);
                        acqGoals.apaugAG= acqGoals.apaugAG+(aq.Acquired_Titles_ap8__c!=null?aq.Acquired_Titles_ap8__c:0);
                        acqGoals.apsepAG= acqGoals.apsepAG+(aq.Acquired_Titles_ap9__c!=null?aq.Acquired_Titles_ap9__c:0);
                        acqGoals.apoctAG= acqGoals.apoctAG+(aq.Acquired_Titles_ap10__c!=null?aq.Acquired_Titles_ap10__c:0);
                        acqGoals.apnovAG= acqGoals.apnovAG+(aq.Acquired_Titles_ap11__c!=null?aq.Acquired_Titles_ap11__c:0);
                        acqGoals.apdecAG= acqGoals.apdecAG+(aq.Acquired_Titles_ap12__c!=null?aq.Acquired_Titles_ap12__c:0);
                        
                        
                        
                        //Progress Goal Numbers
                        acqGoals.apjanPG = acqGoals.apjanPG+(aq.Goal_Progress_ap1__c!=null?aq.Goal_Progress_ap1__c:0);
                        acqGoals.apfebPG = acqGoals.apfebPG+(aq.Goal_Progress_ap2__c!=null?aq.Goal_Progress_ap2__c:0);
                        acqGoals.apmarPG = acqGoals.apmarPG+(aq.Goal_Progress_ap3__c!=null?aq.Goal_Progress_ap3__c:0);
                        acqGoals.apaprPG = acqGoals.apaprPG+(aq.Goal_Progress_ap4__c!=null?aq.Goal_Progress_ap4__c:0);
                        acqGoals.apmayPG = acqGoals.apmayPG+(aq.Goal_Progress_ap5__c!=null?aq.Goal_Progress_ap5__c:0);
                        acqGoals.apjunePG = acqGoals.apjunePG+(aq.Goal_Progress_ap6__c!=null?aq.Goal_Progress_ap6__c:0);
                        acqGoals.apjulyPG = acqGoals.apjulyPG+(aq.Goal_Progress_ap7__c!=null?aq.Goal_Progress_ap7__c:0);
                        acqGoals.apaugPG = acqGoals.apaugPG+(aq.Goal_Progress_ap8__c!=null?aq.Goal_Progress_ap8__c:0);
                        acqGoals.apsepPG = acqGoals.apsepPG+(aq.Goal_Progress_ap9__c!=null?aq.Goal_Progress_ap9__c:0);
                        acqGoals.apoctPG = acqGoals.apoctPG+(aq.Goal_Progress_ap10__c!=null?aq.Goal_Progress_ap10__c:0);
                        acqGoals.apnovPG = acqGoals.apnovPG+(aq.Goal_Progress_ap11__c!=null?aq.Goal_Progress_ap11__c:0);
                        acqGoals.apdecPG = acqGoals.apdecPG+(aq.Goal_Progress_ap12__c!=null?aq.Goal_Progress_ap12__c:0);
                        
                        
                        //In Negotiation Goal Numbers
                        acqGoals.apjanIN = acqGoals.apjanIN+(aq.In_Negotiation_Titles_ap1__c!=null?aq.In_Negotiation_Titles_ap1__c:0);
                        acqGoals.apfebIN = acqGoals.apfebIN+(aq.In_Negotiation_Titles_ap2__c!=null?aq.In_Negotiation_Titles_ap2__c:0);
                        acqGoals.apmarIN = acqGoals.apmarIN+(aq.In_Negotiation_Titles_ap3__c!=null?aq.In_Negotiation_Titles_ap3__c:0);
                        acqGoals.apaprIN = acqGoals.apaprIN+(aq.In_Negotiation_Titles_ap4__c!=null?aq.In_Negotiation_Titles_ap4__c:0);
                        acqGoals.apmayIN = acqGoals.apmayIN+(aq.In_Negotiation_Titles_ap5__c!=null?aq.In_Negotiation_Titles_ap5__c:0);
                        acqGoals.apjuneIN = acqGoals.apjuneIN+(aq.In_Negotiation_Titles_ap6__c!=null?aq.In_Negotiation_Titles_ap6__c:0);
                        acqGoals.apjulyIN = acqGoals.apjulyIN+(aq.In_Negotiation_Titles_ap7__c!=null?aq.In_Negotiation_Titles_ap7__c:0);
                        acqGoals.apaugIN = acqGoals.apaugIN+(aq.In_Negotiation_Titles_ap8__c!=null?aq.In_Negotiation_Titles_ap8__c:0);
                        acqGoals.apsepIN = acqGoals.apsepIN+(aq.In_Negotiation_Titles_ap9__c!=null?aq.In_Negotiation_Titles_ap9__c:0);
                        acqGoals.apoctIN = acqGoals.apoctIN+(aq.In_Negotiation_Titles_ap10__c!=null?aq.In_Negotiation_Titles_ap10__c:0);
                        acqGoals.apnovIN = acqGoals.apnovIN+(aq.In_Negotiation_Titles_ap11__c!=null?aq.In_Negotiation_Titles_ap11__c:0);
                        acqGoals.apdecIN = acqGoals.apdecIN+(aq.In_Negotiation_Titles_ap12__c!=null?aq.In_Negotiation_Titles_ap12__c:0);
                        
                        //Pre-Acquisition Goal Numbers
                        acqGoals.apjanPA = acqGoals.apjanPA+(aq.Pre_Acquisition_Titles_ap1__c!=null?aq.Pre_Acquisition_Titles_ap1__c:0);
                        acqGoals.apfebPA = acqGoals.apfebPA+(aq.Pre_Acquisition_Titles_ap2__c!=null?aq.Pre_Acquisition_Titles_ap2__c:0);
                        acqGoals.apmarPA = acqGoals.apmarPA+(aq.Pre_Acquisition_Titles_ap3__c!=null?aq.Pre_Acquisition_Titles_ap3__c:0);
                        acqGoals.apaprPA = acqGoals.apaprPA+(aq.Pre_Acquisition_Titles_ap4__c!=null?aq.Pre_Acquisition_Titles_ap4__c:0);
                        acqGoals.apmayPA = acqGoals.apmayPA+(aq.Pre_Acquisition_Titles_ap5__c!=null?aq.Pre_Acquisition_Titles_ap5__c:0);
                        acqGoals.apjunePA = acqGoals.apjunePA+(aq.Pre_Acquisition_Titles_ap6__c!=null?aq.Pre_Acquisition_Titles_ap6__c:0);
                        acqGoals.apjulyPA = acqGoals.apjulyPA+(aq.Pre_Acquisition_Titles_ap7__c!=null?aq.Pre_Acquisition_Titles_ap7__c:0);
                        acqGoals.apaugPA = acqGoals.apaugPA+(aq.Pre_Acquisition_Titles_ap8__c!=null?aq.Pre_Acquisition_Titles_ap8__c:0);
                        acqGoals.apsepPA = acqGoals.apsepPA+(aq.Pre_Acquisition_Titles_ap9__c!=null?aq.Pre_Acquisition_Titles_ap9__c:0);
                        acqGoals.apoctPA = acqGoals.apoctPA+(aq.Pre_Acquisition_Titles_ap10__c!=null?aq.Pre_Acquisition_Titles_ap10__c:0);
                        acqGoals.apnovPA = acqGoals.apnovPA+(aq.Pre_Acquisition_Titles_ap11__c!=null?aq.Pre_Acquisition_Titles_ap11__c:0);
                        acqGoals.apdecPA = acqGoals.apdecPA+(aq.Pre_Acquisition_Titles_ap12__c!=null?aq.Pre_Acquisition_Titles_ap12__c:0);
                        
                    }
                    
                    
                    //A Tier Roll-Ups
                    { 
                        //Finance/Business Goal Numbers
                        acqGoals.ajanT = acqGoals.ajanT+(aq.Business_Goal_a1__c!=null?aq.Business_Goal_a1__c:0);
                        acqGoals.afebT = acqGoals.afebT+(aq.Business_Goal_a2__c!=null?aq.Business_Goal_a2__c:0);
                        acqGoals.amarT = acqGoals.amarT+(aq.Business_Goal_a3__c!=null?aq.Business_Goal_a3__c:0);
                        acqGoals.aaprT = acqGoals.aaprT+(aq.Business_Goal_a4__c!=null?aq.Business_Goal_a4__c:0);
                        acqGoals.amayT = acqGoals.amayT+(aq.Business_Goal_a5__c!=null?aq.Business_Goal_a5__c:0);
                        acqGoals.ajuneT = acqGoals.ajuneT+(aq.Business_Goal_a6__c!=null?aq.Business_Goal_a6__c:0);
                        acqGoals.ajulyT = acqGoals.ajulyT+(aq.Business_Goal_a7__c!=null?aq.Business_Goal_a7__c:0);
                        acqGoals.aaugT = acqGoals.aaugT+(aq.Business_Goal_a8__c!=null?aq.Business_Goal_a8__c:0);
                        acqGoals.asepT = acqGoals.asepT+(aq.Business_Goal_a9__c!=null?aq.Business_Goal_a9__c:0);
                        acqGoals.aoctT = acqGoals.aoctT+(aq.Business_Goal_a10__c!=null?aq.Business_Goal_a10__c:0);
                        acqGoals.anovT = acqGoals.anovT+(aq.Business_Goal_a11__c!=null?aq.Business_Goal_a11__c:0);
                        acqGoals.adecT = acqGoals.adecT+(aq.Business_Goal_a12__c!=null?aq.Business_Goal_a12__c:0);
                        
                        //Live/Planned Goal Numbers
                        acqGoals.ajanLG = acqGoals.ajanLG+(aq.Live_Goal_a1__c!=null?aq.Live_Goal_a1__c:0);
                        acqGoals.afebLG = acqGoals.afebLG+(aq.Live_Goal_a2__c!=null?aq.Live_Goal_a2__c:0);
                        acqGoals.amarLG = acqGoals.amarLG+(aq.Live_Goal_a3__c!=null?aq.Live_Goal_a3__c:0);
                        acqGoals.aaprLG = acqGoals.aaprLG+(aq.Live_Goal_a4__c!=null?aq.Live_Goal_a4__c:0);
                        acqGoals.amayLG = acqGoals.amayLG+(aq.Live_Goal_a5__c!=null?aq.Live_Goal_a5__c:0);
                        acqGoals.ajuneLG = acqGoals.ajuneLG+(aq.Live_Goal_a6__c!=null?aq.Live_Goal_a6__c:0);
                        acqGoals.ajulyLG = acqGoals.ajulyLG+(aq.Live_Goal_a7__c!=null?aq.Live_Goal_a7__c:0);
                        acqGoals.aaugLG = acqGoals.aaugLG+(aq.Live_Goal_a8__c!=null?aq.Live_Goal_a8__c:0);
                        acqGoals.asepLG = acqGoals.asepLG+(aq.Live_Goal_a9__c!=null?aq.Live_Goal_a9__c:0);
                        acqGoals.aoctLG = acqGoals.aoctLG+(aq.Live_Goal_a10__c!=null?aq.Live_Goal_a10__c:0);
                        acqGoals.anovLG = acqGoals.anovLG+(aq.Live_Goal_a11__c!=null?aq.Live_Goal_a11__c:0);
                        acqGoals.adecLG = acqGoals.adecLG+(aq.Live_Goal_a12__c!=null?aq.Live_Goal_a12__c:0);
                        
                        //Acquired Goal Numbers
                        acqGoals.ajanAG= acqGoals.ajanAG+(aq.Acquired_Titles_a1__c!=null?aq.Acquired_Titles_a1__c:0);
                        acqGoals.afebAG= acqGoals.afebAG+(aq.Acquired_Titles_a2__c!=null?aq.Acquired_Titles_a2__c:0);
                        acqGoals.amarAG= acqGoals.amarAG+(aq.Acquired_Titles_a3__c!=null?aq.Acquired_Titles_a3__c:0);
                        acqGoals.aaprAG= acqGoals.aaprAG+(aq.Acquired_Titles_a4__c!=null?aq.Acquired_Titles_a4__c:0);
                        acqGoals.amayAG= acqGoals.amayAG+(aq.Acquired_Titles_a5__c!=null?aq.Acquired_Titles_a5__c:0);
                        acqGoals.ajuneAG= acqGoals.ajuneAG+(aq.Acquired_Titles_a6__c!=null?aq.Acquired_Titles_a6__c:0);
                        acqGoals.ajulyAG= acqGoals.ajulyAG+(aq.Acquired_Titles_a7__c!=null?aq.Acquired_Titles_a7__c:0);
                        acqGoals.aaugAG= acqGoals.aaugAG+(aq.Acquired_Titles_a8__c!=null?aq.Acquired_Titles_a8__c:0);
                        acqGoals.asepAG= acqGoals.asepAG+(aq.Acquired_Titles_a9__c!=null?aq.Acquired_Titles_a9__c:0);
                        acqGoals.aoctAG= acqGoals.aoctAG+(aq.Acquired_Titles_a10__c!=null?aq.Acquired_Titles_a10__c:0);
                        acqGoals.anovAG= acqGoals.anovAG+(aq.Acquired_Titles_a11__c!=null?aq.Acquired_Titles_a11__c:0);
                        acqGoals.adecAG= acqGoals.adecAG+(aq.Acquired_Titles_a12__c!=null?aq.Acquired_Titles_a12__c:0);
                        
                        
                        
                        //Progress Goal Numbers
                        acqGoals.ajanPG = acqGoals.ajanPG+(aq.Goal_Progress_a1__c!=null?aq.Goal_Progress_a1__c:0);
                        acqGoals.afebPG = acqGoals.afebPG+(aq.Goal_Progress_a2__c!=null?aq.Goal_Progress_a2__c:0);
                        acqGoals.amarPG = acqGoals.amarPG+(aq.Goal_Progress_a3__c!=null?aq.Goal_Progress_a3__c:0);
                        acqGoals.aaprPG = acqGoals.aaprPG+(aq.Goal_Progress_a4__c!=null?aq.Goal_Progress_a4__c:0);
                        acqGoals.amayPG = acqGoals.amayPG+(aq.Goal_Progress_a5__c!=null?aq.Goal_Progress_a5__c:0);
                        acqGoals.ajunePG = acqGoals.ajunePG+(aq.Goal_Progress_a6__c!=null?aq.Goal_Progress_a6__c:0);
                        acqGoals.ajulyPG = acqGoals.ajulyPG+(aq.Goal_Progress_a7__c!=null?aq.Goal_Progress_a7__c:0);
                        acqGoals.aaugPG = acqGoals.aaugPG+(aq.Goal_Progress_a8__c!=null?aq.Goal_Progress_a8__c:0);
                        acqGoals.asepPG = acqGoals.asepPG+(aq.Goal_Progress_a9__c!=null?aq.Goal_Progress_a9__c:0);
                        acqGoals.aoctPG = acqGoals.aoctPG+(aq.Goal_Progress_a10__c!=null?aq.Goal_Progress_a10__c:0);
                        acqGoals.anovPG = acqGoals.anovPG+(aq.Goal_Progress_a11__c!=null?aq.Goal_Progress_a11__c:0);
                        acqGoals.adecPG = acqGoals.adecPG+(aq.Goal_Progress_a12__c!=null?aq.Goal_Progress_a12__c:0);
                        
                        
                        //In Negotiation Goal Numbers
                        acqGoals.ajanIN = acqGoals.ajanIN+(aq.In_Negotiation_Titles_a1__c!=null?aq.In_Negotiation_Titles_a1__c:0);
                        acqGoals.afebIN = acqGoals.afebIN+(aq.In_Negotiation_Titles_a2__c!=null?aq.In_Negotiation_Titles_a2__c:0);
                        acqGoals.amarIN = acqGoals.amarIN+(aq.In_Negotiation_Titles_a3__c!=null?aq.In_Negotiation_Titles_a3__c:0);
                        acqGoals.aaprIN = acqGoals.aaprIN+(aq.In_Negotiation_Titles_a4__c!=null?aq.In_Negotiation_Titles_a4__c:0);
                        acqGoals.amayIN = acqGoals.amayIN+(aq.In_Negotiation_Titles_a5__c!=null?aq.In_Negotiation_Titles_a5__c:0);
                        acqGoals.ajuneIN = acqGoals.ajuneIN+(aq.In_Negotiation_Titles_a6__c!=null?aq.In_Negotiation_Titles_a6__c:0);
                        acqGoals.ajulyIN = acqGoals.ajulyIN+(aq.In_Negotiation_Titles_a7__c!=null?aq.In_Negotiation_Titles_a7__c:0);
                        acqGoals.aaugIN = acqGoals.aaugIN+(aq.In_Negotiation_Titles_a8__c!=null?aq.In_Negotiation_Titles_a8__c:0);
                        acqGoals.asepIN = acqGoals.asepIN+(aq.In_Negotiation_Titles_a9__c!=null?aq.In_Negotiation_Titles_a9__c:0);
                        acqGoals.aoctIN = acqGoals.aoctIN+(aq.In_Negotiation_Titles_a10__c!=null?aq.In_Negotiation_Titles_a10__c:0);
                        acqGoals.anovIN = acqGoals.anovIN+(aq.In_Negotiation_Titles_a11__c!=null?aq.In_Negotiation_Titles_a11__c:0);
                        acqGoals.adecIN = acqGoals.adecIN+(aq.In_Negotiation_Titles_a12__c!=null?aq.In_Negotiation_Titles_a12__c:0);
                        
                        //Pre-Acquisition Goal Numbers
                        acqGoals.ajanPA = acqGoals.ajanPA+(aq.Pre_Acquisition_Titles_a1__c!=null?aq.Pre_Acquisition_Titles_a1__c:0);
                        acqGoals.afebPA = acqGoals.afebPA+(aq.Pre_Acquisition_Titles_a2__c!=null?aq.Pre_Acquisition_Titles_a2__c:0);
                        acqGoals.amarPA = acqGoals.amarPA+(aq.Pre_Acquisition_Titles_a3__c!=null?aq.Pre_Acquisition_Titles_a3__c:0);
                        acqGoals.aaprPA = acqGoals.aaprPA+(aq.Pre_Acquisition_Titles_a4__c!=null?aq.Pre_Acquisition_Titles_a4__c:0);
                        acqGoals.amayPA = acqGoals.amayPA+(aq.Pre_Acquisition_Titles_a5__c!=null?aq.Pre_Acquisition_Titles_a5__c:0);
                        acqGoals.ajunePA = acqGoals.ajunePA+(aq.Pre_Acquisition_Titles_a6__c!=null?aq.Pre_Acquisition_Titles_a6__c:0);
                        acqGoals.ajulyPA = acqGoals.ajulyPA+(aq.Pre_Acquisition_Titles_a7__c!=null?aq.Pre_Acquisition_Titles_a7__c:0);
                        acqGoals.aaugPA = acqGoals.aaugPA+(aq.Pre_Acquisition_Titles_a8__c!=null?aq.Pre_Acquisition_Titles_a8__c:0);
                        acqGoals.asepPA = acqGoals.asepPA+(aq.Pre_Acquisition_Titles_a9__c!=null?aq.Pre_Acquisition_Titles_a9__c:0);
                        acqGoals.aoctPA = acqGoals.aoctPA+(aq.Pre_Acquisition_Titles_a10__c!=null?aq.Pre_Acquisition_Titles_a10__c:0);
                        acqGoals.anovPA = acqGoals.anovPA+(aq.Pre_Acquisition_Titles_a11__c!=null?aq.Pre_Acquisition_Titles_a11__c:0);
                        acqGoals.adecPA = acqGoals.adecPA+(aq.Pre_Acquisition_Titles_a12__c!=null?aq.Pre_Acquisition_Titles_a12__c:0);
                        
                    }
                    
                    //B Tier Roll-Ups
                    { 
                        //Finance/Business Goal Numbers
                        acqGoals.bjanT = acqGoals.bjanT+(aq.Business_Goal_b1__c!=null?aq.Business_Goal_b1__c:0);
                        acqGoals.bfebT = acqGoals.bfebT+(aq.Business_Goal_b2__c!=null?aq.Business_Goal_b2__c:0);
                        acqGoals.bmarT = acqGoals.bmarT+(aq.Business_Goal_b3__c!=null?aq.Business_Goal_b3__c:0);
                        acqGoals.baprT = acqGoals.baprT+(aq.Business_Goal_b4__c!=null?aq.Business_Goal_b4__c:0);
                        acqGoals.bmayT = acqGoals.bmayT+(aq.Business_Goal_b5__c!=null?aq.Business_Goal_b5__c:0);
                        acqGoals.bjuneT = acqGoals.bjuneT+(aq.Business_Goal_b6__c!=null?aq.Business_Goal_b6__c:0);
                        acqGoals.bjulyT = acqGoals.bjulyT+(aq.Business_Goal_b7__c!=null?aq.Business_Goal_b7__c:0);
                        acqGoals.baugT = acqGoals.baugT+(aq.Business_Goal_b8__c!=null?aq.Business_Goal_b8__c:0);
                        acqGoals.bsepT = acqGoals.bsepT+(aq.Business_Goal_b9__c!=null?aq.Business_Goal_b9__c:0);
                        acqGoals.boctT = acqGoals.boctT+(aq.Business_Goal_b10__c!=null?aq.Business_Goal_b10__c:0);
                        acqGoals.bnovT = acqGoals.bnovT+(aq.Business_Goal_b11__c!=null?aq.Business_Goal_b11__c:0);
                        acqGoals.bdecT = acqGoals.bdecT+(aq.Business_Goal_b12__c!=null?aq.Business_Goal_b12__c:0);
                        
                        //Live/Planned Goal Numbers
                        acqGoals.bjanLG = acqGoals.bjanLG+(aq.Live_Goal_b1__c!=null?aq.Live_Goal_b1__c:0);
                        acqGoals.bfebLG = acqGoals.bfebLG+(aq.Live_Goal_b2__c!=null?aq.Live_Goal_b2__c:0);
                        acqGoals.bmarLG = acqGoals.bmarLG+(aq.Live_Goal_b3__c!=null?aq.Live_Goal_b3__c:0);
                        acqGoals.baprLG = acqGoals.baprLG+(aq.Live_Goal_b4__c!=null?aq.Live_Goal_b4__c:0);
                        acqGoals.bmayLG = acqGoals.bmayLG+(aq.Live_Goal_b5__c!=null?aq.Live_Goal_b5__c:0);
                        acqGoals.bjuneLG = acqGoals.bjuneLG+(aq.Live_Goal_b6__c!=null?aq.Live_Goal_b6__c:0);
                        acqGoals.bjulyLG = acqGoals.bjulyLG+(aq.Live_Goal_b7__c!=null?aq.Live_Goal_b7__c:0);
                        acqGoals.baugLG = acqGoals.baugLG+(aq.Live_Goal_b8__c!=null?aq.Live_Goal_b8__c:0);
                        acqGoals.bsepLG = acqGoals.bsepLG+(aq.Live_Goal_b9__c!=null?aq.Live_Goal_b9__c:0);
                        acqGoals.boctLG = acqGoals.boctLG+(aq.Live_Goal_b10__c!=null?aq.Live_Goal_b10__c:0);
                        acqGoals.bnovLG = acqGoals.bnovLG+(aq.Live_Goal_b11__c!=null?aq.Live_Goal_b11__c:0);
                        acqGoals.bdecLG = acqGoals.bdecLG+(aq.Live_Goal_b12__c!=null?aq.Live_Goal_b12__c:0);
                        
                        //Acquired Goal Numbers
                        acqGoals.bjanAG = acqGoals.bjanAG+(aq.Acquired_Titles_b1__c!=null?aq.Acquired_Titles_b1__c:0);
                        acqGoals.bfebAG = acqGoals.bfebAG+(aq.Acquired_Titles_b2__c!=null?aq.Acquired_Titles_b2__c:0);
                        acqGoals.bmarAG = acqGoals.bmarAG+(aq.Acquired_Titles_b3__c!=null?aq.Acquired_Titles_b3__c:0);
                        acqGoals.baprAG = acqGoals.baprAG+(aq.Acquired_Titles_b4__c!=null?aq.Acquired_Titles_b4__c:0);
                        acqGoals.bmayAG = acqGoals.bmayAG+(aq.Acquired_Titles_b5__c!=null?aq.Acquired_Titles_b5__c:0);
                        acqGoals.bjuneAG = acqGoals.bjuneAG+(aq.Acquired_Titles_b6__c!=null?aq.Acquired_Titles_b6__c:0);
                        acqGoals.bjulyAG = acqGoals.bjulyAG+(aq.Acquired_Titles_b7__c!=null?aq.Acquired_Titles_b7__c:0);
                        acqGoals.baugAG = acqGoals.baugAG+(aq.Acquired_Titles_b8__c!=null?aq.Acquired_Titles_b8__c:0);
                        acqGoals.bsepAG = acqGoals.bsepAG+(aq.Acquired_Titles_b9__c!=null?aq.Acquired_Titles_b9__c:0);
                        acqGoals.boctAG = acqGoals.boctAG+(aq.Acquired_Titles_b10__c!=null?aq.Acquired_Titles_b10__c:0);
                        acqGoals.bnovAG = acqGoals.bnovAG+(aq.Acquired_Titles_b11__c!=null?aq.Acquired_Titles_b11__c:0);
                        acqGoals.bdecAG = acqGoals.bdecAG+(aq.Acquired_Titles_b12__c!=null?aq.Acquired_Titles_b12__c:0);
                        
                        //Progress Goal Numbers
                        acqGoals.bjanPG = acqGoals.bjanPG+(aq.Goal_Progress_b1__c!=null?aq.Goal_Progress_b1__c:0);
                        acqGoals.bfebPG = acqGoals.bfebPG+(aq.Goal_Progress_b2__c!=null?aq.Goal_Progress_b2__c:0);
                        acqGoals.bmarPG = acqGoals.bmarPG+(aq.Goal_Progress_b3__c!=null?aq.Goal_Progress_b3__c:0);
                        acqGoals.baprPG = acqGoals.baprPG+(aq.Goal_Progress_b4__c!=null?aq.Goal_Progress_b4__c:0);
                        acqGoals.bmayPG = acqGoals.bmayPG+(aq.Goal_Progress_b5__c!=null?aq.Goal_Progress_b5__c:0);
                        acqGoals.bjunePG = acqGoals.bjunePG+(aq.Goal_Progress_b6__c!=null?aq.Goal_Progress_b6__c:0);
                        acqGoals.bjulyPG = acqGoals.bjulyPG+(aq.Goal_Progress_b7__c!=null?aq.Goal_Progress_b7__c:0);
                        acqGoals.baugPG = acqGoals.baugPG+(aq.Goal_Progress_b8__c!=null?aq.Goal_Progress_b8__c:0);
                        acqGoals.bsepPG = acqGoals.bsepPG+(aq.Goal_Progress_b9__c!=null?aq.Goal_Progress_b9__c:0);
                        acqGoals.boctPG = acqGoals.boctPG+(aq.Goal_Progress_b10__c!=null?aq.Goal_Progress_b10__c:0);
                        acqGoals.bnovPG = acqGoals.bnovPG+(aq.Goal_Progress_b11__c!=null?aq.Goal_Progress_b11__c:0);
                        acqGoals.bdecPG = acqGoals.bdecPG+(aq.Goal_Progress_b12__c!=null?aq.Goal_Progress_b12__c:0);
                        
                        //In Negotiation Goal Numbers
                        acqGoals.bjanIN = acqGoals.bjanIN+(aq.In_Negotiation_Titles_b1__c!=null?aq.In_Negotiation_Titles_b1__c:0);
                        acqGoals.bfebIN = acqGoals.bfebIN+(aq.In_Negotiation_Titles_b2__c!=null?aq.In_Negotiation_Titles_b2__c:0);
                        acqGoals.bmarIN = acqGoals.bmarIN+(aq.In_Negotiation_Titles_b3__c!=null?aq.In_Negotiation_Titles_b3__c:0);
                        acqGoals.baprIN = acqGoals.baprIN+(aq.In_Negotiation_Titles_b4__c!=null?aq.In_Negotiation_Titles_b4__c:0);
                        acqGoals.bmayIN = acqGoals.bmayIN+(aq.In_Negotiation_Titles_b5__c!=null?aq.In_Negotiation_Titles_b5__c:0);
                        acqGoals.bjuneIN = acqGoals.bjuneIN+(aq.In_Negotiation_Titles_b6__c!=null?aq.In_Negotiation_Titles_b6__c:0);
                        acqGoals.bjulyIN = acqGoals.bjulyIN+(aq.In_Negotiation_Titles_b7__c!=null?aq.In_Negotiation_Titles_b7__c:0);
                        acqGoals.baugIN = acqGoals.baugIN+(aq.In_Negotiation_Titles_b8__c!=null?aq.In_Negotiation_Titles_b8__c:0);
                        acqGoals.bsepIN = acqGoals.bsepIN+(aq.In_Negotiation_Titles_b9__c!=null?aq.In_Negotiation_Titles_b9__c:0);
                        acqGoals.boctIN = acqGoals.boctIN+(aq.In_Negotiation_Titles_b10__c!=null?aq.In_Negotiation_Titles_b10__c:0);
                        acqGoals.bnovIN = acqGoals.bnovIN+(aq.In_Negotiation_Titles_b11__c!=null?aq.In_Negotiation_Titles_b11__c:0);
                        acqGoals.bdecIN = acqGoals.bdecIN+(aq.In_Negotiation_Titles_b12__c!=null?aq.In_Negotiation_Titles_b12__c:0);
                        
                        //Pre-Acquisition Goal Numbers
                        acqGoals.bjanPA = acqGoals.bjanPA+(aq.Pre_Acquisition_Titles_b1__c!=null?aq.Pre_Acquisition_Titles_b1__c:0);
                        acqGoals.bfebPA = acqGoals.bfebPA+(aq.Pre_Acquisition_Titles_b2__c!=null?aq.Pre_Acquisition_Titles_b2__c:0);
                        acqGoals.bmarPA = acqGoals.bmarPA+(aq.Pre_Acquisition_Titles_b3__c!=null?aq.Pre_Acquisition_Titles_b3__c:0);
                        acqGoals.baprPA = acqGoals.baprPA+(aq.Pre_Acquisition_Titles_b4__c!=null?aq.Pre_Acquisition_Titles_b4__c:0);
                        acqGoals.bmayPA = acqGoals.bmayPA+(aq.Pre_Acquisition_Titles_b5__c!=null?aq.Pre_Acquisition_Titles_b5__c:0);
                        acqGoals.bjunePA = acqGoals.bjunePA+(aq.Pre_Acquisition_Titles_b6__c!=null?aq.Pre_Acquisition_Titles_b6__c:0);
                        acqGoals.bjulyPA = acqGoals.bjulyPA+(aq.Pre_Acquisition_Titles_b7__c!=null?aq.Pre_Acquisition_Titles_b7__c:0);
                        acqGoals.baugPA = acqGoals.baugPA+(aq.Pre_Acquisition_Titles_b8__c!=null?aq.Pre_Acquisition_Titles_b8__c:0);
                        acqGoals.bsepPA = acqGoals.bsepPA+(aq.Pre_Acquisition_Titles_b9__c!=null?aq.Pre_Acquisition_Titles_b9__c:0);
                        acqGoals.boctPA = acqGoals.boctPA+(aq.Pre_Acquisition_Titles_b10__c!=null?aq.Pre_Acquisition_Titles_b10__c:0);
                        acqGoals.bnovPA = acqGoals.bnovPA+(aq.Pre_Acquisition_Titles_b11__c!=null?aq.Pre_Acquisition_Titles_b11__c:0);
                        acqGoals.bdecPA = acqGoals.bdecPA+(aq.Pre_Acquisition_Titles_b12__c!=null?aq.Pre_Acquisition_Titles_b12__c:0);
                        
                    }
                    
                    //C Tier Roll-Ups
                    { 
                        //Finance/Business Goal Numbers
                        acqGoals.cjanT = acqGoals.cjanT+(aq.Business_Goal_c1__c!=null?aq.Business_Goal_c1__c:0);
                        acqGoals.cfebT = acqGoals.cfebT+(aq.Business_Goal_c2__c!=null?aq.Business_Goal_c2__c:0);
                        acqGoals.cmarT = acqGoals.cmarT+(aq.Business_Goal_c3__c!=null?aq.Business_Goal_c3__c:0);
                        acqGoals.caprT = acqGoals.caprT+(aq.Business_Goal_c4__c!=null?aq.Business_Goal_c4__c:0);
                        acqGoals.cmayT = acqGoals.cmayT+(aq.Business_Goal_c5__c!=null?aq.Business_Goal_c5__c:0);
                        acqGoals.cjuneT = acqGoals.cjuneT+(aq.Business_Goal_c6__c!=null?aq.Business_Goal_c6__c:0);
                        acqGoals.cjulyT = acqGoals.cjulyT+(aq.Business_Goal_c7__c!=null?aq.Business_Goal_c7__c:0);
                        acqGoals.caugT = acqGoals.caugT+(aq.Business_Goal_c8__c!=null?aq.Business_Goal_c8__c:0);
                        acqGoals.csepT = acqGoals.csepT+(aq.Business_Goal_c9__c!=null?aq.Business_Goal_c9__c:0);
                        acqGoals.coctT = acqGoals.coctT+(aq.Business_Goal_c10__c!=null?aq.Business_Goal_c10__c:0);
                        acqGoals.cnovT = acqGoals.cnovT+(aq.Business_Goal_c11__c!=null?aq.Business_Goal_c11__c:0);
                        acqGoals.cdecT = acqGoals.cdecT+(aq.Business_Goal_c12__c!=null?aq.Business_Goal_c12__c:0);
                        
                        //Live/Planned Goal Numbers
                        acqGoals.cjanLG = acqGoals.cjanT+(aq.Live_Goal_c1__c!=null?aq.Live_Goal_c1__c:0);
                        acqGoals.cfebLG = acqGoals.cfebT+(aq.Live_Goal_c2__c!=null?aq.Live_Goal_c2__c:0);
                        acqGoals.cmarLG = acqGoals.cmarT+(aq.Live_Goal_c3__c!=null?aq.Live_Goal_c3__c:0);
                        acqGoals.caprLG = acqGoals.caprT+(aq.Live_Goal_c4__c!=null?aq.Live_Goal_c4__c:0);
                        acqGoals.cmayLG = acqGoals.cmayT+(aq.Live_Goal_c5__c!=null?aq.Live_Goal_c5__c:0);
                        acqGoals.cjuneLG = acqGoals.cjuneT+(aq.Live_Goal_c6__c!=null?aq.Live_Goal_c6__c:0);
                        acqGoals.cjulyLG= acqGoals.cjulyT+(aq.Live_Goal_c7__c!=null?aq.Live_Goal_c7__c:0);
                        acqGoals.caugLG = acqGoals.caugT+(aq.Live_Goal_c8__c!=null?aq.Live_Goal_c8__c:0);
                        acqGoals.csepLG = acqGoals.csepT+(aq.Live_Goal_c9__c!=null?aq.Live_Goal_c9__c:0);
                        acqGoals.coctLG = acqGoals.coctT+(aq.Live_Goal_c10__c!=null?aq.Live_Goal_c10__c:0);
                        acqGoals.cnovLG = acqGoals.cnovT+(aq.Live_Goal_c11__c!=null?aq.Live_Goal_c11__c:0);
                        acqGoals.cdecLG = acqGoals.cdecT+(aq.Live_Goal_c12__c!=null?aq.Live_Goal_c12__c:0);
                        
                        //Acquired Goal Numbers
                        acqGoals.cjanAG = acqGoals.cjanAG+(aq.Acquired_Titles_c1__c!=null?aq.Acquired_Titles_c1__c:0);
                        acqGoals.cfebAG = acqGoals.cfebAG+(aq.Acquired_Titles_c2__c!=null?aq.Acquired_Titles_c2__c:0);
                        acqGoals.cmarAG = acqGoals.cmarAG+(aq.Acquired_Titles_c3__c!=null?aq.Acquired_Titles_c3__c:0);
                        acqGoals.caprAG = acqGoals.caprAG+(aq.Acquired_Titles_c4__c!=null?aq.Acquired_Titles_c4__c:0);
                        acqGoals.cmayAG = acqGoals.cmayAG+(aq.Acquired_Titles_c5__c!=null?aq.Acquired_Titles_c5__c:0);
                        acqGoals.cjuneAG = acqGoals.cjuneAG+(aq.Acquired_Titles_c6__c!=null?aq.Acquired_Titles_c6__c:0);
                        acqGoals.cjulyAG = acqGoals.cjulyAG+(aq.Acquired_Titles_c7__c!=null?aq.Acquired_Titles_c7__c:0);
                        acqGoals.caugAG = acqGoals.caugAG+(aq.Acquired_Titles_c8__c!=null?aq.Acquired_Titles_c8__c:0);
                        acqGoals.csepAG = acqGoals.csepAG+(aq.Acquired_Titles_c9__c!=null?aq.Acquired_Titles_c9__c:0);
                        acqGoals.coctAG = acqGoals.coctAG+(aq.Acquired_Titles_c10__c!=null?aq.Acquired_Titles_c10__c:0);
                        acqGoals.cnovAG = acqGoals.cnovAG+(aq.Acquired_Titles_c11__c!=null?aq.Acquired_Titles_c11__c:0);
                        acqGoals.cdecAG = acqGoals.cdecAG+(aq.Acquired_Titles_c12__c!=null?aq.Acquired_Titles_c12__c:0);
                        
                        //Progress Goal Numbers
                        acqGoals.cjanPG = acqGoals.cjanPG+(aq.Goal_Progress_c1__c!=null?aq.Goal_Progress_c1__c:0);
                        acqGoals.cfebPG = acqGoals.cfebPG+(aq.Goal_Progress_c2__c!=null?aq.Goal_Progress_c2__c:0);
                        acqGoals.cmarPG = acqGoals.cmarPG+(aq.Goal_Progress_c3__c!=null?aq.Goal_Progress_c3__c:0);
                        acqGoals.caprPG = acqGoals.caprPG+(aq.Goal_Progress_c4__c!=null?aq.Goal_Progress_c4__c:0);
                        acqGoals.cmayPG = acqGoals.cmayPG+(aq.Goal_Progress_c5__c!=null?aq.Goal_Progress_c5__c:0);
                        acqGoals.cjunePG = acqGoals.cjunePG+(aq.Goal_Progress_c6__c!=null?aq.Goal_Progress_c6__c:0);
                        acqGoals.cjulyPG = acqGoals.cjulyPG+(aq.Goal_Progress_c7__c!=null?aq.Goal_Progress_c7__c:0);
                        acqGoals.caugPG = acqGoals.caugPG+(aq.Goal_Progress_c8__c!=null?aq.Goal_Progress_c8__c:0);
                        acqGoals.csepPG = acqGoals.csepPG+(aq.Goal_Progress_c9__c!=null?aq.Goal_Progress_c9__c:0);
                        acqGoals.coctPG = acqGoals.coctPG+(aq.Goal_Progress_c10__c!=null?aq.Goal_Progress_c10__c:0);
                        acqGoals.cnovPG = acqGoals.cnovPG+(aq.Goal_Progress_c11__c!=null?aq.Goal_Progress_c11__c:0);
                        acqGoals.cdecPG = acqGoals.cdecPG+(aq.Goal_Progress_c12__c!=null?aq.Goal_Progress_c12__c:0);
                        
                        //In Negotiation Goal Numbers
                        acqGoals.cjanIN = acqGoals.cjanIN+(aq.In_Negotiation_Titles_c1__c!=null?aq.In_Negotiation_Titles_c1__c:0);
                        acqGoals.cfebIN = acqGoals.cfebIN+(aq.In_Negotiation_Titles_c2__c!=null?aq.In_Negotiation_Titles_c2__c:0);
                        acqGoals.cmarIN = acqGoals.cmarIN+(aq.In_Negotiation_Titles_c3__c!=null?aq.In_Negotiation_Titles_c3__c:0);
                        acqGoals.caprIN = acqGoals.caprIN+(aq.In_Negotiation_Titles_c4__c!=null?aq.In_Negotiation_Titles_c4__c:0);
                        acqGoals.cmayIN = acqGoals.cmayIN+(aq.In_Negotiation_Titles_c5__c!=null?aq.In_Negotiation_Titles_c5__c:0);
                        acqGoals.cjuneIN = acqGoals.cjuneIN+(aq.In_Negotiation_Titles_c6__c!=null?aq.In_Negotiation_Titles_c6__c:0);
                        acqGoals.cjulyIN = acqGoals.cjulyIN+(aq.In_Negotiation_Titles_c7__c!=null?aq.In_Negotiation_Titles_c7__c:0);
                        acqGoals.caugIN = acqGoals.caugIN+(aq.In_Negotiation_Titles_c8__c!=null?aq.In_Negotiation_Titles_c8__c:0);
                        acqGoals.csepIN = acqGoals.csepIN+(aq.In_Negotiation_Titles_c9__c!=null?aq.In_Negotiation_Titles_c9__c:0);
                        acqGoals.coctIN = acqGoals.coctIN+(aq.In_Negotiation_Titles_c10__c!=null?aq.In_Negotiation_Titles_c10__c:0);
                        acqGoals.cnovIN = acqGoals.cnovIN+(aq.In_Negotiation_Titles_c11__c!=null?aq.In_Negotiation_Titles_c11__c:0);
                        acqGoals.cdecIN = acqGoals.cdecIN+(aq.In_Negotiation_Titles_c12__c!=null?aq.In_Negotiation_Titles_c12__c:0);
                        
                        //Pre-Acquisition Goal Numbers
                        acqGoals.cjanPA = acqGoals.cjanPA+(aq.Pre_Acquisition_Titles_c1__c!=null?aq.Pre_Acquisition_Titles_c1__c:0);
                        acqGoals.cfebPA = acqGoals.cfebPA+(aq.Pre_Acquisition_Titles_c2__c!=null?aq.Pre_Acquisition_Titles_c2__c:0);
                        acqGoals.cmarPA = acqGoals.cmarPA+(aq.Pre_Acquisition_Titles_c3__c!=null?aq.Pre_Acquisition_Titles_c3__c:0);
                        acqGoals.caprPA = acqGoals.caprPA+(aq.Pre_Acquisition_Titles_c4__c!=null?aq.Pre_Acquisition_Titles_c4__c:0);
                        acqGoals.cmayPA = acqGoals.cmayPA+(aq.Pre_Acquisition_Titles_c5__c!=null?aq.Pre_Acquisition_Titles_c5__c:0);
                        acqGoals.cjunePA = acqGoals.cjunePA+(aq.Pre_Acquisition_Titles_c6__c!=null?aq.Pre_Acquisition_Titles_c6__c:0);
                        acqGoals.cjulyPA = acqGoals.cjulyPA+(aq.Pre_Acquisition_Titles_c7__c!=null?aq.Pre_Acquisition_Titles_c7__c:0);
                        acqGoals.caugPA = acqGoals.caugPA+(aq.Pre_Acquisition_Titles_c8__c!=null?aq.Pre_Acquisition_Titles_c8__c:0);
                        acqGoals.csepPA = acqGoals.csepPA+(aq.Pre_Acquisition_Titles_c9__c!=null?aq.Pre_Acquisition_Titles_c9__c:0);
                        acqGoals.coctPA = acqGoals.coctPA+(aq.Pre_Acquisition_Titles_c10__c!=null?aq.Pre_Acquisition_Titles_c10__c:0);
                        acqGoals.cnovPA = acqGoals.cnovPA+(aq.Pre_Acquisition_Titles_c11__c!=null?aq.Pre_Acquisition_Titles_c11__c:0);
                        acqGoals.cdecPA = acqGoals.cdecPA+(aq.Pre_Acquisition_Titles_c12__c!=null?aq.Pre_Acquisition_Titles_c12__c:0);
                    }
                    //D Tier Roll-Ups
                    { 
                        //Finance/Business Goal Numbers
                        acqGoals.djanT = acqGoals.djanT+(aq.Business_Goal_d1__c!=null?aq.Business_Goal_d1__c:0);
                        acqGoals.dfebT = acqGoals.dfebT+(aq.Business_Goal_d2__c!=null?aq.Business_Goal_d2__c:0);
                        acqGoals.dmarT = acqGoals.dmarT+(aq.Business_Goal_d3__c!=null?aq.Business_Goal_d3__c:0);
                        acqGoals.daprT = acqGoals.daprT+(aq.Business_Goal_d4__c!=null?aq.Business_Goal_d4__c:0);
                        acqGoals.dmayT = acqGoals.dmayT+(aq.Business_Goal_d5__c!=null?aq.Business_Goal_d5__c:0);
                        acqGoals.djuneT = acqGoals.djuneT+(aq.Business_Goal_d6__c!=null?aq.Business_Goal_d6__c:0);
                        acqGoals.djulyT = acqGoals.djulyT+(aq.Business_Goal_d7__c!=null?aq.Business_Goal_d7__c:0);
                        acqGoals.daugT = acqGoals.daugT+(aq.Business_Goal_d8__c!=null?aq.Business_Goal_d8__c:0);
                        acqGoals.dsepT = acqGoals.dsepT+(aq.Business_Goal_d9__c!=null?aq.Business_Goal_d9__c:0);
                        acqGoals.doctT = acqGoals.doctT+(aq.Business_Goal_d10__c!=null?aq.Business_Goal_d10__c:0);
                        acqGoals.dnovT = acqGoals.dnovT+(aq.Business_Goal_d11__c!=null?aq.Business_Goal_d11__c:0);
                        acqGoals.ddecT = acqGoals.ddecT+(aq.Business_Goal_d12__c!=null?aq.Business_Goal_d12__c:0);
                        
                        //Live/Planned Goal Numbers
                        acqGoals.djanLG = acqGoals.djanLG+(aq.Live_Goal_d1__c!=null?aq.Live_Goal_d1__c:0);
                        acqGoals.dfebLG = acqGoals.dfebLG+(aq.Live_Goal_d2__c!=null?aq.Live_Goal_d2__c:0);
                        acqGoals.dmarLG = acqGoals.dmarLG+(aq.Live_Goal_d3__c!=null?aq.Live_Goal_d3__c:0);
                        acqGoals.daprLG= acqGoals.daprLG+(aq.Live_Goal_d4__c!=null?aq.Live_Goal_d4__c:0);
                        acqGoals.dmayLG = acqGoals.dmayLG+(aq.Live_Goal_d5__c!=null?aq.Live_Goal_d5__c:0);
                        acqGoals.djuneLG = acqGoals.djuneLG+(aq.Live_Goal_d6__c!=null?aq.Live_Goal_d6__c:0);
                        acqGoals.djulyLG = acqGoals.djulyLG+(aq.Live_Goal_d7__c!=null?aq.Live_Goal_d7__c:0);
                        acqGoals.daugLG = acqGoals.daugLG+(aq.Live_Goal_d8__c!=null?aq.Live_Goal_d8__c:0);
                        acqGoals.dsepLG = acqGoals.dsepLG+(aq.Live_Goal_d9__c!=null?aq.Live_Goal_d9__c:0);
                        acqGoals.doctLG = acqGoals.doctLG+(aq.Live_Goal_d10__c!=null?aq.Live_Goal_d10__c:0);
                        acqGoals.dnovLG = acqGoals.dnovLG+(aq.Live_Goal_d11__c!=null?aq.Live_Goal_d11__c:0);
                        acqGoals.ddecLG = acqGoals.ddecLG+(aq.Live_Goal_d12__c!=null?aq.Live_Goal_d12__c:0);
                        
                        //Acquired Goal Numbers
                        acqGoals.djanAG = acqGoals.djanAG+(aq.Acquired_Titles_d1__c!=null?aq.Acquired_Titles_d1__c:0);
                        acqGoals.dfebAG = acqGoals.dfebAG+(aq.Acquired_Titles_d2__c!=null?aq.Acquired_Titles_d2__c:0);
                        acqGoals.dmarAG = acqGoals.dmarAG+(aq.Acquired_Titles_d3__c!=null?aq.Acquired_Titles_d3__c:0);
                        acqGoals.daprAG = acqGoals.daprAG+(aq.Acquired_Titles_d4__c!=null?aq.Acquired_Titles_d4__c:0);
                        acqGoals.dmayAG = acqGoals.dmayAG+(aq.Acquired_Titles_d5__c!=null?aq.Acquired_Titles_d5__c:0);
                        acqGoals.djuneAG = acqGoals.djuneAG+(aq.Acquired_Titles_d6__c!=null?aq.Acquired_Titles_d6__c:0);
                        acqGoals.djulyAG = acqGoals.djulyAG+(aq.Acquired_Titles_d7__c!=null?aq.Acquired_Titles_d7__c:0);
                        acqGoals.daugAG = acqGoals.daugAG+(aq.Acquired_Titles_d8__c!=null?aq.Acquired_Titles_d8__c:0);
                        acqGoals.dsepAG = acqGoals.dsepAG+(aq.Acquired_Titles_d9__c!=null?aq.Acquired_Titles_d9__c:0);
                        acqGoals.doctAG = acqGoals.doctAG+(aq.Acquired_Titles_d10__c!=null?aq.Acquired_Titles_d10__c:0);
                        acqGoals.dnovAG = acqGoals.dnovAG+(aq.Acquired_Titles_d11__c!=null?aq.Acquired_Titles_d11__c:0);
                        acqGoals.ddecAG = acqGoals.ddecAG+(aq.Acquired_Titles_d12__c!=null?aq.Acquired_Titles_d12__c:0);
                        
                        //Progress Goal Numbers
                        acqGoals.djanPG = acqGoals.djanPG +(aq.Goal_Progress_d1__c!=null?aq.Goal_Progress_d1__c:0);
                        acqGoals.dfebPG  = acqGoals.dfebPG +(aq.Goal_Progress_d2__c!=null?aq.Goal_Progress_d2__c:0);
                        acqGoals.dmarPG  = acqGoals.dmarPG +(aq.Goal_Progress_d3__c!=null?aq.Goal_Progress_d3__c:0);
                        acqGoals.daprPG  = acqGoals.daprPG +(aq.Goal_Progress_d4__c!=null?aq.Goal_Progress_d4__c:0);
                        acqGoals.dmayPG  = acqGoals.dmayPG +(aq.Goal_Progress_d5__c!=null?aq.Goal_Progress_d5__c:0);
                        acqGoals.djunePG  = acqGoals.djunePG +(aq.Goal_Progress_d6__c!=null?aq.Goal_Progress_d6__c:0);
                        acqGoals.djulyPG  = acqGoals.djulyPG +(aq.Goal_Progress_d7__c!=null?aq.Goal_Progress_d7__c:0);
                        acqGoals.daugPG  = acqGoals.daugPG +(aq.Goal_Progress_d8__c!=null?aq.Goal_Progress_d8__c:0);
                        acqGoals.dsepPG  = acqGoals.dsepPG +(aq.Goal_Progress_d9__c!=null?aq.Goal_Progress_d9__c:0);
                        acqGoals.doctPG  = acqGoals.doctPG +(aq.Goal_Progress_d10__c!=null?aq.Goal_Progress_d10__c:0);
                        acqGoals.dnovPG  = acqGoals.dnovPG +(aq.Goal_Progress_d11__c!=null?aq.Goal_Progress_d11__c:0);
                        acqGoals.ddecPG  = acqGoals.ddecPG +(aq.Goal_Progress_d12__c!=null?aq.Goal_Progress_d12__c:0);
                        
                        //In Negotiation Goal Numbers
                        acqGoals.djanIN = acqGoals.djanIN+(aq.In_Negotiation_Titles_d1__c!=null?aq.In_Negotiation_Titles_d1__c:0);
                        acqGoals.dfebIN = acqGoals.dfebIN+(aq.In_Negotiation_Titles_d2__c!=null?aq.In_Negotiation_Titles_d2__c:0);
                        acqGoals.dmarIN = acqGoals.dmarIN+(aq.In_Negotiation_Titles_d3__c!=null?aq.In_Negotiation_Titles_d3__c:0);
                        acqGoals.daprIN = acqGoals.daprIN+(aq.In_Negotiation_Titles_d4__c!=null?aq.In_Negotiation_Titles_d4__c:0);
                        acqGoals.dmayIN = acqGoals.dmayIN+(aq.In_Negotiation_Titles_d5__c!=null?aq.In_Negotiation_Titles_d5__c:0);
                        acqGoals.djuneIN = acqGoals.djuneIN+(aq.In_Negotiation_Titles_d6__c!=null?aq.In_Negotiation_Titles_d6__c:0);
                        acqGoals.djulyIN = acqGoals.djulyIN+(aq.In_Negotiation_Titles_d7__c!=null?aq.In_Negotiation_Titles_d7__c:0);
                        acqGoals.daugIN = acqGoals.daugIN+(aq.In_Negotiation_Titles_d8__c!=null?aq.In_Negotiation_Titles_d8__c:0);
                        acqGoals.dsepIN = acqGoals.dsepIN+(aq.In_Negotiation_Titles_d9__c!=null?aq.In_Negotiation_Titles_d9__c:0);
                        acqGoals.doctIN = acqGoals.doctIN+(aq.In_Negotiation_Titles_d10__c!=null?aq.In_Negotiation_Titles_d10__c:0);
                        acqGoals.dnovIN = acqGoals.dnovIN+(aq.In_Negotiation_Titles_d11__c!=null?aq.In_Negotiation_Titles_d11__c:0);
                        acqGoals.ddecIN = acqGoals.ddecIN+(aq.In_Negotiation_Titles_d12__c!=null?aq.In_Negotiation_Titles_d12__c:0);
                        
                        //Pre-Acquisition Goal Numbers
                        acqGoals.djanPA = acqGoals.djanPA+(aq.Pre_Acquisition_Titles_d1__c!=null?aq.Pre_Acquisition_Titles_d1__c:0);
                        acqGoals.dfebPA = acqGoals.dfebPA+(aq.Pre_Acquisition_Titles_d2__c!=null?aq.Pre_Acquisition_Titles_d2__c:0);
                        acqGoals.dmarPA = acqGoals.dmarPA+(aq.Pre_Acquisition_Titles_d3__c!=null?aq.Pre_Acquisition_Titles_d3__c:0);
                        acqGoals.daprPA = acqGoals.daprPA+(aq.Pre_Acquisition_Titles_d4__c!=null?aq.Pre_Acquisition_Titles_d4__c:0);
                        acqGoals.dmayPA = acqGoals.dmayPA+(aq.Pre_Acquisition_Titles_d5__c!=null?aq.Pre_Acquisition_Titles_d5__c:0);
                        acqGoals.djunePA = acqGoals.djunePA+(aq.Pre_Acquisition_Titles_d6__c!=null?aq.Pre_Acquisition_Titles_d6__c:0);
                        acqGoals.djulyPA = acqGoals.djulyPA+(aq.Pre_Acquisition_Titles_d7__c!=null?aq.Pre_Acquisition_Titles_d7__c:0);
                        acqGoals.daugPA = acqGoals.daugPA+(aq.Pre_Acquisition_Titles_d8__c!=null?aq.Pre_Acquisition_Titles_d8__c:0);
                        acqGoals.dsepPA = acqGoals.dsepPA+(aq.Pre_Acquisition_Titles_d9__c!=null?aq.Pre_Acquisition_Titles_d9__c:0);
                        acqGoals.doctPA = acqGoals.doctPA+(aq.Pre_Acquisition_Titles_d10__c!=null?aq.Pre_Acquisition_Titles_d10__c:0);
                        acqGoals.dnovPA = acqGoals.dnovPA+(aq.Pre_Acquisition_Titles_d11__c!=null?aq.Pre_Acquisition_Titles_d11__c:0);
                        acqGoals.ddecPA = acqGoals.ddecPA+(aq.Pre_Acquisition_Titles_d12__c!=null?aq.Pre_Acquisition_Titles_d12__c:0);
                    }
                    
                    //tier status roll ups
                    {
                        acqGoals.ap_aq_TRU = acqGoals.ap_aq_TRU+(aq.AQ_Total_ap__c!=null?aq.AQ_Total_ap__c:0);
                        acqGoals.ap_in_TRU = acqGoals.ap_in_TRU+(aq.IN_Total_ap__c!=null?aq.IN_Total_ap__c:0);
                        acqGoals.ap_pa_TRU = acqGoals.ap_pa_TRU+(aq.pa_Total_ap__c!=null?aq.pa_Total_ap__c:0);
                        acqGoals.ap_gp_TRU = acqGoals.ap_gp_TRU+(aq.gp_Total_ap__c!=null?aq.gp_Total_ap__c:0);
                        acqGoals.ap_lg_TRU = acqGoals.ap_lg_TRU+(aq.lg_Total_ap__c!=null?aq.lg_Total_ap__c:0);
                        
                        acqGoals.a_aq_TRU = acqGoals.a_aq_TRU+(aq.AQ_Total_a__c!=null?aq.AQ_Total_a__c:0);
                        acqGoals.a_in_TRU = acqGoals.a_in_TRU+(aq.IN_Total_a__c!=null?aq.IN_Total_a__c:0);
                        acqGoals.a_pa_TRU = acqGoals.a_pa_TRU+(aq.pa_Total_a__c!=null?aq.pa_Total_a__c:0);
                        acqGoals.a_gp_TRU = acqGoals.a_gp_TRU+(aq.gp_Total_a__c!=null?aq.gp_Total_a__c:0);
                        acqGoals.a_lg_TRU = acqGoals.a_lg_TRU+(aq.lg_Total_a__c!=null?aq.lg_Total_a__c:0);
                        
                        acqGoals.b_aq_TRU = acqGoals.b_aq_TRU+(aq.AQ_Total_b__c!=null?aq.AQ_Total_b__c:0);
                        acqGoals.b_in_TRU = acqGoals.b_in_TRU+(aq.IN_Total_b__c!=null?aq.IN_Total_b__c:0);
                        acqGoals.b_pa_TRU = acqGoals.b_pa_TRU+(aq.pa_Total_b__c!=null?aq.pa_Total_b__c:0);
                        acqGoals.b_gp_TRU = acqGoals.b_gp_TRU+(aq.gp_Total_b__c!=null?aq.gp_Total_b__c:0);
                        acqGoals.b_lg_TRU = acqGoals.b_lg_TRU+(aq.lg_Total_b__c!=null?aq.lg_Total_b__c:0);
                        
                        acqGoals.c_aq_TRU = acqGoals.c_aq_TRU+(aq.AQ_Total_c__c!=null?aq.AQ_Total_c__c:0);
                        acqGoals.c_in_TRU = acqGoals.c_in_TRU+(aq.IN_Total_c__c!=null?aq.IN_Total_c__c:0);
                        acqGoals.c_pa_TRU = acqGoals.c_pa_TRU+(aq.pa_Total_c__c!=null?aq.pa_Total_c__c:0);
                        acqGoals.c_gp_TRU = acqGoals.c_gp_TRU+(aq.gp_Total_c__c!=null?aq.gp_Total_c__c:0);
                        acqGoals.c_lg_TRU = acqGoals.c_lg_TRU+(aq.lg_Total_c__c!=null?aq.lg_Total_c__c:0);
                        
                        acqGoals.d_aq_TRU = acqGoals.d_aq_TRU+(aq.AQ_Total_d__c!=null?aq.AQ_Total_d__c:0);
                        acqGoals.d_in_TRU = acqGoals.d_in_TRU+(aq.IN_Total_d__c!=null?aq.IN_Total_d__c:0);
                        acqGoals.d_pa_TRU = acqGoals.d_pa_TRU+(aq.pa_Total_d__c!=null?aq.pa_Total_d__c:0);
                        acqGoals.d_gp_TRU = acqGoals.d_gp_TRU+(aq.gp_Total_d__c!=null?aq.gp_Total_d__c:0);
                        acqGoals.d_lg_TRU = acqGoals.d_lg_TRU+(aq.lg_Total_d__c!=null?aq.lg_Total_d__c:0);
                        
                    }
                    
                    //total monthly acquired titles for the selected imprints
                    //12 variables, that add up the months of acquired titles for the VF page...
                    {
                        acqGoals.janTotal_aq = 
                            acqGoals.janTotal_aq+(aq.Acquired_Titles_ap1__c!=null?aq.Acquired_Titles_ap1__c:0)+
                            (aq.Acquired_Titles_a1__c!=null?aq.Acquired_Titles_a1__c:0)+(aq.Acquired_Titles_b1__c!=null?aq.Acquired_Titles_b1__c:0)+
                            (aq.Acquired_Titles_c1__c!=null?aq.Acquired_Titles_c1__c:0)+(aq.Acquired_Titles_d1__c!=null?aq.Acquired_Titles_d1__c:0);
                        
                        acqGoals.febTotal_aq = 
                            acqGoals.febTotal_aq+(aq.Acquired_Titles_ap2__c!=null?aq.Acquired_Titles_ap2__c:0)+
                            (aq.Acquired_Titles_a2__c!=null?aq.Acquired_Titles_a2__c:0)+(aq.Acquired_Titles_b2__c!=null?aq.Acquired_Titles_b2__c:0)+
                            (aq.Acquired_Titles_c2__c!=null?aq.Acquired_Titles_c2__c:0)+(aq.Acquired_Titles_d2__c!=null?aq.Acquired_Titles_d2__c:0);
                        
                        acqGoals.marTotal_aq = 
                            acqGoals.marTotal_aq+(aq.Acquired_Titles_ap3__c!=null?aq.Acquired_Titles_ap3__c:0)+
                            (aq.Acquired_Titles_a3__c!=null?aq.Acquired_Titles_a3__c:0)+(aq.Acquired_Titles_b3__c!=null?aq.Acquired_Titles_b3__c:0)+
                            (aq.Acquired_Titles_c3__c!=null?aq.Acquired_Titles_c3__c:0)+(aq.Acquired_Titles_d3__c!=null?aq.Acquired_Titles_d3__c:0);
                        
                        acqGoals.aprTotal_aq = 
                            acqGoals.aprTotal_aq+(aq.Acquired_Titles_ap4__c!=null?aq.Acquired_Titles_ap4__c:0)+
                            (aq.Acquired_Titles_a4__c!=null?aq.Acquired_Titles_a4__c:0)+(aq.Acquired_Titles_b4__c!=null?aq.Acquired_Titles_b4__c:0)+
                            (aq.Acquired_Titles_c4__c!=null?aq.Acquired_Titles_c4__c:0)+(aq.Acquired_Titles_d4__c!=null?aq.Acquired_Titles_d4__c:0);
                        
                        acqGoals.mayTotal_aq = 
                            acqGoals.mayTotal_aq+(aq.Acquired_Titles_ap5__c!=null?aq.Acquired_Titles_ap5__c:0)+
                            (aq.Acquired_Titles_a5__c!=null?aq.Acquired_Titles_a5__c:0)+(aq.Acquired_Titles_b5__c!=null?aq.Acquired_Titles_b5__c:0)+
                            (aq.Acquired_Titles_c5__c!=null?aq.Acquired_Titles_c5__c:0)+(aq.Acquired_Titles_d5__c!=null?aq.Acquired_Titles_d5__c:0);
                        
                        acqGoals.junTotal_aq = 
                            acqGoals.junTotal_aq+(aq.Acquired_Titles_ap6__c!=null?aq.Acquired_Titles_ap6__c:0)+
                            (aq.Acquired_Titles_a6__c!=null?aq.Acquired_Titles_a6__c:0)+(aq.Acquired_Titles_b6__c!=null?aq.Acquired_Titles_b6__c:0)+
                            (aq.Acquired_Titles_c6__c!=null?aq.Acquired_Titles_c6__c:0)+(aq.Acquired_Titles_d6__c!=null?aq.Acquired_Titles_d6__c:0);
                        
                        acqGoals.julTotal_aq = 
                            acqGoals.julTotal_aq+(aq.Acquired_Titles_ap7__c!=null?aq.Acquired_Titles_ap7__c:0)+
                            (aq.Acquired_Titles_a7__c!=null?aq.Acquired_Titles_a7__c:0)+(aq.Acquired_Titles_b7__c!=null?aq.Acquired_Titles_b7__c:0)+
                            (aq.Acquired_Titles_c7__c!=null?aq.Acquired_Titles_c7__c:0)+(aq.Acquired_Titles_d7__c!=null?aq.Acquired_Titles_d7__c:0);
                        
                        acqGoals.augTotal_aq = 
                            acqGoals.augTotal_aq+(aq.Acquired_Titles_ap8__c!=null?aq.Acquired_Titles_ap8__c:0)+
                            (aq.Acquired_Titles_a8__c!=null?aq.Acquired_Titles_a8__c:0)+(aq.Acquired_Titles_b8__c!=null?aq.Acquired_Titles_b8__c:0)+
                            (aq.Acquired_Titles_c8__c!=null?aq.Acquired_Titles_c8__c:0)+(aq.Acquired_Titles_d8__c!=null?aq.Acquired_Titles_d8__c:0);
                        
                        acqGoals.sepTotal_aq = 
                            acqGoals.sepTotal_aq+(aq.Acquired_Titles_ap9__c!=null?aq.Acquired_Titles_ap9__c:0)+
                            (aq.Acquired_Titles_a9__c!=null?aq.Acquired_Titles_a9__c:0)+(aq.Acquired_Titles_b9__c!=null?aq.Acquired_Titles_b9__c:0)+
                            (aq.Acquired_Titles_c9__c!=null?aq.Acquired_Titles_c9__c:0)+(aq.Acquired_Titles_d9__c!=null?aq.Acquired_Titles_d9__c:0);
                        
                        acqGoals.octTotal_aq = 
                            acqGoals.octTotal_aq+(aq.Acquired_Titles_ap10__c!=null?aq.Acquired_Titles_ap10__c:0)+
                            (aq.Acquired_Titles_a10__c!=null?aq.Acquired_Titles_a10__c:0)+(aq.Acquired_Titles_b10__c!=null?aq.Acquired_Titles_b10__c:0)+
                            (aq.Acquired_Titles_c10__c!=null?aq.Acquired_Titles_c10__c:0)+(aq.Acquired_Titles_d10__c!=null?aq.Acquired_Titles_d10__c:0);
                        
                        acqGoals.novTotal_aq = 
                            acqGoals.novTotal_aq+(aq.Acquired_Titles_ap11__c!=null?aq.Acquired_Titles_ap11__c:0)+
                            (aq.Acquired_Titles_a11__c!=null?aq.Acquired_Titles_a11__c:0)+(aq.Acquired_Titles_b11__c!=null?aq.Acquired_Titles_b11__c:0)+
                            (aq.Acquired_Titles_c11__c!=null?aq.Acquired_Titles_c11__c:0)+(aq.Acquired_Titles_d11__c!=null?aq.Acquired_Titles_d11__c:0);
                        
                        acqGoals.decTotal_aq = 
                            acqGoals.decTotal_aq+(aq.Acquired_Titles_ap12__c!=null?aq.Acquired_Titles_ap12__c:0)+
                            (aq.Acquired_Titles_a12__c!=null?aq.Acquired_Titles_a12__c:0)+(aq.Acquired_Titles_b12__c!=null?aq.Acquired_Titles_b12__c:0)+
                            (aq.Acquired_Titles_c12__c!=null?aq.Acquired_Titles_c12__c:0)+(aq.Acquired_Titles_d12__c!=null?aq.Acquired_Titles_d12__c:0);
                    }
                    
                    {
                        acqGoals.janTotal_bg = 
                            acqGoals.janTotal_bg+(aq.Business_Goal_ap1__c!=null?aq.Business_Goal_ap1__c:0)+
                            (aq.Business_Goal_a1__c!=null?aq.Business_Goal_a1__c:0)+(aq.Business_Goal_b1__c!=null?aq.Business_Goal_b1__c:0)+
                            (aq.Business_Goal_c1__c!=null?aq.Business_Goal_c1__c:0)+(aq.Business_Goal_d1__c!=null?aq.Business_Goal_d1__c:0);
                        
                        acqGoals.febTotal_bg = 
                            acqGoals.febTotal_bg+(aq.Business_Goal_ap2__c!=null?aq.Business_Goal_ap2__c:0)+
                            (aq.Business_Goal_a2__c!=null?aq.Business_Goal_a2__c:0)+(aq.Business_Goal_b2__c!=null?aq.Business_Goal_b2__c:0)+
                            (aq.Business_Goal_c2__c!=null?aq.Business_Goal_c2__c:0)+(aq.Business_Goal_d2__c!=null?aq.Business_Goal_d2__c:0);
                        
                        acqGoals.marTotal_bg = 
                            acqGoals.marTotal_bg+(aq.Business_Goal_ap3__c!=null?aq.Business_Goal_ap3__c:0)+
                            (aq.Business_Goal_a3__c!=null?aq.Business_Goal_a3__c:0)+(aq.Business_Goal_b3__c!=null?aq.Business_Goal_b3__c:0)+
                            (aq.Business_Goal_c3__c!=null?aq.Business_Goal_c3__c:0)+(aq.Business_Goal_d3__c!=null?aq.Business_Goal_d3__c:0);
                        
                        acqGoals.aprTotal_bg = 
                            acqGoals.aprTotal_bg+(aq.Business_Goal_ap4__c!=null?aq.Business_Goal_ap4__c:0)+
                            (aq.Business_Goal_a4__c!=null?aq.Business_Goal_a4__c:0)+(aq.Business_Goal_b4__c!=null?aq.Business_Goal_b4__c:0)+
                            (aq.Business_Goal_c4__c!=null?aq.Business_Goal_c4__c:0)+(aq.Business_Goal_d4__c!=null?aq.Business_Goal_d4__c:0);
                        
                        acqGoals.mayTotal_bg = 
                            acqGoals.mayTotal_bg+(aq.Business_Goal_ap5__c!=null?aq.Business_Goal_ap5__c:0)+
                            (aq.Business_Goal_a5__c!=null?aq.Business_Goal_a5__c:0)+(aq.Business_Goal_b5__c!=null?aq.Business_Goal_b5__c:0)+
                            (aq.Business_Goal_c5__c!=null?aq.Business_Goal_c5__c:0)+(aq.Business_Goal_d5__c!=null?aq.Business_Goal_d5__c:0);
                        
                        acqGoals.junTotal_bg = 
                            acqGoals.junTotal_bg+(aq.Business_Goal_ap6__c!=null?aq.Business_Goal_ap6__c:0)+
                            (aq.Business_Goal_a6__c!=null?aq.Business_Goal_a6__c:0)+(aq.Business_Goal_b6__c!=null?aq.Business_Goal_b6__c:0)+
                            (aq.Business_Goal_c6__c!=null?aq.Business_Goal_c6__c:0)+(aq.Business_Goal_d6__c!=null?aq.Business_Goal_d6__c:0);
                        
                        acqGoals.julTotal_bg = 
                            acqGoals.julTotal_bg+(aq.Business_Goal_ap7__c!=null?aq.Business_Goal_ap7__c:0)+
                            (aq.Business_Goal_a7__c!=null?aq.Business_Goal_a7__c:0)+(aq.Business_Goal_b7__c!=null?aq.Business_Goal_b7__c:0)+
                            (aq.Business_Goal_c7__c!=null?aq.Business_Goal_c7__c:0)+(aq.Business_Goal_d7__c!=null?aq.Business_Goal_d7__c:0);
                        
                        acqGoals.augTotal_bg = 
                            acqGoals.augTotal_bg+(aq.Business_Goal_ap8__c!=null?aq.Business_Goal_ap8__c:0)+
                            (aq.Business_Goal_a8__c!=null?aq.Business_Goal_a8__c:0)+(aq.Business_Goal_b8__c!=null?aq.Business_Goal_b8__c:0)+
                            (aq.Business_Goal_c8__c!=null?aq.Business_Goal_c8__c:0)+(aq.Business_Goal_d8__c!=null?aq.Business_Goal_d8__c:0);
                        
                        acqGoals.sepTotal_bg = 
                            acqGoals.sepTotal_bg+(aq.Business_Goal_ap9__c!=null?aq.Business_Goal_ap9__c:0)+
                            (aq.Business_Goal_a9__c!=null?aq.Business_Goal_a9__c:0)+(aq.Business_Goal_b9__c!=null?aq.Business_Goal_b9__c:0)+
                            (aq.Business_Goal_c9__c!=null?aq.Business_Goal_c9__c:0)+(aq.Business_Goal_d9__c!=null?aq.Business_Goal_d9__c:0);
                        
                        acqGoals.octTotal_bg = 
                            acqGoals.octTotal_bg+(aq.Business_Goal_ap10__c!=null?aq.Business_Goal_ap10__c:0)+
                            (aq.Business_Goal_a10__c!=null?aq.Business_Goal_a10__c:0)+(aq.Business_Goal_b10__c!=null?aq.Business_Goal_b10__c:0)+
                            (aq.Business_Goal_c10__c!=null?aq.Business_Goal_c10__c:0)+(aq.Business_Goal_d10__c!=null?aq.Business_Goal_d10__c:0);
                        
                        acqGoals.novTotal_bg = 
                            acqGoals.novTotal_bg+(aq.Business_Goal_ap11__c!=null?aq.Business_Goal_ap11__c:0)+
                            (aq.Business_Goal_a11__c!=null?aq.Business_Goal_a11__c:0)+(aq.Business_Goal_b11__c!=null?aq.Business_Goal_b11__c:0)+
                            (aq.Business_Goal_c11__c!=null?aq.Business_Goal_c11__c:0)+(aq.Business_Goal_d11__c!=null?aq.Business_Goal_d11__c:0);
                        
                        acqGoals.decTotal_bg = 
                            acqGoals.decTotal_bg+(aq.Business_Goal_ap12__c!=null?aq.Business_Goal_ap12__c:0)+
                            (aq.Business_Goal_a12__c!=null?aq.Business_Goal_a12__c:0)+(aq.Business_Goal_b12__c!=null?aq.Business_Goal_b12__c:0)+
                            (aq.Business_Goal_c12__c!=null?aq.Business_Goal_c12__c:0)+(aq.Business_Goal_d12__c!=null?aq.Business_Goal_d12__c:0);
                    }
                    
                    {
                        acqGoals.janTotal_lg = 
                            acqGoals.janTotal_lg+(aq.Live_Goal_ap1__c!=null?aq.Live_Goal_ap1__c:0)+
                            (aq.Live_Goal_a1__c!=null?aq.Live_Goal_a1__c:0)+(aq.Live_Goal_b1__c!=null?aq.Live_Goal_b1__c:0)+
                            (aq.Live_Goal_c1__c!=null?aq.Live_Goal_c1__c:0)+(aq.Live_Goal_d1__c!=null?aq.Live_Goal_d1__c:0);
                        
                        acqGoals.febTotal_lg = 
                            acqGoals.febTotal_lg+(aq.Live_Goal_ap2__c!=null?aq.Live_Goal_ap2__c:0)+
                            (aq.Live_Goal_a2__c!=null?aq.Live_Goal_a2__c:0)+(aq.Live_Goal_b2__c!=null?aq.Live_Goal_b2__c:0)+
                            (aq.Live_Goal_c2__c!=null?aq.Live_Goal_c2__c:0)+(aq.Live_Goal_d2__c!=null?aq.Live_Goal_d2__c:0);
                        
                        acqGoals.marTotal_lg = 
                            acqGoals.marTotal_lg+(aq.Live_Goal_ap3__c!=null?aq.Live_Goal_ap3__c:0)+
                            (aq.Live_Goal_a3__c!=null?aq.Live_Goal_a3__c:0)+(aq.Live_Goal_b3__c!=null?aq.Live_Goal_b3__c:0)+
                            (aq.Live_Goal_c3__c!=null?aq.Live_Goal_c3__c:0)+(aq.Live_Goal_d3__c!=null?aq.Live_Goal_d3__c:0);
                        
                        acqGoals.aprTotal_lg = 
                            acqGoals.aprTotal_lg+(aq.Live_Goal_ap4__c!=null?aq.Live_Goal_ap4__c:0)+
                            (aq.Live_Goal_a4__c!=null?aq.Live_Goal_a4__c:0)+(aq.Live_Goal_b4__c!=null?aq.Live_Goal_b4__c:0)+
                            (aq.Live_Goal_c4__c!=null?aq.Live_Goal_c4__c:0)+(aq.Live_Goal_d4__c!=null?aq.Live_Goal_d4__c:0);
                        
                        acqGoals.mayTotal_lg = 
                            acqGoals.mayTotal_lg+(aq.Live_Goal_ap5__c!=null?aq.Live_Goal_ap5__c:0)+
                            (aq.Live_Goal_a5__c!=null?aq.Live_Goal_a5__c:0)+(aq.Live_Goal_b5__c!=null?aq.Live_Goal_b5__c:0)+
                            (aq.Live_Goal_c5__c!=null?aq.Live_Goal_c5__c:0)+(aq.Live_Goal_d5__c!=null?aq.Live_Goal_d5__c:0);
                        
                        acqGoals.junTotal_lg = 
                            acqGoals.junTotal_lg+(aq.Live_Goal_ap6__c!=null?aq.Live_Goal_ap6__c:0)+
                            (aq.Live_Goal_a6__c!=null?aq.Live_Goal_a6__c:0)+(aq.Live_Goal_b6__c!=null?aq.Live_Goal_b6__c:0)+
                            (aq.Live_Goal_c6__c!=null?aq.Live_Goal_c6__c:0)+(aq.Live_Goal_d6__c!=null?aq.Live_Goal_d6__c:0);
                        
                        acqGoals.julTotal_lg = 
                            acqGoals.julTotal_lg+(aq.Live_Goal_ap7__c!=null?aq.Live_Goal_ap7__c:0)+
                            (aq.Live_Goal_a7__c!=null?aq.Live_Goal_a7__c:0)+(aq.Live_Goal_b7__c!=null?aq.Live_Goal_b7__c:0)+
                            (aq.Live_Goal_c7__c!=null?aq.Live_Goal_c7__c:0)+(aq.Live_Goal_d7__c!=null?aq.Live_Goal_d7__c:0);
                        
                        acqGoals.augTotal_lg = 
                            acqGoals.augTotal_lg+(aq.Live_Goal_ap8__c!=null?aq.Live_Goal_ap8__c:0)+
                            (aq.Live_Goal_a8__c!=null?aq.Live_Goal_a8__c:0)+(aq.Live_Goal_b8__c!=null?aq.Live_Goal_b8__c:0)+
                            (aq.Live_Goal_c8__c!=null?aq.Live_Goal_c8__c:0)+(aq.Live_Goal_d8__c!=null?aq.Live_Goal_d8__c:0);
                        
                        acqGoals.sepTotal_lg = 
                            acqGoals.sepTotal_lg+(aq.Live_Goal_ap9__c!=null?aq.Live_Goal_ap9__c:0)+
                            (aq.Live_Goal_a9__c!=null?aq.Live_Goal_a9__c:0)+(aq.Live_Goal_b9__c!=null?aq.Live_Goal_b9__c:0)+
                            (aq.Live_Goal_c9__c!=null?aq.Live_Goal_c9__c:0)+(aq.Live_Goal_d9__c!=null?aq.Live_Goal_d9__c:0);
                        
                        acqGoals.octTotal_lg = 
                            acqGoals.octTotal_lg+(aq.Live_Goal_ap10__c!=null?aq.Live_Goal_ap10__c:0)+
                            (aq.Live_Goal_a10__c!=null?aq.Live_Goal_a10__c:0)+(aq.Live_Goal_b10__c!=null?aq.Live_Goal_b10__c:0)+
                            (aq.Live_Goal_c10__c!=null?aq.Live_Goal_c10__c:0)+(aq.Live_Goal_d10__c!=null?aq.Live_Goal_d10__c:0);
                        
                        acqGoals.novTotal_lg = 
                            acqGoals.novTotal_lg+(aq.Live_Goal_ap11__c!=null?aq.Live_Goal_ap11__c:0)+
                            (aq.Live_Goal_a11__c!=null?aq.Live_Goal_a11__c:0)+(aq.Live_Goal_b11__c!=null?aq.Live_Goal_b11__c:0)+
                            (aq.Live_Goal_c11__c!=null?aq.Live_Goal_c11__c:0)+(aq.Live_Goal_d11__c!=null?aq.Live_Goal_d11__c:0);
                        
                        acqGoals.decTotal_lg = 
                            acqGoals.decTotal_lg+(aq.Live_Goal_ap12__c!=null?aq.Live_Goal_ap12__c:0)+
                            (aq.Live_Goal_a12__c!=null?aq.Live_Goal_a12__c:0)+(aq.Live_Goal_b12__c!=null?aq.Live_Goal_b12__c:0)+
                            (aq.Live_Goal_c12__c!=null?aq.Live_Goal_c12__c:0)+(aq.Live_Goal_d12__c!=null?aq.Live_Goal_d12__c:0);
                    }
                    
                    {
                        acqGoals.janTotal_in = 
                            acqGoals.janTotal_in+(aq.In_Negotiation_Titles_ap1__c!=null?aq.In_Negotiation_Titles_ap1__c:0)+
                            (aq.In_Negotiation_Titles_a1__c!=null?aq.In_Negotiation_Titles_a1__c:0)+(aq.In_Negotiation_Titles_b1__c!=null?aq.In_Negotiation_Titles_b1__c:0)+
                            (aq.In_Negotiation_Titles_c1__c!=null?aq.In_Negotiation_Titles_c1__c:0)+(aq.In_Negotiation_Titles_d1__c!=null?aq.In_Negotiation_Titles_d1__c:0);
                        
                        acqGoals.febTotal_in = 
                            acqGoals.febTotal_in+(aq.In_Negotiation_Titles_ap2__c!=null?aq.In_Negotiation_Titles_ap2__c:0)+
                            (aq.In_Negotiation_Titles_a2__c!=null?aq.In_Negotiation_Titles_a2__c:0)+(aq.In_Negotiation_Titles_b2__c!=null?aq.In_Negotiation_Titles_b2__c:0)+
                            (aq.In_Negotiation_Titles_c2__c!=null?aq.In_Negotiation_Titles_c2__c:0)+(aq.In_Negotiation_Titles_d2__c!=null?aq.In_Negotiation_Titles_d2__c:0);
                        
                        acqGoals.marTotal_in = 
                            acqGoals.marTotal_in+(aq.In_Negotiation_Titles_ap3__c!=null?aq.In_Negotiation_Titles_ap3__c:0)+
                            (aq.In_Negotiation_Titles_a3__c!=null?aq.In_Negotiation_Titles_a3__c:0)+(aq.In_Negotiation_Titles_b3__c!=null?aq.In_Negotiation_Titles_b3__c:0)+
                            (aq.In_Negotiation_Titles_c3__c!=null?aq.In_Negotiation_Titles_c3__c:0)+(aq.In_Negotiation_Titles_d3__c!=null?aq.In_Negotiation_Titles_d3__c:0);
                        
                        acqGoals.aprTotal_in = 
                            acqGoals.aprTotal_in+(aq.In_Negotiation_Titles_ap4__c!=null?aq.In_Negotiation_Titles_ap4__c:0)+
                            (aq.In_Negotiation_Titles_a4__c!=null?aq.In_Negotiation_Titles_a4__c:0)+(aq.In_Negotiation_Titles_b4__c!=null?aq.In_Negotiation_Titles_b4__c:0)+
                            (aq.In_Negotiation_Titles_c4__c!=null?aq.In_Negotiation_Titles_c4__c:0)+(aq.In_Negotiation_Titles_d4__c!=null?aq.In_Negotiation_Titles_d4__c:0);
                        
                        acqGoals.mayTotal_in = 
                            acqGoals.mayTotal_in+(aq.In_Negotiation_Titles_ap5__c!=null?aq.In_Negotiation_Titles_ap5__c:0)+
                            (aq.In_Negotiation_Titles_a5__c!=null?aq.In_Negotiation_Titles_a5__c:0)+(aq.In_Negotiation_Titles_b5__c!=null?aq.In_Negotiation_Titles_b5__c:0)+
                            (aq.In_Negotiation_Titles_c5__c!=null?aq.In_Negotiation_Titles_c5__c:0)+(aq.In_Negotiation_Titles_d5__c!=null?aq.In_Negotiation_Titles_d5__c:0);
                        
                        acqGoals.junTotal_in = 
                            acqGoals.junTotal_in+(aq.In_Negotiation_Titles_ap6__c!=null?aq.In_Negotiation_Titles_ap6__c:0)+
                            (aq.In_Negotiation_Titles_a6__c!=null?aq.In_Negotiation_Titles_a6__c:0)+(aq.In_Negotiation_Titles_b6__c!=null?aq.In_Negotiation_Titles_b6__c:0)+
                            (aq.In_Negotiation_Titles_c6__c!=null?aq.In_Negotiation_Titles_c6__c:0)+(aq.In_Negotiation_Titles_d6__c!=null?aq.In_Negotiation_Titles_d6__c:0);
                        
                        acqGoals.julTotal_in = 
                            acqGoals.julTotal_in+(aq.In_Negotiation_Titles_ap7__c!=null?aq.In_Negotiation_Titles_ap7__c:0)+
                            (aq.In_Negotiation_Titles_a7__c!=null?aq.In_Negotiation_Titles_a7__c:0)+(aq.In_Negotiation_Titles_b7__c!=null?aq.In_Negotiation_Titles_b7__c:0)+
                            (aq.In_Negotiation_Titles_c7__c!=null?aq.In_Negotiation_Titles_c7__c:0)+(aq.In_Negotiation_Titles_d7__c!=null?aq.In_Negotiation_Titles_d7__c:0);
                        
                        acqGoals.augTotal_in = 
                            acqGoals.augTotal_in+(aq.In_Negotiation_Titles_ap8__c!=null?aq.In_Negotiation_Titles_ap8__c:0)+
                            (aq.In_Negotiation_Titles_a8__c!=null?aq.In_Negotiation_Titles_a8__c:0)+(aq.In_Negotiation_Titles_b8__c!=null?aq.In_Negotiation_Titles_b8__c:0)+
                            (aq.In_Negotiation_Titles_c8__c!=null?aq.In_Negotiation_Titles_c8__c:0)+(aq.In_Negotiation_Titles_d8__c!=null?aq.In_Negotiation_Titles_d8__c:0);
                        
                        acqGoals.sepTotal_in = 
                            acqGoals.sepTotal_in+(aq.In_Negotiation_Titles_ap9__c!=null?aq.In_Negotiation_Titles_ap9__c:0)+
                            (aq.In_Negotiation_Titles_a9__c!=null?aq.In_Negotiation_Titles_a9__c:0)+(aq.In_Negotiation_Titles_b9__c!=null?aq.In_Negotiation_Titles_b9__c:0)+
                            (aq.In_Negotiation_Titles_c9__c!=null?aq.In_Negotiation_Titles_c9__c:0)+(aq.In_Negotiation_Titles_d9__c!=null?aq.In_Negotiation_Titles_d9__c:0);
                        
                        acqGoals.octTotal_in = 
                            acqGoals.octTotal_in+(aq.In_Negotiation_Titles_ap10__c!=null?aq.In_Negotiation_Titles_ap10__c:0)+
                            (aq.In_Negotiation_Titles_a10__c!=null?aq.In_Negotiation_Titles_a10__c:0)+(aq.In_Negotiation_Titles_b10__c!=null?aq.In_Negotiation_Titles_b10__c:0)+
                            (aq.In_Negotiation_Titles_c10__c!=null?aq.In_Negotiation_Titles_c10__c:0)+(aq.In_Negotiation_Titles_d10__c!=null?aq.In_Negotiation_Titles_d10__c:0);
                        
                        acqGoals.novTotal_in = 
                            acqGoals.novTotal_in+(aq.In_Negotiation_Titles_ap11__c!=null?aq.In_Negotiation_Titles_ap11__c:0)+
                            (aq.In_Negotiation_Titles_a11__c!=null?aq.In_Negotiation_Titles_a11__c:0)+(aq.In_Negotiation_Titles_b11__c!=null?aq.In_Negotiation_Titles_b11__c:0)+
                            (aq.In_Negotiation_Titles_c11__c!=null?aq.In_Negotiation_Titles_c11__c:0)+(aq.In_Negotiation_Titles_d11__c!=null?aq.In_Negotiation_Titles_d11__c:0);
                        
                        acqGoals.decTotal_in = 
                            acqGoals.decTotal_in+(aq.In_Negotiation_Titles_ap12__c!=null?aq.In_Negotiation_Titles_ap12__c:0)+
                            (aq.In_Negotiation_Titles_a12__c!=null?aq.In_Negotiation_Titles_a12__c:0)+(aq.In_Negotiation_Titles_b12__c!=null?aq.In_Negotiation_Titles_b12__c:0)+
                            (aq.In_Negotiation_Titles_c12__c!=null?aq.In_Negotiation_Titles_c12__c:0)+(aq.In_Negotiation_Titles_d12__c!=null?aq.In_Negotiation_Titles_d12__c:0);
                    }
                    
                    {
                        acqGoals.janTotal_pg = 
                            acqGoals.janTotal_pg+(aq.Goal_Progress_ap1__c!=null?aq.Goal_Progress_ap1__c:0)+
                            (aq.Goal_Progress_a1__c!=null?aq.Goal_Progress_a1__c:0)+(aq.Goal_Progress_b1__c!=null?aq.Goal_Progress_b1__c:0)+
                            (aq.Goal_Progress_c1__c!=null?aq.Goal_Progress_c1__c:0)+(aq.Goal_Progress_d1__c!=null?aq.Goal_Progress_d1__c:0);
                        
                        acqGoals.febTotal_pg = 
                            acqGoals.febTotal_pg+(aq.Goal_Progress_ap2__c!=null?aq.Goal_Progress_ap2__c:0)+
                            (aq.Goal_Progress_a2__c!=null?aq.Goal_Progress_a2__c:0)+(aq.Goal_Progress_b2__c!=null?aq.Goal_Progress_b2__c:0)+
                            (aq.Goal_Progress_c2__c!=null?aq.Goal_Progress_c2__c:0)+(aq.Goal_Progress_d2__c!=null?aq.Goal_Progress_d2__c:0);
                        
                        acqGoals.marTotal_pg = 
                            acqGoals.marTotal_pg+(aq.Goal_Progress_ap3__c!=null?aq.Goal_Progress_ap3__c:0)+
                            (aq.Goal_Progress_a3__c!=null?aq.Goal_Progress_a3__c:0)+(aq.Goal_Progress_b3__c!=null?aq.Goal_Progress_b3__c:0)+
                            (aq.Goal_Progress_c3__c!=null?aq.Goal_Progress_c3__c:0)+(aq.Goal_Progress_d3__c!=null?aq.Goal_Progress_d3__c:0);
                        
                        acqGoals.aprTotal_pg = 
                            acqGoals.aprTotal_pg+(aq.Goal_Progress_ap4__c!=null?aq.Goal_Progress_ap4__c:0)+
                            (aq.Goal_Progress_a4__c!=null?aq.Goal_Progress_a4__c:0)+(aq.Goal_Progress_b4__c!=null?aq.Goal_Progress_b4__c:0)+
                            (aq.Goal_Progress_c4__c!=null?aq.Goal_Progress_c4__c:0)+(aq.Goal_Progress_d4__c!=null?aq.Goal_Progress_d4__c:0);
                        
                        acqGoals.mayTotal_pg = 
                            acqGoals.mayTotal_pg+(aq.Goal_Progress_ap5__c!=null?aq.Goal_Progress_ap5__c:0)+
                            (aq.Goal_Progress_a5__c!=null?aq.Goal_Progress_a5__c:0)+(aq.Goal_Progress_b5__c!=null?aq.Goal_Progress_b5__c:0)+
                            (aq.Goal_Progress_c5__c!=null?aq.Goal_Progress_c5__c:0)+(aq.Goal_Progress_d5__c!=null?aq.Goal_Progress_d5__c:0);
                        
                        acqGoals.junTotal_pg = 
                            acqGoals.junTotal_pg+(aq.Goal_Progress_ap6__c!=null?aq.Goal_Progress_ap6__c:0)+
                            (aq.Goal_Progress_a6__c!=null?aq.Goal_Progress_a6__c:0)+(aq.Goal_Progress_b6__c!=null?aq.Goal_Progress_b6__c:0)+
                            (aq.Goal_Progress_c6__c!=null?aq.Goal_Progress_c6__c:0)+(aq.Goal_Progress_d6__c!=null?aq.Goal_Progress_d6__c:0);
                        
                        acqGoals.julTotal_pg = 
                            acqGoals.julTotal_pg+(aq.Goal_Progress_ap7__c!=null?aq.Goal_Progress_ap7__c:0)+
                            (aq.Goal_Progress_a7__c!=null?aq.Goal_Progress_a7__c:0)+(aq.Goal_Progress_b7__c!=null?aq.Goal_Progress_b7__c:0)+
                            (aq.Goal_Progress_c7__c!=null?aq.Goal_Progress_c7__c:0)+(aq.Goal_Progress_d7__c!=null?aq.Goal_Progress_d7__c:0);
                        
                        acqGoals.augTotal_pg = 
                            acqGoals.augTotal_pg+(aq.Goal_Progress_ap8__c!=null?aq.Goal_Progress_ap8__c:0)+
                            (aq.Goal_Progress_a8__c!=null?aq.Goal_Progress_a8__c:0)+(aq.Goal_Progress_b8__c!=null?aq.Goal_Progress_b8__c:0)+
                            (aq.Goal_Progress_c8__c!=null?aq.Goal_Progress_c8__c:0)+(aq.Goal_Progress_d8__c!=null?aq.Goal_Progress_d8__c:0);
                        
                        acqGoals.sepTotal_pg = 
                            acqGoals.sepTotal_pg+(aq.Goal_Progress_ap9__c!=null?aq.Goal_Progress_ap9__c:0)+
                            (aq.Goal_Progress_a9__c!=null?aq.Goal_Progress_a9__c:0)+(aq.Goal_Progress_b9__c!=null?aq.Goal_Progress_b9__c:0)+
                            (aq.Goal_Progress_c9__c!=null?aq.Goal_Progress_c9__c:0)+(aq.Goal_Progress_d9__c!=null?aq.Goal_Progress_d9__c:0);
                        
                        acqGoals.octTotal_pg = 
                            acqGoals.octTotal_pg+(aq.Goal_Progress_ap10__c!=null?aq.Goal_Progress_ap10__c:0)+
                            (aq.Goal_Progress_a10__c!=null?aq.Goal_Progress_a10__c:0)+(aq.Goal_Progress_b10__c!=null?aq.Goal_Progress_b10__c:0)+
                            (aq.Goal_Progress_c10__c!=null?aq.Goal_Progress_c10__c:0)+(aq.Goal_Progress_d10__c!=null?aq.Goal_Progress_d10__c:0);
                        
                        acqGoals.novTotal_pg = 
                            acqGoals.novTotal_pg+(aq.Goal_Progress_ap11__c!=null?aq.Goal_Progress_ap11__c:0)+
                            (aq.Goal_Progress_a11__c!=null?aq.Goal_Progress_a11__c:0)+(aq.Goal_Progress_b11__c!=null?aq.Goal_Progress_b11__c:0)+
                            (aq.Goal_Progress_c11__c!=null?aq.Goal_Progress_c11__c:0)+(aq.Goal_Progress_d11__c!=null?aq.Goal_Progress_d11__c:0);
                        
                        acqGoals.decTotal_pg = 
                            acqGoals.decTotal_pg+(aq.Goal_Progress_ap12__c!=null?aq.Goal_Progress_ap12__c:0)+
                            (aq.Goal_Progress_a12__c!=null?aq.Goal_Progress_a12__c:0)+(aq.Goal_Progress_b12__c!=null?aq.Goal_Progress_b12__c:0)+
                            (aq.Goal_Progress_c12__c!=null?aq.Goal_Progress_c12__c:0)+(aq.Goal_Progress_d12__c!=null?aq.Goal_Progress_d12__c:0);
                    }
                    
                    {
                        acqGoals.janTotal_pa = 
                            acqGoals.janTotal_pa+(aq.Pre_Acquisition_Titles_ap1__c!=null?aq.Pre_Acquisition_Titles_ap1__c:0)+
                            (aq.Pre_Acquisition_Titles_a1__c!=null?aq.Pre_Acquisition_Titles_a1__c:0)+(aq.Pre_Acquisition_Titles_b1__c!=null?aq.Pre_Acquisition_Titles_b1__c:0)+
                            (aq.Pre_Acquisition_Titles_c1__c!=null?aq.Pre_Acquisition_Titles_c1__c:0)+(aq.Pre_Acquisition_Titles_d1__c!=null?aq.Pre_Acquisition_Titles_d1__c:0);
                        
                        acqGoals.febTotal_pa = 
                            acqGoals.febTotal_pa+(aq.Pre_Acquisition_Titles_ap2__c!=null?aq.Pre_Acquisition_Titles_ap2__c:0)+
                            (aq.Pre_Acquisition_Titles_a2__c!=null?aq.Pre_Acquisition_Titles_a2__c:0)+(aq.Pre_Acquisition_Titles_b2__c!=null?aq.Pre_Acquisition_Titles_b2__c:0)+
                            (aq.Pre_Acquisition_Titles_c2__c!=null?aq.Pre_Acquisition_Titles_c2__c:0)+(aq.Pre_Acquisition_Titles_d2__c!=null?aq.Pre_Acquisition_Titles_d2__c:0);
                        
                        acqGoals.marTotal_pa = 
                            acqGoals.marTotal_pa+(aq.Pre_Acquisition_Titles_ap3__c!=null?aq.Pre_Acquisition_Titles_ap3__c:0)+
                            (aq.Pre_Acquisition_Titles_a3__c!=null?aq.Pre_Acquisition_Titles_a3__c:0)+(aq.Pre_Acquisition_Titles_b3__c!=null?aq.Pre_Acquisition_Titles_b3__c:0)+
                            (aq.Pre_Acquisition_Titles_c3__c!=null?aq.Pre_Acquisition_Titles_c3__c:0)+(aq.Pre_Acquisition_Titles_d3__c!=null?aq.Pre_Acquisition_Titles_d3__c:0);
                        
                        acqGoals.aprTotal_pa = 
                            acqGoals.aprTotal_pa+(aq.Pre_Acquisition_Titles_ap4__c!=null?aq.Pre_Acquisition_Titles_ap4__c:0)+
                            (aq.Pre_Acquisition_Titles_a4__c!=null?aq.Pre_Acquisition_Titles_a4__c:0)+(aq.Pre_Acquisition_Titles_b4__c!=null?aq.Pre_Acquisition_Titles_b4__c:0)+
                            (aq.Pre_Acquisition_Titles_c4__c!=null?aq.Pre_Acquisition_Titles_c4__c:0)+(aq.Pre_Acquisition_Titles_d4__c!=null?aq.Pre_Acquisition_Titles_d4__c:0);
                        
                        acqGoals.mayTotal_pa = 
                            acqGoals.mayTotal_pa+(aq.Pre_Acquisition_Titles_ap5__c!=null?aq.Pre_Acquisition_Titles_ap5__c:0)+
                            (aq.Pre_Acquisition_Titles_a5__c!=null?aq.Pre_Acquisition_Titles_a5__c:0)+(aq.Pre_Acquisition_Titles_b5__c!=null?aq.Pre_Acquisition_Titles_b5__c:0)+
                            (aq.Pre_Acquisition_Titles_c5__c!=null?aq.Pre_Acquisition_Titles_c5__c:0)+(aq.Pre_Acquisition_Titles_d5__c!=null?aq.Pre_Acquisition_Titles_d5__c:0);
                        
                        acqGoals.junTotal_pa = 
                            acqGoals.junTotal_pa+(aq.Pre_Acquisition_Titles_ap6__c!=null?aq.Pre_Acquisition_Titles_ap6__c:0)+
                            (aq.Pre_Acquisition_Titles_a6__c!=null?aq.Pre_Acquisition_Titles_a6__c:0)+(aq.Pre_Acquisition_Titles_b6__c!=null?aq.Pre_Acquisition_Titles_b6__c:0)+
                            (aq.Pre_Acquisition_Titles_c6__c!=null?aq.Pre_Acquisition_Titles_c6__c:0)+(aq.Pre_Acquisition_Titles_d6__c!=null?aq.Pre_Acquisition_Titles_d6__c:0);
                        
                        acqGoals.julTotal_pa = 
                            acqGoals.julTotal_pa+(aq.Pre_Acquisition_Titles_ap7__c!=null?aq.Pre_Acquisition_Titles_ap7__c:0)+
                            (aq.Pre_Acquisition_Titles_a7__c!=null?aq.Pre_Acquisition_Titles_a7__c:0)+(aq.Pre_Acquisition_Titles_b7__c!=null?aq.Pre_Acquisition_Titles_b7__c:0)+
                            (aq.Pre_Acquisition_Titles_c7__c!=null?aq.Pre_Acquisition_Titles_c7__c:0)+(aq.Pre_Acquisition_Titles_d7__c!=null?aq.Pre_Acquisition_Titles_d7__c:0);
                        
                        acqGoals.augTotal_pa = 
                            acqGoals.augTotal_pa+(aq.Pre_Acquisition_Titles_ap8__c!=null?aq.Pre_Acquisition_Titles_ap8__c:0)+
                            (aq.Pre_Acquisition_Titles_a8__c!=null?aq.Pre_Acquisition_Titles_a8__c:0)+(aq.Pre_Acquisition_Titles_b8__c!=null?aq.Pre_Acquisition_Titles_b8__c:0)+
                            (aq.Pre_Acquisition_Titles_c8__c!=null?aq.Pre_Acquisition_Titles_c8__c:0)+(aq.Pre_Acquisition_Titles_d8__c!=null?aq.Pre_Acquisition_Titles_d8__c:0);
                        
                        acqGoals.sepTotal_pa = 
                            acqGoals.sepTotal_pa+(aq.Pre_Acquisition_Titles_ap9__c!=null?aq.Pre_Acquisition_Titles_ap9__c:0)+
                            (aq.Pre_Acquisition_Titles_a9__c!=null?aq.Pre_Acquisition_Titles_a9__c:0)+(aq.Pre_Acquisition_Titles_b9__c!=null?aq.Pre_Acquisition_Titles_b9__c:0)+
                            (aq.Pre_Acquisition_Titles_c9__c!=null?aq.Pre_Acquisition_Titles_c9__c:0)+(aq.Pre_Acquisition_Titles_d9__c!=null?aq.Pre_Acquisition_Titles_d9__c:0);
                        
                        acqGoals.octTotal_pa = 
                            acqGoals.octTotal_pa+(aq.Pre_Acquisition_Titles_ap10__c!=null?aq.Pre_Acquisition_Titles_ap10__c:0)+
                            (aq.Pre_Acquisition_Titles_a10__c!=null?aq.Pre_Acquisition_Titles_a10__c:0)+(aq.Pre_Acquisition_Titles_b10__c!=null?aq.Pre_Acquisition_Titles_b10__c:0)+
                            (aq.Pre_Acquisition_Titles_c10__c!=null?aq.Pre_Acquisition_Titles_c10__c:0)+(aq.Pre_Acquisition_Titles_d10__c!=null?aq.Pre_Acquisition_Titles_d10__c:0);
                        
                        acqGoals.novTotal_pa = 
                            acqGoals.novTotal_pa+(aq.Pre_Acquisition_Titles_ap11__c!=null?aq.Pre_Acquisition_Titles_ap11__c:0)+
                            (aq.Pre_Acquisition_Titles_a11__c!=null?aq.Pre_Acquisition_Titles_a11__c:0)+(aq.Pre_Acquisition_Titles_b11__c!=null?aq.Pre_Acquisition_Titles_b11__c:0)+
                            (aq.Pre_Acquisition_Titles_c11__c!=null?aq.Pre_Acquisition_Titles_c11__c:0)+(aq.Pre_Acquisition_Titles_d11__c!=null?aq.Pre_Acquisition_Titles_d11__c:0);
                        
                        acqGoals.decTotal_pa = 
                            acqGoals.decTotal_pa+(aq.Pre_Acquisition_Titles_ap12__c!=null?aq.Pre_Acquisition_Titles_ap12__c:0)+
                            (aq.Pre_Acquisition_Titles_a12__c!=null?aq.Pre_Acquisition_Titles_a12__c:0)+(aq.Pre_Acquisition_Titles_b12__c!=null?aq.Pre_Acquisition_Titles_b12__c:0)+
                            (aq.Pre_Acquisition_Titles_c12__c!=null?aq.Pre_Acquisition_Titles_c12__c:0)+(aq.Pre_Acquisition_Titles_d12__c!=null?aq.Pre_Acquisition_Titles_d12__c:0);
                    }
                    
                    //total section total roll-ups
                    {
                        acqGoals.t_lg_TRU = 
                            acqGoals.t_lg_TRU+(acqGoals.ap_lg_TRU!=null?acqGoals.ap_lg_TRU:0)+
                            (acqGoals.a_lg_TRU!=null?acqGoals.a_lg_TRU:0)+(acqGoals.b_lg_TRU!=null?acqGoals.b_lg_TRU:0)+
                            (acqGoals.c_lg_TRU!=null?acqGoals.c_lg_TRU:0)+(acqGoals.d_lg_TRU!=null?acqGoals.d_lg_TRU:0);
                        
                        acqGoals.t_aq_TRU = 
                            acqGoals.t_aq_TRU+(acqGoals.ap_aq_TRU!=null?acqGoals.ap_aq_TRU:0)+
                            (acqGoals.a_aq_TRU!=null?acqGoals.a_aq_TRU:0)+(acqGoals.b_aq_TRU!=null?acqGoals.b_aq_TRU:0)+
                            (acqGoals.c_aq_TRU!=null?acqGoals.c_aq_TRU:0)+(acqGoals.d_aq_TRU!=null?acqGoals.d_aq_TRU:0);
                        
                        acqGoals.t_gp_TRU = 
                            acqGoals.t_gp_TRU+(acqGoals.ap_gp_TRU!=null?acqGoals.ap_gp_TRU:0)+
                            (acqGoals.a_gp_TRU!=null?acqGoals.a_gp_TRU:0)+(acqGoals.b_gp_TRU!=null?acqGoals.b_gp_TRU:0)+
                            (acqGoals.c_gp_TRU!=null?acqGoals.c_gp_TRU:0)+(acqGoals.d_gp_TRU!=null?acqGoals.d_gp_TRU:0);
                        
                        acqGoals.t_in_TRU = 
                            acqGoals.t_in_TRU+(acqGoals.ap_in_TRU!=null?acqGoals.ap_in_TRU:0)+
                            (acqGoals.a_in_TRU!=null?acqGoals.a_in_TRU:0)+(acqGoals.b_in_TRU!=null?acqGoals.b_in_TRU:0)+
                            (acqGoals.c_in_TRU!=null?acqGoals.c_in_TRU:0)+(acqGoals.d_in_TRU!=null?acqGoals.d_in_TRU:0);
                        
                        acqGoals.t_pa_TRU = 
                            acqGoals.t_pa_TRU+(acqGoals.ap_pa_TRU!=null?acqGoals.ap_pa_TRU:0)+
                            (acqGoals.a_pa_TRU!=null?acqGoals.a_pa_TRU:0)+(acqGoals.b_pa_TRU!=null?acqGoals.b_pa_TRU:0)+
                            (acqGoals.c_pa_TRU!=null?acqGoals.c_pa_TRU:0)+(acqGoals.d_pa_TRU!=null?acqGoals.d_pa_TRU:0);
                    }


                } //end roll up field for loop
                
            }
            
        }
    } 
    
    /* Details Modal Start */
    public void getDetails(){
        list<string> titleStatus = new list<String>();//label.titleStatus.split(',');
        set<string> tierSet = new set<string>();
        set<string> allTierSet = new set<string>{'A+', 'A', 'B', 'C', 'D'};
            
            if(tier=='allTiers'){
                tierSet.addAll(allTierSet);
            }else{
                tierSet.add(tier);
            }
        
        for(String st: label.titleStatus.split(','))
            titleStatus.add(st.trim());
        System.debug('etx' + titleStatus);
        
        titleRecords = new list< Title__c >();
        String query = 'SELECT ';
        integer agYearval = Integer.valueOf(yearSel);
        integer monthval = Integer.valueOf(month); // convert text to integer, Formula Field required for querying recrods
        string referralSource='BULK-APubDE';
        for(String sfield : fieldMap1.keyset())
        {
            query = query+sfield+',';
        }
        query = query.removeend(',');  // Dynamic Query String, it has all the field values using schema describe 
        System.debug('query'+query);
        
        query = query+' FROM Title__c WHERE yearOfDpd__c = '+agYearval+' AND monthOfDPD__c = '+monthval+' AND Internal_Imprint__c =:internalImprintsSel AND Status__c =:titleStatus AND Referral_Source__c!=:referralSource AND Sales_Tier__c IN :tierSet ORDER BY digital_publication_date__c ASC';
        System.debug('query'+query);
        /* Ttile object dymanic query **/
        titleRecords = database.query(query);
    }
    
    public class summaryRecord{
        public decimal apjanT{get;set;}
        public decimal apfebT{get;set;}
        public decimal apmarT{get;set;}
        public decimal apaprT{get;set;}
        public decimal apmayT{get;set;}
        public decimal apjuneT{get;set;}
        public decimal apjulyT{get;set;}
        public decimal apaugT{get;set;}
        public decimal apsepT{get;set;}
        public decimal apoctT{get;set;}
        public decimal apnovT{get;set;}
        public decimal apdecT{get;set;}
        
        
        public decimal ajanT{get;set;}
        public decimal afebT{get;set;}
        public decimal amarT{get;set;}
        public decimal aaprT{get;set;}
        public decimal amayT{get;set;}
        public decimal ajuneT{get;set;}
        public decimal ajulyT{get;set;}
        public decimal aaugT{get;set;}
        public decimal asepT{get;set;}
        public decimal aoctT{get;set;}
        public decimal anovT{get;set;}
        public decimal adecT{get;set;} 
        
        public decimal bjanT{get;set;}
        public decimal bfebT{get;set;}
        public decimal bmarT{get;set;}
        public decimal baprT{get;set;}
        public decimal bmayT{get;set;}
        public decimal bjuneT{get;set;}
        public decimal bjulyT{get;set;}
        public decimal baugT{get;set;}
        public decimal bsepT{get;set;}
        public decimal boctT{get;set;}
        public decimal bnovT{get;set;}
        public decimal bdecT{get;set;}
        
        public decimal cjanT{get;set;}
        public decimal cfebT{get;set;}
        public decimal cmarT{get;set;}
        public decimal caprT{get;set;}
        public decimal cmayT{get;set;}
        public decimal cjuneT{get;set;}
        public decimal cjulyT{get;set;}
        public decimal caugT{get;set;}
        public decimal csepT{get;set;}
        public decimal coctT{get;set;}
        public decimal cnovT{get;set;}
        public decimal cdecT{get;set;}
        
        public decimal djanT{get;set;}
        public decimal dfebT{get;set;}
        public decimal dmarT{get;set;}
        public decimal daprT{get;set;}
        public decimal dmayT{get;set;}
        public decimal djuneT{get;set;}
        public decimal djulyT{get;set;}
        public decimal daugT{get;set;}
        public decimal dsepT{get;set;}
        public decimal doctT{get;set;}
        public decimal dnovT{get;set;}
        public decimal ddecT{get;set;}   
        
        //Wrapper getters and setters
        
        public decimal apjanLG{get;set;}
        public decimal apfebLG{get;set;}
        public decimal apmarLG{get;set;}
        public decimal apaprLG{get;set;}
        public decimal apmayLG{get;set;}
        public decimal apjuneLG{get;set;}
        public decimal apjulyLG{get;set;}
        public decimal apaugLG{get;set;}
        public decimal apsepLG{get;set;}
        public decimal apoctLG{get;set;}
        public decimal apnovLG{get;set;}
        public decimal apdecLG{get;set;}
        
        public decimal apjanAG{get;set;}
        public decimal apfebAG{get;set;}
        public decimal apmarAG{get;set;}
        public decimal apaprAG{get;set;}
        public decimal apmayAG{get;set;}
        public decimal apjuneAG{get;set;}
        public decimal apjulyAG{get;set;}
        public decimal apaugAG{get;set;}
        public decimal apsepAG{get;set;}
        public decimal apoctAG{get;set;}
        public decimal apnovAG{get;set;}
        public decimal apdecAG{get;set;}
        
        public decimal apjanIN{get;set;}
        public decimal apfebIN{get;set;}
        public decimal apmarIN{get;set;}
        public decimal apaprIN{get;set;}
        public decimal apmayIN{get;set;}
        public decimal apjuneIN{get;set;}
        public decimal apjulyIN{get;set;}
        public decimal apaugIN{get;set;}
        public decimal apsepIN{get;set;}
        public decimal apoctIN{get;set;}
        public decimal apnovIN{get;set;}
        public decimal apdecIN{get;set;}
        
        public decimal apjanPA{get;set;}
        public decimal apfebPA{get;set;}
        public decimal apmarPA{get;set;}
        public decimal apaprPA{get;set;}
        public decimal apmayPA{get;set;}
        public decimal apjunePA{get;set;}
        public decimal apjulyPA{get;set;}
        public decimal apaugPA{get;set;}
        public decimal apsepPA{get;set;}
        public decimal apoctPA{get;set;}
        public decimal apnovPA{get;set;}
        public decimal apdecPA{get;set;}
        
        public decimal apjanPG{get;set;}
        public decimal apfebPG{get;set;}
        public decimal apmarPG{get;set;}
        public decimal apaprPG{get;set;}
        public decimal apmayPG{get;set;}
        public decimal apjunePG{get;set;}
        public decimal apjulyPG{get;set;}
        public decimal apaugPG{get;set;}
        public decimal apsepPG{get;set;}
        public decimal apoctPG{get;set;}
        public decimal apnovPG{get;set;}
        public decimal apdecPG{get;set;}
        
        //a
        
        public decimal ajanLG{get;set;}
        public decimal afebLG{get;set;}
        public decimal amarLG{get;set;}
        public decimal aaprLG{get;set;}
        public decimal amayLG{get;set;}
        public decimal ajuneLG{get;set;}
        public decimal ajulyLG{get;set;}
        public decimal aaugLG{get;set;}
        public decimal asepLG{get;set;}
        public decimal aoctLG{get;set;}
        public decimal anovLG{get;set;}
        public decimal adecLG{get;set;}
        
        public decimal ajanAG{get;set;}
        public decimal afebAG{get;set;}
        public decimal amarAG{get;set;}
        public decimal aaprAG{get;set;}
        public decimal amayAG{get;set;}
        public decimal ajuneAG{get;set;}
        public decimal ajulyAG{get;set;}
        public decimal aaugAG{get;set;}
        public decimal asepAG{get;set;}
        public decimal aoctAG{get;set;}
        public decimal anovAG{get;set;}
        public decimal adecAG{get;set;}
        
        public decimal ajanIN{get;set;}
        public decimal afebIN{get;set;}
        public decimal amarIN{get;set;}
        public decimal aaprIN{get;set;}
        public decimal amayIN{get;set;}
        public decimal ajuneIN{get;set;}
        public decimal ajulyIN{get;set;}
        public decimal aaugIN{get;set;}
        public decimal asepIN{get;set;}
        public decimal aoctIN{get;set;}
        public decimal anovIN{get;set;}
        public decimal adecIN{get;set;}
        
        public decimal ajanPA{get;set;}
        public decimal afebPA{get;set;}
        public decimal amarPA{get;set;}
        public decimal aaprPA{get;set;}
        public decimal amayPA{get;set;}
        public decimal ajunePA{get;set;}
        public decimal ajulyPA{get;set;}
        public decimal aaugPA{get;set;}
        public decimal asepPA{get;set;}
        public decimal aoctPA{get;set;}
        public decimal anovPA{get;set;}
        public decimal adecPA{get;set;}
        
        public decimal ajanPG{get;set;}
        public decimal afebPG{get;set;}
        public decimal amarPG{get;set;}
        public decimal aaprPG{get;set;}
        public decimal amayPG{get;set;}
        public decimal ajunePG{get;set;}
        public decimal ajulyPG{get;set;}
        public decimal aaugPG{get;set;}
        public decimal asepPG{get;set;}
        public decimal aoctPG{get;set;}
        public decimal anovPG{get;set;}
        public decimal adecPG{get;set;}
        
        //b
        
        public decimal bjanLG{get;set;}
        public decimal bfebLG{get;set;}
        public decimal bmarLG{get;set;}
        public decimal baprLG{get;set;}
        public decimal bmayLG{get;set;}
        public decimal bjuneLG{get;set;}
        public decimal bjulyLG{get;set;}
        public decimal baugLG{get;set;}
        public decimal bsepLG{get;set;}
        public decimal boctLG{get;set;}
        public decimal bnovLG{get;set;}
        public decimal bdecLG{get;set;}
        
        public decimal bjanAG{get;set;}
        public decimal bfebAG{get;set;}
        public decimal bmarAG{get;set;}
        public decimal baprAG{get;set;}
        public decimal bmayAG{get;set;}
        public decimal bjuneAG{get;set;}
        public decimal bjulyAG{get;set;}
        public decimal baugAG{get;set;}
        public decimal bsepAG{get;set;}
        public decimal boctAG{get;set;}
        public decimal bnovAG{get;set;}
        public decimal bdecAG{get;set;}
        
        public decimal bjanIN{get;set;}
        public decimal bfebIN{get;set;}
        public decimal bmarIN{get;set;}
        public decimal baprIN{get;set;}
        public decimal bmayIN{get;set;}
        public decimal bjuneIN{get;set;}
        public decimal bjulyIN{get;set;}
        public decimal baugIN{get;set;}
        public decimal bsepIN{get;set;}
        public decimal boctIN{get;set;}
        public decimal bnovIN{get;set;}
        public decimal bdecIN{get;set;}
        
        public decimal bjanPA{get;set;}
        public decimal bfebPA{get;set;}
        public decimal bmarPA{get;set;}
        public decimal baprPA{get;set;}
        public decimal bmayPA{get;set;}
        public decimal bjunePA{get;set;}
        public decimal bjulyPA{get;set;}
        public decimal baugPA{get;set;}
        public decimal bsepPA{get;set;}
        public decimal boctPA{get;set;}
        public decimal bnovPA{get;set;}
        public decimal bdecPA{get;set;}
        
        public decimal bjanPG{get;set;}
        public decimal bfebPG{get;set;}
        public decimal bmarPG{get;set;}
        public decimal baprPG{get;set;}
        public decimal bmayPG{get;set;}
        public decimal bjunePG{get;set;}
        public decimal bjulyPG{get;set;}
        public decimal baugPG{get;set;}
        public decimal bsepPG{get;set;}
        public decimal boctPG{get;set;}
        public decimal bnovPG{get;set;}
        public decimal bdecPG{get;set;}
        
        //c
        
        public decimal cjanLG{get;set;}
        public decimal cfebLG{get;set;}
        public decimal cmarLG{get;set;}
        public decimal caprLG{get;set;}
        public decimal cmayLG{get;set;}
        public decimal cjuneLG{get;set;}
        public decimal cjulyLG{get;set;}
        public decimal caugLG{get;set;}
        public decimal csepLG{get;set;}
        public decimal coctLG{get;set;}
        public decimal cnovLG{get;set;}
        public decimal cdecLG{get;set;}
        
        public decimal cjanAG{get;set;}
        public decimal cfebAG{get;set;}
        public decimal cmarAG{get;set;}
        public decimal caprAG{get;set;}
        public decimal cmayAG{get;set;}
        public decimal cjuneAG{get;set;}
        public decimal cjulyAG{get;set;}
        public decimal caugAG{get;set;}
        public decimal csepAG{get;set;}
        public decimal coctAG{get;set;}
        public decimal cnovAG{get;set;}
        public decimal cdecAG{get;set;}
        
        public decimal cjanIN{get;set;}
        public decimal cfebIN{get;set;}
        public decimal cmarIN{get;set;}
        public decimal caprIN{get;set;}
        public decimal cmayIN{get;set;}
        public decimal cjuneIN{get;set;}
        public decimal cjulyIN{get;set;}
        public decimal caugIN{get;set;}
        public decimal csepIN{get;set;}
        public decimal coctIN{get;set;}
        public decimal cnovIN{get;set;}
        public decimal cdecIN{get;set;}
        
        public decimal cjanPA{get;set;}
        public decimal cfebPA{get;set;}
        public decimal cmarPA{get;set;}
        public decimal caprPA{get;set;}
        public decimal cmayPA{get;set;}
        public decimal cjunePA{get;set;}
        public decimal cjulyPA{get;set;}
        public decimal caugPA{get;set;}
        public decimal csepPA{get;set;}
        public decimal coctPA{get;set;}
        public decimal cnovPA{get;set;}
        public decimal cdecPA{get;set;}
        
        public decimal cjanPG{get;set;}
        public decimal cfebPG{get;set;}
        public decimal cmarPG{get;set;}
        public decimal caprPG{get;set;}
        public decimal cmayPG{get;set;}
        public decimal cjunePG{get;set;}
        public decimal cjulyPG{get;set;}
        public decimal caugPG{get;set;}
        public decimal csepPG{get;set;}
        public decimal coctPG{get;set;}
        public decimal cnovPG{get;set;}
        public decimal cdecPG{get;set;}
        
        //d
        
        public decimal djanLG{get;set;}
        public decimal dfebLG{get;set;}
        public decimal dmarLG{get;set;}
        public decimal daprLG{get;set;}
        public decimal dmayLG{get;set;}
        public decimal djuneLG{get;set;}
        public decimal djulyLG{get;set;}
        public decimal daugLG{get;set;}
        public decimal dsepLG{get;set;}
        public decimal doctLG{get;set;}
        public decimal dnovLG{get;set;}
        public decimal ddecLG{get;set;}
        
        public decimal djanAG{get;set;}
        public decimal dfebAG{get;set;}
        public decimal dmarAG{get;set;}
        public decimal daprAG{get;set;}
        public decimal dmayAG{get;set;}
        public decimal djuneAG{get;set;}
        public decimal djulyAG{get;set;}
        public decimal daugAG{get;set;}
        public decimal dsepAG{get;set;}
        public decimal doctAG{get;set;}
        public decimal dnovAG{get;set;}
        public decimal ddecAG{get;set;}
        
        public decimal djanIN{get;set;}
        public decimal dfebIN{get;set;}
        public decimal dmarIN{get;set;}
        public decimal daprIN{get;set;}
        public decimal dmayIN{get;set;}
        public decimal djuneIN{get;set;}
        public decimal djulyIN{get;set;}
        public decimal daugIN{get;set;}
        public decimal dsepIN{get;set;}
        public decimal doctIN{get;set;}
        public decimal dnovIN{get;set;}
        public decimal ddecIN{get;set;}
        
        public decimal djanPA{get;set;}
        public decimal dfebPA{get;set;}
        public decimal dmarPA{get;set;}
        public decimal daprPA{get;set;}
        public decimal dmayPA{get;set;}
        public decimal djunePA{get;set;}
        public decimal djulyPA{get;set;}
        public decimal daugPA{get;set;}
        public decimal dsepPA{get;set;}
        public decimal doctPA{get;set;}
        public decimal dnovPA{get;set;}
        public decimal ddecPA{get;set;}
        
        public decimal djanPG{get;set;}
        public decimal dfebPG{get;set;}
        public decimal dmarPG{get;set;}
        public decimal daprPG{get;set;}
        public decimal dmayPG{get;set;}
        public decimal djunePG{get;set;}
        public decimal djulyPG{get;set;}
        public decimal daugPG{get;set;}
        public decimal dsepPG{get;set;}
        public decimal doctPG{get;set;}
        public decimal dnovPG{get;set;}
        public decimal ddecPG{get;set;}
        
        //tier status total roll-ups
        
        public decimal ap_aq_TRU {get;set;}
        public decimal ap_in_TRU {get;set;}
        public decimal ap_pa_TRU {get;set;}
        public decimal ap_gp_TRU {get;set;}
        public decimal ap_lg_TRU {get;set;}
        
        public decimal a_aq_TRU {get;set;}
        public decimal a_in_TRU {get;set;}
        public decimal a_pa_TRU {get;set;}
        public decimal a_gp_TRU {get;set;}
        public decimal a_lg_TRU {get;set;}
        
        public decimal b_aq_TRU {get;set;}
        public decimal b_in_TRU {get;set;}
        public decimal b_pa_TRU {get;set;}
        public decimal b_gp_TRU {get;set;}
        public decimal b_lg_TRU {get;set;}
        
        public decimal c_aq_TRU {get;set;}
        public decimal c_in_TRU {get;set;}
        public decimal c_pa_TRU {get;set;}
        public decimal c_gp_TRU {get;set;}
        public decimal c_lg_TRU {get;set;}
        
        public decimal d_aq_TRU {get;set;}
        public decimal d_in_TRU {get;set;}
        public decimal d_pa_TRU {get;set;}
        public decimal d_gp_TRU {get;set;}
        public decimal d_lg_TRU {get;set;}
        
        //month acquired totals
        public decimal janTotal_aq {get;set;}
        public decimal febTotal_aq {get;set;}
        public decimal marTotal_aq {get;set;}
        public decimal aprTotal_aq {get;set;}
        public decimal mayTotal_aq {get;set;}
        public decimal junTotal_aq {get;set;}
        public decimal julTotal_aq {get;set;}
        public decimal augTotal_aq {get;set;}
        public decimal sepTotal_aq {get;set;}
        public decimal octTotal_aq {get;set;}
        public decimal novTotal_aq {get;set;}
        public decimal decTotal_aq {get;set;}
        
        //month business goal totals
        public decimal janTotal_bg {get;set;}
        public decimal febTotal_bg {get;set;}
        public decimal marTotal_bg {get;set;}
        public decimal aprTotal_bg {get;set;}
        public decimal mayTotal_bg {get;set;}
        public decimal junTotal_bg {get;set;}
        public decimal julTotal_bg {get;set;}
        public decimal augTotal_bg {get;set;}
        public decimal sepTotal_bg {get;set;}
        public decimal octTotal_bg {get;set;}
        public decimal novTotal_bg {get;set;}
        public decimal decTotal_bg {get;set;}
        
        //month live goal totals
        public decimal janTotal_lg {get;set;}
        public decimal febTotal_lg {get;set;}
        public decimal marTotal_lg {get;set;}
        public decimal aprTotal_lg {get;set;}
        public decimal mayTotal_lg {get;set;}
        public decimal junTotal_lg {get;set;}
        public decimal julTotal_lg {get;set;}
        public decimal augTotal_lg {get;set;}
        public decimal sepTotal_lg {get;set;}
        public decimal octTotal_lg {get;set;}
        public decimal novTotal_lg {get;set;}
        public decimal decTotal_lg {get;set;}
        
        //month progress totals
        public decimal janTotal_pg {get;set;}
        public decimal febTotal_pg {get;set;}
        public decimal marTotal_pg {get;set;}
        public decimal aprTotal_pg {get;set;}
        public decimal mayTotal_pg {get;set;}
        public decimal junTotal_pg {get;set;}
        public decimal julTotal_pg {get;set;}
        public decimal augTotal_pg {get;set;}
        public decimal sepTotal_pg {get;set;}
        public decimal octTotal_pg {get;set;}
        public decimal novTotal_pg {get;set;}
        public decimal decTotal_pg {get;set;}
        
        //month in negotiation totals
        public decimal janTotal_in {get;set;}
        public decimal febTotal_in {get;set;}
        public decimal marTotal_in {get;set;}
        public decimal aprTotal_in {get;set;}
        public decimal mayTotal_in {get;set;}
        public decimal junTotal_in {get;set;}
        public decimal julTotal_in {get;set;}
        public decimal augTotal_in {get;set;}
        public decimal sepTotal_in {get;set;}
        public decimal octTotal_in {get;set;}
        public decimal novTotal_in {get;set;}
        public decimal decTotal_in {get;set;}
        
        //month pre-acquisition totals
        public decimal janTotal_pa {get;set;}
        public decimal febTotal_pa {get;set;}
        public decimal marTotal_pa {get;set;}
        public decimal aprTotal_pa {get;set;}
        public decimal mayTotal_pa {get;set;}
        public decimal junTotal_pa {get;set;}
        public decimal julTotal_pa {get;set;}
        public decimal augTotal_pa {get;set;}
        public decimal sepTotal_pa {get;set;}
        public decimal octTotal_pa {get;set;}
        public decimal novTotal_pa {get;set;}
        public decimal decTotal_pa {get;set;}
        
        public decimal t_aq_TRU {get;set;}
        public decimal t_in_TRU {get;set;}
        public decimal t_pa_TRU {get;set;}
        public decimal t_gp_TRU {get;set;}
        public decimal t_lg_TRU {get;set;}
        
        public summaryRecord()
        {
            apjanT=0;apfebT=0;apmarT=0;apaprT=0;apmayT=0;apjuneT=0;apjulyT=0;apaugT=0;apsepT=0;apoctT=0;apnovT=0;apdecT=0; 
            apjanLG=0;apfebLG=0;apmarLG=0;apaprLG=0;apmayLG=0;apjuneLG=0;apjulyLG=0;apaugLG=0;apsepLG=0;apoctLG=0;apnovLG=0;apdecLG=0;
            apjanAG=0;apfebAG=0;apmarAG=0;apaprAG=0;apmayAG=0;apjuneAG=0;apjulyAG=0;apaugAG=0;apsepAG=0;apoctAG=0;apnovAG=0;apdecAG=0;
            apjanIN=0;apfebIN=0;apmarIN=0;apaprIN=0;apmayIN=0;apjuneIN=0;apjulyIN=0;apaugIN=0;apsepIN=0;apoctIN=0;apnovIN=0;apdecIN=0;
            apjanPA=0;apfebPA=0;apmarPA=0;apaprPA=0;apmayPA=0;apjunePA=0;apjulyPA=0;apaugPA=0;apsepPA=0;apoctPA=0;apnovPA=0;apdecPA=0;
            apjanPG=0;apfebPG=0;apmarPG=0;apaprPG=0;apmayPG=0;apjunePG=0;apjulyPG=0;apaugPG=0;apsepPG=0;apoctPG=0;apnovPG=0;apdecPG=0;
            
            ajanT=0;afebT=0;amarT=0;aaprT=0;amayT=0;ajuneT=0;ajulyT=0;aaugT=0;asepT=0;aoctT=0;anovT=0;adecT=0; 
            ajanLG=0;afebLG=0;amarLG=0;aaprLG=0;amayLG=0;ajuneLG=0;ajulyLG=0;aaugLG=0;asepLG=0;aoctLG=0;anovLG=0;adecLG=0;
            ajanAG=0;afebAG=0;amarAG=0;aaprAG=0;amayAG=0;ajuneAG=0;ajulyAG=0;aaugAG=0;asepAG=0;aoctAG=0;anovAG=0;adecAG=0;
            ajanIN=0;afebIN=0;amarIN=0;aaprIN=0;amayIN=0;ajuneIN=0;ajulyIN=0;aaugIN=0;asepIN=0;aoctIN=0;anovIN=0;adecIN=0;
            ajanPA=0;afebPA=0;amarPA=0;aaprPA=0;amayPA=0;ajunePA=0;ajulyPA=0;aaugPA=0;asepPA=0;aoctPA=0;anovPA=0;adecPA=0;
            ajanPG=0;afebPG=0;amarPG=0;aaprPG=0;amayPG=0;ajunePG=0;ajulyPG=0;aaugPG=0;asepPG=0;aoctPG=0;anovPG=0;adecPG=0;
            
            bjanT=0;bfebT=0;bmarT=0;baprT=0;bmayT=0;bjuneT=0;bjulyT=0;baugT=0;bsepT=0;boctT=0;bnovT=0;bdecT=0; 
            bjanLG=0;bfebLG=0;bmarLG=0;baprLG=0;bmayLG=0;bjuneLG=0;bjulyLG=0;baugLG=0;bsepLG=0;boctLG=0;bnovLG=0;bdecLG=0;
            bjanAG=0;bfebAG=0;bmarAG=0;baprAG=0;bmayAG=0;bjuneAG=0;bjulyAG=0;baugAG=0;bsepAG=0;boctAG=0;bnovAG=0;bdecAG=0;
            bjanIN=0;bfebIN=0;bmarIN=0;baprIN=0;bmayIN=0;bjuneIN=0;bjulyIN=0;baugIN=0;bsepIN=0;boctIN=0;bnovIN=0;bdecIN=0;
            bjanPA=0;bfebPA=0;bmarPA=0;baprPA=0;bmayPA=0;bjunePA=0;bjulyPA=0;baugPA=0;bsepPA=0;boctPA=0;bnovPA=0;bdecPA=0;
            bjanPG=0;bfebPG=0;bmarPG=0;baprPG=0;bmayPG=0;bjunePG=0;bjulyPG=0;baugPG=0;bsepPG=0;boctPG=0;bnovPG=0;bdecPG=0;
            
            cjanT=0;cfebT=0;cmarT=0;caprT=0;cmayT=0;cjuneT=0;cjulyT=0;caugT=0;csepT=0;coctT=0;cnovT=0;cdecT=0; 
            cjanLG=0;cfebLG=0;cmarLG=0;caprLG=0;cmayLG=0;cjuneLG=0;cjulyLG=0;caugLG=0;csepLG=0;coctLG=0;cnovLG=0;cdecLG=0;
            cjanAG=0;cfebAG=0;cmarAG=0;caprAG=0;cmayAG=0;cjuneAG=0;cjulyAG=0;caugAG=0;csepAG=0;coctAG=0;cnovAG=0;cdecAG=0;
            cjanIN=0;cfebIN=0;cmarIN=0;caprIN=0;cmayIN=0;cjuneIN=0;cjulyIN=0;caugIN=0;csepIN=0;coctIN=0;cnovIN=0;cdecIN=0;
            cjanPA=0;cfebPA=0;cmarPA=0;caprPA=0;cmayPA=0;cjunePA=0;cjulyPA=0;caugPA=0;csepPA=0;coctPA=0;cnovPA=0;cdecPA=0;
            cjanPG=0;cfebPG=0;cmarPG=0;caprPG=0;cmayPG=0;cjunePG=0;cjulyPG=0;caugPG=0;csepPG=0;coctPG=0;cnovPG=0;cdecPG=0;
            
            djanT=0;dfebT=0;dmarT=0;daprT=0;dmayT=0;djuneT=0;djulyT=0;daugT=0;dsepT=0;doctT=0;dnovT=0;ddecT=0; 
            djanLG=0;dfebLG=0;dmarLG=0;daprLG=0;dmayLG=0;djuneLG=0;djulyLG=0;daugLG=0;dsepLG=0;doctLG=0;dnovLG=0;ddecLG=0;
            djanAG=0;dfebAG=0;dmarAG=0;daprAG=0;dmayAG=0;djuneAG=0;djulyAG=0;daugAG=0;dsepAG=0;doctAG=0;dnovAG=0;ddecAG=0;
            djanIN=0;dfebIN=0;dmarIN=0;daprIN=0;dmayIN=0;djuneIN=0;djulyIN=0;daugIN=0;dsepIN=0;doctIN=0;dnovIN=0;ddecIN=0;
            djanPA=0;dfebPA=0;dmarPA=0;daprPA=0;dmayPA=0;djunePA=0;djulyPA=0;daugPA=0;dsepPA=0;doctPA=0;dnovPA=0;ddecPA=0;
            djanPG=0;dfebPG=0;dmarPG=0;daprPG=0;dmayPG=0;djunePG=0;djulyPG=0;daugPG=0;dsepPG=0;doctPG=0;dnovPG=0;ddecPG=0;
            
            //tier status rollups
            ap_aq_TRU=0;ap_in_TRU=0;ap_pa_TRU=0;ap_gp_TRU=0;ap_lg_TRU=0;
            a_aq_TRU=0;a_in_TRU=0;a_pa_TRU=0;a_gp_TRU=0;a_lg_TRU=0;
            b_aq_TRU=0;b_in_TRU=0;b_pa_TRU=0;b_gp_TRU=0;b_lg_TRU=0;
            c_aq_TRU=0;c_in_TRU=0;c_pa_TRU=0;c_gp_TRU=0;c_lg_TRU=0;
            d_aq_TRU=0;d_in_TRU=0;d_pa_TRU=0;d_gp_TRU=0;d_lg_TRU=0;
            
            //monthly business goal totals
            janTotal_bg=0;febTotal_bg=0;marTotal_bg=0;aprTotal_bg=0;mayTotal_bg=0;junTotal_bg=0;
            julTotal_bg=0;augTotal_bg=0;sepTotal_bg=0;octTotal_bg=0;novTotal_bg=0;decTotal_bg=0;
            
            //monthly live goal totals
            janTotal_lg=0;febTotal_lg=0;marTotal_lg=0;aprTotal_lg=0;mayTotal_lg=0;junTotal_lg=0;
            julTotal_lg=0;augTotal_lg=0;sepTotal_lg=0;octTotal_lg=0;novTotal_lg=0;decTotal_lg=0;
            
            //monthly acquired totals
            janTotal_aq=0;febTotal_aq=0;marTotal_aq=0;aprTotal_aq=0;mayTotal_aq=0;junTotal_aq=0;
            julTotal_aq=0;augTotal_aq=0;sepTotal_aq=0;octTotal_aq=0;novTotal_aq=0;decTotal_aq=0;
            
            //monthly progress totals
            janTotal_pg=0;febTotal_pg=0;marTotal_pg=0;aprTotal_pg=0;mayTotal_pg=0;junTotal_pg=0;
            julTotal_pg=0;augTotal_pg=0;sepTotal_pg=0;octTotal_pg=0;novTotal_pg=0;decTotal_pg=0;
            
            //monthly in negotiation totals
            janTotal_in=0;febTotal_in=0;marTotal_in=0;aprTotal_in=0;mayTotal_in=0;junTotal_in=0;
            julTotal_in=0;augTotal_in=0;sepTotal_in=0;octTotal_in=0;novTotal_in=0;decTotal_in=0;
            
            //monthly pre aquisition totals
            janTotal_pa=0;febTotal_pa=0;marTotal_pa=0;aprTotal_pa=0;mayTotal_pa=0;junTotal_pa=0;
            julTotal_pa=0;augTotal_pa=0;sepTotal_pa=0;octTotal_pa=0;novTotal_pa=0;decTotal_pa=0;
            
            //total section roll-ups
            t_aq_TRU=0;t_in_TRU=0;t_pa_TRU=0;t_gp_TRU=0;t_lg_TRU=0;
            
        }
    }
    
    
    
}