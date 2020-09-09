<div class="container-fluid">

<h2>Gestion des listes de destinataires</h2>

	<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
        <li class="active"><a href="#gestMailing" data-toggle="tab">Vos listes personnelles</a></li>
        <li><a href="#abonnements" data-toggle="tab">Vos publications et abonnements</a></li>
    </ul>
    </ul>

    <div id="my-tab-content" class="tab-content">

		<div class="tab-pane active" id="gestMailing">
			{include file="inc/gestMailing.inc.tpl"}
		</div>

		<div class="tab-pane" id="abonnements">
			{include file="inc/abonnements.inc.tpl"}
		</div>

	</div>

</div>  <!-- container -->

<div id="modal"></div>

<script type="text/javascript">

$(document).ready(function(){

	$('#abonnements').on('click', '.btn-desabo', function(){
		var idListe = $(this).closest('tr').data('idliste');
		$.post('inc/desAboListe.inc.php', {
			idListe: idListe
		}, function(resultat){
			if (resultat == 1) {
				$.post('inc/refreshPageAbonnements.inc.php',{
				}, function(resultat){
					$('#abonnements').html(resultat);
				})
			}
		})
	})

	$('#abonnements').on('click', '.btn-approp', function(){
		var idListe = $(this).closest('tr').data('idliste');
		$.post('inc/appropListe.inc.php', {
			idListe: idListe
		}, function(resultat){
			$.post('inc/refreshPageAbonnements.inc.php',{
			}, function(resultat){
				$('#abonnements').html(resultat);
				// rafraichissement du tableau de la liste des listes (gauche)
				$.post('inc/listeListes.inc.php', {
				}, function(resultat){
					$('#listeListes').html(resultat);
				})
			})
		})
	})

	$('#abonnements').on('click', '.btn-abo', function(){
		var idListe = $(this).closest('tr').data('idliste');
		$.post('inc/aboListe.inc.php', {
			idListe: idListe
		}, function(resultat){
			$.post('inc/refreshPageAbonnements.inc.php',{
			}, function(resultat){
				$('#abonnements').html(resultat);
			})
		})
	})

	$('#gestMailing').on('click', '#btn-reset', function(){
		$('#nomListe').val('');
	})

	$('#gestMailing').on('click', '#btn-create', function(){
		var nomListe = $('#nomListe').val();
		if (nomListe != '') {
			$.post('inc/createNewListe.inc.php', {
				nomListe: nomListe
			}, function (resultat){
				$('#listeListes').html(resultat);
				// rafraichissement du choix des listes dans la gestion des membres
				$.post('inc/getChoixListe.inc.php', {
				}, function(resultat){
					$('#choixListe').html(resultat);
					$('#nomListe').val('');
				})
				bootbox.alert({
					title: 'Création d\'une liste',
					message: 'La liste <strong>' + nomListe + '</strong> a été créée'
				});
			})
		}
	})

	$('#gestMailing').on('click', '#btn-tous', function(){
		$('#listeMails li').find('input:checkbox').prop('checked', true);
	})

	$('#gestMailing').on('click', '#btn-none', function(){
		$('#listeMails li').find('input:checkbox').prop('checked', false);
	})

	$('#gestMailing').on('click', '#btn-invert', function(){
		var boutons = $('#listeMails li').find('input:checkbox');
		boutons.each(function(index){
			if ($(this).prop('checked') == true)
				$(this).prop('checked', false)
				else $(this).prop('checked', true);
		})
	})

	$('#gestMailing').on('click', '.btn-delListe', function(){
		var idListe = $(this).closest('tr').data('idliste');
		$.post('inc/getModalDelListe.inc.php', {
			idListe: idListe
		}, function(resultat){
			$('#modal').html(resultat);
			$('#modalDelListe').modal('show');
		})
	})
	$('#modal').on('click', '#btn-modalDelListe', function(){
		var idListe = $(this).data('idliste');
		$.post('inc/delListe.inc.php', {
			idListe: idListe
		}, function(resultat){
			if (resultat == 1) {
				// suppression de la ligne dans le tableau des listes
				$('#tableListes tr[data-idliste="' + idListe + '"]').remove();
				// remise à zéro des cases à cocher de la liste des profs
				$('#listeMails li').find('input:checkbox').prop('checked', false);
				// remise à zéro de la liste des membres (sans idListe)
				$.post('inc/listeMembres.inc.php',{
				}, function(resultat){
					$('#listeMembres').html(resultat);
					$.post('inc/refreshPageAbonnements.inc.php',{
					}, function(resultat){
						$('#abonnements').html(resultat);
					})
				})
			}
			$('#modalDelListe').modal('hide');
		})
	})

	$('#gestMailing').on('click', '.btn-delMembre', function(){
		var membre = $(this).closest('tr').data('acronyme');
		var idListe = $('#tableListes tr.selected').data('idliste');
		$.post('inc/delMembre4liste.inc.php', {
			membre: membre,
			idListe: idListe
		}, function(resultat){
			if (resultat != '') {
				$('#listeMembres table tr[data-acronyme="' + membre + '"]').remove();
				// rafraichissement de la liste des listes
				// (pour le nombre de membres de la présente liste)
				$.post('inc/listeListes.inc.php', {
					idListe: idListe
				}, function(resultat){
					$('#listeListes').html(resultat);
				});
			}
		})
	})

	$('#gestMailing').on('click', '#btn-addMembres', function(){
		var title = 'Ajout de nouveaux membres';
		var idListe = $('#tableListes tr.selected').data('idliste');
		if (idListe != undefined){
			var formulaire = $('#ajoutMembres').serialize();
			$.post('inc/addNewMembres.inc.php', {
				formulaire: formulaire,
				idListe: idListe
			}, function(resultat){
				var nb = parseInt(resultat);
				if (nb > 0) {
					// affichage de la liste des membres
					$.post('inc/listeMembres.inc.php', {
						id: idListe
						},
						function (resultat){
							$("#listeMembres").html(resultat);
							// rafraichissement de la liste des listes
							// et des nombres de membres
							$.post('inc/listeListes.inc.php', {
								idListe: idListe
							}, function(resultat){
								$('#listeListes').html(resultat);
							});
							bootbox.alert({
								title: title,
								message: nb + ' membre(s) ajouté(s)'
								})
							});
				}
				else bootbox.alert({
					title: title,
					message: 'Aucun nouveau membre ajouté'
				})
			})
		}
		else bootbox.alert({
			title: title,
			message: 'Veuillez choisir une liste'
		})
	})

	$(".mailsAjout").click(function(){
		var nb = $(".mailsAjout:input:checkbox:checked").length
		$("#selectionAdd").text(nb);
		})
	$("#resetAdd").click(function(){
		$("#selectionAdd").text(0);
		})
	$("#resetDel").click(function(){
		$("#selectionDest").text(0)
		})

	$('#gestMailing').on('click', "#tableListes tbody td", function(){
		var id = $(this).closest('tr').data('idliste');
		$('#tableListes tr').removeClass('selected');
		$(this).closest('tr').addClass('selected');
		$.post('inc/listeMembres.inc.php', {
			id: id
			},
			function (resultat){
				$("#listeMembres").html(resultat);
				$.post('inc/listeProfs.inc.php', {
					id: id
				}, function(resultat){
					$('#listeMails').html(resultat);
				})
				});
		});

})

</script>
