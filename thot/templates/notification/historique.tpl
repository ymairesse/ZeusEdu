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
				<a data-toggle="tab" href="#tabs-edit" id="onglet-edit" class="btn-lightBlue"><i class="fa fa-bullhorn fa-lg"></i> Nouvelle annonce</a>
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
<!-- .....formulaire modal pour l'édition  d'une notification               ..  -->
<!-- .......................................................................... -->
{include file="notification/modal/modalEdit.tpl"}
<!-- .......................................................................... -->
<!-- .....formulaire modal pour l'édition  des PJ (ajout/suppr)             ..  -->
<!-- .......................................................................... -->
{include file="files/modal/modalTreeView.tpl"}
<!-- .......................................................................... -->
<!-- .....formulaire modal pour la lecture des accusés de réception          ..  -->
<!-- .......................................................................... -->
{include file="notification/modal/modalAccuses.tpl"}

<script type="text/javascript">

	function reset(){
		CKEDITOR.instances.texte.setReadOnly(false);
		CKEDITOR.instances.texte.setData('');
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
		$('#submitNotif').attr('data-sent', 'false').removeClass('btn-lightBlue').addClass('btn-primary');
		$('#submitNotif').html('<i class="fa fa-paper-plane"></i> Envoyer');
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

		// enregistrement et envoi d'une annonce
		$('#ficheEleve').on('click', '#submitNotif', function(){
			var sent = $(this).attr('data-sent');
			if (sent == 'true') {
				reset();
			}
			else {
				if ($('#notification').valid()) {
					var formulaire = $('#notification').serialize();
					var matricule = $('#matricule').val();
					var tous = $('#cbTous').prop('checked');  // la case à cocher "TOUS"
					// en cas d'édition, le matricule est connu => c'est le cas d'un élève isolé
					// en cas de nouvel enregistrement et que la case à cocher cbTous n'est pas cochée
					// ou qu'elle est undefined, c'est le cas d'un élève isolé
					var type = ((matricule != '') || tous == false)  ? 'eleves' : $('#type').val();
					$.post('inc/notif/saveNotification.inc.php', {
						formulaire: formulaire
					}, function(resultat){
						bootbox.alert({
							title: 'Envoi d\'une annonce',
							message: resultat
						});

						// raffraîchissement de l'historique des notifications pour ce type
						$.post('inc/notif/refreshNotifications.inc.php', {
							type: type
						}, function(resultat){
							$('#tabs-'+type).html(resultat);
							// ne pas compter l'entête ni le pied du tableau => -2
							var lignes = $('#tabs-'+type+' table tr').length -2;
							$(".badge[data-type='"+type+"']").text(lignes);
						});

						// réinitialisation de l'éditeur et des satellites
						$('#notification input[type=checkbox], #notification input[type=text]').prop('readOnly', true);
						CKEDITOR.instances.texte.setReadOnly(true);
						// $('#submitNotif').removeClass('btn-primary').addClass('btn-lightBlue').attr('data-sent', 'true');
						// $('#submitNotif').html('<i class="fa fa-paper-plane"></i> Nouvelle annonce');
					})
				}
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
						reset();
					}
				}
			})
		})

		$('#ficheEleve').on('change', '#type', function(){
			var type = $(this).val();
			$('.sousType').addClass('hidden');
			$('#editorPanel, #choixEleves').addClass('hidden');
			$('#notification input[type!="hidden"]').prop('disabled', true);
			switch (type) {
				case 'ecole':
					$('#divEcole').removeClass('hidden');
					$.post('inc/notif/noListeEleves.inc.php', {
						destinataire: 'École'
					}, function(resultat){
						$('.cb').prop('checked', false);
						$('#destinataire').val($('#tous').val());
						$('#choixEleves').html(resultat).removeClass('hidden');
						$('#notification input[type!="hidden"]').prop('disabled', false);
						$('#mail, #accuse, #parent').prop('disabled', true);
						$('#editorPanel').removeClass('hidden');
					});
					break;
				case 'niveau':
					$('#divNiveau').removeClass('hidden');
					$('#niveau4niveau').val('');
					break;
				case 'classes':
					$('#divClasse').removeClass('hidden');
					$('#choixEleves').html('').removeClass('hidden');
					$('#classe').val('');
					break;
				case 'cours':
					$('#divMatiere').removeClass('hidden');
					break;
				case 'coursGrp':
					$('#divCoursGrp').removeClass('hidden');
					$('#choixEleves').html('').removeClass('hidden');
					break;
			}
		})

		$('#ficheEleve').on('change', '#niveau4niveau', function(){
			var niveau = $(this).val();
			$('.cb').prop('checked', false);
			$('#accuse').prop('disabled', false);
			$('#notification input[type!="hidden"]').prop('disabled', false);
			$('#mail, #parent').prop('disabled', true);
			$('#accuse').prop('disabled', false);
			$('#destinataire').val(niveau);
			$('#editorPanel').removeClass('hidden');
			$('#stringDestinataire').html(niveau + 'e année');
			$('#choixEleves').removeClass('hidden');
		})

		$('#ficheEleve').on('change', '#niveau4classe', function(){
			var niveau = $(this).val();
			$.post('inc/notif/selectClasseNiveau.inc.php', {
				niveau: niveau
			}, function(resultat){
				$('#divSelectClasse').html(resultat);
				$('#classe').val('');
				$('#choixEleves, #editorPanel').addClass('hidden');
			})
		})

		$('#ficheEleve').on('change', '#niveau4matiere', function(){
			var niveau = $(this).val();
			$.post('inc/notif/selectMatiereNiveau.inc.php', {
				niveau: niveau
			}, function(resultat){
				$('#divSelectMatiere').html(resultat);
				$('#choixEleves, #editorPanel').addClass('hidden');
			});
		})
		$('#ficheEleve').on('change', '#matiere', function(){
			var matiere = $(this).val();
			if (matiere != '') {
				$('#notification input[type!="hidden"]').prop('disabled', false);
				$('.cb').prop('checked', false);
				$('#accuse').prop('disabled', false);
				$('#mail, #parent').prop('disabled', true);
				$('#stringDestinataire').html(matiere);
				$('#editorPanel').removeClass('hidden');
				$.post('inc/notif/noListeEleves.inc.php', {
					destinataire: matiere
				}, function(resultat){
					$('#choixEleves').html(resultat).removeClass('hidden');
					$('#destinataire').val(matiere);
				});
			}
			else {
				$('#choixEleves, #editorPanel').addClass('hidden');
			}
		})

		$('#ficheEleve').on('change', '#classe', function(){
			var classe = $(this).val();
			$.post('inc/notif/listeElevesClasse.inc.php', {
				classe: classe
			}, function(resultat){
				$('#choixEleves').html(resultat).removeClass('hidden');
				$('.cb').prop('checked', false);
				$('#destinataire').val(classe);
				$('#notification input[type!="hidden"]').prop('disabled', false);
				$('#editorPanel').removeClass('hidden');
				$('#stringDestinataire').html(classe);
			});
		})

		$('#ficheEleve').on('change', '#selectCoursGrp', function(){
			var coursGrp = $(this).val();
			$.post('inc/notif/listeElevesCoursGrp.inc.php', {
				coursGrp: coursGrp
			}, function(resultat){
				$('#choixEleves').html(resultat).removeClass('hidden');
				$('.cb').prop('checked', false);
				$('#destinataire').val(coursGrp);
				$('#notification input[type!="hidden"]').prop('disabled', false);
				$('#editorPanel').removeClass('hidden');
				$('#stringDestinataire').html(coursGrp);
			})
		})

		$('#ficheEleve').on('click', '.btnEdit', function(){
			var notifId = $(this).data('id');
			$.post('inc/notif/editNotification.inc.php', {
				notifId: notifId
			}, function(resultat){
				$('#tabs-edit').html(resultat);
				$('#onglet-edit').trigger('click');
				$('#selecteur').addClass('hidden');
				$('#editorPanel').removeClass('hidden');
				$('#choixEleves').removeClass('hidden');
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
            $.post('inc/notif/showAccuses.inc.php', {
                    id: id
                },
                function(resultat) {
					$('#modalAccuses .modal-content').html(resultat);
                    $("#modalAccuses").modal('show');
                });
        })

		// si l'on clique sur un onglet, son numéro est retenu dans un input caché dont la "class" est 'onglet'
        $(".nav-tabs li a").click(function() {
            var ref = $(this).attr("href").split("-")[1];
            $(".onglet").val(ref);
        });

	})
</script>
