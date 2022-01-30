/* eslint-disable no-else-return */
/* eslint-disable guard-for-in */
/* eslint-disable eqeqeq */
/* eslint-disable no-console */
import { LightningElement, api, track } from 'lwc';
import getCBData from '@salesforce/apex/cb_Controller_lwc.getCBData';

export default class CreativeBriefComponent extends LightningElement {

    //@api componentname;
    @api title = {};
    @track c = {};
    cbc1 = []; cbc2 = []; cbc3 = []; cbca = []; cbci = []; // concepts images
    psi = []; dpd = []; w = []; hm = []; p = []; location = []; mt = []; lighting = []; layout = []; //Photo Shoot Image Lists
    translatorName; tlCheck; euCheck; translatorCheck; nonStandardFormats;
    selectedPublicationBackgrounds; imageGallery; illustratorName; publishedSeries; photoShoot; // creative brief meta data
    coverContent;aboutTheAuthor;aboutTheSeries;aboutTheBook;packaging;creativeDirection;promotionalText;preProduction;
    psCreativeDirection;postProduction;
    connectedCallback() {
        this.c.Title__r = [];

    }

    @api
    getCBRecords() {
        console.log('child vent');
        console.log(JSON.stringify(this.title));
        getCBData({
            titleId: this.title ? this.title.MartyId : null

        }).then((data) => {
            if (data) {
                this.c = data.c;
                this.photoShoot = this.c.Photo_Shoot__c;
                this.translatorName = data.translatorName;
                this.tlCheck = data.tlCheck;
                this.euCheck = data.euCheck;
                this.deCheck = data.deCheck;
                this.illustratorName = data.illustratorName;
                this.translatorCheck = data.translatorCheck;
                this.nonStandardFormat = data.nonStandardFormat;
                this.selectedPublicationBackgrounds = data.selectedPublicationBackgrounds;
                //this.imageGallery  = data.imageGallery;
                
                let pSeries = [];
                for(let a in data.PublishedSeries) {
                    let ps = data.PublishedSeries[a]; 
                    ps.ASIN__c = ''+ ps.ASIN__c + '.01.SY450_SCLZZZZZZZ_.jpg';
                    pSeries.push(ps);
                }
                this.publishedSeries = pSeries;
               console.log('publish'+ JSON.stringify(this.publishedSeries));

               // console.log(JSON.stringify(data));
                this.coverContent = this.c.Title__r.Full_Title_Name__c || this.c.Title__r.Author__c || 
                                    this.c.Title__r.Sub_Title__c || this.c.Bestselling_Author_Line__c || 
                                    this.c.Author_of_X_Line__c || this.c.Tagline__c || this.c.Publicity_Quotes__c || 
                                    this.c.p1_Other__c || this.c.Title__r.Series__c || this.c.Title__r.External_Imprint__c || 
                                    this.c.Title__r.Category__c ;

                this.aboutTheAuthor =  this.c.Author_Branding_Requirements__c || this.c.Publishing_Background__c;

                this.aboutTheSeries =  this.c.Number_of_Books_in_the_Series__c || this.c.Number_in_Series__c || 
                                       this.c.Series_Description__c || this.c.Relevant_Series_Details || 
                                       this.c.Series_Branding_Requirements__c || this.publishedSeries;   

                this.aboutTheBook = this.c.bq_5_3__c || this.c.bq_5_4__c || this.c.bq_5_5__c || this.c.bq_5_10__c || 
                                    this.c.bq_5_6__c || this.bq_5_7__c || this.c.bq_5_13__c || this.c.bq_5_11__c || 
                                    this.c.bq_5_14__c || this.c.bq_5_15__c || this.c.Restricted_Content_to_Avoid__c;

                this.packaging = this.c.Non_Standard_Formats__c|| this.c.Non_Standard_Format_Notes__c;
                                        

                this.creativeDirection = this.c.Visual_Details_1__c || this.c.Concept_Description_1__c || 
                                         this.c.Concept_Description_2__c || this.c.Concept_Description_3__c ||
                                         this.c.Genre_Subgenre_Conventions__c;
                
                this.promotionalText = this.c.Cover_and_Promo_Text_Interplay__c || this.c.Hook_That_the_Promo_Text_Should_Leverage__c ||
                                       this.c.Promo_Text_Focus_Area__c || this.c.Sexual_Content_Rating__c || 
                                       this.c.Violence_Ratings__c;

                this.preProduction = this.c.ps_date_of_shoot__c || this.c.ps_Assets_Deliverable_Due_Date__c ||
                                     this.c.ps_Photo_Shoot_Description__c || this.c.ps_Photo_Shoot_Location__c || 
                                     this.c.ps_Subject__c || this.c.ps_Time_Period__c || this.c.ps_Description_of_Characters__c ||
                                     this.c.ps_Detailed_Physical_Descriptions__c || this.c.ps_Wardrobe__c ||
                                     this.c.ps_Hair_Makeup__c || this.c.ps_Props__c;

                this.psCreativeDirection = this.c.ps_Personality_Descriptions__c || this.c.ps_Location__c ||
                                           this.c.ps_Mood_Tone__c || this.c.ps_Lighting_Description__c || 
                                           this.c.ps_Shot_List__c;

                this.postProduction = this.c.ps_Personality_Descriptions__c;
                setTimeout(() => {
                if (data.imageGallery)
                    this.getCBIData(data.imageGallery);
                }, 10);    


            }
        })
            .catch((error) => {
                console.log(error);
                //  this.message = 'Error received: code' + error.errorCode + ', ' +
                //   'message ' + error.body.message;
            });
    }
    get layoutSize() {

        if (this.layout)
            return this.layout.length;
        else
            return this.layout.length;
    }

    // frame cbi data images
    getCBIData(allCBI) {
        ///debugger;
        try {
            console.log(allCBI);
            for (let cbi in allCBI) {
              ///  console.log(allCBI[cbi].Related_To__c);
                if (allCBI[cbi]) {
                    if (allCBI[cbi].Related_To__c == 'Creative Brief') {
                        if (allCBI[cbi].Image_Section__c == null || allCBI[cbi].Priority__c == null) {
                            this.cbci.push(allCBI[cbi]);
                            console.log(allCBI[cbi].Image_Section__c);
                            console.log(allCBI[cbi].Priority__c);

                        }
                        if (allCBI[cbi].Image_Section__c == 'Concept Imagery' && allCBI[cbi].Concept__c == null) {
                            this.cbci.push(allCBI[cbi]);

                        }
                        if (allCBI[cbi].Image_Section__c == 'Concept Imagery') {
                            if (allCBI[cbi].Concept__c == '1') {
                                this.cbc1.push(allCBI[cbi]);
                            }
                            if (allCBI[cbi].Concept__c == '2') {
                                this.cbc2.push(allCBI[cbi]);
                            }
                            if (allCBI[cbi].Concept__c == '3') {
                                this.cbc3.push(allCBI[cbi]);
                            }
                        }

                        if (allCBI[cbi].Image_Section__c == 'Additional Related Visual') {
                            this.cbca.push(allCBI[cbi]);
                        }

                    }

                    if (allCBI[cbi].Related_To__c == 'Photo Shoot') {
                        if (allCBI[cbi].Image_Section__c == null || allCBI[cbi].Priority__c == null) {
                            this.psi.push(allCBI[cbi]);

                        }
                        if (allCBI[cbi].Image_Section__c == 'Detailed Physical Descriptions') {
                            this.dpd.push(allCBI[cbi]);
                        }
                        if (allCBI[cbi].Image_Section__c == 'Wardrobe') {
                            this.w.push(allCBI[cbi]);
                        }
                        if (allCBI[cbi].Image_Section__c == 'Hair & Makeup') {
                            this.hm.push(allCBI[cbi]);
                        }
                        if (cbi.Image_Section__c == 'Props') {
                            this.p.push(allCBI[cbi]);
                        }
                        if (allCBI[cbi].Image_Section__c == 'Location') {
                            this.location.push(allCBI[cbi]);
                        }
                        if (allCBI[cbi].Image_Section__c == 'Mood/Tone') {
                            this.mt.push(allCBI[cbi]);
                        }
                        if (allCBI[cbi].Image_Section__c == 'Lighting Comps') {
                            this.lighting.push(allCBI[cbi]);
                        }
                        if (allCBI[cbi].Image_Section__c == 'Layout Comps') {
                            this.layout.push(allCBI[cbi]);
                        }
                    }
                }
            }
        } catch (e) { console.log(e); }
        console.log('cbc1' + JSON.stringify(this.cbc1));
        console.log( 'cbc2' + JSON.stringify(this.cbc2));
        console.log( 'cbc3' + JSON.stringify(this.cbc3));
        console.log( 'cbca' + JSON.stringify(this.cbca));
       // this.template.querySelector('[data-id="rejectMenu1"]')
        const cbc1 = this.template.querySelector('[data-id="cbc1"]');
        if (cbc1) {
           
            cbc1.cbi = this.cbc1;
            cbc1.getcbi();
        }
        const cbc2 = this.template.querySelector('[data-id="cbc2"]');
        if (cbc2) {
          
            cbc2.cbi = this.cbc2;
            cbc2.getcbi();
        }
        const cbc3 = this.template.querySelector('[data-id="cbc3"]');
        if (cbc3) {
            cbc3.cbi = this.cbc3;
            cbc3.getcbi();
        }
        const cbca = this.template.querySelector('[data-id="cbca"]');
        if (cbca) {
            cbca.cbi = this.cbca;
            cbca.getcbi();
        }

        const hm = this.template.querySelector('[data-id="hm"]');
        if (hm) {
            hm.cbi = this.hm;
            hm.getcbi();
        }
       
    }

    cdDownLoad(e) {
      //  let tiId = e.currentTarget.name;
       // window.location.href = '/s/cb-exportaspdf';
        let tiId = e.currentTarget.name;
        window.open('/lwccommunity/cb_vendor_export_view?titleId='+ tiId , '_blank');

        //window.open('/lwccommunity/s/cb-exportaspdf?titleId='+ tiId , '_blank');
    }

}