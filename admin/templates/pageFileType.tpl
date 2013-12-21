<div id="attention">
	<p>Problème: votre fichier est de type <br>
    <strong>{$fileType}</strong><br>
    au lieu de<br>
    <strong>text/plain; charset=utf-8</strong>.</p>
	<p>Veuillez vérifier que vous tentez bien d'importer un fichier CSV.</p>
</div>

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