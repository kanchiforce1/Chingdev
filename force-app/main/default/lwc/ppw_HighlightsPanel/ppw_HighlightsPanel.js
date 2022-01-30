import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getProject from '@salesforce/apex/ppw_projectControllerExtension_lwc.getProject';
export default class Ppw_HighlightsPanel extends NavigationMixin(LightningElement) {
    project;
    @api recordId;
    @api project;
   
    connectedCallback() {
        // this.setSpinner(true);
       console.log(this.project);
        if(!this.project) {
            getProject({ pId :  this.recordId?  this.recordId : 'a041H00000pWPlCQAW' })
            .then((data) => {
                if(data) {
                    this.project = data.project;
                
                
                }
            }).catch((error) => { }); 
        }
     }
     nagivateTotitle(e) {
         var tId = e.target.name;
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
}