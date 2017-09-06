<script type="text/javascript">

$(document).ready(function(){

	$("#formSelecteur").submit(function(){
		$("#wait").show();
	})

	$("#selectUser").change(function(){
		$("#formSelecteur").submit();
		})
})

</script>

<div id="selecteur" class="noprint" style="clear:both">
<fieldset style="clear:both"><legend>Modification d'un utilisateur/trice</legend>
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
	<select name="acronyme" id="selectUser"  size="13">
		<option value="">Sélectionner un utilisateur</option>
		{foreach from=$listeProfs key=acronyme item=prof}
			<option value="{$acronyme}">{$prof.nom} {$prof.prenom} [{$prof.acronyme}]</option>
		{/foreach}
	</select>
	<input type="hidden" name="action" value="gestUsers">
	<input type="hidden" name="mode" value="modifUser">
	<input type="submit" value="OK" name="OK" id="envoi">
	</form>
</fieldset>
</div>
