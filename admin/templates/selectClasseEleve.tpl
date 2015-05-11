<div id="selecteur" class="noprint" style="clear:both">
	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php">
	<select name="laClasse" id="selectClasse">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=classe}
			<option value="{$classe}"{if $classe eq $laClasse} selected{/if}>{$classe}</option>
		{/foreach}
	</select>
	<span id="choixEleve">
		{* Emplacement de la liste de sélection des élèves *}
		<select name="matricule" id="selectEleve">
			<option value="">Choisir un élève</option>
			{if isset($listeEleves)}
				{* key = matric car $matricule est passé en argument *}
				{foreach from=$listeEleves key=matric item=eleve}
				<option value="{$matric}"{if isset($matricule) && ($matric == $matricule)} selected="selected"{/if}>
					{$eleve.nom} {$eleve.prenom}</option>
				{/foreach}
			{/if}
		</select>
	</span>
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="gestEleves">
	<input type="hidden" name="mode" value="modifEleve">
	<input type="hidden" name="etape" value="showEleve">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectEleve").val() != '')
			$("#wait").show();
			else return false;
	})

	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
			var classe = $(this).val();
		if (classe != '') $("#envoi").show();
		// la fonction listeEleves.inc.php renvoie la liste déroulante
		// des élèves de la classe sélectionnée
		$.post('inc/listeEleves.inc.php', {
			'classe': classe,
			'partis': true
			},
				function (resultat){
					$("#choixEleve").html(resultat)
				}
			)
	});

	$("#selectEleve").change(function(){
		if ($(this).val() > 0) {
			// si la liste de sélection des élèves renvoie une valeur significative
			// le formulaire est soumis
			$("#formSelecteur").submit();
			$("#envoi").show();
		}
			else $("#envoi").hide();
		})
})

</script>
