<div class="container-fluid">

<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

<div class="row">

	<div class="col-md-10 col-sm-8">
		<ul class="nav nav-tabs" id="tabs">
			<li><a data-toggle="tab" href="#tabs-0">Suivi</a></li>
			<li><a data-toggle="tab" href="#tabs-1">Personnel</a></li>
			<li><a data-toggle="tab" href="#tabs-2">Responsables</a></li>
			<li><a data-toggle="tab" href="#tabs-3" id="medical" title="Médical">{if $medicEleve.info != ''}<i class="fa fa-heartbeat faa-pulse animated" style="font-size:1.2em; color: red"></i>{else}<i class="fa fa-heart" style="color:blue"></i> {/if}</a></li>
			<li><a data-toggle="tab" href="#tabs-4" title="Infirmerie"><i style="color: red;" class="fa fa-medkit fa-lg"></i>  <span class="badge" style="color:red; background: white">{$consultEleve|@count}</span></a></li>
			<li><a data-toggle="tab" href="#tabs-5">Bulletin</a></li>
			<li><a data-toggle="tab" href="#tabs-6" id="scolaire">Scolaire</a></li>
			<li><a data-toggle="tab" href="#tabs-7" id="rep">Répertoire</a></li>
			<li><a data-toggle="tab" href="#tabs-8" id="edt">EDT</a></li>
			<li><a data-toggle="tab" href="#tabs-9" id="ades">ADES <span class="badge" style="color:red; background: white;">{$nbFaits}</span></a></li>
			<li><a data-toggle="tab" href="#tabs-10">EBS {if $infoEBS != ''}<i class="fa fa-user-circle-o"></i> {/if}</a> </li>
		</ul>
	</div>

	<div class="col-md-2 col-sm-4">
		<form action="index.php" method="POST" role="form" class="form-inline microform">
		<button type="submit" class="btn btn-primary pull-right">Nouveau R.V.</button>
		<input type="hidden" name="matricule" id="matricule" value="{$eleve.matricule}">
		<input type="hidden" name="mode" value="new">
		<input type="hidden" name="action" value="{$action}">
		</form>
	</div>

</div>

    <div class="tab-content">

		<div id="tabs-0" class="tab-pane fade in active">

			{include file="detailSuivi/suivi.tpl"}

		</div>

        <div id="tabs-1" class="tab-pane fade in">

			{include file="detailSuivi/donneesPerso.tpl"}

		</div>

		<div id="tabs-2" class="tab-pane fade in">

			{include file="detailSuivi/donneesParents.tpl"}

		</div>

		<div id="tabs-3" class="tab-pane fade in">

			{include file="detailSuivi/infoMedic.tpl"}

		</div>

		<div id="tabs-4" class="tab-pane fade in">

			{include file="detailSuivi/visitesInfirmerie.tpl"}

		</div>

		<div id="tabs-5" class="tab-pane fade in">

			{include file="selecteurs/selectBulletin.tpl"}

		</div>

		<div id="tabs-6" class="tab-pane fade in">

			{* {include file="detailSuivi/scolaire.tpl"} *}

		</div>

		<div id="tabs-7" class="tab-pane fade in">

			{* include file="detailSuivi/repertoire.tpl" *}

		</div>

		<div id="tabs-8" class="tab-pane fade in">
			{* {if $imageEDT == ''}
			 	<iframe src="../edt/index.html" style="width:100%; height:600px"></iframe>
				{else}
				<img src="../edt/eleves/{$imageEDT}" alt="{$imageEDT}" class="img img-responsive">
			{/if} *}
		</div>

		<div id="tabs-9" class="tab-pane fade in">

			{* {include file="detailSuivi/infoDisciplinaires.tpl"} *}

		</div>

		<div id="tabs-10" class="tab-pane fade in">

			{include file="detailSuivi/infoEBS.tpl"}

		</div>

</div>




<script type="text/javascript">

var onglet = "{$onglet|default:0}";


$(document).ready(function(){

	// activer l'onglet dont le numéro a été passé
	$('#tabs li a').eq(onglet).tab('show');

	$('#ades').click(function(){
		var matricule = $('#matricule').val();
		$.post('inc/suivi/ades.inc.php', {
			matricule: matricule
		}, function(resultat){
			$('#tabs-9').html(resultat);
		})
	})

	$('#rep').click(function(){
		var matricule = $('#matricule').val();
		$.post('inc/suivi/repertoire.inc.php', {
			matricule: matricule
		}, function(resultat){
			$('#tabs-7').html(resultat);
		})
	})

	$('#edt').click(function(){
		var matricule = $('#matricule').val();
		$.post('inc/suivi/edt.inc.php', {
			matricule: matricule
		}, function(resultat){
			$('#tabs-8').html(resultat);
		})
	})

	$('#scolaire').click(function(){
		var matricule = $('#matricule').val();
		$.post('inc/suivi/scolaire.inc.php', {
			matricule: matricule
		}, function(resultat){
			$('#tabs-6').html(resultat);
		})
	})


	$("#tabs li").click(function(){
		var n = $(this).index()
		$(".onglet").val(n);
		})

	// si l'on clique sur un onglet, son numéro est retenu dans un des inputs cachés dont la class est 'onglet'
	$("#tabs ul li a").click(function(){
		var no = $(this).attr("href").substr(6,1);
		$(".onglet").val(no-1);
		});

	$(".delete").click(function(){
		if (!(confirm("Veuillez confirmer l'effacement définitif de cet item")))
			return false;
		})

})

</script>
