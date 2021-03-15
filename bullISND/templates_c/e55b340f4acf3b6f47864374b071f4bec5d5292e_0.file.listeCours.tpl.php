<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:49:47
  from '/home/yves/www/sio2/peda/bullISND/templates/listeCours.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5acb0b28b8_81966722',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'e55b340f4acf3b6f47864374b071f4bec5d5292e' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/listeCours.tpl',
      1 => 1522657851,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e5acb0b28b8_81966722 (Smarty_Internal_Template $_smarty_tpl) {
?><select name="coursGrp" id="coursGrp" class="form-control">
	<option value="">Choisir un cours en <?php echo $_smarty_tpl->tpl_vars['niveau']->value;?>
e</option>
	<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCoursGrp']->value, 'data', false, 'unCoursGrp');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unCoursGrp']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
	<option value="<?php echo $_smarty_tpl->tpl_vars['unCoursGrp']->value;?>
" <?php if ((isset($_smarty_tpl->tpl_vars['coursGrp']->value)) && ($_smarty_tpl->tpl_vars['unCoursGrp']->value == $_smarty_tpl->tpl_vars['coursGrp']->value)) {?> selected<?php }?>>
		[<?php echo $_smarty_tpl->tpl_vars['data']->value['coursGrp'];?>
] <?php echo $_smarty_tpl->tpl_vars['data']->value['statut'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['libelle'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['nbheures'];?>
h (<?php echo $_smarty_tpl->tpl_vars['data']->value['acronyme'];?>
)</option>
	<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
</select>
<?php }
}
