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
		<input type="submit" name="submit" value="Enregistrer" style="float:right">
	<table class="tableauAdmin">
	<tr>
		<th>Journée entière</th>
		{foreach from=$listePeriodes key=noPeriode item=limitesPeriode}
		<th><strong>{$noPeriode}</strong><br>{$limitesPeriode.debut} - {$limitesPeriode.fin}</th>
		{/foreach}
	</tr>
	<tr id="journee">
		<td class="journeeEntiere" style="cursor:pointer">
			{$date}
		</td>
		
		{* réduction de la liste des présences à celle de l'élève dont on a le matricule*}
		{assign var=listePr value=$listePresences.$matricule}
		
		{* on passe le différentes périodes existantes en revue *}
		{foreach from=$lesPeriodes item=noPeriode}
			{assign var=statut value=$listePr.$noPeriode.statut|default:'indetermine'}

			<td class="{$statut} cb">
				{* s'il s'agit de la période actuelle, on présente la case à cocher (éventuellement cochée) *}
				<input type="checkbox" name="matr-{$matricule}_periode-{$noPeriode}" value="absent" class="cb"
					{if $statut=='absent'} checked="checked"{/if}
					{if in_array($statut,array('sortie','justifie','signale'))} disabled="disabled"{/if}>
			</td>
		{/foreach}
	</tr>

	</table>
	</form>
	
	<table class="tableauPresences" style="padding-top:2em">
	<tr>
	<th>Période</th>
	{foreach from=$listePeriodes key=noPeriode item=periode}
		<th>{$noPeriode}</th>
	{/foreach}
	</tr>
	<tr>
	<th>Heures</th>
	{foreach from=$listePeriodes key=noPeriode item=periode}
		<td style="text-align:center">{$periode.debut} à {$periode.fin}</td>
	{/foreach}
	</tr>
</table>
{/if}

<script type="text/javascript">

$(document).ready(function(){
	
	$(".journeeEntiere").click(function(event){
		event.stopPropagation();
		var $lesTD = $(this).parent().find('td input')
		$lesTD.each(function(i){
			$(this).trigger('click');
			})
		})

	$("#journee td").click(function(event){
		var cb=$(this).find('input[type=checkbox]')[0];
		if ($(this).hasClass('present')) 
			$(this).removeClass('present').addClass('absent');
			else if ($(this).hasClass('absent'))
				$(this).removeClass('absent').addClass('present');
				else if ($(this).hasClass('indetermine'))
					$(this).removeClass('indetermine').addClass('absent');
		cb.checked = $(this).hasClass('absent');
		})
		
})

</script>
