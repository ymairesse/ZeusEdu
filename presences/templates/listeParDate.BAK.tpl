<div class="container-fluid">
<h3>Liste des absences du {$date}</h3>
<h4>Liste 1
{foreach from=$statutsAbs.liste1 item=item key=statut}
	<span style="color:{$listeJustifications.$item.color}; background:{$listeJustifications.$item.background}"
			title="{$listeJustifications.$item.libelle}">{$item}
	</span>
{/foreach}
</h4>

<div class="table-responsive">
<table class="tableauPresences table table-striped table-condensed">
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
					style="display:block; width:100%; color:{$listeJustifications.$statut.color|default:'#f00'}; background:{$listeJustifications.$statut.background|default:'#666'}"
					class="periode pop micro"
					data-toggle="popover"
					data-content="{$listeJustifications.$statut.libelle|default:'!!!'|cat:'<br>'|cat:$p.parent|cat:'<br>'|cat:$p.media}"
					data-html="true"
					data-container="body"
					data-original-title="{$titre}">
					{$listeJustifications.$statut.shortJustif|default:'!!!'}
				</span>
			</td>
		{else}
			<td title="indetermine" data-container="body" data-html="true">
				<span style="display:block; width:2em" class="periode indetermine">
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

<h4>Liste 2 (justifie un SMS)
{foreach from=$statutsAbs.liste2 item=item key=statut}
	<span style="color:{$listeJustifications.$item.color|default:null}; background:{$listeJustifications.$item.background|default:null}"
		title="{$listeJustifications.$item.libelle|default:null}">{$item}</span>
{/foreach}
</h4>

<div class="table-responsive">

<table class="tableauPresences table table-striped table-condensed">
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
				<span style="display:block; width:100%; color:{$listeJustifications.$statut.color|default:'#f00'};  background:{$listeJustifications.$statut.background|default:'#666'}"
					class="periode pop micro"
					data-toggle="popover"
					data-content="{$listeJustifications.$statut.libelle|default:'!!!'|cat:'<br>'|cat:$p.parent|cat:'<br>'|cat:$p.media}"
					data-html="true"
					data-container="body"
					data-original-title="{$titre}">
				{$listeJustifications.$statut.shortJustif|default:'-'}
				</span>
			</td>
		{else}
			<td title="indetermine" data-container="body" data-html="true">
				<span style="display:block; width:2em" class="periode indetermine">-</span>
			</td>
		{/if}
	{/foreach}
	<td class="micro">{$smarty.foreach.boucle.iteration}</td>
	</tr>
	{/foreach}
</table>
</div>

{include file='legendeAbsences.tpl'}
</div>
