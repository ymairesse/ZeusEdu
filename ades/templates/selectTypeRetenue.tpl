<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="typeRetenue" id="selectType">
		<option value="">Type de retenue</option>
		{foreach from=$listeTypes key=ceType item=unType}
			<option value="{$ceType}"{if isset($typeRetenue) && ($typeRetenue == $ceType)} selected="selected"{/if}>{$unType.titreFait}</option>
		{/foreach}
		</select>
		
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	{if isset($etape)}<input type="hidden" name="etape" value="{$etape}">{/if}
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {
	
	$("#selectType").change(function(){
		if ($(this).val() != '') {
			$("#formSelecteur").submit();
		}
		})

	$("#formSelecteur").submit(function(){
		if ($("#selectType").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})

})
{/literal}
</script>