/* eslint-disable no-alert */
/* eslint-disable @lwc/lwc/no-async-operation */
/* eslint-disable eqeqeq */
/* eslint-disable no-console */
import { LightningElement, api, track, wire } from 'lwc';
import getTransmittalData from '@salesforce/apex/PPW_transmittalController_lwc.getTrasmittalData';
import processConfirmation from '@salesforce/apex/PPW_transmittalController_lwc.processConfirmation';
import cometdlwc from "@salesforce/resourceUrl/CometD";
import uId from '@salesforce/user/Id';
import { loadScript } from "lightning/platformResourceLoader";
import getSessionId from '@salesforce/apex/PPW_transmittalController_lwc.getSessionId';
import resetChatterCount from '@salesforce/apex/PPW_transmittalController_lwc.resetChatterCount';
import { createMessageContext, releaseMessageContext,
    publish } from 'lightning/messageService';
import SAMPLEMC from "@salesforce/messageChannel/communityMessageChannel__c";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ppw_transmittalComponent extends LightningElement {

    predevWordCount; perWordFlg; amountWithRushFee; RushFee; CalculatedamountincludingRushFee;
    marketting_vendorManager; mboFee; baseAmount_flg; rate_flg; additionalRate; additionalRateInputMap; inputRateAmount_Flg;
    estimatedAdditionalRate; additionalRateInputVendor; additionalRateInputVendor_notOpen; customQuoteRateMultiplier;serviceName;
    statusOpen; statusNotOpen; statusReview; statusconfrim; esitmatedStartDate; currentTitle; cardHeaderText; rateAmount;
    psCurrency;additionalRateStringMap;additionalRateStringlabel;additionalRateOpPanel;
    footerDisplay; confirmExists; psStatus; removeStatusVals = 'Killed,Cancelled'; statusReviewTooltip;confirmationHistory;
    tableHeaders = ['Services','ASIN','ISBN-13','Publication Date','Trim Width','Trim Height','Interior Stock','Initial Page Count'];

    @track additionalRateStatus; vendorNoteRT; classStyleStatus; toolTipStatus; martyid; actualStartDate; actualCompleteDate; serviceBasedConfirmation;
    @track asign; estimatedEndDate; psId; cId; confirmationModal; digitalOrEbook; comboBxoClassName; servicePreData



    @track testval; v; c; serviceBasedCon;
    @track reviewReason = '';
    @track rejectionReason; transmittalData; additionalRateInput; customQuote;
    @track confirmationMap; selectedCon; selectConfirmationId; confirmations; requiredActionCon = []; requiredActionConExist; allConfirmExists;
    CofirmationsFlg; asignFormatFlg; additionalServiceFlg;
    @api title;
    @track hii; allRenderId;
    @api martyid;
    @api seriesId;
    @api vendor;
    context = createMessageContext();
    @api
    getTransmittalRecords() {
        console.log('getTransmittalRecords');
        console.log(JSON.stringify(this.title));
        this.seriesId = this.title ? this.title.isSeries=='true'? this.title.MartyId : null: null;
        getTransmittalData({
            titleId: this.martyid? this.martyid: this.title ? this.title.MartyId : null,
            seriesId: this.seriesId,
            v1: this.vendor? this.vendor: this.title ? this.title.urlParameters ? this.title.urlParameters.v : null : null

        }).then((data) => {
            if (data) {
                this.confirmations = [];
              //  this.tableHeaders = [];
                // this.CofirmationsFlg = false;
                console.log(JSON.stringify(data));
                let conMap = {}
                this.transmittalData = data;

                let serviceBaseLst = [];
                this.requiredActionCon = [];
                this.requiredActionConExist = false;
                this.allConfirmExists = false;
                if (this.transmittalData) {
                    this.currentTitle = this.transmittalData.currentTitle;
                    this.additionalRateStringMap = this.transmittalData.additionalRateStringMap; 
                  //  this.serviceName = this.transmittalData.serviceName;
                   // this.serviceBasedCon = this.transmittalData.serviceBasedCon;
                    if (this.transmittalData.serviceBasedMostActionCon) {
                        if (this.transmittalData.serviceBasedMostActionConMap)
                            for (let a in this.transmittalData.serviceBasedMostActionConMap)
                                if (a)
                                    for (let s1 in this.transmittalData.serviceBasedMostActionConMap[a])
                                        if (s1) {
                                            let c = this.transmittalData.serviceBasedMostActionConMap[a][s1];
                                            let con = {};
                                            // if(con) {
                                            con.cardHeaderText = 'card-header pointer-cursor-add' + c.Status__c == 'Open' ? 'bg-warning' : c.Status__c == 'Review Requested' ? 'bg-secondary text-white' : 'text-white';
                                            con.c = c;
                                            con.currentTitle = this.transmittalData.currentTitle
                                            con.statusOpen = c.Status__c == 'Open';
                                            con.statusReview = c.Status__c == 'Review Requested';
                                            con.statusconfrim = c.Status__c == 'Confirmed';
                                            con.footerDisplay = true;//(con.statusOpen || con.statusconfrim || ) remove hide footer functionality
                                            con.perWordFlg = c.Project_Services__r.Rate__r.Rate_Multiplier__c == 'Per Word';
                                            con.amountWithRushFee = (c.Project_Services__r.Base_Amount__c != null && (c.Project_Services__r.User_Input_Rate_Amount__c == null || c.Project_Services__r.User_Input_Rate_Amount__c == 0))
                                            con.RushFee = (c.Confirmed_Rush_Fee__c != null && c.Confirmed_Rush_Fee__c > 0 && (c.Project_Services__r.User_Input_Rate_Amount__c == null || c.Project_Services__r.User_Input_Rate_Amount__c == 0));
                                            console.log(c.Project_Services__r.Base_Amount__c);
                                            console.log(c.Project_Services__r.Rate_Amount__c);

                                            con.calculatedamountincludingRushFee = (c.Project_Services__r.Base_Amount__c != null && c.Project_Services__r.Rate_Amount__c != null);
                                            con.marketting_vendorManager = (c.Project_Services__r.User_Input_Rate_Amount__c != null && c.Project_Services__r.User_Input_Rate_Amount__c != 0);
                                            con.mboFee = (c.Confirmed_MBO_Fee__c != null && c.Confirmed_MBO_Fee__c != 0.00);
                                            con.esitmatedStartDate = c.Project_Services__r.Estimated_Start_Date__c != null;
                                            con.estimatedEndDate = c.Project_Services__r.Estimated_Completion_Date__c != null;
                                            con.actualStartDate = c.Project_Services__r.Actual_Start_Date__c != null;
                                            con.actualCompleteDate = c.Project_Services__r.Actual_Completion_Date__c != null;
                                            con.rateAmount = c.Project_Services__r.Rate_Amount__c != null;
                                            // con.perWordFlg = c.Project_Services__r.Rate__r.Rate_Multiplier__c == 'Per Word';
                                            console.log('c.Project_Services__r.Base_Amount__c' + c.Project_Services__r.Base_Amount__c);
                                            console.log('c.Project_Services__r.Rate_Amount__c' + c.Project_Services__r.Rate_Amount__c);
                                            //  con.CalculatedamountincludingRushFee_f = c.Project_Services__r.Base_Amount__c != null && c.Project_Services__r.Rate_Amount__c != null;
                                            con.vendorNoteRT = c.Project_Services__r.Vendor_Notes_RT__c != null;

                                            con.baseAmount_flg = c.Project_Services__r.Base_Amount__c != null;
                                            con.rate_flg = c.Project_Services__r.Rate__c != null;
                                            con.customQuote = 0;
                                            con.predevWordCount = (c.Project_Services__r.Status__c == 'In Planning' ? c.Project_Services__r.Word_Count_In_Planning__c :
                                                c.Project_Services__r.Status__c == 'Confirming' ? c.Project_Services__r.Word_Count_Confirming__c :
                                                    c.Project_Services__r.Status__c == 'Scheduled' ? c.Project_Services__r.Word_Count_Scheduled__c :
                                                        c.Project_Services__r.Status__c == 'Kicked Off' ? c.Project_Services__r.Word_Count_Kicked_Off__c :
                                                            c.Project_Services__r.Status__c == 'Completed' ? c.Project_Services__r.Word_Count_Completed__c :
                                                                c.Project_Services__r.Status__c == 'Cancelled' ? c.Project_Services__r.Word_Count_Cancelled__c : '');


                                            if (this.transmittalData.additionalRateInputMap_vendor) {
                                                console.log('rate' + c.Project_Services__r.Rate__c);
                                                console.log('stat' + c.Status__c);
                                                con.additionalRateInputVendor = (this.transmittalData.additionalRateInputMap_vendor[c.Project_Services__r.Rate__c] && c.Status__c == 'Open')
                                                con.additionalRateStatus = (this.transmittalData.additionalRateInputMap_vendor[c.Project_Services__r.Rate__c] && c.Status__c == 'Open');

                                                con.additionalRateInputVendor = (this.transmittalData.additionalRateInputMap_vendor[c.Project_Services__r.Rate__c] && c.Status__c == 'Open')
                                                con.additionalRateInputVendor_notOpen = (this.transmittalData.additionalRateInputMap_vendor[c.Project_Services__r.Rate__c] && c.Status__c != 'Open');
                                            }
                                            if (this.transmittalData.additionalRateInputMap) {
                                                con.additionalRate = (this.transmittalData.additionalRateInputMap[c.Project_Services__r.Rate__c] && (c.Project_Services__r.User_Input_Rate_Amount__c == null || c.Project_Services__r.User_Input_Rate_Amount__c == 0 || c.Project_Services__r.User_Input_Rate_Amount__c == undefined) && con.additionalRateInputVendor);
                                                console.log(this.transmittalData.additionalRateInputMap[c.Project_Services__r.Rate__c]);
                                                console.log(c.Project_Services__r.User_Input_Rate_Amount__c);
                                                console.log((c.Project_Services__r.User_Input_Rate_Amount__c == null || c.Project_Services__r.User_Input_Rate_Amount__c == 0));

                                            } con.servicePrep = this.transmittalData.servicePrepListsMap;
                                            con.subCatMap = this.transmittalData.subCatMap;
                                            if (this.transmittalData.subCatMap)
                                                if (this.transmittalData.subCatMap.length > 0)
                                                    this.servicePreData = false;
                                            con.statusScheduled = c.Project_Services__r.Status__c == 'Scheduled';
                                            if (this.transmittalData.additionalRateInputMap && c.Project_Services__r) {
                                                con.inputRateAmount_Flg = (this.transmittalData.additionalRateInputMap[c.Project_Services__r.Rate__c] && (c.Project_Services__r.User_Input_Rate_Amount__c == null || c.Project_Services__r.User_Input_Rate_Amount__c == 0));
                                                con.estimatedAdditionalRate = 'Estimated' + this.transmittalData.additionalRateInputMap[c.Project_Services__r.Rate__c] + 's';
                                            }

                                            if (c.Project_Services__r.Rate__r) {
                                                console.log('c.Project_Services__r' + c.Project_Services__r.Rate__r.Rate_Multiplier__c);
                                                con.customQuoteRateMultiplier = (c.Project_Services__r.Rate__r.Rate_Multiplier__c == 'Custom Quote');
                                            }
                                            if (con) {
                                                if (c.Project_Services__r.Status__c == 'Confirming') // get confirmation for most action required
                                                    this.requiredActionCon.push(con);
                                                else
                                                    serviceBaseLst.push(con);
                                                conMap[con.c.Id] = con;
                                            }

                                            // if(c.Project_Services__r.Status__c == 'Confirming') // get confirmation for most action required
                                            //   this.requiredActionCon.push(con);
                                            // asign format check
                                            if (this.transmittalData.formatListsMap) {
                                                console.log('asignFormatFlg&&' + this.transmittalData.formatListsMap.size);
                                                console.log('asignFormatFlg&&' + this.transmittalData.formatListsMap.length);
                                                for (let a in this.transmittalData.formatListsMap) {
                                                    this.asignFormatFlg = true;
                                                    break;
                                                }
                                            }
                                            // additional service flg check
                                            if (this.transmittalData.servicePrepListsMap) {
                                                console.log('additionalServiceFlg @@' + this.transmittalData.servicePrepListsMap.size);
                                                console.log('additionalServiceFlg @@' + this.transmittalData.servicePrepListsMap.length);
                                                for (let a in this.transmittalData.servicePrepListsMap) {
                                                    this.additionalServiceFlg = true;
                                                    break;
                                                }
                                            }

                                            //  }

                                        }
                        this.confirmationMap = conMap;
                    }
                    console.log('serviceBaseLst' + JSON.stringify(serviceBaseLst));
                    if (serviceBaseLst) {

                        this.confirmations = serviceBaseLst;
                       // this.allConfirmExists = true;
                        this.confirmationModal = true;
                        if (serviceBaseLst[0]) { // confirmation exist toggle
                            if (serviceBaseLst[0].c) {
                                this.confirmExists = true;
                            } else
                                this.confirmExists = false;
                        } else
                            this.confirmExists = false;
                        this.CofirmationsFlg = true;
                    } else
                        this.confirmExists = false;

                    if (this.requiredActionCon.length > 0) {
                        this.confirmExists = true; // make true when most action confirmation exists
                        this.requiredActionConExist = true;
                    }
                    if (this.confirmations.length > 0) {
                        this.confirmExists = true; // make true when most action confirmation exists
                        this.allConfirmExists = true;
                    }
                    // formate table
                   /* if (this.transmittalData.formatNameList) {
                        let x = this.value;
                        if (x.ASIN__c != null)
                            this.tableHeaders.push('ASIN');
                        if (x.ISBN_13__c != null)
                            this.tableHeaders.push('ISBN-13');
                        if (x.APub_Publish_Date__c != null)
                            this.tableHeaders.push('Publication Date');
                        if (x.Name == 'Paperback' || x.Name == 'Hardcover') {
                            if (x.Trim_Width__c != null)
                                this.tableHeaders.push('Trim Width');
                            if (x.Trim_Height__c != null)
                                this.tableHeaders.push('Trim Height');
                            if (x.Interior_Paper_Stock__c != null)
                                this.tableHeaders.push('Interior Stock');
                            if (x.Initial_Page_Count__c != null)
                                this.tableHeaders.push('Initial Page Count');
                        }


                    } */
                }

                let linput = document.createElement('html');
                // setTimeout(function() {
                linput.innerHTML = '<h1> hiii</h1>';//this.selectedCon.c.Project_Services__r.Vendor_Notes_RT__c;
                // alert('jooo');
                let vNote = this.template.querySelector('.vendorNotRT');

                if (vNote)
                    vNote.appendChild(linput);
                this.renderSelectConfirmation();
                console.log('this.requiredActionCon pavan' + JSON.stringify(this.requiredActionCon));
            }
          

        }).catch((error) => {
            console.log(error);
            //  this.message = 'Error received: code' + error.errorCode + ', ' +
            //   'message ' + error.body.message;
        });
    }

    resetCatterCount(psId) {
        resetChatterCount({psId: psId}).then((data)=> {

        }).catch((error)=> {

        });
    }

    @wire(getSessionId)
    wiredSessionId({ error, data }) {
     if (data) {
       console.log(data);
       this.sessionId = data;
       this.error = undefined;
       loadScript(this, cometdlwc)
       .then(() => {
        setTimeout(()=> { 
            this.initializecometd();
        
        }, 3000);
           
       });
   } else if (error) {
       console.log(error);
       this.error = error;
       this.sessionId = undefined;
     }
   }


   libInitialized = false;
   @track sessionId;
   @track error;
  
    
  initializecometd() {
    let self = this;
    if (this.libInitialized) {
      return;
    }
  
   this.libInitialized = true;
  
   //inintializing cometD object/class
   var cometdlib = new window.org.cometd.CometD();
          
  //Calling configure method of cometD class, to setup authentication which will be used in handshaking
    cometdlib.configure({
      url: window.location.protocol + '//' + window.location.hostname + '/cometd/47.0/',
      requestHeaders: { Authorization: 'OAuth ' + this.sessionId},
      appendMessageTypeToURL : false,
      logLevel: 'debug'
  });
  
  cometdlib.websocketEnabled = false;
  
  cometdlib.handshake(function(status) {
              
      if (status.successful) {
       
          // Successfully connected to the server.
          // Now it is possible to subscribe or send messages
          console.log('Successfully connected to server');
          cometdlib.subscribe('/event/User_Message__e', (message) => {
                    console.log('subscribed to message!'+ JSON.stringify(message));
                    let psid = message.data.payload.Project_ServiceId__c;
                    let loggedInUserid = message.data.payload.CreatedById;
                    console.log(psid);
                    let rActionCon = [];
                    if(self.requiredActionCon) {
                        self.requiredActionCon.forEach ((value) => {
                            if(value.c.Project_Services__r.Id == psid && uId != loggedInUserid) {
                                value.c.Project_Services__r.Chatter_Count_External__c = value.c.Project_Services__r.Chatter_Count_External__c? value.c.Project_Services__r.Chatter_Count_External__c+1: 1;
                                rActionCon.push(value);
                            } else rActionCon.push(value);
                          
                          })
                      
                    }
                


                    self.requiredActionCon = rActionCon;
                    rActionCon = []
                    if(self.confirmations) {
                        self.confirmations.forEach ((value) => {
                            if(value.c.Project_Services__r.Id == psid && uId != loggedInUserid) {
                                value.c.Project_Services__r.Chatter_Count_External__c = value.c.Project_Services__r.Chatter_Count_External__c? value.c.Project_Services__r.Chatter_Count_External__c+1: 1;
                                rActionCon.push(value);
                            } else rActionCon.push(value);
                          
                          })

                    }
                    self.confirmations = rActionCon;

                  //  console.log('self.requiredActionCon 456' + JSON.stringify(self.requiredActionCon));
                  
         });
      } else {
          /// Cannot handshake with the server, alert user.
          console.error('Error in handshaking: ' + JSON.stringify(status));
       }
     });
    }
  


    pushNotification(e) {
        let psid = e.target.name;
        console.log(psid);
        const message = {
            recordId: psid,
            
        };
        publish(this.context, SAMPLEMC, message);
        let rActionCon = []
        if(this.confirmations) {
            this.confirmations.forEach ((value) => {
                if(value.c.Project_Services__r.Id == psid) {
                    this.resetCatterCount(psid);
                    value.c.Project_Services__r.Chatter_Count_External__c = null;
                    rActionCon.push(value);
                } else rActionCon.push(value);
              
              })
              this.confirmations = rActionCon;
        }
     

        rActionCon = []
        if(this.requiredActionCon) {
            this.requiredActionCon.forEach ((value) => {
                if(value.c.Project_Services__r.Id == psid) {
                    this.resetCatterCount(psid);
                    value.c.Project_Services__r.Chatter_Count_External__c  = null;
                    rActionCon.push(value);
                } else rActionCon.push(value);
              
              })
              this.requiredActionCon = rActionCon;
        }
      


    }

    // close confirmation history modal
    closeModal() {
        console.log('hihi');
        this.selectConfirmationId = null;
        this.confirmationHistory = false;
    }

    // auto close modal stop propagation
    stopPropagation(event) {
        event.stopPropagation();
    }

    closeModal1() {
       
        this.selectConfirmationId = null;
    }



    // close change view for close modal
    closeModalClass() { //slds-box slds-box_x-small 
        //  this.template.querySelector('[data-id="closeModal1"]').classList.toggle('slds-is-open');
        this.template.querySelector('[data-id="closeModal1"]').classList.add('slds-box slds-box_x-small');
    }
    onReject() {
        setTimeout(() => {

            this.template.querySelector('[data-id="rejectMenu"]').classList.toggle('slds-is-open');// slds-is-open
        }, 150);

    }

    showToolTip() {
        this.statusReviewTooltip =  true;
        console.log('show'+ this.statusReviewTooltip);
    }

    HideToolTip() {
        this.statusReviewTooltip =  false;
        console.log('show'+ this.statusReviewTooltip);
    }

    onReview() {
        setTimeout(() => {
            console.log('reivew');
            this.template.querySelector('[data-id="rejectMenu1"]').classList.toggle('slds-is-open');// slds-is-open
        }, 150);


    }
    selectConfirmation(e) {
        // e.stopPropagation();
        console.log('e.target.key' + JSON.stringify(e.currentTarget.id));
        let selectedConId = e.currentTarget.id.trim().substring(0, 18);
        console.log('this.confirmationMap' + this.confirmationMap);
        if (this.confirmationMap && selectedConId) {
            this.selectedCon = this.confirmationMap[selectedConId];
            this.psId = this.selectedCon.c.Project_Services__c;
            this.psStatus = this.selectedCon.c.Project_Services__r.Status__c;
            
            console.log(this.selectedCon); 
            console.log(this.selectedCon.c.Project_Services__r.Rate__r.Rate_Currency__c); 
            this.psCurrency = (this.selectedCon.c.Project_Services__r.Rate__r.Rate_Currency__c=='USD'?'$': 
            (this.selectedCon.c.Project_Services__r.Rate__r.Rate_Currency__c=='EUR'?'€': 
            (this.selectedCon.c.Project_Services__r.Rate__r.Rate_Currency__c=='GBP'?'£': 
            (this.selectedCon.c.Project_Services__r.Rate__r.Rate_Currency__c=='JPY'?'¥' :'') 
            ))) 
            console.log(this.psCurrency); 
            this.additionalRateStringlabel = 'Estimated ' +(this.additionalRateStringMap?this.additionalRateStringMap[this.selectedCon.c.Project_Services__r.Rate__c]+'s':'') 
            this.additionalRateOpPanel = this.selectedCon.c.Status__c != 'Open' && !this.selectedCon.additionalRate 
            this.cId = this.selectedCon.c.Id;
            console.log('selected' + JSON.stringify(this.selectedCon));
            this.selectConfirmationId = selectedConId;

            let linput = document.createElement('html');
            // setTimeout(function() {
            linput.innerHTML = '<h1> hiii</h1>';//this.selectedCon.c.Project_Services__r.Vendor_Notes_RT__c;

            let vNote = this.template.querySelector('.vendorNotRT');

            if (vNote)
                vNote.appendChild(linput);

            console.log(this.selectConfirmationId);
            this.allRenderId = 'HIIII';
            //  }, 30);
        }
        let review = this.template.querySelector('[data-id="reviewStatusDis"]');
        if(review)
            review.disabled = true;
        // this.hii = selectedConId;

    }

    renderedCallback() {
        const style = document.createElement('style');
        style.innerText = `.slds-button_icon {
            position: absolute !important;
            vertical-align: top !important;
            top: 0px !important;
            margin-left: 5px !important;
        
        } `;
        
       let lh = this.template.querySelector('lightning-helptext');
       if(lh)
            lh.appendChild(style);
    }
    renderSelectConfirmation() {

        if (this.confirmationMap && this.selectConfirmationId) {
            this.selectedCon = this.confirmationMap[this.selectConfirmationId];
            this.psStatus = this.selectedCon.c.Project_Services__r.Status__c;
            // alert(this.psStatus);
            this.template.querySelector('c-apub_status-path-panel').changeCurrentStatus(this.psStatus);
        }

    }

    cancelHistory() {
        console.log(this.template.querySelector('[data-id="historyModal"]'));
        // this.template.querySelector('[data-id="historyModal"]').classList.toggle('slds-is-open');
        this.confirmationModal = false;
    }


    valueChange(e) {
        this[e.target.name] = e.target.value;
        let reject = this.template.querySelector('[data-id="rejectR"]');
        let review = this.template.querySelector('[data-id="reviewR"]');

        if (e.target.value) {
            if (reject)
                reject.disabled = false;
            if (review)
                review.disabled = false;
        } else {
            if (reject)
                reject.disabled = true;
            if (review)
                review.disabled = true;
        }

    }

    hideDropDown(event) {
        console.log('hide');
        console.log(event.target.name);

        // setTimeout(() => {
        if (!event.target.name) {
            let rejectMenu = this.template.querySelector('[data-id="rejectMenu"]');
            let rejectMenu1 = this.template.querySelector('[data-id="rejectMenu1"]');
            if (rejectMenu)
                rejectMenu.classList.remove('slds-is-open');// slds-is-open
            if (rejectMenu1)
                rejectMenu1.classList.remove('slds-is-open');// slds-is-open
            this.reviewReason = null;
            // this.valueChange = null;
        }
        //  }, 50);
        // }

    }
    openConhistory(e) {
        console.log('openconfirmation');
    this.confirmationHistory = true;
    setTimeout(() => {
    this.template.querySelector('c-ppw_transmittal-conf-history').getServiceBasedConfirmation();
    }, 100);
  
    }

    onActionService(e) {

        this.template.querySelector('[data-id="censhareId"]').classList.toggle('slds-hide');
        let confirmChoice = e.target.name;
        let rejectMenu = this.template.querySelector('[data-id="rejectMenu"]');
        let rejectMenu1 = this.template.querySelector('[data-id="rejectMenu1"]');
        if (rejectMenu)
            rejectMenu.classList.remove('slds-is-open');// slds-is-open
        if (rejectMenu1)
            rejectMenu1.classList.remove('slds-is-open');// slds-is-open
        console.log('rejectMenu' + rejectMenu);
        let wrap = {
            psId: this.psId, cId: this.selectConfirmationId, confirmChoice: confirmChoice, rejectionReason: this.rejectionReason,
            additionalRateInput: this.additionalRateInput, customQuote: this.customQuote, reviewReason: this.reviewReason
        }
        let serviceReq = JSON.stringify(wrap);
        processConfirmation({
            serviceReq: serviceReq


        }).then((data) => {
            this.template.querySelector('[data-id="censhareId"]').classList.toggle('slds-hide');
            if (data) {
                console.log(JSON.stringify(data));
                if (data.resStatus) {
                    this.showToast('Confirmation Status', 'Confirmation Status update successfully', 'success');

                } else {
                    this.showToast('Confirmation Status', 'Confirmation Status update falied', 'error');


                }


                this.getTransmittalRecords();


                if (confirmChoice == 'reject') {
                    this.selectConfirmationId = null;
                }

            }
        }).catch((error) => {
            console.log(error);

        });
    }

    showToast(title, message, type) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: type
        });
        this.dispatchEvent(event);
    }


}