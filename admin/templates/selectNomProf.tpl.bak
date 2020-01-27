<div class="container">
	
<div id="selecteur" class="noprint">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline" role="form">
	<select name="acronyme" id="selectUser">
		<option value="">Sélectionner un utilisateur</option>
		{foreach from=$listeProfs key=abreviation item=prof}
			<option value="{$abreviation}"{if isset($acronyme) && ($acronyme == $abreviation)} selected="selected"{/if}>
				{$prof.nom} {$prof.prenom} [{$abreviation}]
			</option>
		{/foreach}
	</select>
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	<input type="hidden" name="action" value="{$action}">
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	</form>
</div>

</div>  <!-- container -->

<script type="text/javascript">

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

</script>