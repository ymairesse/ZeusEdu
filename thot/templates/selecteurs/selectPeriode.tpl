<div id="selecteur">
	
	<form name="choixPeriode" id="formSelecteur" method="POST" action="index.php" class="noprint form-inline">
		
		<div class="form-group">
			<label for="date">Début de période</label>
			<input id="dateDebut" maxlength="10" type="text" name="dateDebut" value="{$dateDebut|default:''}" class="form-control-inline datepicker">
		</div>
		
		<div class="form-group">
			<label for="date">Fin de période</label>
			<input id="dateFin" maxlength="10" type="text" name="dateFin" value="{$dateFin|default:''}" class="form-control-inline">
		</div>
		
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="{$etape}">
		<button type="submit" class="btn btn-primary">OK</button>
	</form>
</div>


<script type="text/javascript">

$("document").ready(function(){
		
	$( "#dateDebut").datepicker({ 
		format: "dd/mm/yyyy",
		clearBtn: true,
		language: "fr",
		calendarWeeks: true,
		autoclose: true,
		todayHighlight: true
		})
		.off('focus')
		.click(function () {
			  $(this).datepicker('show');
		  });

	$( "#dateFin").datepicker({
		format: "dd/mm/yyyy",
		clearBtn: true,
		language: "fr",
		calendarWeeks: true,
		autoclose: true,
		todayHighlight: true
		});
		
	
	$("#formSelecteur").submit(function(){
	
		var dateDebut = $("#dateDebut").val();
		var dateFin = $("#dateFin").val();
		
		if ((dateDebut != '') && (dateFin != '')) {
			var jourDebut = parseInt(dateDebut.substring(0,2));
			var moisDebut = parseInt(dateDebut.substring(3,5));
			var anDebut = parseInt(dateDebut.substring(6,10));
			var beginDate = new Date(anDebut, moisDebut, jourDebut);
			
			var jourFin = parseInt(dateFin.substring(0,2));
			var moisFin = parseInt(dateFin.substring(3,5));
			var anFin = parseInt(dateFin.substring(6,10));
			var endDate = new Date(anFin, moisFin, jourFin);
			if (beginDate > endDate) {
				$("#dateFin").val(dateDebut);
				$("#dateDebut").val(dateFin);
				}
			$("#wait").show();
			$.blockUI();
			}
			else return false;
			})

})

</script>
