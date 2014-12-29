<h3>Liste des absences du {$date}</h3>
<h4>Liste 1 
{foreach from=$statutsAbs['liste1'] key=wtf item=statut}
	<span class="{$statut}"><img src="images/{$statut}.png" alt="{$statut}">{$statut}
{/foreach}</h4>
<table class="tableauAdmin">
	<tr>
		<th>Matricule</th>
		<th>Classe</th>		
		<th>Nom</th>
		{foreach from=$listePeriodes key=periode item=limitesPeriode}
		<th style="width:3em"><strong>{$periode}</strong><br>{$limitesPeriode.debut} - {$limitesPeriode.fin}</th>
		{/foreach}
		<td>&nbsp;</td>
	</tr>

	{foreach from=$liste1 key=matricule item=unEleve name=boucle}
	<tr style="font-size:1.3em">
	<td>{$matricule}</td>
	<td>{$unEleve.identite.classe}</td>	
	<td class="tooltip"><span class="tip"><img src="../photos/{$unEleve.identite.photo}.jpg" alt="{$matricule}" style="width:100px"></span>{$unEleve.identite.nom}</td>
	{foreach from=$listePeriodes key=laPeriode item=wtf}
		{if isset($unEleve.presences.$laPeriode)}
			{assign var=p value=$unEleve.presences.$laPeriode}
			{assign var=statut value=$p.statut}
			{assign var=titre value='<h3>'|cat:$p.educ|cat:' ['|cat:$p.quand|cat:' à '|cat:$p.heure|cat:']'|cat:'</h3>'|cat:$p.parent|cat:'<br>'|cat:$p.media}
			<td title="{$titre}">
				<span style="display:block; width:2em" class="periode {$statut}"><img src="images/{$statut}.png" alt="{$statut}"</span>
		{else}
			<td title="indetermine"><span style="display:block; width:2em" class="periode indetermine"><img src="images/indetermine.png" alt="indetermine"></span></td>
		{/if}
	{/foreach}
	<td class="micro">{$smarty.foreach.boucle.iteration}</td>	
	</tr>
	{/foreach}
</table>

<h4>Liste 2 
{foreach from=$statutsAbs['liste2'] key=wtf item=statut}
	<span class="{$statut}"><img src="images/{$statut}.png" alt="{$statut}">{$statut}
{/foreach}</h4>
<table class="tableauAdmin">
	<tr>
		<th>Matricule</th>
		<th>Classe</th>
		<th>Nom</th>
		{foreach from=$listePeriodes key=periode item=limitesPeriode}
		<th style="width:3em"><strong>{$periode}</strong><br>{$limitesPeriode.debut} - {$limitesPeriode.fin}</th>
		{/foreach}
		<td>&nbsp;</td>
	</tr>

	{foreach from=$liste2 key=matricule item=unEleve name=boucle}
	<tr style="font-size:1.3em">
	<td>{$matricule}</td>
	<td>{$unEleve.identite.classe}</td>
	<td class="tooltip"><span class="tip"><img src="../photos/{$unEleve.identite.photo}.jpg" alt="{$matricule}" style="width:100px"></span>{$unEleve.identite.nom}</td>
	{foreach from=$listePeriodes key=laPeriode item=wtf}
		{if isset($unEleve.presences.$laPeriode)}
			{assign var=p value=$unEleve.presences.$laPeriode}
			{assign var=statut value=$p.statut}
			{assign var=titre value='<h3>'|cat:$p.educ|cat:' ['|cat:$p.quand|cat:' à '|cat:$p.heure|cat:']'|cat:'</h3>'|cat:$p.parent|cat:'<br>'|cat:$p.media}
			<td title="{$titre}">
				<span style="display:block; width:2em" class="periode {$statut}"><img src="images/{$statut}.png" alt="{$statut}"</span>
		{else}
			<td title="indetermine"><span style="display:block; width:2em" class="periode indetermine"><img src="images/indetermine.png" alt="indetermine"></span></td>
		{/if}
	{/foreach}
	<td class="micro">{$smarty.foreach.boucle.iteration}</td>	
	</tr>
	{/foreach}
</table>

{include file='legendeAbsences.html'}


<script type="text/javascript">
	
	$(document).ready(function(){
	
	$(".tableauAdmin tr").hover(
		function() {
			$(this).addClass('mev')
			},
		function() {
			$(this).removeClass('mev')
			}
		)
		
	})
	
</script>
