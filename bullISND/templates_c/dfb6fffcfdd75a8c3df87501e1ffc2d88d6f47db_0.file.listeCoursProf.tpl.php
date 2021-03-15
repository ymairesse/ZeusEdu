<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 12:27:17
  from '/home/yves/www/sio2/peda/bullISND/templates/users/listeCoursProf.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604df31592d425_88073422',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'dfb6fffcfdd75a8c3df87501e1ffc2d88d6f47db' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/users/listeCoursProf.tpl',
      1 => 1457985450,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604df31592d425_88073422 (Smarty_Internal_Template $_smarty_tpl) {
?><h4 class="bg-primary"><?php echo $_smarty_tpl->tpl_vars['nomProf']->value;?>
 <i class="fa fa-arrow-right pull-right"></i></h4>
<table class="table table-condensed">
    <thead>
        <tr>
            <th>Cours</th>
            <th>Libelle</th>
            <th>&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeAffectations']->value, 'dataCours', false, 'coursGrp');
$_smarty_tpl->tpl_vars['dataCours']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['dataCours']->value) {
$_smarty_tpl->tpl_vars['dataCours']->do_else = false;
?>
        <tr class="unCours">
            <td><?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
</td>
            <td><?php echo $_smarty_tpl->tpl_vars['dataCours']->value['libelle'];?>
</td>
            <td><input type="checkbox" name="cours[]" value="<?php echo $_smarty_tpl->tpl_vars['dataCours']->value['coursGrp'];?>
"></td>
        </tr>
        <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
    </tbody>

</table>
<?php }
}
