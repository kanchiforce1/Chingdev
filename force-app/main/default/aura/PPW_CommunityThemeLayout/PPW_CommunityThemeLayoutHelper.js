({
    removeAppStyles : function() {
        //alert('in rendereer');
        var allLinks = document.getElementsByTagName('link');
        
        var badLink;
        for (var i = 0; i < allLinks.length; i++) {
            
            thisLinkUrl=allLinks[i].href;
            var badName='/app.css';
            if (thisLinkUrl.substring( thisLinkUrl.length - badName.length, thisLinkUrl.length ) === badName) badLink = allLinks[i];
        }
        badLink.parentNode.removeChild(badLink);    
        
    },
    
    /*
    getUser: function(component, event) {
		var action = component.get("c.cGetCurrentUser");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.runningUser", response.getReturnValue());
				var rUser = component.get("v.runningUser");
				var fN = rUser['FirstName'];
                var lN = rUser['LastName'];
                
                var initials = fN.charAt(0).toUpperCase()+ lN.charAt(0).toUpperCase()
                var fullName = fN.charAt(0).toUpperCase() + fN.substr(1,fN.length) + " " + lN.charAt(0).toUpperCase() + lN.substr(1,lN.length);
                component.set("v.currentUserName", fullName);
                component.set("v.nameInitials", initials);
				component.set("v.runningUserId", rUser['Id']);
                component.set("v.username", rUser['Email']);
			}
			else if (response.getState() === "ERROR") {
				console.log(">>>>>>>>>>>> HIT HELPER getCurrentUser: failure" + response.getError());
			}
		});
		$A.enqueueAction(action);
	},
    */
    getContactInfo: function(component,event){
        
        console.log(">>>>>>>>>>>> HIT HELPER getContactInfo");
        var action = component.get("c.getCurrentContact");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.fmgContact", response.getReturnValue());
                var fmgContact = component.get("v.fmgContact");
                
                var fN = fmgContact['FirstName'];
                var lN = fmgContact['LastName'];
                
                var initials = fN.charAt(0).toUpperCase()+ lN.charAt(0).toUpperCase()
                var fullName = fN.charAt(0).toUpperCase() + fN.substr(1,fN.length) + " " + lN.charAt(0).toUpperCase() + lN.substr(1,lN.length);
                component.set("v.currentUserName", fullName);
                component.set("v.nameInitials", initials);
                
            }
            
            else if (response.getState() === "ERROR") {
				console.log(">>>>>>>>>>>> HIT HELPER getContactInfo: failure" + response.getError());
			}
        });
        
        $A.enqueueAction(action);
    },
    getAccountName: function(component, event){
		var action = component.get("c.getAccountName");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.accountname", response.getReturnValue());
			}
			else if (response.getState() === "ERROR") {
				console.log(">>>>>>>>>>>> HIT HELPER getAccountName: failure" + response.getError());
			}
		});
		$A.enqueueAction(action);
	},
    
   /* formValidation: function(component){
        
        
        var hasError = false; 
        
		var desc = $("#feedback").val();
         console.log("desc>>>" + desc);
        var subj = $("#subj").val();
        console.log("subj>>>" + subj);
        var casetype = $("#casetype").val();
         console.log("caseType>>>" + casetype);
        if(casetype == ''){
             $("#dcasetype").addClass('has-error')
                .find('.help-block').removeClass('noDisplay');
             $('span[aria-labelledby=select2-casetype-container]').addClass('has-error')
                .find('.help-block').removeClass('noDisplay');
            hasError = true;
        }else{
             $("#dcasetype").removeClass('has-error')
                .find('.help-block').addClass('noDisplay');
            $('span[aria-labelledby=select2-casetype-container]').removeClass('has-error')
                .find('.help-block').addClass('noDisplay');
        }
        if(subj == ''){
            $("#dsubj").addClass('has-error')
                .find('.help-block').removeClass('noDisplay');
        }else{
            $("#dsubj").removeClass('has-error')
                .find('.help-block').addClass('noDisplay');
        }
        if(desc == ''){
            $("#dfeedback").addClass('has-error')
                .find('.help-block').removeClass('noDisplay');
            hasError = true;
        }else{
            $("#dfeedback").removeClass('has-error')
                .find('.help-block').addClass('noDisplay');
        }
        
        return hasError;
    },
    
    handleResetForm: function(component, event){
        console.log('>>>> HIT resetForm');
         $("#feedback").val('');
        $("#subj").val('');
        $("#casetype").select2("val", "");
        
        if($("#dfeedback").hasClass("has-error")){
            $("#dfeedback").removeClass('has-error')
                .find('.help-block').addClass('noDisplay');
        }
        if($("#dsubj").hasClass("has-error")){
            $("#dsubj").removeClass('has-error')
                .find('.help-block').addClass('noDisplay');
        }
        if($("#dcasetype").hasClass("has-error")){
            $("#dcasetype").removeClass('has-error')
                .find('.help-block').addClass('noDisplay');
            $('span[aria-labelledby=select2-casetype-container]').removeClass('has-error')
                .find('.help-block').addClass('noDisplay');
        }
    },
  
   /* handleCreateCase: function(component, event) {
        console.log(">>>>HIT Create Case");
        var desc = $("#feedback").val();
        var subj = $("#subj").val();
        var type = $("#casetype option:selected").val();
        console.log(">>>>HIT Create Case" + desc);
        console.log(">>>>HIT Create Case" + type);
      
        var action = component.get("c.cGetCase");
        action.setParams({description:desc, subject:subj, casetype:type});
        action.setCallback(this, function(response) {
            var rtnValue = response.getReturnValue();
            if (response.getState() === "SUCCESS") {
               console.log(">>>>Junk "+rtnValue['Id']);
                $('#myModal').modal('hide');
              swal({
					title: "Success!",
                    text: "Thank you for getting in touch.\n" + 
                  			"One of our provider support engineers\n" + "will respond to you within a few hours.\n" + "Have a great day!",
					type: "success",
					showCancelButton: false,
					confirmButtonColor: "#42a4e4",
					closeOnConfirm: true
				});
            }else if (response.getState() === "ERROR") {
				console.log(">>>>>>>>>>>> case Creation: failure" + response.getError());
				swal({
					title: "Oops...!",
                    text: "Something went wrong, if problem persists contact us via email:\n" + "help@intivahealth.com",
					type: "warning",
					showCancelButton: false,
					confirmButtonColor: "#42a4e4",
					closeOnConfirm: true
				});
			}
            
           this.handleResetForm(component);
           console.log(">>>>Junk "+rtnValue['Id']);

       });
        $A.enqueueAction(action);
   },    
    
    fetchPickListValHTML: function(component, fieldName, elementId) {
    	console.log('>>> fetchPickListVal');
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {

                console.log('>>> getselectOptions Success');
                var allValues = response.getReturnValue();

                console.log('>>> getselectOptions allValues: ' + allValues);



                var select = document.getElementById(elementId);
                for (var i = 0; i < allValues.length; i++) {

                    //console.log('>>> getselectOptions allValues: ' + allValues[i]);
                    select.options[select.options.length] = new window.Option(allValues[i], allValues[i]);
                    
                }
            }
        });
        
        $A.enqueueAction(action);
    }
 */

})