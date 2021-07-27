<div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">

		<div class="form-group">
			<label for="bulletin">Bulletin</label>
			<select name="bulletin" id="bulletin" class="form-control">
				{foreach from=$listePeriodes key=no item=nomPeriode}
					<option value="{$no}" {if $no eq $bulletin}selected{/if}>
						{$nomPeriode}
					</option>
				{/foreach}
			</select>
		</div>

		<div class="form-group">
			<select name="classe" id="classe" class="form-control">
				<option value="">Classe</option>
				{foreach from=$listeClasses item=uneClasse}
					<option value="{$uneClasse}" {if isset($classe) && ($classe eq $uneClasse)}selected{/if}>
						{$uneClasse}
					</option>
				{/foreach}
			</select>
		</div>

		<button type="submit" class="btn btn-primary">OK</button>

		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="{$etape}">
	</form>
</div>

<script type="text/javascript">

	$(document).ready(function() {
		$("#formSelecteur").submit(function() {
			if ($("#classe").val() == '') {
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
