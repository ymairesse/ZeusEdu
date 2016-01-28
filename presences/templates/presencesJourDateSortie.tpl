{if (!(isset($ajout)))}

<table class="table table-condensed" id="presencesJour">

	<thead>
	<tr style="cursor:pointer">
		<th class="signale">Jour entier</th>
		<th style="width:6em">Date</th>
	{foreach from=$listePeriodes key=noPeriode item=bornes}
		<th class="listePeriodes{if $noPeriode == $periodeActuelle} signale{/if}">{$noPeriode}<br>{$bornes.debut} - {$bornes.fin}</th>
	{/foreach}
	</tr>
	</thead>

{/if}

{if isset($listeDates)}
	{foreach $listeDates as $uneDate}
	<tr>
		<td class="signale" style="width:6em">
		<select style="width: 5em" name="statut_global" class="statut_all">
			<option value="indetermine" selected="selected">NP (présences non prises)</option>
			<option value="sortie">SORT (Sortie autorisée)</option>
		</select>
		</td>

		<td><input type="hidden" name="dates[]" value="{$uneDate}" class="date">{$uneDate|truncate:5:''}</td>

		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{assign var=statut value=$listePresences.$uneDate.$noPeriode.statut|default:'indetermine'}
			<td class="{$statut}">

			<select name="periode-{$noPeriode}_date-{$uneDate}" class="statut" style="width:5em">
				{if $statut == 'indetermine'}
				<option value="indetermine" selected="selected">NP (présences non prises)</option>
				{/if}
				{if $statut == 'present'}
				<option value="present"selected="selected">PRES (Présent)</option>
				{/if}
				{if $statut == 'absent'}
				<option value="absent" selected="selected">ABS (Absent)</option>
				{/if}
				{if $statut == 'signale'}
				<option value="signale" selected="selected">SIGN (Absence signalée)</option>
				{/if}
				{if $statut == 'justifie'}
				<option value="justifie" selected="selected">JUST (Absence justifiée)</option>
				{/if}
				{if $statut == 'ecarte'}
				<option value="ecarte" selected="selected">ÉCART (Écarté du cours)</option>
				{/if}
				{if $statut == 'stage'}
				<option value="stage" selected="selected">STAGE</option>
				{/if}
				{if $statut == 'suivi'}
				<option value="suivi" selected="selected">SUIVI (PMS/CAS)</option>
				{/if}
				<option value="sortie"{if $statut == 'sortie'} selected="selected"{/if}>SORT (Sortie autorisée)</option>
				{if $statut == 'renvoi'}
				<option value="renvoi" selected="selected">RENV (Renvoyé)</option>
				{/if}
			</select>
			<input type="hidden" name="modif-{$noPeriode}_date-{$uneDate}" id="modif-{$noPeriode}_date-{$uneDate}" value="non" class="modif">
			<img src="images/modif.png" alt="*" style="display:none" id="star_{$noPeriode}_date-{$uneDate}">
			</td>
		{/foreach}
	</tr>
	{/foreach}

	{else}

	<tr>
		<td class="signale" style="width:6em">
		<select style="width: 5em" name="statut_global" class="statut_all">
			<option value="indetermine" selected="selected">NP (présences non prises)</option>
			<!-- <option value="present">PRES (Présent)</option>
			<option value="absent">ABS (Absent)</option>
			<option value="signale">SIGN (Absence signalée)</option>
			<!-- <option value="justifie">JUST (Absence justifiée)</option> -->
			<option value="sortie">SORT (Sortie autorisée)</option>
			<!--  <option value="renvoi">RENV (Renvoyé)</option> -->
		</select>
		</td>
		<td><input type="hidden" name="dates[]" value="{$date}" class="date">{$date|truncate:5:''}</td>

		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{assign var=statut value=$listePresences.$matricule.$noPeriode.statut|default:'indetermine'}
			<td class="{$statut}" style="width:6em">
			<select style="width: 5em" name="periode-{$noPeriode}_date-{$date}" class="statut">
				{if $statut == 'indetermine'}
				<option value="indetermine" selected="selected">NP (présences non prises)</option>
				{/if}
				{if $statut == 'present'}
				<option value="present"selected="selected">PRES (Présent)</option>
				{/if}
				{if $statut == 'absent'}
				<option value="absent" selected="selected">ABS (Absent)</option>
				{/if}
				{if $statut == 'signale'}
				<option value="signale" selected="selected">SIGN (Absence signalée)</option>
				{/if}
				{if $statut == 'justifie'}
				<option value="justifie" selected="selected">JUST (Absence justifiée)</option>
				{/if}
				{if $statut == 'suivi'}
				<option value="suivi" selected="selected">SUIVI (PMS/CAS)</option> -->
				{/if}
				<option value="sortie"{if $statut == 'sortie'} selected="selected"{/if}>SORT (Sortie autorisée)</option>
				
				{if $statut == 'renvoi'}
				<option value="renvoi"selected="selected">RENV (Renvoyé)</option>
				{/if}
			</select>
			<input type="hidden" name="modif-{$noPeriode}_date-{$date}" id="modif-{$noPeriode}_date-{$date}" value="non" class="modif">
			<img src="images/modif.png" alt="*" style="display:none" id="star_{$noPeriode}_date-{$date}">
			</td>
		{/foreach}
	</tr>

{/if}

{if (!(isset($ajout)))}
</table>
{/if}

<script type="text/javascript">

$(document).ready(function(){

	$('#presencesJour').on('click','.listePeriodes',function(){
		var rang = parseInt($(this).index());
		$("#presencesJour").find('tr').not($(this)).find('select').eq(rang-1).val('sortie').trigger('change');
		})

	})

</script>
