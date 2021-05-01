<img src="../images/coeur.gif" alt="coeur" style="width:14px" title="Staying alive" data-param="{$param|default:0}">
{$param} {$heure}
<script type="text/javascript">

    var time = new Date().getTime();

    $(document.body).bind("mousemove keypress", function(e) {
    	time = new Date().getTime();
    });

    function refresh() {
        var newTime = new Date().getTime() - time;
        if (new Date().getTime() - time >= 5000) {
            var param = Math.random()*1e9;
        	$.post('inc/refreshNeverDie.inc.php', {
                param: param
            }, function(resultat){
                $('#neverdie').html(resultat);
            })
        }
        else setTimeout(refresh, 5000);
    	}

    setTimeout(refresh, 5000);

</script>
