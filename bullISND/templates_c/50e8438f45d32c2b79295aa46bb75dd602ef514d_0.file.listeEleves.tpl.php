<?php
/* Smarty version 3.1.34-dev-7, created on 2021-02-10 17:56:51
  from '/home/yves/www/sio2/peda/bullISND/templates/listeEleves.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_602410533e2ea7_68897297',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '50e8438f45d32c2b79295aa46bb75dd602ef514d' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/listeEleves.tpl',
      1 => 1588953700,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_602410533e2ea7_68897297 (Smarty_Internal_Template $_smarty_tpl) {
if ((isset($_smarty_tpl->tpl_vars['listeEleves']->value))) {?>

<select name="matricule" id="selectEleve" <?php if ((isset($_smarty_tpl->tpl_vars['size']->value))) {?>size="<?php echo $_smarty_tpl->tpl_vars['size']->value;?>
"<?php }
if ((isset($_smarty_tpl->tpl_vars['multiple']->value))) {?> multiple<?php }?> class="form-control input-sm">
	<option value="">Choisir un élève</option>
	<?php if ((isset($_smarty_tpl->tpl_vars['listeEleves']->value))) {?>
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeEleves']->value, 'unEleve', false, 'leMatricule');
$_smarty_tpl->tpl_vars['unEleve']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['leMatricule']->value => $_smarty_tpl->tpl_vars['unEleve']->value) {
$_smarty_tpl->tpl_vars['unEleve']->do_else = false;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['leMatricule']->value;?>
"
			class="<?php if ((isset($_smarty_tpl->tpl_vars['listeSelectionEleves']->value)) && ($_smarty_tpl->tpl_vars['listeSelectionEleves']->value != Null) && (!in_array($_smarty_tpl->tpl_vars['leMatricule']->value,$_smarty_tpl->tpl_vars['listeSelectionEleves']->value))) {?>hidden<?php }?>"
			<?php if ((isset($_smarty_tpl->tpl_vars['listeSelectionEleves']->value)) && ($_smarty_tpl->tpl_vars['listeSelectionEleves']->value != Null) && (!in_array($_smarty_tpl->tpl_vars['leMatricule']->value,$_smarty_tpl->tpl_vars['listeSelectionEleves']->value))) {?> disabled<?php }?>
			 <?php if ((isset($_smarty_tpl->tpl_vars['matricule']->value)) && ($_smarty_tpl->tpl_vars['leMatricule']->value == $_smarty_tpl->tpl_vars['matricule']->value)) {?> selected<?php }?>>
			 <?php echo $_smarty_tpl->tpl_vars['unEleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['unEleve']->value['prenom'];?>

		 	</option>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
	<?php }?>
</select>

<?php }
}
}
