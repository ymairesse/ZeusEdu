<link href="css/filetree.css" type="text/css" rel="stylesheet">

<div class="container">

	<h2>Historique et Annonces</h2>

	<div id="zoneEdition">

		<ul id="tabs" class="nav nav-tabs hidden-print" data-tabs="tabs">
			<li class="active">
				<a href="#tabs-1" data-toggle="tab" class="realTab">À un élève <span class="badge" data-type="eleves">{$listeNotifications.eleves|@count}</span></a>
			</li>
			<li><a href="#" class="btn btn-default btnPlusNotif btnTabAdd pop" data-content="Veuillez sélectionner un élève par sa classe ou par un cours">x</a></li>
			<li>
				<a href="#tabs-2" data-toggle="tab" class="realTab">À un cours
					<span class="badge" data-type="coursGrp">{$listeNotifications.coursGrp|@count|default:0}</span>
				</a>
			</li>
			<li><a href="index.php?action=notification&amp;etape=show&amp;mode=coursGrp" class="btn btn-default btnPlusNotif btnTabAdd">+</a></li>
			<li>
				<a href="#tabs-3" data-toggle="tab" class="realTab">À une classe
					<span class="badge" data-type="classes">{$listeNotifications.classes|@count}</span>
				</a>
			</li>
			<li><a href="index.php?action=notification&amp;etape=show&amp;mode=classes" class="btn btn-default btnPlusNotif btnTabAdd">+</a></li>
			{if ($userStatus == 'admin') || ($userStatus == 'direction')}
			<li>
				<a href="#tabs-4" data-toggle="tab" class="realTab">À un niveau
					<span class="badge" data-type="niveau">{$listeNotifications.niveau|@count}</span>
				</a>
			</li>
			<li><a href="index.php?action=notification&amp;etape=show&amp;mode=niveau" class="btn btn-default btnPlusNotif btnTabAdd">+</a></li>
			<li>
				<a href="#tabs-5" data-toggle="tab" class="realTab">À l'ensemble des élèves
					<span class="badge" data-type="ecole">{$listeNotifications.ecole|@count}</span>
				</a>
			</li>
			<li><a href="index.php?action=notification&amp;etape=show&amp;mode=ecole" class="btn btn-default btnPlusNotif btnTabAdd">+</a></li>
			{/if}
		</ul>

		<div id="FicheEleve" class="tab-content">

			{include file="notification/edit/eleve.tpl"}
			{include file="notification/edit/coursGrp.tpl"}
			{include file="notification/edit/classe.tpl"}
			{if ($userStatus == 'admin') || ($userStatus == 'direction')}
				{include file="notification/edit/niveau.tpl"}
				{include file="notification/edit/ecole.tpl"}
			{/if}

		</div>
		<!-- tab-content -->

	</div>  <!-- zoneEdition -->

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
{include file="modal/modalTreeView.tpl"}
<!-- .......................................................................... -->
<!-- .....formulaire modal pour la lecture des accusés de réception          ..  -->
<!-- .......................................................................... -->
{include file="notification/modal/modalAccuses.tpl"}

<script type="text/javascript">

	$(document).ready(function() {

		// activer l'onglet dont le numéro a été passé
		$(".nav-tabs li a.realTab").eq({$onglet}).trigger('click');

		$(document).ajaxStart(function() {
			$('body').addClass('wait');
		}).ajaxComplete(function() {
			$('body').removeClass('wait');
		});

		$('.btnEdit').click(function(){
			var notifId = $(this).data('id');
			var type = $(this).data('type');
			$.post('inc/notif/editNotification.inc.php', {
				notifId: notifId,
				type: type
				},
				function(resultat){
					$('#zoneEdition').html(resultat);
				})
		})

		// activation du bouton [+] avec l'onglet correspondant
		$("li a.realTab").click(function() {
			$('.btnPlusNotif').removeClass('btn-primary').addClass('btn-default');
			$(this).closest('li').next('li').find('a').addClass('btn-primary');
			var onglet = $("li a.realTab").index(this);
			$.post('inc/setCookie.inc.php', {
				name: 'notifications',
				cookie: onglet
				},
				function(){
				})
		});

		$(".selectAll").click(function() {
			$(this).closest('table').find('.checkDelete').trigger('click');
		})

		$("#saveEdited").click(function() {
			var texte = CKEDITOR.instances['texte'].getData()
			var id = $("#id").val();
			var objet = $("#objet").val();
			var dateDebut = $("#dateDebut").val();
			var dateFin = $("#dateFin").val();
			var urgence = $("#urgence").val();
			$.post('inc/notif/saveEdited.inc.php', {
					id: id,
					texte: texte,
					objet: objet,
					dateDebut: dateDebut,
					dateFin: dateFin,
					urgence: urgence
				},
				function(resultat) {
					var obj = JSON.parse(resultat);
					$('.tableEdit tr.selected .debut').html(obj.dateDebut);
					$('.tableEdit tr.selected .fin').html(obj.dateFin);
					$('.tableEdit tr.selected .objet').html(obj.objet);
					$('.tableEdit tr.selected .dateDebut').html(obj.dateDebut);
					$('.tableEdit tr.selected .dateFin').html(obj.dateFin);
					$('.tableEdit tr.selected .urgence').removeClass().addClass('urgence urgence' + obj.urgence);


				})
			$("#modalEdit").modal('hide');
		})

		$('#modalDelete').on('click', '.delPJ', function(){
			$(this).closest('li').remove();
		})

		$(".btn-delete").click(function() {
			var id = $(this).data('id');
			$("#modalDelIdBtn").data('id', id);
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
				notifId: id
				},
				function(resultat) {
					$('#modalDelPjFiles').html(resultat);
				})
			$("#spanDelDestinataire").text(destinataire);
			$("#modalDelete").modal('show');
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
					$(".badge[data-type='"+type+"']").text(resultat);
				})
		})

		$(".delModal").click(function() {
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
					$(".badge[data-type='"+type+"']").text(resultat);
				})
			$("#modalBulkDelete").modal('hide');
		})

		$(".checkDelete").click(function() {
			var ch = $(this).prop('checked');
			var id = $(this).data('id');
			$("#del_" + id).prop('checked', ch);
		})

		$(".showAccuse").click(function() {
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
