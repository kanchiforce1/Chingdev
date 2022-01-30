import { LightningElement,api } from 'lwc';

export default class CustomHelpText extends LightningElement {
@api text;
@api iconName;
@api styleClass;
@api varient;

handleOnClick() {
    const divHelp = this.template.querySelector('[data-id="divHelp"]');
    divHelp.classList.toggle('slds-hide');
    //$A.util.toggleClass(component.find("divHelp"), 'slds-hide');
  }
  handleMouseLeave() {
    const divHelp = this.template.querySelector('[data-id="divHelp"]');
    divHelp.classList.add('slds-hide');

    //$A.util.addClass(component.find("divHelp"), 'slds-hide');
  }
  handleMouseEnter() {
    const divHelp = this.template.querySelector('[data-id="divHelp"]');
    divHelp.classList.remove('slds-hide');

   // $A.util.removeClass(component.find("divHelp"), 'slds-hide');
  }
}