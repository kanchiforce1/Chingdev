/* eslint-disable eqeqeq */
/* eslint-disable no-console */
import { LightningElement,wire,api,track } from 'lwc';
import { fireEvent } from 'c/pubsub';
import getResults from '@salesforce/apex/lwcCustomLookupController.getResults';
import getTitleIdResults from '@salesforce/apex/lwcCustomLookupController.getTitleIdResults';
import getVendorId from '@salesforce/apex/lwcCustomLookupController.getVendorId';
import { CurrentPageReference } from 'lightning/navigation';
import checkBtnsAccess from '@salesforce/apex/lwcCustomLookupController.checkBtnsAccess';

export default class LwcCustomLookup extends LightningElement {
   

     // search title data in look up field
    searchField(event) {
        var currentText = event.target.value;
        this.LoadingText = true;
       
        this.getTitleData(currentText);
        
    }

    getTitleData(currentText) {
        console.log(JSON.stringify(this.vendor));
        console.log('currentText' + currentText);
        getResults({ ObjectName: this.objectName, fieldName: this.fieldName, fieldName1: this.fieldName1, value: currentText , 
                        filter1: this.filter1, filter2: this.filter2 })
        .then(result => {
            
            if(result) {
                console.log('result' + JSON.stringify(result));
                this.searchRecords= result;
                this.LoadingText = false;
           
                if(result.length == 0) {
                    this.messageFlag = true;
                    this.LoadingText = false;
                }
                else {
                    this.messageFlag = false;
                    this.template.querySelector('[data-id="resultBox"]').classList.add('slds-is-open');
                }
      

            } else {
                    this.LoadingText = false;
                    this.messageFlag = true;
            }
        })
        .catch(error => {
            this.searchRecords= null;
            this.messageFlag = true;
            console.log('-------error-------------'+error);
            console.log(error);
        });

    }

    
  }