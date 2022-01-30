({
	scriptsLoaded : function(component, event, helper) {
        alert('jii');
		var cmp = component.get('v.container1');
        component.set('v.container1',cmp);
	}
})