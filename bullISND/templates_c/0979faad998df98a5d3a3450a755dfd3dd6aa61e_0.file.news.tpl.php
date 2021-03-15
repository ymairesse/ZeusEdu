<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-07 12:33:36
  from '/home/yves/www/sio2/peda/bullISND/templates/news/news.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_6044ba10a91658_86238097',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '0979faad998df98a5d3a3450a755dfd3dd6aa61e' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/news/news.tpl',
      1 => 1615116718,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:news/situationsVides.tpl' => 1,
    'file:news/noSitDelibe.tpl' => 1,
    'file:news/noCommentDelibe.tpl' => 1,
    'file:news/modalDelNews.tpl' => 1,
  ),
),false)) {
function content_6044ba10a91658_86238097 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container-fluid">

	<div class="row">

		<?php if (in_array($_smarty_tpl->tpl_vars['PERIODEENCOURS']->value,$_smarty_tpl->tpl_vars['PERIODESDELIBES']->value)) {?>

			<div class="col-md-5 col-sm-12">
				<?php $_smarty_tpl->_subTemplateRender('file:news/situationsVides.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
				<?php $_smarty_tpl->_subTemplateRender('file:news/noSitDelibe.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
				<?php $_smarty_tpl->_subTemplateRender('file:news/noCommentDelibe.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
			</div>

			<div class="col-md-7 col-sm-12">
				<?php $_smarty_tpl->_assignInScope('module', "bullISND");?>
				<?php $_smarty_tpl->_subTemplateRender(((string)$_smarty_tpl->tpl_vars['INSTALL_DIR']->value)."/widgets/flashInfo/templates/index.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, true);
?>
			</div>

		<?php } else { ?>

			<div class="col-md-12 col-sm-12">
				<?php $_smarty_tpl->_assignInScope('module', "bullISND");?>
				<?php $_smarty_tpl->_subTemplateRender(((string)$_smarty_tpl->tpl_vars['INSTALL_DIR']->value)."/widgets/flashInfo/templates/index.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, true);
?>
			</div>

		<?php }?>

	</div>  <!-- row -->

</div>  <!-- container -->


<?php if ($_smarty_tpl->tpl_vars['userStatus']->value == 'admin') {?>
	<?php $_smarty_tpl->_subTemplateRender('file:news/modalDelNews.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
}?>

<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready(function(){

	$("a.delInfo").click(function(){
		var id=$(this).attr('id');
		var titre = $("#titre"+id).text();
		$("#newsId").val(id);
		$("#newsTitle").text(titre);
		$("#modalDel").modal('show');
		})

	$("li.collapsible").click(function(){
		$('.collapsible ul').hide('slow');
        $(this).find('ul').toggle('slow');
    })

})

<?php echo '</script'; ?>
>
<?php }
}
