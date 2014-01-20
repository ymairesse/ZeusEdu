{foreach from=$listeFaits key=classe item=Eleves}
	{if $Eleves|count > 1}
		<h2 class="classeEntete">{$classe}</h2>
		<p  class="pageBreak"></p>
	{/if}

	{foreach from=$Eleves key=matricule item=ficheEleve}
	<img src="../images/logoEcole.png" alt="logoEcole" style="float:left">
	<h2>Fiche de discipline de </h2>
	<h3 class="eleveEntete">{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom} {$listeEleves.$matricule.classe}</h3>
	<p style="font-weight: bolder">Du {$debut} au {$fin}</p>
		{foreach from=$ficheEleve key=typeFait item=listeFaits}
			<h4 style="clear:both">{$listeTypesFaits.$typeFait.titreFait}</h4>
				<table class="tableauSynthese">
					<tr>
						{foreach from=$listeChamps.$typeFait item=champ}
						<th>{$listeTitres.$champ}</th>
						{/foreach}
					</tr>
					
					{foreach from=$listeFaits key=wtf item=faits}
					<tr>
						{foreach from=$listeChamps.$typeFait key=wtf item=unChamp}
						<td>{$faits.$unChamp}</td>
						{/foreach}
					</tr>
					{/foreach}
					
				</table>
		{/foreach}
	<div class="noScreen">
		<p style="margin-top:3em">Document à remettre signé à l'éducateur de niveau</p>
		<table width="100%">
			<tr>
				<td width="50%">Signature des parents</td>
				<td width="50%">Signature de l'élève</td>
			</tr>
		</table>
	</div>
	{if $Eleves|@count > 1}
	<br class="pageBreak">
	{/if}
	{/foreach}
{/foreach}