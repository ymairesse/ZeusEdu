<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>
<h2>{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>
	
<div id="tabs">
	<ul>
		<li><a href="#tabs-1">Fiche Disciplinaire</a></li>
		<li><a href="#tabs-2">Parents et responsables</a></li>
		<li><a href="#tabs-3">Données personnelles</a></li>
		<li><a href="#tabs-4">Mémo</a></li>
	</ul>
	
	<div id="tabs-1">
		{include file="infoDisciplinaires.tpl"}
	</div>
	<div id="tabs-2">
		{include file="donneesParents.tpl"}
	</div>
	<div id="tabs-3">
		{include file="donneesPerso.tpl"}
	</div>
	<div id="tabs-4">
		{include file="memoEleve.tpl"}
	</div>
		
</div> <!-- tabs -->

<script type="text/javascript">
	<!-- quel est l'onglet actif? -->
	var onglet = "{$onglet|default:''}";
;
{literal}
	$(document).ready(function(){
		
		window.location.hash = '#top';
		
		$("#tabs").tabs();

		$(".delete").click(function(){
			if (!(confirm("Veuillez confirmer l'effacement définitif de cet item")))
				return false;
			})
		
		<!-- activer l'onglet dont le numéro a été passé -->
		$('#tabs').tabs("option", "active", onglet);
		
		<!-- si l'on clique sur un onglet, son numéro est retenu dans un input caché dont l'id est 'onglet' -->
		$("#tabs ul li a").click(function(){
			var no = $(this).attr("href").substr(6,1);
			$(".onglet").val(no-1);
			});
		
	})
{/literal}
</script>
