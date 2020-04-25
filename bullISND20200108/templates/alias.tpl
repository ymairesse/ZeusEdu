<form name="formAlias" id="formAlias" action="index.php" method="POST">
<select name="acronyme" id="acronyme">
	{foreach from=$listeProfs key=acronyme item=unProf}
		<option value="{$acronyme}">{$unProf.nom} {$unProf.prenom}</option>
	{/foreach}
</select>
<input type="submit" name="selection" value="Sélectionner">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="etape" value="{$etape}">
</form>

<script type="text/javascript">
{literal}
	$(document).ready(function(){
	$("#acronyme").change(function(){
		$("#formAlias").submit();
	})
	
	$("#acronyme").focus();
	})

{/literal}
</script>
