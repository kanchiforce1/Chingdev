({
    closeCaseWindow: function(component, event, helper) {
        component.set('v.contactUs', false);
    },
    
    init1: function(component, event) {
      
       var action = component.get("c.getCaseRecordType");
      
        action.setCallback( this, function(response) {
            if(response.getState() === 'SUCCESS') {
                console.log(JSON.stringify(response.getReturnValue()));
              component.set('v.caseRecordType', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
       
       // component.set('v.succesMes', 'Thanks for the contact us');
        
    },
    onSubmit1 : function(component, event) {
        try {
            alert('hii');
        var caseRecordType = component.get('v.caseRecordType');
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        fields.OwnerId = caseRecordType.caseOwnerId;
        fields.RecordTypeId = caseRecordType.caseRecordTypeId;
            console.log(JSON.stringify(fields));
        component.find('newCase').submit(fields);
        component.set('v.succesMes', 'Thanks for the contact us');
        } catch(e) {console.log(e.message);}
        // var updatedRecord = JSON.parse(JSON.stringify(event.getParams()));
        // console.log('onsuccess: ', updatedRecord.id);
    },
    
    onSuccess1: function(component, event) {
        component.set('v.succesMes', 'Thanks for the contact us');
        // var updatedRecord = JSON.parse(JSON.stringify(event.getParams()));
        // console.log('onsuccess: ', updatedRecord.id);
    }
})