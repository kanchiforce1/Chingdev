import { LightningElement, api, track } from 'lwc';

export default class Ppw_ServicePrepQuesions extends LightningElement {
    @api key1;
  
    parentQuestions;
    @api type;
    @api selectedName;
    @api smap;
    optionValues;
    @api questionStaticMap;//sectionHide = true;
    sectionQustinCount=false;
    @api serTypeSubQuestionsMap;
   @api connectedCallback() {
      console.log('connected callback');
        if(this.smap)
        var vque = this.smap[this.key1];
            var questions= []
            if(vque) {
                for(var a in vque) {
                    questions.push(vque[a]);
                    if(!vque[a].serPrepQuestion.Service_Prep_Parent_Question__c) {
                        this.sectionQustinCount = true;
                       // break;
                    } 
                }
                var serq = this.template.querySelectorAll('c-ppw_-select-options-map');
                    
                if(serq.length>0) 
                this.parentQuestions = JSON.parse(JSON.stringify(questions));
                 else this.parentQuestions = questions;
            }
        
    }
    
@api
    onQuestionValue1(sid, s) {
        var serq = this.template.querySelectorAll('c-ppw_-select-options-map');
      for(var i =0; i<serq.length; i++) {
            serq[i].renderChild1(sid,s);
        }

    }

    @api
    renderQuestionStatic() {
       console.log('renderQuestionStatic');
       console.log(JSON.stringify(this.questionStaticMap));
        var serq = this.template.querySelectorAll('c-ppw_-select-options-map');
      for(var i =0; i<serq.length; i++) 
       if(serq[i]) {
            serq[i].questionStaticMap = this.questionStaticMap;
            serq[i].makequestionStatic();
        }
      
    }

    onQuestionValue(e) {

        const details = e.detail;//.order.toString();
       const displayorders = details.displayOrd.toString();
       const nodisplayorders = details.nodisplayOrd.toString();
       const disord = displayorders? displayorders.includes(',')? displayorders.split(','): displayorders: null;
       const nodisord = nodisplayorders? nodisplayorders.includes(',')? nodisplayorders.split(','): nodisplayorders: null;

       var self = this;
        if(this.serTypeSubQuestionsMap) {
            var squs = self.serTypeSubQuestionsMap[details.id];
            console.log(JSON.stringify(squs));
            if(squs) {
           for(var a in squs) {
                var ordFixed = squs[a].Order__c.toFixed(2);
                if(disord) {
                    if(disord.includes(ordFixed.toString()))
                      this.questionRender('inline',  squs[a].Id, details);
                     else 
                        this.questionRender('none',  squs[a].Id, details);
                }
                if(nodisord) 
                    if(nodisord.includes(ordFixed.toString()))
                        this.questionRender('none',  squs[a].Id, details);
                
            }
        } else {
            var selectedEvent = new CustomEvent('answeredquestion', { detail: {sid: null, s: '', details: details} });
            this.dispatchEvent(selectedEvent);
            }
        } else {
            var selectedEvent = new CustomEvent('answeredquestion', { detail: {sid: null, s: '', details: details} });
            this.dispatchEvent(selectedEvent);
        }
   }


   questionRender(s, sid, details) {
       

        var selectedEvent = new CustomEvent('answeredquestion', { detail: {sid: sid, s: s, details: details} }, {
         
        });
        this.dispatchEvent(selectedEvent);
   }
   

}