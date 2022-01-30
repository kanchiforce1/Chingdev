@isTest(seeAllData=true)
public class cb_external_test {
    //tests the vendor view page controller...
    public static title__c t = new title__c();
    public static creative_brief__c cb = new creative_brief__c();
    public static creative_brief__c cb2 = new creative_brief__c();
    public static author_questionnaire__c aq = new author_questionnaire__c();
    public static book_questionnaire__c bq = new book_questionnaire__c();
    
    static testMethod void extViewPage(){
        set<id> titles = new set<id>();
        list<title_contact__c> titlesWithAuthors = new list<title_contact__c>([select title__c from title_contact__c where Role__c='Author' AND Title__r.Internal_Imprint__c='47North']);
        
        for(title_contact__c x : titlesWithAuthors){
            titles.add(x.title__c);
        }
        
        list<title__c> title = new list<title__c>([select id from Title__c where id in :titles AND id NOT IN(select title__c from Creative_brief__c) limit 1]);
        
        aq.Title__c = title.get(0).id;
        bq.Title__c = title.get(0).id;
        insert aq;
        insert bq;
        cb.Title__c = title.get(0).id;
        cb.Non_Standard_Formats__c = 'Other';
        cb.Publishing_Background__c = 'Debut';
        insert cb;
        
        list<cbi__c> cbiList = new list<cbi__c>();
        cbi__c cbi1 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief');
        cbi__c cbi2 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief', image_section__c='Concept Imagery', priority__c=1, caption__c='test');
        cbi__c cbi3 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief', image_section__c='Concept Imagery', concept__c='1', priority__c=1, caption__c='test');
        cbi__c cbi4 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief', image_section__c='Concept Imagery', concept__c='2', priority__c=1, caption__c='test');
        cbi__c cbi5 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief', image_section__c='Concept Imagery', concept__c='3', priority__c=1, caption__c='test', delete__c=true);
        cbi__c cbi6 = new cbi__c (creative_brief__c = cb.id, related_to__c='Creative Brief', image_section__c='Additional Related Visual', priority__c=1, caption__c='test');
        
        cbiList.add(cbi1);cbiList.add(cbi2);cbiList.add(cbi3);cbiList.add(cbi4);cbiList.add(cbi5);cbiList.add(cbi6);
        
        cbi__c ps1 = new cbi__c (creative_brief__c = cb.id, related_to__c='Photo Shoot');
        cbi__c ps2 = new cbi__c (creative_brief__c = cb.id, related_to__c='Photo Shoot', image_section__c='Detailed Physical Descriptions', priority__c=1, caption__c='test');
        cbi__c ps3 = new cbi__c (creative_brief__c = cb.id, related_to__c='Photo Shoot', image_section__c='Wardrobe', priority__c=1, caption__c='test');
        cbi__c ps4 = new cbi__c (creative_brief__c = cb.id, related_to__c='Photo Shoot', image_section__c='Hair & Makeup', priority__c=1, caption__c='test');
        cbi__c ps5 = new cbi__c (creative_brief__c = cb.id, related_to__c='Photo Shoot', image_section__c='Props', priority__c=1, caption__c='test', delete__c=true);
        cbi__c ps6 = new cbi__c (creative_brief__c = cb.id, related_to__c='Photo Shoot', image_section__c='Location', priority__c=1, caption__c='test');
        cbi__c ps7 = new cbi__c (creative_brief__c = cb.id, related_to__c='Photo Shoot', image_section__c='Mood/Tone', priority__c=1, caption__c='test');
         cbi__c ps8 = new cbi__c (creative_brief__c = cb.id, related_to__c='Photo Shoot', image_section__c='Lighting Comps', priority__c=1, caption__c='test');
         cbi__c ps9 = new cbi__c (creative_brief__c = cb.id, related_to__c='Photo Shoot', image_section__c='Layout Comps', priority__c=1, caption__c='test');
        
        cbiList.add(ps1);cbiList.add(ps2);cbiList.add(ps3);cbiList.add(ps4);cbiList.add(ps5);cbiList.add(ps6);cbiList.add(ps7);cbiList.add(ps8);cbiList.add(ps9);
        
        insert(cbiList);

        
        test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.cb_vext_view'));
        System.currentPageReference().getParameters().put('id', cb.Id);
        
        cb_externalController exView = new cb_externalController();
        
        exView.getPublishedSeries();
      //  cb_externalController.getimageGalleryMap();
        exView.deCheck = true;
        exView.euCheck = true;
        exView.tlCheck = true;
        exView.translatorCheck = true;
        
        test.stopTest();
    }
    static testMethod void tlCheck(){
        set<id> titles = new set<id>();
        list<title_contact__c> titlesWithAuthors = new list<title_contact__c>([select title__c from title_contact__c where Role__c='Illustrator' AND Title__r.Internal_Imprint__c='Two Lions']);
        
        for(title_contact__c x : titlesWithAuthors){
            titles.add(x.title__c);
        }
        
        list<title__c> title = new list<title__c>([select id from Title__c where id in :titles AND id NOT IN(select title__c from Creative_brief__c) limit 1]);
        
        aq.Title__c = title.get(0).id;
        bq.Title__c = title.get(0).id;
        insert aq;
        insert bq;
        cb.Title__c = title.get(0).id;
        cb.Non_Standard_Formats__c = 'Other';
        cb.Publishing_Background__c = 'Debut';
        insert cb;
        
        test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.cb_vext_view'));
        System.currentPageReference().getParameters().put('id', cb.Id);
        
        cb_externalController exView = new cb_externalController();
        
        test.stopTest();
    }
    
    static testMethod void translatorCheck(){
        set<id> titles = new set<id>();
        list<title_contact__c> titlesWithAuthors = new list<title_contact__c>([select title__c from title_contact__c where Role__c='Translator']);
        
        for(title_contact__c x : titlesWithAuthors){
            titles.add(x.title__c);
        }
        
        list<title__c> title = new list<title__c>([select id from Title__c where id in :titles AND id NOT IN(select title__c from Creative_brief__c) limit 1]);
        
        aq.Title__c = title.get(0).id;
        bq.Title__c = title.get(0).id;
        insert aq;
        insert bq;
        cb.Title__c = title.get(0).id;
        cb.Non_Standard_Formats__c = 'Other';
        cb.Publishing_Background__c = 'Debut';
        insert cb;
        
        test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.cb_vext_view'));
        System.currentPageReference().getParameters().put('id', cb.Id);
        
        cb_externalController exView = new cb_externalController();
        
        test.stopTest();
    }
}