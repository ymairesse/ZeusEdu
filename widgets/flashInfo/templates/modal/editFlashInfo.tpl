<form id="editFlashInfo">

	<div class="row">

		<div class="col-md-6 col-sm-12">

			<div class="form-group">
				<label for="titre">Titre</label>
				<input type="text" name="titre" id="titre" value="{$flashInfo.titre}" class="form-control" required>
			</div>

		</div>

		<div class="col-md-2 col-sm-4">

			<div class="form-group">
			<label for="date">Date</label>
				<input type="text" name="date" id="datepicker" value="{$flashInfo.date}" class="datepicker form-control" required>
			</div>

		</div>

		<div class="col-md-2 col-sm-4">

			<div class="form-group">
				<label for="heure">Heure</label>
				<input type="text" name="heure" id="timepicker" value="{$flashInfo.heure}" class="timepicker form-control" required>
			</div>

		</div>

		<div class="col-md-2 col-sm-4">

			<div class="checkbox">
  				<label title="Le texte de l'annonce apparaît développé ou seulement le titre">
					<input name="developpe" type="checkbox"{if $flashInfo.developpe} checked{/if} value="1">
					Développé
				</label>
			</div>

		</div>

	</div>

	<textarea name="texte" id="texte">{$flashInfo.texte}</textarea>


	<div class="btn-group pull-right">
		<button type="button" class="btn btn-default" name="button" data-dismiss="modal">Annuler</button>
		<button type="button" class="btn btn-primary" name="button" id="btn-saveNews"><i class="fa fa-save"></i> Enregistrer</button>
	</div>
	<input type="hidden" name="id" value="{$flashInfo.id|default:''}">
	<input type="hidden" name="module" value="{$module}">

	<div class="clearfix">

	</div>

</form>

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

	$("#editFlashInfo").validate({
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
