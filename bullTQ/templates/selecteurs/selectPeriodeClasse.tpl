<div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		Période
		<select name="bulletin" id="bulletin">
			<option value="">Veuillez choisir</option>
			{foreach from=$listePeriodes key=no item=nomPeriode}
			<option value="{$no}" {if $no == $bulletin}selected{/if}>{$nomPeriode}
			</option>
			{/foreach}
		</select>
		Classe
		<select name="classe" id="classe">
			<option value="">Classe</option>
			{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}" {if isset($classe) && ($classe eq $uneClasse)} selected="selected" {/if}>{$uneClasse}</option>
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
			if (($("#classe").val() == '') || ($("#bulletin").val() == '')) {
				return false
			}
			$("#wait").show();
			$.blockUI();
		})
	})

	$("#classe").change(function() {
		if ($(this).val() != '')
			$("#formSelecteur").submit();
	})
</script>
