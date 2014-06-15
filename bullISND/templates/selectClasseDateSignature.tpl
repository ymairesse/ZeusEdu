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
	<select name="typeDoc">
		<option value="competences"{if $typeDoc == 'competences'} selected="selected"{/if}>Rapport de compétences</option>
		<option value="pia"{if $typeDoc == 'pia'} selected="selected"{/if}>Plan individuel d'apprentissage</option>
	</select>
	<input type="Submit" name="OK" value="OK" id="submit">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
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
