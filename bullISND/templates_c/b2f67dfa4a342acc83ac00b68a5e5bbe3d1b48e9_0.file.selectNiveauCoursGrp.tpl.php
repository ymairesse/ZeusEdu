<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:49:43
  from '/home/yves/www/sio2/peda/bullISND/templates/selecteurs/selectNiveauCoursGrp.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5ac7e925b7_94231422',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'b2f67dfa4a342acc83ac00b68a5e5bbe3d1b48e9' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selecteurs/selectNiveauCoursGrp.tpl',
      1 => 1587142729,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e5ac7e925b7_94231422 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">
		<select name="niveau" id="niveauCours" class="form-control">
			<option value="">Niveau des cours</option>
			<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeNiveaux']->value, 'unNiveau', false, 'k');
$_smarty_tpl->tpl_vars['unNiveau']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['k']->value => $_smarty_tpl->tpl_vars['unNiveau']->value) {
$_smarty_tpl->tpl_vars['unNiveau']->do_else = false;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['unNiveau']->value;?>
" <?php if ((isset($_smarty_tpl->tpl_vars['niveau']->value)) && ($_smarty_tpl->tpl_vars['unNiveau']->value == $_smarty_tpl->tpl_vars['niveau']->value)) {?> selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['unNiveau']->value;?>
e année</option>
			<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
		</select>

		<span id="choixCours">
	<?php if ((isset($_smarty_tpl->tpl_vars['listeCoursGrp']->value))) {?>
		<select name="coursGrp" id="coursGrp" class="form-control">
		<option value="">Choisir un cours</option>
			<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCoursGrp']->value, 'data', false, 'unCoursGrp');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unCoursGrp']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
		<option value="<?php echo $_smarty_tpl->tpl_vars['unCoursGrp']->value;?>
"<?php if ((isset($_smarty_tpl->tpl_vars['coursGrp']->value)) && ($_smarty_tpl->tpl_vars['unCoursGrp']->value == $_smarty_tpl->tpl_vars['coursGrp']->value)) {?> selected<?php }?>>[<?php echo $_smarty_tpl->tpl_vars['data']->value['coursGrp'];?>
] <?php echo $_smarty_tpl->tpl_vars['data']->value['libelle'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['nbheures'];?>
h (<?php echo $_smarty_tpl->tpl_vars['data']->value['acronyme'];?>
)</option>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
		</select>
	<?php }?>
	</span>

		<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
		<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
		<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
		<input type="hidden" name="etape" value="show">
		<br>

	</form>
</div>

<?php echo '<script'; ?>
 type="text/javascript">
	$(document).ready(function() {

		$("#formSelecteur").submit(function() {
			var niveau = $("#niveauCours").val();
			var coursGrp = $("#coursGrp").val();
			if (niveau && coursGrp) {
				$("#wait").show();
				$("#corpsPage").hide();
			} else return false;
		})

		$("#niveauCours").change(function() {
			$("#wait").show();
			var niveau = $(this).val();
			if (niveau)
				$.post("inc/listeCoursNiveau.inc.php", {
						niveau: niveau
					},
					function(resultat) {
						$("#choixCours").html(resultat)
					}
				)
			$("#wait").hide();
		});

		$("#choixCours").on("change", "#coursGrp", function() {
			$("#formSelecteur").submit();
		})

	})
<?php echo '</script'; ?>
>
<?php }
}
