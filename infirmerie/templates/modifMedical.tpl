<div class="container">

<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

<form role="form" class="form-vertical" name="modifMedical" id="modifMedical" method="POST" action="index.php">

	<div class="row">

		<div class="col-md-8 col-sm-12">

			<div class="panel panel-default">

				<div class="panel-body">

					<div class="form-group">
						<label for="medecin">Médecin traitant</label>
						<input type="text" name="medecin" maxlength="30" size="20" value="{$medicEleve.medecin}" id="medecin" class="form-control">
					</div>

					<div class="form-group">
						<label for="telMedecin">Télephone du médecin</label>
						<input type="text" name="telMedecin" value="{$medicEleve.telMedecin}" maxlength="20" id="telMedecin" class="form-control">
					</div>

				</div>

			</div>

		</div>

		<div class="col-md-2 col-sm-12">

			<img src="../photos/{$eleve.photo}.jpg" class="photo draggable" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}"
			id="photo" style="width:100px; clear:both">

		</div>

		<div class="col-md-2 col-sm-12">

			<input type="hidden" name="matricule" value="{$eleve.matricule}">
			<input type="hidden" name="classe" value="{$eleve.classe}">
			<input type="hidden" name="onglet" id="onglet" value="{$onglet|default:0}">
			<input type="hidden" name="action" value="enregistrer">
			<input type="hidden" name="mode" value="medical">
			<div class="btn-group-vertical pull-right">
				<button type="submit" class="btn btn-primary" name="submit">Enregistrer</button>
				<button type="reset" class="btn btn-default" name="reset">Annuler</button>
			</div>

		</div>

	</div>  <!-- row -->

	<div class="row">

		<div class="col-md-6 col-sm-12">

			<div class="panel panel-default">

				<div class="panel-header">
					<h4>Situation personnelle</h4>
				</div>

				<div class="panel-body">

					<div class="form-group">
						<label for="sitFamiliale">Situation de famille</label>
						<textarea name="sitFamiliale" id="sitFamiliale" rows="3" class="form-control">{$medicEleve.sitFamiliale}</textarea>
					</div>

					<div class="form-group">
						<label for="anamnese">Anamnèse</label>
						<textarea rows="2" name="anamnese" id="anamnese" class="form-control">{$medicEleve.anamnese}</textarea>
					</div>

				</div>

			</div>

		</div>

		<div class="col-md-6 col-sm-12">

			<div class="panel panel-default">

				<div class="panel-header">
					<h4>Particularités</h4>
				</div>

				<div class="panel-body">

					<div class="form-group">
						<p><label>Médicales</label><br /><textarea rows="3" name="medical" id="medical" class="form-control">{$medicEleve.medical}</textarea></p>
					</div>

					<div class="form-group">
						<label for="traitement">Traitement</label>
						<textarea rows="2" name="traitement" id="traitement" class="form-control">{$medicEleve.traitement}</textarea>
					</div>

					<div class="form-group">
						<label for="psy">Psy</label>
						<textarea rows="2" name="psy" id="psy" class="form-control">{$medicEleve.psy}</textarea>
					</div>

				</div>

			</div>  <!-- panel -->

		</div>  <!-- col-md.... -->


	</div>  <!-- row -->
</form>

<form name="retour" id="retour" action="index.php" method="POST" class="microForm">
	<input type="hidden" name="action" value="ficheEleve">
	<input type="hidden" name="mode" value="wtf">
	<input type="hidden" name="matricule" value="{$matricule}">
	<input type="hidden" name="classe" value="{$eleve.classe}">
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
