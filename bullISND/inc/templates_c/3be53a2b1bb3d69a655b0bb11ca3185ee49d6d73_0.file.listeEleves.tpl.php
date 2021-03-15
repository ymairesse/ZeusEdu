<?php
/* Smarty version 3.1.34-dev-7, created on 2020-12-06 16:56:53
  from '/home/yves/www/sio2/peda/bullISND/templates/direction/listeEleves.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_5fccff456c4387_25961471',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '3be53a2b1bb3d69a655b0bb11ca3185ee49d6d73' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/direction/listeEleves.tpl',
      1 => 1459422362,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_5fccff456c4387_25961471 (Smarty_Internal_Template $_smarty_tpl) {
if ((isset($_smarty_tpl->tpl_vars['listeEleves']->value))) {?>
<table class="table table-condensed table-bordered">
	<thead>
		<tr>
			<th>Nom</th>
			<th><input type="checkbox" id="checkAll"></th>
		</tr>
	</thead>
	<tbody>
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeEleves']->value, 'unEleve', false, 'matricule');
$_smarty_tpl->tpl_vars['unEleve']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['matricule']->value => $_smarty_tpl->tpl_vars['unEleve']->value) {
$_smarty_tpl->tpl_vars['unEleve']->do_else = false;
?>
			<tr>
				<td><?php echo $_smarty_tpl->tpl_vars['unEleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['unEleve']->value['prenom'];?>
</td>
				<td><input type="checkbox" name="eleves[]" class="eleves" value="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
"></td>
			</tr>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
	</tbody>

</table>
<?php }
}
}
