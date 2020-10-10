<div class="container-fluid">

	<div class="row">

		<div class="col-md-9 col-sm-12">

			<div class="panel">

				<div class="panel-header">
					<h3>Éditez le texte de la signature ici.</h3>
				</div>

				<form role="form" name="editeur" method="POST" action="index.php">

					<button type="submit" class="btn btn-primary pull-right" name="submit">Enregistrer</button>
					<div class="clearfix">
					</div>

					<textarea id="texte" name="signature" placeholder="Frappez votre texte ici" autofocus="true">{$signature}</textarea>

					<input type="hidden" name="action" value="{$action}">
					<input type="hidden" name="mode" value="{$mode}">
					<input type="hidden" name="etape" value="enregistrer">
				</form>

			</div>  <!-- panel -->

		</div>  <!-- col-sm-... -->

		<div class="col-md-3 col-sm-12">

				<div class="notice">
					<ul class="list-unstyled">
						<li>La mention <strong>##expediteur##</strong> sera automatiquement remplacée par le nom de l'utilisateur</li>
						<li>La mention <strong>##mailExpediteur##</strong> sera remplacée par son adresse de courrier électronique</li>
					</ul>
				</div>

		</div>  <!-- col-md-... -->

	</div>  <!-- row -->

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
		styleTags: [
		   'p',
			   { title: 'Blockquote', tag: 'blockquote', className: 'blockquote', value: 'blockquote' },
			   'pre', 'h1', 'h2'
		   ],
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

})


</script>
