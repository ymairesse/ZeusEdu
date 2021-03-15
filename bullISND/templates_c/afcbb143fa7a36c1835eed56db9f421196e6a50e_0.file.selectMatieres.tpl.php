<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:57:32
  from '/home/yves/www/sio2/peda/bullISND/templates/selectMatieres.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5c9c388196_56380747',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'afcbb143fa7a36c1835eed56db9f421196e6a50e' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selectMatieres.tpl',
      1 => 1427568479,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e5c9c388196_56380747 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_checkPlugins(array(0=>array('file'=>'/home/yves/www/sio2/peda/smarty/plugins/modifier.truncate.php','function'=>'smarty_modifier_truncate',),));
?>
<div id="selecteur" class="noprint" style="clear:both">
	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php">
		<label for="cours">Choix de la matière</label>
		<select name="cours" id="cours">
		<option value="">Matière</option>
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCours']->value, 'details', false, 'leCours');
$_smarty_tpl->tpl_vars['details']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['leCours']->value => $_smarty_tpl->tpl_vars['details']->value) {
$_smarty_tpl->tpl_vars['details']->do_else = false;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['leCours']->value;?>
"<?php if ($_smarty_tpl->tpl_vars['cours']->value == $_smarty_tpl->tpl_vars['leCours']->value) {?> selected<?php }?> 
			title="<?php echo $_smarty_tpl->tpl_vars['details']->value['libelle'];?>
">[<?php echo $_smarty_tpl->tpl_vars['details']->value['cours'];?>
] <?php echo $_smarty_tpl->tpl_vars['details']->value['statut'];?>
 <?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['details']->value['libelle'],30);?>
 <?php echo $_smarty_tpl->tpl_vars['details']->value['nbheures'];?>
h</option>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
		</select>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
	<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
	<input type="hidden" name="etape" value="showCoursGrp">
	</form>
</div>

<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready (function() {
	$("#cours").change(function(){
		if ($(this).val() != '') {
			$("#wait").show();
			$("#formSelecteur").submit();
			}
			else return false;
		})

	
})

<?php echo '</script'; ?>
>
<?php }
}
