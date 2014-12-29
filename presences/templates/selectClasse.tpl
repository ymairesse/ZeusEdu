<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
			{foreach from=$listeClasses item=uneClasse}
				<option value="{$uneClasse}" {if isset($classe) && ($uneClasse == $classe)}selected{/if}>{$uneClasse}</option>
			{/foreach}
		</select>
		<input type="submit" value="OK" name="OK" id="envoi">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="showClasse">
	</form>
</div>

<script type="text/javascript">
{literal}
	$(document).ready (function() {
		
		$("#selectClasse").change(function(){
			if ($(this).val() != '') {
				$("#envoi").show();
				$("#formSelecteur").submit();
			}
		})
		
		$("#formSelecteur").submit(function(){
			if ($("#selectClasse").val() == '')
				return false;
				else {
					$.blockUI();
					$("#wait").css("z-index","999").show();
					}
		})
	})
{/literal}
</script>
