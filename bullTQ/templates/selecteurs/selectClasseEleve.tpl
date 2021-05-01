<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">

		<div class="form-group">
			<select name="classe" id="selectClasse" class="form-control">
				<option value="">Classe</option>
				{foreach from=$listeClasses item=uneClasse}
				<option value="{$uneClasse}" {if isset($classe) && ($uneClasse eq $classe)} selected="selected" {/if}>{$uneClasse}</option>
				{/foreach}
			</select>
		</div>


		<div class="form-group" id="choixEleve">
				<select name="matricule" id="selectEleve" class="form-control">
					<option value="">Choisir un élève</option>
					{if isset($listeEleves)} {* key = matric car $matricule est passé en argument *} {foreach from=$listeEleves key=matric item=eleve}
					<option value="{$matric}" {if isset($matricule) && ($matric eq $matricule)} selected{/if} title="{$matricule}">
						{$eleve.nom} {$eleve.prenom}</option>
					{/foreach} {/if}
				</select>
		</div>

		<button type="submit" class="btn btn-primary">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
	</form>

</div>

<script type="text/javascript">
	$(document).ready(function() {

		$("#formSelecteur").submit(function() {
			if ($("#selectEleve").val() != '') {
				$("#wait").show();
				$.blockUI();
			} else return false;
		})


		$("#selectClasse").change(function() {
			// on a choisi une classe dans la liste déroulante
			var classe = $(this).val();
			// la fonction listeEleves.inc.php renvoie la liste déroulante
			// des élèves de la classe sélectionnée
			$.post("inc/listeEleves.inc.php", {
						classe: classe
					},
					function(resultat) {
						$("#choixEleve").html(resultat)
					}
				)
				// $("#matricule").attr("disabled","");
		});

		$("#choixEleve").on("change", '#selectEleve', function() {
			if ($(this).val() > 0) {
				// si la liste de sélection des élèves renvoie une valeur significative
				// le formulaire est soumis
				$("#formSelecteur").submit();
			}
		})
	})
</script>
