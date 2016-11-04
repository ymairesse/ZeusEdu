<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

{assign var=memo value=$memoEleve.proprio} {assign var=idProprio value=$memo|key} {assign var=leMemo value=$memo.$idProprio}
<div class="container">

	<div class="alert alert-danger alert-dismissible hidden" role="alert" id="mailKO">
		<button type="button" class="close pull-right">&times;</button>
		L'envoi du mail a échoué
	</div>

	<div class="alert alert-success alert-dismissible hidden" role="alert" id="mailOK">
		<button type="button" class="close pull-right">&times;</button>
		Le mail a été envoyé
	</div>

	<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

	<ul id="tabs" class="nav nav-tabs hidden-print" data-tabs="tabs">
		<li class="active"><a href="#tabs-1" data-toggle="tab"><i class="fa fa-legal"></i> Fiche Disciplinaire</a></li>
		<li><a href="#tabs-2" data-toggle="tab"><i class="fa fa-user-plus"></i> Parents et responsables</a></li>
		<li><a href="#tabs-3" data-toggle="tab"><i class="fa fa-user"></i> Données personnelles</a></li>
		<li><a href="#tabs-4" data-toggle="tab">{if $leMemo.texte|count_characters > 0}<i class="fa fa-pencil-square-o text-danger"></i>{/if} Mémo</a></li>
	</ul>

	<div id="FicheEleve" class="tab-content">

		<div class="tab-pane active" id="tabs-1">
			{include file="eleve/infoDisciplinaires.tpl"}
		</div>
		<div class="tab-pane hidden-print" id="tabs-2">
			{include file="eleve/donneesParents.tpl"}
		</div>
		<div class="tab-pane hidden-print" id="tabs-3">
			{include file="eleve/donneesPerso.tpl"}
		</div>
		<div class="tab-pane hidden-print" id="tabs-4">
			{include file="eleve/memoEleve.tpl"}
		</div>


	</div>
	<!-- tab-content -->


	<!-- boîte modale pour l'édition ou nouveau fait disciplinaire -->

	<div class="modal fade" id="editFait" tabindex="-1" role="dialog" aria-labelledby="titleEditFait" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="titleEditFait">Fait disciplinaire</h4>
				</div>
				<div class="modal-body" id="formFait">

				</div>
			</div>
		</div>
	</div>

	<!-- boîte modale pour la suppression d'un fait disciplinaire -->
	<div class="modal fade" id="modalDel" tabindex="-1" role="dialog" aria-labelledby="titleDelete" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="titleDelete">Effacement du fait</h4>
				</div>
				<div class="modal-body" id="formDel">

				</div>
			</div>
		</div>
	</div>

	{include file="eleve/modal/envoiRetenue.tpl"}

</div>
<!-- container -->

<iframe width="1px" height="1px" id="iframePrint">

</iframe>

<script type="text/javascript">
	<!-- quel est l onglet actif? -->
	var onglet = "{$onglet|default:''}";

	<!-- activer l onglet dont le numéro a été passé -->
	$(".nav-tabs li a[href='#tabs-" + onglet + "']").tab('show');


	$(document).ready(function() {

		window.location.hash = '#top';

		$(".openThis").click(function() {
			var table = $(this).closest('h3').next().find('table');
			if (table.hasClass('hidden'))
				table.removeClass('hidden');
			else table.addClass('hidden');
		})

		$("#openAll").click(function() {
			$(".openThis").trigger('click');
		})

		$(".delete").click(function() {
			var idfait = $(this).data('idfait');
			var mode = 'delete';
			$.post('inc/faits/editFaitDisc.inc.php', {
				idfait: idfait,
				mode: 'delete'
			}, function(resultat) {
				$("#formDel").html(resultat);
				// désactivation des champs sauf les "hidden"
				$("#modalDel input:text").prop('disabled', true);
				$("#modalDel textarea").prop('disabled', true);
				$("#modalDel select").prop('disabled', true);
				$('.motif').hide();
				$("#modalDel").modal('show');
			})
		})

		$(".edit").click(function() {
			var idfait = $(this).data('idfait');
			var matricule = '';
			var classe = '';
			var type = '';
			var mode = 'edit';
			$.post('inc/faits/editFaitDisc.inc.php', {
				type: type,
				matricule: matricule,
				classe: classe,
				idfait: idfait,
				mode: 'edit'
			}, function(resultat) {
				$("#formFait").html(resultat);
				$("#editFait").modal('show');
			})
		})

		$(".print").click(function(event) {
			var idfait = $(this).data('idfait');
			$.post('inc/retenues/printRetenue.inc.php', {
					idfait: idfait
				},
				function(resultat) {}
			)
		})

		$("#lePdf").click(function() {
			$("#retenuePDF").modal('hide');
		})


		$("#tabs li a").click(function() {
			var ref = $(this).attr("href").split("-")[1];
			$(".onglet").val(ref);
		});

		$(".newFait").click(function() {
			var type = $(this).data('typefait');
			var matricule = $(this).data('matricule');
			var classe = $(this).data('classe');
			$.post('inc/faits/editFaitDisc.inc.php', {
				type: type,
				matricule: matricule,
				classe: classe,
				mode: 'edit'
			}, function(resultat) {
				$("#formFait").html(resultat);
				$("#editFait").modal('show');
			})
		})

		$("#printPage").click(function() {
			var anScol = $("#tabsDisc li.active").data('anneescolaire');
			var matricule = $(this).data('matricule');
			$.post('inc/printFicheCourante.inc.php', {
					anScol: anScol,
					matricule: matricule
				},
				function(resultat) {

				})
		})

		$(".close").click(function(){
			$(this).parent('div').addClass('hidden');
		})

	})
</script>
