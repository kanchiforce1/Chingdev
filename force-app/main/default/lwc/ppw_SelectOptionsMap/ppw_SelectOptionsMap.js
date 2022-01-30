import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class Ppw_SelectOptionsMap extends NavigationMixin(LightningElement) {
    
    @api serPrep;
    @api serPrepQuestion;
    @api questionStaticMap;
    @api selectedName;questonStatic=false;isTrasmitMapping=false;// Transmittal_Mapping__c
    //@api serPQuestion
    questionType;isPicklist;isMultiselect;isNumber;isText;isCheckBox;isTextArea
    value; selectedMultipleOptions;questionStatic;
    optionValues = [];
    @api serTypeSubQuestionsMap;
    @api serTypeSubQuestionsOrderMap;
    @api connectedCallback() { 
            if(this.serPrepQuestion) {

               this.serPrepQuestion = this.serPrep.serPrepQuestion;
              this.questionType = this.serPrepQuestion.Question_Type__c;
              //   this.questonStatic = this.serPrepQuestion.Service_Prep_Responses__r[0].Question_Static__c || 
              //                                 (this.selectedName == 'Acquisition' ? this.serPrep.serPrep.Acquistion_Tab_Static__c : this.selectedName == 'Design'? this.serPrep.serPrep.Design_Scheduling_Tab_Static__c : this.serPrep.serPrep.Editorial_Tab_static__c);
                this.isTrasmitMapping = this.serPrepQuestion.Transmittal_Mapping__c;
               // console.log(this.serPrepQuestion.Id + ';;' +  this.questonStatic) ;
                if(this.isTrasmitMapping)
                    this.questonStatic = false;
                  ///  console.log('select map');
                                                // this.value = 
                if(this.questionType == 'Picklist') {
                    this.getOptionValues();
                        this.isPicklist = true;
                        this.value = this.serPrepQuestion.Service_Prep_Responses__r[0].Response__c;
                }
                    if(this.questionType == 'Picklist (Multi-Select)') {
                        this.getOptionValues();
                        this.isMultiselect = true;
                        const selectedOptions = this.serPrepQuestion.Service_Prep_Responses__r[0].Response__c;
                        this.value = selectedOptions? selectedOptions.includes(',')? selectedOptions.split(',') : [selectedOptions] : [];
                    }
                    if(this.questionType == 'Number') {
                        this.isNumber = true;
                        this.value = this.serPrepQuestion.Service_Prep_Responses__r[0].Response_Number__c;
                    }
                    if(this.questionType == 'Text Area') {
                        this.isTextArea = true;
                        this.value = this.serPrepQuestion.Service_Prep_Responses__r[0].Response__c;
                    }    
                    if(this.questionType == 'Checkbox') {
                        this.isCheckBox = true;
                        this.value = this.serPrepQuestion.Service_Prep_Responses__r[0].Response__c;
                    }


                }
                if(this.questionStaticMap) 
                if(this.questionStaticMap[this.serPrepQuestion.Id])
                    this.questonStatic = this.questionStaticMap[this.serPrepQuestion.Id];
      
         
        } 

        onLoadSubQuestionsRender() {


        }
        question(e) {
          
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                    "recordId": this.serPrepQuestion.Id,
                    "objectApiName": "Account",
                    "actionName": "view"
                },
            }).then(url => {
                window.open(url, "_blank");
            });

            

        }  
            getOptionValues() {
              
                 let options = this.serPrepQuestion.Option_Values__c;//? this.serPrepQuestion.Option_Values__c.substring(0, this.serPrepQuestion.Option_Values__c.length - 1): this.serPrepQuestion.Option_Values__c;
                var optionValues1 = options? (options.includes(';')? options.split(';'): [options]) : [];
                var optionVals = [];
              //  console.log(JSON.stringify(optionValues1));
                if(this.questionType != 'Picklist (Multi-Select)')
                    optionVals.push({value: '', label: '--Select--'});

              if(optionValues1)
                    optionValues1.forEach(item => {
                    if(item)
                        optionVals.push({value: item.trim(), label: item.trim()});

                }); 
                this.optionValues = optionVals;
              }

    renderedCallback() {
        console.log('rendercallback map component');
      
            if(this.serPrepQuestion) {
            let question = this.template.querySelector('[data-id="'+ this.serPrepQuestion.Id +'"]')
                if(question) {
                if(!this.serPrepQuestion.Service_Prep_Parent_Question__c)
                    question.style.display = 'inline';
                else
                    question.style.display = 'none';
                }
               
                
            }
         
           
    }

    
    @api makequestionStatic() {
        console.log('questionStatic');
    
        if(this.questionStaticMap)
            if(this.questionStaticMap[this.serPrepQuestion.Id] == true)
                this.questonStatic = this.questionStaticMap[this.serPrepQuestion.Id];
            if(this.questionStaticMap[this.serPrepQuestion.Id] == false)
                this.questonStatic = this.questionStaticMap[this.serPrepQuestion.Id];
      
    }
    @api
    renderChild(r) {
    if(this.template)
        var question = this.template.querySelector('[data-id="'+ this.serPrepQuestion.Id +'"]')
        if(question) {
      
        question.style.display = r;
        }
    }
        @api
        renderChild1(s, r) {
      
         if(this.template)
            var question = this.template.querySelector('[data-id="'+ s+'"]')
            if(question) {
          
            question.style.display = r;
            }
        
    }


onselectvalue(e) {
   
    var value = e.target.value;
   // console.log(value);
    if(this.serPrepQuestion.Question_Type__c == 'Checkbox')
        value = e.detail.checked;
    
   
   if(value)
        value = value.toString();
   // console.log(JSON.stringify(value));
    var displayOrd = [];
    var nodisplayOrd = [];
    var detailParams = { value: '', displayOrd: [], nodisplayOrd: [] }
   // console.log(value);
    if(!this.serPrepQuestion.Service_Prep_Parent_Question__c) {
        if(this.serPrepQuestion.Sub_Question_Render__c) {
           // id = this.serPrepQuestion.Id;
            if(this.serPrepQuestion.Sub_Question_Render__c.includes(';')) {
                let sub = this.serPrepQuestion.Sub_Question_Render__c.split(';');
                for(var b in sub) 
                    displayOrd = this.displayOrder(sub[b].split('='),value, displayOrd);
            
          //  console.log(JSON.stringify(displayOrd))
                for(var b in sub) {
                        var ord = sub[b].trim().split('=');
                        nodisplayOrd = this.nodisplayOrder(ord,value,displayOrd, nodisplayOrd);
                    }
        
            
            } else {
                let sub = this.serPrepQuestion.Sub_Question_Render__c;
                var ord = sub.split('=');
                displayOrd = this.displayOrder(ord,value, displayOrd);
                nodisplayOrd = this.nodisplayOrder(ord,value,displayOrd, nodisplayOrd);
            
            }

        }

    }

    // change value by question type
    //if(this.serPrepQuestion.Question_Type__c == 'Checkbox')
       // value = value? true

    detailParams.id = this.serPrepQuestion.Id;
    detailParams.value = value;
    detailParams.response = this.serPrepQuestion.Service_Prep_Responses__r[0].Id;
    detailParams.questionDetils = this.serPrepQuestion;
    detailParams.questionType = this.serPrepQuestion.Question_Type__c;
    detailParams.displayOrd = displayOrd;
    detailParams.nodisplayOrd = nodisplayOrd;
  //  console.log(JSON.stringify(detailParams));

   // if(displayOrd || nodisplayOrd) {
            var selectedEvent = new CustomEvent('questionchange', { detail: detailParams} , {
            
            });
            // Dispatches the event.
         this.dispatchEvent(selectedEvent);
    //}                  
    }

    getSubQuestionsOrder() {
        
    }

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

nodisplayOrder(ord,value,displayOrd,nodisplayOrd ) {
                
    if(ord) {
        if(value) {
            var v = value? value.includes(',')? value.split(',').includes(ord[0].trim()): value == ord[0].trim() : false;
          //  console.log(JSON.stringify(v));
            if(v) {
                nodisplayOrd = this.noDisplaySplitOrders(ord,displayOrd,nodisplayOrd);
            } else
                nodisplayOrd = this.noDisplaySplitOrders(ord,displayOrd,nodisplayOrd);    
            } else nodisplayOrd = this.noDisplaySplitOrders(ord,displayOrd,nodisplayOrd);

    
    }
        return nodisplayOrd;
}

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



}