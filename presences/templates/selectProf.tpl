
<div id="selecteurProf" class="noprint" style="float:left; clear:both;">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		<select name="selectProf" id="selectProf">
		<option value="">Professeur</option>
			{foreach from=$listeProfs item=unProf}
				<option value="{$unProf.acronyme}" {if $unProf.acronyme == $acronyme}selected{/if}>{$unProf.nom} {$unProf.prenom}</option>
			{/foreach}
		</select>
		<input type="submit" value="OK" name="OK" id="envoi">
		<input type="hidden" name="action" value="parProf">
	</form>
</div>

<script type="text/javascript">
{literal}
	$(document).ready (function() {
	
		$("#selectProf").change(function(){
			if ($(this).val() != '') {
				$("#formSelecteur").submit();
			}
		})
		
		$("#formSelecteur").submit(function(){
			if ($("#selectProf").val() == "")
				return false;
				else {
					$.blockUI();
					$("#wait").show();
					}
		})
	})
{/literal}
</script>
