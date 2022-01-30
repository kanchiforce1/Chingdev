import { LightningElement , api, wire} from 'lwc';
import PPW_koTitleStatus from '@salesforce/label/c.PPW_koTitleStatus';
import PPW_Force_Kickoff_Users from '@salesforce/label/c.PPW_Force_Kickoff_Users';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import kickOffService from '@salesforce/apex/ppw_projectControllerExtension_lwc.kickOffService';
import forceKickOffService from '@salesforce/apex/ppw_projectControllerExtension_lwc.forceKickOffService';

import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import FederationIdentifier from '@salesforce/schema/User.FederationIdentifier';


export default class Ppw_KickOffModal extends LightningElement {
    @api project;
    @api projectService;
    @api series;
    savebtnLabel;savebtnIcon;titleStatus;isStatusScheduled;isForceKickoff;isContractedScheduled=true;
    userFederationIdentifier;spinner;
    
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [FederationIdentifier]
    }) wireuser({
        error,
        data
        }) {
            console.log(JSON.stringify(data));
            if (data) 
                this.userFederationIdentifier = data.fields.FederationIdentifier.displayValue;
            }
    
    connectedCallback() {
        console.log(JSON.stringify(this.projectService));
        console.log(JSON.stringify(this.series));
        if (this.projectService) {
            if (this.series) {
                if (this.projectService.Status__c == 'Scheduled') {
                this.isStatusScheduled = true;
                this.titleStatus = true;
                this.isForceKickoff =  PPW_Force_Kickoff_Users.includes(this.userFederationIdentifier);
                this.isContractedScheduled = !(this.titleStatus && this.isStatusScheduled);
                }

            }
            if (this.projectService.Project__r.Title__r) {
                if (PPW_koTitleStatus.includes(this.projectService.Project__r.Title__r.Status__c))
                    this.titleStatus = true;
                if (this.projectService.Status__c == 'Scheduled')
                    this.isStatusScheduled = true;
                //censharekickOffPS != true,
                this.isForceKickoff = ((this.projectService.Project__r.Title__r.Status__c != 'Contracted' || this.projectService.Status__c != 'Scheduled') &&
                    PPW_Force_Kickoff_Users.includes(this.userFederationIdentifier));
                this.isContractedScheduled = !(this.titleStatus && this.isStatusScheduled);
            }
        
    }
    
    }
    
    onnewOpen() {
        setTimeout(() => {

            this.template.querySelector('[data-id="forceKickoff"]').classList.toggle('slds-is-open');// slds-is-open
        }, 150);

    }

    hideDropDown1() {
        let rejectMenu = this.template.querySelector('[data-id="forceKickoff"]');
        if (rejectMenu)
            rejectMenu.classList.remove('slds-is-open');// slds-is-open
            this.template.querySelector('[data-id="createIn"]').value = '';
    }

    forceKickedOff() {
        this.spinner = false;
        var comments = this.template.querySelector('[data-id="createIn"]').value;
        this.hideDropDown1();
       forceKickOffService({x: this.projectService, forceKickOffReason: comments})
        .then((data) => {
            this.renderKickedOff();
        });
    }

    hideDropDown(event) {
        console.log('hide');
      
       if(event)
         if (!event.target.name) {
           this.hideDropDown1();
         }
    }
    renderedCallback() {
        this.savebtnLabel = this.projectService? 'Kick Off' : 'Kick Off';
        this.savebtnIcon = this.projectService? '' : 'utility:setup_assistant_guide';
    }

    kickOffServiceFun() {
        this.spinner = true;
      //  alert('kickOffServiceFun');
        kickOffService({x: this.projectService})
        .then((data) => {
            if(data) {
                if(data.psRec) {
                    this.projectService = data.psRec;
                    this.renderKickedOff();
                }
            }});
    }

    renderKickedOff() {
        this.connectedCallback();
        this.getrefreshpanels();
        this.showNotification('Success!','Project Service has been Kicked Off Successfully', 'success');
        let force = this.template.querySelector('[data-id="force"]');
        force.disabled= true;
        let kickoff = this.template.querySelector('[data-id="kickoff"]');
        kickoff.disabled= true;
        this.spinner = false;
    }

    getrefreshpanels() {
        var selectedEvent = new CustomEvent('getrefreshpanels', { });
        this.dispatchEvent(selectedEvent);
    }

    closeCreatePsModal() {
        var selectedEvent = new CustomEvent('closecreatepsmodal', { });
        this.dispatchEvent(selectedEvent);
    }
    showNotification(t, m, v) {
        const evt = new ShowToastEvent({
            title: t,
            message: m,
            variant: v,
        });
        this.dispatchEvent(evt);
    }
}