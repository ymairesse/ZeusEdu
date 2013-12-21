<div id="selecteurClasse" class="noprint" style="float:left; clear:both; width:16em;">
	<form name="selecteur" id="formSelecteurClasse" method="POST" action="index.php">
		<select name="groupe" id="groupe">
			<option value="">Titulaire de</option>
			{foreach from=$lesGroupes item=unGroupe}
			<option value="{$unGroupe}" {if $unGroupe == $groupe}selected{/if}>{$unGroupe}</option>
			{/foreach}
		</select>
		<input type="submit" value="OK" name="OK" id="envoi">
		<input type="hidden" name="action" value="titulaire">
	</form>
</div>

<script type="text/javascript">
{literal}
	$(document).ready (function() {
	
		$("#groupe").change(function(){
			if ($(this).val() != '') {
				$("#wait").css("z-index","999").show();
				$("#formSelecteurClasse").submit();
				}
				else return false;
		})
		
		$("#formSelecteurClasse").submit(function(){
			if ($("#groupe").val() == "")
				return false;
				else $("#wait").css("z-index","999").show();
		})
	})
{/literal}
</script>
