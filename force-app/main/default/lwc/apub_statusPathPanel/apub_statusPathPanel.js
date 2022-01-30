import { LightningElement, api, wire } from 'lwc';
import picklistValues from '@salesforce/apex/PPW_transmittalController_lwc.picklistValues';
import { getRecord } from 'lightning/uiRecordApi';

export default class Apub_statusPathPanel extends LightningElement {

    @api status;
    @api currentStep;
    @api objectName;
    @api fieldName;
    @api removeVals;
    @api recordId;
    statusMap;



    connectedCallback() {
        if (!this.statusMap) {
            if (this.objectName) {
                picklistValues({
                    objectName: this.objectName, fieldName: this.fieldName, recordId: this.recordId

                }).then((data) => {
                    if (data) {
                      
                        console.log(this.recordId);
                        let sameval = false;
                        let statusWrp = []

                        let arr = data.fieldsLst;
                        if (data.recData)
                            this.currentStep = data.recData[this.fieldName];
                        var revalues = [];
                        console.log(this.removeVals);
                        if (this.removeVals) {
                            if (this.removeVals.includes(','))
                                revalues = this.removeVals.split(',');
                            else
                                revalues.push(this.removeVals);
                        }

                        console.log(revalues);
                        if (revalues)
                            for (let a in revalues) {

                                let index = arr.indexOf(revalues[a]);

                                if (index >= 0)
                                    arr.splice(index, 1);

                            }

                        for (let a in arr) {
                            let swrp = {}
                            if (arr[a] == this.currentStep) {
                                swrp.classLst = 'slds-path__item slds-is-current slds-is-active';
                                sameval = true;
                            } else {
                                if (sameval)
                                    swrp.classLst = 'slds-path__item slds-is-incomplete';
                                else
                                    swrp.classLst = 'slds-path__item slds-is-complete';

                            }
                            swrp.sval = arr[a];
                            statusWrp.push(swrp);
                        }
                        this.statusMap = statusWrp;
                    }
                })
                    .catch((error) => {
                        console.log(error);

                    });
            }
    }

}

@api
changeCurrentStatus(cStep) {
    
        let statusWrp = [];
        let sameval;
       // alert(cStep);
       
        for (let a in this.statusMap) {
            let swrp = {}
            if (this.statusMap[a].sval == cStep) {
                swrp.classLst = 'slds-path__item slds-is-current slds-is-active';
                sameval = true;
            } else {
                if (sameval)
                    swrp.classLst = 'slds-path__item slds-is-incomplete';
                else
                    swrp.classLst = 'slds-path__item slds-is-complete';

            }
            swrp.sval = this.statusMap[a].sval;
            statusWrp.push(swrp);
        }
        console.log(JSON.stringify(statusWrp));
        this.statusMap = statusWrp;
  
}

/*  @wire(getRecord, { recordId: '$recordId', fields: '$fieldName' })
  getRecord({data, error}) {
      if(data) {
          this.record = data;
          console.log(JSON.stringify(data));
         // this.error = undefined;
      }
      else if (error) {
          console.log(JSON.stringify(error));
      }
  } */
previouseHelpTextid;
showHelpText(e) {

    var rectarget = e.currentTarget;
    var idstr = rectarget.dataset.id;
    if (this.previouseHelpTextid)
        this.template.querySelector('[data-val="' + this.previouseHelpTextid + '"]').classList.add('slds-hide');

    if (idstr)
        this.template.querySelector('[data-val="' + idstr + '"]').classList.remove('slds-hide');

    this.previouseHelpTextid = idstr;
}

hideHelpText(e) {
    var rectarget = e.currentTarget;
    var idstr = rectarget.dataset.id;
    if (idstr)
        this.template.querySelector('[data-val="' + idstr + '"]').classList.add('slds-hide');

}

}