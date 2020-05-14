<div class="container-fluid">

	<div class="row">

		<div class="col-md-8 col-sm-12">

			<div class="panel">

				<div class="panel-header">
					<h3>Éditez le texte de la retenue ici.</h3>
				</div>

				<form role="form" name="editeur" method="POST" action="index.php">
					<div class="row">

					<div class="col-sm-6 col-xs-12">
						  <label for="format">Format</label>
						  <select class="form-control" id="page" name="page">
							  <option value="A5"{if $format.page == 'A5'} selected{/if}>Format A5 (21cm x 14,80cm)</option>
							  <option value="A4"{if $format.page == 'A4'} selected{/if}>Format A4 (29,70cm x 21cm)</option>
						  </select>
						</div>

						<div class="col-sm-6 col-xs-12">
							  <label for="orientation">Orientation</label>
							  <select class="form-control" id="orientation" name="orientation">
								<option value="paysage"{if $format.orientation == 'paysage'} selected{/if}>Orientation "Paysage"</option>
							  	<option value="portrait"{if $format.orientation == 'portrait'} selected{/if}>Orientation "Portrait"</option>
							  </select>
						</div>


					</div>

					<input type="hidden" name="action" value="{$action}">
					<input type="hidden" name="mode" value="{$mode}">
					<input type="hidden" name="etape" value="enregistrer">

					<textarea id="texte" name="retenue" placeholder="Frappez votre texte ici" autofocus="true">{$retenue}</textarea>

					<button type="submit" class="btn btn-primary pull-right" name="submit">Enregistrer</button>
					<div class="clearfix"></div>
				</form>

			</div>  <!-- panel -->

		</div>  <!-- col-sm-... -->

		<div class="col-md-4 col-sm-12">

			<h3>Mentions possibles</h3>
			<p>
				Attention, les majusucules et les minuscules ont leur importance.
			</p>
			<ul class="list-unstyled">
				<li><strong>##ECOLE##</strong> le nom de l'école</li>
				<li><strong>##ADRESSE##</strong> l'adresse de l'école</li>
				<li><strong>##TELEPONE##</strong> le numéro de télphone de l'école</li>
				<li><strong>##COMMUNE##</strong> localité</li>
				<li><strong>##DATE##</strong> la date d'impression du billet</li>
			</ul>
			<ul class="list-unstyled">
				<li><strong>##titreFait##</strong> le type de retenue</li>
				<li><strong>##prenom##</strong> le prénom de l'élève</li>
				<li><strong>##nom##</strong> le nom de l'élève</li>
				<li><strong>##classe##</strong> la classe de l'élève</li>
				<li><strong>##duree##</strong> la durée de la retenue</li>
				<li><strong>##dateRetenue##</strong> la date de la retenue</li>
				<li><strong>##heure##</strong> l'heure de la retenue</li>
				<li><strong>##local##</strong> le local</li>
				<li><strong>##motif##</strong> le motif de la retenue</li>
				<li><strong>##materiel##</strong> le matériel à apporter</li>
				<li><strong>##travail##</strong> le travail à effectuer</li>
				<li><strong>##professeur##</strong> le nom du sanctionnateur</li>
			</ul>
			<p>
				Toutes ces mentions seront remplacées par leur valeur dans le billet de retenue.
			</p>

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

})

</script>
