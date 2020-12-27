<div class="container-fluid">

		<input type="hidden" name="id" id="id" value="{$notification.id}">
		<input type="hidden" name="edition" id="edition" value="{if $notification.id != ''}true{/if}">

		<input type="hidden" name="destinataire" id="destinataire" value="{$destinataire|default:''}">

		<input type="hidden" name="leType" id="leType" value="{$notification.type|default:''}">

		<div class="panel panel-default" id="editorPanel">

			<div class="panel-body">

				<div class="row">
					<p id="dateEnvoi" class="hidden"></p>
					<div class="col-xs-8">
						<input type="text" maxlength="80" name="objet" id="objet" placeholder="Objet de votre annonce" class="form-control" value="{$notification.objet|default:''}">
					</div>
					<div class="col-xs-4">
						<div class="btn-group btn-group-justified">
							<div class="btn-group">
								<button type="button" class="btn btn-primary" id="submitNotif" disabled><i class="fa fa-paper-plane"></i> Envoyer</button>
							</div>
							<div class="btn-group">
								<button type="button" class="btn btn-default" id="reset"><i class="fa fa-refresh"></i> Annuler</button>
							</div>
						</div>
					</div>
				</div>

				<div class="form-group col-md-2 col-xs-4">
					<label for="dateDebut">Date début</label>
					<input type="text" name="dateDebut" id="dateDebut" placeholder="Début" class="datepicker form-control" value="{$notification.dateDebut}" title="La notification apparaît à partir de cette date">
				</div>

				<div class="form-group col-md-2 col-xs-4">
					<label for="dateFin">Date fin</label>
					<input type="text" name="dateFin" id="dateFin" placeholder="Fin" class="datepicker form-control" value="{$notification.dateFin}" title="La notification disparaît à partir de cette date">
					<div class="help-block">Déf:+1mois</div>
				</div>
				<div class="form-group col-md-2 col-xs-4">
					<label for="mail" title="Un mail d'avertissement est envoyé">Mail<br>élève</label>
					<input type="checkbox" name="mail" id="mail" class="form-control-inline cb" value="1"
					{if isset($notification.mail) && $notification.mail==1 } checked='checked' {/if}
					disabled>
					{* disabled pour l'envoi de mail à toute l'école ou à tout un niveau afin d'éviter les overquotas d'envois *}
					{* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
				</div>

				<div class="form-group col-md-2 col-xs-4">
					<label for="accuse" title="Un accusé de lecture est demandé">Accusé<br>lecture</label>
					<input type="checkbox" name="accuse" id="accuse" class="form-control-inline cb" value="1"
					{if isset($notification.accuse) && $notification.accuse==1 } checked='checked' {/if}
					disabled>
					{* disabled pour toute l'école car ingérable *}
					{* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
				</div>

				<div class="form-group col-md-2 col-xs-4">
					<label for="parents" title="Notification par mail aux parents">Mail<br>Parents</label>
					<input type="checkbox" name="parent" id="parent" class="form-control-inline cb" value="1"
					{if (isset($notification.parents)) && ($notification.parents==1 )} checked{/if}
					disabled>
					 {* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
				</div>

				<div class="form-group col-md-2 col-xs-4">
					<label for="freeze" title="Notification persistante, reste disponible pour vous après la date de fin">Persis-<br>tant</label>
					<input type="checkbox" name="freeze" id="freeze" class="form-control-inline" value="1"
					{if (isset($notification.freeze)) && ($notification.freeze==1 )} checked{/if}>
					{* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
				</div>

				{* <div class="form-group col-md-2 col-xs-4">
					<label for="titu" title="Notification par mail au titulaire">Mail<br>Titu.</label>
					<input type="checkbox" name="titu" id="titu" class="form-control-inline cb" value="1"
					{if (isset($notification.titu)) && ($notification.titu==1 )} checked{/if}
					 {if isset($edition)} disabled{/if}>
					 {* disabled en cas d'édition (on ne change pas les règles en cours de route) *}
				{* }</div> *}

				<div class="clearfix"></div>


				<textarea id="texte"
					name="texte"
					class="form-control"
					placeholder="Frappez votre texte ici"
					required
					autofocus="true">{$notification.texte|default:''}</textarea>

				{*------------------------------------------------------------------------------*}
				{include file="../../../widgets/fileTree/templates/treeview4PJ.tpl"}
				{*------------------------------------------------------------------------------*}

			</div>
			<!-- panel-body -->

			<div class="panel-footer">
				{if $notification.type == 'niveau' || $notification.type == 'ecole'}
		            <p>L'envoi de mails est désactivé pour les notifications à tout un niveau ou à toute l'école</p>
		        {/if}
		        {if $notification.type == 'ecole'}
		            <p>La demande d'accusé de lecture est désactivée pour les notifications à l'ensemble de l'école</p>
		        {/if}
		        {if isset($edition)}
		            Certaines options ne sont pas modifiables
		        {/if}
			</div>

		</div>
		<!-- panel -->

	</div>
	<!-- container -->

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

	$(document).ready(function() {

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

		$("#dateDebut").datepicker({
				format: "dd/mm/yyyy",
				clearBtn: true,
				language: "fr",
				calendarWeeks: true,
				autoclose: true,
				todayHighlight: true
			})
			.off('focus')
			.click(function() {
				$(this).datepicker('show');
			});

		$("#dateFin").datepicker({
			format: "dd/mm/yyyy",
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true
		});

		$("#notification").validate({
			// pour ne pas ignorer le "textarea" qui sera caché
			ignore: [],
			rules: {
				objet: {
					required: true
					},
				dateDebut: {
					required: true,
					minlength: 10
					},
				dateFin: {
					required: true,
					minlength: 10
					},
				texte: {
					required: true,
					minlength: 20
					}
				},
			messages: {
				'objet': 'Veuillez indiquer un objet pour votre annonce',
				'texte': 'Un texte significatif svp',
				},
			errorPlacement: function(error, element) {
				if (element.hasClass('cb')){
					error.insertBefore(element.closest('ul'));
					}
					else {
						error.insertAfter(element);
					}
			}
		});

	})

</script>
