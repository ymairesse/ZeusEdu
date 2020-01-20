<div id="repertoire">

	<ul class="nav nav-tabs">
		{foreach from=$listeCoursGrp key=coursGrp item=dataCoursGrp name=boucleCoursGrp}
		<li {if $smarty.foreach.boucleCoursGrp.first}class="active"{/if} title="{$dataCoursGrp.libelle}">
			<a data-toggle="tab" href="#cours{$smarty.foreach.boucleCoursGrp.iteration}">
			  {$abrCoursGrp[$coursGrp]}
			</a>
		</li>
		{/foreach}
	</ul>

	<div class="tab-content">
		{foreach from=$listeCoursGrp key=coursGrp item=dataCoursGrp name=boucleCoursGrp}
		{assign var=nCours value=$smarty.foreach.boucleCoursGrp.iteration}
		<div id="cours{$smarty.foreach.boucleCoursGrp.iteration}" class="tab-pane fade{if $smarty.foreach.boucleCoursGrp.first} in active{/if}">
			<h3>{$dataCoursGrp.libelle} {$dataCoursGrp.nbheures}h [{$dataCoursGrp.nom}]</h3>
			{if isset($listeCotes.$coursGrp)}
				{assign var=listeCotesCours value=$listeCotes.$coursGrp}
				{assign var=nCours value=$smarty.foreach.boucleCoursGrp.iteration}

				{include file="detailSuivi/navTabsCours.tpl"}
			{else}
				<p class="avertissement">Répertoire vide</p>
			{/if}

		</div>
		{/foreach}
	</div>

</div>
