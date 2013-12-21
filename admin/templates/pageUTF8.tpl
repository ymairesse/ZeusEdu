<script type="text/javascript">
    {literal}
    $(document).ready(function(){
        $.gritter.add({
            title: "Attention!",
            text: $("#attention").html(),
            image: '../images/info.png',
            sticky: true
        })
        $("#attention").hide();        
        })    
    {/literal}
</script>

<div id="attention">
    <p>Attention, votre fichier n'est que partiellement correct.</p>
    <p>Il est du type <br>
    <strong>{$fileType}</strong><br>
    mais il devrait être du type <br>
    <strong>text/plain; charset=utf-8</strong></p>
    <p>Il est possible que l'importation fonctionne malgré tout.</p>
    <p><strong>Vérifiez qu'il n'y a pas de problèmes de caractères accentués.</strong></p>
</div>