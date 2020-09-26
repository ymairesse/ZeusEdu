<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">

		<select name="degre" id="degre" class="form-control input-sm">
			<option value="">Degré d'étude</option>
			{foreach $listeDegres item=leDegre}
			<option value="{$leDegre}"{if $degre == $leDegre} selected{/if}>
			{$leDegre}
			</option>
		{/section}
	</select>

	<select name="classe" id="classe" class="form-control input-sm">
		<option value="">Classe</option>
		{include file='selecteur/listeClasses.tpl'}
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
		$("#formSelecteur").submit();
	})

})

</script>
