 jQuery.fn.tabEnter = function() {
this.keypress(function(e){
// get key pressed (charCode from Mozilla/Firefox and Opera / keyCode in IE)
var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;

if ((key == 13) || (key == 40)) {
// get tabindex from which element keypressed
var ntabindex = parseInt($(this).attr("tabindex"));
$("[tabindex=" + eval(ntabindex+1) + "]").focus();
return false;
}

if (key == 38) {
var ntabindex = parseInt($(this).attr("tabindex"));
$("[tabindex=" + eval(ntabindex-1) + "]").focus();
return false
}

});
}
