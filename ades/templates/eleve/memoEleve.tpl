{assign var=memo value=$memoEleve.proprio}
{assign var=idProprio value=$memo|key}
{assign var=leMemo value=$memo.$idProprio}

<div class="row">

	<div class="col-md-9 col-sm-12">

		<form name="padEleve" id="padEleve" method="POST" action="index.php" class="form-vertical" role="form">
			<input type="hidden" name="matricule" id="matriculeMemo" value="{$eleve.matricule}">
			<button class="btn btn-primary pull-right hidden-print" type="button" id="saveMemo"><i class="fa fa-save"></i> Enregistrer</button>
			<hr>
			<textarea name="texte_{$idProprio}" id="texte" rows="20" class="form-control" placeholder="Frappez votre texte ici">{$leMemo.texte}</textarea>
		</form>
	</div>  <!-- col-md-... -->

	<div class="col-md-3 col-sm-12 hidden-print">

		<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="photo img-responsive thumbnail" title="{$eleve.prenom} {$eleve.nom}">

	</div>  <!-- col-md-... -->

</div>  <!-- row -->

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
		  ['fontname', ['fontname']],
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
			}
		}
	});

	$('#saveMemo').click(function(){
		var matricule = $('#matriculeMemo').val();
		var memo = $('#texte').summernote('code');
		console.log(memo);
		$.post('inc/eleves/saveMemo.inc.php', {
			matricule: matricule,
			memo: memo
			},
			function(resultat){
				bootbox.alert({
					message: resultat
				})
			})
	})

})

</script>
