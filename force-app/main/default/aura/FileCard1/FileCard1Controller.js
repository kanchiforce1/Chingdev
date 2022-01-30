({
	fireApplicationEvent : function(component, event, helper) {
	
        window.localStorage.setItem('name1', 'wel come1');
        window.localStorage.setItem('name2', 'wel come2');
        window.localStorage.setItem('name3', 'wel come3');
        component.set('v.name1', 'wel come1');
        component.set('v.name2', 'wel come2');
        component.set('v.name3', 'wel come3');
        
		//var v = window.localStorage.getItem('name');
        /* var cmpEvent = component.getEvent("UrlNavigationEvt"); 
        //Set event attribute value
        cmpEvent.setParams({"message" : "Welcome "}); 
        cmpEvent.fire();  */
      /*  var appEvent = $A.get("e.c:UrlNavigationEvt");
		appEvent.setParams({"message" : "Welcome "});
         appEvent.fire(); */
       //  alert('hiii');
        window.location.href="/pavTest/s/navigation";
       // window.addEventListener("popstate",helper.handleHashChange(location.hash));
//        alert('hiii');
        
	},
     update : function (component, event, helper) {
        // Get the new hash from the event
        var loc = event.getParam("token");
         alert(loc);
        // Do something else
    }
})