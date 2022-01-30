/* eslint-disable eqeqeq */
/* eslint-disable no-console */
import { LightningElement,wire,api,track } from 'lwc';



export default class LwcCustomLookup extends LightningElement {
   
    @api selectedlabel;
    @track value;
    vendor;istitle;
    @api label;
    selectedvalue = '';
    defaultSelectedVal = '';
    isservice;isserviceType;isVednor;isRate;vendorbadge;vendorstatus;placeholder;
    @api eventname;
    @api customHelpText;
    @api records;
    @api picklistVals;
    @api searchRecords = [];
    required = false;inputClass = '';LoadingText = false; 
    notfound = false; iconFlag =  true; clearIconFlag = false; 
    inputReadOnly = false;
    iconName = 'action:new_account';
    txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
   
    connectedCallback() {
        this.formreset();
      
    }
        setdefaultSelectVal() {
      
            var dtest = '';
            if(this.eventname == 'selecttitle') {
                dtest = 'Select a Title';
                this.searchRecords = [];
                this.picklistVals = [];
            // this.searchRecords = [];
            }

            if(this.eventname == 'selectservice') {
                dtest = 'Select a Group';
                this.searchRecords = [];
                this.picklistVals = [];
            // this.searchRecords = [];
            }
                if(this.eventname == 'selectservicetype') {
                    dtest = 'Select a Service Type';
                    this.searchRecords = [];
                    this.picklistVals = [];
                }

            if(this.eventname == 'selectvendor') {
                dtest = 'Select a Vendor';
                this.searchRecords = [];
                this.picklistVals = [];
            }
            this.placeholder = dtest;
            return dtest;
        }

     /*   @api setpicklists(type, p) {
            if(type == this.eventname) 
                this.picklistVals = p;
        }
        @api setfieldValue(type, s) {
            if(type == this.eventname) 
                this.selectedlabel = s;
        }*/

    

        @api resetServiceType(l, type) {
            if(type == this.eventname) {
                if(l>0)
                    this.selectedlabel = 'Select a Service Type';
                 else  this.selectedlabel = '';  
               // resetServiceType
            }
        }
        @api resetVendor(l ,type) {
            if(type == this.eventname) {
                console.log(l)
                console.log(l>0);
                if(l>0)
                    this.selectedlabel = 'Select a Vendor';
                 else  this.selectedlabel = '';

                this.vendorstatus = '';
                this.vendorbadge = '';  
            }
        }

        @api resetVendorLabel(type, v) {
            if(type == this.eventname) {
              
                if(v) {
                    this.selectedlabel = v;
                }

            }
        }
        @api resetTitle(type,t) {
            if(type == this.eventname) {
              
                if(t) {
                    this.selectedlabel = t;
                   // this.selectedlabel = 'Select a Title';
                    this.placeholder = 'Select a Title';
                    }    else  {
                      //  this.placeholder = 'Select a Title';
                        this.selectedlabel = 'Select a Title';
                    }
 
            }
        }

   @api setpicklistsonchange(p,type, vendorstatus) {
   
        if(type == this.eventname) {
            console.log(this.eventname);
            this.picklistVals = p;
                
            if(this.eventname == 'selectvendor') {
                this.vendorstatus = vendorstatus;
                this.vendorbadge = vendorstatus == 'Approved: Ok to Use'? 'slds-text-color_success':'warningColor';

            }
  //console.log('api set' +JSON.stringify(this.picklistVals));
        }
    }

 /*     @api setRenderValues(s, type) {
        if(type == this.eventname)
            this.selectedlabel = s;
    }
    
  @api titlereset(p, s) {
        console.log('serviceTyperest'+ this.eventname);
        if(this.eventname == 'selectservicetype') {
            this.selectedlabel = this.setdefaultSelectVal();
         if(!s) 
            if(p.length == 0)
                this.selectedlabel = '';
        
        }
    }

    @api serviceTyperest(p, s) {
        console.log('serviceTyperest'+ this.eventname);
        if(this.eventname == 'selectservicetype') {
            this.selectedlabel = this.setdefaultSelectVal();
         if(!s) 
            if(p.length == 0)
                this.selectedlabel = '';
        
        }
    }
        @api vendorrest(p, v) {
            console.log('vendoree'+ this.eventname);
            if(this.eventname == 'selectvendor') {
                this.selectedlabel = this.setdefaultSelectVal();
                this.vendorstatus = '';
                if(!v)
                if(p.length == 0)
                    this.selectedlabel = '';

            }
          
            } */
   
        @api setAllValues(s, st, v,vendorstatus) {
            console.log(this.eventname);
            console.log(s);
            console.log(st);
            console.log(v);

            if(this.eventname == 'selectservice') 
                this.selectedlabel = s;
          
            if(this.eventname == 'selectservicetype') 
                this.selectedlabel = st;
            if(this.eventname == 'selectvendor') {
                this.selectedlabel = v;
                this.vendorstatus = vendorstatus;
                this.vendorbadge = vendorstatus == 'Approved: Ok to Use'? 'slds-text-color_success':'warningColor';
            }
        }


    formreset() {
       // console.log(this.eventname);
       if(this.eventname == 'selecttitle') {
        this.istitle = true;
        if(!this.selectedlabel)
           this.selectedlabel = this.setdefaultSelectVal();
   }
       if(this.eventname == 'selectservice') {
             this.isservice = true;
             if(!this.selectedlabel)
                this.selectedlabel = this.setdefaultSelectVal();
        }
    if(this.eventname == 'selectservicetype') {
            this.isserviceType = true;
            this.selectedlabel = this.setdefaultSelectVal();
    }

    if(this.eventname == 'selectvendor') {
        this.isVednor = true;
        this.selectedlabel = this.setdefaultSelectVal();
    }
  
    }

   @api setEditServiceVals(s) {
       

    }

    renderedCallback() {
    // console.log('render callback');
    }

    // search title data in look up field
    searchField(event) {
      
        var currentText = event.target? event.target.value: '';
        this.notfound = false;
        this.LoadingText = true;
        var input, filter, ul, li, a, i;
     
        var filter = currentText.toUpperCase();
   
        var a = this.template.querySelectorAll('[data-id="keys"]');
       // console.log('this.picklistVals'+ JSON.stringify(this.picklistVals));
     
       
       var sresult = [{label: this.placeholder, value: ''}]
        for (var i = 0; i < this.picklistVals.length; i++) {
          var txtValue = this.picklistVals[i].label;
          if (txtValue.toUpperCase().indexOf(filter) > -1) 
            sresult.push(this.picklistVals[i]);
        }
   
        
        console.log(JSON.stringify(sresult));
        if( sresult) {
        this.searchRecords = sresult; 
        this.notfound = false;
        } else {
            this.notfound = true;
        }
        this.LoadingText = false;
    
        this.template.querySelector('[data-id="resultBox"]').classList.add('slds-is-open');
    }

    
  
    onhide() {
        setTimeout( ()=> {
            this.template.querySelector('[data-id="resultBox"]').classList.remove('slds-is-open');
            
        }, 200);
       // 
     }

    inblur() {
      
    }

    // set selected title id from look up search result
   setSelectedRecord(event) {
        var isSeries = event.currentTarget.dataset.isseries;
        this.selectedlabel = event.currentTarget.dataset.label;
        this.selectedvalue = event.currentTarget.dataset.value;
       
        var vendorstatus = event.currentTarget.dataset.vendorstatus; 
        
       var vendorbadge = event.currentTarget.dataset.vendorbadge;
       var sDescription = event.currentTarget.dataset.description;
       var wikialink = event.currentTarget.dataset.wikialink;
       console.log(sDescription);
        console.log('this.selectedlabel23' + this.selectedvalue);
        console.log(isSeries);

        var a = this.template.querySelector('[data-id="inputText"]');
        a.value= '';
        if(this.eventname == 'selectvendor') {
            this.vendorstatus = vendorstatus;
            this.vendorbadge = vendorbadge;

        }
       var selectedEvent = new CustomEvent(this.eventname, { detail: {s: this.selectedlabel.toString(), componentName: this.eventname, id: this.selectedvalue , sDescription: sDescription, wikiALink: wikialink, isSeries:isSeries}});
        this.dispatchEvent(selectedEvent);
        this.template.querySelector('[data-id="resultBox"]').classList.toggle('slds-is-open');
    }

    
  }