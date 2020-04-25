<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		Bulletin n° <select name="bulletin" id="bulletin">
		{foreach from=$listePeriodes key=no item=nomPeriode}
			<option value="{$no}" 
			{if $no == $bulletin}selected{/if}>{$nomPeriode}
			</option>
		{/foreach}
	</select>
	
	<select name="classe" id="classe">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}"{if isset($classe) && ($classe == $uneClasse)} selected="selected"{/if}>{$uneClasse}</option>
		{/foreach}
	</select>
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	</form>
</div>
<script type="text/javascript">
{literal}
$(document).ready (function() {
	$("#formSelecteur").submit(function(){
		if ($("#classe").val() == '') {
			return false
		}
		$("#wait").show();
		$.blockUI();
		})
	})
	
	$("#classe").change (function(){
		if ($(this).val() != '') 
			$("#formSelecteur").submit();
	})
{/literal}
</script>
