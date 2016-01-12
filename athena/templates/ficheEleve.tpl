<div class="container">

<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

<div class="row">

	<div class="col-md-10 col-sm-8">
		<ul class="nav nav-tabs" id="tabs">
			<li><a data-toggle="tab" href="#tabs-0">Suivi</a></li>
			<li><a data-toggle="tab" href="#tabs-1">Personnel</a></li>
			<li><a data-toggle="tab" href="#tabs-2">Responsables</a></li>
			<li><a data-toggle="tab" href="#tabs-3">Médical {if $medicEleve.info != ''}<i class="fa fa-heartbeat faa-pulse animated" style="font-size:1.2em; color: red"></i>{/if}</a></li>
			<li><a data-toggle="tab" href="#tabs-4">Infirmerie <span class="badge" style="color:red; background: white">{$consultEleve|@count}</span></a></li>
			<li><a data-toggle="tab" href="#tabs-5">Bulletin</a></li>
			<li><a data-toggle="tab" href="#tabs-6">EDT</a></li>
			<li><a data-toggle="tab" href="#tabs-7">ADES</a></li>
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

			 <iframe src="http://isnd.be/peda/edt" style="width:100%; height:600px"></iframe>

		</div>


		<div id="tabs-7" class="tab-pane fade in">

			{include file="detailSuivi/ades.tpl"}

		</div>

</div>




<script type="text/javascript">

var onglet = "{$onglet|default:0}";


$(document).ready(function(){

	<!-- activer l'onglet dont le numéro a été passé -->
	$('#tabs li a').eq(onglet).tab('show');


	$("#tabs li").click(function(){
		var n = $(this).index()
		$(".onglet").val(n);
		})

	<!-- si l'on clique sur un onglet, son numéro est retenu dans un des inputs cachés dont la class est 'onglet' -->
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
