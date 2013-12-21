<div id="selecteur" class="noprint" style="clear:both">
	<form name="choixGroupe" action="index.php" method="POST" id="choixGroupeDate">
	Classe: 
	<select name="classe" id="selectClasse">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=uneClasse}
		<option value="{$uneClasse}"{if $uneClasse == $classe} selected{/if}>{$uneClasse}</option>
		{/foreach}
	</select>
		Avec signature <input type="checkbox" value=true {if $signature==true}checked=checked{/if} name="signature">
	Date: <input type="text" name="date" value="{$date}" id="date" size="15">
	<input type="Submit" name="OK" value="OK" id="submit">
	<input type="hidden" name="action" value="admin">
	<input type="hidden" name="mode" value="rapportCompetences">
	<input type="hidden" name="etape" value="print">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready(function(){
	$("#date").datepicker({ 
		closeText: 'Fermer',
		prevText: '&#x3c;Préc',
		nextText: 'Suiv&#x3e;',
		currentText: 'Courant',
		monthNames: ['Janvier','Février','Mars','Avril','Mai','Juin',
		'Juillet','Août','Septembre','Octobre','Novembre','Décembre'],
		monthNamesShort: ['Jan','Fév','Mar','Avr','Mai','Jun',
		'Jul','Aoû','Sep','Oct','Nov','Déc'],
		dayNames: ['Dimanche','Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi'],
		dayNamesShort: ['Dim','Lun','Mar','Mer','Jeu','Ven','Sam'],
		dayNamesMin: ['Di','Lu','Ma','Me','Je','Ve','Sa'],
		weekHeader: 'Sm',
		dateFormat: 'dd/mm/yy',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''
		});

	$("#choixGroupeDate").submit(function(){
		$("#wait").show();
		$.blockUI();
		$("#corpsPage").hide();
	})
})
{/literal}
</script>
