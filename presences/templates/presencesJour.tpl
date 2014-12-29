
{foreach from=$listePeriodes key=noPeriode item=bornes}
	{assign var=statut value=$presences.$matricule.$noPeriode.statut|default:'indetermine'}
	<td class="{$statut}">
	<select style="width: 6em" name="statut_{$noPeriode}" id="statut_{$noPeriode}" class="statut">
		<option value="indetermine"{if $statut == 'indetermine'} selected="selected"{/if}>NP (présences non prises)</option>
		<option value="present"{if $statut == 'present'} selected="selected"{/if}>PRES (Présent)</option>
		<option value="absent"{if $statut == 'absent'} selected="selected"{/if}>ABS (Absent)</option>
		<option value="signale"{if $statut == 'signale'} selected="selected"{/if}>SIGN (Absence signalée)</option>
		<option value="justifie"{if $statut == 'justifie'} selected="selected"{/if}>JUST (Absence justifiée)</option>
		<option value="sortie"{if $statut == 'sortie'} selected="selected"{/if}>SORT (Sortie autorisée)</option>
	</select>
	<input type="hidden" name="modif_{$noPeriode}" value='non' id="modif_{$noPeriode}">
	<img src="images/modif.png" alt="*" style="display:none" id="star_{$noPeriode}">
	</td>
{/foreach}
