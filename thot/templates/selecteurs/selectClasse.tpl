<div id="selecteur" class="selecteur noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="GET" action="index.php" role="form" class="form-inline">
		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
			{foreach from=$listeClasses item=uneClasse}
				<option value="{$uneClasse}" {if (isset($classe) && ($uneClasse == $classe)) || $listeClasses|count == 1}selected{/if}>{$uneClasse}</option>
			{/foreach}
		</select>
		<button type="submit" class="btn  btn-primary btn-sm">OK</button>
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="etape" value="showClasse">
		<input type="hidden" name="type" value="cours">
	</form>
xxx
</div>

<script type="text/javascript">

	$(document).ready (function() {

		$("#formSelecteur").submit(function(){
			$("#wait").show();
			$.blockUI();
		})

		$("#selectClasse").change(function(){
			if ($(this).val() != '') {
				$("#formSelecteur").submit();
			}
		})

	})

</script>
