<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 20:12:57
  from '/home/yves/www/sio2/peda/bullISND/templates/selecteurs/selectNiveauCours.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e60391b8ca9_65222887',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '9781831335a6c658b01be5b1643e4bca39bb6b60' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selecteurs/selectNiveauCours.tpl',
      1 => 1605609611,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:selecteurs/listeCoursComp.tpl' => 1,
  ),
),false)) {
function content_604e60391b8ca9_65222887 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="selecteur" class="noprint" style="clear:both">

	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
	<select name="niveau" id="niveau" class="form-control">
		<option value="">Niveau</option>
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeNiveaux']->value, 'unNiveau');
$_smarty_tpl->tpl_vars['unNiveau']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unNiveau']->value) {
$_smarty_tpl->tpl_vars['unNiveau']->do_else = false;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['unNiveau']->value;?>
"<?php if ((isset($_smarty_tpl->tpl_vars['niveau']->value)) && ($_smarty_tpl->tpl_vars['unNiveau']->value == $_smarty_tpl->tpl_vars['niveau']->value)) {?>selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['unNiveau']->value;?>
</option>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
	</select>

	<span id="choixCours">
	<?php if ($_smarty_tpl->tpl_vars['listeNiveaux']->value) {?>
		<?php $_smarty_tpl->_subTemplateRender("file:selecteurs/listeCoursComp.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
	<?php }?>
	</span>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
	<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
	<input type="hidden" name="etape" value="show">
	</form>
</div>

<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#cours").val() != "") {
			$("#wait").show();
			$("#corpsPage").hide();
			}
			else return false;
	})

	$("#niveau").change(function(){
		var niveau = $(this).val();
		$.post("inc/listeCours.inc.php", {
			'niveau': niveau
			},
				function (resultat){
					$("#choixCours").html(resultat)
				}
			)
	});
})

<?php echo '</script'; ?>
>
<?php }
}
