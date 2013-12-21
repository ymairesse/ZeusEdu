(function($) {
    var defaults = {
        includeDescendants: true,
        includeSelf: true,
        onlyApplyToInput: true,
        tabInScope: $() // ensure we won't focus an element outside this scope
    };


    var KEYS = {
        RETURN: 13
    };


    $.fn.extend({
        enterToTab: function(options) {
            options = $.extend(defaults, options || {});
            var inputs;
            var expression = "";
            if (options.includeDescendants) {
                if (options.onlyApplyToInput)
                    expression = ":text";
                else
                    expression = ":input"; // textarea, button is also included
            }
            if (options.includeSelf && this.is(expression))
                inputs = this.find(expression).andSelf();
            else
                inputs = this.find(expression);

            inputs.bind("keydown", function(e) {
                var t = $(e.target);
                var tn = t.attr("tagName");
                if ("TEXTAREA" == $(e.target).attr("tagName") && e.keyCode == KEYS.RETURN)
                    e.preventDefault();
            });
            inputs.bind("keyup", function(e) {
                if (e.keyCode == KEYS.RETURN) {
                    var inputs = options.tabInScope.find(":input");
                    var tabIndex = inputs.index(e.target);
                    var i = (tabIndex + 1) % inputs.length;
                    while (i != tabIndex) {
                        var jqInput = $(inputs[i]);
                        if (jqInput.is(":enabled") && jqInput.is("[tabindex!=-1]") && jqInput.is("[readOnly!='true']")) {
                            inputs[i].focus();
                            inputs[i].select();
                            return;
                        }
                        i = (i + 1) % inputs.length;
                    }
                    //                    e.preventDefault(); 
                    //                    return false;
                }
            });
        }
    });

})(jQuery);

