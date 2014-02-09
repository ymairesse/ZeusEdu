<p><img src="../photos/{$eleve.photo}.jpg" class="photo draggable" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}" 
	id="photo" style="width:100px; top:-60px; position: relative" /></p>
	<form name="padEleve" id="padEleve" method="POST" action="index.php">
		<input type="hidden" name="classe" value="{$classe}">
		<input type="hidden" name="matricule" value="{$matricule}">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="savePad">
		<input type="Submit" name="submit" value="Enregistrer">
		{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
		<input type="hidden" class="onglet" name="onglet" value="{$onglet|default:0}">
		<hr>
		<textarea id="memo" name="texte" cols="90" rows="20" class="ckeditor" placeholder="Frappez votre texte ici" autofocus="true">{$memoEleve->getPadText()}</textarea>
	</form>


<script type="text/javascript">

{literal}

$(document).ready(function(){

	$("#padEleve").submit(function(){
		window.onbeforeunload = function(){};
		$.blockUI();
		$("#wait").show();
		})
	
})

{/literal}
</script>
