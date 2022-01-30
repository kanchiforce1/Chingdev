({
	   doInit: function(component, event, helper) {
        
           var sPageurl = window.location.search.substring(1);
           //str.includes("world")
          var titleId;
              if(sPageurl)
              if(sPageurl.split('&')) {
                var sURLVariables = sPageurl.split('&')
                  for (var i = 0; i < sPageurl.split('&').length; i++) {
                      var sParameterName = sURLVariables[i].split('=');
                      
                      if (sParameterName[0] === 'titleId') 
                          titleId = sParameterName[1] === undefined ? true : sParameterName[1];
                      
                  }
              } else {
                  var sParameterName = sPageurl.split('=');
                  
                  if (sParameterName[0] === 'titleId') 
                      titleId = sParameterName[1] === undefined ? true : sParameterName[1];
              }
                  
                 
           var action = component.get("c.getImageGallery");
           alert(titleId);
             action.setParams({
                titleId : titleId
              
              });
         action.setCallback(this, function(response) {
             var res = response.getReturnValue();
             console.log(JSON.stringify(res));
             helper.helperMethod(component, event, helper).setCallback(this,
                                                           helper.helperMethod1(component, event, helper)
                                                                      );
             component.set('v.CB',res.c);
             component.set('v.imageGalleryMap',res.imageGalleryMap);
             component.set('v.tlCheck',res.tlCheck);
             component.set('v.euCheck',res.euCheck);
             component.set('v.deCheck',res.deCheck);
             component.set('v.translatorCheck',res.translatorCheck);
             component.set('v.illustratorName',res.illustratorName);
             component.set('v.nonStandardFormats',res.nonStandardFormats);
             component.set('v.selectedPublicationBackgrounds',res.selectedPublicationBackgrounds);
            // component.set('v.CB',res.c);
         	//component.set('v.userRole',response.getReturnValue());
         });
             $A.enqueueAction(action);
       },
    
     scriptsLoaded: function(component, event, helper) {
         
     },
    
})