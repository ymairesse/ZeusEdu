<div class="table-responsive">

    {if $nbJoursAvecAbsence > 0}
        <p style="color:{$statutsAbs.absent.color}; background: {$statutsAbs.absent.background}">Nombre de jours avec absence non signalée <strong>{$nbJoursAvecAbsence}</strong></p>
    {/if}
    {if $nbRetards > 0}
        <p style="color:{$statutsAbs.retard.color}; background: {$statutsAbs.retard.background}">Nombre de retards <strong>{$nbRetards}</strong></p>
    {/if}

    {if $listePresences|@count > 0}
    <div style="max-height:35em; overflow: auto">

    <table class="table table-condensed">
		<thead>
			<tr>
				<th>&nbsp;</th>
				<th colspan="{$listePeriodesCours|count}" style="text-align:center">Périodes</th>
			</tr>
		</thead>
		<tr>
			<th>Date</th>
			{foreach from=$listePeriodesCours key=noPeriode item=bornes}
				<th><strong>{$noPeriode}</strong><br>{$bornes.debut} - {$bornes.fin}</th>
			{/foreach}
		</tr>
		{foreach from=$listePresences key=date item=presence}
			<tr>
				<td>{$date}</td>
				{foreach from=$listePeriodesCours key=noPeriode item=bornes}
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

    {else}
        <p class="avertissement">Aucune absence ni retard</p>
    {/if}
</div>
