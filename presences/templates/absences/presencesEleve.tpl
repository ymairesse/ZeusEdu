<div class="container-fluid">

<h3>Absences précédentes de {$detailsEleve.nom} {$detailsEleve.prenom} {$detailsEleve.classe} <span class="badge badge-danger pull-right">{$listePresences|count} ligne(s)</span></h3>

{if $listePresences|count == 0}
	<p class="avertissement">Aucune absence</p>
{else}
<div class="table-responsive" style="height:30em; overflow: auto;">

	<table class="table table-condensed">
		<thead>
			<tr>
				<th>&nbsp;</th>
				<th colspan="{$listePeriodes|count}" style="text-align:center">Périodes</th>
			</tr>
		</thead>
		<tr>
			<th>Date</th>
			{foreach from=$listePeriodes key=noPeriode item=bornes}
				<th style="text-align:center">[{$noPeriode}]<br>{$bornes.debut}</th>
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
					{if $statut != 'indetermine'}
						{assign var=laPeriode value=$listePresences.$date.$noPeriode}
						{assign var=titre value=$laPeriode.educ|cat:' ['|cat:$laPeriode.quand|cat:' à '|cat:$laPeriode.heure|cat:']'}
						{assign var=parent value=$laPeriode.parent|cat:'<br>'|cat:$laPeriode.media}
					{else}
						{assign var=parent value=Null}
						{assign var=titre value='Présences non prises'}
					{/if}
					<td class="pop"
						data-content="{$parent}"
						data-html="true"
						data-container="body"
						data-original-title="{$titre}"
						data-placement="top">
						<span style="display:block; width:100%; color:{$statutsAbs.$statut.color|default:'#e00'}; background:{$statutsAbs.$statut.background|default:'#666'}; text-align:center">
							{$statutsAbs.$statut.shortJustif|default:'!!!'}
						</span>
					</td>
				{/foreach}
			</tr>
		{/foreach}
	</table>
</div>
{include file='legendeAbsences.tpl'}

{/if}

<form name="fake" style="display:none">
	{* bidouille pour assurer le fonctionnement du sélecteur avec autocomplete *}
</form>
</div>  <!-- container -->
