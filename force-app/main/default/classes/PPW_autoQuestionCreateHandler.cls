/***********************************
Author:      Amazon Apub // kkolla@
Used By:     custom page controller used in PPW_servicePrepForm page
Description: Handler form calling service prep object trigger creating questions, responses.
             Note: Title record is mandatory for creating service prep question, as the questions are created based on Locale__C field in title__C object.
***********************************/
public class PPW_autoQuestionCreateHandler  {
    
    public static List<PPW_Auto_Create_Ps__mdt> createPs = new List<PPW_Auto_Create_Ps__mdt>();
    public static set<Id> titleQus1;
    /** title field set  **/
    public static List<Schema.FieldSetMember> getTitleFields() {
        return SObjectType.Title__c.FieldSets.PPW_Service_Prep.getFields();
    }
    /** Asin field set  **/  
    public static List<Schema.FieldSetMember> getAsinFields() {
        return SObjectType.Asin__C.FieldSets.MDTAsinfieldApiNames.getFields();
    }
    
    /** creating question's based on title,Asin  **/
    public static void createQuestions(List<Service_Prep__c> newrecs){
        
        createPs = [SELECT id,label,developername,
                    Field_Label_Value__c,PS_to_Create__c,
                    Question_to_Create__c,Object_Name__c from PPW_Auto_Create_Ps__mdt];
        
        Set<String> titleIds = new Set<String>();
        List<Service_Prep__c> seList = new LIst<Service_Prep__c>();
        seList = [select id,project__r.title__r.Production_Locale__c 
                  from Service_Prep__c where id=:trigger.new];
        
        for(Service_Prep__c sp: seList){
            if(sp.project__c!=null)
                titleIds.add(sp.project__r.title__c);
            
        } 
        
        set<String> fieldsApiNames = new set<string>();
        String query='Select ';
        for(Schema.FieldSetMember f : getTitleFields()) {
            query = query+f.getFieldPath()+',';
            fieldsApiNames.add(f.getFieldPath());
        }
        query = query+'id from Title__c where id=:titleIds';  
        List<Title__c> titlesList = database.query(query);
        
        /** Asin query using field set query  ***/ 
        set<String> assinFieldsApiNames = new set<string>();
        query='Select ';
        for(Schema.FieldSetMember f : getAsinFields()) {
            query = query+f.getFieldPath()+',';
            assinFieldsApiNames.add(f.getFieldPath());
        }
        query = query+'id from Asin__c where Title__c=: titleIds';  
        List<ASIN__c> asinRecords = database.query(query);
        
        map<String,String> serivceName = new map<String,String>();
        
        set<String> titleQusetions = new set<String>();
        titleQus1 = new set<Id>();
        map<String,set<String>> titleQuemap = new map<String,set<String>>();
        
        for(Service__c s: [SELECT id,name from Service__c where active__C = true])
            serivceName.put(s.id,s.id);
        
        /** title based PS creation  **/ 
        for(Title__c t: titlesList){
            for(String s: fieldsApiNames){
                for(string ser: QuestionToCreate(String.valueOf(t.get(s)),s))
                    if(ser!=null)
                    titleQusetions.add(ser);     
            }
        }   
        
        /** Asin based PS creation **/
        for(ASIN__c t: asinRecords){
            for(String s: assinFieldsApiNames){
                for(string ser: QuestionToCreate(String.valueOf(t.get(s)),s))
                    if(ser!=null)
                    titleQusetions.add(ser); 
            }
        }   
        
        string titleId;
        
        List<Service_Prep_Response__c> sPrepRessList = new List<Service_Prep_Response__c>();
        List<Service_Prep_Response__c> createSerResp = new List<Service_Prep_Response__c>();
        
        List<Service_Prep_Question__c> questions = new   List<Service_Prep_Question__c>();
        questions = dynamicQuery();
        for(Service_Prep__c sp: seList){
            for(Service_Prep_Question__c serPrepQus: questions){
                Service_Prep_Response__c sPreRes = new Service_Prep_Response__c();
                if(!titleQus1.contains(serPrepQus.Id))
                {
                    if(!String.isBlank(serPrepQus.Locale__c))
                    {
                        if(sp.project__c!=null && sp.project__r.title__r.Production_Locale__c !=null){
                            if(serPrepQus.Locale__c.containsIgnoreCase(String.valueOf(sp.project__r.title__r.Production_Locale__c).trim())){
                                sPreRes = new Service_Prep_Response__c(Service_Prep__c=sp.id,Service_Prep_Question__c = serPrepQus.id);
                                sPrepRessList.add(sPreRes); 
                            }
                        } 
                    }     
                }else{
                    if(titleQusetions.contains(serPrepQus.Id))
                        if(sp.project__c!=null && sp.project__r.title__r.Production_Locale__c !=null){
                            if(serPrepQus.Locale__c.containsIgnoreCase(String.valueOf(sp.project__r.title__r.Production_Locale__c).trim())){
                                sPreRes = new Service_Prep_Response__c(Service_Prep__c=sp.id,Service_Prep_Question__c = serPrepQus.id);
                                sPrepRessList.add(sPreRes); 
                            }
                        } 
                }
            }
        }
        
        insert sPrepRessList;
    } 
    
    /** Service Prep Question record Dynamic query  **/
    private static List<Service_Prep_Question__c> dynamicQuery(){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get('Service_Prep_Question__c').getDescribe().fields.getMap();
        String query='SELECT ';
        
        query += string.join(new List<String>(fieldMap.keyset()),',');
        query = query.removeend(',');
        query = query+ ' FROM '+ 'Service_Prep_Question__c where Active__c = true';
        System.debug(query);
        System.debug(query);
        return database.query(query);
        
    }
    /** split value for mulitple service ids logic  **/    
    public static Set<string> splitvalues(String str)
    {
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
    
    /** split logic for non ids **/ 
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
    
    /** creating question's depending on title and asin records  **/
    public static set<Id> QuestionToCreate(String imprintName,String FieldName){
        set<Id> serviceids = new set<Id>();
        if(imprintName!=null) {
            for(PPW_Auto_Create_Ps__mdt SerVal: createPs)
            {
                
                if(serVal.label==FieldName)
                    if(serVal.Field_Label_Value__c!=null)
                    if(imprintName.equalsIgnoreCase(serVal.Field_Label_Value__c)){
                        if(serVal.Question_to_Create__c!=null)
                            for(string s: splitvalues(serVal.Question_to_Create__c ))
                            serviceids.add(s);
                    }else{
                        
                        if(serVal.Field_Label_Value__c.contains(','))
                            for(String s: splitvalues1(serVal.Field_Label_Value__c))
                            if(imprintName.equalsIgnoreCase(s))     
                            for(string sval: splitvalues(serVal.Question_to_Create__c))
                            serviceids.add(sval);
                    }
                for(string s: splitvalues(serVal.Question_to_Create__c ))
                    titleQus1.add(s);
                
            }                                                             
        }
        return serviceids;
    }
    
    
}