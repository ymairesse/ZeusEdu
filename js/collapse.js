$.fn.collapse = function() {
    return this.each(function() {
        $(this).find("legend").addClass('collapsible').click(function() {
            if ($(this).parent().hasClass('collapsed'))
                $(this).parent().removeClass('collapsed').addClass('collapsible');
			$(this).removeClass('collapsed');
			$(this).parent().children().not('legend').toggle("slow", function() {
				if ($(this).is(":visible"))
                    $(this).parent().find("legend").addClass('collapsible');
                 else
                    $(this).parent().addClass('collapsed').find("legend").addClass('collapsed');
             });
        });
    });
};
