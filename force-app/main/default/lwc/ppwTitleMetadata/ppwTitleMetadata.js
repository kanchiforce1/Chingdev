import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import viewInCenshare from '@salesforce/label/c.View_in_Censhare';
export default class PpwTitleMetadata extends NavigationMixin(LightningElement) {
    
    @api titledata;
   

    renderedCallback() {
      
    }
    get title() {
        return this.titledata.title;
    }
    get series() {
        return this.titledata.series;
    }
    get seriestitlesCB() {
        return this.titledata.seriestitlesCB;
    }
    get seriestitleprojects() {
        return this.titledata.seriestitleprojects;
    }
    connectedCallback() {
      
        console.log('titledata' + JSON.stringify(this.titledata));
     
    }
    nagivateTotitle(e) {
        var tId = e.target.name;
        this.navigation(tId);
    }

    navigation(tId) {
        // Generate a URL to a User record page
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: tId,
                actionName: 'view',
            },
        }).then(url => {
            window.open(url, "_blank");
        });
    }
    projectNavigation(e) {
       
        var tId= e.target.name;
        var p = this.seriestitleprojects[tId];
        if(p)
            this.navigation(p.Id);
    
    }
    cbNavigation(e) {
        var tId= e.target.name;
        var cb = this.seriestitlesCB[tId];
       if(cb) {
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__webPage',
                    attributes: {
                        url: '/apex/cb_view?id=' + cb
                    }
                }).then(generatedUrl => {
                    window.open(generatedUrl);
                });
            }
    }
    censhareNavigation(e) {
        var tId= e.target.name;
        var p = this.seriestitleprojects[tId];
        console.log(p);
        if(p) {
        var url = viewInCenshare + p.Censhare_Project_ID__c;
          window.open(String(url) , "_blank");
        }
    }
}