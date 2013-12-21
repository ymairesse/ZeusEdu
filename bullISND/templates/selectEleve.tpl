<div id="selecteur" class="noprint" style="clear:both">
	<form name="formSelecteur" id="formSelecteur" action="index.php" method="POST">
	{if $listeElevesClasse}
		{include file="listeEleves.tpl"}
	{/if}
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="showEleve">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {

	if ($("#eleve_ID").val() > 0)
		$("#resultat").show();

	$("#formSelecteur").submit(function(){
		$("#wait").show();
		$("#corpsPage").hide();
	})

	$("#eleve_ID").change(function(){
		if ($(this).val() > 0)
			$("#formSelecteur").submit()
			else $("#envoi").hide();
		})

})
{/literal}
</script>
