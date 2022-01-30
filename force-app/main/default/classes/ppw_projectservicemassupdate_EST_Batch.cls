/***********************************
Author:      Amazon Apub // kkolla@
Used By:     PPW Project
Description: Batch class to roll up existing data of different kinds of project services to one object Project_Service__c
***********************************/


global class ppw_projectservicemassupdate_EST_Batch implements Database.Batchable<sObject>
{
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public Map <String, Schema.SObjectField> fieldMapCBS = schemaMap.get('Comic_Book_Service__c').getDescribe().fields.getMap();
    public Map <String, Schema.SObjectField> fieldMapCS = schemaMap.get('Cover_Service__c').getDescribe().fields.getMap();
    public Map <String, Schema.SObjectField> fieldMapES = schemaMap.get('Editorial_Service__c').getDescribe().fields.getMap();
    public Map <String, Schema.SObjectField> fieldMapFCS = schemaMap.get('Full_Color_Service__c').getDescribe().fields.getMap();
    public Map <String, Schema.SObjectField> fieldMapIS = schemaMap.get('Interior_Service__c').getDescribe().fields.getMap();
    public Map <String, Schema.SObjectField> fieldMapPTS = schemaMap.get('Promotional_Text_Service__c').getDescribe().fields.getMap();
    public List<string> projectId;
    public boolean ESTFlag;
    public static map<string,String> psFieldsetmap = new map<string,String>();
    public static map<String,rate__C> rateMap = new map<String,rate__C>();
   
    public static Map<String,Map <String, Schema.SObjectField>> objNames = new map<String,Map <String, Schema.SObjectField>>();
    /** project service field label and field api names map **/
    
    public map<String,String> psFieldsetMap(){
        map<String,String> psmap = new map<String,String>();
        for(Schema.FieldSetMember osf: SObjectType.Project_Services__c.FieldSets.massUpdateServices.getFields())
            psmap.put(osf.getLabel(),osf.getFieldPath());
        return psmap;
    }
    
    public ppw_projectservicemassupdate_EST_Batch(List<string>str){
        projectId = str;
      
       
    }
    
     public ppw_projectservicemassupdate_EST_Batch(){
      
       
    }
    /** dynamic query forming **/
    public String dyamicquery(String objname, list<Project__c> psIds) {
        String query='Select ';
       
        String SOQL_IDs = '';
        for (Project__c p : psIds) {
            String id_in_quotes = '\''+p.id+'\'';
            if (SOQL_IDs!='') { SOQL_IDs+=','; }  //  add a comma if this isn't the first one
            SOQL_IDs += id_in_quotes;
        }
               
        
        if(objname.containsignoreCase('Comic_Book_Service__c')) {
            for(String sfield : fieldMapCBS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Cover_Service__c')) {
            for(String sfield : fieldMapCS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Editorial_Service__c')) {
            for(String sfield : fieldMapES.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Full_Color_Service__c')) {
            for(String sfield : fieldMapFCS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Interior_Service__c')) {
            for(String sfield : fieldMapIS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Promotional_Text_Service__c')) {
            for(String sfield : fieldMapPTS.keyset())
            query = query+sfield+',';   
        }            
        
        query = query.removeend(',');  // Dynamic Query String, it has all the field values using schema describe
        query = query + ',Service__r.Service_Grouping__c, Service__r.Service_Rate_Type__c,Project__r.title__c,Project__r.title__r.Status__c,Service__r.Name ';
        System.debug('query'+query);
        String s = '';  
        /* object dymanic query **/
          
           // query = query+' FROM '+objname+' WHERE Project__c =: pList';
            if(string.isNotBlank(SOQL_IDs))
            query = query+' FROM '+objname + ' WHERE Project__c != NULL AND Project__c IN ('+ SOQL_IDs +') AND PsUpdate__c = false';
        else
            query = '';
           
        return query;
    }
    
      /** dynamic query forming for record share **/
    public String dyamicquery1(String objname, set<String> vendorIds) {
        String query='Select ';
       
        String SOQL_IDs = '';
        for (String p : vendorIds) {
            String id_in_quotes = '\''+p+'\'';
            if (SOQL_IDs!='') { SOQL_IDs+=','; }  //  add a comma if this isn't the first one
            SOQL_IDs += id_in_quotes;
        }
               
        
        if(objname.containsignoreCase('Comic_Book_Service__c')) {
            for(String sfield : fieldMapCBS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Cover_Service__c')) {
            for(String sfield : fieldMapCS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Editorial_Service__c')) {
            for(String sfield : fieldMapES.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Full_Color_Service__c')) {
            for(String sfield : fieldMapFCS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Interior_Service__c')) {
            for(String sfield : fieldMapIS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Promotional_Text_Service__c')) {
            for(String sfield : fieldMapPTS.keyset())
            query = query+sfield+',';   
        }            
        
        query = query.removeend(',');  // Dynamic Query String, it has all the field values using schema describe
        query = query + ',Service__r.Service_Grouping__c, Service__r.Service_Rate_Type__c,Project__r.title__c,Project__r.title__r.Status__c,Service__r.Name ';
        System.debug('query'+query);
        String s = '';  
        /* object dymanic query **/
          
           // query = query+' FROM '+objname+' WHERE Project__c =: pList';
            query = query+' FROM '+objname + ' WHERE Project__c != NULL AND Vendor__c != NULL AND Vendor__c IN ('+ SOQL_IDs +') AND Project__r.title__r.Status__c IN (\'In Production\', \'Contracted\',\'In Translation\') ';
            system.debug(query);
           
        return query;
    }
    
       /** dynamic query forming **/
    public String dyamicquery2(String objname, list<Project__c> psIds) {
        String query='Select ';
       
        String SOQL_IDs = '';
        for (Project__c p : psIds) {
            String id_in_quotes = '\''+p.id+'\'';
            if (SOQL_IDs!='') { SOQL_IDs+=','; }  //  add a comma if this isn't the first one
            SOQL_IDs += id_in_quotes;
        }
               
        
        if(objname.containsignoreCase('Comic_Book_Service__c')) {
            for(String sfield : fieldMapCBS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Cover_Service__c')) {
            for(String sfield : fieldMapCS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Editorial_Service__c')) {
            for(String sfield : fieldMapES.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Full_Color_Service__c')) {
            for(String sfield : fieldMapFCS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Interior_Service__c')) {
            for(String sfield : fieldMapIS.keyset())
            query = query+sfield+',';
        }    
        if(objname.containsignoreCase('Promotional_Text_Service__c')) {
            for(String sfield : fieldMapPTS.keyset())
            query = query+sfield+',';   
        }            
        
        query = query.removeend(',');  // Dynamic Query String, it has all the field values using schema describe
        query = query + ',Service__r.Service_Grouping__c, Service__r.Service_Rate_Type__c,Project__r.title__c,Project__r.title__r.Status__c,Service__r.Name ';
        System.debug('query'+query);
        String s = '';  
        /* object dymanic query **/
          
           // query = query+' FROM '+objname+' WHERE Project__c =: pList';
            query = query+' FROM '+objname + ' WHERE Project__c != NULL AND Project__c IN ('+ SOQL_IDs +') AND Project__r.title__r.Status__c IN (\'In Production\', \'Contracted\',\'In Translation\') ';
            system.debug(query);
           
        return query;
    }
    
    // get all rates
     public static void rate_Confirmations() {
        
        if(rateMap.isEmpty())
            for(rate__C r : [Select id,Service__c,Vendor__c,Vendor__r.MBO_Program__c,Rate_Currency__c,
                             Rate_Amount__c,Rate_Multiplier__c from rate__c where Active_Rate__c = true]) {
               
                if(r.Service__c!=null&&r.Vendor__c!=null)
            
                rateMap.put(r.id,r);
            }    
        
    }
    
    public Project_Services__c projectServiceMapping(Map <String, Schema.SObjectField> fieldMap,SObject sobj,Project_Services__c ps){
        
        //Project_Services__c p = new Project_Services__c();
        for (String fieldName: fieldMap.keySet()) {
            String label = fieldMap.get(fieldName).getDescribe().getLabel();
            if(psFieldsetmap.containskey(label))
                ps.put(psFieldsetmap.get(label),sobj.get(fieldName));
            
        }   
        return ps; 
    }
    
    public void rateAmountChanges(Project_Services__c ps,SObject cb){
       // system.debug()
        Decimal eCost = cb.get('Estimated_Cost__c') != null? Decimal.valueOf(String.valueOf(cb.get('Estimated_Cost__c'))) : 0;
        String rateMultiplier = ' ('+rateMap.get(ps.rate__c).Rate_Multiplier__c+')';
            switch on ps.Rate_Currency__c {
                when 'USD' {
                    ps.Rate_Amount__c ='$'+eCost + rateMultiplier ;
                    
                }
                when 'EUR' {
                    ps.Rate_Amount__c ='€'+eCost + rateMultiplier;
                }
                when 'GBP' {
                    ps.Rate_Amount__c ='£'+eCost + rateMultiplier;
                } 
                when 'JPY' {
                    ps.Rate_Amount__c ='¥'+eCost + rateMultiplier;
                    
                }
                when else {
                    ps.Rate_Amount__c =''+eCost + rateMultiplier;
                    
                }  
                
            }
        
        ps.Amount__c = eCost;
     
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {     
        if(projectId != null)
            return Database.getQueryLocator('Select id,title__r.status__c from project__c where id=:projectId ');
        else
            return Database.getQueryLocator('Select id,title__r.status__c from project__c ');
    }
    global void execute(Database.BatchableContext bc, List<project__c> projectList)  
    {
        set<Id> publishpsIds = new set<Id>();
        set<Id> nonPublishIds = new set<Id>();
        List<Project__c > psFilter = new List<Project__c>();
        List<Project_Services__c> psList = new List<Project_Services__c>();
        rate_Confirmations();
        for(Project__c p: projectList) {
            
            if(p.title__r.status__c != 'Published')
            nonPublishIds.add(p.id);
            else
            publishpsIds.add(p.id);
           psFilter.add(p);
        }    
        psFieldsetmap = new map<string,String>();
        psFieldsetmap =  psFieldsetMap();
        
        
        List<Sobject> updateServics = new List<Sobject>();
        objNames = new Map<String,Map <String, Schema.SObjectField>>();
        objNames.put('Comic_Book_Service__c',fieldMapCBS);
        objNames.put('Cover_Service__c',fieldMapCS);
        objNames.put('Editorial_Service__c',fieldMapES);
        objNames.put('Full_Color_Service__c',fieldMapFCS);
        objNames.put('Interior_Service__c',fieldMapIS);
        objNames.put('Promotional_Text_Service__c',fieldMapPTS);
        
        Project_Services__c ps;
        
        /** All object data **/
        
        for(String s: objNames.keyset()) 
            
           
            for(SObject cb: (List<SObject>)database.query(dyamicquery(s,psFilter))) {
                
                ps = new Project_Services__c(); // publish
                if(publishpsIds.contains(String.valueOf(cb.get('Project__c')))) {
                   ps = projectServiceMapping(objNames.get(s),cb,ps);
                   ps.put('Rate_Currency__c',cb.get('Currency__c'));
                   rateAmountChanges(ps,cb);
                    updatepsData(s,cb,ps);
                    ps.status__c = 'Completed';
                    updateServics.add(cb);
                    psList.add(ps);
                } else     // non publish
                    if(nonPublishIds.contains(String.valueOf(cb.get('Project__c')))) {
                        ps = projectServiceMapping(objNames.get(s),cb,ps);                   
                        updatepsData(s,cb,ps);
                        ps.put('Amount__c',cb.get('Estimated_Cost__c'));
                        ps.put('Rate_Currency__c',cb.get('Currency__c'));
                        ps.status__c = 'In Planning';
                        updateServics.add(cb);
                        psList.add(ps);
                  }  
             
             }
               
        update updateServics;
        insert psList;
        
    }
   
   public void updatepsData(String s, Sobject cb, Project_Services__c ps) {
                
        ps.put('Service_Type_Complexity__c',cb.get('Service_Type__c'));
        ps.put('Internal_Service_Notes__c',cb.get('Notes__c'));
        
        cb.put('PsUpdate__c',true);
            
   
   } 
    
    global void finish(Database.BatchableContext bc)
    {
      
    }
    
    
}