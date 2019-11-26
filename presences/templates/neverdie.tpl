<img src="../images/coeur.gif" alt="coeur" style="width:14px" title="Staying alive" data-param="{$param|default:0}">
{$heure|default:"00:00"}
<script type="text/javascript">

    var time = new Date().getTime();
    // temps entre les rafraîchissements
    var refreshTime = 5000;

    $(document.body).bind("mousemove keypress", function(e) {
    	time = new Date().getTime();
    });

    function refresh() {
        var newTime = new Date().getTime() - time;
        if (new Date().getTime() - time >= refreshTime) {
            var param = Math.random()*1e9;
        	$.post('inc/refreshNeverDie.inc.php', {
                param: param
            }, function(resultat){
                $('#neverdie').html(resultat);
            })
        }
        else setTimeout(refresh, refreshTime);
    	}

    setTimeout(refresh, refreshTime);

</script>
