<div id="selecteur" class="selecteur noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

		<select name="idRP" id="idRP" class="form-control">
			<option value="">Nouvelle date</option>
			{if isset($listeDates)}
				{foreach from=$listeDates item=uneDate}
				<option value="{$uneDate.idRP}" {if isset($idRP) && ($uneDate.idRP==$idRP)} selected="selected" {/if}>
					Réunion du {$uneDate.date}
				</option>
				{/foreach}
			{/if}
		</select>

		<button type="submit" class="btn btn-primary btn-sm">OK</button>
		{if isset($nbRv)}
			<strong class="pull-right">À ce moment, {$nbRv} RV pris</strong>
		{/if}

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

		$("#idRP").change(function() {
			if ($(this).val() != '') {
				$("#wait").show();
				$.blockUI();
				$("#formSelecteur").submit();
			}
		})

	})
</script>
