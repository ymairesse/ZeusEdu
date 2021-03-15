<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:33:44
  from '/home/yves/www/sio2/peda/bullISND/templates/listeMatieres.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5708150731_43618204',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '2ede5d8e1a61de585b335a0e1775b17b4e388802' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/listeMatieres.tpl',
      1 => 1518458622,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e5708150731_43618204 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_checkPlugins(array(0=>array('file'=>'/home/yves/www/sio2/peda/smarty/plugins/modifier.truncate.php','function'=>'smarty_modifier_truncate',),));
if ((isset($_smarty_tpl->tpl_vars['listeMatieres']->value))) {?>
<select name="cours" id="matiere" class="form-control">
	<option value=''>Choisir une matière en <?php echo $_smarty_tpl->tpl_vars['niveau']->value;?>
e</option>
	<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeMatieres']->value, 'data', false, 'uneMatiere');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['uneMatiere']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
	<option value="<?php echo $_smarty_tpl->tpl_vars['uneMatiere']->value;?>
"<?php if ((isset($_smarty_tpl->tpl_vars['cours']->value)) && ($_smarty_tpl->tpl_vars['uneMatiere']->value == $_smarty_tpl->tpl_vars['cours']->value)) {?> selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['data']->value['cours'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['statut'];?>
 <?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['data']->value['libelle'],30);?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['nbheures'];?>
h</option>
	<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
</select>
<?php }
}
}
