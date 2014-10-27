<h3>Dates et modification des dates de retenues</h3>

<form name="dateRetenue" id="dateRetenue" action="index.php" method="POST">
	<label for="typeRetenue">Type de retenue</label>
	<select name="typeRetenue" id="typeRetenue">
		<option value="">Type de retenue</option>
		{foreach from=$listeTypes key=idType item=typeRetenue}
			<option value="{$idType}" {if $idType == $retenue->get('type')} selected="selected"{/if}>{$typeRetenue.titreFait}</option>
		{/foreach}
	</select><br>
	<label for="date">Date</label>
	<input id="datepicker" size="10" maxlength="10" type="text" name="date" value="{$retenue->get('dateRetenue')|default:''}">
			<span class="micro">Clic+Enter pour "Aujourd'hui"</span><br>
	<label for="heure">Heure</label>
	<input type="text" id="timepicker" value="{$retenue->get(heure)}" name="heure" maxlength="6" size="6"><br>
	
	<label for="duree">Durée</label>
	<select name="duree" id="duree">
		<option value=''>Durée</option>
		<option value='1'{if $retenue->get('duree') == 1} selected="selected"{/if}>1h</option>
		<option value='2'{if $retenue->get('duree') == 2} selected="selected"{/if}>2h</option>
		<option value='3'{if $retenue->get('duree') == 3} selected="selected"{/if}>3h</option>
	</select><br>
	
	<label for="local">Local</label>
	<input type="text" name="local" value="{$retenue->get('local')}" maxlength="30" size="30" id="local" class="autocomplete"><br>
		
	<label for="places">Places</label>
	<input type="text" name="places" value="{$retenue->get('places')}" maxlength="2" size="4" id="places"><br>
	
	<label>Occupation</label>
	<span style="display: inline-block; border: 1px solid black; padding:5px; height:1em; width:3em">{$retenue->get('occupation')}</span><br>
	<input type="hidden" name="occupation" id="occupation" value="{$retenue->get('occupation')}">
	
	<label>Visible</label>
	<input type="checkbox" name="affiche" value="O"{if $retenue->get('affiche') == 'O'} checked="checked"{/if}><br>
	<label>Répéter</label>
	<input type="text" name="recurrence" id="recurrence" size="2" value="0"> semaine(s)<br>
	{if $idretenue != Null}<input type="hidden" name="idretenue" value="{$idretenue}">{/if}

	<input type="submit" value="Enregistrer" name="mode" class="fauxBouton">
	<input type="reset" value="Réinitialiser" name="Submit">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="type" value="{$retenue->get('type')}">
</form>


<script type="text/javascript">
{literal}

	$.validator.addMethod(
		"dateFr",
		function(value, element) {
			return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
		},
		"date au format jj/mm/AAAA svp"
	);

	$(document).ready(function(){

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
		
		$( "#datepicker" ).datepicker({ 
			dateFormat: "dd/mm/yy",
			prevText: "Avant",
			nextText: "Après",
			monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
			dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
			firstDay: 1	
			});		
		
		$("#dateRetenue").validate({
			rules: {
				typeRetenue: {
					required: true	
					},
				duree: {
					required:true
					},
				date: {
					required: true,
					dateFr: true
					},
				local: {
					required:true
					},
				places: {
					required: true,
					min: $("#occupation").val()
					},
				recurrence: {
					required: true,
					number: true,
					range:[0,30]
				}
				},
			errorElement: "span"
			});

		})
{/literal}
</script>