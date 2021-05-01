<div class="row">

	<div class="col-md-12 col-sm-12">
		{if isset($medicEleve.info) && ($medicEleve.info != '')}
		<div class="alert alert-danger"><span class="glyphicon glyphicon-warning-sign" style="font-size:200%"></span> {$medicEleve.info|default:''}</div>
		{else}
		<div class="alert alert-info">Information médicale importante: néant</div>
		{/if}
	</div>

</div>


	<div class="clearfix"></div>

	<div class="row">

		<div class="col-md-4 col-sm-6">
			<div class="panel panel-default">
				<div class="panel-header">
					<h4>Médecin traitant</h4>
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
				<div class="panel-header">
					<h4>Situation personnelle</h4>
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
				<div class="panel-header">
					<h4>Particularités</h4>
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
