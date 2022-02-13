<div class="container-fluid">

	<div class="row">

		<div class="col-md-9 col-sm-12">

			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">Voir et modifier les pondérations par périodes</h3>
				</div>

				<div class="panel-body">
					<h4>{$intituleCours.coursGrp} | {$intituleCours.nomCours} {$intituleCours.nbheures}h {$intituleCours.statut} ({$listeClasses})</h4>
					<div class="table-responsive" id="table-ponderation">

						{include file="ponderation/tablePonderation.tpl"}

					</div>
				</div>
				<div class="panel-footer">

				</div>
			</div>


		</div>
		<!-- col-md... -->

		<div class="col-md-3 col-sm-12">
			{include file="ponderation/noticeBaremes.html"}
		</div>
		<!-- col-md... -->

	</div>
	<!-- row -->

</div>
<!-- container -->

<div id="modal">

</div>

<script type="text/javascript">
	$(document).ready(function() {

		$(document).ajaxStart(function() {
			$('body').addClass("wait");
		}).ajaxComplete(function() {
			$('body').removeClass("wait");
		});

		$('body').on('change', '.listeEleves', function() {
			var matricule = $(this).val();
			var coursGrp = $(this).data('coursgrp');
			$.post('inc/ponderation/clonePonderation.inc.php', {
				coursGrp: coursGrp,
				matricule: matricule
			}, function(resultatJSON){
				var resultat = JSON.parse(resultatJSON);
				var nb = resultat['nb'];
				$('#table-ponderation').html(resultat['html']);
				bootbox.alert({
					title: 'Enregistrement des pondérations',
					message: nb + ' ponderation(s) enregistrée(s)'
				})
			})
		})

		$('body').on('click', '.btnMoins', function() {
			var matricule = $(this).data('matricule');
			var coursGrp = $(this).data('coursgrp');
			$.post('inc/ponderation/delPonderation.inc.php', {
				coursGrp: coursGrp,
				matricule: matricule
			}, function(resultat) {
				$("#modal").html(resultat);
				$("#modalDelPonderation").modal('show');
			});
		})
		$('#modal').on('click', '#btn-modalDelPonderation', function(){
			var matricule = $(this).data('matricule');
			var coursGrp = $(this).data('coursgrp');
			$.post('inc/ponderation/modalDelPonderation.inc.php', {
				coursGrp: coursGrp,
				matricule: matricule
			}, function(nb){
				$('#modalDelPonderation').modal('hide');
				$('#table-ponderation .btnMoins[data-matricule="'+matricule+'"]').closest('tr').remove()
				bootbox.alert({
					title: 'Suppression des pondérations',
					message: nb + ' pondération(s) supprimée(s)'
				})
			})
		})

		$('body').on('click', '.btnPlus', function() {
			var matricule = $(this).closest('tr').find('select').val();
			var coursGrp = $(this).data('coursgrp');
			// période en cours (n° du bulletin)
			var bulletin = $(this).data('bulletin');

			// noter les valeurs de pondérations dans le formulaire de la boîte modale
			$.post('inc/ponderation/addPonderation.inc.php', {
					matricule: matricule,
					coursGrp: coursGrp,
					bulletin: bulletin
				},
				function(resultat) {
					$('#modal').html(resultat);
					$('#modalPonderation').modal('show');
				});
		})

		$('body').on('click', '.editPonderation', function() {
			// matricule de l'élève concerné ou "all" si tous les élèves
			var matricule = $(this).data('matricule');
			var coursGrp = $(this).data('coursgrp');
			// période en cours (n° du bulletin)
			var bulletin = $(this).data('bulletin');

			// noter les valeurs de pondérations dans le formulaire de la boîte modale
			$.post('inc/ponderation/addPonderation.inc.php', {
					matricule: matricule,
					coursGrp: coursGrp,
					bulletin: bulletin
				},
				function(resultat) {
					$('#modal').html(resultat);
					$('#modalPonderation').modal('show');
				});
		})

		$('#modal').on('click', '#savePonderation', function(){
			var formulaire = $('#formPonderations').serialize();
			$.post('inc/ponderation/savePonderations.inc.php', {
				formulaire: formulaire
			}, function(resultatJSON){
				var resultat = JSON.parse(resultatJSON);
				var nb = resultat['nb'];
				if (nb > 0) {
					$('#table-ponderation').html(resultat['html']);
					bootbox.alert({
						title: 'Enregistrement des pondérations',
						message: nb + ' ponderation(s) enregistrée(s)'
					})
				}
				$('#modalPonderation').modal('hide');
			})
		})

	})
</script>
