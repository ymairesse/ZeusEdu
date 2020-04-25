<div id="selecteurClasse" class="noprint" style="float:left; clear:both; width:12em;">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="selectClasse" id="selectClasse">
		<option value="">Classe</option>
			{foreach from=$lesGroupes item=unGroupe}
				<option value="{$unGroupe}" {if isset($classe) && ($unGroupe == $classe)}selected{/if}>{$unGroupe}</option>
			{/foreach}
		</select>
		<input type="submit" value="OK" name="OK" id="envoi">
		<input type="hidden" name="action" value="parClasses">
	</form>
</div>

<script type="text/javascript">
{literal}
	$(document).ready (function() {
	
		$("#selectClasse").change(function(){
			if ($(this).val() != '') {
				$("#wait").css("z-index","999").show();
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
