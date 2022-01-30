/* eslint-disable eqeqeq */
/* eslint-disable no-console */
import { LightningElement,wire,api,track } from 'lwc';
import { fireEvent } from 'c/pubsub';
import getResults from '@salesforce/apex/lwcCustomLookupController.getResults';
import getTitleIdResults from '@salesforce/apex/lwcCustomLookupController.getTitleIdResults';
import getVendorId from '@salesforce/apex/lwcCustomLookupController.getVendorId';
import { CurrentPageReference } from 'lightning/navigation';
import checkBtnsAccess from '@salesforce/apex/lwcCustomLookupController.checkBtnsAccess';

export default class LwcCustomLookup extends LightningElement {
    objectName = 'Title__c';
    fieldName = 'Marty_Title_ID__c, Full_Title_Name__c, Is_In_Series__c';
    filter1 = 'Marty_Title_ID__c';
    filter2 = ' Name';
    fieldName1 = 'Full_Title_Name__c';
    selectRecordId = '';
    selectedTitle = 'Please select title';
    titleId;titleIdResult;page;

    @track selectRecordName;vendor;
    Label = 'Please Select Title Id';
    @track searchRecords = [];
    required = false;inputClass = '';LoadingText = false; messageFlag = false; iconFlag =  true; clearIconFlag = false; inputReadOnly = false;
    iconName = 'action:new_account';
    txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
   
    @wire(getVendorId) vendor;
    connectedCallback() {

        const param = 'titleId';
        this.titleId = new URL(window.location.href).searchParams.get('titleId');
        this.page = new URL(window.location.href).searchParams.get('page');
       
    
        console.log(this.titleId);
        if(this.titleId)
            this.getTitleIdResults();
    
    }

    renderedCallback() {
        const style = document.createElement('style');
        style.innerText = ` input[type="search"] {
            height: 3.5rem;
            font-size: 19px;
        
        } input[type="search"]::placeholder{
            font-size: 19px;
         }`;
         
        
        this.template.querySelector('[data-id="inputText"]').appendChild(style);
    }

    // search title data in look up field
    searchField(event) {
        var currentText = event.target.value;
        this.LoadingText = true;
       
        this.getTitleData(currentText);
        
    }

    getTitleData(currentText) {
        console.log(JSON.stringify(this.vendor));
        console.log('currentText' + currentText);
        getResults({ ObjectName: this.objectName, fieldName: this.fieldName, fieldName1: this.fieldName1, value: currentText , 
                        filter1: this.filter1, filter2: this.filter2 })
        .then(result => {
            
            if(result) {
                console.log('result' + JSON.stringify(result));
                this.searchRecords= result;
                this.LoadingText = false;
           
                if(result.length == 0) {
                    this.messageFlag = true;
                    this.LoadingText = false;
                }
                else {
                    this.messageFlag = false;
                    this.template.querySelector('[data-id="resultBox"]').classList.add('slds-is-open');
                }
      

            } else {
                    this.LoadingText = false;
                    this.messageFlag = true;
            }
        })
        .catch(error => {
            this.searchRecords= null;
            this.messageFlag = true;
            console.log('-------error-------------'+error);
            console.log(error);
        });

    }

    // select auto title from url parameters
    getTitleIdResults() {
        console.log(JSON.stringify(this.vendor));
      
        getTitleIdResults({ titleId: this.titleId})
        .then(result => {
            
            if(result) {
                let title = result.title; 
                let btnToggle = result.btnToggle;

                this.selectedTitle = title.Marty_Title_ID__c + ' - ' + title.Name;
               
                let tId = title.Id;
                let mId = title.Marty_Title_ID__c;
                let tName = title.Name;
                let isinseries = title.Is_In_Series__c;
                let fulltitlename = title.Full_Title_Name__c;
                 
                    let selectWrp = {
                        'Id' : tId,
                        'MartyId' : mId,
                        'fullTitleName' : fulltitlename,
                        'Name' : tName,
                        'btnToggle' : btnToggle,
                        'vendor' : this.vendor,
                        'page': this.page // button navigation based on url parameters
                }
               setTimeout(() =>  {
                    fireEvent(this.pageRef, 'selectedtitle',selectWrp);
                },2000);
                
                   
                }       

        })
        .catch(error => {
            console.log('-------error-------------'+error);
            console.log(error);
        });

    }


    setOutTime;
    onmouseout() {
       
        if(!this.setOutTime) {
        this.setOutTime = setTimeout(() =>  {
            console.log("In out");
            this.template.querySelector('[data-id="resultBox"]').classList.remove('slds-is-open');
            this.messageFlag = false; 
            this.LoadingText = false;
          
            this.currentText = '';
              
        }, 600);
           
         } else  this.setOutTime = 0;
     }

    onmouseover() {
        console.log('onmouse over');
        clearTimeout(this.setOutTime);
    }
    inblur() {
        console.log("In inblur");
        clearTimeout(this.setOutTime);
        this.template.querySelector('[data-id="resultBox"]').classList.toggle('slds-is-open');
        this.messageFlag = false; 
        this.LoadingText = false;
    }

    @wire(CurrentPageReference) pageRef;

    // set selected title id from look up search result
   setSelectedRecord(event) {
        this.selectRecordName = '';
        this.selectedTitle = event.currentTarget.dataset.martyid + ' - ' + event.currentTarget.dataset.name;
        var inputText = this.template.querySelector('[data-id="inputText"]');
        if(inputText)
            inputText.value = '';

        this.template.querySelector('[data-id="resultBox"]').classList.remove('slds-is-open'); //listboxId
    
        this.messageFlag = false; 
        let btnToggle;
        let tId = event.currentTarget.dataset.id;
        let isseries = event.currentTarget.dataset.isseries;
        let mId = event.currentTarget.dataset.martyid;
        let tName = event.currentTarget.dataset.name;
        let isinseries = event.currentTarget.dataset.isinseries;
        let fulltitlename = event.currentTarget.dataset.fulltitlename;
        console.log('martyiddd'+ event.currentTarget.dataset.martyid);
        if(event.currentTarget.dataset.martyid) {
            checkBtnsAccess({ tId: event.currentTarget.dataset.martyid, isSeries: isseries})
            .then(result => {
                if(result) {
                    btnToggle = result;
            console.log(JSON.stringify(result));
            console.log(mId);
            let selectWrp = {
                'Id' : tId,
                'MartyId' : mId,
                'fullTitleName' : fulltitlename,
                'isseries': isseries,
                'Name' : tName,
                'btnToggle' : btnToggle,
                'vendor' : this.vendor
               
        }
            console.log(selectWrp);
            fireEvent(this.pageRef, 'selectedtitle',selectWrp);
           
        
            }
            })
            .catch(error => {
            
                console.log('-------error-------------'+error);
                console.log(error);
            });
        }
        
            
      
    }

    
  }