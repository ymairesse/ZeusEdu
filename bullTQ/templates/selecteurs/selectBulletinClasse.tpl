<div id="selecteur" class="noprint" style="clear:both" role="form">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline" role="form">
		Bulletin n°
		<select name="bulletin" id="bulletin">
			{section name=bidule start=1 loop=$nbBulletins+1}
			<option value="{$smarty.section.bidule.index}" {if $smarty.section.bidule.index==$bulletin}selected{/if}>
				{$smarty.section.bidule.index}
			</option>
			{/section}
		</select>

		<select name="classe" id="classe">
			<option value="">Classe</option>
			{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}" {if isset($classe) && ($classe==$uneClasse)}selected{/if}>{$uneClasse}</option>
			{/foreach}
		</select>
		<button type="submit" class="btn btn-primary btn-xs">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="{$etape}">
	</form>
</div>
<script type="text/javascript">
	$(document).ready(function() {
		$("#formSelecteur").submit(function() {
			$("#wait").show();
			$.blockUI();
		})
	})

	$("#classe").change(function() {
		$("#formSelecteur").submit();
	})
</script>
