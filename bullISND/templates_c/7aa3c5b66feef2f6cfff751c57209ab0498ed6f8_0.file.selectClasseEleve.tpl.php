<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 10:38:35
  from '/home/yves/www/sio2/peda/bullISND/templates/selectClasseEleve.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604dd99be62752_68584911',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '7aa3c5b66feef2f6cfff751c57209ab0498ed6f8' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selectClasseEleve.tpl',
      1 => 1595672766,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:listeEleves.tpl' => 1,
  ),
),false)) {
function content_604dd99be62752_68584911 (Smarty_Internal_Template $_smarty_tpl) {
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

	<div class="btn-group pull-right">
		<button type="button"
			class="btn btn-info"
			title="Sélection de périodes supplémentaires"
		 	id="plusPeriode">
			<i class="fa fa-plus"></i> Périodes suppl.
		</button>

		<button type="button"
			class="btn pull-right <?php if ($_smarty_tpl->tpl_vars['mentionsSelect']->value != Null) {?>btn-danger<?php } else { ?>btn-primary<?php }?>"
			title="<?php if ($_smarty_tpl->tpl_vars['mentionsSelect']->value != Null) {?>Mentions filtrées: <?php echo implode($_smarty_tpl->tpl_vars['mentionsSelect']->value,', ');
} else { ?>Aucun filtre<?php }?>"
			id="filtre">
			<i class="fa fa-filter"></i> Filtrer<?php if ($_smarty_tpl->tpl_vars['mentionsSelect']->value != Null) {?> Période <?php echo $_smarty_tpl->tpl_vars['periodeSelect']->value;?>
 [<?php echo implode($_smarty_tpl->tpl_vars['mentionsSelect']->value,', ');?>
]<?php }?>
		</button>
	</div>


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

<div id="modal">
</div>

<?php echo '<script'; ?>
 type="text/javascript">

$(document).ready (function() {

	$("#formSelecteur").submit(function(){
		if ($("#selectEleve").val() != '') {
			$("#wait").show();
			$.blockUI();
			}
			else return false;
	})

	$('#plusPeriode').click(function(){
		$.post('inc/delibe/modalAddPeriodes.inc.php', {
		}, function(resultat){
			$('#modal').html(resultat);
			$('#modalAddPeriode').modal('show');
		})
	})

	$('#modal').on('click', '#btn-addPeriodes', function(){
		var formulaire = $('#formAddPeriodes').serialize();
		$.post('inc/delibe/addPeriodes.inc.php', {
			formulaire: formulaire
		}, function(resultat){
			$('#modalAddPeriode').modal('hide');
			location.reload();
		})
	})

	$('#filtre').click(function(){
		$.post('inc/delibe/modalFiltrer.inc.php', {
		}, function(resultat){
			$('#modal').html(resultat);
			$('#modalFiltrer').modal('show');
		})
	})

	$('#modal').on('click', '#activerFiltre', function(){
		if ($('#formFiltre').valid()) {
			var formulaire = $('#formFiltre').serialize();
			$.post('inc/delibe/activerFiltre.inc.php', {
				formulaire: formulaire
			}, function(resultat){
				$('#modalFiltrer').modal('hide');
				 location.reload();
			})
		}
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
			// else $("#envoi").hide();
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
