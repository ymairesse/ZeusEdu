<h3>Date de début de période</h3>
<form name="dateDebut" id="date" action="index.php" method="POST">
	<label for="date">Date</label>
	<input type="text" name="dateDebut" id="dateDebut" value="">
	<input type="submit" value="Envoyer" name="submit">
	<input type="reset" value="Annuler" name="reset">
</form>

<script type="text/javascript">
{literal}
$(document).ready(function(){
	
	$("#dateDebut" ).datepicker({ 
		dateFormat: "dd/mm/yy",
		prevText: "Avant",
		nextText: "Après",
		monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
		dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
		firstDay: 1	
		});

	})
{/literal}
</script>