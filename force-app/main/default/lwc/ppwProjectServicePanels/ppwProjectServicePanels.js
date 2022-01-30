import { LightningElement, api , wire, track} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';

import ProfileName from '@salesforce/schema/User.Profile.Name';
import ppw_censhareConnect_PSUpdate from '@salesforce/apex/ppw_projectControllerExtension_lwc.getppw_censhareConnect_PSUpdate';
import getterpsMegaMap from '@salesforce/apex/ppw_projectControllerExtension_lwc.getterpsMegaMap';
import getBundleSerivcesDetails from '@salesforce/apex/ppw_projectControllerExtension_lwc.getBundleSerivcesDetails';
export default class LightningExampleAccordionMultiple extends LightningElement {
   // activeSections = ['A', 'C'];
    activeSections = [];
    activeSectionsMessage = '';ceshareMes;ceshareAlert;
    isCommunityUser;isSystemAdmin;cautoFetchComplete;
    @api recordId;
    @api series;
    
    recordId1;
    @track aServices=[];
    cService=[];
    calServices=[];
    bundleSerivcesMap={}
    aServices1;
    cService1;
    calServices1;
    //channelName = '/event/User_Message__e';

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [ProfileName]
    }) wireuser({
        error,
        data
        }) {
           // console.log('user profile'  + JSON.stringify( data));
            if (data) 
                this.isSystemAdmin = data.fields.Profile.displayValue == 'System Administrator'? true : false;
            }

async censhareConnectUpdate() {
   
   const data = await ppw_censhareConnect_PSUpdate({
        pId: this.recordId
    });
     
        const notify = this.template.querySelector('[data-id="notify"]');
        notify.classList.toggle('slds-hide');

              if(data)  {
                notify.classList.add('slds-theme_success');
              this.ceshareMes = 'Project Service dates have been sync’d from censhare.'
              }
              else  {
                  this.ceshareMes = 'Unable to syn’c Project Service dates from censhare. Old dates may be present.'
                  notify.classList.add('slds-alert_warning');
              }
        this.cautoFetchComplete = true;
        setTimeout(function(){ 
            
            notify.classList.toggle('slds-hide');
        
        }, 6000);
   
}


hideNotify() {

}
notifyClose() {
    const notify = this.template.querySelector('[data-id="notify"]');
    notify.classList.toggle('slds-hide');
}
    @api async connectedCallback() {
        this.channelName = '/event/User_Message__e';
       // this.handleSubscribe();
       // this.registerErrorListener();  

        if(!this.cautoFetchComplete) 
            await this.censhareConnectUpdate();
        console.log(this.recordId);
        this.bundleSerivcesMap = await getBundleSerivcesDetails({projectId: this.recordId});
        getterpsMegaMap({ projectId :  this.recordId?  this.recordId : '' })
         .then((data) => {
             if(data) {
                console.log('data');
                 var activeServicesMap = [];
                 var aServices=[];
                 var cService=[];
                 var calServices=[];
                 for(var a in data) {
                    for(var b in data[a]) {
                      
                        for(var c in data[a][b]) 
                                data[a][b][c] = this.getStatusBadge(data[a][b][c]);
                   }
                            
                     if(a == 'Active') 
                        for(var b in data[a]) 
                            aServices.push({key: b, value: data[a][b]});
                      
                        if(a == 'Completed') 
                            for(var b in data[a]) 
                                cService.push({key: b, value: data[a][b]});
        
                        if(a == 'Cancelled') 
                            for(var b in data[a]) 
                                calServices.push({key: b, value: data[a][b]});

                        
                 }
            
               var serq = this.template.querySelectorAll('c-ppw-project-service-panel-map');
          
                if(serq.length>0) {
                   const as = JSON.parse(JSON.stringify(aServices));
                   const cs = JSON.parse(JSON.stringify(cService));
                   const  cas = JSON.parse(JSON.stringify(calServices));
               
                    this.aServices = as;
                    this.cService = cs;
                    this.calServices = cas;
                } else {
                    this.aServices = aServices;
                    this.cService = cService;
                    this.calServices = calServices;
                }
         
                console.log('data');
                
             }
         
         }).catch((e) => { console.log(e.message);});
     }

     setPushNotify(psId) {
       

     }

     set aServices(value) {
        this.aServices = [...value];
    }

     getStatusBadge(psitem) {
     
            var psdata = []
            for(var a in psitem) {
                var s = psitem[a].ps.Status__c;
                psitem[a].ps.isEdit =  (s =='In Planning' || s =='Scheduled' || s == 'Cancelled' || s == 'Confirming' || s == 'Kicked Off' || s =='Killed')? false : true;
                psitem[a].ps.isCancel = (s =='In Planning' || s =='Scheduled' || s == 'Completed' || s == 'Confirming' || s == 'Kicked Off') ? false : true;
                psitem[a].ps.isConfirmation = (s =='In Planning' || s =='Scheduled' || s == 'Cancelled' || s == 'Confirming' || s == 'Kicked Off' || s ==  'Completed' || s =='Killed') && 
                                                (psitem[a].ps.Vendor__c && psitem[a].ps.Service__c && psitem[a].ps.Service_Type_Complexity__c)? false : true;
                psitem[a].ps.isKickedoff = (s =='Scheduled')? false : true;
                psitem[a].ps.isTransimittalForm = ( s =='Scheduled' || s == 'Kicked Off' || s == 'Confirming'|| s == 'Completed')? false : true;
             
                var badgeClass = 'slds-badge ' + 
                (psitem[a].ps.Status__c =='In Planning'? '' : 
                            ((psitem[a].ps.Status__c == 'Completed' )? 'slds-theme_success' : 
                            ((psitem[a].ps.Status__c == 'Killed' )? 'slds-theme_error' : 
                            ((psitem[a].ps.Status__c == 'Cancelled'? 'slds-theme_error' :'')))));
                            psitem[a].ps.badgeClass = badgeClass;
                            psdata.push(psitem[a]);
                 
            }
         
        
        return psdata;
    }
     @api renderUpdatedPs() {
      
         this.connectedCallback();
     }


}