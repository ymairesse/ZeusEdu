<table class="tableauPresences">
{if (!(isset($ajout)))}
	<tr>
		<th style="width:6em">&nbsp;</th>
		<th>Date</th>
	{foreach from=$listePeriodes key=noPeriode item=bornes}
		<th  style="cursor:pointer" class="listePeriodes {if $noPeriode == $periodeActuelle} fauxBouton{/if}"><span class="noPeriode">{$noPeriode}</span><br>{$bornes.debut} - {$bornes.fin}</th>
	{/foreach}
	</tr>
{/if}

{if isset($listeDates)}
	{foreach $listeDates as $uneDate}
	<tr>
		<td style="width:6em;">&nbsp;</td>
		<td style="width:6em"><input type="hidden" name="dates[]" value="{$uneDate}" class="date">{$uneDate|truncate:5:''}</td>

		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{assign var=statut value=$listePresences.$uneDate.$noPeriode.statut|default:'indetermine'}
			<td class="{$statut}" style="width:6em">
			<select style="width: 4em" name="periode-{$noPeriode}_date-{$uneDate}" id="select-{$noPeriode}_date-{$uneDate}" class="statut">
				{if $statut == 'indetermine'} 
					<option value="indetermine"selected="selected">NP (présences non prises)</option>
				{/if}
				{if $statut == 'present'}
					<option value="present" selected="selected">PRES (Présent)</option>
				{/if}
				{if $statut == 'absent'} 
					<option value="absent" selected="selected">ABS (Absent)</option>
				{/if}
				{if $statut == 'signale'}
					<option value="signale" selected="selected">SIGN (Absence signalée)</option>
				{/if}
				{if $statut == 'justifie'}
				<!-- <option value="justifie" selected="selected">JUST (Absence justifiée)</option> -->
				{/if}
				<option value="sortie"{if $statut == 'sortie'} selected="selected"{/if}>SORT (Sortie autorisée)</option>
			</select>
			<input type="hidden" name="modif-{$noPeriode}_date-{$uneDate}" id="modif-{$noPeriode}_date-{$uneDate}" value="non" class="modif">
			<img src="images/modif.png" alt="*" style="display:none" id="star_{$noPeriode}_date-{$uneDate}">
			</td>
		{/foreach}
	</tr>
	{/foreach}
	
	{else}
	
	<tr>
		<td style="width:6em;">&nbsp;</td>
		<td style="width:6em"><input type="hidden" name="dates[]" value="{$date}" class="date">{$date|truncate:5:''}</td>

		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{assign var=statut value=$listePresences.$matricule.$noPeriode.statut|default:'indetermine'}
			<td class="{$statut}" style="width:6em;">
			<select style="width: 4em" name="periode-{$noPeriode}_date-{$date}" id="sel-{$noPeriode}_date-{$date}" class="statut">
				{if $statut == 'indetermine'} 
					<option value="indetermine"selected="selected">NP (présences non prises)</option>
				{/if}
				{if $statut == 'present'}
					<option value="present" selected="selected">PRES (Présent)</option>
				{/if}
				{if $statut == 'absent'} 
					<option value="absent" selected="selected">ABS (Absent)</option>
				{/if}
				{if $statut == 'signale'}
					<option value="signale" selected="selected">SIGN (Absence signalée)</option>
				{/if}
				{if $statut == 'justifie'}
				<!-- <option value="justifie" selected="selected">JUST (Absence justifiée)</option> -->
				{/if}
				<option value="sortie"{if $statut == 'sortie'} selected="selected"{/if}>SORT (Sortie autorisée)</option>
			</select>
			<input type="hidden" name="modif-{$noPeriode}_date-{$date}" id="modif-{$noPeriode}_date-{$date}" value="non" class="modif">
			<img src="images/modif.png" alt="*" style="display:none" id="star_{$noPeriode}_date-{$date}">
			</td>
		{/foreach}
	</tr>
	
{/if}

</table>

