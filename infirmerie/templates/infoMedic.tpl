<div class="row">

	<div class="col-md-2 col-sm-4">
		<form name="modifInfo" id="modifInfo" role="form" class="form-inline" action="index.php" method="POST">
			{if isset($medicEleve.info) && ($medicEleve.info != '')}
			<button class="btn btn-primary btn-lg" type="submit" name="submit">Modifier <span class="glyphicon glyphicon-chevron-right"></span></button>
			{else}
			<button class="btn btn-primary" type="submit" name="submit">Ajouter <span class="glyphicon glyphicon-chevron-right"></span></button>
			{/if}
			<input type="hidden" name="action" value="modifier">
			<input type="hidden" name="mode" value="infoMedicale">
			<input type="hidden" name="infoMedicale" value="{$medicEleve.info|default:''}">
			<input type="hidden" name="classe" value="{$eleve.classe}">
			<input type="hidden" name="matricule" value="{$matricule}">
			<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
		</form>
	</div>

	<div class="col-md-10 col-sm-8">
		{if isset($medicEleve.info) && ($medicEleve.info != '')}
		<div class="alert alert-danger"><span class="glyphicon glyphicon-warning-sign" style="font-size:200%"></span> {$medicEleve.info|default:''}</div>
		{else}
		<div class="alert alert-info">Information médicale importante: néant</div>
		{/if}
	</div>

</div>


	<form name="modifMedical" method="POST" action="index.php" class="microForm form-vertical" role="form">
		<button class="btn btn-primary pull-right" type="submit" name="submit">Modifier</button>
		<input type="hidden" name="action" value="modifier">
		<input type="hidden" name="mode" value="medical">
		<input type="hidden" name="classe" value="{$eleve.classe}">
		<input type="hidden" name="matricule" value="{$matricule}">
		<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>

	<div class="clearfix"></div>

	<div class="row">

		<div class="col-md-4 col-sm-6">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3>Médecin traitant</h3>
				</div>
				<div class="panel-body">
					<dl>
						<dt>Nom</dt>
							<dd>{$medicEleve.medecin|default:'-'}</dd>

						<dt>Téléphone</dt>
							<dd>{$medicEleve.telMedecin|default:'-'}</dd>
					</dl>
				</div>
			</div>
		</div>

		<div class="col-md-4 col-sm-6">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3>Situation personnelle</h3>
				</div>
				<div class="panel-body">
					<dl>
						<dt>Situation de famille</dt>
							<dd>{$medicEleve.sitFamiliale|default:'-'}</dd>
						<dt>Anamnèse</dt>
							<dd>{$medicEleve.anamnese|default:'-'}</dd>
					</dl>
				</div>
			</div>
		</div>


		<div class="col-md-4 col-sm-6">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3>Particularités</h3>
				</div>
				<div class="panel-body">
					<dl>
						<dt>Médicales</dt>
							<dd>{$medicEleve.medical|default:'-'}</dd>
						<dt>Traitement</dt>
							<dd>{$medicEleve.traitement|default:'-'}</dd>
						<dt>Psy</dt>
							<dd>{$medicEleve.psy|default:'&nbsp;'}</dd>
					</dl>
				</div>
			</div>
		</div>

	</div>  <!-- row -->
