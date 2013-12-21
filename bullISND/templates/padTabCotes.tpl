{foreach from=$syntheseToutesAnnees key=annee item=dataSynthese}
{assign var=listeCours value=$dataSynthese.listeCours}
{assign var=resultats value=$dataSynthese.resultats}
<h3>Résultats de {$annee}e</h3>
	<table class="tableauTitu">
		<tr>
			<th>&nbsp;</th>
			{foreach from=$listeCours key=coursGrp item=data}
				<th title="{$data.libelle} {$coursGrp}">{$data.cours} {$data.nbheures}h {$data.statut} </th>
			{/foreach}
			<th>Mentions</th>
		</tr>
		
		{foreach from=$resultats key=periode item=bulletin}

		<tr>
			<th>{$periode}</th>
			{foreach from=$listeCours key=coursGrp item=data}
				{if in_array($coursGrp, array_keys($resultats.$periode))}
					<td class="cote mention{$resultats.$periode.$coursGrp.mention|default:''}" title="{$coursGrp}">
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

<table class="micro">
<tr>
	<td colspan="6">Code de couleurs</td>
</tr>
<tr>
	<td class="mentionI">< 50</td>
	<td class="mentionF">50</td>
	<td class="mentionS">60</td>
	<td class="mentionAB">65</td>
	<td class="mentionB">70</td>
	<td class="mentionBplus">75</td>
	<td class="mentionTB">80</td>
	<td class="mentionTBplus">85</td>
	<td class="mentionE">>90</td>
</tr>
</table>
