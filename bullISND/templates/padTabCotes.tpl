{if isset($degre) && ($degre == 1)}
<h3>Résultats du CEB</h3>
<table style="font-size:0.8em; width:100%" class="tableauTitu">
	<tr>
		<th style="width:17%">Matières</th>
		<th style="width:17%">Français</th>
		<th style="width:17%">Math</th>
		<th style="width:17%">Sciences</th>
		<th style="width:17%">Histoire/géo</th>
		<th style="width:17%">Deuxième langue</th>
	</tr>
	<tr>
		<th>Cotes obtenues</th>
		<td class="cote">{$ceb.fr}</td>
		<td class="cote">{$ceb.math}</td>
		<td class="cote">{$ceb.sc}</td>
		<td class="cote">{$ceb.hg}</td>
		<td class="cote">{$ceb.l2}</td>
	</tr>
</table>
{/if}

<!-- année scolaire en cours -->
{assign var=annee value=$classe|substr:0:1}
<h3>Résultats de {$annee}e année (année scolaire en cours)</h3>
<table style="font-size:0.8em" class="tableauTitu">
	<tr>
		<th>&nbsp;</th>
	{foreach from=$listeCoursGrp key=coursGrp item=dataCours}
		<th title="{$dataCours.libelle}|{$dataCours.coursGrp} <br>{$dataCours.prenom} {$dataCours.nom}">{$dataCours.cours} {$dataCours.nbheures}h<br>{$dataCours.statut}</th>
	{/foreach}
	<th>Mentions</th>
	</tr>

	{foreach from=$anneeEnCours key=periode item=data}
	<tr>
		<th>{$periode}</td>
		{foreach from=$listeCoursGrp key=coursGrp item=dataCours}
			<td class="cote mention{$anneeEnCours.$periode.$coursGrp.mention|trim:'+'|default:''}" title="{$coursGrp}">
			{if isset($anneeEnCours.$periode.$coursGrp.sitDelibe) && ($anneeEnCours.$periode.$coursGrp.sitDelibe != '')}
				<span class="micro">Délibé</span>
				<strong>{$anneeEnCours.$periode.$coursGrp.sitDelibe|default:''}</strong><br>
			{/if}
			{if ($anneeEnCours.$periode.$coursGrp.situation|trim:' ' != '')}
				{$anneeEnCours.$periode.$coursGrp.situation|default:''}/{$anneeEnCours.$periode.$coursGrp.maxSituation|default:''}<br>
				<span class="micro">={$anneeEnCours.$periode.$coursGrp.pourcent|default:''}</span>
			{else}
				&nbsp;
			{/if}
			</td>
		{/foreach}
		<td class="cote"><strong>{$mentions.$matricule.$annee.$periode|default:'&nbsp;'}</strong></td>
	</tr>
	{/foreach}
</table>

<!-- Années scolaires précédentes -->
<h3>Année(s) scolaire(s) précédentes</h3>
{foreach from=$syntheseToutesAnnees key=anScolaire item=syntheseAnnee}
	{foreach from=$syntheseAnnee key=annee item=dataSynthese}

	{assign var=listeCoursGrp value=$dataSynthese.listeCours}
	{assign var=resultats value=$dataSynthese.resultats}
	<h4>{$anScolaire} - Résultats de {$annee}e année</h4>

		<table style="font-size:0.8em" class="tableauTitu">
			<tr>
				<th>&nbsp;</th>
				{foreach from=$listeCoursGrp key=coursGrp item=data}
					<th title="{$data.libelle}<br>{$coursGrp}">{$data.cours} {$data.nbheures}h {$data.statut} </th>
				{/foreach}
				<th>Mentions</th>
			</tr>
			
			{foreach from=$resultats key=periode item=bulletin}
			<tr>
				<th>{$periode}</th>
				{foreach from=$listeCoursGrp key=coursGrp item=data}
					{if in_array($coursGrp, array_keys($resultats.$periode))}
						<td class="cote mention{$resultats.$periode.$coursGrp.mention|trim:'+'|default:''}" title="{$coursGrp}">
							{if isset($resultats.$periode.$coursGrp.sitDelibe) && ($resultats.$periode.$coursGrp.sitDelibe != '')}
								<span class="micro">Délibé </span>
								<strong>{$resultats.$periode.$coursGrp.sitDelibe}</strong><br>
							{/if}
							
							{if isset($resultats.$periode.$coursGrp.pourcent) && ($resultats.$periode.$coursGrp.pourcent != '') }
							{$resultats.$periode.$coursGrp.situation}/{$resultats.$periode.$coursGrp.maxSituation}<br>
							<span class="micro">={$resultats.$periode.$coursGrp.pourcent}</span>
							{/if}
						 </td>
						{else}
						<td>&nbsp;</td>
					{/if}
				{/foreach}
				<td class="cote"><strong>{$mentions.$matricule.$annee.$periode|default:'&nbsp;'}</strong></td> 
			</tr>

			{/foreach}

		</table>
	{/foreach}
{/foreach}
{include file="tableauMentions.tpl"}
