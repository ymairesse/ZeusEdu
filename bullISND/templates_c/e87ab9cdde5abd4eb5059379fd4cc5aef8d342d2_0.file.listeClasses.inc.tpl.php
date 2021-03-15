<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:36:23
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/listeClasses.inc.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e57a702b594_57349097',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'e87ab9cdde5abd4eb5059379fd4cc5aef8d342d2' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/listeClasses.inc.tpl',
      1 => 1600967661,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e57a702b594_57349097 (Smarty_Internal_Template $_smarty_tpl) {
?><label for="classe">Classe</label>
<select class="form-control" name="listeClasses" id="listeClasses">
    <option value="">Choisir une classe</option>
    <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeClasses']->value, 'classe');
$_smarty_tpl->tpl_vars['classe']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['classe']->value) {
$_smarty_tpl->tpl_vars['classe']->do_else = false;
?>
    <option value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
</option>
    <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
</select>
<?php }
}
