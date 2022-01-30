({
    init : function(component, event, helper) {
        
        var action = component.get("c.fetchUserDetail");
        console.log('hiihiid');
        action.setCallback( this, function(response) {
            if(response.getState() === 'SUCCESS') {
                console.log(response.getReturnValue());
                console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.currentUser", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    contactUs: function(component, event, helper) {
        component.set('v.contactUs', true);
    },
    
    closeCaseWindow : function(component, event, helper) {
        component.set('v.contactUs', false);
    },
    
    reload: function(component, event, helper) {
        window.location.href= '/lwccommunity/s'
        //location.reload();
    },
    
    
    onClick: function(component, event, helper) {
        var id = event.target.dataset.menuItemId;
        if (id) {
            component.getSuper().navigate(id);
        }
    },
    
    logout: function(component, event, helper) {
        
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
            },40);
    },
    getContactInfo: function(component, event, helper){
        helper.getContactInfo(component, event);
    },
    
    scriptsLoaded: function(component, event, helper) {
    },
})