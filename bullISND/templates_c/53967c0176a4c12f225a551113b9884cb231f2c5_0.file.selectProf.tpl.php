<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-12 13:28:18
  from '/home/yves/www/sio2/peda/bullISND/templates/selectProf.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604b5e62a60e51_24699129',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '53967c0176a4c12f225a551113b9884cb231f2c5' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selectProf.tpl',
      1 => 1427612946,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604b5e62a60e51_24699129 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="selecteur" class="noprint" style="clear:both">
	
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
	<select name="acronyme" id="selectUser">
		<option value="">Sélectionner un utilisateur</option>
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeProfs']->value, 'prof', false, 'abreviation');
$_smarty_tpl->tpl_vars['prof']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['abreviation']->value => $_smarty_tpl->tpl_vars['prof']->value) {
$_smarty_tpl->tpl_vars['prof']->do_else = false;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['abreviation']->value;?>
"<?php if ((isset($_smarty_tpl->tpl_vars['acronyme']->value)) && ($_smarty_tpl->tpl_vars['acronyme']->value == $_smarty_tpl->tpl_vars['abreviation']->value)) {?> selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['prof']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
 [<?php echo $_smarty_tpl->tpl_vars['abreviation']->value;?>
]</option>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
	</select>
	<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
	<input type="hidden" name="etape" value="<?php echo $_smarty_tpl->tpl_vars['etape']->value;?>
">
	<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	</form>

</div>

<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready(function(){

	$("#selectUser").change(function(){
		if ($("#selectUser").val() != "")
			$("#formSelecteur").submit();
		})
	
	$("#formSelecteur").submit(function(){
		if ($("#selectUser").val() == "")
			return false;
			else $("#wait").show();
		})

})

<?php echo '</script'; ?>
><?php }
}
