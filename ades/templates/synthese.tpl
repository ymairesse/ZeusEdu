<div class="container">

{foreach from=$listeFaits key=classe item=Eleves}
	{if $Eleves|count > 1}
		<h2 class="classeEntete">{$classe}</h2>
		<p  class="pageBreak"></p>
	{/if}

	{foreach from=$Eleves key=matricule item=ficheEleve}

		<div class="row">

			<div class="col-xs-10">
				<h3 class="eleveEntete">{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom} {$listeEleves.$matricule.classe}</h3>
				<p style="font-weight: bolder">Du {$debut} au {$fin}</p>
			</div>
			<div class="col-xs-2 img-responsive">
				<img src="../photos/{$listeEleves.$matricule.photo}.jpg" alt="{$matricule}" style="width:100px">
			</div>

		</div>

		{foreach from=$ficheEleve key=typeFait item=listeFaits}
			<h4 style="clear:both">{$listeTypesFaits.$typeFait.titreFait}</h4>
				<table class="table table-condensed table-hover table-striped tableauSynthese">
					<thead>
						<tr>
							{foreach from=$listeChamps.$typeFait item=champ}
							<th>{$listeTitres.$champ}</th>
							{/foreach}
						</tr>
					</thead>
					{foreach from=$listeFaits key=wtf item=faits}
					<tr>
						{foreach from=$listeChamps.$typeFait key=wtf item=unChamp}
						<td>{$faits.$unChamp|default:''}</td>
						{/foreach}
					</tr>
					{/foreach}

				</table>
		{/foreach}

	{/foreach}
{/foreach}
</div>
