<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		
		{if $userStatus == 'admin'}
			<label for="freeDate" title="{if $freeDate}{$date} {else}Aujourd'hui{/if}">Date</label>
			<input type="checkbox" value="1" id="freeDate" name="freeDate"{if $freeDate} checked="checked"{/if}>
			<input type="text" name="date" id="datepicker" maxlength="10" value="{$date}"{if !($freeDate)} style="display:none"{/if}>
		{/if}

		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}"{if (isset($classe)) && ($uneClasse == $classe)} selected="selected"{/if}>{$uneClasse}</option>
		{/foreach}
		</select>
		
		<input type="submit" value="OK" name="OK" id="envoi">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="showClasse">
		<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>
</div>

<script type="text/javascript">

var freeDate = false;

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectClasse").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})
	
	$("#selectClasse").change(function(){
		if ($(this).val() != '')
			$("#formSelecteur").submit();
		})

	
	$("#datepicker").datepicker({
		format: "dd/mm/yyyy",
		clearBtn: true,
		language: "fr",
		calendarWeeks: true,
		autoclose: true,
		todayHighlight: true
		});
	
	$("#freeDate").click(function(){
		freeDate = !(freeDate);
		if (freeDate) 
			$("#datepicker").show()
			else $("#datepicker").hide();
		})
	
	// si la période choisie change
	$("#selectPeriode").change(function(){
		$("#formSelecteur").submit();
		})
		
	})

</script>

