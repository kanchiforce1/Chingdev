import { LightningElement,api,wire } from 'lwc';


export default class Apub_statusPathCondition extends LightningElement {

    @api statusVal;
    @api selectedStatus;
    sameStatusVal = false;classList;

   

    connectedCallback() {
        console.log(this.statusVal);
      
        if(this.statusVal == this.selectedStatus) 
            this.classList = 'slds-path__item slds-is-current slds-is-active';
        else
            this.classList = 'slds-path__item slds-is-incomplete';
         
    }
}