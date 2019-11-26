<div id="selecteur" class="noprint">

	<form name="formSelecteur" action="index.php" method="POST" id="formSelecteur" role="form" class="form-inline">
	<div class="input-group">
		<label for="date">Date:</label>
		<input type="text" name="date" value="{$date}" id="date" class="datepicker form-control-inline">
	</div>
	<button type="Submit" class="btn btn-primary btn-sm" id="submit">OK</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	
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
