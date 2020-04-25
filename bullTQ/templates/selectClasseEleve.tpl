<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected="selected"{/if}>{$uneClasse}</option>
		{/foreach}
		</select>
		
		<span id="choixEleve">
			<select name="matricule" id="selectEleve">
				<option value="">Choisir un élève</option>
				{if isset($listeEleves)}
					{* key = matric car $matricule est passé en argument *}
					{foreach from=$listeEleves key=matric item=eleve}
					<option value="{$matric}"{if isset($matricule) && ($matric == $matricule)} selected{/if} title="{$matricule}">
						{$eleve.nom} {$eleve.prenom}</option>
					{/foreach}
				{/if}
			</select>
		</span>
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectEleve").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})
	

	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
		var classe = $(this).val();
		// la fonction listeEleves.inc.php renvoie la liste déroulante
		// des élèves de la classe sélectionnée
		$.post("inc/listeEleves.inc.php",
			{'classe': classe},
				function (resultat){
					$("#choixEleve").html(resultat)
				}
			)
		// $("#matricule").attr("disabled","");
	});

	$("#choixEleve").on("change", '#selectEleve', function(){
		if ($(this).val() > 0) {
			// si la liste de sélection des élèves renvoie une valeur significative
			// le formulaire est soumis
			$("#formSelecteur").submit();
			}
		})
})
{/literal}
</script>
