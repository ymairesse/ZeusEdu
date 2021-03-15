<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 12:24:11
  from '/home/yves/www/sio2/peda/bullISND/templates/remplacants.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604df25bb5f993_94311721',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'f346b511d4a2af89fca2aeb6a9ed8907e2a411bb' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/remplacants.tpl',
      1 => 1427216905,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604df25bb5f993_94311721 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container">
	
<h2>Liste des profs remplacés</h2>

<table class="tableauAdmin table">
	<thead>
	<tr>
		<th>Cours</th>
		<th>Prof</th>
	</tr>
	</thead>
	<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeRemplacements']->value, 'remplacants', false, 'coursGrp');
$_smarty_tpl->tpl_vars['remplacants']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['remplacants']->value) {
$_smarty_tpl->tpl_vars['remplacants']->do_else = false;
?>
		<?php $_smarty_tpl->_assignInScope('pos', strpos($_smarty_tpl->tpl_vars['coursGrp']->value,'-'));?>
		<?php $_smarty_tpl->_assignInScope('cours', substr($_smarty_tpl->tpl_vars['coursGrp']->value,0,('pos'-3)));?>
		<tr>
			<th><?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
</th>
			<th><strong><?php if ((isset($_smarty_tpl->tpl_vars['listeCoursEleves']->value[$_smarty_tpl->tpl_vars['cours']->value]))) {
echo $_smarty_tpl->tpl_vars['listeCoursEleves']->value[$_smarty_tpl->tpl_vars['cours']->value]['libelle'];
} else { ?>Cours inconnu<?php }?></strong></th>
		</tr>
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['remplacants']->value, 'unProf');
$_smarty_tpl->tpl_vars['unProf']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unProf']->value) {
$_smarty_tpl->tpl_vars['unProf']->do_else = false;
?>
		<tr>
			<td>&nbsp;</td>
			<td><?php echo $_smarty_tpl->tpl_vars['unProf']->value;?>
</td>
		</tr>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
	<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
</table>

</div><?php }
}
