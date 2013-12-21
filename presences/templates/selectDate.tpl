<div id="selecteur" class="noprint" style="clear:both">
	<form name="choixDate" action="index.php" method="POST" id="choixDate">

	Date: <input type="text" name="date" value="{$date}" id="date" size="15">
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

	$("#Date").submit(function(){
		$("#wait").show();
		$.blockUI();
		$("#corpsPage").hide();
	})

	$("#choixDate").submit(function(){
		$("#body").hide();
		})
	
	$("#date").change(function(event){
		$("#submit").click();
		})
})


{/literal}
</script>
