public class cb_externalController {
    public string titleId = ApexPages.currentPage().getParameters().get('titleId');
    public string cbid = ApexPages.currentPage().getParameters().get('id');
    public Creative_Brief__c c {get; set;}
    
    public boolean tlCheck {get; set;}
    public boolean euCheck {get; set;}
    public boolean deCheck {get; set;}
    public boolean translatorCheck {get; set;}
    public string translatorName{get; set;}
    public string illustratorName{get; set;}
    
    public List<String> nonStandardFormats {get; set;}
    public List<String> selectedPublicationBackgrounds {get; set;}
    
    public Map<String,List<CBI__c>> imageGalleryMap {get {
        if(imageGalleryMap == null)
            return getimageGalleryMap1();
        else
            return imageGalleryMap;     
    } set;}
    public Map<String,List<CBI__c>> imageGalleryMap2 {get; set;}
    
    public void doinit() {
    
    }
    
    public cb_externalController() {
       // imageGalleryMap = new  Map<String,List<CBI__c>>();
       // imageGalleryMap2 = new  Map<String,List<CBI__c>>();
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
                c = cb.get(0);
                
                string translatorID = Metalookup.FindContributors(c.Title__c, 'Translator');
                
                Map<string, Contact> contactMap = new Map<string, Contact>([select id, Name,pen_Name__c from contact where id in (select legal_name__c from title_contact__c)]);
                
                //checks for conditional sections/questions
                if(contactMap.containsKey(translatorID)) {
                    translatorName = (c.Title__r.Production_Locale__c == 'DE' || c.Title__r.Production_Locale__c == 'US')? String.isNotEmpty(contactMap.get(translatorID).pen_Name__c) ? contactMap.get(translatorID).pen_Name__c : contactMap.get(translatorID).Name : contactMap.get(translatorID).Name;
                    if(translatorName != null){translatorCheck=true;}
                }
                if(c.Title__r.Production_Locale__c == 'EU'){euCheck = true;}
                if(c.Title__r.Internal_Imprint__c == 'Apub DE' || c.Title__r.Internal_Imprint__c == 'Crossing DE'){deCheck = true;}
                if(c.Title__r.Internal_Imprint__c == 'Two Lions'){
                    tlCheck=true;
                    string illustratorID = Metalookup.FindContributors(c.Title__c, 'Illustrator');
                    if(contactMap.containsKey(illustratorID))
                        illustratorName = contactMap.get(illustratorID).Name;
                }
                ////
                
                //set and handle multi-select values
                if(c.Publishing_Background__c != null){
                    selectedPublicationBackgrounds = new List<String>();
                    selectedPublicationBackgrounds = c.Publishing_Background__c.split(';');
                }
                if(c.Non_Standard_Formats__c != null){
                    nonStandardFormats = new List<String>();
                    nonStandardFormats = c.Non_Standard_Formats__c.split(';');
                }
                ////
                
                //retrieve CBI records for mapping
               /// imageGalleryMap = getimageGalleryMap1();
               //getimageGalleryMap1();
                ////
                
            }
            
        }
    }
    
    public Map<String,List<CBI__c>> getimageGalleryMap1() {
        Map<String,List<CBI__c>> imageGalleryMap1 = new Map<String,List<CBI__c>>();
        
        List<CBI__c> allCBI = [SELECT id, name, caption__c, concept__c, creative_brief__c, image_path__c, image_section__c, priority__c, related_to__c, delete__c
                               FROM CBI__c
                               WHERE creative_brief__c = :cbid
                               ORDER BY Priority__c ASC];
                               
        CBI__c cb = new CBI__c();                       
        //Concept Image Lists
        List<CBI__c> cbc1 = new List<CBI__c>();
        List<CBI__c> cbc2 = new List<CBI__c>();
        List<CBI__c> cbc3 = new List<CBI__c>();
        List<CBI__c> cbca = new List<CBI__c>();
        List<CBI__c> cbci = new List<CBI__c>();
        
        
        //Photo Shoot Image Lists
        List<CBI__c> psi = new List<CBI__c>();
        List<CBI__c> dpd = new List<CBI__c>();
        List<CBI__c> w = new List<CBI__c>();
        List<CBI__c> hm = new List<CBI__c>();
        List<CBI__c> p = new List<CBI__c>();
        List<CBI__c> location = new List<CBI__c>();
        List<CBI__c> mt = new List<CBI__c>();
        List<CBI__c> lighting = new List<CBI__c>();
        List<CBI__c> layout = new List<CBI__c>();
        
        for(CBI__c cbi : allCBI) {
            system.debug(cbi);
            cb = cbi;
            if(cbi.Related_To__c == 'Creative Brief'){
                if(cbi.Image_Section__c == null || cbi.Priority__c == null){
                    cbci.add(cbi);
                    continue;
                }
                if(cbi.Image_Section__c == 'Concept Imagery' && cbi.Concept__c == null){
                    cbci.add(cbi);
                    continue;
                }
                if(cbi.Image_Section__c == 'Concept Imagery'){
                    if(cbi.Concept__c == '1'){
                        cbc1.add(cbi);
                    }
                    if(cbi.Concept__c == '2'){
                        cbc2.add(cbi);
                    }
                    if(cbi.Concept__c == '3'){
                        cbc3.add(cbi);
                    }
                }
                
                if(cbi.Image_Section__c == 'Additional Related Visual'){
                    cbca.add(cbi);
                }
                
            }
            
            if(cbi.Related_To__c == 'Photo Shoot'){
                if(cbi.Image_Section__c == null || cbi.Priority__c == null){
                    psi.add(cbi);
                    continue;
                }
                if(cbi.Image_Section__c == 'Detailed Physical Descriptions'){
                    dpd.add(cbi);
                }
                if(cbi.Image_Section__c == 'Wardrobe'){
                    w.add(cbi);
                }
                if(cbi.Image_Section__c == 'Hair & Makeup'){
                    hm.add(cbi);
                }
                if(cbi.Image_Section__c == 'Props'){
                    p.add(cbi);
                }
                if(cbi.Image_Section__c == 'Location'){
                    location.add(cbi);
                }
                if(cbi.Image_Section__c == 'Mood/Tone'){
                    mt.add(cbi);
                }
                if(cbi.Image_Section__c == 'Lighting Comps'){
                    lighting.add(cbi);
                }
                if(cbi.Image_Section__c == 'Layout Comps'){
                    layout.add(cbi);
                }
            }
        }
        
        
        
        //imageGalleryMap.put('cbci', cbci);
        //imageGalleryMap.put('psi', psi);
        imageGalleryMap1.put('cbc1', cbc1);
        imageGalleryMap1.put('cbc2', cbc2);
        imageGalleryMap1.put('cbc3', cbc3);
        imageGalleryMap1.put('cbca', cbca);
        imageGalleryMap1.put('dpd', dpd);
        imageGalleryMap1.put('w', w);
        imageGalleryMap1.put('hm', hm);
        imageGalleryMap1.put('p', p);
        imageGalleryMap1.put('location', location);
        imageGalleryMap1.put('mt', mt);
        imageGalleryMap1.put('lighting', lighting);
        imageGalleryMap1.put('layout', layout); 
        system.debug(imageGalleryMap1);
        cbi__c cbic = new cbi__c(Related_To__c = 'testte');
        
       // imageGalleryMap.put('cbc1', new List<String>{'test'});
       // imageGalleryMap = imageGalleryMap1;
        return imageGalleryMap1;
    }
    
    public List<ASIN__c> getPublishedSeries() {
        string authorID = MetaLookup.FindAuthor(String.valueOf(c.Title__c));
        string series = c.Title__r.Series__c;
        string titleID = c.Title__c;
        List<ASIN__c> previousASINs = new List<ASIN__c>();
        if(series != null){
            previousASINs = [
                SELECT id, ASIN__c, Title__r.Name, Title__r.External_Imprint__c 
                FROM ASIN__c 
                WHERE Title__c 
                IN (SELECT Title__c 
                FROM Title_Contact__c 
                WHERE Legal_Name__c = :authorID AND Title__r.Status__c IN ('In Production', 'Published') AND Title__r.Series__c = :series AND Title__c != :titleID) AND Name = 'Digital' ORDER BY Apub_Publish_Date__c ASC
            ];
        }
        
        system.debug(previousASINs);
        return previousASINs;
    }
}