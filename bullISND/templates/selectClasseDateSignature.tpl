<div id="selecteur" class="selecteur noprint" style="clear:both">
	<form name="choixGroupe" action="index.php" method="POST" id="formSelecteur">
	Classe: 
	<select name="classe" id="selectClasse">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=uneClasse}
		<option value="{$uneClasse}"{if $uneClasse == $classe} selected{/if}>{$uneClasse}</option>
		{/foreach}
	</select>
		Avec signature <input type="checkbox" value=true {if $signature==true}checked=checked{/if} name="signature">
	Date: <input type="text" name="date" value="{$date}" id="datepicker" size="15">
	<select name="typeDoc">
		<option value="competences"{if $typeDoc == 'competences'} selected="selected"{/if}>Rapport de compétences</option>
		<option value="pia"{if $typeDoc == 'pia'} selected="selected"{/if}>Plan individuel d'apprentissage</option>
	</select>
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	</form>
</div>

<script type="text/javascript">

$(document).ready(function(){

	$("#datepicker").datepicker({
		format: "dd/mm/yyyy",
		clearBtn: true,
		language: "fr",
		calendarWeeks: true,
		autoclose: true,
		todayHighlight: true
		});

	$("#formSelecteur").submit(function(){
		$("#wait").show();
		$.blockUI();
		$("#corpsPage").hide();
	})
})

</script>
