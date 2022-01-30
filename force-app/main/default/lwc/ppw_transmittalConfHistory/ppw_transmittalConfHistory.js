import { LightningElement ,api, track} from 'lwc';

export default class Ppw_transmittalConfHistory extends LightningElement {
    @api sName;
    @api serviceBasedCon;
    @api serviceBasedConfirmation;
    @api confirmationTblHeaders;
    @api serviceBasedConfirmationMap;
    @api rushFeeFlg;
    sBaseCon;serviceBasedConfData;badgeClass;serviceBasedConfData1;
    connectedCallback() {
        console.log(this.serviceBasedCon);
        if(this.serviceBasedCon) {
           
            this.sBaseCon = this.serviceBasedCon[this.sName] && this.serviceBasedConfirmation;
            this.serviceBasedConfData = this.serviceBasedConfirmationMap[this.sName];
            let sBasedCon = [];
            for(let i in this.serviceBasedConfData)
            if(this.serviceBasedConfData[i]) {
                let c = this.serviceBasedConfData[i];
               // console.log('cc$$'+ c);
                let sb = {}
                sb.badgeHelpText = (c.Confirmation__c == 'No'? c.Rejection_Reason__c : 
                (c.Status__c == 'Review Requested'? c.Reason_for_Review__c : 
                (c.Status__c=='Open' ? c.open_confirmation__c : null)));
                sb.c = c;
                sb.badgeHelpText1 = (c.Status__c == 'Open'? c.Status__c :
                (c.Status__c =='Confirmed' && c.Confirmation__c =='Yes')? 'Accepted' : 
                ((c.Status__c == 'Review Requested' && c.Confirmation__c =='Yes')? 'Review Requested' : 
                ((c.Status__c == 'Confirmed' && c.Confirmation__c == 'No')? 'Rejected':
                (c.Status__c == 'Internal Closed'? 'Internal Closed' : ''))));
    
                sb.badgeClass = 'slds-badge slds-float--right slds-no-flex ' + (c.Status__c =='Open'? 'slds-badge_lightest sOpen' : ((c.Status__c == 'Confirmed' && c.Confirmation__c == 'Yes')? 'slds-theme_success' : ((c.Status__c == 'Review Requested' && c.Confirmation__c =='Yes')?
                                             'slds-badge_lightest sReviewRequest' : ((c.Status__c == 'Confirmed' && c.Confirmation__c == 'No')? 'slds-theme_error' : (c.Status__c == 'Internal Closed'? 'slds-slds-badge_inverse' :'')))));
                sBasedCon.push(sb);
            }
            this.serviceBasedConfData1 = sBasedCon;
            console.log('serviceBasedConfData1'+ JSON.stringify(this.serviceBasedConfData1));
        }
    }
    @api
    getServiceBasedConfirmation() {
        console.log('confi');
        console.log(this.serviceBasedCon);
    }

    // accordian toggle
    accordianToggle(e) {
        var id = e.currentTarget.dataset.name;
        console.log('idd'+ id);
        this.template.querySelector('[data-id="'+ id + '"]').classList.toggle('slds-hide');
    }
   // this.template.querySelector('[data-id="closeModal1"]').classList.add('slds-box slds-box_x-small');

    onToast(e) {
    
        var id = e.currentTarget.id.split('-')[0];
        var name = e.currentTarget.dataset.name;
      
        if(name == 'status')
            this.template.querySelector('[data-id="'+ id + '"]').classList.toggle('slds-hide');// slds-is-open
        if(name == 'createddate')
            this.template.querySelector('[data-createddate="'+ id + '"]').classList.toggle('slds-hide');// slds-is-open
        if(name == 'confirmation')
            this.template.querySelector('[data-confirmation="'+ id + '"]').classList.toggle('slds-hide');// slds-is-open    
     
    }

    onToastHide(e) {
    
        var id = e.currentTarget.id.split('-')[0];
        var name = e.currentTarget.dataset.name;
       // console.log(name);
        if(name == 'status')
            this.template.querySelector('[data-id="'+ id + '"]').classList.toggle('slds-hide');// slds-is-open
        if(name == 'createddate')
            this.template.querySelector('[data-createddate="'+ id + '"]').classList.toggle('slds-hide');// slds-is-open
        if(name == 'confirmation')
            this.template.querySelector('[data-confirmation="'+ id + '"]').classList.toggle('slds-hide');// slds-is-open
    
    }
}