/* eslint-disable no-console */
import { LightningElement,track,api } from 'lwc';

export default class CbGalleryExternal1 extends LightningElement {
    @api cbi;
    @track imageData;
    @api
    getcbi() {
       console.log('cbit'+ JSON.stringify(this.cbi));
       const imgLst = []
       const cbiv = this.cbi;
       for(let a in cbiv) {
           if(cbiv[a]) {
                let imaged = {}
                imaged.id = cbiv[a].Id;
                imaged.url = 'https://chingdev-dev-ed--c.na72.content.force.com/servlet/servlet.FileDownload?file='+ cbiv[a].Image_Path__c;
                imaged.Caption =cbiv[a].Caption__c;
                imgLst.push(imaged);
                //this.cbi[a] = 
           }
       }
       console.log(imgLst);
       this.imageData = imgLst;
    }
}