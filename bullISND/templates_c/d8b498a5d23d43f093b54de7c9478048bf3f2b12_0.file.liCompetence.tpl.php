<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 20:13:58
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/liCompetence.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e6076eca113_67538335',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'd8b498a5d23d43f093b54de7c9478048bf3f2b12' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/liCompetence.tpl',
      1 => 1605461588,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e6076eca113_67538335 (Smarty_Internal_Template $_smarty_tpl) {
?><tr data-idComp="<?php echo $_smarty_tpl->tpl_vars['idComp']->value;?>
">
    <td>
        <button type="button" class="btn btn-danger btn-xs btn-delCompetence">
            <i class="fa fa-times"></i>
        </button>
    </td>
    <td>
        <input type="text" name="libelle_<?php echo $_smarty_tpl->tpl_vars['idComp']->value;?>
" data-idcomp="<?php echo $_smarty_tpl->tpl_vars['idComp']->value;?>
" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['data']->value['libelle'])===null||$tmp==='' ? $_smarty_tpl->tpl_vars['libelle']->value : $tmp);?>
" class="lblComp form-control" id="lbl_<?php echo $_smarty_tpl->tpl_vars['idComp']->value;?>
" size="40" required>
    </td>
    <td>
        <input type="text" name="ordre_<?php echo $_smarty_tpl->tpl_vars['idComp']->value;?>
" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['data']->value['ordre'])===null||$tmp==='' ? 0 : $tmp);?>
" size="3" class="form-control">
    </td>

</tr>
<?php }
}
