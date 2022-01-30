({doInit : function(component, event, helper) {
	var username = $A.get("$SObjectType.CurrentUser.FirstName");
       var Lastname = $A.get("$SObjectType.CurrentUser.LastName");
      var Phone = $A.get("$SObjectType.CurrentUser.Phone");
        console.log(username+ Lastname+Phone);
	
	}
 })