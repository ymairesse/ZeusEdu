<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
			{foreach from=$lesGroupes item=unGroupe}
				<option value="{$unGroupe}" {if isset($classe) && ($unGroupe == $classe)}selected{/if}>{$unGroupe}</option>
			{/foreach}
		</select>
		<input type="submit" value="OK" name="OK" id="envoi">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="showEleve">
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
