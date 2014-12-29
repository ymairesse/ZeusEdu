<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
			{foreach from=$listeClasses item=uneClasse}
				<option value="{$uneClasse}" {if isset($classe) && ($uneClasse == $classe)}selected{/if}>{$uneClasse}</option>
			{/foreach}
		</select>
		<input type="text" name="date" id="date" class="datepicker" maxlength="10" size="10" value="{$date}" placeholder="Date">
		<input type="submit" value="OK" name="OK" id="envoi">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="showClasse">
	</form>
</div>

<script type="text/javascript">

	$(document).ready (function() {
		
	$( ".datepicker").datepicker({ 
		dateFormat: "dd/mm/yy",
		prevText: "Avant",
		nextText: "Après",
		monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
		dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
		firstDay: 1	
		});
	
	$("#selectClasse").change(function(){
		if (($(this).val() != '') && ($("#date").val() != '')) {
			$("#envoi").show();
			$("#formSelecteur").submit();
		}
		})
		
	$("#date").change(function(){
		if (($(this).val() != '') && ($("#classe").val() != ''))
			$("#envoi").show();
			$("#formSelecteur").submit();
		})
	
	$("#formSelecteur").submit(function(){
		if (($("#selectClasse").val() == '') || ($("#date").val() == ''))
			return false;
			else {
				$.blockUI();
				$("#wait").css("z-index","999").show();
				}
		})
	})

</script>
