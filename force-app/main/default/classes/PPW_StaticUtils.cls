/***********************************
Author:      Amazon Apub // kkolla@
Used By:     PPW_servicePrepFormControllerHelper (used for dynamic query of custom metdata type PPW_compareFieldUserValue__mdt)
Description: Dynamic Query class
************************************/

public class PPW_StaticUtils {
      public static List<Sobject> dynamicQueryListType(String sObjName, String whereClause, String orderclause) {
        
         try{
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(sObjName).getDescribe().fields.getMap();
            String query='SELECT ';
            query += string.join(new List<String>(fieldMap.keyset()),',');
            query = query.removeend(',');
             for(String field: fieldMap.keySet()) {
                if(String.valueOf(fieldMap.get(field).getDescribe().getType())== 'REFERENCE')
                   if(fieldMap.get(field).getDescribe().isCustom()) {
                       String newField=field.replace('__c', '__r') ;
                       newField= newField+'.Name';
                       query += ',' + newField;
                       System.debug(newField);
                   } else {
                       String newField=field.replace('id', '') ;
                       newField= newField+'.Name';
                       query += ',' + newField;
                   }
            }
            
            query = query+ ' FROM '+ sObjName;
            if(whereClause!=null)
            query = query+ whereClause;
            if(orderclause!=null)
                query = query+ orderclause;
            System.debug(query);
            List<SObject> sObjeList = database.query(query);
            return (!sObjeList.isEmpty()) ? sObjeList : null;        
            
         } catch(Exception exp) { System.debug(exp.getMessage()); return null; } 
        
    }  
    
     public static void txThrowAuraException(Exception e,String clsName,String mName,String frmType,String mrtId,String vendor) {
       
        insert new CommunityException__c(Error_Message__c= e.getMessage(),
                                Class_Name__c = clsName,Method_Name__c = mName,
                                Form_Type__c =  frmType,
                                Marty_title_ID__c =  mrtId,
                                Vendor__c =  vendor,
                                Line_Number__c = e.getLineNumber());
        if (!Test.isRunningTest()) {
            throw new AuraHandledException('');
        }
    }
    
    
    //copied from ppw_utils
    
    public static boolean verifyLocale(String titlelocale, String locale ) { // verify locale with title from vendor,project,ps
        if(String.isNotBlank(titlelocale) && String.isNotBlank(locale)) {
        List<String> tlocale = splitString(titlelocale);
        for(String str: tlocale)
            if(locale.contains(str))
                return true;
             
        
        }
    return false;
    }
    public static List<String> splitString(String titlelocale) {
     List<String> tlocale = new List<String>();
        if(titlelocale.contains(';')) 
            tlocale = titlelocale.split(';');
        else tlocale.add(titlelocale);
    return tlocale;
    
    }
    
     public static String makeListIncludesType(String prodLocale) {
       List<String> plocale = new List<String>();
      
       for(String s: splitString(prodLocale))
           plocale.add('\''+ s+ '\'');
        return String.join(plocale, ',');
       // return 
    }

    

}