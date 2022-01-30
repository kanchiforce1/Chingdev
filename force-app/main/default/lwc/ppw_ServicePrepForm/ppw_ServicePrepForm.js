import { LightningElement,track,api,wire } from 'lwc';
import getServicePrepList from '@salesforce/apex/PPW_ServicePrepFormController_lwc.PPW_ServicePrepFormController_lwc1';
import saveForm1 from '@salesforce/apex/PPW_ServicePrepFormController_lwc.saveForm1';
import createupdatePs from '@salesforce/apex/PPW_ServicePrepFormController_lwc.createupdatePs';
import censhareCalloutStatus from '@salesforce/apex/PPW_ServicePrepFormController_lwc.censhareCalloutStatus';
import createCaseMethod from '@salesforce/apex/PPW_ServicePrepFormController_lwc.createCaseMethod';
//import servicePrepForm from '@salesforce/apex/PPW_ServicePrepFormController_lwc.servicePrepForm';

import { ShowToastEvent } from 'lightning/platformShowToastEvent'
export default class ModalPopupLWC extends LightningElement {
    // recordId = 'a041H00000umTcjQAE';
     @api recordId;
     @api series;
    @track lwcResponseWrp;saveQuestionsResponse={};
    acqQustionsCount;ediQustionsCount;desQustionsCount;
    error;servicePrepId;acqSubCat;acquisitionQuestion;desSubCat;DesignSQuestion;ediSubCat;EditorialSQuestion;
    createPsServicesMap = {};updatePservicesMap;projectId;updatePsList = {};cancelPsList = [];servicePrepformList=[]
    selectedName = 'Acquisition';selectedQuestions;serTypeSubQuestionsMap;
    acqQustionsResMap;literayformPsservices=[];createCaseTitle = {};
    serTypeSubQuestionsOrderMap;questionStaticMap={}
    servicePrepForm;isEnabledForm=true;btnName;renderedOnce;
    isModalconfirm=false;isModalValid=false;
    questionsFillMes;createPSConfirmMes;
    connectedCallbakcRender=false;
    sendRequest={}

    closeModal() {
        console.log('close modal');
        this.isModalconfirm = false;
        this.isModalValid = false;
    }

    // connected call   back life cycle hook method
    connectedCallback() {
        if(this.series) {
            this.isEnabledForm = false;
            this.setSpinner(false);
            return ;
        }
        this.setSpinner(true);
        getServicePrepList({ Sid1 : this.recordId?  this.recordId : 'a041H00000pWNXZQA4'})
        .then((data) => {
          
            this.lwcResponseWrp = data;
            this.acqSubCat = data.acqSubCat;
            this.acquisitionQuestion = data.acquisitionQuestion;
            this.desSubCat = data.desSubCat;
            this.DesignSQuestion = data.DesignSQuestion;
            this.ediSubCat = data.ediSubCat;
            this.EditorialSQuestion = data.EditorialSQuestion;
          //  this.activeServices = data.services
         //   this.selectedQuestions = data.acquisitionQuestion;
            this.serTypeSubQuestionsMap = data.serTypeSubQuestionsMap;
          this.servicePrepForm = data.serPrep[0];
          this.projectId = this.servicePrepForm.Project__c;
          this.servicePrepId = this.servicePrepForm.Id;

            this.getQuestionStaticIds();

            console.log('data' + JSON.stringify(this.lwcResponseWrp));
            console.log('data' + JSON.stringify(data.serPrep[0]));

            this.error = undefined;
            var isacq = this.template.querySelector('[data-id="isacq"]');
            var isdes = this.template.querySelector('[data-id="isdes"]');
            var isedi = this.template.querySelector('[data-id="isedi"]');


          


        if(this.selectedName == 'Acquisition') {
               if(isacq)
                isacq.style.display = 'inline';
                if(isdes)
                isdes.style.display = 'none';
                if(isedi)
                isedi.style.display = 'none';
          
        }
       if(!this.connectedCallbakcRender)
            this.setSpinner(false);
        })
        .catch((error) => {
            alert(this.recordId);
            alert(JSON.stringify(error));
            this.setSpinner(false);
            this.isEnabledForm = false;
            this.error = error;
            this.lwcResponseWrp = undefined;
        });
      
    }

    setSpinner(d) {
        var selectedEvent = new CustomEvent('spinner', { detail: {display: d, slastmodifiedBy: this.servicePrepForm? this.servicePrepForm.LastModifiedBy.Name:null, 
                                                                            slastmodifiedDate: this.servicePrepForm? this.servicePrepForm.LastModifiedDate: null} });
        this.dispatchEvent(selectedEvent);
            
    }
// render call standard lify cycle hook method
    renderedCallback() {
      
            const style = document.createElement('style');
           style.innerText = ` button[title="Save Service Prep"] {
                width: 100%;
                margin: 3px 0px 5px 2px; 
             
             }
             button[title="Create Services"] {
                width: 100%;
                margin: 3px 0px 5px 2px; 
             
             }
           
             button[title="Review and Complete"] {
                width: 100%;
                margin: 3px 0px 5px 2px; 
             
             }`
         
           const savesPrep =  this.template.querySelector('[data-id="savesPrep"]');
           if(savesPrep) {
               if(!this.renderedOnce)
                savesPrep.appendChild(style);
               
           }
           const create = this.template.querySelector('[data-id="create"]');
          if(create){
              if(!this.renderedOnce)
                create.appendChild(style);
                this.createPsbtnDisableAction(create);
            this.renderedOnce = true;
          }
    
        console.log('render call back service prep form');
      //  console.log(JSON.stringify(this.acquisitionQuestion));
        var acqQustionsResMap = {}
       
        if(this.acquisitionQuestion) 
            for(var a in this.acquisitionQuestion) 
                for(var b in this.acquisitionQuestion[a]) {
       
                 
                    var acq = this.acquisitionQuestion[a][b].serPrepQuestion;
                
                        if(!acq.Service_Prep_Parent_Question__c) {
                           
                                acqQustionsResMap[acq.Id] = acq.Service_Prep_Responses__r[0]? acq.Question_Type__c == 'Number' ? acq.Service_Prep_Responses__r[0].Response_Number__c : (acq.Question_Type__c == 'Checkbox' ? acq.Service_Prep_Responses__r[0].Response__c == 'true' ? acq.Service_Prep_Responses__r[0].Response__c : undefined : acq.Service_Prep_Responses__r[0].Response__c): undefined;
                            
                            var subQus = this.serTypeSubQuestionsMap[acq.Id];
                            console.log(JSON.stringify(subQus));
                            for(var sq in subQus) {
                                if(subQus[sq].Question_Category__c == 'Acquisition')
                                if(subQus[sq].Service_Prep_Responses__r[0]) {
                                    if(subQus[sq].Question_Type__c == 'Number') {
                                        if(subQus[sq].Service_Prep_Responses__r[0].Response_Number__c)
                                            acqQustionsResMap[subQus[sq].Id] = subQus[sq].Service_Prep_Responses__r[0].Response_Number__c;
                                    } else  if(subQus[sq].Service_Prep_Responses__r[0].Response__c)
                                                acqQustionsResMap[subQus[sq].Id] = subQus[sq].Service_Prep_Responses__r[0].Response__c;
                                    }
                                }
                            }
                            
                            this.onselectvalue(acq);
                        }

                
                this.acqQustionsResMap = acqQustionsResMap;
            if( this.DesignSQuestion) 
            for(var a in this.DesignSQuestion) 
                for(var b in this.DesignSQuestion[a]) {
                  
                this.onselectvalue( this.DesignSQuestion[a][b].serPrepQuestion);
            }
            if(this.EditorialSQuestion) 
            for(var a in this.EditorialSQuestion) 
                for(var b in this.EditorialSQuestion[a]) {
                    
                this.onselectvalue(this.EditorialSQuestion[a][b].serPrepQuestion);
            }
           // this.setSpinner(false);
    }

    createPsbtnDisableAction(create) {
        //this.servicePrepForm.Acquistion_Tab_Static__c
        if(this.servicePrepForm) {
            if(this.selectedName == 'Acquisition') {
                if(this.servicePrepForm.Acquistion_Tab_Static__c)
                    create.disabled = true;
                else   create.disabled = false;  
            }     
            if(this.selectedName == 'Design') {
                if(this.servicePrepForm.Design_Scheduling_Tab_Static__c || this.servicePrepForm.Acquistion_Tab_Static__c==false)
                    create.disabled = true;
                else   create.disabled = false; 
            }
            if(this.selectedName == 'Editorial') {
                if(this.servicePrepForm.Editorial_Tab_static__c || this.servicePrepForm.Acquistion_Tab_Static__c==false)
                    create.disabled = true;
                else   create.disabled = false; 
            }
        }
    }

// onload sub questions load
    onselectvalue(serPrep) {
       
        if(!serPrep.Service_Prep_Parent_Question__c && serPrep.Service_Prep_Responses__r) {
            var value = (serPrep.Question_Type__c == 'Number'? serPrep.Service_Prep_Responses__r[0].Response_Number__c: serPrep.Service_Prep_Responses__r[0].Response__c);
            
    
    if(value)
            value = value.toString();
// console.log(JSON.stringify(value));
        var displayOrd = [];
        var nodisplayOrd = [];
        var detailParams = { value: '', displayOrd: [], nodisplayOrd: [] }
     //   console.log(value);
        if(!serPrep.Service_Prep_Parent_Question__c) {
            if(serPrep.Sub_Question_Render__c) {
            
                if(serPrep.Sub_Question_Render__c.includes(';')) {
                    let sub = serPrep.Sub_Question_Render__c.split(';');
                    for(var b in sub) 
                        displayOrd = this.displayOrder(sub[b].split('='),value, displayOrd);
                
                  //  console.log(JSON.stringify(displayOrd))
                    for(var b in sub) {
                            var ord = sub[b].trim().split('=');
                            nodisplayOrd = this.nodisplayOrder(ord,value,displayOrd, nodisplayOrd);
                        }
            
                
                } else {
                    let sub = serPrep.Sub_Question_Render__c;
                    var ord = sub.split('=');
                    displayOrd = this.displayOrder(ord,value, displayOrd);
                    nodisplayOrd = this.nodisplayOrder(ord,value,displayOrd, nodisplayOrd);
                
                }

            }

        }

        // change value by question type
    
        detailParams.id = serPrep.Id;
        detailParams.value = value;
        detailParams.response = serPrep.Service_Prep_Responses__r[0].Id;
        detailParams.questionType = serPrep.Question_Type__c;
        detailParams.displayOrd = displayOrd;
        detailParams.nodisplayOrd = nodisplayOrd;
        //console.log(JSON.stringify(detailParams));


        const details = detailParams;//.order.toString();
        const displayorders = details.displayOrd.toString();
        const nodisplayorders = details.nodisplayOrd.toString();
        const disord = displayorders? displayorders.includes(',')? displayorders.split(','): displayorders: null;
        const nodisord = nodisplayorders? nodisplayorders.includes(',')? nodisplayorders.split(','): nodisplayorders: null;

    //  var self = this;
        if(this.serTypeSubQuestionsMap) {
            var squs = this.serTypeSubQuestionsMap[details.id];
            
            if(squs) {
                for(var a in squs) {
                    var ordFixed = squs[a].Order__c.toFixed(2);
                    if(disord) {
                        if(disord.includes(ordFixed.toString())) {
                        
                            var serq = this.template.querySelectorAll('c-ppw_-service-prep-quesions');

                            for(var i =0; i<serq.length; i++) {
                                if(squs[a].Question_Category__c == 'Acquisition') {
                                    if(squs[a].Service_Prep_Responses__r[0].Question_Type__c == 'Number')
                                        this.acqQustionsResMap[squs[a].Id] = squs[a].Service_Prep_Responses__r[0].Response_Number__c;
                                    else {
                                        if(squs[a].Service_Prep_Responses__r[0].Question_Type__c == 'Checkbox')
                                            this.acqQustionsResMap[squs[a].Id] = squs[a].Service_Prep_Responses__r[0].Response__c == true? squs[a].Service_Prep_Responses__r[0].Response__c : undefined; 
                                        else
                                            this.acqQustionsResMap[squs[a].Id] = squs[a].Service_Prep_Responses__r[0].Response__c; 
                                    }
                                }
                                serq[i].onQuestionValue1(squs[a].Id, 'inline');
                                serq[i].renderQuestionStatic();// question static onload and rerender
                            }
                        } 
                    }
                
                    }  
                }
            } 
        
        } 
                
    
    }

    showToast(title,mes,variant,mode) {
        // sticky ,info (default), success, warning, and error.
        const event = new ShowToastEvent({
            title: title,
            message: mes,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(event);
    }


// make orders as a list for display sub questions
displayOrder(ord,value,displayOrd) {
  
    if(ord)
    if(value) {
        var v = value? value.includes(',')? value.split(',').includes(ord[0].trim()): value == ord[0].trim() : false;
    if(v) {
        if(ord[1])
        if(ord[1].includes(',')) {
            if(ord[1].split(','))
                ord[1].split(',').forEach( elem => {
                displayOrd.push(elem);
            });
            } else
                displayOrd.push(ord[1]);    
           
        }
    }
    return displayOrd;
}

// make orders as a list for hide sub questions
nodisplayOrder(ord,value,displayOrd,nodisplayOrd ) {
                
    if(ord) {
        if(value) {
            var v = value? value.includes(',')? value.split(',').includes(ord[0].trim()): value == ord[0].trim() : false;
           // console.log(JSON.stringify(v));
            if(v) {
                nodisplayOrd = this.noDisplaySplitOrders(ord,displayOrd,nodisplayOrd);
            } else
                nodisplayOrd = this.noDisplaySplitOrders(ord,displayOrd,nodisplayOrd);    
            } else nodisplayOrd = this.noDisplaySplitOrders(ord,displayOrd,nodisplayOrd);

    
    }
        return nodisplayOrd;
}

// make sub question hide check
noDisplaySplitOrders(ord,displayOrd,nodisplayOrd) {
    if(ord[1]) {
        if(ord[1].includes(',')) {
            let itms = ord[1].split(',');

        if(itms)
        itms.forEach( elem => {
            if(displayOrd)
            if(!displayOrd.includes(elem))
                nodisplayOrd.push(elem);
        });
            }    else {
                if(displayOrd)
                if(!displayOrd.includes(ord[1]))
                    nodisplayOrd.push(ord[1]);
            }
        }
        return nodisplayOrd;
}

// this is event method which is calling from service prep question sub component
    async onServicePrep(e) {
        this.setSpinner(true);
        console.log(e.target.title);
        const btnName = e.target.title;
        this.btnName = btnName;
        const sendRequest = {}
        var sPrepform = { 'sobjectType': 'Service_Prep__c',
        'Id': this.servicePrepId
       
        };
        sendRequest.selectedName = this.selectedName;
        sendRequest.saveQuestionsResponse = this.saveQuestionsResponse;
        sendRequest.newPss = this.createPsServicesMap;
        sendRequest.updatePss = this.updatePsList;
        sendRequest.cancelPs = this.cancelPsList;
        sendRequest.acqQustionsResMap = this.acqQustionsResMap;
        sendRequest.createCaseTitle = this.createCaseTitle;
        sendRequest.projectId = this.projectId;
        sendRequest.sPrepform = sPrepform;

       
        console.log(JSON.stringify(sendRequest));

      
        if(this.selectedName == 'Acquisition')
   

       sendRequest.selectedName = this.selectedName;
        console.log(btnName);
        console.log(this.selectedName);
        if(btnName == 'Save Service Prep') {
            if(this.selectedName == 'Acquisition') {
              await this.saveQuestions(sendRequest);
            //  await this.connectedCallback();
              await this.setSpinner(false);
              await this.showToast('Acquisition', 'Responses to the Service Prep Questions have been saved successfully.','sticky', 'success');
            }
            if(this.selectedName == 'Design') 
                await this.designTabActions(sendRequest);
            if(this.selectedName == 'Editorial') 
               await this.editorialTabActions(sendRequest);
 
             
        }
        if(btnName == 'Create Services' || btnName == 'Review and Complete') {
            if(this.selectedName == 'Acquisition') {
                var acqvalidate;
                for(var a in this.acqQustionsResMap) {
                   if(!this.acqQustionsResMap[a]) {
                       acqvalidate = false;
                        break;
                    } else  acqvalidate = true;
                }
                
                if(acqvalidate === true) {
                    this.isModalconfirm = true;
                    this.sendRequest = sendRequest;
                    this.questionsFillMes = 'Clicking OK will finalize the questions and make the Acquisition Section read-only. Confirm your answers are correct before clicking OK.';
                    } else {
                        this.isModalValid = true;
                        this.questionsFillMes = 'please fill questions';
                    }
                      //  this.showToast('acquestion', 'please fill questions','sticky', 'warning');
                    await this.setSpinner(false);  
            }
             
             if(this.selectedName == 'Design') 
                await this.designTabActions(sendRequest);
                if(this.selectedName == 'Editorial') 
                await this.editorialTabActions(sendRequest);
 

        }
}
   async onProceed() {
        await this.setSpinner(true);  
       // sPrepform.Acquistion_Tab_Static__c = true;
        this.sendRequest.Acquistion_Tab_Static__c = true;
       await this.acquestionTabActions(this.sendRequest);
       await this.closeModal();
}


// design tab button actioon
   async designTabActions(sendRequest) {
        await this.saveQuestions(sendRequest);
        await this.createUpdatePs(sendRequest);
        await this.showToast('Acquisition', 'Responses to the Service Prep Questions have been saved successfully.','sticky', 'success');
       // await this.setSpinner(false);
    }
// acquestion tab button actioon
   async acquestionTabActions(sendRequest) {
         await this.createUpdatePs(sendRequest);
         await this.showToast('Acquisition', 'PS are created','sticky', 'success');
       //  await this.setSpinner(false);
        }
// editorial tab button actioon
   async editorialTabActions(sendRequest) {
        await this.saveQuestions(sendRequest);
        await this.createUpdatePs(sendRequest);
        await this.showToast('Acquisition', 'All questions answers has been saved and ps are created','sticky', 'success');
      //  await this.setSpinner(false);
    }
    // save questions method
   async saveQuestions(sendRequest) {
       
        console.log('sendRequest' + JSON.stringify(sendRequest));
       await saveForm1({ saveQuestionsResponse : sendRequest.saveQuestionsResponse})
       
   
    }
// create ps apex call back method
   async createUpdatePs(sendRequest) {
       //// this.setSpinner(true);
      const data = await createupdatePs({ request : JSON.stringify(sendRequest)})
        
                await   this.createCaseCallBack();
                await   this.censhareCalloutStatus(data.censhareNewPs); 
      
  
    }
   async createCaseCallBack() {
      
            if(this.createCaseTitle)
           await createCaseMethod({ casetitles : this.createCaseTitle});
          
        
    }

    questionStaticLogic(serPrepQuestion) {
        console.log('serPrepQuestion123'+ JSON.stringify(serPrepQuestion));
        if(serPrepQuestion.Service_Prep_Responses__r)
        return serPrepQuestion.Transmittal_Mapping__c? false: (serPrepQuestion.Service_Prep_Responses__r[0].Question_Static__c || 
            (serPrepQuestion.Question_Category__c == 'Acquisition' ? this.servicePrepForm.Acquistion_Tab_Static__c : 
            (this.servicePrepForm.Acquistion_Tab_Static__c == false? true :
             (serPrepQuestion.Question_Category__c == 'Editorial Scheduling'? 
             this.servicePrepForm.Editorial_Tab_static__c : 
             this.servicePrepForm.Design_Scheduling_Tab_Static__c))));
            return false;
    }
getQuestionStaticIds() {
    console.log('getQuestionStaticIds');
 
      var questionStaticMap = {}
   
      if(this.acquisitionQuestion) 
          for(var a in this.acquisitionQuestion) 
              for(var b in this.acquisitionQuestion[a]) {
                    var acq = this.acquisitionQuestion[a][b].serPrepQuestion;
                    questionStaticMap[acq.Id] = this.questionStaticLogic(acq);
                    
                      }

          if(this.DesignSQuestion) 
          for(var a in this.DesignSQuestion) 
              for(var b in this.DesignSQuestion[a]) 
                questionStaticMap[this.DesignSQuestion[a][b].serPrepQuestion.Id] = this.questionStaticLogic(this.DesignSQuestion[a][b].serPrepQuestion);
       
          if(this.EditorialSQuestion) 
          for(var a in this.EditorialSQuestion) 
              for(var b in this.EditorialSQuestion[a])
                questionStaticMap[this.EditorialSQuestion[a][b].serPrepQuestion.Id] = this.questionStaticLogic(this.EditorialSQuestion[a][b].serPrepQuestion);
       
          this.questionStaticMap = questionStaticMap;
         // console.log('questionStatic1234'+ JSON.stringify(questionStaticMap));
}


    // create ps apex call back method
   async censhareCalloutStatus(censhareNewPs) {
    this.connectedCallbakcRender = true;
     //this.btnName
       const data = await censhareCalloutStatus({cTab: this.selectedName, censhareNewPs: censhareNewPs , btnName: this.btnName, servicePrepId: this.servicePrepId});
       
            if(data) {
                console.log('call out status' +JSON.stringify(data));
                    if(data.pollerEnabled) {
                        setTimeout(() =>{ 
                            this.censhareCalloutStatus(censhareNewPs);
                        }, 3000);
                     } else {
                       
                       await this.connectedCallback();

                       new Promise((resolve, reject) =>{
  
                        // Setting 2000 ms time
                       // setTimeout(resolve, 2000);

                        setTimeout(() => {  
                            console.log('set timeout question static render');
                            var serq = this.template.querySelectorAll('c-ppw_-service-prep-quesions');
                                
                            for(var i =0; i<serq.length; i++) {
                            if(serq[i]) {
                                    serq[i].questionStaticMap = this.questionStaticMap;
                                    serq[i].renderQuestionStatic();
                                }
                            }
                           
                            resolve();
                            
                        }, 3000);




                    }).then(() =>{
                        //setTimeout(() => {
                            console.log("Wrapped setTimeout after 2000ms");  
                            this.setSpinner(false);
                            this.getrefreshpanels();
                       // }, 100);
                        
                    });
                }
            }
      
  
    }


    // event method when question answer from grand child component
    answeredQuestion(e) {
       const details = e.detail;
       console.log(JSON.stringify(details));
       const qId = details.details.id;
       const value = details.details.value;
       const qType = details.details.questionType;
       const resId = details.details.response;
       console.log(JSON.stringify(resId));
       console.log(JSON.stringify(qId));
       var response = { 'sobjectType': 'Service_Prep_Response__c',
                             'Id': resId,
                             'Response__c': null,
                             'Response_Number__c': null,
                       };
                   
                       var newPSs = { 'sobjectType': 'Project_Services__c',
                      
                       'Project__c': this.projectId,
                       'Service__c': null
                 };
      
       if(qType == 'Number') 
            response.Response_Number__c = value;
       else 
            response.Response__c = value;

            response.Question_Static__c = this.selectedName != 'Acquisition'? true : false;
      
            if(this.selectedName == 'Acquisition') 
               
                    this.acqQustionsResMap[qId] = value;
           
           var services;
          
            var createPsservices = this.getServiceIdsForCreatePs(value,details.details.questionDetils);
            var updatePsservices = this.getServiceIdsForUpdatePs(value,details.details.questionDetils);
            var cancelPsservices = this.getServiceIdsForCancelPs(value,details.details.questionDetils);
            var literayformPsservices = this.createPSLogicFormLiterary_Form(details.details.questionDetils.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r.Literary_Form__c,value,details.details.questionDetils);
            this.createCreateCase(value,details.details.questionDetils);

           console.log('literayformPsservices' +JSON.stringify(literayformPsservices));
           console.log('createCaseTitle' +JSON.stringify(this.createCaseTitle));

            if(createPsservices) 
            for(var a in createPsservices) {
                let s = createPsservices[a].trim();
                newPSs.Service__c = s;
                this.createPsServicesMap[s] = newPSs;
            }
            if(literayformPsservices) 
            for(var a in literayformPsservices) {
                let s = literayformPsservices[a];
                newPSs.Service__c = s;
                this.createPsServicesMap[s] = newPSs;
            }
            if(updatePsservices)  
            for(let a in updatePsservices)
                this.updatePsList[a] = updatePsservices[a];
             
                if(cancelPsservices) 
                for(var a in cancelPsservices) {
                    let s = cancelPsservices[a].trim();
                    this.cancelPsList.push(s);
                }

        this.saveQuestionsResponse[resId] = response;
        console.log(JSON.stringify(this.saveQuestionsResponse));
        console.log(JSON.stringify(this.createPsServicesMap));
        if(details.sid) {
        var serq = this.template.querySelectorAll('c-ppw_-service-prep-quesions');
    
            for(var i =0; i<serq.length; i++) {
                if(this.selectedName == 'Acquisition') {
                    if(details.s == 'inline')
                        this.acqQustionsResMap[details.sid] = undefined;
                    else
                        delete this.acqQustionsResMap[details.sid];
                   
                }
                serq[i].onQuestionValue1(details.sid, details.s);
            }
        }
              
    }

    //create ps logic form literay from title field
    createCreateCase(response,serPrepQuestion) {
          /**  Create Case from title  **/ 
         // var createCaseTitle = {}
                console.log(response);
                console.log(JSON.stringify(serPrepQuestion));
                var question = { 'sobjectType': 'Service_Prep_Question__c'};
          if(serPrepQuestion.Create_Case__c)
            if(response) {
               var title = serPrepQuestion.Service_Prep_Responses__r[0].Service_Prep__r.Project__r.Title__r;
                if(response.includes('No') && title.Internal_Imprint__c!='Two Lions') {
                    question.Id = serPrepQuestion.Id;
                    question.Question_Category__c = serPrepQuestion.Question_Category__c;
                    question.Name = serPrepQuestion.Name;
                    question.Question__c = serPrepQuestion.Question__c;
                   
                    if(this.createCaseTitle)
                        if(this.createCaseTitle[title.Id]) {
                            if (this.createCaseTitle.hasOwnProperty(title.Id)) {
                            
                            this.createCaseTitle[title.Id] =  this.createCaseTitle[title.Id].push(question);
                    
                            }    else
                            this.createCaseTitle[title.Id] = [question];
                        } else
                            this.createCaseTitle[title.Id] = [question];  
                   // this.createQuestions.push(serPrepResp);
                }   
             } 

    }
//create ps logic form literay from title field
     createPSLogicFormLiterary_Form(Literaryval,response,serPrepQuestion) {
    
       var resServicesMap = {}
      
       var createPsList = [];
       console.log(response);        
       console.log(JSON.stringify(serPrepQuestion)); 
       var TransmittalMapping = false;
        if(response) {
            if(serPrepQuestion.Title_Response_Value__c) {
                var titleres = serPrepQuestion.Title_Response_Value__c.split(';');
                for(var s in titleres) {
                    if(serPrepQuestion.Transmittal_Mapping__c)
                        TransmittalMapping = true;
                        console.log('ss'+ JSON.stringify(titleres[s]));
                    if(titleres[s]) {
                    
                        var resServices = titleres[s].trim().split('=');
                       
                        if(resServices.length==2) {
                     
                           let SIds = [];
                       
                          let litterVal = resServices[0].split('-');
                              if(litterVal.length == 2) {
                                console.log('response'+ JSON.stringify(litterVal));
                                if( litterVal[1].trim().includes(response) && litterVal[0].trim().includes(Literaryval) ) {
                                   
                                    if(resServices[1].includes(',')) {
                                        for(var str in resServices[1].trim().split(','))
                                            SIds.push(str.trim());
                                    } else    SIds.push(resServices[1].replace(';',''));
                                    
                                    resServicesMap[resServices[0].trim()] = SIds;
                                }
                            }   
                        } 
                    }
                }  
            }
            
            for(var str in resServicesMap) {
                if((str.trim().includes(response.trim()) || response.trim().includes(str.trim())) && str.trim().includes(Literaryval))
                    for(var id1 in resServicesMap[str]) {
                     
                            createPsList.push(resServicesMap[str][id1]);
                            }
                    
            }
        }
     
        return createPsList;
    }
    getrefreshpanels() {
        var selectedEvent = new CustomEvent('getrefreshpanels', { });
        this.dispatchEvent(selectedEvent);
    }  

    getServiceIdsForCreatePs(value, details) {
      
        if(details.Render_type__c == 'Create PS') 
           return this.getServicesIds(value, details.Render_Response__c);
        else
            return [];
    }
// get services ids for cancel ps action button
    getServiceIdsForCancelPs(value, details) {
      
        if(details.Delete_Render_type__c == 'Delete PS') 
           return this.getServicesIds(value, details.Delete_Render_Response__c);
        else
            return [];
    }
// get services ids
    getServicesIds(value,renRes) {
        var serviceIds = []; //updatePsList
       
           // var renRes = details.Render_Response__c;
            if(renRes) {
               // const value = details.value;
                   let ser = []
                    if(renRes.trim().includes(';'))
                        ser = renRes.split(';') 
                        else ser.push(renRes.trim());
                        console.log(JSON.stringify(ser));
                        console.log(JSON.stringify(value));

            for(var s  in ser) {     
                var ord = ser[s].split('=');
                if(value) {
                    var v = value? (value.includes(',')? value.split(',').includes(ord[0].trim()): value == ord[0].trim()) : false;
                if(v) {
                    if(ord[1])
                    if(ord[1].includes(',')) {
                       
                            ord[1].split(',').forEach( elem => {
                                serviceIds.push(elem);
                        });
                        } else
                        serviceIds.push(ord[1].trim());    
                       
                    }
                }
                }
            }
      
        return serviceIds;
    }
// get services ids for update ps action button
    getServiceIdsForUpdatePs(value, details) {
        var serviceIds = {}; //updatePsList  cancelPsList
        if(details.Update_Render_Type__c == 'Update PS') {
            var renRes = details.Update_Render_Response__c;
            if(renRes) {
                  let ser = []
                    if(renRes.trim().includes(';'))
                        ser = renRes.split(';') 
                        else ser.push(renRes.trim());
                        console.log(JSON.stringify(ser));
                        console.log(JSON.stringify(value));

            for(var s  in ser) {     
                var ord = ser[s].split('=');
                if(value) {
                    var v = value? (value.includes(',')? value.split(',').includes(ord[0].trim()): value == ord[0].trim()) : false;
                if(v) {
                    if(ord[1])
                    if(ord[1].includes(',')) {
                       
                            ord[1].split(',').forEach( elem => {
                                let updateser = elem.split('->');
                                if(updateser.length == 2)
                                    serviceIds[updateser[0].trim()] = updateser[1].trim();
                           
                        });
                        } else {
                           
                                let updateser = ord[1].split('->');
                                if(updateser.length == 2)
                                    serviceIds[updateser[0].trim()] = updateser[1].trim();
                       
                        }
                    
                    }
                }
                }
            }
        }
        return serviceIds;
    }

    // change menu selections 
    handleSelect(event) {
        const selectedName = event.detail.name;
        var isacq = this.template.querySelector('[data-id="isacq"]');
        var isdes = this.template.querySelector('[data-id="isdes"]');
        var isedi = this.template.querySelector('[data-id="isedi"]');

        var savesPrep = this.template.querySelector('[data-id="savesPrep"]');
        var create = this.template.querySelector('[data-id="create"]');
     
     this.selectedName = selectedName;
     this.createPsbtnDisableAction(create);
        if(selectedName == 'Acquisition') {
            if(savesPrep && create) {
                savesPrep.label = 'Save Service Prep';
                create.label = 'Create Services';
                create.title = 'Create Services';
            }
                if(isacq)
                isacq.style.display = 'inline';
                if(isdes)
                isdes.style.display = 'none';
                if(isedi)
                isedi.style.display = 'none';
          
        }
        if(selectedName == 'Design') {
            if(savesPrep && create) {
                savesPrep.label = 'Save Design Prep';
                create.label = 'Review and Complete';
                create.title = 'Review and Complete';
            }
                if(isacq)
                isacq.style.display = 'none';
                if(isdes)
                isdes.style.display = 'inline';
                if(isedi)
                isedi.style.display = 'none';
        }
        if(selectedName == 'Editorial') {
            if(savesPrep && create) {
                savesPrep.label = 'Save Editorial Prep';
                create.label = 'Review and Complete';
                create.title = 'Review and Complete';
            }
                if(isacq)
                isacq.style.display = 'none';
                if(isdes)
                isdes.style.display = 'none';
                if(isedi)
                isedi.style.display = 'inline';
        }
    }
}