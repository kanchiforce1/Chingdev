/***********************************
Author:      Amazon Apub // kkolla@
Used By:     custom page controller which is used in PPW_servicePrepForm page
Description: Helper Controller for the PPW ServicePrepForm Form, linked to project page. Non question PS creation logic will be in this helper class
************************************/

public class PPW_ServicePrepFormControllerHelper{
    
    /** Title object Field set **/  //Querying all the fields
    public static List<Schema.FieldSetMember> getTitleFields() {
        return SObjectType.Title__c.FieldSets.PPW_Service_Prep.getFields();
    }
    
    /** Asin object Field set  **/ 
    public static List<Schema.FieldSetMember> getAsinFields() {
        return SObjectType.Asin__C.FieldSets.MDTAsinfieldApiNames.getFields();
    }
    
    /*** Split logic for mulitiple services ids  ***/ 
    public static Set<string> splitvalues(String str) {
        set<string>svalues = new set<string>();
        if(str!=null && str!=''){
            if(str.contains(',')){
                for(String s: str.split(','))
                    if(s!=null && s!='')
                    svalues.add(Id.valueOf(s.trim()));
            } else
                svalues.add(Id.valueOf(str.trim()));
        }
        return svalues;           
    }     
    
    public static map<String,String> serivceName {
        get {
            if(serivceName == null) {
                serivceName = new map<String,String>();
                for(Service__c s: [SELECT id,name,Service_Rate_Type__c from Service__c where active__C = true order by Service_Rate_Type__c]){
                    serivceName.put(s.id,s.id); 
                }
                return serivceName;
            }  
            else
                return serivceName;
        } set{ 
        }
    }// = new map<String,String>();
    public map<String,set<String>> stanComplexServices = new map<String,set<String>>();
    
    /** Create PS logic from title record based on internal imprint **/
    public static set<String> psToCreate(String imprintName,String FieldName){
        
        System.debug(imprintName +','+FieldName);
        set<String> serviceids = new set<String>();
        if(imprintName!=null){
            for(PPW_Auto_Create_Ps__mdt SerVal: createPsmetaData)
            {
                System.debug(serVal.Field_Label_Value__c);
                if(serVal.label==FieldName && serVal.Field_Label_Value__c != null) 
                    if(imprintName.equalsIgnoreCase(serVal.Field_Label_Value__c)){
                        for(string s: splitvalues(serVal.PS_to_Create__c))
                            if(serivceName.containskey(s))
                            serviceids.add(s);
                    }else{
                        if(serVal.Field_Label_Value__c.contains(','))
                            for(String s: splitvalues1(serVal.Field_Label_Value__c))
                            if(imprintName.equalsIgnoreCase(s))     
                            for(string sval: splitvalues(serVal.PS_to_Create__c))
                            serviceids.add(sval);
                    }
                
                
                
            }                                                             
            
        }
        return serviceids;
    }
    
    /** Split logic for non id values  **/
    public static Set<string> splitvalues1(String str)
    {
        set<string>svalues = new set<string>();
        if(str!=null && str!=''){
            if(str.contains(',')){
                for(String s: str.split(','))
                    if(s!=null && s!='')
                    svalues.add(s.trim());
            } else
                svalues.add(str.trim());
        }
        return svalues;           
    } 
    
    /** Add new ps logic **/      
    @TestVisible
    Private static List<Project_Services__c> createPSLogicFromTitle(String pId,string updatePs){
        List<Project_Services__c> cPsList = new List<Project_Services__c>();
        set<Id> SIds = new set<Id>();
        if(!String.isBlank(updatePs))
            if(updatePs.contains(',')){
                for(String str: updatePs.trim().split(','))
                    SIds.add(Id.valueOf(str.trim()));
            } else    SIds.add(Id.valueOf(updatePs.removeEnd(';')));
        
        for(String s: SIds)
            if(serivceName.containsKey(s))
            cPsList.add(new Project_Services__c(Project__c=pid,Service__c=s));
        System.debug('cPsList'+cPsList);
        return cPsList;
    }
    
    /** Update Ps Split Logic  **/
    @TestVisible
    Private static map<String,String> updateSplitLogic(String splitStr){
        map<String,String> upPslist = new map<String,String>();
        for(String s: splitStr.split(';')) {
            if(!String.isBlank(s))
                
                if(s.contains(',')){
                    for(String str: s.trim().split(','))
                    {
                        List<String> serList = str.trim().split('->');
                        upPslist.put(Id.valueOf(serList[0]),Id.valueOf(serList[1]));
                        
                    } 
                } else { 
                    s.trim().removeend(';');
                    List<String> serList = s.split('->');
                    upPslist.put(Id.valueOf(serList[0]),Id.valueOf(serList[1]));
                    
                }
        } 
        
        return upPslist;
    }
    
    /** Update ps method calling from PPW_ServicePrepFormController, depends on MWC or internal imprint value or sub category field value from title record **/   
    @TestVisible
    Private  static List<Project_Services__c> updatePSLogic(string updatePs,List<Project_Services__c> psuplist){
        map<String,String> upPslist = new map<String,String>();
        upPslist = updateSplitLogic(updatePs);
        
        List<Project_Services__c> finalUpdatePSs = new List<Project_Services__c>();
        
        for(Project_Services__c ps: psuplist) {
            if(upPslist != null && ps.Service__c != null )
                if(upPslist.containskey(String.valueOf(Id.valueOf(ps.Service__c)))){
                    ps.Service__c  = upPslist.get(String.valueOf(Id.valueOf(ps.Service__c)));
                    finalUpdatePSs.add(ps);
                } else
                    finalUpdatePSs.add(ps);      
        }
        System.debug('finalUpdatePSs'+finalUpdatePSs);
        return finalUpdatePSs;
    }
    
    
    public static boolean digitPatternCheck(String str) {
        if(!String.isBlank(str)) {
            Pattern p = Pattern.compile('\\d+');
            Matcher m = p.matcher(str);
            return  m.matches();
        } else  return false;
        
        
    }   
    public static String pid{get;set;}
    public static Map<String,List<SObject>> recordsMap{
        set{}
        get{
            if(recordsMap == null) {
                recordsMap = new Map<String,List<SObject>>();
                List<Title__c> titleRecs = new List<Title__c>();
                List<ASIN__c> asinRecs = new List<ASIN__c>();
                
                Project__c p = [Select id,Title__c from Project__c where id=:Pid limit 1];
                system.debug(p.id);
                system.debug(p.title__c);
                titleRecs = (List<Title__c>)PPW_StaticUtils.dynamicQueryListType('Title__c', ' WHERE Id =\''+ p.title__c + '\'', null);
                asinRecs = (List<ASIN__c>)PPW_StaticUtils.dynamicQueryListType('ASIN__c', ' WHERE title__c =\''+ p.title__c + '\'', null);
                if(!titleRecs.isEmpty())
                    recordsMap.put('Title__c',titleRecs);
                if(asinRecs!=null)
                    if(!asinRecs.isEmpty())
                    recordsMap.put('ASIN__c',asinRecs);
                
                return recordsMap;  
            } else 
                return recordsMap;
            
            
        }
    }
    
    // public List<Title__c> titleRecords = new List<Title__c>();
    //public static 
    public static List<PPW_Auto_Create_Ps__mdt> createPsmetaData {
        get{ 
            if(createPsmetaData == null) {
                createPsmetaData = new List<PPW_Auto_Create_Ps__mdt>();
                createPsmetaData = [SELECT id,label,developername,
                                    Field_Label_Value__c,PS_to_Create__c,PS_to_Update__c,
                                    Question_to_Create__c,Object_Name__c from PPW_Auto_Create_Ps__mdt];
                return createPsmetaData;
            } else
                return createPsmetaData;
        }set{}
    } //= new List<PPW_Auto_Create_Ps__mdt>();
    public static List<PPW_spManuscriptWordCount__mdt> updatePsmetaData{
        set{}
        get{ 
            if(updatePsmetaData == null) {
                updatePsmetaData = new List<PPW_spManuscriptWordCount__mdt>();
                updatePsmetaData = [SELECT id,label,developername,
                                    MWC_greater_than__c,MWC_less_than__c,updatePS__c,CreatePS__c from PPW_spManuscriptWordCount__mdt];
                return updatePsmetaData;
            }
            else
                return updatePsmetaData; 
        }
    }
    
    public static List<PPW_compareFieldUserValue__mdt> insertPsmetaData {
        set{}
        get{
            system.debug(insertPsmetaData);
            if(insertPsmetaData == null) {
                insertPsmetaData = new  List<PPW_compareFieldUserValue__mdt>();
                insertPsmetaData = (List<PPW_compareFieldUserValue__mdt>)PPW_StaticUtils.dynamicQueryListType('PPW_compareFieldUserValue__mdt', null, null);
                return insertPsmetaData;
            } else
                return insertPsmetaData;
        }
    }
    /** Update ps method calling from PPW_ServicePrepFormController depends on MWC value from title record **/ 
    public static List<Project_Services__c> psMWCCreate(List<Project_Services__c> pslist,String qId, String resVal) {
        
        
        List<Project_Services__c> psUpdateList = new list<Project_Services__c>();
        
        for(String key : recordsMap.keyset()) 
            for(Sobject t: recordsMap.get(key)) {
                system.debug(t);
                system.debug(key);
                for(PPW_compareFieldUserValue__mdt cfu : insertPsmetaData) {
                    system.debug('cfu' + cfu);
                    system.debug('resVal ' + resVal);
                    system.debug('qId' + qId);
                    if(cfu.Object_Name__c == key) {
                        if(String.isNotBlank(cfu.Field_Name1__c) && String.isNotBlank(cfu.Field_Value1__c) && t.get(cfu.Field_Name1__c) != null) { // one if
                            if(String.isNotBlank(cfu.Field_Name2__c) && String.isNotBlank(cfu.Field_Value2__c) && t.get(cfu.Field_Name2__c) != null) { // two if
                                if(String.isNotBlank(cfu.Field_Name3__c) && cfu.Field_Value3__c!= null && t.get(cfu.Field_Name3__c) != null) { // three if
                                    if(String.isNotBlank(cfu.Field_Name4__c) && String.isNotBlank(cfu.Field_Value4__c) && t.get(cfu.Field_Name4__c) != null) { // four if
                                        if(String.isNotBlank(cfu.Field_Name5__c) && String.isNotBlank(cfu.Field_Value5__c) && t.get(cfu.Field_Name5__c) != null) { // five if
                                            if(String.isNotBlank(cfu.SPQ_Id__c) && String.isNotBlank(cfu.SPQ_Response__c) && String.isNotBlank(resVal) && String.isNotBlank(qId)) { // question if
                                                if(getConditions(t,cfu.Field_Name1__c,cfu.Field_Value1__c) &&  
                                                   getConditions(t,cfu.Field_Name2__c,cfu.Field_Value2__c) &&
                                                   getConditions(t,cfu.Field_Name3__c,cfu.Field_Value3__c) &&
                                                   getConditions(t,cfu.Field_Name4__c,cfu.Field_Value4__c) &&
                                                   getConditions(t,cfu.Field_Name5__c,cfu.Field_Value5__c) &&
                                                   Id.valueOf(cfu.SPQ_Id__c).equals(qId) && (resVal.contains(cfu.SPQ_Response__c) || cfu.SPQ_Response__c.contains(resVal)))  
                                                    pslist = getNewPSsRecords(cfu.PS_To_Create__c,pslist,pid);
                                                
                                            } else { // question else
                                                if(getConditions(t,cfu.Field_Name1__c,cfu.Field_Value1__c) &&  
                                                   getConditions(t,cfu.Field_Name2__c,cfu.Field_Value2__c) &&
                                                   getConditions(t,cfu.Field_Name3__c,cfu.Field_Value3__c) &&
                                                   getConditions(t,cfu.Field_Name4__c,cfu.Field_Value4__c) &&
                                                   getConditions(t,cfu.Field_Name5__c,cfu.Field_Value5__c) 
                                                  )  
                                                    pslist = getNewPSsRecords(cfu.PS_To_Create__c,pslist,pid);
                                                
                                                
                                            }
                                        } else { // five else
                                            if(String.isNotBlank(cfu.SPQ_Id__c) && String.isNotBlank(cfu.SPQ_Response__c) && String.isNotBlank(resVal) && String.isNotBlank(qId)) {
                                                if(getConditions(t,cfu.Field_Name1__c,cfu.Field_Value1__c) &&  
                                                   getConditions(t,cfu.Field_Name2__c,cfu.Field_Value2__c) &&
                                                   getConditions(t,cfu.Field_Name3__c,cfu.Field_Value3__c) &&
                                                   getConditions(t,cfu.Field_Name4__c,cfu.Field_Value4__c) &&
                                                   
                                                   Id.valueOf(cfu.SPQ_Id__c).equals(qId) && (resVal.contains(cfu.SPQ_Response__c) || cfu.SPQ_Response__c.contains(resVal)))  
                                                    pslist=  getNewPSsRecords(cfu.PS_To_Create__c,pslist,pid);
                                                
                                            } else { // question else
                                                if(String.isNotBlank(resVal))
                                                    if(getConditions(t,cfu.Field_Name1__c,cfu.Field_Value1__c) &&  
                                                       getConditions(t,cfu.Field_Name2__c,cfu.Field_Value2__c) &&
                                                       getConditions(t,cfu.Field_Name3__c,cfu.Field_Value3__c) &&
                                                       getConditions(t,cfu.Field_Name4__c,cfu.Field_Value4__c))
                                                    
                                                    pslist= getNewPSsRecords(cfu.PS_To_Create__c,pslist,pid);
                                            } 
                                            
                                        }
                                        
                                        
                                    } else {  // four else
                                        
                                        if(String.isNotBlank(cfu.SPQ_Id__c) && String.isNotBlank(cfu.SPQ_Response__c) && String.isNotBlank(resVal) && String.isNotBlank(qId)) {
                                            if(getConditions(t,cfu.Field_Name1__c,cfu.Field_Value1__c) &&  
                                               getConditions(t,cfu.Field_Name2__c,cfu.Field_Value2__c) &&
                                               getConditions(t,cfu.Field_Name3__c,cfu.Field_Value3__c) &&
                                               
                                               Id.valueOf(cfu.SPQ_Id__c).equals(qId) &&  (resVal.contains(cfu.SPQ_Response__c) || cfu.SPQ_Response__c.contains(resVal))) { 
                                                   pslist = getNewPSsRecords(cfu.PS_To_Create__c,pslist,pid);
                                               } 
                                        } else { // question else
                                            if(String.isNotBlank(resVal))
                                                if(getConditions(t,cfu.Field_Name1__c,cfu.Field_Value1__c) &&  
                                                   getConditions(t,cfu.Field_Name2__c,cfu.Field_Value2__c) &&
                                                   getConditions(t,cfu.Field_Name3__c,cfu.Field_Value3__c)) {  
                                                       pslist = getNewPSsRecords(cfu.PS_To_Create__c,pslist,pid);
                                                   } 
                                            
                                        }
                                        
                                    }
                                } else { // three else
                                    if(String.isNotBlank(cfu.SPQ_Id__c) && String.isNotBlank(cfu.SPQ_Response__c) && String.isNotBlank(resVal) && String.isNotBlank(qId)) { // question if
                                        if(getConditions(t,cfu.Field_Name1__c,cfu.Field_Value1__c) &&  
                                           getConditions(t,cfu.Field_Name2__c,cfu.Field_Value2__c) &&
                                           
                                           Id.valueOf(cfu.SPQ_Id__c).equals(qId) && (resVal.contains(cfu.SPQ_Response__c) || cfu.SPQ_Response__c.contains(resVal)))  
                                            pslist = getNewPSsRecords(cfu.PS_To_Create__c,pslist,pid);
                                        
                                    } else { // question else
                                        if(String.isNotBlank(resVal))
                                            if(getConditions(t,cfu.Field_Name1__c,cfu.Field_Value1__c) &&  
                                               getConditions(t,cfu.Field_Name2__c,cfu.Field_Value2__c))  
                                            pslist = getNewPSsRecords(cfu.PS_To_Create__c,pslist,pid);
                                        
                                        
                                    }
                                }
                            } else { // two else
                                if(String.isNotBlank(cfu.SPQ_Id__c) && String.isNotBlank(cfu.SPQ_Response__c) && String.isNotBlank(resVal) && String.isNotBlank(qId)) { // question if
                                    if(getConditions(t,cfu.Field_Name1__c,cfu.Field_Value1__c) &&  
                                       Id.valueOf(cfu.SPQ_Id__c).equals(qId) &&  (resVal.contains(cfu.SPQ_Response__c) || cfu.SPQ_Response__c.contains(resVal)))  
                                        pslist = getNewPSsRecords(cfu.PS_To_Create__c,pslist,pid);
                                    
                                } else { // question else
                                    if(String.isNotBlank(resVal))
                                        if(getConditions(t,cfu.Field_Name1__c,cfu.Field_Value1__c))  
                                        pslist = getNewPSsRecords(cfu.PS_To_Create__c,pslist,pid);
                                    
                                }
                                
                            }
                        } else {  // one else
                            
                        }
                    }         
                }
            }
        
        return null;  
    } 
    
    private static boolean getConditions(Sobject t,String fieldName,String fieldValue) {
        
        return (String.valueOf(t.get(fieldName)).equalsIgnoreCase(fieldValue) || fieldValue.contains(String.valueOf(t.get(fieldName))));
        
        
    }   
    private static List<Project_Services__c> getNewPSsRecords(String psToCreate,List<Project_Services__c> pslist,String pid) {
        for(string s: splitvalues(psToCreate.trim())) 
            if(serivceName.containskey(s)) {
                pslist.add(new Project_Services__c(Project__c=pid,Service__c=s));
            }
        return pslist;
    }   
    
    
    /** Update ps method calling from PPW_ServicePrepFormController depends on MWC value from title record **/ 
    public static List<Project_Services__c> psMWCUpdate(String Pid,List<Project_Services__c> pslist) {
        // getTitleAsinRecords(Pid);
        System.debug('pslist'+pslist);
        
        List<Project_Services__c> psUpdateList = new list<Project_Services__c>();
        psUpdateList.addAll(pslist);
        
        integer mwc;
        string updatepsTemp;
        
        /** Title based create or update PS logic  **/ 
        try{
            for(Title__c t: titlesList)
                for(Project__c p: projectsMap.get(t.id))
                for(String s: fieldsApiNames){
                    System.debug(s);
                    if(t.get(s)!=null) {
                        if(digitPatternCheck(String.valueOF(t.get(s))))
                            mwc = integer.valueOf(t.get(s));
                    }
                    
                    if(mwc!=null){
                        for(PPW_spManuscriptWordCount__mdt SerVal: updatePsmetaData )
                        {
                            System.debug(serVal.MWC_greater_than__c);
                            System.debug(serVal.CreatePS__c);
                            System.debug(serVal.MWC_less_than__c);
                            System.debug(mwc);
                            if(serVal.label==s)
                                if(mwc>serVal.MWC_greater_than__c && mwc<serVal.MWC_less_than__c){
                                    if(!string.isBlank(serVal.CreatePS__c))
                                        psUpdateList.addAll(createPSLogicFromTitle(Pid,serVal.CreatePS__c));
                                    
                                    if(!string.isBlank(serVal.updatePS__c)){
                                        
                                        if(psUpdateList!=null && psUpdateList.size()>0)
                                            psUpdateList = updatePSLogic(serVal.updatePS__c,psUpdateList);
                                        else
                                            psUpdateList = updatePSLogic(serVal.updatePS__c,psUpdateList); 
                                    }     
                                    
                                }
                        }     
                    }
                } 
            System.debug(psUpdateList);  
        } catch(exception e) {
            
        }
        System.debug('psUpdateList'+psUpdateList);        
        if(psUpdateList!=null)
            if(!psUpdateList.isEmpty())
            pslist = psUpdateList;
        
        return pslist;
    }
    
    /** Get's the query meta data **/
    @TestVisible
    private void getQueryMetaData() {
        if(createPsContainsMetaData .isEmpty())
            createPsContainsMetaData = [SELECT id,label,developername,
                                        Field_Label_Value__c,PS_to_Create__c,PS_to_Update__c,
                                        Question_to_Create__c,Object_Name__c from PPW_autoPsContains__mdt];
        if(createPsmetaData.isEmpty())
            createPsmetaData = [SELECT id,label,developername,
                                Field_Label_Value__c,PS_to_Create__c,PS_to_Update__c,
                                Question_to_Create__c,Object_Name__c from PPW_Auto_Create_Ps__mdt];
        
    }
    public static List<PPW_autoPsContains__mdt> createPsContainsMetaData{
        get{
            if(createPsContainsMetaData == null) {
                createPsContainsMetaData = new List<PPW_autoPsContains__mdt>();
                createPsContainsMetaData = [SELECT id,label,developername,
                                            Field_Label_Value__c,PS_to_Create__c,PS_to_Update__c,
                                            Question_to_Create__c,Object_Name__c from PPW_autoPsContains__mdt];
                return createPsContainsMetaData;
            } else
                return createPsContainsMetaData;   
        }set{}
    } //= new List<PPW_autoPsContains__mdt>();
    
    /** Update ps based on value in subcategory field in title object  **/
    public static List<Project_Services__c> updatePsTileSubCategory(String Pid,List<Project_Services__c> pslist) {
        
        //getQueryMetaData();
        
        List<Project_Services__c> psUpdateList = new list<Project_Services__c>();
        
        /** Subcategory field in title object based PS update  **/ 
        for(Title__c t: titlesList)
            for(Project__c p: projectsMap.get(t.id))
            for(String s: fieldsApiNames)
            if(t.get(s)!=null)
            for(PPW_autoPsContains__mdt SerVal:  createPsContainsMetaData  )
        {
            if(serVal.label==s)
                if(String.valueOf(t.get(s)).containsIgnoreCase(serVal.Field_Label_Value__c))
                if(!string.isBlank(serVal.PS_to_Update__c)){
                    psUpdateList = updatePSLogic(serVal.PS_to_Update__c,pslist);
                    
                }    
        }
        
        
        System.debug(psUpdateList);
        
        if(psUpdateList!=null)
            if(!psUpdateList.isEmpty())
            pslist = psUpdateList;
        
        return pslist;
        
    } 
    
    
    /** Default end Update ps method which is calling fromPPW_ServicePrepFormController statndard service to complex **/ 
    public List<Project_Services__c> updateStanToComplex(List<Project_Services__c> pslist){
        // serivceName
        /*  map<String,set<String>> staToComplexmap = new map<String,set<String>>();
integer staCount=0;
set<String> proofReadingset = Label.PPW_spProofReadBackendLogic.trim().split(',');

for(Project_Services__c ps: pslist)
if(serivceName.get(ps.Service__c).Service_Rate_Type__c.containsignoreCase('Developmental Edit - Standard'))
staCount++; 
if(staCount>=2) {
for(Project_Services__c ps: pslist)
if( proofReadingset.contains(serivceName.get(ps.Service__c).Service_Rate_Type__c)) { //.containsignoreCase('Proofreading') || 
String compServiceId;
String 
for(String s: serivceName.keyset()) 
if(serivceName.get(s).Service_Rate_Type__c!=null)
if(proofReadingset.contains(serivceName.get(s).Service_Rate_Type__c) && serivceName.get(s).Service_Rate_Type__c.containsIgnoreCase('Complex'))  
compServiceId = serivceName.get(s).Service_Rate_Type__c;


} 

}  */
        return pslist;
    }
    
    /** Proof Complex service logic **/
    @Testvisible
    private String getProofComplexServiceId(String serName){
        return null;
    }
    
    
    public static List<Title__c> titlesList {
        get{
            if(titlesList == null) {
                titlesList = new List<Title__c>();
                /** Title query using field set  ***/ 
                String query='Select ';
                for(Schema.FieldSetMember f : getTitleFields()) {
                    query = query+f.getFieldPath()+',';
                    fieldsApiNames.add(f.getFieldPath());
                }
                set<String> titleIds = new set<String>();
                for(project__c p : [Select id,Title__c from Project__c where id=:Pid])
                    titleIds.add(p.title__c);
                query = query+'id from Title__c where id=:titleIds';  
                titlesList = database.query(query);
                return titlesList;
            }  else
                return titlesList;
        } set{}
    }
    
    public static List<ASIN__c> asinRecords{
        /** Asin query using field set  ***/ 
        
        get{ 
            if(asinRecords == null) {
                asinRecords = new List<ASIN__c>();
                assinFieldsApiNames = new list<string>();
                for(Schema.FieldSetMember f : getAsinFields()) 
                    assinFieldsApiNames.add(f.getFieldPath());
                
                String  query='Select ';
                set<String> titleIds = new set<String>();
                if(projectlist == null) {
                    for(project__c p : [Select id,Title__c from Project__c where id=:Pid])
                        titleIds.add(p.title__c);
                } else
                    for(project__c p : projectlist)
                    titleIds.add(p.title__c);
                for(Schema.FieldSetMember f : getAsinFields()) {
                    query = query+f.getFieldPath()+',';
                    assinFieldsApiNames.add(f.getFieldPath());
                }
                query = query+'id from Asin__c where Title__c=: titleIds';  
                asinRecords = database.query(query);
                return asinRecords;
            } else
                return asinRecords;
        } set{}
    }
    public static List<Project__c> projectlist{
        get{
            if(projectlist == null) {
                projectlist = new List<Project__c>();
                projectlist = [Select id,Title__c from Project__c where id=:Pid]; 
                return projectlist;
            }  else
                return projectlist;
        }set{}
    }   
    
    public static map<String,List<Project__c>> projectsMap {
        get{
            if(projectsMap == null) {
                projectsMap = new map<String,List<Project__c>>();
                if(projectlist == null)
                    projectlist = [Select id,Title__c from Project__c where id=:Pid];
                Set<String> titleIds = new Set<String>();
                projectsMap = new map<String,List<Project__c>>();
                for(Project__c p: projectlist)
                    if(p.Title__c!=null){
                        if(projectsMap.containskey(p.Title__c))
                            projectsMap.get(p.Title__c).add(p);
                        else
                            projectsMap.put(p.Title__c,new list<Project__c>{p});
                    }
                return projectsMap;
            } else
                return projectsMap; 
        } set{}
    }  
    public static list<String> fieldsApiNames{
        get{  /** Title query using field set  ***/ 
            if(fieldsApiNames == null) {
                fieldsApiNames = new list<String>();
                String query='Select ';
                for(Schema.FieldSetMember f : getTitleFields()) {
                    query = query+f.getFieldPath()+',';
                    fieldsApiNames.add(f.getFieldPath());
                    
                }
                return fieldsApiNames;
            } else
                return fieldsApiNames;
        }   
        set{}}
    
    public static list<String> assinFieldsApiNames{
        /** Asin query using field set  ***/ 
        get{ 
            if(assinFieldsApiNames == null) {
                assinFieldsApiNames = new list<string>();
                
                for(Schema.FieldSetMember f : getAsinFields()) 
                    assinFieldsApiNames.add(f.getFieldPath());
                
                return assinFieldsApiNames;
            } else 
                return assinFieldsApiNames; 
        } set{}
        
    }
    
    /** Create ps method calling from PPW_ServicePrepFormController **/ 
    public static List<Project_Services__c> psCreation(String Pid,Service_Prep__c serPrep){
        List<Project_Services__c> psCreateList = new list<Project_Services__c>();
        
        set<Id> titleQus1 = new set<Id>();
        map<String,set<String>> titleQuemap = new map<String,set<String>>();
        
        
        /** Title based PS creation  **/ 
        for(Title__c t: titlesList)
            for(Project__c p: projectsMap.get(t.id))
            for(String s: fieldsApiNames){
                System.debug(s);
                System.debug(t);
                for(String ser: psToCreate(String.valueOf(t.get(s)),s))
                    if(ser!=null)
                    psCreateList.add(new Project_Services__c(Project__c=p.id,Service__c=ser));
                
                
            }
        
        
        
        /** Asin based PS creation **/
        for(ASIN__c t: asinRecords)
            for(Project__c p: projectsMap.get(t.Title__c))
            for(String s: assinFieldsApiNames)
            for(String ser: psToCreate(String.valueOf(t.get(s)),s))
            if(ser!=null)
            psCreateList.add(new Project_Services__c(Project__c=p.id,Service__c=ser));
        
        
        
        System.debug(psCreateList);
        string str='';
        for(Project_Services__c ps: psCreateList) {
            if(string.isEmpty(str))
                str = ps.service__c;
            else str = str+','+ps.service__c;
        }
        if(String.isEmpty(serPrep.Service_Id_s_Created__c))
            serPrep.Service_Id_s_Created__c = str; 
        else serPrep.Service_Id_s_Created__c = serPrep.Service_Id_s_Created__c + ','+str;     
        
        return psCreateList;
        
    }
    
    /** Default ps Creation from Custom Label **/
    public static List<Project_Services__c> defaultpsCreate(String str,Service_Prep__c serPrep,String Pid){
        
        List<Project_Services__c> psCreateList = new list<Project_Services__c>();
        if(!String.isBlank(str))
            for(Id id1: Label.PPW_default_PS_create.split(',')) {
                if(serivceName.containskey(id1))
                    psCreateList.add(new Project_Services__c(Project__c=Pid,Service__c=id1));
            } 
        String s = '';
        // adding into the services created at first time
        
        for(Project_Services__c ps: psCreateList) {
            if(string.isEmpty(s))
                s = ps.service__c;
            else s = s+','+ps.service__c;
        }
        if(String.isEmpty(serPrep.Service_Id_s_Created__c))
            serPrep.Service_Id_s_Created__c = str; 
        else serPrep.Service_Id_s_Created__c = serPrep.Service_Id_s_Created__c + ','+str;  
        System.debug(psCreateList);  
        return psCreateList;
    }
    
    /** Update ps method calling from PPW_ServicePrepFormController **/ 
    public static List<Project_Services__c> psInternalImprintupdate(String Pid,List<Project_Services__c> psuplist) {
        
        List<Project_Services__c> psUpdateList = new list<Project_Services__c>();
        
        
        /** Title based PS creation **/ 
        for(Title__c t: titlesList)
            for(Project__c p: projectsMap.get(t.id))
                for(String s: fieldsApiNames)
                    if(t.get(s)!=null)
                        for(PPW_Auto_Create_Ps__mdt SerVal:  createPsmetaData) {
                            if(serVal.label==s && serVal.Field_Label_Value__c != null && t.get(s) != null)
                                if(String.valueOf(t.get(s)).containsIgnoreCase(serVal.Field_Label_Value__c))
                                    if(!string.isBlank(serVal.PS_to_Update__c))
                                        psUpdateList = updatePSLogic(serVal.PS_to_Update__c,psuplist);
                           
                         }
        
           
        /** Asin based PS creation **/
        for(ASIN__c t: asinRecords)
            for(Project__c p: projectsMap.get(t.Title__c))
                for(String s: assinFieldsApiNames)
                   if(t.get(s)!=null)
                        for(PPW_Auto_Create_Ps__mdt SerVal:  createPsmetaData) {
                            if(serVal.label==s && serVal.Field_Label_Value__c != null && t.get(s) != null)
                                if(String.valueOf(t.get(s)).containsIgnoreCase(serVal.Field_Label_Value__c))
                                    if(!string.isBlank(serVal.PS_to_Update__c))
                                        psUpdateList = updatePSLogic(serVal.PS_to_Update__c,psuplist);
                           
                         }
        
        System.debug('psUpdateList'+psUpdateList);        
        if(psUpdateList!=null)
            if(psUpdateList.size()>0)
            psuplist= psUpdateList;
        
        return psuplist;
    }    
    
}