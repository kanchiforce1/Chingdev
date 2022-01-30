public with sharing class cb_Controller_lwc {
    public string titleId;// = ApexPages.currentPage().getParameters().get('titleId');
    public static string cbid;// = ApexPages.currentPage().getParameters().get('id');
   
    
    
    public static List<String> nonStandardFormats {get; set;}
    public static List<String> selectedPublicationBackgrounds {get; set;}
  
    public class cbWrpData {
        @AuraEnabled
        public Creative_Brief__c c {get; set;}
        @AuraEnabled
        public boolean tlCheck {get; set;}
        @AuraEnabled
        public boolean euCheck {get; set;}
        @AuraEnabled
        public boolean deCheck {get; set;}
        @AuraEnabled
        public boolean translatorCheck {get; set;}
        @AuraEnabled
        public string translatorName{get; set;}
        @AuraEnabled
        public string illustratorName{get; set;}
        @AuraEnabled
        public List<String> nonStandardFormats {get; set;}
        @AuraEnabled
        public List<String> selectedPublicationBackgrounds {get; set;}
        @AuraEnabled
        public List<CBI__c> imageGallery {get; set;}
        @AuraEnabled
        public List<ASIN__c> PublishedSeries {get; set;} 
    
    }
    @AuraEnabled
    public static cbWrpData getCBData(String titleId) {
     cbWrpData cbd = new cbWrpData();
         system.debug(titleId);
        if(titleId!=null) 
            cbid = [SELECT id FROM Creative_Brief__c WHERE Title__r.Marty_Title_ID__c =: titleId].id;
       // else
            
        
        if(cbid != null) {
        
            list<creative_brief__c> cb = new list<creative_brief__c> 
                ([SELECT 
                  id, Name, 
                  Title__c, Title__r.Marty_Title_Id__c, Title__r.Name, Title__r.Full_Title_Name__c, Title__r.Series__c, Title__r.External_Imprint__c, Title__r.Internal_Imprint__c, Title__r.Production_Locale__c, Title__r.Is_In_Series__c, Title__r.Category__c, Title__r.Author__c, Title__r.Sub_title__c, Title__r.Number_in_Series__c,
                  Title__r.Current_Editor__c, Title__r.Marketing_Manager__c, Title__r.Production_Manager__c, Title__r.Art_Director__c, Title__r.Content_Producer__c, Title__r.Kim_Art_Director__c,
                  Author_of_X_Line__c, Bestselling_Author_Line__c, Tagline__c, Publicity_Quotes__c, p1_Other__c, 
                  Author_Branding_Requirements__c, Publishing_Background__c,
                  Number_of_Books_in_the_Series__c, Series_Description__c, Relevant_Series_Details__c, Series_Branding_Requirements__c,
                  bq_5_3__c, bq_5_4__c, bq_5_5__c, bq_5_6__c, bq_5_7__c, bq_5_10__c, bq_5_11__c, bq_5_13__c, bq_5_14__c, bq_5_15__c, Restricted_Content_to_Avoid__c, Non_Standard_Formats__c, Non_Standard_Format_Notes__c,
                  Genre_Subgenre_Conventions__c, Hook_That_the_Promo_Text_Should_Leverage__c, Promo_Text_Focus_Area__c, Sexual_Content_Rating__c, Violence_Ratings__c, Violence_Description__c,
                  ps_date_of_shoot__c, ps_assets_deliverable_due_date__c,ps_Photo_Shoot_Location__c, ps_photo_shoot_description__c, ps_Subject__c, ps_Time_Period__c, ps_Description_of_Characters__c, ps_Detailed_Physical_Descriptions__c,
                  ps_Wardrobe__c, ps_Hair_Makeup__c, ps_Props__c, ps_Personality_Descriptions__c, ps_Location__c, ps_Mood_Tone__c, ps_Shot_List__c, ps_Lighting_Description__c,
                  concept_description_1__c, visual_details_1__c, concept_description_2__c, visual_details_2__c, concept_description_3__c, visual_details_3__c, Cover_and_Promo_Text_Interplay__c, Photo_Shoot__c
                  FROM Creative_Brief__c 
                  WHERE id = :cbid LIMIT 1]);
            
            
            if(!cb.isEmpty()){
                //set the primary creative brief record
                cbd.c = cb.get(0);
            
                
             //   string translatorID = Metalookup.FindContributors(cbd.c.Title__c, 'Translator');
                
              //  Map<string, Contact> contactMap = new Map<string, Contact>([select id, Name from contact where id in (select legal_name__c from title_contact__c)]);
                Map<String, Title_Contact__c> tcMap = new Map<String, Title_Contact__c>();
                
                
                  List<Title_Contact__c> tc = new List<Title_Contact__c>();
                   List<Id> tcIds = new List<Id>();
                   for(Title_Contact__c t : [SELECT id, name, role__c,Legal_Name__r.id, Legal_Name__r.Name,Title__r.Production_Locale__c ,Legal_Name__r.pen_Name__c
                          FROM Title_Contact__c 
                          WHERE (Role__c = 'Translator' OR Role__c= 'Illustrator') AND Title__r.Id=: cbd.c.Title__c 
                          ORDER BY Legal_Name__r.LastName ASC 
                          ]) {
                        tcMap.put(t.Role__c, t);
                        tcIds.add(t.id);
                    }       
                     
                //Map<string, Contact> contactMap = new Map<string, Contact>([select id, Name,pen_Name__c from contact where id in (select legal_name__c from title_contact__c where id=: tcIds)]);
                
                //checks for conditional sections/questions
                if(tcMap != null) {
                    if(tcMap.containsKey('Translator')) {
                        Title_Contact__c tcc = tcMap.get('Translator');
                        String pLocale = String.isNotBlank(tcc.title__r.Production_Locale__c)? tcc.title__r.Production_Locale__c.trim(): tcc.title__r.Production_Locale__c;
                       cbd.translatorName = (pLocale == 'DE' || pLocale == 'US')? String.isNotEmpty(tcc.Legal_Name__r.pen_Name__c) ? tcc.Legal_Name__r.pen_Name__c : tcc.Legal_Name__r.Name : tcc.Legal_Name__r.Name;
                      //  cbd.translatorName = tcMap.get('Translator').Legal_Name__r.Name;
                        if(cbd.translatorName != null){cbd.translatorCheck=true;}
                    }  
             
                if(cbd.c.Title__r.Production_Locale__c == 'EU'){cbd.euCheck = true;}
                if(cbd.c.Title__r.Internal_Imprint__c == 'Apub DE' || cbd.c.Title__r.Internal_Imprint__c == 'Crossing DE'){cbd.deCheck = true;}
                if(cbd.c.Title__r.Internal_Imprint__c == 'Two Lions'){
                    cbd.tlCheck=true;
                    if(tcMap.containsKey('Illustrator'))
                       cbd.illustratorName = tcMap.get('Illustrator').Legal_Name__r.Name;
                  
                  /*  string illustratorID = Metalookup.FindContributors(cbd.c.Title__c, 'Illustrator');
                    if(contactMap.containsKey(illustratorID))
                        cbd.illustratorName = contactMap.get(illustratorID).Name; */
                }
              }
                
                //set and handle multi-select values
                if(cbd.c.Publishing_Background__c != null){
                    selectedPublicationBackgrounds = new List<String>();
                    cbd.selectedPublicationBackgrounds = cbd.c.Publishing_Background__c.split(';');
                }
                if(cbd.c.Non_Standard_Formats__c != null){
                    nonStandardFormats = new List<String>();
                    cbd.nonStandardFormats = cbd.c.Non_Standard_Formats__c.split(';');
                }
                ////
                
                //retrieve CBI records for mapping
                cbd.imageGallery = getimageGalleryMap();
                ////
                
            }
            
        }
        
        /*   */
        cbd.PublishedSeries = getPublishedSeries(cbd.c); 
       return cbd;
    }
    
    public static List<CBI__c> getimageGalleryMap() {
        Map<String,List<CBI__c>> imageGalleryMap = new Map<String,List<CBI__c>>();
        
        List<CBI__c> allCBI = [SELECT id, name, caption__c, concept__c, creative_brief__c, image_path__c, image_section__c, priority__c, related_to__c, delete__c
                               FROM CBI__c
                               WHERE creative_brief__c = :cbid
                               ORDER BY Priority__c ASC];
        return allCBI;                       
        //Concept Image Lists
       /* 
        
        
      
        
        return imageGalleryMap; */
    }
    
    public static List<ASIN__c> getPublishedSeries(Creative_Brief__c c) {
        system.debug(c);
        if(c!=null) {
            string authorID = MetaLookup.FindAuthor(String.valueOf(c.Title__c));
            string series = c.Title__r.Series__c;
            string titleID = c.Title__c;
            system.debug(c.Title__r.Series__c);
            system.debug(c.Title__c);
            
            List<ASIN__c> previousASINs = new List<ASIN__c>();
            if(series != null){
                        
                previousASINs = [
                    SELECT id, ASIN__c,Title_Name__c, Title_External_Imprint__c 
                    FROM ASIN__c 
                    WHERE Title__c 
                    IN (SELECT Title__c 
                    FROM Title_Contact__c 
                    WHERE Legal_Name__c = :authorID AND Title_Status__c IN ('In Production', 'Published') AND Title_Series__c = :series AND Title__c != :titleID) AND Name = 'Digital' ORDER BY Apub_Publish_Date__c ASC
                ]; 
            }
            
            system.debug('previousASINs' + previousASINs);
            return previousASINs;
        } else
            return null;
    }
}