<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 16:45:05
  from '/home/yves/www/sio2/peda/bullISND/templates/selecteurs/selectListeMatieres.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e2f811fa4a5_89015767',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '0a437e155dd6586f174f5f2a6bb2f0520b6dede5' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selecteurs/selectListeMatieres.tpl',
      1 => 1615736701,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e2f811fa4a5_89015767 (Smarty_Internal_Template $_smarty_tpl) {
?><label for="matiere">Sélection d'un matière</label>
<select name="matiere" id="matiere" class="form-control" size="20">

	<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCours']->value, 'unCours', false, 'leCours');
$_smarty_tpl->tpl_vars['unCours']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['leCours']->value => $_smarty_tpl->tpl_vars['unCours']->value) {
$_smarty_tpl->tpl_vars['unCours']->do_else = false;
?>
	<option value="<?php echo $_smarty_tpl->tpl_vars['leCours']->value;?>
"<?php if ((isset($_smarty_tpl->tpl_vars['cours']->value)) && ($_smarty_tpl->tpl_vars['leCours']->value == $_smarty_tpl->tpl_vars['cours']->value)) {?> selected<?php }?> title="[<?php echo $_smarty_tpl->tpl_vars['leCours']->value;?>
] <?php echo $_smarty_tpl->tpl_vars['unCours']->value['libelle'];?>
 <?php echo $_smarty_tpl->tpl_vars['unCours']->value['nbheures'];?>
h">
		<?php echo $_smarty_tpl->tpl_vars['unCours']->value['libelle'];?>
 <?php echo $_smarty_tpl->tpl_vars['unCours']->value['statut'];?>
 <?php echo $_smarty_tpl->tpl_vars['unCours']->value['nbheures'];?>
h [<?php echo $_smarty_tpl->tpl_vars['leCours']->value;?>
]</option>
	<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

</select>
<?php }
}
