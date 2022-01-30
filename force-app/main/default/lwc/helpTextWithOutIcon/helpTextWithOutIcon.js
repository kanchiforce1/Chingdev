import { LightningElement,api } from 'lwc';

export default class HelpTextWithOutIcon extends LightningElement {
@api text;
@api isDisplay;
@api varient;


  handleMouseLeave() {
    const divHelp = this.template.querySelector('[data-id="divHelp"]');
   // divHelp.classList.add('slds-hide');

    //$A.util.addClass(component.find("divHelp"), 'slds-hide');
  }
  handleMouseEnter() {
    const divHelp = this.template.querySelector('[data-id="divHelp"]');
    divHelp.classList.remove('slds-hide');

   // $A.util.removeClass(component.find("divHelp"), 'slds-hide');
  }
}