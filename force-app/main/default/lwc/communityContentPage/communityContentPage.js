/* eslint-disable no-unused-vars */

/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable eqeqeq */
/* eslint-disable no-console */
import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';

export default class CommunityContentPage extends LightningElement {
    @track buttonname;
    // @track dataWrap;
    @track transmittal;
    @track cb; titleId;
    @track chinook;
    titleMes;
    @track dataWrap;
    @api title;
    @wire(CurrentPageReference) pageRef;
    connectedCallback() {
        // this.spinner();
        // subscribe to searchKeyChange event
        registerListener('clickButton', this.handleGetTitleData, this);
        registerListener('selectedtitle', this.handleGetTitleId, this);
        //   this.spinner();
        // this.titleMes = true;
    }

    handleGetTitleId(titleId) { // it shows message in jumbotron
        // alert('handle get titleid');
        if (titleId)
            this.titleId = titleId;

        let dataWrap = titleId
        console.log(dataWrap);

        this.buttonname = dataWrap.page;
        this.transmittal = false;
        console.log(this.buttonname);
        debugger;
        if (this.buttonname) {
            try {
                if (this.title)
                    this.titleMes = true;
                if (this.buttonname == 'Transmittal') {
                    this.transmittal = true;
                    this.cb = false;
                    this.chinook = false;
                    this.title = dataWrap;
                    setTimeout(() => {
                        this.template.querySelector("c-ppw_transmittal-component").getTransmittalRecords();
                    }, 100);

                }
                if (this.buttonname == 'Chinook') {
                    console.log(this.buttonname);
                    this.transmittal = false;
                    this.cb = false;
                    this.chinook = true;
                    this.title = dataWrap;

                    setTimeout(() => {
                        this.template.querySelector("c-esp-component").getChinookRecords();
                    }, 100);

                }

                if (this.buttonname == 'CB') {
                    this.transmittal = false;
                    this.cb = true;
                    this.chinook = false;
                    setTimeout(() => {
                        this.template.querySelector("c-creative-brief-component").getCBRecords();
                    }, 100);
                    this.title = dataWrap;

                }
                this.titleMes = false;
                setTimeout(() => {
                    this.spinnerDi();
                }, 500);

            } catch (e) {
                console.log(e);
                this.spinnerDi();
            }
        } else {

            this.cb = false;
            this.chinook = false;
            this.transmittal = false;
            this.titleMes = true;

        }


    }
    renderedCallback() {
        this.spinnerDi();
    }
    disconnectedCallback() {
        // unsubscribe from searchKeyChange event
        // unregisterAllListeners(this);
    }

    spinnerEn() {
        // console.log()
        var spn = this.template.querySelector('[data-id="spinner"]');
        console.log(spn.classList);
        if (spn)
            spn.classList.remove('slds-hide');

    }

    spinnerDi() {
        var spn = this.template.querySelector('[data-id="spinner"]');
        console.log(spn.classList);
        if (spn)
            spn.classList.add('slds-hide');

    }


    handleGetTitleData(dataWrap) {
        //  if(this.isConnected)
        this.spinnerEn();
        // alert(dataWrap);
        if (dataWrap) {
            console.log(dataWrap);

            this.buttonname = dataWrap.btnName;
            this.transmittal = false;
            console.log(this.buttonname);
            try {
                if (this.title)
                    this.titleMes = true;
                if (this.buttonname == 'Transmittal') {
                    this.transmittal = true;
                    this.cb = false;
                    this.chinook = false;
                    this.title = dataWrap;
                    setTimeout(() => {
                        this.template.querySelector("c-ppw_transmittal-component").getTransmittalRecords();

                    }, 100);

                }
                if (this.buttonname == 'Chinook') {
                    console.log(this.buttonname);
                    this.transmittal = false;
                    this.cb = false;
                    this.chinook = true;
                    this.title = dataWrap;

                    setTimeout(() => {
                        this.template.querySelector("c-esp-component").getChinookRecords();

                    }, 100);

                }

                if (this.buttonname == 'CB') {
                    this.transmittal = false;
                    this.cb = true;
                    this.chinook = false;
                    setTimeout(() => {
                        this.template.querySelector("c-creative-brief-component").getCBRecords();

                    }, 100);
                    this.title = dataWrap;

                }
                this.titleMes = false;


            } catch (e) { console.log(e); }
        }

    }
}