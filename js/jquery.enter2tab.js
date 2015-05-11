 jQuery.fn.tabEnter = function() {

ARROW_LEFT = 37;
ARROW_UP = 38;
ARROW_RIGHT = 39;
ARROW_DOWN = 40;
ENTER = 13;
ESC = 27;
TAB = 9;	

	this.keypress(function(e){
		// get key pressed (charCode from Mozilla/Firefox and Opera / keyCode in IE)
		var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
		
		if ((key == ENTER) || (key == ARROW_DOWN)) {
			// get tabindex from which element keypressed
			var ntabindex = parseInt($(this).attr("tabindex"));
			$("[tabindex=" + eval(ntabindex+1) + "]").focus();
			return false;
		}
		
		if (key == ARROW_UP) {
			var ntabindex = parseInt($(this).attr("tabindex"));
			$("[tabindex=" + eval(ntabindex-1) + "]").focus();
			return false
		}
	});
}
