import { LightningElement,track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import uId from '@salesforce/user/Id';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled }  from 'lightning/empApi';
import { createMessageContext, releaseMessageContext,publish } from 'lightning/messageService';
import SAMPLEMC from "@salesforce/messageChannel/communityMessageChannel__c";
import resetChatterCountInternal from '@salesforce/apex/ppw_projectControllerExtension_lwc.resetChatterCountInternal';
import PPW_PCIReportLink from '@salesforce/label/c.PPW_PCIReportLink';
import PPW_ATSHReportLink from '@salesforce/label/c.PPW_ATSHReportLink';
import PPW_APReportLink from '@salesforce/label/c.PPW_APReportLink';
import PPW_REMReportLink from '@salesforce/label/c.PPW_REMReportLink';
import viewInCenshare from '@salesforce/label/c.View_in_Censhare';


export default class ModalPopupLWC extends NavigationMixin(LightningElement) {
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    isCreatePsModal = false;isCB;
    chatterCount;
    @api project;
    @api series;
    @api recordId;spinner = true;
    lastModifiedDate;LastModifiedBy;isServicePrep;
    @api title;
    isBundledService=false;
    //navPage = 'http://salesforce.com';
    spinnertext;
    isBulkAction;
    projectnotifyCount;
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

    // Handles subscribe button click
 handleSubscribe() {
    let self = this;
    
   // Callback invoked whenever a new event message is received
   const messageCallback = function(response) {
       console.log('New message received : ', JSON.stringify(response));
       let pid = response.data.payload.Project_ServiceId__c;
       let loggedInUserid = response.data.payload.CreatedById;
       console.log(self.recordId);
       console.log(pid);
       console.log(uId);
       console.log(loggedInUserid);
       console.log(self.projectnotifyCount);
       console.log(self.chatterCount);
       if (pid == self.recordId && uId != loggedInUserid) {
            self.projectnotifyCount= self.projectnotifyCount? (self.projectnotifyCount +1) : (self.chatterCount +1);


       }
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
    this.chatterCount = 0;
    resetChatterCountInternal({ pId :  this.recordId})
    .then((data) => {
      
    }).catch((error) => { });
   // var pId = e.target.name;
        const message = {
            recordId: this.recordId,
        };
        publish(this.context, SAMPLEMC, message);
         this.projectnotifyCount = null;
   
}


    connectedCallback() {
        this.projectnotifyCount = this.project.Chatter_Count_Internal__c;
        this.chatterCount = this.project.Chatter_Count_Internal__c;
        this.handleSubscribe();
        this.registerErrorListener();  
        console.log(this.recordId);
        console.log('project' + JSON.stringify(this.project));
        console.log('project' + JSON.stringify(this.title));
    
    }

    renderedCallback() {
      


    }
    report(e) {
        let l = e.target.label;
        if(l == 'Project Cost Information')
           this.navigationToReport( PPW_PCIReportLink, this.project.Name);
           
           if(l == 'Author Title & Series History')
           this.navigationToReport( PPW_ATSHReportLink, this.project.Title__r.Author__c);
   
           if(l == 'Author Preferences')
              this.navigationToReport( PPW_APReportLink, this.project.Title__r.Author__c);
   
           if(l == 'Related ESP Metrics')
              this.navigationToReport( PPW_REMReportLink, this.project.Title__r.Author__c);
    }
      
    navigationToReport(r,f) {
    this[NavigationMixin.GenerateUrl]({
        type: 'standard__recordPage',
        attributes: {
            recordId: r,
            objectApiName: 'Report',
            actionName: 'view'
        },
        state: {
            fv0: f
        }
    }).then(url => {
           
        window.open(url, "_blank");
   });
}
    

nagivateToCBPage() {
   
    var t = this.title;
    console.log(JSON.stringify(t.Creative_Briefs__r));
    if(t.Creative_Briefs__r) {
    let cbid = t.Creative_Briefs__r? t.Creative_Briefs__r[0].Id: '';
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__webPage',
                attributes: {
                    url: '/apex/cb_view?id=' + cbid
                }
            }).then(generatedUrl => {
                window.open(generatedUrl);
            });
        }
      
   }


    nagivateToPage() {
   
     var url = viewInCenshare + this.project.Censhare_Project_ID__c;
     console.log(url);
           window.open(String(url) , "_blank");
       
    }


    serPrepmodifiedDate(e) {


    }

  
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    openCreatePsModal(e) {
        // to open modal set isModalOpen tarck value as true
        const label = e.target.label;
        if(label == 'Transmittal Form')
            this.handleNavigate();
        else  this.isCreatePsModal = true;
    }


    handleNavigate(ps) {
        var state = {};
        if(this.series)
            state.c__seriesid=this.series.Wombat_Series_ID__c;
        if(this.project.Title__r)
            state.c__martyid= this.project.Title__r.Marty_Title_ID__c;
            state.c__vendor='';
        this[NavigationMixin.GenerateUrl]({
            

           // this[NavigationMixin.Navigate]({
                type: 'standard__navItemPage',
                attributes: {
                    apiName: 'PPW_Test_TF',
                }, 
                
                state:state


    }).then(url => {
           
        window.open(url, "_blank");
   });


    }



    @api closeCreatePsModal() {
        // to open modal set isModalOpen tarck value as true
        this.isCreatePsModal = false;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }

    bulkAction() {
        this.isBulkAction = true;
       
     }

     openBundleModal() {
         this.isBundledService = true;
       
     }

    censhareloadingCss() {
        const style = document.createElement('style');
        style.innerText = ` lightning-spinner::after{
          
            content: 'Please wait while loading';
          
         }`;
        
       const sp = this.template.querySelector('[data-id="spinner"]')
       if(sp) 
        sp.appendChild(style);
    }

    loadingCss() {

    }

     @api closebulkAction() {
        this.isBulkAction = false;
        this.isBundledService = false;
     }

    showmore() {
        let showmore = this.template.querySelector('[data-id="showmore-results"]');
       showmore.classList.toggle('slds-hide')
    }

    @api getrefreshpanels() {
        var selectedEvent = new CustomEvent('getrefreshpanels', { });
        this.dispatchEvent(selectedEvent);
    }
    spinner1(e) {
        const d = e.detail;
        this.spinner = d.display;
       // let spinner = this.template.querySelector('[data-id="spinner"]');
        this.censhareloadingCss();
        //if(spinner)
           // spinner.classList.add(d.class);
        this.lastModifiedDate = d.slastmodifiedDate;
        this.LastModifiedBy = d.slastmodifiedBy;

       // alert(details);
    }
}