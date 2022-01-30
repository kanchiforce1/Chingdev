import { LightningElement , api , track} from 'lwc';

export default class Ppw_transmittalConfHistoryData extends LightningElement {

    @api c;
    @api rushFeeFlg;
    badgeClass;badgeHelpText;badgeHelpText;badgeHelpText1;

    connectedCallback() {
        if(this.c) {
            this.badgeHelpText = (this.c.confirmation__c == 'No'? this.c.rejection_reason__c : (this.c.status__c == 'Review Requested'? this.c.Reason_for_Review__c : ''));

            this.badgeHelpText1 = (this.c.status__c == 'Open'? this.c.status__c :
            (this.c.status__c =='Confirmed' && this.c.confirmation__c =='Yes')? 'Accepted' : 
            ((this.c.status__c == 'Review Requested' && this.c.confirmation__c =='Yes')? 'Review Requested' : 
            ((this.c.status__c == 'Confirmed' && this.c.confirmation__c == 'No')? 'Rejected':
            (this.c.status__c == 'Internal Closed'? 'Internal Closed' : ''))));

            this.badgeClass = 'badge ' + (this.c.status__c =='Open'? 'badge-primary' : ((this.c.status__c == 'Confirmed' && this.c.confirmation__c == 'Yes')? 'badge-success' : ((this.c.status__c == 'Review Requested' && this.c.confirmation__c =='Yes')? 'badge-info' : ((this.c.status__c == 'Confirmed' && this.c.confirmation__c == 'No')? 'badge-danger' : (this.c.status__c == 'Internal Closed'? 'badge-secondary' :'')))));
        }
    }
}