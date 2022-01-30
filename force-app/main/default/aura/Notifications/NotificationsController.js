({
    closeCaseWindow: function(component, event, helper) {
        component.set('v.contactUs', false);
    },
    
      onLoad : function(component, event, helper) {
         var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'slds-hide');
       
     
    },
    
   
    
    init: function(component, event) {
       var action = component.get("c.getCaseRecordType");
      
        action.setCallback( this, function(response) {
            if(response.getState() === 'SUCCESS') {
               // console.log(JSON.stringify(response.getReturnValue()));
              component.set('v.caseRecordType', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    onSubmit : function(component, event) {
        var localee = component.find("localee").get("v.value");
        alert(localee)
        if(!localee) {
      	   localee.set('v.validity', {valid:false, badInput :true});
           localee.showHelpMessageIfInvalid();
        } else {
        var caseRecordType = component.get('v.caseRecordType');
            console.log(JSON.stringify(caseRecordType));
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
            if(localee == 'US')
        		fields.OwnerId = caseRecordType.caseUSOwnerId;
            if(localee == 'EU')
                fields.OwnerId = caseRecordType.caseUKOwnerId;
        fields.RecordTypeId = caseRecordType.caseRecordTypeId;
        fields.Vendor__c = caseRecordType.vendorId;
        fields.Origin = 'Web';
           console.log(JSON.stringify(fields));
        
        component.find('newCase').submit(fields);
    }
    
      
    },
    
    onSuccess: function(component, event) {
        component.set('v.succesMes', 'Thank you for contacting us, you will be receiving an email shortly with a case ID for further reference');
    
    }
})