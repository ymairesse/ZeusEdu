<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		Bulletin n° <select name="bulletin" id="bulletin" class="form-control input-sm">
		{section name=bidule start=1 loop=$nbBulletins+1}
			<option value="{$smarty.section.bidule.index}"
			{if $smarty.section.bidule.index == $bulletin}selected{/if}>{$smarty.section.bidule.index}
			</option>
		{/section}
	</select>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	</form>
</div>
<script type="text/javascript">
{literal}
$(document).ready (function() {
	$("#formSelecteur").submit(function(){
		$("#wait").show();
		$.blockUI();
		})

	$("#bulletin").change(function(){
		$("#formSelecteur").submit();
		})
	})
{/literal}
</script>
