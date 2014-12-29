{if $classe != Null && $date != Null}

<h3>Feuille de présences pour la classe de <strong>{$classe}</strong> le <strong>{$date}</strong></h3>
<table class="tableauAdmin">
	<tr>
		<th style="width:6em">Matricule</th>
		<th style="width:30em">Nom/prénom</th>
		{foreach from=$listePeriodes key=noPeriode item=limitesPeriode}
		<th><strong>{$noPeriode}</strong><br>{$limitesPeriode.debut} - {$limitesPeriode.fin}</th>
		{/foreach}
	</tr>

	{foreach from=$listeEleves key=matricule item=dataEleve}
	<tr>
		<td>{$matricule}</td>
		<td class="tooltip">
			<div class="tip" style="display:none"><img src="../photos/{$dataEleve.photo}.jpg" alt="{$matricule}" style="width:100px"><br>{$matricule}</div>
			{$dataEleve.nom} {$dataEleve.prenom}
		</td>
		{foreach from=$listePeriodes key=noPeriode item=data}
			{assign var=x value=$listePresences.$matricule.$noPeriode}
			{if $x.statut != 'indetermine'}
				{assign var=titre value='<h3>'|cat:$x.educ|cat:' ['|cat:$x.quand|cat:' à '|cat:$x.heure|cat:']'|cat:'</h3>'|cat:$x.parent|cat:'-'|cat:$x.media}
				{else}
				{assign var=titre value=$x.statut}
			{/if}
			<td class="{$x.statut}" title="{$titre}">
				<img src="images/{$x.statut}.png" alt="{$x.statut}">
			</td>
		{/foreach}
	</tr>
	{/foreach}

</table>

{include file='legendeAbsences.html'}

{/if}
