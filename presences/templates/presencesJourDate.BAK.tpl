{if (!(isset($ajout)))}

<table class="table table-condensed">
	<thead>
	<tr style="cursor:pointer">
		<th class="signale">Jour entier</th>
		<th style="width:4em">Date</th>
		{foreach from=$listePeriodes key=noPeriode item=bornes}
			<th class="listePeriodes{if $noPeriode == $periodeActuelle} signale{/if}">
			{$noPeriode}<br>{$bornes.debut} - {$bornes.fin}
			</th>
		{/foreach}
	</tr>
	</thead>

{/if}

{if isset($listeDates)}
	{* on présente toutes les justifications déjà passées pour l'élève *}
	{foreach $listeDates as $uneDate}
	<tr>
		<td style="width:6em">
		{* signalement pour la journée complète *}
		<select style="width: 5em" name="statut_global" class="statut_all" data-heure='jour'>
			{foreach from=$listeJustifications key=justif item=justification}
				<option value="{$justif}"
						data-color="{$justification.color}"
						data-background="{$justification.background}">
					{$justification.shortJustif} ({$justification.libelle})
				</option>
			{/foreach}
		</select>
		</td>

		<td><input type="hidden" name="dates[]" value="{$uneDate}" class="date">{$uneDate|truncate:5:''}</td>

		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{assign var=statut value=$listePresences.$uneDate.$noPeriode.statut|default:'indetermine'}
			{assign var=justification value=$listeJustifications.$statut}
			<td style="width:6em; color:{$justification.color}; background:{$justification.background}">

			<select name="periode-{$noPeriode}_date-{$uneDate}" class="statut" style="width:5em" data-heure="{$noPeriode}" data-date="{$uneDate}">
				{foreach from=$listeJustifications key=justif item=justification}
					<option value="{$justif}"
							{if $statut == $justif} selected="selected"{/if}
							data-color="{$justification.color}"
							data-background="{$justification.background}">
						{$justification.shortJustif} ({$justification.libelle})
					</option>
				{/foreach}
			</select>

			<input type="hidden" name="modif-{$noPeriode}_date-{$uneDate}" id="modif-{$noPeriode}_date-{$uneDate}" value="non" class="modif">
			<img src="images/modif.png" alt="*" class="hidden star" id="star_{$noPeriode}_date-{$uneDate}">
			</td>
		{/foreach}
	</tr>
	{/foreach}

	{else}

	<tr>
		<td class="signale" style="width:6em">
		<select style="width: 5em" name="statut_global" class="statut_all" data-heure='jour'>
			{if $mode == 'speed'}
				{foreach from=$listeSpeed key=justif item=justification}
					<option value="{$justif}"
							data-color="{$justification.color}"
							data-background="{$justification.background}">
						{$justification.shortJustif} {$justification.libelle}
					</option>
				{/foreach}
			{else}
				{foreach from=$listeJustifications key=justif item=justification}
					<option value="{$justif}"
							data-color="{$justification.color}"
							data-background="{$justification.background}">
						{$justification.shortJustif} ({$justification.libelle})
					</option>
				{/foreach}
			{/if}
		</select>
		</td>
		<td>
			<input type="hidden" name="dates[]" value="{$date}" class="date">{$date|truncate:5:''}
		</td>

		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{assign var=statut value=$listePresences.$matricule.$noPeriode.statut|default:'indetermine'}
			{assign var=justification value=$listeJustifications.$statut|default:'indetermine'}
			<td style="width:6em; color:{$justification.color}; background:{$justification.background}">
			<select style="width: 5em" name="periode-{$noPeriode}_date-{$date}" class="statut" data-heure="{$noPeriode}" data-date="{$date}">
				{if $mode == 'speed'}
					{foreach from=$listeSpeed key=justif item=justification}
						<option value="{$justif}"
								data-color="{$justification.color}"
								data-background="{$justification.background}"
								{if $justif == $statut} selected="selected"{/if}>
							{$justification.shortJustif} {$justification.libelle}
						</option>
					{/foreach}
				{else}
					{foreach from=$listeJustifications key=justif item=justification}
						<option
							value="{$justif}"
							{if $justif == $statut} selected="selected"{/if}
							data-color="{$justification.color}"
							data-background="{$justification.background}">
							{$justification.shortJustif} ({$justification.libelle})
						</option>
					{/foreach}
				{/if}
			</select>

			<input type="hidden" name="modif-{$noPeriode}_date-{$date}" id="modif-{$noPeriode}_date-{$date}" value="non" class="modif">
			<img src="images/modif.png" alt="*" class="hidden star" id="star_{$noPeriode}_date-{$date}">
			</td>
		{/foreach}
	</tr>

{/if}

{if (!(isset($ajout)))}
</table>
{/if}
