<div class="col-md-9 col-sm-10">

	<h2>Liste des partages</h2>

	<form id="formPartages">

		<h3>{if (isset($coursGrp))}
			{$listeCours.$coursGrp.nomCours|default:''} - [{$coursGrp}] {$listeCours.$coursGrp.statut} {$listeCours.$coursGrp.libelle} {$listeCours.$coursGrp.nbheures}h
		{/if}
		{if isset($classe)}
			Classe: {$classe}
		{/if}
		</h3>

		<div id="zonePartages" style="height: 35em; overflow: auto;">

			{include file="tableauPartages.tpl"}

		</div>

		<div class="clearfix"></div>

	</form>

</div>  <!-- col-md... -->

<div class="col-md-3 col-sm-2">

	<h4>Légende</h4>
	<table class="table table-condensed">
		<tr>
		<td style="width:30em;" class="r">Lecture seule (pas de modification)</td>
		<td style="width:30em" class="rw">Lecture et écriture (modifications autorisées</td>
		</tr>
	</table>

</div>  <!-- col-md-4 -->



<div id="modal"></div>

<script type="text/javascript">

	$(document).ready(function(){

		$('#zonePartages').on('click', '.btn-partage', function(){
			var matricule = $(this).data('matricule');
			var id = $(this).data('id');
			var guest = $(this).data('guest');
			var mode = $(this).data('mode');
			var bouton = $(this);
			$.post('inc/modalEditShare.inc.php', {
				matricule: matricule,
				id: id,
				guest: guest,
				mode: mode
			}, function(resultat){
				$('#modal').html(resultat);
				$('#modalAddPartage').modal('show');
			})
		})

		$('#zonePartages').on('click', '#btn-shareAll', function(){
			var formulaire = $('#formPartages').serialize();
			$.post('inc/modalAddShare.inc.php', {
				formulaire: formulaire
			}, function(resultat){
				$('#modal').html(resultat);
				$('#modalAddPartage').modal('show');
			})
		})

		$('#zonePartages').on('click', '.btn-addShare', function(){
			var matricule = $(this).data('matricule');
			var mode = 'r';
			$.post('inc/modalAddShare.inc.php', {
				matricule: matricule,
				mode: mode
			}, function(resultat){
				$('#modal').html(resultat);
				$('#modalAddPartage').modal('show');
			})
		})

        $('#modal').on('click', '#modalConfirmAddShare', function(){
            var formulaire = $('#formAddShare').serialize();
            $.post('inc/actualAddShare.inc.php', {
                formulaire: formulaire
            }, function(resultat){
				var texte = (resultat >= 0) ? 'ajouté(s)' : 'supprimé(s)';
				var nb = Math.abs(resultat)
				var mode = $('#mode').val();
				if (mode == 'parClasse') {
					var groupe = $('#selectClasse').val();
				}
				else {
					var groupe = $('#coursGrp').val();
				}
				$('#modalAddPartage').modal('hide');
				bootbox.alert({
					title: 'Partage des notes',
					message: nb + ' partage(s) ' + texte,
				});
				$.post('inc/tablePartages.inc.php', {
					mode: mode,
					groupe: groupe
				},
				function(resultat){
					$('#zonePartages').html(resultat);
				})
            })
        })

	})

</script>
