<div id="selecteur" class="noprint" style="clear:both">

	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
	<select name="niveau" id="niveau" class="form-control">
		<option value="">Niveau</option>
		{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)}selected{/if}>{$unNiveau}</option>
		{/foreach}
	</select>
xxx
	<span id="choixCours">
	{if $listeNiveaux}
		{include file="selecteurs/listeCoursComp.tpl"}
	{/if}
	</span>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="show">
	</form>
</div>

<script type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#cours").val() != "") {
			$("#wait").show();
			$("#corpsPage").hide();
			}
			else return false;
	})

	$("#niveau").change(function(){
		var niveau = $(this).val();
		$.post("inc/listeCoursComp.inc.php", {
			'niveau': niveau
			},
				function (resultat){
					$("#choixCours").html(resultat)
				}
			)
	});
})

</script>
