<?php
/* Smarty version 3.1.34-dev-7, created on 2021-02-09 18:08:50
  from '/home/yves/www/sio2/peda/bullISND/templates/selectClasse.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_6022c1a2a5ba63_36849808',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '168f8141d4543c58b5127666d3918ce904734017' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selectClasse.tpl',
      1 => 1434609318,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_6022c1a2a5ba63_36849808 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="selecteur" class="noprint" style="clear:both">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline" role="form">
		<select name="classe" id="selectClasse">
		<option value="">Classe</option>
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeClasses']->value, 'uneClasse');
$_smarty_tpl->tpl_vars['uneClasse']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['uneClasse']->value) {
$_smarty_tpl->tpl_vars['uneClasse']->do_else = false;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['uneClasse']->value;?>
"<?php if (((isset($_smarty_tpl->tpl_vars['classe']->value))) && ($_smarty_tpl->tpl_vars['uneClasse']->value == $_smarty_tpl->tpl_vars['classe']->value)) {?> selected="selected"<?php }?>><?php echo $_smarty_tpl->tpl_vars['uneClasse']->value;?>
</option>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
		</select>
		
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
	<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
	<input type="hidden" name="etape" value="showClasse">
	<input type="hidden" name="onglet" class="onglet" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['onglet']->value)===null||$tmp==='' ? 0 : $tmp);?>
">
	</form>
</div>

<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectClasse").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})
	
	$("#selectClasse").change(function(){
		if ($(this).val() != '')
			$("#formSelecteur").submit();
		})

})

<?php echo '</script'; ?>
>
<?php }
}
