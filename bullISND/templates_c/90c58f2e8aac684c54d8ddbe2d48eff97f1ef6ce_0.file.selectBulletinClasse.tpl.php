<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 10:59:32
  from '/home/yves/www/sio2/peda/bullISND/templates/selectBulletinClasse.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604dde84653980_58677470',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '90c58f2e8aac684c54d8ddbe2d48eff97f1ef6ce' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selectBulletinClasse.tpl',
      1 => 1593335859,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604dde84653980_58677470 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		Bulletin n° <select name="bulletin" id="bulletin" class="form-control input-sm">
		<?php
$__section_bidule_0_loop = (is_array(@$_loop=$_smarty_tpl->tpl_vars['nbBulletins']->value+1) ? count($_loop) : max(0, (int) $_loop));
$__section_bidule_0_start = min(1, $__section_bidule_0_loop);
$__section_bidule_0_total = min(($__section_bidule_0_loop - $__section_bidule_0_start), $__section_bidule_0_loop);
$_smarty_tpl->tpl_vars['__smarty_section_bidule'] = new Smarty_Variable(array());
if ($__section_bidule_0_total !== 0) {
for ($__section_bidule_0_iteration = 1, $_smarty_tpl->tpl_vars['__smarty_section_bidule']->value['index'] = $__section_bidule_0_start; $__section_bidule_0_iteration <= $__section_bidule_0_total; $__section_bidule_0_iteration++, $_smarty_tpl->tpl_vars['__smarty_section_bidule']->value['index']++){
?>
			<option value="<?php echo (isset($_smarty_tpl->tpl_vars['__smarty_section_bidule']->value['index']) ? $_smarty_tpl->tpl_vars['__smarty_section_bidule']->value['index'] : null);?>
"
			<?php if ((isset($_smarty_tpl->tpl_vars['__smarty_section_bidule']->value['index']) ? $_smarty_tpl->tpl_vars['__smarty_section_bidule']->value['index'] : null) == $_smarty_tpl->tpl_vars['bulletin']->value) {?> selected="selected"<?php }?>><?php echo (isset($_smarty_tpl->tpl_vars['__smarty_section_bidule']->value['index']) ? $_smarty_tpl->tpl_vars['__smarty_section_bidule']->value['index'] : null);?>

			</option>
		<?php
}
}
?>
	</select>

	<select name="classe" id="classe" class="form-control input-sm">
		<option value="">Classe</option>
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeClasses']->value, 'uneClasse');
$_smarty_tpl->tpl_vars['uneClasse']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['uneClasse']->value) {
$_smarty_tpl->tpl_vars['uneClasse']->do_else = false;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['uneClasse']->value;?>
"<?php if ((isset($_smarty_tpl->tpl_vars['classe']->value)) && ($_smarty_tpl->tpl_vars['classe']->value == $_smarty_tpl->tpl_vars['uneClasse']->value)) {?> selected="selected"<?php }?>><?php echo $_smarty_tpl->tpl_vars['uneClasse']->value;?>
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
	<input type="hidden" name="etape" value="<?php echo $_smarty_tpl->tpl_vars['etape']->value;?>
">
	</form>
</div>
<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if (($("#classe").val() == '') || ($("#bulletin").val() == ''))
			return false;
			else {
				$("#wait").show();
				$.blockUI();
			}
		})

	$("#classe").change (function(){
		var classe = $(this).val();
		Cookies.set('classe', classe);
		$("#formSelecteur").submit();
	})

})

<?php echo '</script'; ?>
>
<?php }
}
