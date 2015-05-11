<div class="container">
<h2>Envoi des photos d'élèves</h2>

<form enctype="multipart/form-data" method="POST" action="index.php" style="min-height:600px">
	<p>Sélectionnez une archive ZIP (max 4 Mo) ou une photo individuelle (format .jpg).</p>
	<p>Le nom de la photo est le matricule de l'élève.</p>
	{if isset($filename)}
	<p class="micro">Fichier précédent envoyé: {$filename}</p>
	{/if}	
	<input type="hidden" name="action" value="gestEleves">
	<input type="hidden" name="mode" value="envoiPhotos">
	<input type="hidden" name="etape" value="Envoyer">
		
	<div class="btn-group">
		<span class="btn btn-default btn-file">
			<span>Sélectionner un fichier</span><input type="file" name="file">
		</span>		
		<button type="submit" class="btn btn-primary">Envoyer</button>
	</div>

	<div style="overflow:scroll; width: 100%; height: 100px; margin-top: 2em;">
	{if isset($listeImages)}
		{foreach from=$listeImages item=image}
		<img src="../photos/{$image}" alt="{$image}" title="{$image}" style="width:50px"> 
		{/foreach}
	{/if}
	{if isset($matricule)}
		<img src="../photos/{$matricule}.jpg" alt="{$matricule}" title="{$matricule}" style="width:50px"> 
	{/if}
	</div>
</form>


</div>  <!-- container -->

<script type="text/javascript">
	
$(document).on('change', '.btn-file :file', function() {
    var input = $(this),
        numFiles = input.get(0).files ? input.get(0).files.length : 1,
        label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.trigger('fileselect', [numFiles, label]);
});	
	

$(document).ready(function(){
			
	$("form").submit(function(){
		$.blockUI();		
		$("#wait").show();
		})

	$('.btn-file :file').on('fileselect', function(event, numFiles, label) {
        $(".btn-file span").text(label);
		});

		
})

</script>
