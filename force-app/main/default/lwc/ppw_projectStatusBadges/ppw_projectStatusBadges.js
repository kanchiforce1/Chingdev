/* eslint-disable eqeqeq */
import { LightningElement, api } from 'lwc';

export default class Ppw_projectStatusBadges extends LightningElement {

    @api confirmation;
    badgeClass; badgeTittle; badgeStatus;

    //@api
    renderedCallback() {
        this.updateUifeildsData();
    }

    connectedCallback() {
       this.updateUifeildsData();
    }

    updateUifeildsData() {
        let c = this.confirmation;
        console.log('badge render call back');
        if (c) {
            this.badgeClass = 'bslds-badge ' + c.Status__c == 'Open' ? 'badge-primary' : (c.Status__c == 'Confirmed' && c.Confirmation__c == 'Yes') ? 'badge-success' : (c.Status__c == 'Review Requested' && c.Confirmation__c == 'Yes') ? 'badge-info' : (c.Status__c == 'Confirmed' && c.Confirmation__c == 'No') ? 'badge-danger' : c.Status__c == 'Internal Closed' ? 'badge-secondary' : '';
            this.badgeTittle = c.Confirmation__c == 'No' ? c.rejection_reason__c : c.status__c == 'Review Requested' ? c.Reason_for_Review__c : '';

            this.badgeStatus = c.Status__c == 'Open' ? c.Status__c : (c.Status__c == 'Confirmed' && c.Confirmation__c == 'Yes') ? 'Accepted' : (c.Status__c == 'Review Requested' && c.Confirmation__c == 'Yes') ? 'Review Requested' : (c.Status__c == 'Confirmed' && c.Confirmation__c == 'No') ? 'Rejected' : c.Status__c == 'Internal Closed' ? 'Internal Closed' : '';
        }
    }

}