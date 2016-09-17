<div id="selecteur" class="selecteur noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

		<select name="date" id="date">
			<option value="">Sélectionnez une date</option>
			{if isset($listeDates)}
				{foreach from=$listeDates item=uneDate}
				<option value="{$uneDate}" {if isset($date) && ($uneDate==$date)} selected="selected" {/if}>
					Réunion du {$uneDate}
				</option>
				{/foreach}
			{/if}
		</select>

		<button type="submit" class="btn btn-primary btn-sm">OK</button>

		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="show">

	</form>

</div>

<script type="text/javascript">
	$(document).ready(function() {

		$("#formSelecteur").submit(function(){
			if ($("#date").val() == '')
				return false;
		})

		$("#date").change(function() {
			if ($(this).val() != '') {
				$("#wait").show();
				$.blockUI();
				$("#formSelecteur").submit();
			}
		})

	})
</script>
