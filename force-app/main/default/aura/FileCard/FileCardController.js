({
	fireApplicationEvent : function(component, event, helper) {
		widnow.location.href="s/";
         var cmpEvent = component.getEvent("UrlNavigationEvt"); 
        //Set event attribute value
        cmpEvent.setParams({"message" : "Welcome "}); 
        cmpEvent.fire(); 
   
	}
})