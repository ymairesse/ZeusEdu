<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">

		<select name="anneeScolaire" id="anneeScolaire" class="form-control">
		<option value="">Année Scolaire</option>
		{foreach from=$listeAnnees item=uneAnnee}
			<option value="{$uneAnnee}"{if isset($anneeScolaire) && ($uneAnnee == $anneeScolaire)} selected="selected"{/if}>{$uneAnnee}</option>
		{/foreach}
		</select>

		<select name="niveau" id="selectNiveau" class="form-control">
			<option value=''>Niveau d'étude</option>
			{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if (isset($niveau) && ($niveau == $unNiveau))} selected="selected"{/if}>{$unNiveau}e annee</option>
			{/foreach}
		</select>

		<span id="choixEleve">

			{include file='listeElevesArchives.tpl'}

		</span>
	<input type="hidden" value="" name="nomEleve" id="nomEleve">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="showEleve">
	<button type="submit" class="btn btn-primary btn-sm" id="envoi" style="display:none">OK</button>
	</form>

</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if (($("#selectAnnee").val() != '') && ($("#selectNiveau").val() != '') && ($("#selectEleve").val() != '')) {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})

	$("#anneeScolaire").change(function(){
		if (($(this).val() == '') || ($("#selectNiveau").val() == ''))
			$("#selectEleve").hide();
			else {
				var niveau = $("#selectNiveau").val();
				var anneeScolaire = $(this).val();
				$.post("inc/listeElevesArchives.inc.php",
					{'annee': anneeScolaire,
					 'niveau': niveau},
					 function (resultat) {
						$("#choixEleve").html(resultat)
						}
				)
				$("#selectEleve").show();
				}
		})

	$("#selectNiveau").change(function(){
		// on a choisi une année d'archive dans la liste déroulante
		var niveau = $(this).val();
		var anneeScolaire = $("#anneeScolaire").val();
		if ((anneeScolaire != '') && (niveau != '')) $("#envoi").show();
		// la fonction listeElevesArchives.inc.php renvoie la liste déroulante des élèves pour l'année d'archive et le niveau
		$.post("inc/listeElevesArchives.inc.php",
			{'annee': anneeScolaire,
			 'niveau': niveau},
				function (resultat){
					$("#choixEleve").html(resultat)
				}
			)
	});

	$("#choixEleve").on("change","#selectEleve", function(){
		if (($("#anneeScolaire").val() != '') && ($("#selectNiveau").val() != '') && ($("#selectEleve").val() != '')) {
			// si la liste de sélection des élèves renvoie une valeur significative le formulaire est soumis
			var nomEleve = $("#choixEleve option:selected").text();
			$("#nomEleve").val(nomEleve);
			$("#formSelecteur").submit();
			$("#envoi").show();
		}
			else $("#envoi").hide();
		})


})
{/literal}
</script>
