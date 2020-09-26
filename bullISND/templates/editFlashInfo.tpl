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
				<button class="btn btn-primary" type="submit" id="submit">
					<span class="glyphicon glyphicon-floppy-disk"></span> Enregistrer
				</button>
				<a type="button" href="index.php" class="btn btn-default"><span class="glyphicon glyphicon glyphicon-remove"></span>Annuler</a>
			</div>
		</div>

	</div>  <!-- row -->

	<div class="form-group">
		<label for="titre">Titre</label>
		<input type="text" name="titre" id="titre" value="{$flashInfo.titre}" class="form-control" required>
	</div>

	<div class="form-group">
	<textarea name="texte" id="texte">{$flashInfo.texte}</textarea>
	</div>
	<input type="hidden" name="id" value="{$flashInfo.id}">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">

</form>

</div>  <!-- container -->

<script type="text/javascript">

function sendFile(file, el) {
	var form_data = new FormData();
	form_data.append('file', file);
	$.ajax({
		data: form_data,
		type: "POST",
		url: 'editor-upload.php',
		cache: false,
		contentType: false,
		processData: false,
		success: function(url) {
			$(el).summernote('editor.insertImage', url);
		}
	});
}

function deleteFile(src) {
	console.log(src);
	$.ajax({
		data: { src : src },
		type: "POST",
		url: 'inc/deleteImage.inc.php',
		cache: false,
		success: function(resultat) {
			console.log(resultat);
			}
	} );
	}

	$(document).ready(function(){

		$('#texte').summernote({
			lang: 'fr-FR', // default: 'en-US'
			height: null, // set editor height
			minHeight: 150, // set minimum height of editor
			focus: true, // set focus to editable area after initializing summernote
			toolbar: [
			  ['style', ['style']],
			  ['font', ['bold', 'underline', 'clear']],
			  ['font', ['strikethrough', 'superscript', 'subscript']],
			  ['color', ['color']],
			  ['para', ['ul', 'ol', 'paragraph']],
			  ['table', ['table']],
			  ['insert', ['link', 'picture', 'video']],
			  ['view', ['fullscreen', 'codeview', 'help']],
			],
			maximumImageFileSize: 2097152,
			dialogsInBody: true,
			callbacks: {
				onImageUpload: function(files, editor, welEditable) {
					for (var i = files.length - 1; i >= 0; i--) {
						sendFile(files[i], this);
					}
				},
				onMediaDelete : function(target) {
					deleteFile(target[0].src);
				}
			}
		});

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
