<div id="selecteur" class="noprint" style="clear:both">
	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php">
	<select name="niveau" id="niveau">
		<option value="">Niveau</option>
		{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)}selected{/if}>{$unNiveau}</option>
		{/foreach}
	</select>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="show">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#niveau").change(function(){
		$("#formSelecteur").submit();
		})

	$("#formSelecteur").submit(function(){
		if ($("#niveau").val() != "") {
			$("#wait").show();
			$("#corpsPage").hide();
			}
			else return false;
	})

})

</script>
