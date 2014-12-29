{debug}
<h3>Absences de {$detailsEleve.nom} {$detailsEleve.prenom} {$detailsEleve.classe}</h3>
{if $listePresences|count == 0}
<p>Aucune absence</p>
{else}
<table class="tableauAdmin">
	<tr>
		<th>&nbsp;</th>
		<th colspan="{$listePeriodes|count}">Périodes</th>
	</tr>
	<tr>
		<th>Date</th>
		{foreach from=$listePeriodes key=noPeriode item=bornes}
			<th><strong>{$noPeriode}<br></strong>{$bornes.debut} / {$bornes.fin}</th>
		{/foreach}
	</tr>
{foreach from=$listePresences key=date item=presence}
	<tr>
		<td>{$date}</td>
		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{if ($listePresences.$date.$noPeriode.statut != '')}
				{assign var=statut value=$listePresences.$date.$noPeriode.statut}
				{else}
				{assign var=statut value='indetermine'}
			{/if}
			{assign var=laPeriode value=$listePresences.$date.$noPeriode}
			{if ($laPeriode.educ == '')}
				{assign var=titre value=Null}
				{else}
				{assign var=titre value="<h3>{$laPeriode.educ} [{$laPeriode.quand} à {$laPeriode.heure}]</h3><br>{$laPeriode.parent} - {$laPeriode.media}"}
			{/if}
			<td class="{$statut} tooltip">
				<span class="tip">{$titre}</span>
				<img src="images/{$statut}.png" alt="{$statut}">
			</td>	
		{/foreach}
	</tr>
{/foreach}
</table>

{include file='legendeAbsences.html'}

{/if}
