<div id="selecteur" class="selecteur noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

		{if $userStatus == 'admin'}
		<select name="type" id="type">
			<option value="eleve"{if isset($type) && ($type == 'eleve')} selected{/if}>Par élève</option>
			<option value="prof"{if isset($type) && ($type == 'prof')} selected{/if}>Par enseignant</option>
		</select>
		{/if}

		<select name="date" id="date">
			<option value="">Date de réunion de parents</option>
			{foreach from=$listeDates item=uneDate}
				<option value="{$uneDate}"{if isset($date) && ($uneDate == $date)} selected="selected"{/if}>
					{$uneDate}
				</option>
			{/foreach}
		</select>

		<button type="submit" class="btn btn-primary btn-sm">OK</button>

		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode|default:'voir'}">
		<input type="hidden" name="etape" value="show">

	</form>

</div>

<script type="text/javascript">

$(document).ready(function(){

	$("#date").change(function(){
		$("#wait").show();
		$.blockUI();
		$("#formSelecteur").submit();
		})

})

</script>
