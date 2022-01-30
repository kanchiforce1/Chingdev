import { LightningElement, api, wire , track} from 'lwc';
import PPW_vmKillService from '@salesforce/label/c.PPW_vmKillService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_RoleId from '@salesforce/schema/User.UserRole.Name';
import cancelService from '@salesforce/apex/ppw_projectControllerExtension_lwc.cancelService';
import censhareCalloutStatus from '@salesforce/apex/ppw_projectControllerExtension_lwc.censhareCalloutStatus';
import forceKickOffService from '@salesforce/apex/ppw_projectControllerExtension_lwc.forceKickOffService';

export default class Ppw_CancelPSModal extends LightningElement {
    @api project;
    @api projectService;
    @track options = [];
    savebtnLabel;savebtnIcon;userRole;killCancelService;spinner;
    
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_RoleId]
    }) wireuser({
        error,
        data
        }) {
            console.log(JSON.stringify(data));
            if (data) 
                this.userRole = data.fields.UserRole.displayValue;
            }
   

    connectedCallback() {
        console.log(JSON.stringify(this.projectService));
       
        var opt = []
        if(this.projectService.Status__c == 'Kicked Off' && PPW_vmKillService.includes(this.userRole))
        {
           opt.push({ label: 'Cancel Service and Initiate Kill Fee', value: '3' });
           // opt.add(new SelectOption('3', 'Cancel Service and Initiate Kill Fee')); 
            this.killCancelService = true;
        }

       
        opt.push({ label: 'Cancel Service Only', value: '1' });
        opt.push({ label: 'Cancel and Create a New service', value: '2' });
        this.options = opt;
      // return opt;
    }

   async censhareCalloutStatus(censhareNewPs) {
     
        const data = await censhareCalloutStatus({ censhareNewPs: censhareNewPs });
       
                console.log('call out status' +JSON.stringify(data));
                    if(data.pollerEnabled) {
                        setTimeout(() => { 
                            this.censhareCalloutStatus(censhareNewPs);
                            
                        }, 3000);

                     } else 
                        this.btnAction();
       
    } 
    handleChange() {

    }
    cancelService(e) {
        this.spinner = true;
       // let val = e.target.value;
        let val = this.template.querySelector('[data-id="canel"]');
        console.log(val.value);
       // console.log(JSON.stringify(this.projectService));
        cancelService({x: this.projectService ,  cancelSelection: val.value})
        .then((data) => {
            console.log('cancel success');
            if(val.value == '2') {
                this.censhareStatus(data);
                //this.btnAction();
               // this.censhareCalloutStatus(this.projectService);
        } else 
                this.btnAction();
        
        });
    }
    
async censhareStatus(data) {
    return await this.censhareCalloutStatus(data.psRecord);
    
    //await this.btnAction();
}

    showNotification(t, m, v) {
        const evt = new ShowToastEvent({
            title: t,
            message: m,
            variant: v,
        });
        this.dispatchEvent(evt);
    }

  btnAction() {
        this.showNotification('Success!','Project Service Cancelled Successfully', 'success');
        let cancels = this.template.querySelector('[data-id="cancels"]');
        cancels.disabled= true;
        this.spinner = false;
        this.getrefreshpanels();
    }

    renderedCallback() {
        this.savebtnLabel = this.projectService? 'Cancel Service' : 'Cancel Service';
        this.savebtnIcon = this.projectService? '' : '';
    }
    getrefreshpanels() {
        var selectedEvent = new CustomEvent('getrefreshpanels', { });
        this.dispatchEvent(selectedEvent);
    }

    closeCreatePsModal() {
        var selectedEvent = new CustomEvent('closecreatepsmodal', { });
        this.dispatchEvent(selectedEvent);
    }

}