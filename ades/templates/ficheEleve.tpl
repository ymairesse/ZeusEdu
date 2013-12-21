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

	</div>
		
</div> <!-- tabs -->

<script type="text/javascript">
{literal}
	$(document).ready(function(){
		
		$("#tabs").tabs();
		
		$(".delete").click(function(){
			if (!(confirm("Veuillez confirmer l'effacement définitif de cet item")))
				return false;
			})
	})
{/literal}
</script>