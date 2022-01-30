/* eslint-disable eqeqeq */
/* eslint-disable no-console */
import { LightningElement,wire,api,track } from 'lwc';



export default class LwcCustomLookup extends LightningElement {
   
    selectedlabel;vendor;selectedvalue;
    @api eventname;
    Label = 'Please Select Title Id';
    @api records;
    @api picklistVals;
    @api searchRecords = [];
    required = false;inputClass = '';LoadingText = false; 
    notfound = false; iconFlag =  true; clearIconFlag = false; 
    inputReadOnly = false;
    iconName = 'action:new_account';
    txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
   
    connectedCallback() {

    
        console.log(this.titleId);
        if(this.titleId)
            this.getTitleIdResults();
    
    }

    renderedCallback() {
      /*  const style = document.createElement('style');
        style.innerText = ` input[type="search"] {
            height: 3.5rem;
            font-size: 19px;
        
        } input[type="search"]::placeholder{
            font-size: 19px;
         }`;
        
        this.template.querySelector('[data-id="inputText"]').appendChild(style);*/
    }

    // search title data in look up field
    searchField(event) {
      return false;
     /*   var currentText = event.target? event.target.value: '';
        this.notfound = false;
        this.LoadingText = true;
        var input, filter, ul, li, a, i;
     
        var filter = currentText.toUpperCase();
      
        var a = this.template.querySelectorAll('[data-id="keys"]');
       var sresult = []
        for (var i = 0; i < this.picklistVals.length; i++) {
          var txtValue = this.picklistVals[i].label;
          if (txtValue.toUpperCase().indexOf(filter) > -1) 
            sresult.push(this.picklistVals[i]);
        }
        if( sresult) {
        this.searchRecords = sresult; 
        this.notfound = false;
        } else {
            this.notfound = true;
        }
        this.LoadingText = false;
        console.log('searchField');
       // this.notfound = false;
        this.template.querySelector('[data-id="resultBox"]').classList.add('slds-is-open');*/
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
   
    var selectedlabel = event.currentTarget.dataset.label;
    var selectedvalue = event.currentTarget.dataset.value;
   
    this.selectedlabel = selectedlabel;
    this.selectedvalue = selectedvalue;
    console.log(this.eventname);
    var selectedEvent = new CustomEvent(this.eventname, { detail: {s: selectedlabel.toString()} });
    this.dispatchEvent(selectedEvent);
    this.template.querySelector('[data-id="resultBox"]').classList.toggle('slds-is-open');
    }

    
  }