{* page servant à la prise en compte rapide des justifications d'absences *}
{* seule les mentions figurant dans la 'listeSpeed' sont autorisées       *}

{if (!(isset($ajout)))}

<table class="table table-condensed" id="presencesJour">
	<thead>
	<tr style="cursor:pointer">
		<th class="signale">Jour entier <button type="button" class="btn btn-primary btn-xs nextJust" name="button"><i class="fa fa-arrow-down"></i></button></th>
		<th style="width:6em">Date</th>
		{foreach from=$listePeriodes key=noPeriode item=bornes}
			<th class="listePeriodes{if $noPeriode == $periodeActuelle} signale{/if}">
			{$noPeriode}<br>{$bornes.debut} - {$bornes.fin}
			<button type="button" class="btn btn-primary btn-xs nextJust" name="button"><i class="fa fa-arrow-down"></i></button>
			</th>
		{/foreach}
	</tr>
	</thead>

{/if}

{if isset($listeDates)}
	{foreach $listeDates as $uneDate}
	<tr>
		<td class="signale" style="width:6em">
		<select style="width: 5em" name="statut_global" class="statut_all">
			{foreach from=listeSpeed key=justif item=justification}
				<option value="{$justif}"
				 		justification-color="{$justification.color}" justification-background="{$justification.background}"
						selected="selected">{$justification.shortJustif} {$justification.libelle}</option>
			{/foreach}
		</select>
		</td>

		<td><input type="hidden" name="dates[]" value="{$uneDate}" class="date">{$uneDate|truncate:5:''}</td>

		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{assign var=statut value=$listePresences.$uneDate.$noPeriode.statut|default:'indetermine'}
			{assign var=justification value=$listeJustifications.$statut}
			<td style="width:6em; color:{$justification.color}; background:{$justification.background}">
				<select name="periode-{$noPeriode}_date-{$uneDate}" class="statut" style="width:5em">
					{foreach from=$listeJustifications key=just item=justification}
						<option value="{$just}"{if $statut == $just} selected="selected"{/if}
								data-color="{$justification.color}" data-background="{$justification.background}">
							{$justification.shortJustif} ({$justification.libelle})
						</option>
					{/foreach}
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
				{foreach from=listeSpeed key=justif item=justification}
					<option value="{$justif}"
					 		justification-color="{$justification.color}" justification-background="{$justification.background}"
							selected="selected">{$justification.shortJustif} {$justification.libelle}</option>
				{/foreach}
			</select>
		</td>
		<td><input type="hidden" name="dates[]" value="{$date}" class="date">{$date|truncate:5:''}</td>

		{foreach from=$listePeriodes key=noPeriode item=bornes}
			{assign var=statut value=$listePresences.$matricule.$noPeriode.statut|default:'indetermine'}
			<td class="{$statut}" style="width:6em">
				<select style="width: 5em" name="statut_global" class="statut_all">
					{foreach from=$listeJustifications key=just item=justification}
						<option value="{$just}"
								data-color="{$justification.color}" data-background="{$justification.background}">
							{$justification.shortJustif} ({$justification.libelle})
						</option>
					{/foreach}
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
