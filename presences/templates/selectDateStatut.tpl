<div id="selecteur" class="noprint">

	<form name="formSelecteur" action="index.php" method="POST" id="formSelecteur" role="form" class="form-inline">
	<div class="form-group">
		<label for="date">Date:</label>
		<input type="text" name="date" value="{$date}" id="date" class="datepicker form-control-inline">
	</div>
	<button type="Submit" class="btn btn-primary btn-sm" id="submit">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">

	<div id="selectJustif class="form-group"">
		<button type="button" class="btn btn-primary btn-sm" id="allStatus">Inverser la sélection <i class="fa fa-arrow-right"></i> </button>
		{foreach from=$statutsAbs key=statut item=item}

			<span style="color:{$item.color}; background:{$item.background}">
				<label class="checkbox-inline"
					title="{$item.libelle}">
					<input type="checkbox" value="{$item.justif}" name="statut[]">
					{$item.shortJustif}
				</label>
			</span>

		{/foreach}
	</div>

	</form>
</div>




<script type="text/javascript">

$(document).ready(function(){

	$("#date").datepicker({
		format: "dd/mm/yyyy",
		clearBtn: true,
		language: "fr",
		calendarWeeks: true,
		autoclose: true,
		todayHighlight: true
		});

	$("#formSelecteur").submit(function(){
		$("#wait").show();
		$.blockUI();
		$("#corpsPage").hide();
	})

	$("#choixDate").submit(function(){
		$("#body").hide();
		})

	$("#date").change(function(event){
		$("#submit").click();
		})
})

</script>
