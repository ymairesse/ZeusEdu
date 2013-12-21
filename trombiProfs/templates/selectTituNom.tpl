<div id="selecteurNomProf" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteurNomProf" method="POST" action="index.php">
	Titulaire de 
	<select name="groupe" id="groupe">
		<option value=''>Classe</option>
		{foreach from=$lesGroupes item=classe}
			<option value='{$classe}' {if isset($groupe) && ($groupe == $classe)} selected="selected"{/if}>{$classe}</option>
		{/foreach}
	</select>
	
	<select name="acronyme" id="acronyme">
		<option value="">Sélectionner un nom</option>
		{foreach from=$listeProfs key=abreviation item=unProf}
			<option value="{$abreviation}"{if isset($acronyme) && ($abreviation eq $acronyme)} selected{/if}>
				{$unProf.nom} {$unProf.prenom} [{$abreviation}]</option>
		{/foreach}
	</select>

	<input type="hidden" name="action" value="classeTitu">
	<input type="submit" value="OK" name="OK" id="envoi">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready(function(){

	$("#formSelecteurNomProf").submit(function(){
		if (($("#acronyme").val() == '') && ($("#groupe").val() == ''))
			return false;
			else $("#wait").css("z-index","999").show();
	})
	
	$("#acronyme").change(function(){
		$("#groupe").val('');
		$("#formSelecteurNomProf").submit();
		})

	$("#groupe").change(function(){
		$("#acronyme").val('');
		$("#formSelecteurNomProf").submit();
		})	
		
})
{/literal}
</script>