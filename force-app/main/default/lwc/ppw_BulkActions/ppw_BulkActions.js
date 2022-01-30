import { LightningElement , api} from 'lwc';
import getservices from '@salesforce/apex/ppw_projectControllerExtension_lwc.getservices';
import getProject from '@salesforce/apex/ppw_projectControllerExtension_lwc.getProject';
import getVendorPSs from '@salesforce/apex/ppw_projectControllerExtension_lwc.getVendorPSs';
import createBulkConfirmation from '@salesforce/apex/ppw_projectControllerExtension_lwc.createBulkConfirmation';
import bulkKickOffService from '@salesforce/apex/ppw_projectControllerExtension_lwc.bulkKickOffService';
import bulkVendorService from '@salesforce/apex/ppw_projectControllerExtension_lwc.bulkVendorService';
import getAllVendors from '@salesforce/apex/ppw_projectControllerExtension_lwc.getAllVendors';
export default class Ppw_BulkActions extends LightningElement {
    bulkAction;buttonLabel= 'Complete Bulk Action';bulkActionVal;isSelectall;spinner;sVendor;successMes;
    confirmationPS;kickedOffPSs;cancelPSs;vendorPSs;checkedPSs={};resultSuccess;resultError;issuc;isError;isVendor;isMasterPT;
    selectedPSs;tableHeaders = ['Service', 'Current Vendor', 'Estimated Start Date', 'Estimated Completion Date', 'Your Service Rate'];//, 'Service Amount'];
    @api recordId;
    @api project;
    @api series;
    @api title;
    //title;
    servicesMap={};showPstable;isVendor;
    get options() {
          return [ 
        {label: 'Assign Multiple Vendors', value: 'Vendor'},
        {label: 'Open Multiple Confirmations', value: 'Confirmation'},
        {label: 'Kick Off Multiple Services', value: 'KickedOff'}
    ]
    }

    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    coloms = [
        { label: 'Service', fieldName: 'Service_Type_Complexity__c' ,  sortable: true,  
            cellAttributes: { 
            
                iconName: { fieldName: 'masterPTIcon' , class: 'slds-hide'} ,iconLabel: ''},
            typeAttributes: { tooltip: ''}
        },
        { label: 'Vendor',
            fieldName: 'Vendor',
        },
        { label: 'Estimated Start Date', fieldName: 'Estimated_Start_Date__c', type: "date" , sortable: true},
        { label: 'Estimated Completion Date', fieldName: 'Estimated_Completion_Date__c',type: "date" , sortable: true},
        { label: 'Your Service Rate', fieldName: 'Total_Rate_Amount__c'},
    
    ]

    connectedCallback() {
        console.log('connectedCallback');
        // this.setSpinner(true);
      /*  getProject({ pId :  this.recordId?  this.recordId : 'a041H00000pWPlCQAW' })
         .then((data) => {
             if(data) {
                 this.title = data.project.Title__r;
              }
         }).catch((error) => { }); */
     }
    closeBulkModal() {
        var selectedEvent = new CustomEvent('closemodal', { });
        this.dispatchEvent(selectedEvent);
    }

    selectVendor() {

    }
    
    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
      
    }


    selectBulkAction(e) {
        this.spinner = true;
        let b = this.template.querySelector('[data-id="modalC"]');
            if(b)
            b.classList.remove('slds__content');
        this.bulkActionVal = e.target.value;
        this.showPstable = true;
       
        this.selectedPSs = [];
        var vendor = this.template.querySelector('[data-id="vendor"]');
        if(this.bulkActionVal == 'Vendor') {
            if(vendor)
                vendor.classList.remove('slds-hide');
                this.isVendor = true;

           this.getAllVendors();
        } else {
            this.isVendor=false;
            if(vendor)
                vendor.classList.add('slds-hide');
            this.getservices();
            
        }
          
            let ser = this.template.querySelector('[data-id="selectall"]');
            if(ser)
                ser.checked = false;
            this.isMasterPT = false;
    }

    @api selectvendor(e) {
        this.sVendor = e.detail.id;
        this.getVendorPSs(this.sVendor);
      //  console.log(JSON.stringify(e.detail));
        this.buttonLabel= 'Complete Bulk '+ this.bulkActionVal;
      
    }

    sortBy(field, reverse, primer) {
        const key = primer
            ? function(x) {
                  return primer(x[field]);
              }
            : function(x) {
                  return x[field];
              };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.selectedPSs];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.selectedPSs = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }


    getVendorPSs(vId) {
        let plocale = this.series? this.series.Production_Locale__c: this.title.Production_Locale__c;
      //this.selectedPSs =  await 
      getVendorPSs({vId: vId, prodLocale: plocale , projectID: this.recordId})
       .then((data) => {
           console.log('data##'+ JSON.stringify(data));
         
            if(data) {
               
                var updated = []
                var data1 = JSON.parse(JSON.stringify(data));
         
                var servicesMap = {}
                for(var a in data1) 
                     servicesMap[data1[a].Id] = data1[a];
                     this.servicesMap = servicesMap;
                  
                    for(var a in data) {
                        var d = data[a];
                        d.masterPTIcon = d.Master_PT_Service__c? 'utility:warning': '';
                        d.Vendor = d? d.Vendor__r? d.Vendor__r.Name: 'None' : 'None';
                        data[a].Total_Rate_Amount__c =  (data[a].Total_Rate_Amount__c != '0' && data[a].Total_Rate_Amount__c != '0.00' && data[a].Total_Rate_Amount__c) ? data[a].Total_Rate_Amount__c: 'None';
                           // d.Total_Rate_Amount__c = 'None';  
                        updated.push(d); 
                     }
               
                this.selectedPSs = updated;
                for(var a in this.selectedPSs)
                     if(this.selectedPSs[a].masterPTIcon)
                        this.isMasterPT = true;
                console.log(this.selectedPSs);
                var tbl = this.template.querySelector('table');
                tbl.classList.add('tbl');
                tbl.style="height: 5rem;";
                console.log('load table');
            }});
    
    }
    getAllVendors() {
        let plocale = this.series? this.series.Production_Locale__c: this.title.Production_Locale__c;
        getAllVendors({prodLocale: plocale})
        .then((data) => {
            var vendors = [];
            console.log(JSON.stringify(data));
            for(var a in data) {
                var vstatus,vicon;
               
                if(data[a].Vendor_Status__c == 'Approved: Ok to Use') {
                     vstatus =  'iconStyle iconColorGreen';
                     vicon = '/utility-sprite/svg/symbols.svg#success';
                 } else {
                     vstatus = 'iconStyle iconColor1';
                     vicon = '/utility-sprite/svg/symbols.svg#warning';
                 }
              
                 var vendorBadge = data[a].Vendor_Status__c == 'Approved: Ok to Use'? 'slds-text-color_success': 'warningColor';
                vendors.push({label: data[a].Name, value: data[a].Id, statusStyle: vstatus, statusIcon: vicon, vendorStatus: data[a].Vendor_Status__c, vendorBadge: vendorBadge});

            }
         
               this.vendors = vendors;
               var serq = this.template.querySelectorAll('c-ppw_servicesearchlookup');
               let l = vendors.length;
               for(var i =0; i<serq.length; i++) {
                   serq[i].resetVendor(l, 'selectvendor');
                   serq[i].setpicklistsonchange(vendors, 'selectvendor', '', '');
                
               }
               this.buttonLabel= 'Complete Bulk '+ this.bulkActionVal;
               this.spinner = false;
        });
    }

    renderedCallback() {
        var tbl = this.template.querySelector('table');
        tbl.classList.add('tbl');
   }

    getservices() {
        this.selectedPSs = [];
        getservices({ projectId :  this.recordId?  this.recordId : '' })
        .then((data) => {
            if(data) {
               
                console.log('data' + JSON.stringify(data));
                var data1 = JSON.parse(JSON.stringify(data));
              var  confirmationPS = [], kickedOffPSs= [], vendorPSs = []
              var servicesMap = {}
              for(var a in data1) 
                   servicesMap[data1[a].Id] = data1[a];
                   this.servicesMap = servicesMap;
                for(var a in data) {
                    data[a].masterPTIcon = data[a].Master_PT_Service__c? 'utility:warning': '';
                    data[a].Vendor = data[a]? data[a].Vendor__r? data[a].Vendor__r.Name :'None': 'None';
                    data[a].Total_Rate_Amount__c =  (data[a].Total_Rate_Amount__c != '0' && data[a].Total_Rate_Amount__c != '0.00' && data[a].Total_Rate_Amount__c) ? data[a].Total_Rate_Amount__c: 'None';
                    if(data[a].Vendor__c && (data[a].Status__c == 'In Planning' || data[a].Status__c == 'In Planning'))
                         
                        confirmationPS.push(data[a])
                       
                        if(data[a].Status__c == 'Scheduled') {
                            if(data[a].Project__r.Series__r)
                                kickedOffPSs.push(data[a]);
                                else {
                                    if(data[a].Project__r.Title__r.Status__c == 'Contracted')
                                        kickedOffPSs.push(data[a]);
                                }
                        }
                    
                }
                console.log(this.bulkActionVal);
                this.buttonLabel= 'Complete Bulk '+ this.bulkActionVal;
                if(this.bulkActionVal == 'Confirmation') 
                    this.selectedPSs = confirmationPS;
             
                    if(this.bulkActionVal == 'KickedOff')
                        this.selectedPSs = kickedOffPSs;

                        //buttonLabel= 'Complete Bulk Action'
                        this.spinner = false;
                        for(var a in this.selectedPSs)
                        if(this.selectedPSs[a].masterPTIcon)
                           this.isMasterPT = true;
            }});
    }

    getSelectedName(e) {
        this.checkedPSs = e.detail.selectedRows;
       // if(selectedRows) {
      //      this.checkedPSs[item.Id] = e.target.name;
      //  }
    }
 

    closeSucModal() {
        let s = this.template.querySelector('[data-id="success"]');
        let b = this.template.querySelector('[data-id="bulkaction"]');
            if(s)
            s.classList.toggle('slds-hide');
            if(b)
            b.classList.toggle('slds-hide');
    }
    onsave(e) {
        var fields = Object.keys(this.checkedPSs).map(key=> ({ ...this.checkedPSs[key] }));
        console.log(JSON.stringify(this.checkedPSs));
            this.spinner = true;
        
        var flds = [];
    
      //  if(this.bulkActionVal == 'Vendor') {
      
       if(this.servicesMap) 
            for(var a in fields) {
                flds.push(this.servicesMap[fields[a].Id]); 
          
            }
                fields = flds;
   // }
    console.log('fkiedss' + JSON.stringify(fields));
       // this.renderPage([]);
        if(this.bulkActionVal == 'Confirmation') {
            this.successMes = 'Confirmation Records have been Created Successfully for the below Project Services';
            createBulkConfirmation({ psList :  fields })
            .then((data) => {
            //if(data.censhareStatus)
                this.renderPage(data);
            });
        }
 
        if(this.bulkActionVal == 'KickedOff') {
            this.successMes = 'Below Project Services have been Kicked Off Successfully';
            bulkKickOffService({ psList :  fields })
            .then((data) => {
               // if(data.censhareStatus)
                    this.renderPage(data);
            });
        } 

        if(this.bulkActionVal == 'Vendor') {
            this.successMes = 'Vendor has been changed Successfully for the below Project Services';
            bulkVendorService({ psList :  fields , vId: this.sVendor})
            .then((data) => {
               // if(data.censhareStatus)
                    this.renderPage(data);
            });
        } 

      
          
    }

    renderPage(data) {
        this.resultSuccess = null;
        this.resultError = null;
        this.getrefreshpanels();
        if(data) {
            console.log(JSON.stringify(data));
            this.closeSucModal();
                var suc = [],error=[];
          //resultSuccess
          for(var a in data) {
              if(data[a].censhareStatus)
                suc.push(data[a]);
                else
                 error.push(data[a]);
          }
          console.log(JSON.stringify(suc));
          console.log(JSON.stringify(error));
          if(suc.length>0)
            this.resultSuccess = suc;
          if(error.length>0)
            this.resultError = error;
        
        }
        this.getservices();
        this.spinner = false;
        this.isMasterPT = false;
    }

    getrefreshpanels() {
        var selectedEvent = new CustomEvent('getrefreshpanels', { });
        this.dispatchEvent(selectedEvent);
    }
}