<div class="container-fluid">

	<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

	<div class="row">

		<div class="col-xs-12">

			<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
				<li class="active"><a href="#tabs-1" data-toggle="tab">Notes</a></li>
				<li><a href="#tabs-2" data-toggle="tab">Scolaire</a></li>
				<li><a href="#tabs-3" data-toggle="tab">Personnel</a></li>
				<li><a href="#tabs-4" data-toggle="tab">Parents</a></li>
				<li><a href="#tabs-5" data-toggle="tab">Athena {if $listeSuivi|@count > 0}<span class="badge" style="color:red; background: white;">{$listeSuivi|count}</span>{/if}</a></li>
				<li><a href="#tabs-6" data-toggle="tab">Ades {if $nbFaits > 0}<span class="badge" style="color:red; background-color: white">{$nbFaits}</span>{/if}</a></li>
				<li><a href="#tabs-7" data-toggle="tab">Présences {if $listePresences|@count > 0}<span class="badge" style="color:red; background-color: white">{$listePresences|@count}</span>{/if}</a></li>
				<li><a href="#tabs-8" data-toggle="tab">Horaire EDT</a></li>
				<li><a data-toggle="tab" href="#tabs-10">Médical <i style="color: red;" class="fa fa-medkit fa-lg"></i>  <span class="badge" style="color:red; background: white">{$consultEleve|@count}</span>
				{if $medicEleve.info != ''}
					<i class="fa fa-heartbeat faa-pulse animated" style="font-size:1.2em; color: red"></i>
				{/if}
				</a></li>
			</ul>

			<div class="tab-content">

				<div class="tab-pane active" id="tabs-1">
					{include file="direction/pad/tabEleve1.inc.tpl"}
				</div>
				<!-- tabs-1 -->

				<div class="tab-pane" id="tabs-2">
					{include file="direction/pad/tabEleve2.inc.tpl"}
				</div>
				<!-- tabs-2 -->

				<div class="tab-pane" id="tabs-3">
					{include file="direction/pad/tabEleve3.inc.tpl"}
				</div>
				<!-- tabs-3 -->

				<div class="tab-pane" id="tabs-4">
					{include file="direction/pad/tabEleve4.inc.tpl"}
				</div>
				<!-- tabs-4 -->

				<div class="tab-pane" id="tabs-5">
					{include file="direction/pad/tabEleve5.inc.tpl"}
				</div>
				<!-- tabs-5 -->

				<div class="tab-pane" id="tabs-6">
					{include file="direction/pad/tabEleve6.inc.tpl"}
				</div>
				<!-- tabs-6 -->

				<div class="tab-pane" id="tabs-7">
					{include file="direction/pad/tabEleve7.inc.tpl"}
				</div>

				<div class="tab-pane" id="tabs-8">
					{include file="direction/pad/tabEleve8.inc.tpl"}
				</div>
				
				<div class="tab-pane" id="tabs-10">
					{include file="direction/pad/visitesInfirmerie.tpl"}
				</div>


			</div>
			<!-- my-tab-content -->

		</div>
		<!-- col-md-10 ... -->

	</div>
	<!-- row -->

</div>
<!-- container -->

<script type="text/javascript">

	//  quel est l'onglet actif?
	var onglet = Cookies.get('onglet');
	// activer l'onglet dont le numéro a été passé
	$(".nav-tabs li a[href='#tabs-" + onglet + "']").tab('show');

	var isModified = false;
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";

	function modification () {
		if (!(isModified)) {
			isModified = true;
			window.onbeforeunload = function(){
				return confirm (confirmationBeforeUnload);
			};
			}
		}

	$(document).ready(function(){

		$('input, textarea, checkbox').on('change', function(){
			modification();
		})

		$('#tabs li a').click(function(){
			var ref = $(this).attr('href').split('-')[1];
			Cookies.set('onglet', ref);
		})

		$(".popover-eleve").mouseover(function(){
			$(this).popover('show');
			})
		$(".popover-eleve").mouseout(function(){
			$(this).popover('hide');
			})

		$('#tabs-1').on('click', '.btn-viewMatiere', function(){
			$(this).closest('tr').find('td div').toggle(200);
			})

		$('#tabs-1').on('click', '#btn-openAll', function(){
			$(this).closest('table').find('td div').toggle(200);
		})

		$('#tabs-1').on('click', '.btn-deleteMatiere', function(){
			var coursGrp = $(this).data('coursgrp');
			var anScol = $(this).data('anscol');
			var periode = $(this).data('periode');
			var matricule = $('#selectEleve').val();
			bootbox.confirm({
				title: 'Confirmation',
				message: 'Veuillez confirmer la suppression des notes pour le cours ' + coursGrp,
				callback: function(result){
					if (result == true) {
						$.post('inc/direction/delMatiere.inc.php', {
							matricule: matricule,
							coursGrp: coursGrp,
							anScol: anScol,
							periode: periode
						}, function(nb){
							if (nb != 0) {
								$.post('inc/direction/refreshListeMatieres.inc.php', {
									matricule: matricule,
									anScol: anScol,
									periode: periode
								}, function(resultat){
									$('.listeMatieres_' + anScol + '_' + periode).html(resultat);
								})
							}
							bootbox.alert({
								title: 'Suppression d\'une matière',
								message: nb + ' matière supprimée'
							});
						})
					}
				}
			})
		})

	})

</script>
