<div class="container-fluid">

	<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}
	{if (isset($coursGrp) && ($coursGrp != ''))}
			{$listeCours.$coursGrp.nomCours|default:''} - [{$coursGrp}] {$listeCours.$coursGrp.statut} {$listeCours.$coursGrp.libelle} {$listeCours.$coursGrp.nbheures}h
	{/if}</h2>

	<div class="row">

		<div class="col-md-10 col-sm-9">

			<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
				<li class="active"><a href="#tabs-1" data-toggle="tab">Notes</a></li>
				<li><a href="#tabs-2" data-toggle="tab">Données personnelles</a></li>
				<li><a href="#tabs-3" data-toggle="tab">Parents et responsable</a></li>
			</ul>

			<div id="my-tab-content" class="tab-content">

				<div class="tab-pane active" id="tabs-1">
				{include file="inc/tabEleve1.inc.tpl"}
				</div>  <!-- tabs-1 -->

				<div class="tab-pane" id="tabs-2">
				{include file="inc/tabEleve2.inc.tpl"}
				</div>  <!-- tabs-2 -->

				<div class="tab-pane" id="tabs-3">
				{include file="inc/tabEleve3.inc.tpl"}
				</div> <!-- tabs-3 -->

			</div>  <!-- my-tab-content -->

		</div>  <!-- col-md-10 ... -->

		<div class="col-md-2 col-sm-3">

			<img src="../photos/{$eleve.photo}.jpg" class="photo img-responsive" alt="{$eleve.prenom} {$eleve.nom}" title="{$eleve.prenom} {$eleve.nom}">

		</div>

	</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
var modifie = false;

$(document).ready(function(){

	$("#mod").hide();

	function modification () {
		if (!(modifie)) {
			modifie = true;
			$("#mod").show();
			window.onbeforeunload = function(){
				var reponse = confirm (confirmationBeforeUnload);
				if (!(reponse)) {
					$.unblockUI();
				}
				return reponse
			};
			}
		}

	$("#padEleve").keyup(function(e){
		var readonly = $(this).attr("readonly");
		if (!(readonly)) {
		var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
		if ((key > 31) || (key == 8)) {
			modification();
			}
		}
	})

	$("#padEleve").submit(function(){
		modifie = false;
		window.onbeforeunload = function(){};
		$.blockUI();
		$("#wait").show();
		})

	$("#annuler").click(function(){
		if (confirm(confirmationReset)) {
			$("#mod").hide();
			modifie = false;
			window.onbeforeunload = function(){};
			return true
			}
		else {
			$.unblockUI();
			return false;
			}
	})

	// le copier/coller provoque aussi une "modification"
	$("input, textarea").bind('paste', function(){
		modification()
	});


})


</script>
