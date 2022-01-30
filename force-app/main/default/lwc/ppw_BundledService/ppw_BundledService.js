import { LightningElement , api} from 'lwc';
import getBundleSerivces from '@salesforce/apex/ppw_projectControllerExtension_lwc.getBundleSerivces';
import createBundleSerivces from '@salesforce/apex/ppw_projectControllerExtension_lwc.createBundleSerivces';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Ppw_BundledService extends LightningElement {
    bulkAction;buttonLabel= 'Complete Bundle Action';bulkActionVal;isSelectall;spinner;sVendor;successMes;
    confirmationPS;kickedOffPSs;cancelPSs;vendorPSs;checkedPSs={};resultSuccess;resultError;issuc;isError;isVendor;isMasterPT;
    tableHeaders = ['Service', 'Current Vendor', 'Estimated Start Date', 'Estimated Completion Date', 'Your Service Rate'];//, 'Service Amount'];
    @api recordId;
    @api project;
    @api series;
    @api title;
    allPssMap;
    
    allPss=[]
    selectedPSs={}
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
        { label: 'Service', fieldName: 'Service_Type_Complexity__c' ,  sortable: true  
          
        },
      
        { label: 'Estimated Start Date', fieldName: 'Estimated_Start_Date__c', type: "date" , sortable: true},
        { label: 'Estimated Completion Date', fieldName: 'Estimated_Completion_Date__c',type: "date" , sortable: true},
        { label: 'Your Service Rate', fieldName: 'Total_Rate_Amount__c'}
    
    ]

   async connectedCallback() { //
        console.log('connectedCallback');
        const data = await getBundleSerivces({ projectID :  this.recordId });
        this.allPssMap = data;
        let allpss=[];
        // var fields = Object.keys(this.checkedPSs).map(key => ({ ...this.checkedPSs[key] }));
        for(var a in data) {
            let ps={key: a, value: data[a]}
            allpss.push(ps);

        }
        this.allPss = allpss;

        
     
     }
    closeBulkModal() {
        var selectedEvent = new CustomEvent('closemodal', { });
        this.dispatchEvent(selectedEvent);
    }

    selectVendor() {

    }

    serviceCheck(e) {
        let item = e.target.checked;
        if(item)
            this.selectedPSs[e.target.name] = this.allPssMap[e.target.name];
        else this.selectedPSs[e.target.name] = [];
    
    }
    
    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
      
    }

    @api selectvendor(e) {
        this.sVendor = e.detail.id;
    
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


    renderedCallback() {
        var tbl = this.template.querySelector('table');
        tbl.classList.add('tbl');
   }

   showToast(title, message , variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
}

    getSelectedName(e) {
        this.checkedPSs = e.detail.selectedRows;
    }
 

    closeSucModal() {
        let s = this.template.querySelector('[data-id="success"]');
        let b = this.template.querySelector('[data-id="bulkaction"]');
            if(s)
            s.classList.toggle('slds-hide');
            if(b)
            b.classList.toggle('slds-hide');
    }
    onsave() {
       
        this.spinner = true;
        let selectedList = [];
        for(let a in this.selectedPSs) 
            for(let b in this.selectedPSs[a])
                selectedList.push(this.selectedPSs[a][b]);
        
        console.log(selectedList);
            createBundleSerivces({ psList :  selectedList })
            .then((data) => {
                    this.showToast('Bundle Services Created', data , 'success');
                    this.spinner = false;
                //this.successMes = 'Bundle Service has been created successfully';
            });
       

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