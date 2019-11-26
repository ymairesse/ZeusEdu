<div class="container">
	<h3>Liste des périodes de cours</h3>
	<div class="row">
		<div class="col-md-6 col-xs-12">

			<form name="formHeures" id="formHeures" action="index.php" method="POST" role="form" class="control-vertical">
				<div class="btn-group pull-right">
					<button type="submit" class="btn btn-primary">Enregistrer</button>
					<button type="reset" class="btn btn-default">Annuler</button>
				</div>
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="{$mode}">
				<input type="hidden" name="etape" value="{$etape}">
					
				<table class="table table-condensed table-striped" id="tableHeures">
					<thead>
					<tr>
						<th>Période</th>
						<th>Début</th>
						<th>Fin</th>
						<th>Suppr</th>
						<th>Up</th>
						<th>Down</th>
					</tr>
					</thead>
					{assign var="tabIndex" value="1"}
					{assign var="nbPeriodes" value=$listePeriodes|count}
			
					{foreach from=$listePeriodes key=periode item=data}
					<tr>
						<td>{$periode}</td>
						<td><input type="text" value="{$data.debut|date_format:"%H:%M"}" name="debut_{$periode}" size="5" maxlength="5" tabIndex="{$tabIndex+1}" class="timePicker hDebut form-control input-sm"></td>
						<td><input type="text" value="{$data.fin|date_format:"%H:%M"}" name="fin_{$periode}" size="5" maxlength="5" tabIndex="{$tabIndex+2}" class="timePicker hFin form-control input-sm"</td>
						<td><input type="checkbox" value="del" name="del_{$periode}" tabIndex="{$tabIndex+3}"></td>
						
						<td{if ($periode != 1) && ($periode < $nbPeriodes)} class="updown"{/if}>
							{if $periode != 1}
								<button type="button" class="btn btn-primary up">
									<span class="glyphicon glyphicon-chevron-up"></span>
								</button>
							{/if}
						</td>
						<td>
							{if $periode < $nbPeriodes}
								<button type="button" class="btn btn-primary down">
									<span class="glyphicon glyphicon-chevron-down"></span>
								</button>
							{/if}
						</td>
					</tr>
					{assign var="tabIndex" value={$tabIndex+4}}
					{/foreach}
					
					<tr>

				</table>
			
			<a type="button" class="btn btn-primary btn-block" href="index.php?action=admin&amp;mode=heures&amp;etape=ajouterPeriode">Ajouter une période de cours</a>
			
			</form>
		</div>  <!-- col-md-... -->
	
		<div class="col-md-6 col-xs-12">
		<p class="notice">Les périodes se placeront naturellement dans l'ordre d'heure <strong>de début</strong>, après enregistrement.<br>Il vous appartient de vérifier la cohérence des heures de début et de fin de période.</p>
		</div>  <!-- col-md-.. -->
	</div> <!-- row -->
	
</div> <!-- container -->

<script type="text/javascript">

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

</script>
