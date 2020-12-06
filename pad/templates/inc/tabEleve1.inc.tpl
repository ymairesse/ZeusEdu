{* <form name="padEleve" id="padEleve" method="POST" action="index.php" class="form-vertical" role="form"> *}
<form name="formPadEleve" id="formPadEleve">
	<input type="hidden" name="mode" value="Enregistrer">
	<input type="hidden" name="classe" value="{$classe|default:''}">
	<input type="hidden" name="matricule" value="{$matricule}">
	<input type="hidden" name="coursGrp" value="{$coursGrp|default:''}">
	<input type="hidden" name="action" value="{$action}">

	{assign var=idProprio value=$padsEleve.proprio|key}

	{* s'il n'y a pas de pad "guest", il ne faut pas montrer des onglets *}
	{if $padsEleve.guest|count > 0}
	<ul class="nav nav-tabs">
		<li class="active"><a href="#tab{$idProprio}" data-toggle="tab">{$padsEleve.proprio.$idProprio.proprio}</a></li>
		{foreach from=$padsEleve.guest key=id item=unPad}
		<li><a href="#tab{$id}" data-toggle="tab">{$unPad.proprio}
			{if $unPad.mode == 'rw'}<img src="images/padIco.png" alt=";o)">{/if}
			</a></li>
		{/foreach}
	</ul>
	{/if}


	<div class="tab-content">

		<div class="tab-pane active" id="tab{$idProprio}">
			<textarea name="texte_{$idProprio}" id="texte_{$idProprio}" rows="20" class="summernote form-control" placeholder="Frappez votre texte ici">{$padsEleve.proprio.$idProprio.texte}</textarea>
		</div>

		{foreach from=$padsEleve.guest key=id item=unPad}
		<div class="tab-pane" id="tab{$id}">
			<textarea name="texte_{$id}" id="texte_{$id}" class="summernote form-control" placeholder="Frappez votre texte ici" autofocus="true" {if $unPad.mode != 'rw'} disabled="disabled"{/if}>{$unPad.texte}</textarea>
		</div>
		{/foreach}

		<button type="button" id="btn-savePad" class="btn btn-primary btn-block">Enregistrer</button>

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

		$('#btn-savePad').click(function(){
			var formulaire = $('#formPadEleve').serialize();
			$.post('inc/savePadEleve.inc.php', {
				formulaire: formulaire
			}, function(resultat){
				bootbox.alert({
					title: 'Enregistrement',
					message: resultat + ' bloc-notes enregistré(s)'
				});
			})
		})

		$('.summernote').summernote({
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
		})

		// désactivation des pads non rw
		$('.summernote:disabled').next().find(".note-editable").attr('contenteditable',false);

	})

</script>
