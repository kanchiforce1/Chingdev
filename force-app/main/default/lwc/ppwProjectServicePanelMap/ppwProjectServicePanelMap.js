import { LightningElement, api ,track, wire } from 'lwc';
//import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import resetChatterCountInternal from '@salesforce/apex/PPW_transmittalController_lwc.resetChatterCountInternal';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled }  from 'lightning/empApi';
import uId from '@salesforce/user/Id';
import { createMessageContext, releaseMessageContext,
    publish } from 'lightning/messageService';
import SAMPLEMC from "@salesforce/messageChannel/communityMessageChannel__c";
export default class PpwProjectServicePanelMap extends NavigationMixin(LightningElement) {
@api key;
@api cmap;
serviceName;
@api series;
@track projectServices = [];
onselectPsName;psMap={};
isCreatePsModal;
project;
@api bundleSerivcesMap;
isConfirmationModal;
isKickOffModal;isCancelModal;closeconfirm;
@api tabName;
@api isSystemAdmin;
@api projectService;
@api serviceActionType;
notifyCount;
@track channelName = '/event/User_Message__e';

subscription = {};


    // Handles unsubscribe button click
    handleUnsubscribe() {
        this.toggleSubscribeButton(false);

        // Invoke unsubscribe method of empApi
        unsubscribe(this.subscription, response => {
            console.log('unsubscribe() response: ', JSON.stringify(response));
            // Response is true for successful unsubscribe
        });
    }

   


context = createMessageContext();

@api getrefreshpanels() {
    console.log('get refresh panel');
    var selectedEvent = new CustomEvent('getrefreshpanels', { });
    this.dispatchEvent(selectedEvent);
}

resetCatterCount(psId) {
    resetChatterCountInternal({psId: psId}).then((data)=> {

    }).catch((error)=> {

    });
}

 // Handles subscribe button click
 handleSubscribe() {
     let self = this;
    //console.log(uId);
    // Callback invoked whenever a new event message is received
    const messageCallback = function(response) {
        console.log('New message received : ', JSON.stringify(response));
        console.log(uId);
        let psid = response.data.payload.Project_ServiceId__c;
        let loggedInUserid = response.data.payload.CreatedById;
        var psmap = self.cmap;
        var pss = [];
   
        for(var a in psmap) {
           let ps = [];
          
           for(var b in psmap[a]) {
               if(!psmap[a][b].ps.Bundled_Container__r) {
                   console.log(JSON.stringify(psmap[a][b].ps.Id == psid));
                   if(psmap[a][b].ps.Id == psid && uId != loggedInUserid)
                        psmap[a][b].ps.Chatter_Count_Internal__c = psmap[a][b].ps.Chatter_Count_Internal__c? psmap[a][b].ps.Chatter_Count_Internal__c+1: 1;

                   ps.push(psmap[a][b]);
                   pss.push({key: a, value: {  ps: ps}});
               }
           }
       }    
       console.log('this.projectServices'+ JSON.stringify(pss));
       self.projectServices = pss;  


        // Response contains the payload of the new message received
    };
   // thisReference.dispatchEvent(evt);
    // Invoke subscribe method of empApi. Pass reference to messageCallback
    subscribe(this.channelName, -1, messageCallback).then(response => {
        // Response contains the subscription information on successful subscribe call
        console.log('Successfully subscribed to : ', JSON.stringify(response.channel));
        this.subscription = response;
       // this.toggleSubscribeButton(true);
    });
}


registerErrorListener() {
    // Invoke onError empApi method
    onError(error => {
        console.log('Received error from server: ', JSON.stringify(error));
        // Error contains the server-side error
    });
}



pushNotification(e) {
    this.closeconfirm = true;
    var pId = e.target.name;
        const message = {
            recordId: pId,
        };
        publish(this.context, SAMPLEMC, message);
        var psmap = this.cmap;
        var pss = [];
        console.log('this.projectServices'+ JSON.stringify(psmap));
        for(var a in psmap) {
           let ps = [];
          
           for(var b in psmap[a]) {
               if(!psmap[a][b].ps.Bundled_Container__r) {
                   console.log(JSON.stringify(psmap[a][b].ps.Id == pId));
                   if(psmap[a][b].ps.Id == pId) {
                        psmap[a][b].ps.Chatter_Count_Internal__c = null;
                        this.resetCatterCount(pId);
                   }

                   ps.push(psmap[a][b]);
                   pss.push({key: a, value: {  ps: ps}});
               }
           }
       }    
       console.log('this.projectServices'+ JSON.stringify(pss));
       this.projectServices = pss;  
   
}

@api set cmap1(value) {
    if(value)
        this.cmap = JSON.parse(JSON.stringify(value));
        this.setcmap();
}
get cmap1() {
    return this.cmap;
}

    @api connectedCallback() {
        this.channelName = '/event/User_Message__e';
        this.handleSubscribe();
        this.registerErrorListener();   
    
    }


    setcmap() {
        console.log('keyf' +this.key);
        console.log(JSON.stringify(this.cmap));
        var pss = [];
        let bundle=[];
            let bId;
            let bname;
            let bInfo;
        var psmap = this.cmap;


        for(var a in psmap) {
           
            for(var b in psmap[a]) {
            
               if(psmap[a][b].ps.Bundled_Container__r) {
                    if(psmap[a][b].ps.Bundled_Container__r.Id) {
                        bundle.push(psmap[a][b]);
                        bId= psmap[a][b].ps.Bundled_Container__r.Id;
                        bname = psmap[a][b].ps.Bundled_Container__r.Bundled_Service_Name__c;
                    } 
                
                    
                } 
              
              
            }
        }  
        console.log(bundle);
        var badgeClass;
        if(this.bundleSerivcesMap && bId) {
            bInfo = this.bundleSerivcesMap[bId];
        
        var s = bInfo.Status__c;
      //  bInfo.isEdit =  (s =='In Planning' || s =='Scheduled' || s == 'Cancelled' || s == 'Confirming' || s == 'Kicked Off' || s =='Killed')? false : true;
      //  bInfo.isCancel = (s =='In Planning' || s =='Scheduled' || s == 'Completed' || s == 'Confirming' || s == 'Kicked Off') ? false : true;
      //  bInfo.isConfirmation = (s =='In Planning' || s =='Scheduled' || s == 'Cancelled' || s == 'Confirming' || s == 'Kicked Off' || s ==  'Completed' || s =='Killed') && 
         //                               (bInfo.Vendor__c && bInfo.Service__c && bInfo.Service_Type_Complexity__c)? false : true;
         //                               bInfo.isKickedoff = (s =='Scheduled')? false : true;
          //                              bInfo.isTransimittalForm = ( s =='Scheduled' || s == 'Kicked Off' || s == 'Confirming'|| s == 'Completed')? false : true;
     
        badgeClass = 'slds-badge ' + 
        (bInfo.Status__c =='In Planning'? '' : 
                    ((bInfo.Status__c == 'Completed' )? 'slds-theme_success' : 
                    ((bInfo.Status__c == 'Killed' )? 'slds-theme_error' : 
                    ((bInfo.Status__c == 'Cancelled'? 'slds-theme_error' :'')))));
                    badgeClass = badgeClass;
    }
                    





        if(bundle.length>0) 
            pss.push({ value: { isbundle: true, bId:bId, badgeClass: badgeClass,  bInfo: bInfo, bname: bname,  bundle: bundle}});
        


        for(var a in psmap) {
            let ps = [];
           
            for(var b in psmap[a]) {
                if(!psmap[a][b].ps.Bundled_Container__r) {
                    ps.push(psmap[a][b]);
            
                    pss.push({key: a, value: {  ps: ps}});
                }
            }
        }    
        console.log('this.projectServices'+ JSON.stringify(pss));
        this.projectServices = pss;   
    
        if (this.tabName == 'Active')
            this.isEdit = false;
        if (this.tabName == 'Completed')
            this.isCompleted = true;
        if (this.tabName == 'Cancelled')
            this.isCancelled = true;
    }

    btnmenu() {
        console.log('btnmenu');
        this.closeconfirm = true;
    }
     // accordian toggle
     accordianToggle(e) {
        var id = e.currentTarget.dataset.name;
       
        if(!this.closeconfirm) {
            this.cardcollapsable(id)
              
         }
         this.closeconfirm = false;
   }

   cardcollapsable(id) {
        this.template.querySelector('[data-value="'+ id + '"]').classList.toggle('slds-hide');
   }

    onbuttAction(e) { 
    
        var btnLabel = e.target.label;
        this.project = e.target.name.Project__r;
        var ps = e.target.name;
     
        this.projectService = e.target.name; //isCancelModal
        if(btnLabel == 'Edit Service')
            this.isCreatePsModal = true;
        if(btnLabel == 'Kick Off Service')
            this.isKickOffModal = true
        if(btnLabel == 'Confirmations Panel')
            this.isConfirmationModal = true;
        if(btnLabel == 'Cancel Service')
            this.isCancelModal = true;
        if(btnLabel == 'Transmittal form') 
            this.handleNavigate(ps);
        if(btnLabel == 'Transmittal form')
            this.pushNotification(ps); 
     
}


    disconnectedCallback() {
        //releaseMessageContext(this.context);
    }
    

    handleNavigate(ps) {
        var state = {};
        if(this.series)
        state.c__seriesid=this.series.Wombat_Series_ID__c;
        if(this.project.Title__r)
        state.c__martyid= this.project.Title__r.Marty_Title_ID__c;
        state.c__vendor=ps.Vendor__r? ps.Vendor__r.Id: ''
        this[NavigationMixin.GenerateUrl]({
     
                type: 'standard__navItemPage',
                attributes: {
                    apiName: 'PPW_Transmittal_Page',
                }, 
                state: state
        
    }).then(url => {
           
        window.open(url, "_blank");
   });

    }
psDetails(e) {
  
        var pId = e.target.name;
       // Generate a URL to a User record page
       this[NavigationMixin.GenerateUrl]({
           type: 'standard__recordPage',
           attributes: {
               recordId: pId,
               actionName: 'view',
           },
       }).then(url => {
        if(this.isSystemAdmin)
            window.open(url, "_blank");
       });
    
}

@api closeCreatePsModal() {
    console.log('close create ps modal')
    this.isCreatePsModal = false;
    this.isKickOffModal = false;
    this.isConfirmationModal = false;
    this.isCancelModal = false;
    this.project = {}
}

}