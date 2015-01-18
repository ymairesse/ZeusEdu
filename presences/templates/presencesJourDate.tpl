<table class="tableauPresences">
{if (!(isset($ajout)))}
	<tr>
		<th style="background-color:#F9C333; width:6em">Jour entier</th>
		<th>Date</th>
	{foreach from=$listePeriodes key=noPeriode item=bornes}
		<th>{$noPeriode}<br>{$bornes.debut} - {$bornes.fin}</th>
	{/foreach}
	</tr>
{/if}

{if isset($listeDates)}
	{foreach $listeDates as $uneDate}
	<tr>
		<td style="background-color:#F9C333; width:6em;">
		<select style="width: 3em" name="statut_global" class="statut_all">
			<option value="indetermine" selected="selected">NP (présences non prises)</option>
			<option value="present">PRES (Présent)</option>
			<option value="absent">ABS (Absent)</option>
			<option value="signale">SIGN (Absence signalée)</option>
			<!-- <option value="justifie">JUST (Absence justifiée)</option> -->
			<option value="sortie">SORT (Sortie autorisée)</option>
		</select>
		</td>
		<td style="width:6em"><input type="hidden" name="dates[]" value="{$uneDate}" class="date">{$uneDate|truncate:5:''}</td>

		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{assign var=statut value=$listePresences.$uneDate.$noPeriode.statut|default:'indetermine'}
			<td class="{$statut}" style="width:6em">
			<select style="width: 4em" name="periode-{$noPeriode}_date-{$uneDate}" class="statut">
				<option value="indetermine"{if $statut == 'indetermine'} selected="selected"{/if}>NP (présences non prises)</option>
				<option value="present"{if $statut == 'present'} selected="selected"{/if}>PRES (Présent)</option>
				<option value="absent"{if $statut == 'absent'} selected="selected"{/if}>ABS (Absent)</option>
				<option value="signale"{if $statut == 'signale'} selected="selected"{/if}>SIGN (Absence signalée)</option>
				<!-- <option value="justifie"{if $statut == 'justifie'} selected="selected"{/if}>JUST (Absence justifiée)</option> -->
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
		<td style="background-color:#F9C333; width:6em;">
		<select style="width: 3em" name="statut_global" class="statut_all">
			<option value="indetermine" selected="selected">NP (présences non prises)</option>
			<option value="present">PRES (Présent)</option>
			<option value="absent">ABS (Absent)</option>
			<option value="signale">SIGN (Absence signalée)</option>
			<!-- <option value="justifie">JUST (Absence justifiée)</option> -->
			<option value="sortie">SORT (Sortie autorisée)</option>
		</select>
		</td>
		<td><input type="hidden" name="dates[]" value="{$date}" class="date">{$date|truncate:5:''}</td>

		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{assign var=statut value=$listePresences.$matricule.$noPeriode.statut|default:'indetermine'}
			<td class="{$statut}" style="width:6em">
			<select style="width: 4em" name="periode-{$noPeriode}_date-{$date}" class="statut">
				<option value="indetermine"{if $statut == 'indetermine'} selected="selected"{/if}>NP (présences non prises)</option>
				<option value="present"{if $statut == 'present'} selected="selected"{/if}>PRES (Présent)</option>
				<option value="absent"{if $statut == 'absent'} selected="selected"{/if}>ABS (Absent)</option>
				<option value="signale"{if $statut == 'signale'} selected="selected"{/if}>SIGN (Absence signalée)</option>
				<!-- <option value="justifie"{if $statut == 'justifie'} selected="selected"{/if}>JUST (Absence justifiée)</option> -->
				<option value="sortie"{if $statut == 'sortie'} selected="selected"{/if}>SORT (Sortie autorisée)</option>
			</select>
			<input type="hidden" name="modif-{$noPeriode}_date-{$date}" id="modif-{$noPeriode}_date-{$date}" value="non" class="modif">
			<img src="images/modif.png" alt="*" style="display:none" id="star_{$noPeriode}_date-{$date}">
			</td>
		{/foreach}
	</tr>
	
{/if}


</table>

