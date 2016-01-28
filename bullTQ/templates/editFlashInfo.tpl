<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="container">
	
<form name="editFlash" id="editFlash" method="POST" action="index.php" style="clear:both" role="form" class="form-vertical">

	<div class="row">
		
		<div class="col-md-5 col-sm-4">
		
			<div class="form-group">
			<label for="date">Date</label>
				<input type="text" name="date" id="datepicker" value="{$flashInfo.date}" class="datepicker form-control" required>
			</div>
		
		</div>
		
		<div class="col-md-5 col-sm-4">
		
			<div class="form-group">
				<label for="heure">Heure</label>
				<input type="text" name="heure" id="timepicker" value="{$flashInfo.heure}" class="timepicker form-control" required>
			</div>
	
		</div>
		
		<div class="col-md-2 col-sm-4">
			
			<div class="btn-group-vertical">
				<button class="btn btn-primary type="submit" id="submit"><span class="glyphicon glyphicon-floppy-disk"></span> Enregistrer</button>
				<a type="button" href="index.php" class="btn btn-default"><span class="glyphicon glyphicon glyphicon-remove"></span>Annuler</a>
			</div>
		</div>
		
	</div>  <!-- row -->
	
	<div class="form-group">
		<label for="titre">Titre</label>
		<input type="text" name="titre" id="titre" value="{$flashInfo.titre}" class="form-control" required>
	</div>
	
	<div class="form-group">
	<textarea name="texte" cols="90" rows="20" class="ckeditor">{$flashInfo.texte}</textarea>
	</div>
	<input type="hidden" name="id" value="{$flashInfo.id}">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">

</form>

</div>  <!-- container -->

<script type="text/javascript">

	$("#datepicker").datepicker({
		format: "dd/mm/yyyy",
		clearBtn: true,
		language: "fr",
		calendarWeeks: true,
		autoclose: true,
		todayHighlight: true
		});

	$('#timepicker').timepicker({
		defaultTime: 'current',
		minuteStep: 5,
		showSeconds: false,
		showMeridian: false
		});
	
	$("#editFlash").validate({
			rules: {
				datepicker: {
					required:true
					},
				timepicker: {
					required:true
					},
				titre: {
					required: true
					}
				},
			errorElement: "span"
			}
	);

</script>
