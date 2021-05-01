<div id="selecteur" class="noprint" style="clear:both">
	
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline" role="form">
		<select name="classe" id="selectClasse" class="form-control">
			<option value="">Classe</option>
			{foreach from=$listeClasses item=uneClasse}
			<option value="{$uneClasse}" {if (isset($classe)) && ($uneClasse eq $classe)} selected="selected" {/if}>{$uneClasse}</option>
			{/foreach}
		</select>

		<button type="submit" class="btn btn-primary">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="showClasse">
		<input type="hidden" name="onglet" class="onglet" value="{$onglet|default:0}">
	</form>
</div>

<script type="text/javascript">
	$(document).ready(function() {

		$("#formSelecteur").submit(function() {
			if ($("#selectClasse").val() != '') {
				$("#wait").show();
				$.blockUI();
			} else return false;
		})

		$("#selectClasse").change(function() {
			if ($(this).val() != '')
				$("#formSelecteur").submit();
		})

	})
</script>
