<div class="container">

	<h2>Édition des notifications</h2>

	<ul id="tabs" class="nav nav-tabs hidden-print" data-tabs="tabs">
		<li class="active"><a href="#tabs-1" data-toggle="tab">À un élève <span class="badge">{$listeNotifications.eleves|count}</span></a></li>
		<li><a href="#tabs-2" data-toggle="tab">À un cours <span class="badge">{$listeNotifications.cours|@count}</span></a></li>
		<li><a href="#tabs-3" data-toggle="tab">À une classe <span class="badge">{$listeNotifications.classes|@count}</span></a></li>
		{if ($userStatus == 'admin') || ($userStatus == 'direction')}
		<li><a href="#tabs-4" data-toggle="tab">À un niveau <span class="badge">{$listeNotifications.niveau|@count}</span></a></li>
		<li><a href="#tabs-5" data-toggle="tab">À l'ensemble des élèves <span class="badge">{$listeNotifications.ecole|@count}</span></a></li>
		{/if}
	</ul>

	<div id="FicheEleve" class="tab-content">

		{include file="editNotifications/eleve.tpl"}
		{include file="editNotifications/cours.tpl"}
		{include file="editNotifications/classe.tpl"}
		{if ($userStatus == 'admin') || ($userStatus == 'direction')}
			{include file="editNotifications/niveau.tpl"}
			{include file="editNotifications/ecole.tpl"}
		{/if}

	</div>
	<!-- tab-content -->

</div>
<!-- container -->

<!-- .......................................................................... -->
<!-- .....formulaire modal pour la  suppression multiple de notifications   ..  -->
<!-- .......................................................................... -->
{include file="notification/modalBulkDelete.tpl"}

<!-- .......................................................................... -->
<!-- .....formulaire modal pour la  suppression d'une notification          ..  -->
<!-- .......................................................................... -->
{include file="notification/modalDelete.tpl"}

<!-- .......................................................................... -->
<!-- .....formulaire modal pour l'édition  d'une notificatio                ..  -->
<!-- .......................................................................... -->
{include file="notification/modalEdit.tpl"}


<script type="text/javascript">
	// quel est l'onglet actif?
	var onglet = "{$onglet|default:0}";

	// activer l'onglet dont le numéro a été passé
	$(".nav-tabs li a[href='#tabs-" + onglet + "']").tab('show');


	$(document).ready(function() {

		$(document).ajaxStart(function() {
			$('body').addClass('wait');
		}).ajaxComplete(function() {
			$('body').removeClass('wait');
		});

		// si l'on clique sur un onglet, son numéro est retenu dans un input caché dont la "class" est 'onglet'
		$(".nav-tabs li a").click(function() {
			var ref = $(this).attr("href").split("-")[1];
			$(".onglet").val(ref);
		});

		$(".selectAll").click(function() {
			$(this).closest('table').find('.checkDelete').trigger('click');
		})

		$(".btnEdit").click(function() {
			var id = $(this).data('id');
			$('.tableEdit tr').removeClass('selected');
			$(this).closest('tr').addClass('selected');
			$.post('inc/notif/modalEdit.inc.php', {
					id: id
				},
				function(resultat) {
					var obj = JSON.parse(resultat);
					$("#objet").val(obj.objet);
					CKEDITOR.instances['texte'].setData(obj.texte);
					$("#id").val(obj.id);
					$("#dateDebut").val(obj.dateDebut);
					$("#dateFin").val(obj.dateFin);
					var urgence = obj.urgence;
					$("#urgence").attr('class', 'form-control').val(urgence).addClass('urgence' + urgence);
				})
			$("#modalEdit").modal('show');
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

		$(".btn-delete").click(function() {
			var id = $(this).data('id');
			$("#modalDelIdBtn").data('id', id);
			var objet = $(this).closest('tr').find('.objet').text();
			$("#spanDelObjet").text(objet);
			var debut = $(this).closest('tr').find('.debut').text();
			$("#spanDelDatedebut").text(debut);
			var fin = $(this).closest('tr').find('.fin').text();
			$("#spanDelDatefin").text(fin);
			var destinataire = $(this).closest('tr').find('.destinataire').text();
			$("#spanDelDestinataire").text(destinataire);
			$("#modalDelete").modal('show');
		})

		$("#modalDelIdBtn").click(function() {
			var id = $(this).data('id');
			$.post('inc/notif/delId.inc.php', {
					id: id
				},
				function() {
					$('#tr_' + id).remove();
					$("#modalDelete").modal('hide');
				})
		})

		$(".delModal").click(function() {
			var nbSuppr = $("input.checkDelete:checked").length;
			$("#nbNotifications").text(nbSuppr);
			$("#modalBulkDelete").modal('show');
		})

		$("#ModalDelBulkBtn").click(function() {
			var cbId = $("input.checkDelete:checked");
			var listeId = [];
			$.each(cbId, function(i) {
				listeId[i] = $(this).data('id');
			})
			$.post('inc/notif/delBulk.inc.php', {
					listeId: listeId
				},
				function() {
					$.each(cbId, function(i) {
						var id = $(this).data('id');
						$('#tr_' + id).remove();
					})
				})
			$("#modalBulkDelete").modal('hide');
		})

		$(".checkDelete").click(function() {
			var ch = $(this).prop('checked');
			var id = $(this).data('id');
			$("#del_" + id).prop('checked', ch);
		})


	})
</script>
