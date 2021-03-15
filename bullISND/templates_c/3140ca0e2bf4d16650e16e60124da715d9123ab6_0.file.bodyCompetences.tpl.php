<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 20:13:08
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/bodyCompetences.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e6044349b92_60921957',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '3140ca0e2bf4d16650e16e60124da715d9123ab6' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/bodyCompetences.tpl',
      1 => 1605463466,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e6044349b92_60921957 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_assignInScope('competences', $_smarty_tpl->tpl_vars['listeCompetences']->value[$_smarty_tpl->tpl_vars['cours']->value]);?>

<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['competences']->value, 'data', false, 'idComp');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['idComp']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
    <tr data-idComp="<?php echo $_smarty_tpl->tpl_vars['idComp']->value;?>
">
        <td>
            <button type="button" class="btn btn-danger btn-xs btn-delCompetence"
            <?php if (in_array($_smarty_tpl->tpl_vars['idComp']->value,$_smarty_tpl->tpl_vars['listeUsedCompetences']->value)) {?> disabled<?php }?> >
                <i class="fa fa-times"></i>
            </button>
        </td>
        <td>
            <input type="text" name="libelle_<?php echo $_smarty_tpl->tpl_vars['idComp']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['data']->value['libelle'];?>
" class="lblComp form-control" id="lbl_<?php echo $_smarty_tpl->tpl_vars['idComp']->value;?>
" data-idcomp="<?php echo $_smarty_tpl->tpl_vars['idComp']->value;?>
" size="40" required>
        </td>
        <td>
            <input type="text" name="ordre_<?php echo $_smarty_tpl->tpl_vars['idComp']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['data']->value['ordre'];?>
" size="3" class="form-control">
        </td>

    </tr>

<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);
}
}
