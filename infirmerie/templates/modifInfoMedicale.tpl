<div class="container">

<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

<form role="form" class="form-vertical" name="modifMedical" id="modifMedical" method="POST" action="index.php">

	<div class="row">

		<div class="col-md-10 col-sm-8">
			<div class="formGroup">
				<label for="info">Informations médicales</label>
				<textarea name="infoMedicale" id="info" class="form-control">{$infoMedicale}</textarea>
			</div>
		</div>

		<div class="col-md-2 col-sm-4">
			<input type='hidden' name="matricule" value="{$matricule}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="etape" value="enregistrer">
			<div class="btn-group-vertical pull-right">
				<button class="btn btn-primary btn-lg" type="submit">Enregistrer</button>
				<button class="btn btn-default btn-lg" type="reset">Annuler</button>
			</div>
		</div>

	</div>  <!-- row -->
</form>

<form name="retour" id="retour" action="index.php" method="POST" class="microForm">
	<input type="hidden" name="action" value="ficheEleve">
	<input type="hidden" name="mode" value="wtf">
	<input type="hidden" name="matricule" value="{$matricule}">
	<input type="hidden" name="onglet" id="onglet" value="{$onglet|default:0}">
	<button type="submit" class="btn btn-primary pull-right" id="retour">Retour sans enregistrer</button>
</form>

</div>  <!-- container -->

<script type="text/javascript">

	$("document").ready(function(){

		$("#modifMedical").submit(function(){
			$.blockUI();
			$("#wait").show();
		})

	})
</script>
