({
	search : function(component, event, helper) {
		
        var fName = component.get('v.firstName');
        var lName = component.get('v.lastName');
        var scon = $A.get('e.c.searchContact');
        scon.setParams({
            'firstName' : fName,
            'lastName' : lName,
            
        });
        scon.fire();
	}
})