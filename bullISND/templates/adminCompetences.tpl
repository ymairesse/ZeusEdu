<div class="container-fluid">

	<div class="row">

		<div class="col-xs-3 col-md-3">

			<div class="panel panel-info">
				<div class="panel-heading">
					Sélection
				</div>
				<div class="panel-body">
					<div class="form-group">
						<label for="selectNiveau">Année d'étude</label>
						<select class="form-control" name="niveau" id="selectNiveau">
							<option value="">Niveau d'étude</option>
							{foreach from=$listeNiveaux key=wtf item=niveau}
								<option value="{$niveau}">{$niveau}e année</option>
							{/foreach}
						</select>
					</div>

					<div id="choixCours">
						{include file="selecteurs/listeCoursComp.tpl"}
					</div>
				</div>

			</div>



		</div>

		<div class="col-md-5 col-xs-9">

			<div class="panel panel-success">
				<div class="panel-heading">
					Gestion des compétences
				</div>
				<div class="panel-body" id="gestionCompetences">

					<p class="avertissement">Sélectionner un cours à gauche</p>

				</div>

			</div>

		</div>

		<div class="col-md-4 col-xs-12">
			<div class="panel panel-info">
				<div class="panel-heading">
					Compétences
				</div>
				<div class="panel-body">
					<p>Pour ajouter une nouvelle compétences, cliquer le bouton "Ajouter une compétence". Un libellé générique est proposé; il suffit de le modifier.</p>
					<p>Les compétences déjà utilisées dans le bulletin ou dans le carnet de cotes ne peuvent être effacées. Le bouton de suppression est désactivé.</p>
					<p>Pour changer l'ordre de présentation des compétences dans le bulletin, ajuster le nombre dans la colonne de droite. Les valeurs ne doivent pas être consécutives.</p>
				</div>

			</div>

		</div>
		<!-- col-md... -->

		</div>
		<!-- row -->

</div>
<!-- container -->

<script type="text/javascript">

	var nbNewComp = 1;

	$(document).ready(function() {

		$('#formAdminCompetences').validate();

		$('#selectNiveau').change(function(){
			var niveau = $(this).val();
			$.post('inc/admin/getListeCoursNiveau.inc.php', {
				niveau: niveau
			}, function(resultat){
				$('#choixCours').html(resultat);
			})
		})

		$('body').on('change', '#cours', function(){
			var cours = $(this).val();
			$.post('inc/admin/getListeCompetences4cours.inc.php', {
				cours: cours
			}, function(resultat){
				$('#gestionCompetences').html(resultat);
			})
		})

		$('body').on('click', '#btn-addCompetence', function(){
			var cours = $('#cours').val();
			var libelle = 'Nouvelle compétence ' + nbNewComp;
			$.post('inc/competences/addCompetence.inc.php', {
				cours: cours,
				libelle: libelle
			}, function(resultat){
				if (resultat == -1)
					bootbox.alert({
						title: 'Erreur',
						message: 'Renommez et enregistrez d\'abord la compétence <strong>' + libelle + '</strong>'
					})
					else {
						$('#tableCompetences tbody').append(resultat);
						nbNewComp ++;
					}
			})
		})

		$('body').on('click', '#btn-saveCompetences', function(){
			if ($('#formAdminCompetences').valid()) {
				var formulaire = $('#formAdminCompetences').serialize();
				$.post('inc/competences/saveCompetences.inc.php', {
					formulaire: formulaire
				}, function(resultat){
					$('#gestionCompetences').html(resultat);
					var nb = $('#tableCompetences tbody tr').length;
					bootbox.alert({
						title: 'Enregistrement',
						message: nb + ' compétences enregistrées'
					})
				})
			}
		})

		$('body').on('click', '.btn-delCompetence', function(){
			var cours = $('#cours').val();
			var idComp = $(this).closest('tr').data('idcomp');
			var libelle = $('.lblComp[data-idcomp="' + idComp + '"]').val();
			bootbox.confirm({
				title: 'Suppression d\'une compétence',
				message: 'Veuille confirmer la suppression définitive de la compétence <br><strong>' + libelle + '</strong>',
				callback: function(resultat){
					if (resultat == true) {
						$.post('inc/competences/delCompetence.inc.php', {
							idComp: idComp,
							cours: cours
						}, function(resultat){
							$('#tableCompetences tr[data-idcomp="' + idComp +'"]').remove();
						})
					}
				}
			});
		})



	})
</script>
