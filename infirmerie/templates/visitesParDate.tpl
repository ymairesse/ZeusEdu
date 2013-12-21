
<form name="choixPeriode" id="choixPeriode" method="POST" action="index.php" style="clear:both">
	<label for="dateFin">Début de période</label>
		<input class="datepicker" size="10" maxlength="10" type="text" name="dateDebut" id="dateDebut"
			value="{$visite.date|date_format:'%d-%m-%Y'}"><br>
	<label for="dateFin">Fin de période</label>
		<input class="datepicker" size="10" maxlength="10" type="text" name="dateFin" id="dateFin"
			value="{$visite.date|date_format:'%d-%m-%Y'}"><br>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input style="float:right" type="submit" name="submit" value="Chercher">
	<input style="float:right" type="reset" name="Annuler" value="Annuler">	
</form>

<script type="text/javascript">
{literal}
	$("document").ready(function(){
		
		$("#modifVisite").submit(function(){
			$("#wait").show();
		});
		
		$( ".datepicker" ).datepicker({ 
			dateFormat: "dd/mm/yy",
			prevText: "Avant",
			nextText: "Après",
			monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
			dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
			firstDay: 1	
			});
		});
{/literal}
</script>
