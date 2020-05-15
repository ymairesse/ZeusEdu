{assign var=memo value=$memoEleve.proprio}
{assign var=idProprio value=$memo|key}
{assign var=leMemo value=$memo.$idProprio}
<div class="container-fluid">

	<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

	<ul id="tabs" class="nav nav-tabs hidden-print" data-tabs="tabs">
		<li class="active"><a href="#tabs-1" data-toggle="tab"><i class="fa fa-legal"></i> Fiche Disciplinaire</a></li>
		<li><a href="#tabs-2" data-toggle="tab"><i class="fa fa-user-plus"></i> Parents et responsables</a></li>
		<li><a href="#tabs-3" data-toggle="tab"><i class="fa fa-user"></i> Données personnelles</a></li>
		<li><a href="#tabs-4" data-toggle="tab">{if $leMemo.texte|count_characters > 0}<i class="fa fa-pencil-square-o text-danger"></i>{/if} Mémo</a></li>
	</ul>

	<div id="ficheEleve" class="tab-content">

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
<script type="text/javascript">

	// quel est l'onglet actif?
	var onglet = {$onglet|default:''}
	// activer l onglet dont le numéro a été passé
	$(".nav-tabs li a[href='#tabs-" + onglet + "']").tab('show');


	$(document).ready(function() {

		window.location.hash = '#top';

		$("#tabs li a").click(function() {
			var ref = $(this).attr("href").split("-")[1];
			$(".onglet").val(ref);
		});

		$(".close").click(function(){
			$(this).parent('div').addClass('hidden');
		})
		$(".openThis").click(function() {
			var table = $(this).closest('h3').next().find('table');
			if (table.hasClass('hidden'))
				table.removeClass('hidden');
			else table.addClass('hidden');
		})
		$("#openAll").click(function() {
			$(".openThis").trigger('click');
		})

	})
</script>
