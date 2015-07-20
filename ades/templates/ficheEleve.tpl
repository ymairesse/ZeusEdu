<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>
{assign var=memo value=$memoEleve.proprio}
{assign var=idProprio value=$memo|key}
{assign var=leMemo value=$memo.$idProprio}
<div class="container">

<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>

<ul id="tabs" class="nav nav-tabs hidden-print" data-tabs="tabs">
	<li class="active"><a href="#tabs-1" data-toggle="tab">Fiche Disciplinaire</a></li>
	<li><a href="#tabs-2" data-toggle="tab">Parents et responsables</a></li>
	<li><a href="#tabs-3" data-toggle="tab">Données personnelles</a></li>
	<li><a href="#tabs-4" data-toggle="tab">Mémo {if $leMemo.texte|count_characters > 0}<i class="fa fa-pencil-square-o text-danger"></i>{/if}</a></li>
</ul>

<div id="FicheEleve" class="tab-content">

	<div class="tab-pane active" id="tabs-1">
		{include file="infoDisciplinaires.tpl"}
	</div>
	<div class="tab-pane hidden-print" id="tabs-2">
		{include file="donneesParents.tpl"}
	</div>
	<div class="tab-pane hidden-print" id="tabs-3">
		{include file="donneesPerso.tpl"}
	</div>
	<div class="tab-pane hidden-print" id="tabs-4">
		{include file="memoEleve.tpl"}
	</div>

</div> <!-- tab-content -->

</div>  <!-- container -->

<script type="text/javascript">

<!-- quel est l'onglet actif? -->
var onglet = "{$onglet|default:''}";

<!-- activer l'onglet dont le numéro a été passé -->
$(".nav-tabs li a[href='#tabs-"+onglet+"']").tab('show');


$(document).ready(function(){

	window.location.hash = '#top';


	$(".delete").click(function(){
		if (!(confirm("Veuillez confirmer l'effacement définitif de cet item")))
			return false;
		})

	<!-- si l'on clique sur un onglet, son numéro est retenu dans un input caché dont la "class" est "onglet" -->

	$("#tabs li a").click(function(){
		var ref=$(this).attr("href").split("-")[1];
		$(".onglet").val(ref);
		});

})

</script>
