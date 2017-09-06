<div class="container">
	
	<h3>Suppression d'élèves</h3>
	
	<form name="suppression" id="supprEleves" action="index.php" method="POST">
	<fieldset>
	<p>Seuls les élèves qui ne sont affectés à aucun cours peuvent être supprimés</p>
	<legend>Sélectionner un ou plusieurs élèves</legend>
	<select name="eleves[]" id="selectEleveDel" multiple="multiple" size="10" style="float:left">
		{foreach from=$listeEleves key=matricule item=eleve}
		<option value="{$matricule}">{$eleve.groupe}: {$eleve.nom} {$eleve.prenom}</option>
		{/foreach}
	</select>
	<input type="submit" name="suppress" id="suppress" value="Supprimer">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="etape" value="confirmer">
	</fieldset>
	</form>

</div>

<script type="text/javascript">

	$(document).ready(function(){
			
		$("#supprEleves").submit(function(){
			var suppr = $("#selectEleveDel").val();
			if (suppr == null) {
				alert("Veuillez sélectionner au moins un élève");
				return false;
			}
			suppr = suppr.toString();
			while (suppr != (suppr = suppr.replace(',','\n ')));
			if (!(confirm("Veuillez confirmer la suppression définitive des élèves suivants\n"+suppr)))
				return false;
			$("#wait").show();
			$.blockUI();
			})	
	})

</script>
