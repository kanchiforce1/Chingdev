/* eslint-disable no-alert */
/* eslint-disable no-console */
/* eslint-disable eqeqeq */
import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getESPData from '@salesforce/apex/Esp_Controller_lwc.getESPRecords';

export default class Esp_CreateComponent extends LightningElement {


    @api esprec;
    @api title;
    espComplete_Cancel; espStatusNew; espInprogress;espStatusNew_Review;
    iskodelayval; isAssetDelayDelivery;isCopyedit_Performed; isCopyedit_Delay; isAdditionalCopyedit_Performed; isProofReading_Performed;
     isProofReading_Delay;isColdRead_Performed;isColdRead_Delay;


    @api setesprecMethod() {
        console.log(JSON.stringify(this.esprec));
        this.espComplete_Cancel = (this.esprec.ESP_Status__c == 'Completed' || this.esprec.ESP_Status__c == 'Cancelled');
        this.espStatusNew = this.esprec.ESP_Status__c == 'New'; 
        this.espInprogress = (this.esprec.ESP_Status__c == 'Review in Progress');
        this.espStatusNew_Review = (this.esprec.ESP_Status__c == 'New' || this.esprec.ESP_Status__c == 'Review in Progress')
        this.iskodelayval = (this.esprec.KO_Delay__c == 'Yes, Minor (2-3 days)' || this.esprec.KO_Delay__c == 'Yes, Medium (4-5 days)' || this.esprec.KO_Delay__c == 'Yes, Major (6+ days)') ? true : false;
        this.isAssetDelayDelivery = (this.esprec.Asset_Delivery_Delay__c == 'Yes, Minor (2-3 days)' || this.esprec.Asset_Delivery_Delay__c == 'Yes, Medium (4-5 days)' || this.esprec.Asset_Delivery_Delay__c == 'Yes, Major (6+ days)') ? true : false;
        this.isCopyedit_Performed = this.esprec.Copyedit_Performed__c;// === true ? true : false;
        this.isCopyedit_Delay = this.esprec.Copyediting_Delay__c == 'Yes, Minor (2-3 days)' || this.esprec.Copyediting_Delay__c == 'Yes, Medium (4-5 days)' || this.esprec.Copyediting_Delay__c == 'Yes, Major (6+ days)';
        this.isAdditionalCopyedit_Performed = this.esprec.Additional_Copyediting_Performed__c === true ? true : false;
        
        this.isProofReading_Performed = this.esprec.Proofread_Performed__c;//	 === true ? true : false;
        this.isProofReading_Delay = this.esprec.Proofreading_Delays__c == 'Yes, Minor (2-3 days)' || this.esprec.Proofreading_Delays__c == 'Yes, Medium (4-5 days)' || this.esprec.Proofreading_Delays__c == 'Yes, Major (6+ days)';

        this.isColdRead_Performed = this.esprec.Cold_Read_Performed__c;// === true ? true : false;
        this.isColdRead_Delay = this.esprec.Cold_Read_Delays__c == 'Yes, Minor (2-3 days)' || this.esprec.Cold_Read_Delays__c == 'Yes, Medium (4-5 days)' || this.esprec.Cold_Read_Delays__c == 'Yes, Major (6+ days)';


    }

    getChinookRecords() {
        console.log('this.espList');
        console.log(JSON.stringify(this.title));
        getESPData({
            titleId: this.title ? this.title.MartyId : null

        }).then((data) => {
            if (data) {
              
                console.log(JSON.stringify(data));
               
                    for (let a in data) {

                        if (data[a].ESP_Status__c == 'New' || data[a].ESP_Status__c == 'Review in Progress') {
                            this.esprec = data[a];
                          
                        }
                        if (data[a].ESP_Status__c == 'Completed') {
                           
                            this.esprec = data[a];
                           
                        }
                        if (data[a].ESP_Status__c == 'Cancelled') {
                            this.esprec = data[a];
                        }

                    }
             this.setesprecMethod();
            } 

        }).catch((error) => {
            console.log(error);
           
        });

    }

    cancel() {
        espC.ESP_Status__c = 'Cancelled';
        update(espC);
    }

    onhandlekoDelay(e) {
        let a = e.target.value;

        this.iskodelayval = (a == 'Yes, Minor (2-3 days)' || a == 'Yes, Medium (4-5 days)' || a == 'Yes, Major (6+ days)') ? true : false;


    }
    // eslint-disable-next-line no-unused-vars
    handleSuccess(e) {

    }
    btnclick;

    handleClick(event) {
       
       alert(event.currentTarget.dataset.id);
        this.btnclick = event.currentTarget.dataset.id;

    }

    handleSubmit(event) {
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
      
        if (fields && this.btnclick == 'Complete')
            fields.ESP_Status__c = 'Completed';
        if (fields && this.btnclick == 'Cancel')
            fields.ESP_Status__c = 'Cancelled';    //espC.ESP_Status__c = 'Cancelled';
        if (fields && this.btnclick == 'Save')
            fields.ESP_Status__c = 'Review in Progress';    

        this.template.querySelector('lightning-record-edit-form').submit(fields);
        if (this.btnclick == 'Complete')
            this.showToast('ESP Record Status changed', 'ESP Record has status changed to complete', 'sticky');
        else {
            if (this.btnclick == 'Cancel')
                this.showToast('ESP Record Status changed', 'ESP Record has status changed to cancelled', 'sticky');
            else
                this.showToast('ESP Record Saved', 'ESP Record has been save successfully' , 'dismissable');
        }
        setTimeout(() => {
            this.getChinookRecords();
            this.dispatchEvent(new CustomEvent('espcancel'));
        }, 10);
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

    onhandleisAssetDelayDelivery(e) {
        let a = e.target.value;

        this.isAssetDelayDelivery = (a == 'Yes, Minor (2-3 days)' || a == 'Yes, Medium (4-5 days)' || a == 'Yes, Major (6+ days)') ? true : false;


    }

    /* copyediting section all render logics here */

    onhandleCopyEditingPerformed(e) {
        let a = e.target.value;

        if (a) {

            this.isCopyedit_Performed = (a == 'true' || a == true) ? true : false;

        } else {
            this.isCopyedit_Performed = (a == 'true' || a == true) ? true : false;
        }

    }

    

    onhandleAdditionalCopyEditingPerformed(e) {
        let a = e.target.value;

        if (a) {

            this.isAdditionalCopyedit_Performed = (a == 'true' || a == true) ? true : false;

        } else {
            this.isAdditionalCopyedit_Performed = (a == 'true' || a == true) ? true : false;
        }

    }

    onhandleCopyEditingDelay(e) {
        let a = e.target.value;

        this.isCopyedit_Delay = (a == 'Yes, Minor (2-3 days)' || a == 'Yes, Medium (4-5 days)' || a == 'Yes, Major (6+ days)') ? true : false;


    }



    /* proofReading section all render logics here */

    onhandleProofReadingPerformed(e) {
        let a = e.target.value;

        if (a) {

            this.isProofReading_Performed = (a == 'true' || a == true) ? true : false;

        } else {
            this.isProofReading_Performed = (a == 'true' || a == true) ? true : false;
        }

    }

    onhandleProofReadingDelay(e) {
        let a = e.target.value;

        this.isProofReading_Delay = (a == 'Yes, Minor (2-3 days)' || a == 'Yes, Medium (4-5 days)' || a == 'Yes, Major (6+ days)') ? true : false;
    }


    /* cold read section all render logics here */
    onhandleColdReadPerformed(e) {
        let a = e.target.value;

        if (a) {

            this.isColdRead_Performed = (a == 'true' || a == true) ? true : false;

        } else {
            this.isColdRead_Performed = (a == 'true' || a == true) ? true : false;
        }

    }

    onhandleColdReadDelay(e) {
        let a = e.target.value;

        this.isColdRead_Delay = (a == 'Yes, Minor (2-3 days)' || a == 'Yes, Medium (4-5 days)' || a == 'Yes, Major (6+ days)') ? true : false;


    }


}