{foreach from=$listeAbsences key=matricule item=absences}
	<h3>{$detailsEleve.$matricule.nom} {$detailsEleve.$matricule.prenom}: {$detailsEleve.$matricule.classe}</h3>
	<form name="noterAbsences" action="index.php" method="POST" id="noterAbsences">
		<input type="hidden" name="date" value="{$date}">
		<input type="hidden" name="educ" value="{$identite.acronyme}">
		<input type="submit" name="submit" value="Enregistrer">
		<input type="reset" name="reset" value="Annuler">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="enregistrer">
	<table class="tableauAdmin">
	<tr>
		<th>Date</th>
		{foreach from=$listePeriodes key=noPeriode item=limitesPeriode}
		<th>{$noPeriode}<br>{$limitesPeriode.debut} - {$limitesPeriode.fin}</th>
		{/foreach}
	</tr>
	<tr>
		<td class="ligne" style="cursor:pointer">
			{$date}<input type="checkbox" name="journee" class="journeeEntiere" title="Toute la journée">
			<input type="hidden" name="journee_matr-{$matricule}" value="{$matricule}">
		</td>
		{foreach from=$listePeriodes key=noPeriode item=limitesPeriode}
		<td style="text-align: center">
			<input type="checkbox" name="matr-{$matricule}_per-{$noPeriode}" value="abs" {if isset($absences.$noPeriode)}checked="checked" title="{$absences.$noPeriode.cours} {$absences.$noPeriode.libelle} {$absences.$noPeriode.nom}"{/if}>
		</td>
		{/foreach}
	</tr>

{/foreach}

	</table>
	</form>
	
<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		$(".journeeEntiere").click(function(event){
			event.stopPropagation();
			var $checkboxes = $(this).parent().nextAll().find('input[type=checkbox]');
			$checkboxes.each(function(i){
				var toto = $checkboxes[i];
				toto.checked = !(toto.checked);
				})
			})

		$(".ligne").click(function(){
			$(".journeeEntiere").trigger('click');
			})
		})
	

	{/literal}
</script>