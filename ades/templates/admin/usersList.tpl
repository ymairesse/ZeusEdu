<div class="container-fluid">

	<div class="row">

		<div class="col-md-9 col-sm-6">

			<h3>Liste des utilisateurs</h3>

			<div class="table-responsive" id="usersList">

				{include file="admin/tableUsersList.tpl"}

			</div>  <!-- table-responsive -->

			</div>   <!-- col-md-... -->

			<div class="col-md-3 col-sm-6">

				<h3>Ajouter un utilisateur</h3>

				<select name="acronyme" id="selectProf" class="form-control">
					<option value="">Sélectionner un utilisateur</option>
					{foreach from=$listeProfs key=cetAcronyme item=prof}
					<option value="{$cetAcronyme}"{if $acronyme == $cetAcronyme} disabled{/if}>{$prof.nom} {$prof.prenom} [{$cetAcronyme}]</option>
					{/foreach}
				</select>

				<select name="statut" id="statut" class="form-control">
					<option value="">Sélectionner un statut</option>
					{foreach from=$listeStatuts key=status item=statut}
					<option value="{$status}">{$statut}</option>
					{/foreach}
				</select>

				<button type="button" class="btn btn-primary btn-block" id="btn-addUser">OK</button>

			</div>  <!-- col-md.... -->

	</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

	$('#btn-addUser').click(function(){
		var utilisateur = $('#selectProf').val();
		var statut = $('#statut').val();
		var leStatut = $('#statut option:selected').text();
		if ((utilisateur != '') && (statut != '')) {
			var nom = $('#selectProf option:selected').text();
			$.post('inc/admin/addUser.inc.php', {
				utilisateur: utilisateur,
				statut: statut
				},
			function(resultat){
				if (resultat != '') {
					$('#usersList').html(resultat);
					bootbox.alert('Modification enregistrée pour <strong>' + nom + '</strong> => <strong>' + leStatut + '</strong>');
					}
					else bootbox.alert('Aucune modification enregistrée');
			})
		}
	})


	$('#usersList').on('change', '.statut', function(){
		var utilisateur = $(this).closest('tr').data('acronyme');
		var nom = $(this).closest('tr').data('nom');
		var statut = $(this).val();
		var leStatut = $(this).find("option:selected").text();
		$.post('inc/admin/saveStatut.inc.php', {
			utilisateur: utilisateur,
			statut: statut
		}, function(resultat){
			if (resultat > 0)
				bootbox.alert('Statut de <strong>' + nom + '</strong> modifié en <strong>' + leStatut + '</strong>');
		})
	})

	$('#usersList').on('click', '.btn-delUser', function(){
		var utilisateur = $(this).closest('tr').data('acronyme');
		var nom = $(this).closest('tr').data('nom');
		var ligne = $(this).closest('tr');
		bootbox.confirm('Veuillez confirmer la suppression de <strong>' + nom + '</strong>', function (confirmed){
			if (confirmed) {
				$.post('inc/admin/delUser.inc.php', {
					utilisateur: utilisateur
				},
				function(resultat){
					if (resultat == 1) {
						$(ligne).remove();
						bootbox.alert('L\'utilisateur <strong>' + nom + '</strong> a été supprimé');
					}
				})
			}
		})

	})

	$("#addUser").submit(function(){
		var statut = $("#statut").val();
		var user = $("#selectProf").val();
		if ((statut == '') || (user == '')) {
			return false;
		}
	})

</script>
