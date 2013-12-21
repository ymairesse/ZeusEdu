<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<form name="editFlash" id="editFlash" method="POST" action="index.php" style="clear:both">
	<a href="index.php" style="float:right"><img src="../images/cancel.png" alt="Annuler" title="Annuler"></a>
	<label for="date">Date</label><input type="text" name="date" id="datepicker" value="{$flashInfo.date}" size="12">
	<label for="heure">Heure</label><input type="text" name="heure" id="timepicker" value="{$flashInfo.heure}" size="10">
	<br>
	<label for="titre">Titre</label> <input type="text" name="titre" id="titre" value="{$flashInfo.titre}" size="60">
	<textarea name="texte" cols="90" rows="20" class="ckeditor">{$flashInfo.texte}</textarea>
	<input type="hidden" name="id" value="{$flashInfo.id}">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="submit" id="submit" value="Enregistrer">
</form>

<script type="text/javascript">
{literal}
	$( "#datepicker").datepicker({ 
		dateFormat: "dd/mm/yy",
		prevText: "Avant",
		nextText: "Après",
		monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
		dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
		firstDay: 1	
		});
	$('#timepicker').timepicker({
		hourText: 'Heures',
		minuteText: 'Minutes',
		amPmText: ['AM', 'PM'],
		timeSeparator: ':',
		nowButtonText: 'Maintenant',
		showNowButton: true,
		closeButtonText: 'OK',
		showCloseButton: true,
		deselectButtonText: 'Désélectionner',
		showDeselectButton: true,
		hours: {starts: 8, ends: 17},
		showDeselectButton: false
		});
{/literal}
</script>
