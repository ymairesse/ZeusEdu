<div class="row">

<form id="form-infoMedic">

	<div class="col-xs-10 panel panel-success">
			<div class="panel-heading">
				<i class="fa fa-user"></i> Information médicale importante
			</div>
			<div class="panel-body">
				<div class="input-group">
					<input type="text" name="medicEleve" id="input-medicEleve" class="form-control" disabled value="{$medicEleve.info|default:''}">
					<div class="input-group-btn">
						<button type="button" class="btn btn-danger" id="btn-enable" disabled>
							<i class="fa fa-pencil"></i>
						</button>
					</div>
				</div>

			</div>
	</div>

	<div class="col-xs-2">
		<button type="button" class="btn btn-primary btn-block" id="btn-editMedic">Modifier</button>
		<button type="button" class="btn btn-success btn-block hidden btn-medic" id="btn-saveMedic">Enregistrer</button>
		<button type="reset" class="btn btn-default btn-block hidden btn-medic" id="btn-resetMedic">Annuler</button>
	</div>

	<div class="col-xs-12 col-md-6 panel">
			<div class="panel-body">
				<div class="form-group">
					<label for="medecin">Nom du médecin traitant</label>
					<input type="text" class="form-control" readonly name="medecin" id="medecin" value="{$medicEleve.medecin|default:''}">
				</div>
				<div class="form-group">
					<label for="telephone">Téléphone</label>
					<input type="text" class="form-control" readonly name="telMedecin" id="telephone" value="{$medicEleve.telephone|default:''}">
				</div>
			</div>
	</div>

	<div class="col-xs-12 col-md-6 panel panel-default">
		<div class="panel-body">
			<div class="form-group">
				<label for="situation">Situation de famille</label>
				<input type="text" class="form-control" readonly name="sitFamiliale" id="sitFamiliale" value="{$medicEleve.sitFamiliale|default:''}">
			</div>
			<div class="form-group">
				<label for="anamnese">Anamnèse</label>
				<input type="text" class="form-control" readonly name="anamnese" id="anamnese" value="{$medicEleve.anamnese|default:''}">
			</div>
		</div>
	</div>

	<div class="col-xs-12 panel panel-default">
		<div class="panel-body">
			<div class="form-group">
				<label for="medical">Particularités médicales</label>
				<input type="text" class="form-control" readonly name="medical" id="medical" value="{$medicEleve.medical|default:''}">
			</div>
			<div class="form-group">
				<label for="traitement">Traitement</label>
				<input type="text" class="form-control" readonly name="traitement" id="traitement" value="{$medicEleve.traitement|default:''}">
			</div>
			<div class="form-group">
				<label for="psy">Psy</label>
				<input type="text" class="form-control" readonly name="psy" id="psy" value="{$medicEleve.psy|default:''}">
			</div>
		</div>
	</div>

	<div class="clearfix"></div>

	<input type="hidden" name="matricule" value="{$dataEleve.matricule}">

</form>

</div>
