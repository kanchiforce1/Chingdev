({
	doInit : function(cmp, event, helper) {
		
        setTimeout(function(){cmp.set('v.inprogress',false);
                              cmp.set('v.failed',true);
                             
                             }, 3000);
          setTimeout(function(){
                              cmp.set('v.failed',false);
                               cmp.set('v.success',true);
                             }, 3000);
    
      // setTimeout(function(){  $A.util.toggleClass(failed, 'slds-hide'); }, 3000);
       
	}
})