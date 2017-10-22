<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		Bulletin n° <select name="bulletin" id="bulletin" class="form-control input-sm">
		{section name=bidule start=0 loop=$nbBulletins+1}
			<option value="{$smarty.section.bidule.index}"
			{if $smarty.section.bidule.index == $bulletin}selected{/if}>{$smarty.section.bidule.index}
			</option>
		{/section}
	</select>

	<select name="classe" id="classe" class="form-control input-sm">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=laClasse}
			<option value="{$laClasse}"{if isset($classe) && ($laClasse == $classe)}selected{/if}>{$laClasse}</option>
		{/foreach}
	</select>
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	</form>
</div>
<script type="text/javascript">

$(document).ready (function() {
	$("#formSelecteur").submit(function(){
		$.blockUI();
		$("#wait").show();
		$("#corpsPage").hide();
		})
	})

	$("#classe").change (function(){
		$("#formSelecteur").submit();
	})

</script>
