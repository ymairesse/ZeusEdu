<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-15 10:16:06
  from '/home/yves/www/sio2/peda/bullISND/templates/poserVerrous.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604f25d6e3f809_50055388',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '7a5c0e3d47be83a52b5b41e0e7fdb08e3caa06ac' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/poserVerrous.tpl',
      1 => 1513094943,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604f25d6e3f809_50055388 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container">

<h2 style="clear:both">Verrouillage des bulletins n° <?php echo $_smarty_tpl->tpl_vars['bulletin']->value;?>
</h2>

	<form name="formulaire" id="formulaire" class="form" method="POST" action="index.php">

		<input type="hidden" name="action" value="admin">
		<input type="hidden" name="mode" value="poserVerrous">
		<input type="hidden" name="etape" value="enregistrer">
		<input type="hidden" name="bulletin" value="<?php echo $_smarty_tpl->tpl_vars['bulletin']->value;?>
">

		<div class="row">

			<div class="col-md-9 col-xs-12">
				<h3>Choix des classes</h3>
				<div class="row">

					<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeClasses']->value, 'niveauxDegre', false, 'degre');
$_smarty_tpl->tpl_vars['niveauxDegre']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['degre']->value => $_smarty_tpl->tpl_vars['niveauxDegre']->value) {
$_smarty_tpl->tpl_vars['niveauxDegre']->do_else = false;
?>

					<div class="col-md-4 col-sm-6">
						<h4>Degré <?php echo $_smarty_tpl->tpl_vars['degre']->value;?>
</h4>
						<ul>
						<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['niveauxDegre']->value, 'classes', false, 'niveaux');
$_smarty_tpl->tpl_vars['classes']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['niveaux']->value => $_smarty_tpl->tpl_vars['classes']->value) {
$_smarty_tpl->tpl_vars['classes']->do_else = false;
?>
							<li><span class="collapsible">Classes de <?php echo $_smarty_tpl->tpl_vars['niveaux']->value;?>
e</span>
								<input type="radio" value="<?php echo $_smarty_tpl->tpl_vars['niveaux']->value;?>
" name="radioNiveau" class="niveau">
							<ul>
								<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['classes']->value, 'uneClasse');
$_smarty_tpl->tpl_vars['uneClasse']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['uneClasse']->value) {
$_smarty_tpl->tpl_vars['uneClasse']->do_else = false;
?>
									<li><?php echo $_smarty_tpl->tpl_vars['uneClasse']->value;?>

									<input type="checkbox" name="classe_<?php echo $_smarty_tpl->tpl_vars['uneClasse']->value;?>
" value="1" class="classe">
									</li>
								<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
							</ul>
							</li>
						<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
						</ul>
					</div>  <!-- col-md-4.. -->

					<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

				</div>  <!-- row -->

			</div>   <!-- col-md-10... -->

			<div class="col-md-3 col-xs-12">
				<h3>Action</h3>
				<div class="radio">
					<label><input type="radio" name="verrou" value="0"<?php if ($_smarty_tpl->tpl_vars['verrou']->value == 0) {?> checked<?php }?>>Déverrouiller</label>
				</div>
				<div class="radio">
					<label><input type="radio" name="verrou" value="1"<?php if ($_smarty_tpl->tpl_vars['verrou']->value == 1) {?> checked<?php }?>>Verrouiller les cotes</label>
				</div>
				<div class="radio">
					<label><input type="radio" name="verrou" value="2"<?php if ($_smarty_tpl->tpl_vars['verrou']->value == 2) {?> checked<?php }?>>Verrouiller cotes et commentaires</label>
				</div>

				<div class="btn-group-vertical btn-block">
					<button type="submit" class="btn btn-primary pull-right">Enregistrer</button>
					<button type="reset" class="btn btn-default pull-right">Annuler</button>
				</div>
			</div>

			<div class="clearfix"></div>

		</div>  <!-- row -->

	</form>

</div>  <!-- container -->


<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready(function(){

	$(".niveau").click(function(){
		// suppression de tous les coches ailleurs
		$(".niveau").nextAll("ul").find("li input:checkbox").prop("checked", false);
		// ajout des checked sur le niveau sélectionné
		$(this).nextAll("ul").find("li input:checkbox").prop("checked","checked")
		})

	$(".classe").click(function(){
		$("#niveaux").find("input:checkbox").not($(this).parent().parent().find("input:checkbox")).attr("checked", false);
		$(".niveau").siblings().next().filter("input").attr("checked", false);
		$(this).parent().parent().parent().find("input:radio").attr("checked", true);
		})

	$(".collapsible").click(function(){
		$(this).parent().children().filter("ul").toggle("slow")
		})

	$(".collapsible").parent().children().filter("ul").hide();

	$("#reset").click(function(){
		$(".classe").attr("checked", false);
		})

	$("#formulaire").submit(function(){
		$.blockUI();
		$("#wait").show();
		})
})

<?php echo '</script'; ?>
>
<?php }
}
