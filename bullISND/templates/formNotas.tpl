<div class="container-fluid">

	<div class="row">

		<div class="col-md-9 col-sm-12">

			<h2>Notices des coordinateurs</h2>
			<p>Notice pour le bulletin <strong>{$bulletin}</strong></p>
			<p>Année d'étude <strong>{$niveau}</strong></p>
			<form method="POST" action="index.php" name="notas" class="form-vertical" role="form">
				<textarea name="notice" id="notice" class="summernote form-control">{$notice}</textarea><br>
				<input type="hidden" name="bulletin" id="noBulletin" value="{$bulletin}">
				<input type="hidden" name="niveau" id="niveau" value="{$niveau}">
				<button type="button" id="saveNotaDir" class="btn btn-primary pull-right">Enregistrer</button>
			</form>

		</div>  <!-- col-md... -->

		<div class="col-md-3 col-sm-12">

		{include file="noticeCoordinateurs.html"}

		</div>  <!-- col-md... -->

	</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){

		$('#saveNotaDir').click(function(){
			var noBulletin = $('#noBulletin').val();
			var niveau = $('#niveau').val();
			var texte = $('#notice').val();
			$.post('inc/direction/saveNotaDirection.inc.php', {
				noBulletin: noBulletin,
				niveau: niveau,
				texte: texte
			}, function(resultat){
				bootbox.alert({
					title: 'Enregistrement',
					message: resultat + " enregistrement"
				})
			})
		})


		$('#notice').summernote({
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
			  ['insert', ['link']],
			  // ['insert', ['link', 'picture', 'video']],
			  ['view', ['fullscreen', 'codeview', 'help']],
			],
			// maximumImageFileSize: 2097152,
			dialogsInBody: true,
			// callbacks: {
			// 	onImageUpload: function(files, editor, welEditable) {
			// 		for (var i = files.length - 1; i >= 0; i--) {
			// 			sendFile(files[i], this);
			// 		}
			// 	},
			// 	onMediaDelete : function(target) {
			// 		deleteFile(target[0].src);
			// 	}
			// }
		});


	})

</script>
