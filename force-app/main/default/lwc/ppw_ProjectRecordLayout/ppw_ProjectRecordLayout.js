import { LightningElement,api } from 'lwc';
import getProject from '@salesforce/apex/ppw_projectControllerExtension_lwc.getProject1';
export default class Ppw_ProjectThemeLayout extends LightningElement {
    @api recordId;
    project;title;series;data;
    connectedCallback() {
       // this.setSpinner(true);
       getProject({ pId :  this.recordId?  this.recordId : 'a041H00000pWPlCQAW' })
        .then((data) => {
            if(data) {
                console.log(JSON.stringify(data));
                this.data = data;
              //  this.project = data.project;
             //  this.title = data.title;
             //  this.series = data.series;
              
            }
        }).catch((error) => { });
    }

    @api getrefreshpanels() {
        var serq = this.template.querySelector('c-ppw-project-service-panels');
        serq.connectedCallback();  //}).then(() => {
    }
}