<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:57:41
  from '/home/yves/www/sio2/peda/bullISND/templates/listeElevesAdd.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5ca5500fb3_93889237',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '5e08bf489716a011c83a4ab64cc966eacb9d2219' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/listeElevesAdd.tpl',
      1 => 1477677569,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e5ca5500fb3_93889237 (Smarty_Internal_Template $_smarty_tpl) {
if ((isset($_smarty_tpl->tpl_vars['listeElevesAdd']->value))) {?>
<select name="listeElevesAdd[]" id="listeElevesAdd" size="20" multiple="multiple" class="form-control">
	<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeElevesAdd']->value, 'unEleve', false, 'leMatricule');
$_smarty_tpl->tpl_vars['unEleve']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['leMatricule']->value => $_smarty_tpl->tpl_vars['unEleve']->value) {
$_smarty_tpl->tpl_vars['unEleve']->do_else = false;
?>
	<option value="<?php echo $_smarty_tpl->tpl_vars['leMatricule']->value;?>
" title="<?php echo $_smarty_tpl->tpl_vars['leMatricule']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['unEleve']->value['classe'];?>
 <?php echo $_smarty_tpl->tpl_vars['unEleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['unEleve']->value['prenom'];?>
</option>
	<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
</select>
<?php }
}
}
