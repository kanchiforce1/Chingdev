({
	init : function(component, event, helper) {
       // var cuUserId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.fetchUserDetail");
       
        action.setCallback( this, function(response){
            if(response.getState() === 'SUCCESS') {
                console.log(response.getReturnValue());
               component.set("v.currentUser", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
	
    contactUs : function(component, event, helper) {
		
	},
    
     onClick: function(component, event, helper) {
		var id = event.target.dataset.menuItemId;
		if (id) {
			component.getSuper().navigate(id);
		}
	},
     UserInfo: function(component, event, helper) { //dropdId
         var userInfo = component.find("userInfo");
         $A.util.addClass(userInfo, 'slds-is-open'); 
         $A.util.removeClass(userInfo, 'slds-is-close');
       
         
     },
	
     closeUserInfo: function(component, event, helper) {
          window.setTimeout(
               function() {
         var userInfo = component.find("userInfo");
        $A.util.addClass(userInfo, 'slds-is-close');
        $A.util.removeClass(userInfo, 'slds-is-open');
               },20);
     },
    getContactInfo: function(component, event, helper){
        helper.getContactInfo(component, event);
    },
    
    scriptsLoaded: function(component, event, helper) {
		/*var path = window.location.pathname;
		var page = path.split("/").pop();
		console.log('>>> Page Title : ' + document.title);

		component.set("v.PageName", document.title);
        
         if ($A.get("$Browser.formFactor") == "DESKTOP") {
            $(".select2class").select2({
                width: "100%",
                minimumResultsForSearch: 6,
                theme: "bootstrap",
                containerCssClass: ':all:'
            });
            $('select option[disabled]').remove();
          	$(".select2class").on('select2:open',function(event){
          	// CSS fix for select2 in Modal
            $('.select2-dropdown').css({zIndex:'100000'});
       		});
        }
        else {
            $(".select2class").addClass("form-control");
            $('select').on('change', function(event) {
               //alert('event name: ' + event.currentTarget.id);
                $('#' +  event.currentTarget.id + ' option[disabled]').remove();
            });
        } 
        */
	},
        
   /* createCase: function(component, event, helper){

        var hasError = helper.formValidation(component);
        if(!hasError){
           helper.handleCreateCase(component, event); 
        }
        
    },
    
    resetForm: function(component, event, helper){
        console.log('>>>> HIT resetForm');
        helper.handleResetForm(component, event);       
    }, */
})