<img src="../images/coeur.gif" alt="coeur" style="width:14px" title="Staying alive" data-param="{$param|default:0}">
<span id="coeur">{$heure|default:''}</span>

<script type="text/javascript">

    var time = new Date().getTime();

    if ($('#coeur').text() == '') {
        var heure = time.getHours() + ":" + time.getMinutes();
        $('#coeur').text(heure);
    }

    function refresh() {
        var newTime = new Date().getTime() - time;
        if (newTime >= 5000) {
            // envoyer un nombre aléatoire en paramètre pour éviter l'effet de cache
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
