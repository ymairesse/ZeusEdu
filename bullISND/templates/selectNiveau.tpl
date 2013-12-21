<div id="selecteur" class="noprint" style="clear:both">
	<form name="selectNiveau" id="selectNiveau" method="POST" action="index.php">
	<select name="niveau" id="niveau">
		<option value="">Niveau</option>
		{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected{/if}>{$unNiveau}</option>
		{/foreach}
	</select>

	</span>
	<input type="submit" value="OK" name="OK" id="envoi">
	<input type="hidden" name="action" value="admin">
	<input type="hidden" name="mode" value="creationCours">
	<input type="hidden" name="etape" value="show">
	</form>
</div>

<script type="text/javascript">
{literal}
$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#cours").val() != "") {
			$("#wait").show();
			$("#corpsPage").hide();
			}
			else return false;
	})

	$("#niveau").change(function(){
		if ($(this).val() != '')
			$("#selectNiveau").submit();
	});
})
{/literal}
</script>
