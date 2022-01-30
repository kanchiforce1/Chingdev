({
	doInit : function(component, event, helper) {
		 var action = component.get("c.getProject");
        action.setParams({ pId : component.get("v.recordId") });
 
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.project", response.getReturnValue());
            }
        });
          $A.enqueueAction(action);
	}
})