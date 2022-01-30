({
	mover : function(component, event, helper) {
		//var ct = event.currentTarget;
        try {
             var toggleText = component.find("mclose");
        $A.util.addClass(toggleText,'slds-box slds-box_x-small');
      
        } catch(e) {console.log(e.message);}
        
        
	},
    
    mover1 : function(component, event, helper) {
        var vl = event.target.tagName;
        // var v = event.currentTarget.Id;
        console.log(vl);
        component.set('v.modalclose', false);
        //  console.log(v);
		//alert(vl);
        
	},

   
    stopPropagation : function(component, event, helper) {
        var vl = event.target.tagName;
      ///  console.log(vl);
	// event.stopPropagation();
        
	},
    
     ccanel : function(component, event, helper) {
        var vl = event.target.tagName;
       console.log(vl);
	// event.stopPropagation();
        
	},
    
     ssave : function(component, event, helper) {
        var vl = event.target.tagName;
        console.log(vl);
	// event.stopPropagation();
        
	},
        
    
    
      closee : function(component, event, helper) {
		alert('modal');
          component.set('v.modalclose', false);
        
	},
})