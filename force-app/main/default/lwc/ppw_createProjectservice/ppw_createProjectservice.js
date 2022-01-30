import { LightningElement, api, wire } from 'lwc';
import getVendors from '@salesforce/apex/ppw_projectControllerExtension_lwc.loadServiceVendorOptions';
import getRates from '@salesforce/apex/ppw_projectControllerExtension_lwc.loadRates';
import getServicetype from '@salesforce/apex/ppw_projectControllerExtension_lwc.getServicetype';
import getServices from '@salesforce/apex/ppw_projectControllerExtension_lwc.getServices';
import saveForm from '@salesforce/apex/ppw_projectControllerExtension_lwc.projectServiceHandler';
import censhareCalloutStatus from '@salesforce/apex/ppw_projectControllerExtension_lwc.censhareCalloutStatus';
//import getCalloutResponseContents from '@salesforce/apex/ppw_projectControllerExtension_lwc.getCalloutResponseContents';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_RoleId from '@salesforce/schema/User.UserRole.Name';
import addlInputRate from '@salesforce/label/c.ppw_addlInput_rateTypes';

import killServiceRolesSet from '@salesforce/label/c.PPW_vmKillService';
import amountChangeRolesSet from '@salesforce/label/c.PPW_MmKillService';
//import completedSet from '@salesforce/label/c.Project_Service_Completed_Status';
export default class Ppw_createProjectserice extends NavigationMixin(LightningElement) {
    services=[];servicesMap;serviceType=[];vendors=[];selectedService;isCustomQuote;isaddRateInput;isPsAmount;
    @api projectService;
    @api series;
    @api serviceActionType;
    newProjectService;selectedServiceId;selectedVendorId;onloadComplete=false;vendorStatus;
    selectedServiceType;selectedVendor;locale;rate;rateLabel= 'Rate ()';serviceDescription;wikiAdditionalLink;
    ;rushfee = 0.00;multiplierSet;psAmount;rateAmountMultiplier='-';
    @api project;
    userRole;

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_RoleId]
    }) wireuser({error,data}) {
            console.log(JSON.stringify(data));
            if (data) 
                this.userRole = data.fields.UserRole.displayValue;
        }

        @api connectedCallback() {
            this.setSpinner(true);
            this.newProjectService = {
                projectID: this.project.Id,
                serviceActionType: this.serviceActionType,
            }
            if(this.projectService) {
                this.newProjectService.serviceVendorSelection = this.projectService.Vendor__c;
                this.newProjectService.serviceTypeSelection = this.projectService.Service__c ;
               // this.newProjectService.honorDependencies = this.projectService.Service__c;
                this.newProjectService.rushFee = this.projectService.Rush_Fee__c;
                this.newProjectService.externalVendorNote = this.projectService.Vendor_Notes_RT__c;
                this.newProjectService.additionalRateInput = this.projectService.Additional_Rate_Input__c;
                this.newProjectService.internalVendorNote = this.projectService.Internal_Service_Notes__c;
                this.newProjectService.honorDependencies = this.projectService.Honor_Dependencies__c;
                this.newProjectService.psAmount = this.projectService.User_Input_Rate_Amount__c;
                this.newProjectService.rateAmount = this.projectService.Custom_Quote_Amount__c;
                this.selectedService  = this.projectService.Service__r? this.projectService.Service__r.Name: '';
                this.selectedServiceType  = this.projectService.Service_Type_Complexity__c;
                this.selectedVendor  = this.projectService.Vendor__r? this.projectService.Vendor__r.Name: '';
                this.vendorStatus = this.projectService.Vendor__r? this.projectService.Vendor__r.Vendor_Status__c: '';
                this.serviceDescription = this.projectService.Service__r? this.projectService.Service__r.Description__c: '';
                this.wikiAdditionalLink = this.projectService.Service__r? this.projectService.Service__r.Wiki_Additional_Information__c: '';
                
        
                if(this.userRole)
                    this.isPsAmount = (this.projectService.Status__c == 'Killed'? killServiceRolesSet.includes(this.userRole): false) || (amountChangeRolesSet.includes(this.userRole))
               
                 this.loadAllServices();
                 } else this.services1(); // load services
            this.locale = this.series? this.series.Production_Locale__c: (this.project? this.project.Title__r.Production_Locale__c: '');
        
                console.log('projectService234' + JSON.stringify(this.projectService));
                var multiplierSet = [];
                var arates = addlInputRate.split(',');
                for(var a in arates)
                    multiplierSet.push(arates[a].trim());
                        this.multiplierSet = multiplierSet;
                        
                //var selectedEvent = new CustomEvent('spiner', { detail: {d: false} });
               // this.dispatchEvent(selectedEvent);
            } 
        @api async saveForm() {
    
            this.newProjectService.rateRecord = this.rate? this.rate: {};
            this.newProjectService.thisProjectService = this.projectService;
        
            this.setSpinner(true);
        
          const data = await saveForm({res: JSON.stringify(this.newProjectService )});
          if(this.serviceActionType == 'create')
             this.setcallbackaction(data);
          else {
            await this.btnActionResponse1(data);
            await this.btnActionResponse2(data);
          }   
         
        }

        async  btnActionResponse2(data) {
            this.showNotification('Success!','Project Service Created Successfully', 'success');
            this.setSpinner(false);
        }
        async  btnActionResponse1(data) {
           
            if(this.serviceActionType == 'create') {
                var selectedEvent = new CustomEvent('btnactionreponse');
                this.dispatchEvent(selectedEvent);
            } else {
                this.projectService = data.updatedpsRecord;
                var selectedEvent = new CustomEvent('btnactionreponse', {detail: {btn:'edit'}});
                this.dispatchEvent(selectedEvent);
                
            }
        }

        async setcallbackaction(data) {
            if(this.serviceActionType == 'create')
               return await this.censhareCalloutStatus(data.psRecord);
             else return    
        }

       async censhareCalloutStatus(censhareNewPs) {
         const data =  await censhareCalloutStatus({ censhareNewPs: censhareNewPs });
          
                if(data) {
                 console.log('call out status' +JSON.stringify(data));
                        if(data.pollerEnabled) {
                            setTimeout(() =>{ 

                                this.censhareCalloutStatus(censhareNewPs);
                            }, 4000);
                        } else {
                            await this.btnActionResponse1(data);
                            await this.btnActionResponse2(data);
                        
                        }
                    } 

        } 

        setSpinner(d) {
            var selectedEvent = new CustomEvent('spiner', { detail: {d: d} });
            this.dispatchEvent(selectedEvent);
                
        }

        showNotification(t, m, v) {
            const evt = new ShowToastEvent({
                title: t,
                message: m,
                variant: v,
            });
            this.dispatchEvent(evt);
            this.connectedCallback();
        }

        onHandler(e) {
            var name= e.target.name;
            console.log(e.target.type);
            console.log(e.target.checked);
            if(e.target.type == 'checkbox')
                this.newProjectService[name] = e.target.checked;
                else
                this.newProjectService[name] = e.target.value;
        }
// edit service
        async loadAllServices() {
           
           await this.serviceTypes(this.selectedService);
           await this.vendors1(this.newProjectService.serviceTypeSelection, this.selectedService , this.locale);
           await this.setAllvalues1(this.selectedService, this.selectedServiceType, this.selectedVendor, this.vendorStatus);  
           await this.getRates(this.newProjectService.serviceVendorSelection , this.locale); 
           await this.services1();
          // await this.setSpinner(false);  
        }
// service load new or edit
        services1() {
           // console.log('services1');
           this.getServiceOpts().then((data)=> {
            //   console.log('dtaa3' + JSON.stringify(data));
             this.renderServiceOpts(data);
             this.setSpinner(false);
           });
           
        }
        serviceTypes(s) {
          //  console.log('serviceTypes');
            this.getServiceTypeOpts(s).then((data)=> {
               // console.log('dtaa2' + JSON.stringify(data));
                this.renderSTypeOpts(data)
              });
        }

        renderedCallback() {
            const style = document.createElement('style');
            style.innerText = ` label{
                font-weight: 600 !important;
              
              
             }`;
            
            this.template.querySelector('label[class="slds-form-element__label"]').appendChild(style);

        }

        vendors1(s, st,l) {
           
            this.getVendorOpts( st,s, l).then((data)=> {
               /// console.log('dtaa1' + JSON.stringify(data));
                this.renderVendorOpts(data)
              });
        }
        setAllvalues1(s, st, v, vt) {
            console.log('setAllvalues');
            var serq = this.template.querySelectorAll('c-ppw_servicesearchlookup');
            console.log(JSON.stringify(serq));
            for(var i =0; i<serq.length; i++) {
                console.log(serq[i]);
                serq[i].setAllValues(s, st, v, vt);
            }
            
        }

        setfieldValue(type, s) {
            console.log('setfieldValue');
            var serq = this.template.querySelectorAll('c-ppw_servicesearchlookup');
            console.log(JSON.stringify(serq));
            for(var i =0; i<serq.length; i++) {
                console.log(serq[i]);
                serq[i].setfieldValue(type, s);
            }
        }
       

          async getServiceOpts() {
            return await getServices();
        }
          async getServiceTypeOpts(s) {
           return await getServicetype({serviceGroup: s})
        }

        async getVendorOpts(s,st,l ) {
            return await getVendors({serviceGroup: s , serviceType: st , prodLocale: l})
         }

         renderServiceOpts(services) {
            var serq = this.template.querySelectorAll('c-ppw_servicesearchlookup');
            for(var i =0; i<serq.length; i++) {
                serq[i].setpicklistsonchange(services,'selectservice','');
             
            }
        }
         renderSTypeOpts(serviceType) {
            var serq = this.template.querySelectorAll('c-ppw_servicesearchlookup');
            for(var i =0; i<serq.length; i++) {
              serq[i].setpicklistsonchange(serviceType,'selectservicetype', '');
             
            }
        }

        renderVendorOpts(vendors) {
            var serq = this.template.querySelectorAll('c-ppw_servicesearchlookup');
            for(var i =0; i<serq.length; i++) 
                serq[i].setpicklistsonchange(vendors, 'selectvendor',  this.vendorStatus);
             
        }

        resetServiceType(d) {
            this.selectedServiceType = null;
            this.serviceDescription = null;
            this.wikiAdditionalLink = null;
            this.newProjectService.serviceTypeSelection = null;
            var serq = this.template.querySelectorAll('c-ppw_servicesearchlookup');
            for(var i =0; i<serq.length; i++) {
                let l = d.length;
                serq[i].resetServiceType(l, 'selectservicetype');

            }
        }
        resetVendor(d) {
            this.newProjectService.serviceVendorSelection = null;
             var serq = this.template.querySelectorAll('c-ppw_servicesearchlookup');
            for(var i =0; i<serq.length; i++) {
                let l = d.length;
               serq[i].resetVendor(l, 'selectvendor');
            }
        }
        @api selectservice(e) {
            this.selectedService = e.detail.s;
           // this.newProjectService.serviceTypeSelection = e.detail.id;
            this.getServiceTypeOpts(e.detail.s).then((data)=> {
                console.log('data'+ JSON.stringify(data));
                this.renderSTypeOpts(data);
                this.resetServiceType(data);
                this.resetVendor([]);
                this.resetRateValues();
            });
          }

          wikiALink(e) {
              var wl = e.target.name;
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__webPage',
                attributes: {
                    url: wl
                }
            }).then(generatedUrl => {
                window.open(generatedUrl);
            });
          }
        @api selectservicetype(e) {
        
            this.selectedServiceType = e.detail.s;
            this.newProjectService.serviceTypeSelection = e.detail.id;
            this.serviceDescription = e.detail.sDescription;
            this.wikiAdditionalLink = e.detail.wikiALink;
           // console.log(this.serviceDescription);
            this.getVendorOpts(this.selectedService, e.detail.id , this.locale).then((data)=> {
                console.log('datavendor'+ JSON.stringify(data));
                this.renderVendorOpts(data);
                this.resetVendor(data);
                this.resetRateValues();
            });
        }

        @api selectvendor(e) {
            this.selectedVendor = e.detail.s;
            this.selectedVendorId = e.detail.id;
            this.newProjectService.serviceVendorSelection = e.detail.id;
           this.getRates(e.detail.id,  this.locale);
        }
        
        getRates(v,l) {
            console.log('getRates');
           // this.resetRateValues();
            getRates({serviceGroup: this.selectedService, serviceType: this.newProjectService.serviceTypeSelection, vendor:  v, prodLocale : l})
            .then((data) => {
                if(data) {
                    console.log('rates' + JSON.stringify(data));
                    this.rate = data;
                    this.newProjectService.rateRecord = this.rate;
                    this.rateLabel = 'Rate (' +data.Rate_Currency__c + ')';
                    this.rateAmountMultiplier = data.Rate_Amount__c + '-' +data.Rate_Multiplier__c;

                if(data.Rate_Multiplier__c == 'Custom Quote')
                    this.isCustomQuote = true;
                else this.isCustomQuote = false;
            
                this.estimatedInputLabel = 'Estimated ' +data.Rate_Multiplier__c + '(s)';
                if(this.multiplierSet.includes(data.Rate_Multiplier__c))
                    this.isaddRateInput = true;
                else this.isaddRateInput = false;
            } else {
                this.resetRateValues();
            }
          
                
            });
           
        }

        resetRateValues() {
            console.log('resetRateValues');
            this.newProjectService.additionalRateInput = null;
            this.newProjectService.psAmount = null;
            this.newProjectService.rateAmount = null;
            this.newProjectService.rushFee = null;
            this.rate = {}
            this.newProjectService.rateRecord = {}
            this.rateLabel = 'Rate ()';
            this.rateAmountMultiplier = '-';
            this.isCustomQuote = false;
            this.estimatedInputLabel = '-';
            this.isaddRateInput = false;
        }
      
}