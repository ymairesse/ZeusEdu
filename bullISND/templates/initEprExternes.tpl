<div class="container-fluid">

<h2>Épreuves externes</h2>

<div class="row">

	<div class="col-xs-4">
		
		<p>Préparation de la grille d'encodage des points des épreuves externes.</p>
		<p>Après choix du niveau d'étude et du cours, le module crée les enregistrements vides dans la table des épreuves externes. Les professeurs titulaires des cours initialisés trouveront les grilles d'encodage des réultats dans le menu "Bulletin" -> "Épreuves externes".</p>

		<form name="selectExternes" id="selectExternes" action="index.php" method="POST" class="form-inline" role="form">

			<select name="cours" id="cours" class="form-control">
				<option value="">Choisir un cours à initialiser</option>
				{foreach from=$listeCoursNiveau key=ceCours item=data}
				<option value="{$ceCours}" {if $ceCours == $cours}selected="selected"{/if}>{$data.libelle} [{$ceCours}]</option>
				{/foreach}
			</select>
			<button type="submit" class="btn btn-primary btn-sm">OK</button>
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="niveau" value="{$niveau}">
			<input type="hidden" name="etape" value="{$etape}">

		</form>


	</div>

	<div class="col-xs-8">

		<div id="tableExternes">

		{include file="tableEprExterne.tpl"}

		</div>
	</div>

</div>



</div>  <!-- container -->

<script type="text/javascript">

	$("document").ready(function(){

		$("#selectExternes").submit(function(){
			if ($("#cours").val() != "") {
				$("#wait").show();
				$("#corpsPage").hide();
				}
			else return false;
			})

	$("#tableExternes").on("click", ".suppr", function(){
			var coursGrp = $(this).parent().prev().text();
			var niveau = $("#niveau").val();
			$.post("inc/delCoursGrpEprExterne.inc.php", {
				'niveau': niveau,
				'coursGrp': coursGrp
				},
				function (resultat){
					$("#tableExternes").html(resultat);
					}
				)
			})

	})

</script>
