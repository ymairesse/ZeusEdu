<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:36:23
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/listeElevesClasse.inc.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e57a702e2f4_17949214',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '5eb95c139fbf81f04c4e905638828026d50a71cf' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/listeElevesClasse.inc.tpl',
      1 => 1601016119,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e57a702e2f4_17949214 (Smarty_Internal_Template $_smarty_tpl) {
?><form id="formEleves">

    <label for="eleves">Élèves</label>
    <select class="form-control" name="listeEleves[]" id="listeEleves" size="10" multiple style="max-height:15em; overflow: auto;">
        <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeEleves']->value, 'data', false, 'matricule');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['matricule']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
        <option value="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['data']->value['groupe'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['prenom'];?>
</option>
        <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
    </select>
    <div class="help-block">Ctrl / Maj pour sélection multiple</div>

</form>
<?php }
}
