public class ProjectScaffolderClass {
    //class to take a project and spin up relevant standard services mapped to the titles locale, imprint, or program. 
    //check that the running user who adds in the project becomes the owner of the services
    
    public static void ServiceScaffolder(List<Project__c> projects) {
        Map<String, Title__c> projectTitleMap = new Map<String, Title__c>();
        Set<String> titleSet = new Set<String>();
        List<Title__c> titles = new List<Title__c>();
        List<Service__c> services = new List<Service__c>();
        
        string productionLocale;
        string imprint;
        
        //Lists for new services to be inserted
        List<Editorial_Service__c> eL = new List<Editorial_Service__c>();
        List<Cover_Service__c> cL = new List<Cover_Service__c>();
        List<Interior_Service__c> iL = new List<Interior_Service__c>();
        List<Promotional_Text_Service__c> ptL = new List<Promotional_Text_Service__c>();
        List<Full_Color_Service__c> fcL = new List<Full_Color_Service__c>();
        List<Comic_Book_Service__c> comL = new List<Comic_Book_Service__c>();
        
        //Unique Service Sets for Creation
        Set<Editorial_Service__c> eS = new Set<Editorial_Service__c>();
        Set<Cover_Service__c> cS = new Set<Cover_Service__c>();
        Set<Interior_Service__c> iS = new Set<Interior_Service__c>();
        Set<Promotional_Text_Service__c> ptS = new Set<Promotional_Text_Service__c>();
        Set<Full_Color_Service__c> fcS = new Set<Full_Color_Service__c>();
        Set<Comic_Book_Service__c> comS = new Set<Comic_Book_Service__c>();
        
        for(Project__c x : projects){
            if(x.Title__c != null){
                titleSet.add(String.valueOf(x.Title__c));
             
            }
        }
        
        if(!titleSet.isEmpty()) {
            titles = [SELECT id, Production_Locale__c, Internal_Imprint__c FROM Title__c WHERE id=:titleSet];
            system.debug(titles);
            services = [SELECT id, Name, Service_Rate_Type__c, Service_Grouping_String__c, US_Standard__c, EU_Standard__c, JCC_Standard__c, Two_Lions_Standard__c, Day_One_Standard__c  
                        FROM Service__c 
                        WHERE Service_Grouping__c!=null AND (US_Standard__c=true OR EU_Standard__c=true OR JCC_Standard__c=true OR Two_Lions_Standard__c=true OR Day_One_Standard__c=true) ];
            
            for(Title__c t : titles) {
               
                for(Project__c p : projects) {
                    projectTitleMap.put(String.valueOf(p.id), t);
                }
                
            }
        }
       
        for (String proj : projectTitleMap.keySet()) { //where the logic takes place to build out services???
            for(Service__c s: services) {
                productionLocale = projectTitleMap.get(proj).Production_Locale__c;
                imprint = projectTitleMap.get(proj).Internal_Imprint__c;
              
                //Editorial
                if(s.Service_Grouping_String__c.contains('Editorial')){
                    if(s.US_Standard__c == true && productionLocale=='US' ){
                        Editorial_Service__c e = new Editorial_Service__c();
                        e.Project__c = proj;
                        e.Service__c = s.Id;
                        eS.add(e);                
                    }
                    if(s.EU_Standard__c == true && (productionLocale=='DE' || productionLocale=='FR' || productionLocale=='IT' || productionLocale=='ES'|| productionLocale=='UK')){
                        Editorial_Service__c e = new Editorial_Service__c();
                        e.Project__c = proj;
                        e.Service__c = s.Id;
                        eS.add(e);                
                    }
                 
                    if(s.JCC_Standard__c == true && imprint=='Jet City Comics' ){
                        Editorial_Service__c e = new Editorial_Service__c();
                        e.Project__c = proj;
                        e.Service__c = s.Id;
                        eS.add(e);                
                    }
                    if(s.Two_Lions_Standard__c == true && imprint=='Two Lions' ){
                        Editorial_Service__c e = new Editorial_Service__c();
                        e.Project__c = proj;
                        e.Service__c = s.Id;
                        eS.add(e);                
                    }
                    if(s.Day_One_Standard__c == true && imprint=='Storyfront' ){
                        Editorial_Service__c e = new Editorial_Service__c();
                        e.Project__c = proj;
                        e.Service__c = s.Id;
                        eS.add(e);                
                    }
                }
                
                //Cover
                if(s.Service_Grouping_String__c.contains('Cover Design')){
                    if(s.US_Standard__c == true && productionLocale=='US' ){
                        Cover_Service__c c = new Cover_Service__c();
                        c.Project__c = proj;
                        c.Service__c = s.Id;
                        cS.add(c);                
                    }
                    if(s.EU_Standard__c == true && (productionLocale=='DE' || productionLocale=='FR' || productionLocale=='IT' || productionLocale=='ES' || productionLocale=='UK')){
                        Cover_Service__c c = new Cover_Service__c();
                        c.Project__c = proj;
                        c.Service__c = s.Id;
                        cS.add(c);                
                    }
                    if(s.JCC_Standard__c == true && imprint=='Jet City Comics' ){
                        Cover_Service__c c = new Cover_Service__c();
                        c.Project__c = proj;
                        c.Service__c = s.Id;
                        cS.add(c);                
                    }
                    if(s.Two_Lions_Standard__c == true && imprint=='Two Lions' ){
                        Cover_Service__c c = new Cover_Service__c();
                        c.Project__c = proj;
                        c.Service__c = s.Id;
                        cS.add(c);                
                    }
                    if(s.Day_One_Standard__c == true && imprint=='Storyfront' ){
                        Cover_Service__c c = new Cover_Service__c();
                        c.Project__c = proj;
                        c.Service__c = s.Id;
                        cS.add(c);                
                    }
                }
                
                //Interior
                if(s.Service_Grouping_String__c.contains('Interior Design')){
                    if(s.US_Standard__c == true && productionLocale=='US' ){
                        Interior_Service__c i = new Interior_Service__c();
                        i.Project__c = proj;
                        i.Service__c = s.Id;
                        iS.add(i);                
                    }
                    if(s.EU_Standard__c == true && (productionLocale=='DE' || productionLocale=='FR' || productionLocale=='IT' || productionLocale=='ES' || productionLocale=='UK') ){
                        Interior_Service__c i = new Interior_Service__c();
                        i.Project__c = proj;
                        i.Service__c = s.Id;
                        iS.add(i);                
                    }
                    if(s.JCC_Standard__c == true && imprint=='Jet City Comics' ){
                        Interior_Service__c i = new Interior_Service__c();
                        i.Project__c = proj;
                        i.Service__c = s.Id;
                        iS.add(i);                
                    }
                    if(s.Two_Lions_Standard__c == true && imprint=='Two Lions' ){
                        Interior_Service__c i = new Interior_Service__c();
                        i.Project__c = proj;
                        i.Service__c = s.Id;
                        iS.add(i);                
                    }
                    if(s.Day_One_Standard__c == true && imprint=='Storyfront' ){
                        Interior_Service__c i = new Interior_Service__c();
                        i.Project__c = proj;
                        i.Service__c = s.Id;
                        iS.add(i);                
                    }
                }
                
                //PT
                if(s.Service_Grouping_String__c.contains('Promotional Text')){
                    if(s.US_Standard__c == true && productionLocale=='US' ){
                        Promotional_Text_Service__c pt = new Promotional_Text_Service__c();
                        pt.Project__c = proj;
                        pt.Service__c = s.Id;
                        ptS.add(pt);                
                    }
                    if(s.EU_Standard__c == true && (productionLocale=='DE' || productionLocale=='FR' || productionLocale=='IT' || productionLocale=='ES' || productionLocale=='UK')){
                        Promotional_Text_Service__c pt = new Promotional_Text_Service__c();
                        pt.Project__c = proj;
                        pt.Service__c = s.Id;
                        ptS.add(pt);                
                    }
                    if(s.JCC_Standard__c == true && imprint=='Jet City Comics' ){
                        Promotional_Text_Service__c pt = new Promotional_Text_Service__c();
                        pt.Project__c = proj;
                        pt.Service__c = s.Id;
                        ptS.add(pt);                
                    }
                    if(s.Two_Lions_Standard__c == true && imprint=='Two Lions' ){
                        Promotional_Text_Service__c pt = new Promotional_Text_Service__c();
                        pt.Project__c = proj;
                        pt.Service__c = s.Id;
                        ptS.add(pt);                
                    }
                    if(s.Day_One_Standard__c == true && imprint=='Storyfront' ){
                        Promotional_Text_Service__c pt = new Promotional_Text_Service__c();
                        pt.Project__c = proj;
                        pt.Service__c = s.Id;
                        ptS.add(pt);                
                    }
                    
                }
                
                //FC
                if(s.Service_Grouping_String__c.contains('Full Color')){
                    if(s.US_Standard__c == true && productionLocale=='US' ){
                        Full_Color_Service__c fc = new Full_Color_Service__c();
                        fc.Project__c = proj;
                        fc.Service__c = s.Id;
                        fcS.add(fc);                
                    }
                    if(s.EU_Standard__c == true && (productionLocale=='DE' || productionLocale=='FR' || productionLocale=='IT' || productionLocale=='ES'|| productionLocale=='UK')){
                        Full_Color_Service__c fc = new Full_Color_Service__c();
                        fc.Project__c = proj;
                        fc.Service__c = s.Id;
                        fcS.add(fc);                
                    }
                    if(s.JCC_Standard__c == true && imprint=='Jet City Comics' ){
                        Full_Color_Service__c fc = new Full_Color_Service__c();
                        fc.Project__c = proj;
                        fc.Service__c = s.Id;
                        fcS.add(fc);               
                    }
                    if(s.Two_Lions_Standard__c == true && imprint=='Two Lions' ){
                        Full_Color_Service__c fc = new Full_Color_Service__c();
                        fc.Project__c = proj;
                        fc.Service__c = s.Id;
                        fcS.add(fc);                
                    }
                    if(s.Day_One_Standard__c == true && imprint=='Storyfront' ){
                        Full_Color_Service__c fc = new Full_Color_Service__c();
                        fc.Project__c = proj;
                        fc.Service__c = s.Id;
                        fcS.add(fc);               
                    }
                    
                }
                
                //CB
                if(s.Service_Grouping_String__c.contains('Comic Book')){
                    if(s.US_Standard__c == true && productionLocale=='US' ){
                        Comic_Book_Service__c com = new Comic_Book_Service__c();
                        com.Project__c = proj;
                        com.Service__c = s.Id;
                        comS.add(com);                
                    }
                    if(s.EU_Standard__c == true && (productionLocale=='DE' || productionLocale=='FR' || productionLocale=='IT' || productionLocale=='ES'|| productionLocale=='UK')){
                        Comic_Book_Service__c com = new Comic_Book_Service__c();
                        com.Project__c = proj;
                        com.Service__c = s.Id;
                        comS.add(com);                 
                    }
                    if(s.JCC_Standard__c == true && imprint=='Jet City Comics' ){
                        Comic_Book_Service__c com = new Comic_Book_Service__c();
                        com.Project__c = proj;
                        com.Service__c = s.Id;
                        comS.add(com);                 
                    }
                    if(s.Two_Lions_Standard__c == true && imprint=='Two Lions' ){
                        Comic_Book_Service__c com = new Comic_Book_Service__c();
                        com.Project__c = proj;
                        com.Service__c = s.Id;
                        comS.add(com);                 
                    }
                    if(s.Day_One_Standard__c == true && imprint=='Storyfront' ){
                        Comic_Book_Service__c com = new Comic_Book_Service__c();
                        com.Project__c = proj;
                        com.Service__c = s.Id;
                        comS.add(com);                 
                    }
                }                
            }
            system.debug(proj);
            system.debug(projectTitleMap.get(proj));
            system.debug(productionLocale);
        }
        
        eL.addAll(eS);
        cL.addAll(cS);
        iL.addAll(iS);
        ptL.addAll(ptS);
        fcL.addAll(fcS);
        comL.addAll(comS);
        
        system.debug(eL);
        system.debug(cL);
        
        insert(eL);
        insert(cL);
        insert(iL);
        insert(ptL);
        insert(fcL);
        insert(comL);
       System.debug('Total Number of SOQL Queries (Scaffolder): ' +  Limits.getQueries()); 
    }
}