<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div class="container">
	
<form name="editFlash" id="editFlash" method="POST" action="index.php" style="clear:both" role="form" class="form-vertical">

	<div class="row">
		
		<div class="col-md-5 col-sm-12">
		
			<div class="form-group">
			<label for="date">Date</label>
				<input type="text" name="date" id="datepicker" value="{$flashInfo.date}" class="datepicker form-control" required>
				<div class="help-block">La date de publication</div>
			</div>
		
		</div>
		
		<div class="col-md-5 col-sm-10">
		
			<div class="form-group">
				<label for="heure">Heure</label>
				<input type="text" name="heure" id="timepicker" value="{$flashInfo.heure}" class="datepicker form-control" required>
				<div class="help-block">L'heure de publiciation</div>
			</div>
	
		</div>
		
		<div class="col-md-2 col-sm-2">
			
			<input type="hidden" name="id" value="{$flashInfo.id}">
			<input type="hidden" name="action" value="news">
			<input type="hidden" name="mode" value="save">

			<input type="hidden" name="application" value="{$application}">
			<div class="btn-group-vertical">
				<button class="btn btn-primary" type="submit" id="submit"><span class="glyphicon glyphicon-floppy-disk"></span> Enregistrer</button>
				<a class="btn btn-default" href="index.php"><span class="glyphicon glyphicon glyphicon-remove"></span> Annuler</a>
			</div>
			
		</div>
		
		<div class="col-md-10 col-sm-10">
	
			<div class="form-group">
				<label for="titre">Titre</label>
				<input type="text" name="titre" id="titre" value="{$flashInfo.titre}" class="form-control" placeholder="Titre de la nouvelle" required>
				<div class="help-block">Le titre de cette nouvelle</div>
			</div>
		</div>
		
		<div class="col-md-2 col-sm-2">
			

			
		</div>
	
		<div class="col-md-12 col-sm-12">
			<div class="form-group">
			<textarea name="texte" cols="90" rows="20" class="ckeditor" placeholder="Écrivez votre texte ici">{$flashInfo.texte}</textarea>
			</div>
		</div>
	
	</div>  <!-- row -->
</form>

</div>  <!-- container -->

<script type="text/javascript">
	
$("document").ready(function(){
	
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

})

</script>
