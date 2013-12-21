<div id="selecteurNomProf" class="noprint" style="float:left">
	<form name="selecteur" id="formSelecteurNomProf" method="POST" action="index.php">
	<select name="acronyme" id="acronyme">
		<option value="">Sélectionner un nom</option>
		{foreach from=$listeProfs key=abreviation item=unProf}
			<option value="{$abreviation}"{if isset($acronyme) && ($abreviation eq $acronyme)} selected{/if}>
				{$unProf.nom} {$unProf.prenom} [{$abreviation}]</option>
		{/foreach}
	</select>
	<input type="hidden" name="action" value="parNom">
	<input type="submit" value="OK" name="OK" id="envoi">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready(function(){

	$("#formSelecteurNomProf").submit(function(){
		if($("#acronyme").val() == '')
			return false;
			else $("#wait").css("z-index","999").show();
	})
	
	$("#acronyme").change(function(){
		$("#formSelecteurNomProf").submit();
		})
})
{/literal}
</script>