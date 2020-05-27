<?php /* Smarty version Smarty-3.1.13, created on 2020-05-27 15:42:10
         compiled from "./templates/editSignature.tpl" */ ?>
<?php /*%%SmartyHeaderCode:19741944045ece6d3c13be21-89342905%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '99f1f8edb455e326b251d25581efb2bc3db0015c' => 
    array (
      0 => './templates/editSignature.tpl',
      1 => 1590586926,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '19741944045ece6d3c13be21-89342905',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5ece6d3c13fd15_59469927',
  'variables' => 
  array (
    'action' => 0,
    'signature' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5ece6d3c13fd15_59469927')) {function content_5ece6d3c13fd15_59469927($_smarty_tpl) {?><div class="container-fluid">

	<div class="row">

		<div class="col-md-9 col-sm-12">

			<div class="panel">

				<div class="panel-header">
					<h3>Éditez le texte de la signature ici.</h3>
				</div>

				<form role="form" name="editeur" method="POST" action="index.php">
					<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
					<input type="hidden" name="mode" value="enregistrer">
					<textarea id="texte" name="signature" class="summernote" placeholder="Frappez votre texte ici" autofocus="true"><?php echo $_smarty_tpl->tpl_vars['signature']->value;?>
</textarea>

					<button type="submit" class="btn btn-primary pull-right" name="submit">Enregistrer</button>

					<div class="clearfix"></div>
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
<?php }} ?>