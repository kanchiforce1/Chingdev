import { LightningElement, wire, api,track } from 'lwc';
import { CurrentPageReference, NavigationMixin} from 'lightning/navigation';

import getAllTitles from '@salesforce/apex/ppw_projectControllerExtension_lwc.getAllTitles';
import getSeriesDetails from '@salesforce/apex/ppw_projectControllerExtension_lwc.getSeriesDetails';
import getTitleDetails from '@salesforce/apex/ppw_projectControllerExtension_lwc.getTitleDetails';



export default class Ppw_TransmittalTab extends NavigationMixin(LightningElement) {

    @api martyid;
    @api vendor;
    @api seriesid;
    titles;vendors;titledetails;
    seriesdetails;
    isVendor_MartyId;
    project;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
        this.martyid = currentPageReference.state.c__martyid? currentPageReference.state.c__martyid: '';
        this.seriesid = currentPageReference.state.c__seriesid? currentPageReference.state.c__seriesid: '';
        this.vendor = currentPageReference.state.c__vendor;
        this.checkVendormartyId();
       }
    }

  async  connectedCallback() {
        if(this.martyid) 
            await this.getTitleDetails(this.martyid);
          
        if(this.seriesid) 
            await this.getSeriesDetails(this.seriesid);
            await this.getAllTitles();
   
    }
    checkVendormartyId() {
        console.log('render call back');
        if(this.martyid)
            this.isVendor_MartyId = (this.martyid && this.vendor);
        if(this.seriesid)
            this.isVendor_MartyId = (this.seriesid && this.vendor);
    }
 
    async getTitleDetails(martyid) {
            const titledetails = await getTitleDetails({martyid: martyid});
            await this.getAllVendors(titledetails.vendors);
            this.project = titledetails.project? titledetails.project: null;
            this.titledetails = titledetails.title;
    }

    async getSeriesDetails(seriesid) {
        const seriesdetails = await getSeriesDetails({seriesid: seriesid});
        await this.getAllVendors(seriesdetails.vendors);
        this.project = seriesdetails.project? seriesdetails.project: null;
        this.seriesdetails = seriesdetails.series;
}

    nagivateTotitle(e) {
        var tId = e.target.name;
       // Generate a URL to a User record page
       this[NavigationMixin.GenerateUrl]({
           type: 'standard__recordPage',
           attributes: {
               recordId: tId,
               actionName: 'view',
           },
       }).then(url => {
           window.open(url, "_blank");
       });
    }

    @api selecttitle(e) {
       
        if(e.detail.isSeries)
            this.seriesid = e.detail.id;
        else   this.martyid = e.detail.id;   
            console.log(this.martyid);
            console.log(this.seriesid);
        console.log('selecttitle');
        this.vendor = '';
        this.checkVendormartyId();
        if(this.martyid)
            this.getTitleDetails(this.martyid);
            if(this.seriesid)
            this.getSeriesDetails(this.seriesid);
        this.renderTransmittal();
      
    }

    @api async selectvendor(e) {
        this.vendor = e.detail.id;
       await this.checkVendormartyId();
        console.log(this.vendor);
        this.renderTransmittal();
      
    }

renderTransmittal() {
    var t = this.template.querySelector("c-ppw_transmittal-component");
    console.log('render transa');
    if(t) {
        console.log('render transa1');
        t.vendor = this.vendor;
        t.martyid = this.martyid;
        t.seriesId = this.seriesid;
        console.log('render transa');
        t.getTransmittalRecords();
    }
}

    //his.template.querySelector("c-ppw_transmittal-component").getTransmittalRecords();
    getAllVendors(data) {
    
            var vendors = [];
            var vendorName='';
            var vendorStatus='';
            console.log('get all vendors');
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
                 if(this.vendor == data[a].Id) {
                    vendorName = data[a].Name;
                    vendorStatus = data[a].Vendor_Status__c;
                 }
            }
         
               this.vendors = vendors;
               var serq = this.template.querySelectorAll('c-ppw_servicesearchlookup');
               let l = vendors.length;
               for(var i =0; i<serq.length; i++) {
                   serq[i].resetVendor(l, 'selectvendor');
                   if(vendorName) {
                        serq[i].resetVendorLabel('selectvendor', vendorName);
                        serq[i].setpicklistsonchange(vendors, 'selectvendor', vendorStatus);
                   } else
                        serq[i].setpicklistsonchange(vendors, 'selectvendor', '', '');
                
               }
             

             
               this.spinner = false;
            
    }

   async getAllTitles() {
     this.titles = await getAllTitles();
     console.log('this.titledetails');
     console.log(this.titledetails);
     console.log(this.titles);
        if(this.titles) {
              var serq = this.template.querySelectorAll('c-ppw_servicesearchlookup');
              if(serq)
               for(var i =0; i<serq.length; i++) {
                let label;
                if(this.seriesdetails)
                label =  this.seriesdetails.Wombat_Series_ID__c?  this.seriesdetails.Wombat_Series_ID__c + '-'+ this.seriesdetails.Series_Title__c : this.seriesdetails.Series_Title__c;
                if(this.titledetails)
                     label =  this.titledetails.Marty_Title_ID__c?  this.titledetails.Marty_Title_ID__c + '-'+ this.titledetails.Name : this.titledetails.Name;
                        
                     serq[i].resetTitle('selecttitle', label);
                   serq[i].setpicklistsonchange(this.titles, 'selecttitle', '');
               }
         
        }
    }


}