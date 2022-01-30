({
	 handleValidate : function (cmp, evt, helper){
        var num = cmp.find("number");
        var val = num.get("v.value");
        if (val<10) {
            console.log(val);
            num.set("v.errors", [{message:"Enter a number more than 10"}]);
        } else {
            console.log('6'+ val);
            num.set("v.errors", null);
        }
         
    },
    
    handleError : function (cmp, evt, helper){
        alert("An error was found in your input.");
    },
    
    checkk: function (cmp, evt, helper){
        var pw = cmp.find("pwd").get("v.value");
        console.log('length' +pw.length);
        console.log('length check' +pw.length<8);
        console.log('length check d' +pw.length>8);
        if(pw.length>8)
            alert('above 8');
        else
            alert('below 8');
        
        
    },
})