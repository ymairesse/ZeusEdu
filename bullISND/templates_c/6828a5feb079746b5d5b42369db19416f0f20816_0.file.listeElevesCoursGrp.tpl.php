<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:36:23
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/listeElevesCoursGrp.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e57a7028d38_64135483',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '6828a5feb079746b5d5b42369db19416f0f20816' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/listeElevesCoursGrp.tpl',
      1 => 1601308855,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e57a7028d38_64135483 (Smarty_Internal_Template $_smarty_tpl) {
?><form id="formElevesCours">
    <div class="form-group">
        <label for="listeElevesCoursGrp">Élèves qui suivent le cours <span class="badge badge-primary"><?php echo (($tmp = @count($_smarty_tpl->tpl_vars['listeElevesCoursGrp']->value))===null||$tmp==='' ? 0 : $tmp);?>
</span></label>
        <select class="form-control" name="listeElevesCoursGrp[]" id="listeElevesCoursGrp" size="<?php echo count($_smarty_tpl->tpl_vars['listeElevesCoursGrp']->value);?>
" multiple style="max-height:25em; overflow:auto">
            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeElevesCoursGrp']->value, 'dataEleve', false, 'matricule');
$_smarty_tpl->tpl_vars['dataEleve']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['matricule']->value => $_smarty_tpl->tpl_vars['dataEleve']->value) {
$_smarty_tpl->tpl_vars['dataEleve']->do_else = false;
?>
            <option value="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['dataEleve']->value['groupe'];?>
 <?php echo $_smarty_tpl->tpl_vars['dataEleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['dataEleve']->value['prenom'];?>
</option>
            <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
        </select>
        <div class="help-block">Ctrl / Maj pour sélection multiple</div>
    </div>
</form>
<?php }
}
