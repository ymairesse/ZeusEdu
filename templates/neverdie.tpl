<img src="../images/coeur.gif" alt="coeur" style="width:14px" title="Staying alive">

<script type="text/javascript">

    var time = new Date().getTime();
    $(document.body).bind("mousemove keypress", function(e) {
    	time = new Date().getTime();
    });

    function refresh() {
        if (new Date().getTime() - time >= 5000)
        	$.post('inc/refreshNeverDie.inc.php', {
                param: math.random()*1e9
            }, function(resultat){
                $('#neverdie').html(resultat);
            })
        else setTimeout(refresh, 5000);
    	}

    setTimeout(refresh, 5000);

</script>
