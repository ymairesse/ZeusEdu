<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 12:27:17
  from '/home/yves/www/sio2/peda/bullISND/templates/users/listeCoursInterim.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604df315943f39_89099465',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '9b89d83003cbd5c302eea1be7f79c571354fde07' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/users/listeCoursInterim.tpl',
      1 => 1457985445,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604df315943f39_89099465 (Smarty_Internal_Template $_smarty_tpl) {
?><h4 class="bg-info"><?php echo $_smarty_tpl->tpl_vars['nomProf']->value;?>
</h4>
<table class="table table-condensed">
    <thead>
        <tr>
            <th>Cours</th>
            <th>Libelle</th>
        </tr>
    </thead>
    <tbody>
        <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeAffectations']->value, 'dataCours', false, 'coursGrp');
$_smarty_tpl->tpl_vars['dataCours']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['dataCours']->value) {
$_smarty_tpl->tpl_vars['dataCours']->do_else = false;
?>
        <tr>
            <td><?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
</td>
            <td><?php echo $_smarty_tpl->tpl_vars['dataCours']->value['libelle'];?>
</td>
        </tr>
        <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
    </tbody>

</table>
<?php }
}
