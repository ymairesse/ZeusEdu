{if $listeFaits|count > 0}

	{foreach from=$listeFaits key=classe item=tousLesEleves}
		{if $tousLesEleves|count > 1}
			<h1 class="classeEntete">{$classe}</h1>
		{/if}

		{foreach from=$tousLesEleves key=matricule item=ficheEleve}

			<div class="row ombre" style="border: 1px solid #555">

				<div class="col-xs-10">
					<h2 class="eleveEntete">{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom} {$listeEleves.$matricule.classe}</h2>
					<p style="font-weight: bolder">Du {$debut} au {$fin}</p>
				</div>
				<div class="col-xs-2">
					<img src="../photos/{$listeEleves.$matricule.photo}.jpg" alt="{$matricule}" style="width:60px; margin: 0.5em" class="img-thumbnail pull-right">
				</div>

			</div>

			{foreach from=$ficheEleve key=typeFait item=listeFaits}
				{assign var=dataFait value=$listeTypesFaits.$typeFait}

				<h4 style="clear:both; color:{$dataFait.couleurTexte}; background:{$dataFait.couleurFond}">{$dataFait.titreFait}</h4>
					<table class="table table-condensed table-hover table-striped tableauSynthese">
						<thead>
							<tr>
								{foreach from=$listeChamps.$typeFait item=champ}
								<th>{$descriptionsChamps.$champ.label}</th>
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
{else}
	<p style="font-size: 20pt; margin-top: 3em;">Aucun fait disciplinaire sur la période {$debut} -> {$fin}</p>
{/if}
