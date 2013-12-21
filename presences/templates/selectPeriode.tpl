<form name="choixPeriode" id="choixPeriode" method="POST" action="index.php" style="clear:both" class="noprint">
	<label for="dateDebut">Début de période</label>
		<input class="datepicker" size="10" maxlength="10" type="text" name="dateDebut" id="dateDebut"
			value="{$dateDebut}">
	<label for="dateFin">Fin de période</label>
		<input class="datepicker" size="10" maxlength="10" type="text" name="dateFin" id="dateFin"
			value="{$dateFin}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	<input type="submit" name="submit" value="OK">
</form>

<script type="text/javascript">
{literal}


	$("document").ready(function(){
		
		$( ".datepicker" ).datepicker({ 
			dateFormat: "dd/mm/yy",
			prevText: "Avant",
			nextText: "Après",
			monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
			dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
			firstDay: 1	
			});
		});
		
		$("#choixPeriode").submit(function(){
			var erreur = false;
			var dateDebut = $("#dateDebut").val();
			var jourDebut = parseInt(dateDebut.substring(0,2));
			var moisDebut = parseInt(dateDebut.substring(3,5));
			var anDebut = parseInt(dateDebut.substring(6,10));
			var dateDebut = new Date(anDebut, moisDebut, jourDebut);
			
			
			var dateFin = $("#dateFin").val();
			var jourFin = parseInt(dateFin.substring(0,2));
			var moisFin = parseInt(dateFin.substring(3,5));
			var anFin = parseInt(dateFin.substring(6,10));
			var dateFin = new Date(anFin, moisFin, jourFin);
			
			if (dateDebut > dateFin) {
					alert("Date finale avant la date initiale... Veuillez corriger.");
					return false
				}
				else {
					$("#wait").show();
					$.blockUI();
					}
			})
{/literal}
</script>
