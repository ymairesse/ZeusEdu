<div class="container">
<h3>Liste des absences du {$date}</h3>
<h4>Liste 1
{foreach from=$statutsAbs['liste1'] key=wtf item=statut}
	<span class="{$statut}">{$statut}</span>
{/foreach}</h4>

<div class="table-responsive">
<table class="tableauPresences table table-hover table-condensed">
	<tr>
		<th>Matricule</th>
		<th>Classe</th>
		<th>Nom</th>
		{foreach from=$listePeriodes key=periode item=limitesPeriode}
		<th style="width:3.5em"><strong>{$periode}</strong><br>{$limitesPeriode.debut} - {$limitesPeriode.fin}</th>
		{/foreach}
		<td>&nbsp;</td>
	</tr>

	{foreach from=$liste1 key=matricule item=unEleve name=boucle}
	<tr style="font-size:1.3em">
	<td>{$matricule}</td>
	<td>{$unEleve.identite.classe}</td>
	<td class="pop"
		data-toggle="popover"
		data-content="<img src='../photos/{$unEleve.identite.photo}.jpg' alt='{$matricule}' style='width:100px'>"
		data-html="true"
		data-container="body"
		data-original-title="{$unEleve.identite.nom|truncate:15}">
		{$unEleve.identite.nom}
	</td>
	{foreach from=$listePeriodes key=laPeriode item=wtf}
		{if isset($unEleve.presences.$laPeriode)}
			{assign var=p value=$unEleve.presences.$laPeriode}
			{assign var=statut value=$p.statut}
			{assign var=titre value=$p.educ|cat:' ['|cat:$p.quand|cat:' à '|cat:$p.heure|cat:']'}
			<td>
				<span
					style="display:block; width:100%"
					class="periode {$statut} pop"
					data-toggle="popover"
					data-content="{$p.parent|cat:'<br>'|cat:$p.media}"
					data-html="true"
					data-container="body"
					data-original-title="{$titre}">
					{if $p.statut == 'absent'}
						{$p.educ|default:'???'}
					{else}
						<span class="micro">{$p.statut|truncate:2:''}</span>
					{/if}
					<!-- <img src="images/{$statut}.png" alt="{$statut}"> -->
				</span>
			</td>
		{else}
			<td title="indetermine" data-container="body" data-html="true">
				<span style="display:block; width:2em" class="periode indetermine">
				<!-- <img src="images/indetermine.png" alt="indetermine"> -->
				-
				</span>
			</td>
		{/if}
	{/foreach}
	<td class="micro">{$smarty.foreach.boucle.iteration}</td>
	</tr>
	{/foreach}
</table>

</div>

<h4>Liste 2
{foreach from=$statutsAbs['liste2'] key=wtf item=statut}
	<span class="{$statut}"><img src="images/{$statut}.png" alt="{$statut}">{$statut}</span>
{/foreach}</h4>

<div class="table-responsive">

<table class="tableauPresences table table-hover table-condensed">
	<tr>
		<th>Matricule</th>
		<th>Classe</th>
		<th>Nom</th>
		{foreach from=$listePeriodes key=periode item=limitesPeriode}
		<th style="width:3.5em"><strong>{$periode}</strong><br>{$limitesPeriode.debut} - {$limitesPeriode.fin}</th>
		{/foreach}
		<td>&nbsp;</td>
	</tr>

	{foreach from=$liste2 key=matricule item=unEleve name=boucle}
	<tr style="font-size:1.3em">
	<td>{$matricule}</td>
	<td>{$unEleve.identite.classe}</td>
	<td class="pop"
		data-toggle="popover"
		data-content="<img src='../photos/{$unEleve.identite.photo}.jpg' alt='{$matricule}' style='width:100px'>"
		data-html="true"
		data-container="body"
		data-original-title="{$unEleve.identite.nom}">
		{$unEleve.identite.nom}
	</td>
	{foreach from=$listePeriodes key=laPeriode item=wtf}
		{if isset($unEleve.presences.$laPeriode)}
			{assign var=p value=$unEleve.presences.$laPeriode}
			{assign var=statut value=$p.statut}
			{assign var=titre value=$p.educ|cat:' ['|cat:$p.quand|cat:' à '|cat:$p.heure|cat:']'}
			<td>
				<span style="display:block; width:100%"
					  class="periode {$statut} pop"
					  data-toggle="popover"
					  data-content="{$p.parent|cat:'<br>'|cat:$p.media}"
					  data-html="true"
					  data-container="body"
					  data-original-title="{$titre}">
					{if $p.statut == 'absent'}
						{$p.educ|default:'???'}
					{else}
						<span class="micro">{$p.statut|truncate:2:''}</span>
					{/if}
					<!-- <img src="images/{$statut}.png" alt="{$statut}"> -->
				</span>
			</td>
		{else}
			<td title="indetermine" data-container="body" data-html="true">
				<span style="display:block; width:2em" class="periode indetermine">
				<!-- <img src="images/indetermine.png" alt="indetermine"> -->
				-
				</span>
			</td>
		{/if}
	{/foreach}
	<td class="micro">{$smarty.foreach.boucle.iteration}</td>
	</tr>
	{/foreach}
</table>
</div>

{include file='legendeAbsences.html'}
</div>
