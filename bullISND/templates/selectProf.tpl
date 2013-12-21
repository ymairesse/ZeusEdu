<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
	<select name="acronyme" id="selectUser">
		<option value="">Sélectionner un utilisateur</option>
		{foreach from=$listeProfs key=abreviation item=prof}
			<option value="{$abreviation}"{if isset($acronyme) && ($acronyme == $abreviation)} selected{/if}>{$prof.nom} {$prof.prenom} [{$abreviation}]</option>
		{/foreach}
	</select>
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	<input type="hidden" name="action" value="{$action}">
	<input type="submit" value="OK" name="OK" id="envoi">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready(function(){

	$("#selectUser").change(function(){
		if ($("#selectUser").val() != "")
			$("#formSelecteur").submit();
		})
	
	$("#formSelecteur").submit(function(){
		if ($("#selectUser").val() == "")
			return false;
			else $("#wait").show();
		})

})
{/literal}
</script>