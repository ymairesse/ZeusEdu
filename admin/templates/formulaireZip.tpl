<h2>Envoi des photos d'élèves</h2>

<form enctype="multipart/form-data" method="POST" action="index.php" style="min-height:600px">
	<p>Sélectionnez une archive ZIP (max 4 Mo) ou une photo individuelle (format .jpg).</p>
	<p>Le nom de la photo est le matricule de l'élève.</p>
	{if isset($filename)}
	<p class="micro">Fichier précédent envoyé: {$filename}</p>
	{/if}	
	<input type="hidden" name="action" value="gestEleves">
	<input type="hidden" name="mode" value="envoiPhotos">
	<input type="file" name="file">
	<input type="submit" name="etape" value="Envoyer" />

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

{if isset($info)}
	<div id="info" title="Information">
		{$info}
	</div>
{/if}


<script type="text/javascript">
{literal}
	$(document).ready(function(){
	$("#info").dialog({
		modal: true,
		autoOpen: true,
		width: 400,
		buttons: {
			Ok: function() {
				$( this ).dialog("close" );
				}
			}
		});
			
	$("form").submit(function(){
		$.blockUI();		
		$("#wait").show();
		})
		
	})
{/literal}
</script>
