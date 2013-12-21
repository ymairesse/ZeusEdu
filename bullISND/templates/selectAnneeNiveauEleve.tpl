<div id="selecteur" class="noprint" style="clear:both">
	
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		
		<select name="annee" id="selectAnnee">
		<option value="">Année Scolaire</option>
		{foreach from=$listeAnnees item=uneAnnee}
			<option value="{$uneAnnee}"{if isset($annee) && ($uneAnnee == $annee)} selected="selected"{/if}>{$uneAnnee}</option>
		{/foreach}
		</select>
		
		<select name="niveau" id="selectNiveau">
			<option value=''>Niveau d'étude</option>
			{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if (isset($niveau) && ($niveau == $unNiveau))} selected="selected"{/if}>{$unNiveau}e annee</option>
			{/foreach}
		</select>

		<span id="choixEleve">

			{include file='listeElevesArchives.tpl'}

		</span>
	<input type="hidden" value="" name="nomEleve" id="nomEleve">
	<input type="submit" value="OK" name="OK" id="envoi" style="display:none">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="showEleve">
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

	$("#selectAnnee").change(function(){
		if (($(this).val() == '') || ($("#selectNiveau").val() == '')) 
			$("#selectEleve").hide();
			else $("#selectEleve").show();
		})

	$("#selectNiveau").change(function(){
		// on a choisi une année d'archive dans la liste déroulante
		var niveau = $(this).val();
		var annee = $("#selectAnnee").val();
		if ((annee != '') && (niveau != '')) $("#envoi").show();
		// la fonction listeElevesArchives.inc.php renvoie la liste déroulante des élèves pour l'année d'archive et le niveau
		$.post("inc/listeElevesArchives.inc.php",
			{'annee': annee,
			'niveau': niveau},
				function (resultat){
					$("#choixEleve").html(resultat)
				}
			)
	});

	$("#choixEleve").on("change","#selectEleve", function(){
		if (($("#selectAnnee").val() != '') && ($("#selectNiveau").val() != '') && ($("#selectEleve").val() != '')) {
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