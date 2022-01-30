({
	doInit : function(component, event, helper) {
		var v = window.localStorage.getItem('name');
        component.set('v.eventMessage', v);
      //  alert(v);
	}
    ,
    update : function(component, event, helper) {
        alert('hiii');
		//var v = window.localStorage.getItem('name');
      //  component.set('v.eventMessage', v);
      //  alert(v);
	}
    ,
    handleBubbling : function(component, event, helper) {
		 var message = event.getParam("message"); 
        alert(message);
        component.set('v.eventMessage', message);
	}
})