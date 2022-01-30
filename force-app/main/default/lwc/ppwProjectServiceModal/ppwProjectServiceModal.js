import { LightningElement, api } from 'lwc';

export default class PpwProjectServiceModal extends LightningElement {
@api project;
@api projectService;
savebtnLabel;savebtnIcon;modalHeader;
@api spinner;
@api series;
@api serviceActionType;//="edit"
isEdit;


@api connectedCallback() {
   this.isEdit = this.serviceActionType =='edit' ? true: false;
   this.modalHeader =  this.serviceActionType =='edit' ? 'Editing: ' + this.projectService.Service_Type_Complexity__c : 'Create a New Service';
}

renderedCallback() {
    this.savebtnLabel = this.projectService? 'Save' : 'Create Service';
    this.savebtnIcon = this.projectService? '' : '';
  //  this.spinner = false;
}

onSave() {
    this.spinner=true;
    var serq = this.template.querySelector('c-ppw_create-projectservice');
   var res = serq.saveForm();  //}).then(() => {
  
}
@api spiner(e) {
    var d = e.detail.d;
    console.log('spinner' +d);
    this.spinner = d;
}
getrefreshpanels1() {
    var selectedEvent = new CustomEvent('getrefreshpanels', { });
    this.dispatchEvent(selectedEvent);
}

@api btnActionResponse(e) {
    var disabled = e.detail? e.detail.btn == 'edit'? false: true: true;
    let s1 = this.template.querySelector('[data-id="savebtn"]');
    s1.disabled = disabled;
    this.getrefreshpanels1();
    this.spinner = false;
  
}

censhareloadingCss() {
    const style = document.createElement('style');
    style.innerText = ` lightning-spinner::after{
      
        content: 'Please wait while loading';
      
     }`;
    
    //this.template.querySelector('[data-id="spinner"]').appendChild(style);
}
closeCreatePsModal() {
    var selectedEvent = new CustomEvent('closecreatepsmodal', { });
    this.dispatchEvent(selectedEvent);
}
}