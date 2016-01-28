<div id="selecteur" class="selecteur noprint" style="clear:both">

<div class="col-md-10 col-sm-8">
<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

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

<div class="col-md-2 col-sm-4">

	<form action="index.php" role="form" class="form-inline" method="POST">
		<button type="submit" class="btn btn-primary pull-right">Nouvelle réunion</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="new">
	</form>

</div>

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
