$.fn.extend({

    treeview: function() {
        return this.each(function() {
            // Initialize the top levels;
            var tree = $(this);
            tree.addClass('treeview-tree');
            tree.find('li').each(function() {
                var stick = $(this);
                });
            tree.find('li').has("ul").each(function () {
                var branch = $(this); //li with children ul

                branch.prepend("<i class='tree-indicator fa fa-hand-o-down'></i>");
                branch.addClass('tree-branch');
                branch.on('click', function (e) {
                    if (this == e.target) {
                        var icon = $(this).children('i:first');

                        icon.toggleClass("fa-hand-o-down fa-hand-o-right");
                        $(this).children().children().toggle();
                        }
                })
                // branch.children().children().toggle();

                branch.children('.tree-indicator, button, a').click(function(e) {
                branch.click();

                e.preventDefault();
                });
                });
        });
}
});
