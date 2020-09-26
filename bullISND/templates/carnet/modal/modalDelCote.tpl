<div class="modal fade noprint" id="modalSuppr" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Suppression d'une cote</h4>
			</div>

			<div class="modal-body">

				<div class="alert alert-danger"><span class="glyphicon glyphicon-warning-sign" style="color:red; font-size:1.5em"></span> Veuillez confirmer la suppression définitive de cette évaluation</div>

				<form name="formDel" action="index.php" method="POST" id="formDel" class="form-vertical">

					<div class="row">

						<div class="col-md-6 col-sm-12">
							<div class="form-group">
								<label>Date</label>
								<p class="form-control-static">{$entete.date}</p>
							</div>
						</div>  <!-- col-md-.. -->

						<div class="col-md-6 col-sm-12">
							<div class="form-group">
								<label>Compétence</label>
								<p class="form-control-static">{$entete.competence}</p>
							</div>
						</div>  <!-- col-md... -->

					</div>  <!-- row -->

					<div class="row">
						<div class="col-md-6 col-sm-12">
							<div class="form-group">
								{assign var=libelle value=$entete.libelle|replace:"\'":"'"}
								<label>Libellé</label>
								<p class="form-control-static">{$libelle}</p>
							</div>
						</div>  <!-- col-md-.. -->

						<div class="col-md-6 col-sm-12">
							<div class="form-group">
								{assign var=remarque value=$entete.remarque|replace:"\'":"'"}
								<label>Remarque</label>
								<p class="form-control-static">{$remarque}</p>
							</div>
						</div>  <!-- col-md-.. -->

					</div>  <!-- row -->

					<div class="row">
						<div class="col-md-4 col-sm-6">
							<div class="form-group">
								<label>Neutralisé</label>
								<p class="form-control-static">{if $entete.neutralise == 1}OUI{else}-{/if}</p>
							</div>
						</div>

						<div class="col-md-4 col-sm-6">
							<div class="form-group">
								<label>Formatif/Certificatif</label>
								<p class="form-control-static"></p>
							</div>
						</div>

						<div class="col-md-4 col-sm-6">
							<div class="form-group">
								<label>Maximum</label>
								<p class="form-control-static">{$entete.max}</p>
							</div>
						</div>  <!-- col-md-.. -->

					</div>  <!-- row -->

					<button type="button" class="btn btn-primary pull-right" id="btn-delCote" data-idcarnet="{$entete.idCarnet}">Effacer</button>
					<button type="reset" class="btn btn-default pull-right" data-dismiss="modal" >Annuler</button>
				</form>
			</div>
			{assign var=coursGrp value=$entete.coursGrp}
			<div class="modal-footer">
				<p>{$listeCours.$coursGrp.libelle} -> {$listeCours.$coursGrp.nomCours} [{$coursGrp}] / Bulletin n° {$entete.bulletin}</p>
			</div>

		</div>
	</div>
</div>
