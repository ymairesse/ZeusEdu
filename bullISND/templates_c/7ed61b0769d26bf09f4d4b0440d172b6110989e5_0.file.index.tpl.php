<?php
/* Smarty version 3.1.34-dev-7, created on 2021-02-09 18:08:39
  from '/home/yves/www/sio2/peda/widgets/flashInfo/templates/index.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_6022c197b45137_91365125',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '7ed61b0769d26bf09f4d4b0440d172b6110989e5' => 
    array (
      0 => '/home/yves/www/sio2/peda/widgets/flashInfo/templates/index.tpl',
      1 => 1589736411,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:./listeAnnonces.tpl' => 1,
    'file:./modal/modalLecture.tpl' => 1,
  ),
),false)) {
function content_6022c197b45137_91365125 (Smarty_Internal_Template $_smarty_tpl) {
?><link rel="stylesheet" href="../widgets/flashInfo/widget.css" type="text/css" media="screen, print">

<link rel="stylesheet" href="../summernote/summernote.min.css">
<?php echo '<script'; ?>
 src="../summernote/summernote.min.js"><?php echo '</script'; ?>
>
<?php echo '<script'; ?>
 src="../summernote/lang/summernote-fr-FR.min.js"><?php echo '</script'; ?>
>

<?php if ($_smarty_tpl->tpl_vars['userStatus']->value == 'admin') {?>
	<button type="button" class="btn btn-primary pull-right" id="btn-newNews">Nouvelle annonce</button>
<?php }?>
<div class="clearfix"></div>

<div id="listeAnnonces">
	<?php if ((isset($_smarty_tpl->tpl_vars['listeFlashInfos']->value)) && count($_smarty_tpl->tpl_vars['listeFlashInfos']->value) > 0) {?>

	<?php $_smarty_tpl->_subTemplateRender("file:./listeAnnonces.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

	<?php } else { ?>
		<img  src="../images/logoPageVide.png" class="img-responsive img-center">

	<?php }?>  </div>

<div id="modal"></div>

<?php $_smarty_tpl->_subTemplateRender("file:./modal/modalLecture.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready(function(){

	$('#listeAnnonces').on('click', '.btn-edit', function(){
		var id = $(this).closest('li').data('id');
		var module = "<?php echo $_smarty_tpl->tpl_vars['module']->value;?>
";
		$.post('../widgets/flashInfo/inc/createEditNews.inc.php', {
			id: id,
			module: "<?php echo $_smarty_tpl->tpl_vars['module']->value;?>
"
		},
		function(resultat){
			$('#modal').html(resultat);
			$('#modalEditNews').modal('show');
		})
	})

	$('#modal').on('click', '#btn-saveNews', function(){
		if ($('#editFlashInfo').valid()) {
			var formulaire = $("#editFlashInfo").serialize();
			$.post('../widgets/flashInfo/inc/saveFlashInfo.inc.php', {
				formulaire: formulaire
				},
				function(resultat){
					if (resultat == 1) {
						bootbox.alert({
							message: 'Annonce enregistrée'
							})
						}
						else bootbox.alert({
							message: 'L\'annonce n\'a pas été enregistrée'
						})
				$('#modalEditNews').modal('hide');
				var module = "<?php echo $_smarty_tpl->tpl_vars['module']->value;?>
";
				// raffraîchir la liste des annonces
				$.post('../widgets/flashInfo/inc/listeAnnonces.inc.php', {
					module: module
				}, function(resultat){
					$('#listeAnnonces').html(resultat);
					// var texte = $('#listeAnnonces').html();
				})
			})
		}
	})

	$('#modalEditNews').on('shown.bs.modal', function () {
	   $('#titre').focus();
	});

	$('#btn-newNews').click(function(){
		var module = "<?php echo $_smarty_tpl->tpl_vars['module']->value;?>
";
		$.post('../widgets/flashInfo/inc/createEditNews.inc.php', {
			module: module
		},
			function(resultat){
				$('#modal').html(resultat);
				$('#modalEditNews').modal('show');
			})
	})

	$('#listeAnnonces').on('click', '.btn-del', function(){
		var id = $(this).closest('li').data('id');
		var module = "<?php echo $_smarty_tpl->tpl_vars['module']->value;?>
";
		$.post('../widgets/flashInfo/inc/modalDelNews.inc.php', {
			id: id,
			module: module
		}, function(resultat){
			$('#modal').html(resultat);
			$('#modalDel').modal('show');
		})

	})

	$('#modal').on('click', '#btn-modalDelNews', function(){
		var id = $(this).data('id');
		var module = "<?php echo $_smarty_tpl->tpl_vars['module']->value;?>
"
		$.post('../widgets/flashInfo/inc/delNews.inc.php', {
			id: id,
			module: module
			}, function (resultat){
				if (resultat > 0) {
					$('li.uneNews[data-id="' + id + '"]').remove();
					bootbox.alert({
						title: 'Effacement de l\'annonce',
						message: 'Cette annonce a été effacée'
					});
				}
		})
		$('#modalDel').modal('hide');
	})

	$('#listeAnnonces').on('click', '.btn-titleNews', function(){
		var texteHTML = $(this).closest('li').data('texte');
		var titre = $(this).closest('li').data('titre');
		$('#modalLecture .texteNews').html(texteHTML);
		$('#modalLecture .modal-title').html(titre);
		$('#modalLecture').modal('show');
	})

})

<?php echo '</script'; ?>
>
<?php }
}
