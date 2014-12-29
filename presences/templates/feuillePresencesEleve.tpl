{if isset($matricule)}
<h3>Absences de {$detailsEleve.$matricule.nom} {$detailsEleve.$matricule.prenom}: {$detailsEleve.$matricule.classe} le {$date}</h3>
	<form name="noterPresences" action="index.php" method="POST" id="noterPresences">
		<input type="hidden" name="educ" value="{$identite.acronyme}">
		<input type="hidden" name="date" value="{$date}">
		<input type="hidden" name="educ" value="{$identite.acronyme}">
		<input type="hidden" name="matricule" value="{$matricule}">
		<input type="hidden" name="media" value="en classe">
		<input type="hidden" name="parent" value="educ/prof">
		<input type="hidden" name="classe" value="{$classe}">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="enregistrer">
		<input type="reset" name="reset" value="Annuler" style="float:right">
		<input type="submit" name="submit" value="Enregistrer" style="float:right">
	<table class="tableauAdmin">
	<tr>
		<th>Date</th>
		{foreach from=$listePeriodes key=noPeriode item=limitesPeriode}
		<th><strong>{$noPeriode}</strong><br>{$limitesPeriode.debut} - {$limitesPeriode.fin}</th>
		{/foreach}
	</tr>
	<tr id="journee">
		<td class="ligne" style="cursor:pointer">
			{$date}<input type="checkbox" name="journee" class="journeeEntiere" title="Toute la journée">
			<input type="hidden" name="journee_matr-{$matricule}" value="{$matricule}">
		</td>
		
		{* réduction de la liste des présences à celle de l'élève dont on a le matricule*}
		{assign var=listePr value=$listePresences.$matricule}
		
		{* on passe le différentes périodes existantes en revue *}
		{foreach from=$lesPeriodes item=noPeriode}
		
		{assign var=statut value=$listePr.$noPeriode.statut|default:'indetermine'}
		{assign var=educ value=$listePr.$noPeriode.educ|default:''}
		{assign var=quand value=$listePr.$noPeriode.quand|default:''}
		{assign var=heure value=$listePr.$noPeriode.heure|default:''}
		{if ($statut!='')}
			{assign var=titre value=$educ|cat:' ['|cat:$quand|cat:' à '|cat:$heure|cat:']'}
			{else}
			{assign var=titre value='indetermine'}
		{/if}		
		<td class="{$statut} cb" title="{$titre}">
			{* s'il s'agit de la période actuelle, on présente la case à cocher (éventuellement cochée) *}
			<input type="checkbox" name="matr-{$matricule}_periode-{$noPeriode}" value="absent" class="cb"
				{if $statut=='absent'} checked="checked"{/if}
				{if in_array($statut,array('sortie','justifie','signale'))} disabled="disabled"{/if}>
		</td>
		{if ($quand!='')}
			{assign var=lastSaveDate value=$quand}
			{assign var=lastSaveTime value=$heure}
			{assign var=lastSaveEduc value=$educ}
		{/if}
		{/foreach}
	</tr>

	</table>
	{if isset($lastSaveDate)}
		<strong>Dernier enregistrement: {$lastSaveDate|default:'-'} à {$lastSaveTime|default:'-'} par {$lastSaveEduc|default:'-'}</strong>
	{/if}	
	</form>
	
{/if}

<script type="text/javascript">

$(document).ready(function(){
	
	$(".journeeEntiere").click(function(event){
		event.stopPropagation();
		var $lesTD = $(this).parent().nextAll('td');
		$lesTD.each(function(i){
			$(this).trigger('click');
			})
		})

	$(".ligne").click(function(){
		$(".journeeEntiere").trigger('click');
		})

	$(".cb").click(function(event){
		// événement géré au niveau du <td>
		event.stopPropagation();
		})

	$("#journee td").click(function(event){
		var $checkBoxes=$(this).find('input[type=checkbox]');
		var cb=$checkBoxes[0];
		cb.checked = !(cb.checked);
		if ($(this).hasClass('present')) 
			$(this).removeClass('present').addClass('absent');
			else if ($(this).hasClass('absent'))
				$(this).removeClass('absent').addClass('present');
				else if ($(this).hasClass('indetermine'))
					$(this).removeClass('indetermine').addClass('absent')			
		})
		
})

</script>
