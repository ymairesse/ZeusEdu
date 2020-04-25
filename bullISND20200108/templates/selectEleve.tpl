<div id="selecteur" class="noprint" style="clear:both">
	<form name="formSelecteur" id="formSelecteur" action="index.php" method="POST">
	{if isset($listeEleves)}
		{include file="listeEleves.tpl"}
	{/if}
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="showEleve">
	<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	if ($("#selectEleve").val() > 0)
		$("#resultat").show();

	$("#formSelecteur").submit(function(){
		$("#wait").show();
		$("#corpsPage").hide();
	})

	$("#selectEleve").change(function(){
		if ($(this).val() > 0)
			$("#formSelecteur").submit()
			else $("#envoi").hide();
		})

})

</script>
