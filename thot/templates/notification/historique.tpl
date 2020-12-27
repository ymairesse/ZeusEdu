<div class="container-fluid">

	<h2>Historique des Annonces</h2>

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

			{if $annoncesPerimees|@count > 0}
				<a href="#" class="btn btn-danger" id="btn-perime">Périmées: <span class="badge"> {$annoncesPerimees|@count}</span></a>
			{/if}
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

				{* onglet contenant le sélecteur de destinataires et le formulaire de mail
				reset de la valeur de $type modifié plus haut *}
				{assign var=type value=''}
				{include file="notification/edit/tabEdit.tpl"}

			</div>

		</div>
		<!-- tab-content -->

</div>
<!-- container -->

<div id="modal"></div>
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
<!-- .....formulaire modal pour la lecture des accusés de lecture           ..  -->
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
		$('#notification input[type=checkbox], #notification input[type=text]').prop('disabled', false);
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

		$('#ficheEleve').on('click', '.tableEdit tbody tr', function(){
			$(this).toggleClass('selected');
		})

		$('#ficheEleve').on('click', '#btn-raz', function(){
			$('#submitNotif').attr('disabled', true);
			$('#texte').summernote('code', '');
			$('#objet').val('');
			$('#id').val('');
			$('#type').val('').trigger('change').prop('disabled', false);
			$('#dateEnvoi').addClass('hidden').html('');
			$('#selectionVertical select').val('').attr('disabled', false);
			$('#choixEleves').addClass('hidden');
			$('#PjFiles').html('<p>Pas de pièce jointe</p>');
			$('.destinataire').val('');
			$('#mail, #accuse, #parent, #freeze').prop('disabled', false).prop('checked', false);
			// $('#type option[value="eleves"]').prop('disabled', true).text('Un élève [choisir dans "classe", "cours", "groupe"]');
		})

		$('#ficheEleve').on('click', '#btn-cloner', function(){
			var id = $('#id').val();
			// reset de l'identifiant de l'annonce à cloner
			$('#id').val('');
			var type = $('#leType').val();
			// $('#type option[value="eleves"]').prop('disabled', true).text('Un élève [choisir dans "classe", "cours", "groupe"]');
			switch (type){
				case 'classes':
					$('#classes').val('');
					$('#type').prop('disabled', false);
					$('#niveau4classe').prop('disabled', false);
					$('#classe').prop('disabled', false);
					$('.membres').prop('disabled',false);
					break;
				case 'niveau':
					$('#type').prop('disabled', false);
					$('#niveau4niveau').val('').prop('disabled', false);
					break;
				case 'coursGrp':
					$('#type').prop('disabled', false);
					$('#selectCoursGrp').prop('disabled', false);;
					$('.membres').prop('disabled',false);
					// $('#choixEleves').addClass('hidden');
					break;
				case 'cours':
					$('#type').prop('disabled', false);
					$('#niveau4matiere').prop('disabled', false);
					$('#cours').val('').prop('disabled', false);
					break;
				case 'groupe':
					$('#type').prop('disabled', false);
					$('.membres').prop('disabled',false);
					// à prévoir
					break;
				case 'profsCours':
					$('#type').prop('disabled', false);
					$('#acronyme').prop('disabled', false);
					$('#coursGrpProf').prop('disabled', false);
					$('.membres').prop('disabled',false);
					break;
				case 'eleves':
					$('#type').val('').trigger('change').prop('disabled', false);
					$('#type option[value="eleves"]').prop('disabled', true);
					break;
			}

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
			// attribuer le texte au textarea
			// $('#notification #texte').val(texteAnnonce);
			if ($('#notification').valid()) {
				var formulaire = $('#notification').serialize();
				var type = $('#leType').val();

				$.post('inc/notif/saveNotification.inc.php', {
					formulaire: formulaire,
					type: type
				}, function(resultat){
					var resultJSON = JSON.parse(resultat);
					var texte = resultJSON['texte'];
					var listeNotifId = resultJSON['listeNotifId'];

					var maintenant = moment().format('dddd DD/MM/YYYY hh:mm:ss');
					$('#dateEnvoi').removeClass('hidden').html('Envoyé le ' + maintenant);
					bootbox.alert({
						title: 'Envoi d\'une annonce',
						message: resultJSON['texte'],
						callback: function(){
							// raffraîchissement de l'historique des notifications pour ce type
							$.post('inc/notif/refreshNotifications.inc.php', {
								type: type,
								listeNotifId: listeNotifId
							}, function(resultat){
								// reset de l'id pour éviter l'envoi multiple
								$('#id').val('');
								// désactivation du bouton Submit pour forcer un nouveau destinataire
								$('#submitNotif').prop('disabled', true);

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

		// choix d'un type de destinataire (sélecteur principal)
		$('#ficheEleve').on('change', '#type', function(){
			var type = $(this).val();
			$('.destinataire').val('');
			$('#typeNotif').val(type);
			$('.sousType').addClass('hidden');
			$('#choixEleves').html('');
			// on remet à disabled pour être sûr
			$('#submitNotif').attr('disabled', true);

			// tous les champs non cachés sont "disabled"
			$('#notification input.cb').prop('disabled', true).attr('checked', false);

			switch (type) {
				case 'ecole':
					$('#divEcole').removeClass('hidden');
					$('#leType').val(type);
					// reset de tous les destinataires possibles
					$('.destinataire').val('');
					$('#destinataire').val('ecole');
					$.post('inc/notif/noListeEleves.inc.php', {
						destinataire: 'École'
					}, function(resultat){
						// choixEleves revient avec l'avertissement qu'il n'y a pas de choix possible
						$('#choixEleves').html(resultat).removeClass('hidden');

						$('#mail, #accuse, #parent, #titu').prop('disabled', true);
						// reset de tous les sélecteurs
						$('.selection').val('');
						// OK, on peut envoyer
						$('#submitNotif').attr('disabled', false);
					});
					break;
				case 'niveau':
					$('#divNiveau').removeClass('hidden');
					$('#choixEleves').html('').removeClass('hidden');
					$('#mail, #parent').prop('disabled', true);
					$('#accuse').prop('disabled', false);
					$('#niveau4niveau').val('').prop('disabled', false);
					$('.destinataire').val('');
					$('#destinataire').val('');
					$('#leType').val(type);
					break;
				case 'classes':
					$('#divClasse').removeClass('hidden');
					$('#mail, #accuse, #parent').prop('disabled', false);
					$('#niveau4classe').val('').prop('disabled', false);
					$('#classe').val('').prop('disabled', false);;
					$('.destinataire').val('');
					$('#destinataire').val('');
					$('#leType').val(type);
					break;
				case 'cours':
					$('#divMatiere').removeClass('hidden');
					$('#mail, #parent, #accuse, #titu').prop('disabled', false);
					$('#niveau4matiere').val('').prop('disabled', false);
					$('#matiere').val('').prop('disabled', false);
					$('.destinataire').val('');
					$('#destinataire').val('');
					$('#leType').val(type);
					break;
				case 'coursGrp':
					$('#divCoursGrp').removeClass('hidden');
					$('#mail, #accuse, #parent, #titu').prop('disabled', false);
					$('#selectCoursGrp').val('')
					$('#choixEleves').html('');
					$('.destinataire').val('');
					$('#destinataire').val('');
					$('#leType').val(type);
					break;
				case 'groupe':
					// $('#divGroupe').removeClass('hidden');
					$('#mail, #accuse, #parent').prop('disabled', false);
					//$('#selectGroupe').val('')
					$('#choixEleves').html('');
					$('.destinataire').val('');
					$('#destinataire').val('');
					$('#leType').val(type);
					break;
				case 'profsCours':
					$('#acronyme').prop('disabled', false);
					$('#divprofsCours').removeClass('hidden');
					$('#mail, #accuse, #parent, #titu').prop('disabled', false);
					$('#selectCoursGrp').val('')
					$('#choixEleves').html('');
					$('.destinataire').val('');
					$('#destinataire').val('');
					$('#leType').val(type);
					break;
				default:
					$('.destinataire').val('');
					$('#destinataire').val('');
					$('#leType').val('');
					break;
			}
		})

		$('#ficheEleve').on('change', '#niveau4niveau', function(){
			var niveau = $(this).val();

			// reset de tous les destinataires possibles
			$('.destinataire').val('');

			// attribution au niveau
			$('#leNiveau').val(niveau);
			$('#destinataire').val(niveau);

			if (niveau != '') {
				// OK, on peut envoyer
				$('#submitNotif').attr('disabled', false);
				$('#destinataire').val(niveau);
				// accusé de lecture, mail et mail parents sont impossibles
				$('#mail, #parent').prop('disabled', true);
				$('#accuse').prop('disabled', false);

				$.post('inc/notif/noListeEleves.inc.php', {
					destinataire: 'Niveau '+niveau
				}, function(resultat){
					$('#choixEleves').html(resultat).removeClass('hidden');
				})
			}
			else {
				// ne pas envoyer
				$('#submitNotif').attr('disabled', true);
				// pas de liste d'élèves
				$('#choixEleves').html('').addClass('hidden');
			}
		})

		$('#ficheEleve').on('change', '#niveau4classe', function(){
			var niveau = $(this).val();
			// reset de tous les destinataires possibles
			$('.destinataire').val('');
			$('#destinataire').val('');
			// rétablir le type si on a fait un envoi "élèves" avant
			$('#leType').val('niveau');
			// pas de choix d'élèves
			$('#choixEleves').html('').addClass('hidden');

			// ne pas envoyer
			$('#submitNotif').attr('disabled', true);

			if (niveau != '') {
				$.post('inc/notif/selectClasseNiveau.inc.php', {
					niveau: niveau
				}, function(resultat){
					$('#divSelectClasse').html(resultat);
					$('#classe').val('');
				})
			}
		})

		$('#ficheEleve').on('change', '#niveau4matiere', function(){
			var niveau = $(this).val();
			// reset de tous les destinataires possibles
			$('.destinataire').val('');
			$('#destinataire').val('');

			// pas de choix d'élèves
			$('#choixEleves').html('').addClass('hidden');

			// ne pas envoyer
			$('#submitNotif').attr('disabled', true);

			if (niveau != '') {
				$.post('inc/notif/selectMatiereNiveau.inc.php', {
					niveau: niveau
				}, function(resultat){
					$('#divSelectMatiere').html(resultat);
					$('#cours').val('')
				});
			}
		})
		$('#ficheEleve').on('change', '#matiere', function(){
			var matiere = $(this).val();

			// reset de tous les destinataires possibles
			$('.destinataire').val('');

			// attribution au niveau
			$('#leCours').val(matiere);
			$('#destinataire').val(matiere);

			if (matiere != '') {
				// OK, on peut envoyer
				$('#submitNotif').attr('disabled', false);

				// accusé de lecture, mail et mail parents sont possibles
				$('#accuse, #mail, #parent').prop('disabled', false);

				$.post('inc/notif/noListeEleves.inc.php', {
					destinataire: matiere
				}, function(resultat){
					$('#choixEleves').html(resultat).removeClass('hidden');
				});
			}
			else {
				// ne pas envoyer
				$('#submitNotif').attr('disabled', true);
				// accusé de lecture, mail et mail parents sont impossibles
				$('#accuse, #mail, #parent').prop('disabled', true);
				// pas de liste d'élèves
				$('#choixEleves').html('').addClass('hidden');
			}
		})

		// changement de la sélection du prof dans le choix profsCours
		$('#ficheEleve').on('change', '#acronyme', function(){
			var acronyme = $(this).val();

			// reset de tous les destinataires possibles
			$('.destinataire').val('');
			$('#destinataire').val('');

			// pas de choix d'Élèves
			$('#choixEleves').html('').addClass('hidden');

			$.post('inc/notif/listeCoursProf.inc.php', {
				acronyme: acronyme
			}, function(resultat){
				$('#divSelectCoursProf').html(resultat)
			})
		})
		// sélection d'un cours dans le choix profsCours
		$('#ficheEleve').on('change', '#coursGrpProf', function(){
			var coursGrp = $(this).val();
			$('.destinataire').val(coursGrp);
			$('#destinataire').val(coursGrp);
			$.post('inc/notif/listeElevesCoursGrp.inc.php', {
				coursGrp: coursGrp
			}, function(resultat){
				$('#choixEleves').html(resultat).removeClass('hidden');
				$('#submitNotif').attr('disabled', false);
			})
		})

		$('#ficheEleve').on('change', '#classe', function(){
			var classe = $(this).val();

			// reset de tous les destinataires possibles
			$('.destinataire').val('');
			$('#laClasse').val(classe);
			$('#destinataire').val(classe);

			// rétablir le type si on a fait un envoi "élèves" avant
			$('#leType').val('classes');

			if (classe != '') {
				// accusé de lecture, mail et mail parents sont possibles
				$('#accuse, #mail, #parent').prop('disabled', false);
				// OK, on peut envoyer
				$('#submitNotif').attr('disabled', false);

				$.post('inc/notif/listeElevesClasse.inc.php', {
					classe: classe
				}, function(resultat){
					$('#choixEleves').html(resultat).removeClass('hidden');
				});
			}
			else {
				// ne pas envoyer
				$('#submitNotif').attr('disabled', true);
				// accusé de lecture, mail et mail parents sont impossibles
				$('#mail, #parent').prop('disabled', true);
				// pas de liste d'élèves
				$('#choixEleves').html('').addClass('hidden');
			}
		})

		$('#ficheEleve').on('change', '#selectCoursGrp', function(){
			var coursGrp = $(this).val();

			// reset de tous les destinataires possibles
			$('.destinataire').val('');

			$('#leCoursGrp').val(coursGrp);
			$('#destinataire').val(coursGrp);

			// rétablir le type si on a fait un envoi "élèves" avant
			$('#leType').val('coursGrp');

			if (coursGrp != '') {
				// accusé de lecture, mail et mail parents sont possibles
				$('#mail, #parent').prop('disabled', false);
				// OK, on peut envoyer
				$('#submitNotif').attr('disabled', false);

				$.post('inc/notif/listeElevesCoursGrp.inc.php', {
					coursGrp: coursGrp
				}, function(resultat){
					$('#choixEleves').html(resultat).removeClass('hidden');
				})
			}
			else {
				// ne pas envoyer
				$('#submitNotif').attr('disabled', true);
				// accusé de lecture, mail et mail parents sont possibles
				$('#mail, #parent').prop('disabled', false);
				// pas de liste d'élèves
				$('#choixEleves').html('').addClass('hidden');
			}
		})

		$('#ficheEleve').on('change', '#listeEleves .checkbox', function(){
			// le "type" peut varier si l'on coche ou décoche un élève de #listeEleves
			// si toutes les cases sont cochées, on revient au "type" du groupe global
			// sinon, c'est un envoi élève par élève
			var checkedCB = $('#listeEleves li.checkbox :checked').length;
			var totalCB = $('#listeEleves li.checkbox').length;
			if (checkedCB == totalCB) {
				var type = $('#type').val();
				$('#leType').val(type);
				}
				else {
					$('#leType').val('eleves');
				}
		})

		// Toutes les fonctions du sélecteur à gauche ^^^^^^^^^^^^^^^^^^^^^^^^^^

		$('#ficheEleve').on('click', '.btnEdit', function(){
			var id = $(this).data('id');
			$.post('inc/notif/editNotification.inc.php', {
				id: id
			}, function(resultat){
				$('#tabs-edit').html(resultat);
				$('#onglet-edit').trigger('click');
				$('#selecteur').addClass('hidden');
				$('#choixEleves').removeClass('hidden');
				$('#submitNotif').attr('disabled', false);
				$('#selectionVertical select').attr('disabled', true);
				$('#type').prop('disabled', true);
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

		$('#modalDelPjFiles').on('click', '.delPJ', function(){
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
            $.post('inc/notif/showAccuses.inc.php', {
                    id: id
                },
                function(resultat) {
					$('#modalAccuses .modal-content').html(resultat);
                    $("#modalAccuses").modal('show');
                });
        })

		$('#btn-perime').click(function(){
			$.post('inc/notif/showPerime.inc.php', {
			}, function(resultat){
				$('#modal').html(resultat);
				$('#modalPerimees').modal('show');
			})
		})

		$('#modal').on('click', '#btn-selectNotif', function(){
			var lignes = $('#modalPerimees tbody tr');
			lignes.each(function(index){
				var notifId = $(this).data('notifid');
				$('.tableEdit tr[data-id="' + notifId +'"] input').prop('checked', true);
				$('.tableEdit tr[data-id="' + notifId +'"]').addClass('selected');
			})
			$('#modalPerimees').modal('hide');
			bootbox.alert({
				title: 'Suppression des annonces périmées',
				message: 'Les annonces périmées sont sélectionnées dans les différents onglets. Vous avez maintenant la possibilité de vérifier la sélection avant effacement'
			})
		})


	})
</script>
