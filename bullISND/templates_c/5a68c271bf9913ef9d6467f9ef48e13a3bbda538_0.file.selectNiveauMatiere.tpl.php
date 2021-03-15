<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:33:44
  from '/home/yves/www/sio2/peda/bullISND/templates/selectNiveauMatiere.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5708148571_85626378',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '5a68c271bf9913ef9d6467f9ef48e13a3bbda538' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selectNiveauMatiere.tpl',
      1 => 1522219157,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:listeMatieres.tpl' => 1,
  ),
),false)) {
function content_604e5708148571_85626378 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="selecteur" class="noprint" style="clear:both">

	<form name="formSelecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		<label for="niveau" class="sr-only">Niveau</label>
		<select name="niveau" id="niveau" class="form-control">
			<option value=''>Niveau</option>
			<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeNiveaux']->value, 'leNiveau', false, 'clef');
$_smarty_tpl->tpl_vars['leNiveau']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['clef']->value => $_smarty_tpl->tpl_vars['leNiveau']->value) {
$_smarty_tpl->tpl_vars['leNiveau']->do_else = false;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['leNiveau']->value;?>
"	<?php if ($_smarty_tpl->tpl_vars['leNiveau']->value == $_smarty_tpl->tpl_vars['niveau']->value) {?>selected<?php }?>>
				<?php echo $_smarty_tpl->tpl_vars['leNiveau']->value;?>

			</option>
			<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
		</select>

		<span id="choixMatiere">
		<?php $_smarty_tpl->_subTemplateRender('file:listeMatieres.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
		</span>

	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
	<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
	<input type="hidden" name="etape" value="showMatiere">
	</form>
</div>

<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready (function() {

	$("#choixMatiere").on("change", "#matiere", function(){
		if ($(this).val() != '') {
			$("#wait").show();
			$("#formSelecteur").submit();
			}
			else return false;
		})

	$("#niveau").change(function(){
		var niveau = $(this).val();
		if (niveau != '') {
			$.post('inc/listeMatieres.inc.php', {
				'niveau':niveau
				},
				function (resultat) {
					$("#choixMatiere").html(resultat)
					}
				)
			}
			else $("#choixMatiere").html('');

	})

	$("#formSelecteur").submit(function(){
		if (($("#niveau").val() == '') || ($("#matiere").val() == '')) {
			return false
		}
		})

})

<?php echo '</script'; ?>
>
<?php }
}
