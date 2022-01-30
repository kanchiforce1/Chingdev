/***********************************
Author:      Amazon Apub // kkolla@
Used By:     custom page controller which is used in PPW_servicePrepForm page
Description: Child Controller for the PPW ServicePrepForm Form
***********************************/

public class PPW_ServicePrepFormChildController{
    
    public String sId{get;set;}
    public String svalue{get;set;}
    public String inputType{get;set;}
    
    /** Method to call service prep form action function to save the response values for dependent question **/  
    public PageReference dispFunc() {
        
        System.debug(sId);
        System.debug(svalue);
        Service_Prep_Response__c sp = new Service_Prep_Response__c(id=sId);
        if(inputType == 'Number') { 
            sp.Response_Number__c = !String.isBlank(svalue) && digitPatternCheck((svalue))? integer.valueOf(svalue.remove(',')):null;
            sp.Response__c = !String.isBlank(svalue) && digitPatternCheck((svalue))? svalue.remove(','):null;
        }else{
            if(inputType == 'Checkbox'){
                if(svalue == 'on') sp.Response__C = 'true';
                else sp.Response__C = 'false';
            } else  sp.Response__C = svalue;
        }
        System.debug(sp);
        update sp;
        return null;
    }
    
    /** To check the value is a number type or not for given input number type **/   
    public boolean digitPatternCheck(String str) {
        if(!String.isBlank(str)) {
            Pattern p = Pattern.compile('^[0-9,.]+$');
            Matcher m = p.matcher(str);
            return  m.matches();
        } else  return false;
        
    }
    
    public map<String,List<PPW_ServicePrepFormController.SerResWrap>> questions1{get;set;} 
    
}