<div id="selecteurClasse" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
			{foreach from=$listeGroupes item=unGroupe}
				<option value="{$unGroupe}" {if $unGroupe == $classe}selected{/if}>{$unGroupe}</option>
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
	
		$("#selectClasse").change(function(){
			if ($(this).val() != '') {
				$("#formSelecteur").submit();
			}
		})
		
		$("#formSelecteur").submit(function(){
			if ($("#selectClasse").val() == '')
				return false;
				else {
					$("#wait").css("z-index","999").show();
					$.blockUI();
					}
		})
	})
{/literal}
</script>
