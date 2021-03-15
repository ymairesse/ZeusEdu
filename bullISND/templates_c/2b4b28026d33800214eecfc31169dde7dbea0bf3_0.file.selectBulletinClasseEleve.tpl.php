<?php
/* Smarty version 3.1.34-dev-7, created on 2021-02-10 17:56:51
  from '/home/yves/www/sio2/peda/bullISND/templates/selectBulletinClasseEleve.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_602410533d9987_18894849',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '2b4b28026d33800214eecfc31169dde7dbea0bf3' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selectBulletinClasseEleve.tpl',
      1 => 1593335741,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:listeEleves.tpl' => 1,
  ),
),false)) {
function content_602410533d9987_18894849 (Smarty_Internal_Template $_smarty_tpl) {
?><div id="selecteur" class="noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">

		<label for="bulletin">Bulletin n°</label>
		<select name="bulletin" id="bulletin" class="form-control input-sm">
		<?php
$__section_bulletins_0_loop = (is_array(@$_loop=$_smarty_tpl->tpl_vars['nbBulletins']->value+1) ? count($_loop) : max(0, (int) $_loop));
$__section_bulletins_0_start = min(1, $__section_bulletins_0_loop);
$__section_bulletins_0_total = min(($__section_bulletins_0_loop - $__section_bulletins_0_start), $__section_bulletins_0_loop);
$_smarty_tpl->tpl_vars['__smarty_section_bulletins'] = new Smarty_Variable(array());
if ($__section_bulletins_0_total !== 0) {
for ($__section_bulletins_0_iteration = 1, $_smarty_tpl->tpl_vars['__smarty_section_bulletins']->value['index'] = $__section_bulletins_0_start; $__section_bulletins_0_iteration <= $__section_bulletins_0_total; $__section_bulletins_0_iteration++, $_smarty_tpl->tpl_vars['__smarty_section_bulletins']->value['index']++){
?>
			<option value="<?php echo (isset($_smarty_tpl->tpl_vars['__smarty_section_bulletins']->value['index']) ? $_smarty_tpl->tpl_vars['__smarty_section_bulletins']->value['index'] : null);?>
"
					<?php if ((isset($_smarty_tpl->tpl_vars['__smarty_section_bulletins']->value['index']) ? $_smarty_tpl->tpl_vars['__smarty_section_bulletins']->value['index'] : null) == $_smarty_tpl->tpl_vars['bulletin']->value) {?>selected<?php }?>>
				<?php echo (isset($_smarty_tpl->tpl_vars['__smarty_section_bulletins']->value['index']) ? $_smarty_tpl->tpl_vars['__smarty_section_bulletins']->value['index'] : null);?>

			</option>
		<?php
}
}
?>
		</select>

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
			<?php $_smarty_tpl->_subTemplateRender("file:listeEleves.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
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
	<input type="hidden" name="onglet" class="onglet" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['onglet']->value)===null||$tmp==='' ? Null : $tmp);?>
">
	<input type="hidden" name="etape" value="<?php echo $_smarty_tpl->tpl_vars['etape']->value;?>
">
	</form>
</div>

<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready (function() {

	if ($("#selectClasse").val() == '') {
		$("#envoi").hide();
		}
		else $("#envoi").show();

	$("#formSelecteur").submit(function(){
		if (($("#selectClasse").val() == '') || ($("#selectEleve").val() == ''))
			return false;
		})

	$("#bulletin").change(function(){
		// $("#envoi").show();
		})

	$("#selectClasse").change(function(){
		// on a choisi une classe dans la liste déroulante
		var classe = $(this).val();
		Cookies.set('classe', classe);
		if (classe != '') $("#envoi").show();
			else $("#envoi").hide();
		// la fonction listeEleves.inc.php renvoie la liste déroulante
		// des élèves de la classe sélectionnée
		$.post("inc/listeEleves.inc.php", {
			'classe': classe},
			function (resultat){
				$("#choixEleve").html(resultat)
				}
			)
	});

	$("#choixEleve").on("change","#selectEleve", function(){
		if ($(this).val() > 0) {
			var matricule =$('#selectEleve').val()
			Cookies.set('matricule', matricule);
			// si la liste de sélection des élèves renvoie une valeur significative
			// le formulaire est soumis
			$("#formSelecteur").submit();
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
