<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:33:53
  from '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/listeProfsCoursGrp.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e57116b6607_73325973',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '12cc47fee46d28d82ccc0c92cb6c714b5f6cd877' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/admin/modal/listeProfsCoursGrp.tpl',
      1 => 1601013999,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e57116b6607_73325973 (Smarty_Internal_Template $_smarty_tpl) {
?><form id="listeProfCours">
    <div class="form-group">
        <label for="listeProfsCoursGrp">Titulaire(s) du cours</label>
        <select class="form-control" name="listeProfsCoursGrp[]" id="listeProfsCoursGrp" size="<?php echo count($_smarty_tpl->tpl_vars['listeProfsCoursGrp']->value);?>
" multiple>
            <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeProfsCoursGrp']->value, 'dataProf', false, 'acronyme');
$_smarty_tpl->tpl_vars['dataProf']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['acronyme']->value => $_smarty_tpl->tpl_vars['dataProf']->value) {
$_smarty_tpl->tpl_vars['dataProf']->do_else = false;
?>
            <option value="<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['dataProf']->value['formule'];?>
 <?php echo $_smarty_tpl->tpl_vars['dataProf']->value['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['dataProf']->value['nom'];?>
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
