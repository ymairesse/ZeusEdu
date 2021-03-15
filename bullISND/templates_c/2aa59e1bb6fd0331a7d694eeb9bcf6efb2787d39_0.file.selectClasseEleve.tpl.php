<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 20:03:30
  from '/home/yves/www/sio2/peda/bullISND/templates/selecteurs/selectClasseEleve.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5e02a6a052_24669856',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '2aa59e1bb6fd0331a7d694eeb9bcf6efb2787d39' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selecteurs/selectClasseEleve.tpl',
      1 => 1595692684,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:listeEleves.tpl' => 1,
  ),
),false)) {
function content_604e5e02a6a052_24669856 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

		<select name="classe" id="selectClasse" class="form-control input-sm">
		<option value="">Classe</option>
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeClasses']->value, 'uneClasse');
$_smarty_tpl->tpl_vars['uneClasse']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['uneClasse']->value) {
$_smarty_tpl->tpl_vars['uneClasse']->do_else = false;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['uneClasse']->value;?>
"<?php if ($_smarty_tpl->tpl_vars['uneClasse']->value == $_smarty_tpl->tpl_vars['classe']->value) {?> selected="selected"<?php }?>><?php echo $_smarty_tpl->tpl_vars['uneClasse']->value;?>
</option>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
		</select>

		<?php if ((isset($_smarty_tpl->tpl_vars['prevNext']->value['prev']))) {?>
			<?php $_smarty_tpl->_assignInScope('matrPrev', $_smarty_tpl->tpl_vars['prevNext']->value['prev']);?>
			<button class="btn btn-default btn-xs" id="prev" title="Précédent: <?php echo $_smarty_tpl->tpl_vars['listeEleves']->value[$_smarty_tpl->tpl_vars['matrPrev']->value]['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['listeEleves']->value[$_smarty_tpl->tpl_vars['matrPrev']->value]['nom'];?>
">
				<span class="glyphicon glyphicon-chevron-left"></span>
			</button>
		<?php }?>

		<span id="choixEleve">

		<?php $_smarty_tpl->_subTemplateRender('file:listeEleves.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>

		</span>

		<?php if ((isset($_smarty_tpl->tpl_vars['prevNext']->value['next']))) {?>
			<?php $_smarty_tpl->_assignInScope('matrNext', $_smarty_tpl->tpl_vars['prevNext']->value['next']);?>
			<button class="btn btn-default btn-xs" id="next" title="Suivant: <?php echo $_smarty_tpl->tpl_vars['listeEleves']->value[$_smarty_tpl->tpl_vars['matrNext']->value]['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['listeEleves']->value[$_smarty_tpl->tpl_vars['matrNext']->value]['nom'];?>
">
				<span class="glyphicon glyphicon-chevron-right"></span>
			 </button>
		<?php }?>


	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
	<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
	<?php if ((isset($_smarty_tpl->tpl_vars['prevNext']->value))) {?>
		<input type="hidden" name="prev" value="<?php echo $_smarty_tpl->tpl_vars['prevNext']->value['prev'];?>
" id="matrPrev">
		<input type="hidden" name="next" value="<?php echo $_smarty_tpl->tpl_vars['prevNext']->value['next'];?>
" id="matrNext">
	<?php }?>
	<input type="hidden" name="etape" value="showEleve">
	<input type="hidden" name="onglet" class="onglet" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['onglet']->value)===null||$tmp==='' ? 0 : $tmp);?>
">
	</form>

</div>

<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectEleve").val() != '') {
			$("#wait").show();
			}
			else return false;
	})


	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
		var classe = $(this).val();

		if (classe != '') $("#envoi").show();
		// la fonction listeEleves.inc.php renvoie la liste déroulante
		// des élèves de la classe sélectionnée
		$.post("inc/listeEleves.inc.php",
			{ 'classe': classe },
				function (resultat) {
					$("#choixEleve").html(resultat)
				}
			)
	});

	$("#choixEleve").on("change", "#selectEleve", function(){
		if ($(this).val() > 0) {
			// si la liste de sélection des élèves renvoie une valeur significative, le formulaire est soumis
			$("#formSelecteur").submit();
			$("#envoi").show();
			}
		})

	$("#prev").click(function(){
		var matrPrev = $("#matrPrev").val();
		$("#selectEleve").val(matrPrev);
		$("#formSelecteur").submit();
	})

	$("#next").click(function(){
		var matrNext = $("#matrNext").val();
		$("#selectEleve").val(matrNext);
		$("#formSelecteur").submit();
	})
})

<?php echo '</script'; ?>
>
<?php }
}
