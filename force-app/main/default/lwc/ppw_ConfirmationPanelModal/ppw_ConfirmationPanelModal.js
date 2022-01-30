import { LightningElement , api} from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import createConfirmation from '@salesforce/apex/ppw_projectControllerExtension_lwc.createConfirmation';
import internalCloseConfirmation from '@salesforce/apex/ppw_projectControllerExtension_lwc.internalCloseConfirmation';
import getAllConfirmation from '@salesforce/apex/ppw_projectControllerExtension_lwc.getAllConfirmation';

export default class Ppw_ConfirmationPanelModal extends LightningElement {
    @api project;
    @api projectService;
    savebtnLabel;savebtnIcon;cancelIcon;
    allConfirmations=[];emptynewConfirmation;newConfirmation;
    closeconfirm=false;spinner;

    closeCreatePsModal() {
        var selectedEvent = new CustomEvent('closecreatepsmodal', { });
        this.dispatchEvent(selectedEvent);
    }

    connectedCallback() {
       this.spinnerShow();
        console.log('projectService'+ this.projectService);
        getAllConfirmation({psRec: this.projectService.Id})
        .then((data) => {
            if(data) {
                if(data.length>0) {
                    this.emptynewConfirmation = false;
            console.log(data);
           // this.allConfirmations = data;
            let sBasedCon = [];
            for(let i in data)
            if(data[i]) {
                let c = data[i];
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
                
                sb.cancelIcon = sb.badgeHelpText1 =='Open'? true: false;
                sb.badgeClass = 'slds-badge fillred ' + (c.Status__c =='Open'? 'slds-badge_lightest sOpen' : ((c.Status__c == 'Confirmed' && c.Confirmation__c == 'Yes')? 'slds-theme_success' : ((c.Status__c == 'Review Requested' && c.Confirmation__c =='Yes')?
                                             'slds-badge_lightest sReviewRequest' : ((c.Status__c == 'Confirmed' && c.Confirmation__c == 'No')? 'slds-theme_error' : (c.Status__c == 'Internal Closed'? 'slds-slds-badge_inverse' :'')))));
                sBasedCon.push(sb);
            }
            this.allConfirmations = sBasedCon;
           console.log('test' +JSON.stringify(this.allConfirmations));
         } else this.emptynewConfirmation = true;
        } else 
            this.emptynewConfirmation = true;
        
            this.spinnerHide();
        })
    }
    
    spinnerShow() {
        this.spinner = true;
    }
    spinnerHide() {
        this.spinner = false;
    }
    closeconfirmation(e) {
        this.spinnerShow();
        var id = e.currentTarget.dataset.name;
        this.closeconfirm = true;
        internalCloseConfirmation({thisProjectService: this.projectService, internalCloseID: id})
        .then((data) => {
           
            this.connectedCallback();
            this.spinnerHide();
            this.showNotification('Success!','Confirmation Closed Successfully', 'success');
            this.getrefreshpanels();
        });
    }
    onnewOpen() {
        setTimeout(() => {

            this.template.querySelector('[data-id="rejectMenu"]').classList.toggle('slds-is-open');// slds-is-open
        }, 150);

    }

    hideDropDown1() {
        let rejectMenu = this.template.querySelector('[data-id="rejectMenu"]');
        if (rejectMenu)
            rejectMenu.classList.remove('slds-is-open');// slds-is-open
            this.template.querySelector('[data-id="createIn"]').value = '';
    }
    getrefreshpanels() {
        console.log('get refreshconfirmapanel')
        var selectedEvent = new CustomEvent('getrefreshpanels', { });
        this.dispatchEvent(selectedEvent);
    }
    hideDropDown(event) {
        console.log('hide');
      
       if(event)
         if (!event.target.name) {
           this.hideDropDown1();
         }
    }

    opennewConfirmation() {
        this.spinnerShow();
        var comments = this.template.querySelector('[data-id="createIn"]').value;
        this.hideDropDown1();
        createConfirmation({ps: this.projectService, ConfirmationText: comments})
        .then((data) => {
            this.getrefreshpanels();
            this.connectedCallback();
            this.spinnerHide();
            this.showNotification('Success!','Confirmation Created Successfully', 'success');
        });
    }


    showNotification(t, m, v) {
        const evt = new ShowToastEvent({
            title: t,
            message: m,
            variant: v,
        });
        this.dispatchEvent(evt);
    }
      // accordian toggle
      accordianToggle(e) {
        
         if(!this.closeconfirm) {
                var id = e.currentTarget.dataset.name;
                console.log('idd'+ id);
                
                this.template.querySelector('[data-id="'+ id + '"]').classList.toggle('slds-hide');
          }
          this.closeconfirm = false;
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