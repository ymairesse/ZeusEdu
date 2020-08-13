<div class="container-fluid">

	<h2>Historique et Annonces</h2>

		{* les différents onglets pour les différents destinataires possibles *}
		<ul class="nav nav-tabs">

			{foreach from=$listeTypes key=type item=data}
				{if $data.droits == Null || in_array($userStatus, $data.droits)}
				<li>
					<a data-toggle="tab" data-type="{$type}" href="#tabs-{$type}" class="onglet">{$data.texte}
						<span class="badge" data-type="{$type}">{$listeNotifications.$type|@count|default:0}</span></a>
				</li>
				{/if}
			{/foreach}

			{* un onglet supplémentaire pour l'éditeur d'annonces *}
			<li class="pull-right">
				<a data-toggle="tab" href="#tabs-edit" id="onglet-edit" class="btn-lightBlue"><i class="fa fa-edit"></i> Éditeur d'annonces</a>
			</li>
		</ul>

		{* la liste des panneaux nécessaires pour chaque type de destinataire  *}
		<div class="tab-content" id="ficheEleve">

			{foreach from=$listeTypes key=type item=data name=boucle}
				{if $data.droits == Null || in_array($userStatus, $data.droits)}
					{if isset($listeNotifications.$type)}
						{assign var=liste value=$listeNotifications.$type}
						<div id="tabs-{$type}" class="tab-pane fade{if $smarty.foreach.boucle.index == 0} in active{/if}">
						{include file="notification/edit/notification4Type.tpl"}
						</div>
						{else}
						<div id="tabs-{$type}" class="tab-pane fade{if $smarty.foreach.boucle.index == 0} in active{/if}">
						<p class="avertissement">Aucune annonce de ce type</p>
						</div>
					{/if}
				{/if}
			{/foreach}
			{* l'éditeur d'annonces *}
			<div id="tabs-edit" class="tab-pane fade">

				{include file="notification/edit/tabEdit.tpl"}

			</div>

		</div>
		<!-- tab-content -->

</div>
<!-- container -->

<!-- .......................................................................... -->
<!-- .....formulaire modal pour la  suppression multiple de notifications   ..  -->
<!-- .......................................................................... -->
{include file="notification/modal/modalBulkDelete.tpl"}

<!-- .......................................................................... -->
<!-- .....formulaire modal pour la  suppression d'une notification          ..  -->
<!-- .......................................................................... -->
{include file="notification/modal/modalDelete.tpl"}

<!-- .......................................................................... -->
<!-- .....formulaire modal pour l'édition  des PJ (ajout/suppr)             ..  -->
<!-- .......................................................................... -->
{include file="files/modal/modalTreeView.tpl"}
<!-- .......................................................................... -->
<!-- .....formulaire modal pour la lecture des accusés de réception          ..  -->
<!-- .......................................................................... -->
{include file="notification/modal/modalAccuses.tpl"}

<script type="text/javascript">

	function resetForm(){
		$('#texte').summernote('enable');
		$('#texte').summernote('code', '');
	}

	function reset(){
		$('#texte').summernote('enable');
		$('#texte').summernote('code', '');

		var ajd = moment().format('DD/MM/YYYY');
		var dans1mois = moment().add(1, 'months').format('DD/MM/YYYY');
		$('#objet').val('');
		$('#dateDebut').val(ajd);
		$('#dateFin').val(dans1mois);
		$('#notification input[type=checkbox], #notification input[type=text]').prop('readOnly', false);
		$('#notification input[type=text]').prop('disabled', false);
		$('#notification input[type=hidden]').val('');
		$('#PjFiles li').remove();
		// décocher les cases à cocher du formulaire et les fichiers sélectionnés dans le fileTree
		$('.cb, .selectFile').prop('checked', false);
		$('#divType, #selecteur').removeClass('hidden');
		$('#selecteur select').prop('disabled', false);
		$('#type').val('').trigger('change');
		$('.sousType').addClass('hidden');
		$('#dateEnvoi').addClass('hidden').html('');
	}

	$(document).ready(function() {

		// activer l'onglet dont le type a été passé
		var ongletNotif = Cookies.get('ongletNotif');
		if ((ongletNotif != undefined)) {
			$('.onglet[data-type="' + ongletNotif + '"]').trigger('click');
		}
		// enregistrer l'onglet sélectionné dans un Cookie
		$('.onglet').click(function(){
			var type = $(this).data('type');
			Cookies.set('ongletNotif', type, { expires: 365 });
		})

		$(document).ajaxStart(function() {
			$('body').addClass('wait');
		}).ajaxComplete(function() {
			$('body').removeClass('wait');
		});

		$('#ficheEleve').on('click', '#btn-raz', function(){
			$('#choixEleves').addClass('hidden');
			$('#submitNotif').attr('disabled', true);
			$('#texte').summernote('code', '');
			$('#objet').val('');
			$('#type').val('').trigger('change');
			$('#dateEnvoi').addClass('hidden').html('');
			$('#selecteurVertical select').attr('readonly', false);
			$('#PjFiles').html('<p>Pas de pièce jointe</p>');
		})

		$('#ficheEleve').on('click', '#reset', function(){
			bootbox.confirm({
				message: "Veuillez confirmer l'annulation d'envoi de cette annonce",
				buttons: {
					cancel: {
						label: 'Oups... non',
						className: 'btn-default'
					},
					confirm: {
						label: 'Je veux remettre à zéro',
						className: 'btn-danger'
					}
				},
				callback: function(result) {
					if (result == true) {
						resetForm();
					}
				}
			})
		})

		// enregistrement et envoi d'une annonce
		$('#ficheEleve').on('click', '#submitNotif', function(){
			var texteAnnonce = $('#texte').summernote('code');
			// attribuer le texte au formulaire "normal"
			$('#notification #texte').val(texteAnnonce);
			if ($('#notification').valid()) {
				var formulaire = $('#notification').serialize();

				// la case à cocher "TOUS"
				var tous = $('#cbTous').prop('checked');

				// #type est le sélecteur principal (école, cours, classe,...)
				// var type = (tous == false) ? 'eleves' : $('#type').val();
				var type = $('#leType').val();

				$.post('inc/notif/saveNotification.inc.php', {
					formulaire: formulaire,
					type: type
				}, function(resultat){
					var maintenant = moment().format('dddd DD/MM/YYYY hh:mm:ss');
					$('#dateEnvoi').removeClass('hidden').html('Envoyé le ' + maintenant);
					bootbox.alert({
						title: 'Envoi d\'une annonce',
						message: resultat,
						callback: function(){
							// raffraîchissement de l'historique des notifications pour ce type
							$.post('inc/notif/refreshNotifications.inc.php', {
								type: type
							}, function(resultat){
								$('#tabs-'+type).html(resultat);
								// ne pas compter l'entête ni le pied du tableau => -2
								var lignes = $('#tabs-' + type + ' table tr').length -2;
								$(".badge[data-type='" + type + "']").text(lignes);
							});
							// réactiver l'onglet du type
							$('.onglet[href="#tabs-' + type + '"]').trigger('click');
						}
					});
				})
			}
		})


		// Toutes les fonctions du sélecteur à gauche vvvvvvvvvvvvvvvvvvvvvvvvvv

		$('#ficheEleve').on('change', '#type', function(){
			var type = $(this).val();
			$('#typeNotif').val(type);
			$('.sousType').addClass('hidden');
			$('#choixEleves').html('');
			// on remet à disabled pour être sûr
			$('#submitNotif').attr('disabled', true);
			// $('#leType').val(type);
			// tous les champs non cachés sont "disabled"
			$('#notification input.cb').prop('disabled', true);
			// $('#objet').prop('disabled', false);

			switch (type) {
				case 'ecole':
					$('#divEcole').removeClass('hidden');
					$('#leType').val(type);
					$('#destinataire').val('ecole');
					$.post('inc/notif/noListeEleves.inc.php', {
						destinataire: 'École'
					}, function(resultat){
						// choixEleves revient avec l'avertissement qu'il n'y a pas de choix possible
						$('#choixEleves').html(resultat).removeClass('hidden');

						$('#mail, #accuse, #parent').prop('disabled', true).prop('checked', false);
						// OK, on peut envoyer
						$('#submitNotif').attr('disabled', false);
					});
					break;
				case 'niveau':
					$('#divNiveau').removeClass('hidden');
					$('#choixEleves').html('').removeClass('hidden');
					$('#mail, #accuse, #parent').prop('disabled', true).prop('checked', false);
					$('#niveau4niveau').val('');
					$('#leType').val(type);
					break;
				case 'classes':
					$('#divClasse').removeClass('hidden');
					$('#mail, #accuse, #parent').prop('disabled', false).prop('checked', false);
					$('#niveau4classe').val('');
					$('#classe').val('');
					$('#leType').val(type);
					break;
				case 'cours':
					$('#divMatiere').removeClass('hidden');
					$('#mail, #accuse, #parent').prop('disabled', false).prop('checked', false);
					$('#niveau4matiere').val('');
					$('#matiere').val('');
					$('#leType').val(type);
					break;
				case 'coursGrp':
					$('#divCoursGrp').removeClass('hidden');
					$('#mail, #accuse, #parent').prop('disabled', false).prop('checked', false);
					$('#choixEleves').html('');
					$('#leType').val(type);
					break;
				default:
					$('#leType').val('');
					break;
			}
		})

		$('#ficheEleve').on('change', '#niveau4niveau', function(){
			// var type = $('#type').val();
			var niveau = $(this).val();
			if (niveau != '') {
				$('.cb').prop('checked', false);
				$('#accuse').prop('disabled', false);
				$('#notification input[type!="hidden"]').prop('disabled', false);
				$('#mail, #parent').prop('disabled', true);
				$('#accuse').prop('disabled', false);
				$('#destinataire').val(niveau);

				// OK, on peut envoyer
				$('#submitNotif').attr('disabled', false);

				$.post('inc/notif/noListeEleves.inc.php', {
					destinataire: 'Niveau '+niveau
				}, function(resultat){
					$('#choixEleves').html(resultat).removeClass('hidden');
				})
			}
			else {
				// ne pas envoyer
				$('#submitNotif').attr('disabled', true);
			}
		})

		$('#ficheEleve').on('change', '#niveau4classe', function(){
			$('#choixEleves').html('').addClass('hidden');
			// ne pas envoyer
			$('#submitNotif').attr('disabled', true);
			var niveau = $(this).val();
			if (niveau != '') {
				$.post('inc/notif/selectClasseNiveau.inc.php', {
					niveau: niveau
				}, function(resultat){
					$('#divSelectClasse').html(resultat);
					$('#classe').val('');
				})
			}
			else {
				$('#choixEleves').html('').addClass('hidden');
				// ne pas envoyer
				$('#submitNotif').attr('disabled', true);
			}
		})

		$('#ficheEleve').on('change', '#niveau4matiere', function(){
			$('#choixEleves').html('').addClass('hidden');
			// ne pas envoyer
			$('#submitNotif').attr('disabled', true);
			var niveau = $(this).val();
			if (niveau != '') {
				$.post('inc/notif/selectMatiereNiveau.inc.php', {
					niveau: niveau
				}, function(resultat){
					$('#divSelectMatiere').html(resultat);
				});
			}
			else {
				// ne pas envoyer
				$('#submitNotif').attr('disabled', true);
			}
		})
		$('#ficheEleve').on('change', '#matiere', function(){
			var matiere = $(this).val();
			if (matiere != '') {
				$('#notification input[type!="hidden"]').prop('disabled', false);
				$('.cb').prop('checked', false);
				$('#accuse').prop('disabled', false);
				$('#mail, #parent').prop('disabled', false);
				// OK, on peut envoyer
				$('#submitNotif').attr('disabled', false);

				$.post('inc/notif/noListeEleves.inc.php', {
					destinataire: matiere
				}, function(resultat){
					$('#choixEleves').html(resultat).removeClass('hidden');
					$('#destinataire').val(matiere);
				});
			}
			else {
				// ne pas envoyer
				$('#submitNotif').attr('disabled', true);
			}
		})

		$('#ficheEleve').on('change', '#classe', function(){
			var classe = $(this).val();
			// var type = $('#type').val();
			if (classe != '') {
				$('.cb').prop('checked', false);
				$('#accuse').prop('disabled', false);
				$('#mail, #parent').prop('disabled', false);
				// OK, on peut envoyer
				$('#submitNotif').attr('disabled', false);
				$.post('inc/notif/listeElevesClasse.inc.php', {
					classe: classe
				}, function(resultat){
					$('#choixEleves').html(resultat).removeClass('hidden');
					$('.cb').prop('checked', false);
					$('#destinataire').val(classe);
					$('#notification input[type!="hidden"]').prop('disabled', false);
					$('#stringDestinataire').html(classe);
				});
			}
			else {
				$('#choixEleves').html('').addClass('hidden');
				// ne pas envoyer
				$('#submitNotif').attr('disabled', true);
			}
		})

		$('#ficheEleve').on('change', '#selectCoursGrp', function(){
			var coursGrp = $(this).val();
			if (coursGrp != '') {
				$('.cb').prop('checked', false);
				$('#accuse').prop('disabled', false);
				$('#mail, #parent').prop('disabled', false);
				// OK, on peut envoyer
				$('#submitNotif').attr('disabled', false);
				$.post('inc/notif/listeElevesCoursGrp.inc.php', {
					coursGrp: coursGrp
				}, function(resultat){
					$('#choixEleves').html(resultat).removeClass('hidden');
					$('.cb').prop('checked', false);
					$('#destinataire').val(coursGrp);
					$('#notification input[type!="hidden"]').prop('disabled', false);
					// $('#editorPanel').removeClass('hidden');
					$('#stringDestinataire').html(coursGrp);
				})
			}
			else {
				$('#choixEleves').html('').addClass('hidden');
				// ne pas envoyer
				$('#submitNotif').attr('disabled', true);
			}
		})

		$('#ficheEleve').on('change', '#listeEleves .checkbox', function(){
			var checkedCB = $('#listeEleves li.checkbox :checked').length;
			var totalCB = $('#listeEleves li.checkbox').length;
			if (checkedCB == totalCB) {
				$('#cbTous').prop('checked', true);
				var type = $('#type').val();
				$('#leType').val(type);
				}
				else {
					$('#cbTous').prop('checked', false);
					$('#leType').val('eleves');
				}
		})

		// Toutes les fonctions du sélecteur à gauche ^^^^^^^^^^^^^^^^^^^^^^^^^^


		$('#ficheEleve').on('click', '.btnEdit', function(){
			var id = $(this).data('id');
			var type = $(this).data('type');
			$.post('inc/notif/editNotification.inc.php', {
				id: id
			}, function(resultat){
				$('#tabs-edit').html(resultat);
				$('#onglet-edit').trigger('click');
				$('#selecteur').addClass('hidden');
				$('#choixEleves').removeClass('hidden');
				$('#submitNotif').attr('disabled', false);
				$('#selecteurVertical select').attr('disabled', true)
			})
		})

		$("#corpsPage").on('click', '.selectAll', function() {
			$(this).closest('table').find('.checkDelete').trigger('click');
		})

		$("#ficheEleve").on('click', '.btn-delete', function() {
			var notifId = $(this).data('id');
			$("#modalDelIdBtn").data('id', notifId);
			var type = $(this).data('type');
			$("#modalDelIdBtn").data('type', type);
			var objet = $(this).closest('tr').find('.objet').text();
			$("#spanDelObjet").text(objet);
			var debut = $(this).closest('tr').find('.debut').text();
			$("#spanDelDatedebut").text(debut);
			var fin = $(this).closest('tr').find('.fin').text();
			$("#spanDelDatefin").text(fin);
			var destinataire = $(this).closest('tr').find('.destinataire').text();
			$.post('inc/notif/listePjFiles.inc.php', {
				notifId: notifId
				},
				function(resultat) {
					$('#modalDelPjFiles').html(resultat);
				})
			$("#spanDelDestinataire").text(destinataire);
			$("#modalDelete").modal('show');
		})

		$('#corpsPage').on('click', '.delPJ', function(){
			var shareId = $(this).data('shareid');
			var notifId = $(this).data('notifid');
			var bouton = $(this);
			$.post('inc/notif/unlinkShare4Notif.inc.php', {
				shareId: shareId,
				notifId: notifId},
			function(){
				bouton.closest('li').remove();
			})
		})

		$("#modalDelIdBtn").click(function() {
			var notifId = $(this).data('id');
			var type = $(this).data('type');
			var form = $('#listePJ').serialize();
			$.post('inc/notif/delId.inc.php', {
					notifId: notifId,
					form: form
				},
				function(resultat) {
					$('#tr_' + notifId).remove();
					$("#modalDelete").modal('hide');
					var lignes = $('#tabs-'+type+' table tr').length -2;
					$(".badge[data-type='"+type+"']").text(lignes);
				})
		})

		$("#corpsPage").on('click', '.delModal', function() {
			var type = $(this).data('type');
			var nbSuppr = $("input.checkDelete:checked").length;
			$("#nbNotifications").text(nbSuppr);
			$("#ModalDelBulkBtn").data('type', type);
			$("#modalBulkDelete").modal('show');
		})

		$("#ModalDelBulkBtn").click(function() {
			var type = $(this).data('type');
			var cbId = $("input.checkDelete:checked");
			var listeId = [];
			$.each(cbId, function(i) {
				listeId[i] = $(this).data('id');
			})
			$.post('inc/notif/delBulk.inc.php', {
					listeId: listeId
				},
				function(resultat) {
					$.each(cbId, function(i) {
						var id = $(this).data('id');
						$('#tr_' + id).remove();
					})
					var lignes = $('#tabs-'+type+' table tr').length -2;
					$(".badge[data-type='"+type+"']").text(lignes);
				})
			$("#modalBulkDelete").modal('hide');
		})

		$(".checkDelete").click(function() {
			var ch = $(this).prop('checked');
			var id = $(this).data('id');
			$("#del_" + id).prop('checked', ch);
		})

		$("#corpsPage").on('click', '.showAccuse', function() {
            var id = $(this).data('id');
            console.log(id);
            $.post('inc/notif/showAccuses.inc.php', {
                    id: id
                },
                function(resultat) {
					$('#modalAccuses .modal-content').html(resultat);
                    $("#modalAccuses").modal('show');
                });
        })

	})
</script>
