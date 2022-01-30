({
	doInit : function(component, event, helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.

            if (sParameterName[0] === 'firstName') { //lets say you are looking for param name - firstName
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            }
        }
        console.log('Param name'+sParameterName[0]);
        console.log('Param value'+sParameterName[1]);
        var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({ //URLFOR('/apex/dsfs__DocuSign_CreateEnvelope',null,[SourceID=Opportunity.Id])
            "url": "{!URLFOR('/transmittal-form?titleId',null,[sParameterName[0] = sParameterName[1]])}"
        });
        urlEvent.fire();
	}
})