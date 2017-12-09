<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<form name="editFlash" id="editFlash" method="POST" action="index.php" style="clear:both" role="form" class="form-vertical">

	<div class="row">

		<div class="col-md-6 col-sm-12">

				<div class="form-group">
					<label for="titre">Titre</label>
					<input type="text" name="titre" id="titre" value="{$flashInfo.titre}" class="form-control" required>
				</div>
		</div>

		<div class="col-md-3 col-sm-6">

			<div class="form-group">
			<label for="date">Date</label>
				<input type="text" name="date" id="datepicker" value="{$flashInfo.date}" class="datepicker form-control" required>
			</div>

		</div>

		<div class="col-md-3 col-sm-6">
			<div class="form-group">
				<label for="heure">Heure</label>
				<input type="text" name="heure" id="timepicker" value="{$flashInfo.heure}" class="timepicker form-control" required>
			</div>
		</div>

	</div>

	<div class="form-group">
		<textarea name="texte" cols="90" rows="20" class="ckeditor" id="editor">{$flashInfo.texte}</textarea>
	</div>

	<div class="btn-group pull-right">
		<button type="button" class="btn btn-default" name="button" data-dismiss="modal">Annuler</button>
		<button type="button" class="btn btn-primary" name="button" id="saveNews"><i class="fa fa-save"></i> Enregistrer</button>
	</div>
	<input type="hidden" name="id" value="{$flashInfo.id|default:''}">

</form>

<script type="text/javascript">

	CKEDITOR.replace('editor');

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
