<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		Bulletin n° <select name="bulletin" id="bulletin" class="form-control input-sm">
		{section name=bidule start=1 loop=$nbBulletins+1}
			<option value="{$smarty.section.bidule.index}"
			{if $smarty.section.bidule.index == $bulletin} selected="selected"{/if}>{$smarty.section.bidule.index}
			</option>
		{/section}
	</select>

	<select name="classe" id="classe" class="form-control input-sm">
		<option value="">Classe</option>
		{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}"{if isset($classe) && ($classe == $uneClasse)} selected="selected"{/if}>{$uneClasse}</option>
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
		if (($("#classe").val() == '') || ($("#bulletin").val() == ''))
			return false;
			else {
				$("#wait").show();
				$.blockUI();
			}
		})

	$("#classe").change (function(){
		var classe = $(this).val();
		Cookies.set('classe', classe);
		$("#formSelecteur").submit();
	})

})

</script>
