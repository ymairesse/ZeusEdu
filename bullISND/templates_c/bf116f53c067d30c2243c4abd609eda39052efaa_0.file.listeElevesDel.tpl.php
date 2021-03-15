<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:57:48
  from '/home/yves/www/sio2/peda/bullISND/templates/listeElevesDel.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5cac53dbb8_42887100',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'bf116f53c067d30c2243c4abd609eda39052efaa' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/listeElevesDel.tpl',
      1 => 1477678200,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e5cac53dbb8_42887100 (Smarty_Internal_Template $_smarty_tpl) {
?><strong><?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
</strong>
<br>

<?php $_smarty_tpl->_assignInScope('size', count($_smarty_tpl->tpl_vars['listeElevesDel']->value));?>
<select size="<?php echo $_smarty_tpl->tpl_vars['size']->value;?>
" name="listeElevesDel[]" id="listeElevesDel" multiple="multiple" class="form-control">
	<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeElevesDel']->value, 'details', false, 'matricule');
$_smarty_tpl->tpl_vars['details']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['matricule']->value => $_smarty_tpl->tpl_vars['details']->value) {
$_smarty_tpl->tpl_vars['details']->do_else = false;
?>
	<option value="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
" title="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['details']->value['classe'];?>
 <?php echo $_smarty_tpl->tpl_vars['details']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['details']->value['prenom'];?>
</option>
	<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
</select>
<p><strong><?php echo count($_smarty_tpl->tpl_vars['listeElevesDel']->value);?>
 élèves</strong></p>
<?php }
}
