@isTest
public class PPW_TestDataFactory {
    /** Create eform Template Data  **/
   @testVisible
    private static List<title__c> gettitleData(Integer numOfRec,String pLocale) {
        
        List<title__c> titleList = new List<title__c>();
        title__c titleRec;
        for(integer i=0;i<numOfRec;i++) {
         title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = pLocale,Pre_Dev_Edit_Word_Count__c = 12,Sub_Category__c= 'Historical',Internal_Imprint__c='Lake Union,Thomas & Mercer'
                                   
                                    );
         titleList.add(t);
        }
        System.Assert(titleList.size()>0);
        return titleList;
    }
    
    
     @testVisible
    private static List<title__c> gettitleData1(Integer numOfRec,String pLocale) {
        
        List<title__c> titleList = new List<title__c>();
        title__c titleRec;
       
         title__C t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = pLocale,Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    PR_Tier__c= 'Yes',Internal_Imprint__c='Lake Union,Thomas & Mercer'
                                    );
         titleList.add(t);
         t = new title__C(Status__c=String.valueOf(label.StatusCheckProjectCreation).split(',')[0].trim(),Name='Test',
                                    Production_Locale__c = pLocale,Pre_Dev_Edit_Word_Count__c = 10,Sub_Category__c= 'Historical',
                                    Sales_Tier__c= 'A+,A,B'
                                    );
                                                                                     
         titleList.add(t);
       
        System.Assert(titleList.size()>0);
        return titleList;
    }
    @testVisible
    private static List<project__c> getProjectData(Integer numOfRec,String tId) {
        
        List<project__c> proList = new List<project__c>();
        project__c p;
        for(integer i=0;i<numOfRec;i++) {
         p = new project__c(title__C = tid);
         proList.add(p);
        }
        System.Assert(proList.size()>0);
        return proList;
    }
    
    @testVisible
    private static List<Service_Prep__c> getServicePrepData(Integer numOfRec,String pId) {
        
        List<Service_Prep__c> spList = new List<Service_Prep__c>();
        Service_Prep__c sp;
        for(integer i=0;i<numOfRec;i++) {
         sp = new Service_Prep__c(project__c = pid);
         spList.add(sp);
        }
        System.Assert(spList.size()>0);
        return spList;
    }
    
      public static ppw_censhareConnector.resWrap setPasitiveTestData(Project_services__c ps) {
    // Map<String,Project_services__c> resPs
        Map<String,Project_services__c> psMap = new Map<String,Project_services__c>();
        psMap.put(ps.id,ps);
        ppw_censhareConnector.resWrap rwrp = new ppw_censhareConnector.resWrap();
        rwrp.resStatus = true;
        rwrp.resPs = psMap;
        return rwrp;
    }
    
      public static Map<String,ppw_censhareConnector.resWrap> setPasitiveTestDataPsList(List<Project_services__c> ps) {
    // Map<String,Project_services__c> resPs
        Map<String,ppw_censhareConnector.resWrap> rwrpMap = new Map<String,ppw_censhareConnector.resWrap>();
        Map<String,Project_services__c> psMap = new Map<String,Project_services__c>();
        for(Project_services__c s: ps)
            psMap.put(s.id,s);
       
        ppw_censhareConnector.resWrap rwrp = new ppw_censhareConnector.resWrap();
        rwrp.resStatus = true;
        rwrp.resPs = psMap;
        
       for(Project_services__c s: ps) {
           rwrp.resProjectService = s;
         rwrpMap.put(s.Id, rwrp);
         }
        return rwrpMap;
    }
    
     
    public static ppw_censhareConnector.resWrap setNagetiveTestData(Project_services__c ps) {
    // Map<String,Project_services__c> resPs
        Map<String,Project_services__c> psMap = new Map<String,Project_services__c>();
        psMap.put(ps.id,ps);
        ppw_censhareConnector.resWrap rwrp = new ppw_censhareConnector.resWrap();
        rwrp.resStatus = false;
        rwrp.resErrorMes = 'TSETe';
        rwrp.resPs = psMap;
        return rwrp;
    }
    
     public static User createPoratalUser(String conId, String p) {
           User user = new User(alias = 'test123', email= Userinfo.getUserId()+'@noemail.com',
           // UserRoleId = portalRoleId,
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p, country='United States',IsActive =true,
            ContactId = conId,
            timezonesidkey='America/Los_Angeles', username=Userinfo.getUserId()+ '@noemail.com');
           return user;
               
    }
      
 /*     @testVisible
    private static List<Service_Prep_Question__c> getServicePrepQData(Integer numOfRec) {
        
        List<Service_Prep_Question__c> spQList = new List<Service_Prep_Question__c>();
        Service_Prep_Question__c spq;
        
         spq = new Service_Prep_Question__c(Question_Category__c ='Design Scheduling' ,Sub_Category__c= 'Front Cover' , 
                                            Question__c = 'Design Service Create' ,Question_Type__c = 'Picklist');
         spQList.add(spq);
        
        
        System.Assert(spQList.size()>0);
        return sQpList;
    }
     */ 
        
    }