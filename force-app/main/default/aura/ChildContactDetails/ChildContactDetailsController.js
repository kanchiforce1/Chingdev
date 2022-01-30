({
	doInit : function(component, event, helper) {
        try {
		var recordId = component.get('v.recordId');
        var action = component.get('c.getAccContacts');
        action.setParams({recId: recordId});
        action.setCallback(this, function(res) {
            console.log(res);
            if(res.status() == 'SUCCESS') {
                component.set('v.contList', res.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
        }catch(e) {console.log(e.message);}
        
	}
})