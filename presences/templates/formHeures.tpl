<h3>Liste des périodes de cours</h3>

<form name="formHeures" id="formHeures" action="index.php" method="POST">
	<input type="submit" value="Enregistrer" name="submit">
	<input type="reset" value="Annuler" name="reset">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
			<div style="float:right; width:40%">
	<p>Les périodes se placeront naturellement dans l'ordre d'heure <strong>de début</strong>, après enregistrement.<br>Il vous appartient de vérifier la cohérence des heures de début et de fin de période.</p>
</div>
	<table class="tableauAdmin" id="tableHeures" style="width:50%">
		<tr>
			<th>Période</th>
			<th>Début</th>
			<th>Fin</th>
			<th>Suppr</th>
			<th>Up/down</th>
		</tr>
		{assign var="tabIndex" value="1"}
		{assign var="nbPeriodes" value=$listePeriodes|count}

		{foreach from=$listePeriodes key=periode item=data}
		<tr>
			<td>{$periode}</td>
			<td><input type="text" value="{$data.debut|date_format:"%H:%M"}" name="debut_{$periode}" size="5" maxlength="5" tabIndex="{$tabIndex+1}" class="timePicker hDebut"></td>
			<td><input type="text" value="{$data.fin|date_format:"%H:%M"}" name="fin_{$periode}" size="5" maxlength="5" tabIndex="{$tabIndex+2}" class="timePicker hFin"</td>
			<td><input type="checkbox" value="del" name="del_{$periode}" tabIndex="{$tabIndex+3}"></td>
			
			<td{if ($periode != 1) && ($periode < $nbPeriodes)} class="updown"{/if}>
				{if $periode != 1}<a href="javascript:void(0)" class="up">^</a>{/if}
				&nbsp;
				{if $periode < $nbPeriodes}<a href="javascript:void(0)" class="down">v</a>{/if}
			</td>
		</tr>
		{assign var="tabIndex" value={$tabIndex+4}}
		{/foreach}
		
		<tr class="ajouter" title="Ajouter une heure de cours">
			<td colspan="5" style="text-align: center"><a href="index.php?action=admin&amp;mode=heures&amp;etape=ajouterPeriode">Ajouter une période de cours</a></td>
		</tr> 
	</table>

</form>


<script type="text/javascript">
	{literal}

	$(".ajouter").css('cursor','pointer');

	$(document).ready(function(){
	
		// validateur pour tous les éléments de class "timePicker"
		jQuery.validator.addClassRules('timePicker', {
			time: true
		});
		jQuery.validator.addClassRules('number', {
			number: true,
			required: true
		});
		// nouvelle méthode pour les objets de type HH:mm
		jQuery.validator.addMethod("time", function(value, element) {
				var isValid = /^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/.test(value);
				return this.optional(element) || isValid;
			}, "Entre 00:00 et 23:59 svp"
		);
		jQuery.validator.addMethod("number", function(value, element) {
				var isValid = /^([0-9]?[0-9])$/.test(value);
				return this.optional(element) || isValid;
			}, "Nombre 0-99"
		);

		$("input").tabEnter();
		
		$('#formHeures').validate();
		
		$("#formHeures input").change(function(){
			$(".ajouter td").hide();
			})
		$("#formHeures input:reset").click(function(){
			$(".ajouter td").show();
			})

		$(".timePicker").timepicker({
			hourText: 'Heures',
			minuteText: 'Minutes',
			amPmText: ['AM', 'PM'],
			timeSeparator: ':',
			closeButtonText: 'OK',
			showCloseButton: true
			})


		$(".up").click(function(){
			var actuel = $(this).closest("tr");
			var prev = actuel.prev();
			var debutActuel = actuel.find(".hDebut").val();
			var finActuel = actuel.find(".hFin").val();
			var delActuel = actuel.find("input:checkbox").attr("checked");
			actuel.find("input:checkbox").attr("checked", false);
			
			var debutPrev = prev.find(".hDebut").val();
			var finPrev = prev.find(".hFin").val();
			var delPrev = prev.find("input:checkbox").attr("checked");
			prev.find("input:checkbox").attr("checked", false);
			
			actuel.find(".hDebut").val(debutPrev);
			actuel.find(".hFin").val(finPrev);
			actuel.find("input:checkbox").attr("checked", delPrev);
			
			prev.find(".hDebut").val(debutActuel);
			prev.find(".hFin").val(finActuel);
			prev.find("input:checkbox").attr("checked", delActuel);
			
			})
		
		$(".down").click(function(){
			var actuel = $(this).closest("tr");
			var next = actuel.next();
			var debutActuel = actuel.find(".hDebut").val();
			var finActuel = actuel.find(".hFin").val();
			var delActuel = actuel.find("input:checkbox").attr("checked");
			actuel.find("input:checkbox").attr("checked", false);

			var debutNext = next.find(".hDebut").val();
			var finNext = next.find(".hFin").val();
			var delNext = next.find("input:checkbox").attr("checked");
			next.find("input:checkbox").attr("checked", false);
			
			actuel.find(".hDebut").val(debutNext);
			actuel.find(".hFin").val(finNext);
			actuel.find("input:checkbox").attr("checked",delNext);
			
			next.find(".hDebut").val(debutActuel);
			next.find(".hFin").val(finActuel);
			next.find("input:checkbox").attr("checked",delActuel);
			
			
			})

		})
	{/literal}
</script>