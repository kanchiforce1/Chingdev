/* eslint-disable guard-for-in */
/* eslint-disable no-empty */
/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable eqeqeq */
/* eslint-disable no-console */
import { LightningElement, api, track } from 'lwc';
import getESPData from '@salesforce/apex/Esp_Controller_lwc.getESPRecords';
import newEspRecord from '@salesforce/apex/Esp_Controller_lwc.newEspRecord';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 




export default class EspComponent extends LightningElement {

    @api titleId;
    @api title;
    @track espList;
    @track espNew = ''; // esp new flag Vendor__c
    @track espRec; // esp record
    @track espNewRec; // esp record
    @track espCompleteRec; // esp record
    @track espCancelRec; // esp record
    @track espCancelled = false;
    @track createbtnFlg = false;
    @track Noesp = false;

    @api
    getChinookRecords() {
        console.log('this.espList');
        console.log(JSON.stringify(this.title));
        this.espCancelled = false;
        this.createbtnFlg = false;
        getESPData({
            titleId: this.title ? this.title.MartyId : null

        }).then((data) => {
            if (data) {
                this.espList = data;
                console.log(JSON.stringify(data));
                if (data.length > 0) {
                    for (let a in data) {

                        if (data[a].ESP_Status__c == 'New' || data[a].ESP_Status__c == 'Review in Progress') {

                            this.espNewRec = data[a];
                            this.espCompleteRec = null;
                            this.createbtnFlg = false;
                            setTimeout(() => {
                                this.template.querySelector('c-esp-create-component').setesprecMethod();
                            }, 100);
                        }
                        if (data[a].ESP_Status__c == 'Completed') {
                            // this.espNewRec = null;
                            this.espCompleteRec = data[a];
                            this.createbtnFlg = true;
                            setTimeout(() => {
                                this.template.querySelector('c-esp-create-component').setesprecMethod();
                            }, 100);
                        }
                        if (data[a].ESP_Status__c == 'Cancelled') {
                            this.espCancelled = true;
                            this.createbtnFlg = true;
                        }

                    }
                } else
                    this.createbtnFlg = true;


                console.log('this.espList' + this.espList);
                //
            } else {
                console.log('No espList');
                this.Noesp = true;
                this.createbtnFlg = true;
            }

        }).catch((error) => {
            console.log(error);
            this.createbtnFlg = true;
        });

    }

    newEsp() {
        let ESP = {'Title__c': this.title.Id, 'Vendor__c' : this.title.vendor}
        var spinner = this.template.querySelector('[data-id="spinner"]');
        spinner.classList.remove('slds-hide');
        console.log(ESP);
        newEspRecord({
           
            ESP :  JSON.stringify(ESP)
        })
    
        .then(esp => {
            console.log(JSON.stringify(esp));
            if (esp) {
                this.showToast('ESP Record Created Successfully', 'ESP Record Created Successfully', '');
                this.createbtnFlg = false;
                this.getChinookRecords();

            }
            spinner.classList.add('slds-hide');
        }).catch((error) => {
            console.log(error);

        });
       
      
           
    }

    showToast(title, message , mode) {
        const event = new ShowToastEvent({
            title: title,
            variant: 'success',
            mode: mode,
            message: message,
        });
        this.dispatchEvent(event);
    }

}