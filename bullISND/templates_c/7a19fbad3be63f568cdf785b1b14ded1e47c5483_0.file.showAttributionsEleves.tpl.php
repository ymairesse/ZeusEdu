<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:57:32
  from '/home/yves/www/sio2/peda/bullISND/templates/showAttributionsEleves.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5c9c3962c6_84826988',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '7a19fbad3be63f568cdf785b1b14ded1e47c5483' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/showAttributionsEleves.tpl',
      1 => 1477678493,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
    'file:listeElevesDel.tpl' => 1,
    'file:listeElevesAdd.tpl' => 1,
  ),
),false)) {
function content_604e5c9c3962c6_84826988 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container">

	 <?php if ((count($_smarty_tpl->tpl_vars['listeCoursGrp']->value) > 0)) {?>

	<form name="mouvementsEleves" id="mouvementsEleves" method="POST" action="index.php" class="form-vertical">

		<h2>Attribution des élèves aux cours</h2>

		<div class="row">

			<div class="col-md-6 col-xs-12">

				<div class="form-group">
					<label for="coursGrp">Cours</label>
					<select name="coursGrp" id="coursGrp" class="form-control">
						<option value=''>Sélectionnez un cours</option>
						<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCoursGrp']->value, 'details', false, 'leCoursGrp');
$_smarty_tpl->tpl_vars['details']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['leCoursGrp']->value => $_smarty_tpl->tpl_vars['details']->value) {
$_smarty_tpl->tpl_vars['details']->do_else = false;
?>
						<option value="<?php echo $_smarty_tpl->tpl_vars['leCoursGrp']->value;?>
" <?php if ((isset($_smarty_tpl->tpl_vars['coursGrp']->value)) && ($_smarty_tpl->tpl_vars['coursGrp']->value == $_smarty_tpl->tpl_vars['leCoursGrp']->value)) {?> selected="selected" <?php }?>><?php echo $_smarty_tpl->tpl_vars['leCoursGrp']->value;?>
 - <?php echo $_smarty_tpl->tpl_vars['details']->value['statut'];?>
 <?php echo $_smarty_tpl->tpl_vars['details']->value['libelle'];?>
 <?php echo $_smarty_tpl->tpl_vars['details']->value['nbheures'];?>
h <?php echo $_smarty_tpl->tpl_vars['details']->value['acronyme'];?>
</option>
						<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
					</select>
				</div>

			</div>

			<div class="col-md-6 col-sm-12">
				<p><strong>Depuis la période</strong></p>
				<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode', false, 'wtf');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['wtf']->value => $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
					<label class="radio-inline">
		 				<input type="radio" name="bulletin" value="<?php echo $_smarty_tpl->tpl_vars['periode']->value;?>
" <?php if ((isset($_smarty_tpl->tpl_vars['bulletin']->value)) && ($_smarty_tpl->tpl_vars['periode']->value == $_smarty_tpl->tpl_vars['bulletin']->value)) {?> checked="checked" <?php }?>><?php echo $_smarty_tpl->tpl_vars['periode']->value;?>

	   				</label>
				<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

			</div>
			<!-- col-md... -->

		</div>
		<!-- row -->

		<div class="row">

			<div class="col-md-5 col-sm-12" id="blocGauche" style="display:none">
				<div class="panel panel-default">
				  <div class="panel-heading">
				    <h3 class="panel-title">Élèves à enlever</h3>
				  </div>
				  <div class="panel-body">
					  <div id="profsElevesDel">
						  <?php if ((isset($_smarty_tpl->tpl_vars['coursGrp']->value))) {?>
							  <?php $_smarty_tpl->_subTemplateRender('file:listeElevesDel.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
						  <?php }?>
					  </div>
					  <button type="button" class="btn btn-primary btn-block" id="nbDel">Désélectionner tout</button>
				  </div>

				</div>

			</div>
			<!-- col-md... -->

			<div class="col-md-2 col-sm-12" id="btnCenter" style="display:none">
				<button type="submit" name="button" class="btn btn-primary btn-block" id="moveEleves" style="margin-top:5em"><< >></button>
			</div>
			<!-- col-md... -->

			<div class="col-md-5 col-sm-12" id="blocDroit" style="display:none">

				<div class="panel panel-default">
				  <div class="panel-heading">
					  <h3 class="panel-title">Élèves à ajouter</h3>
				  </div>
				  <div class="panel-body">
					  <label for="niveau">Niveau</label>
					  <select name="niveau" id="niveau" class="form-control">
						  <option value="">Niveau d'étude</option>
						  <?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeNiveaux']->value, 'unNiveau');
$_smarty_tpl->tpl_vars['unNiveau']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unNiveau']->value) {
$_smarty_tpl->tpl_vars['unNiveau']->do_else = false;
?>
						  <option value="<?php echo $_smarty_tpl->tpl_vars['unNiveau']->value;?>
" <?php if ((isset($_smarty_tpl->tpl_vars['niveau']->value)) && ($_smarty_tpl->tpl_vars['unNiveau']->value == $_smarty_tpl->tpl_vars['niveau']->value)) {?> selected="selected" <?php }?>><?php echo $_smarty_tpl->tpl_vars['unNiveau']->value;?>
e année</option>
						  <?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
					  </select>

					  <div id="blocElevesAdd">
						  <?php $_smarty_tpl->_subTemplateRender('file:listeElevesAdd.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, $_smarty_tpl->cache_lifetime, array(), 0, false);
?>
					  </div>

					  <button type="button" class="btn btn-primary btn-block" id="nbAdd">Désélectionner tout</button>
				  </div>

				</div>

			</div>
			<!-- col-md... -->

			<input type="hidden" name="cours" value="<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
">
			<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
			<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
			<input type="hidden" name="etape" value="enregistrer">

		</div>
		<!-- row -->

	</form>
	<?php }?>

</div>
<!-- container -->

<?php echo '<script'; ?>
 type="text/javascript">
	$(document).ready(function() {

		if ($("#coursGrp").val() != '') {
			$("#blocGauche, #blocDroit, #btnCenter").fadeIn();
		} else $("#blocGauche, #blocDroit, #btnCenter").fadeOut();

		$("#coursGrp").change(function() {
			var coursGrp = $(this).val();
			if (coursGrp != '') {
				$.post('inc/profsElevesDel.inc.php', {
						'coursGrp': coursGrp
					},
					function(resultat) {
						$("#profsElevesDel").html(resultat);
					}
				);
				$("#blocGauche, #blocDroit, #btnCenter").fadeIn();
			} else {
				$("#profsEleveDel").html('');
				$("#blocGauche, #blocDroit, #btnCenter").fadeOut();
			}
		})

		$("#niveau").change(function() {
			var niveau = $(this).val();
			if (niveau != '')
				$.post('inc/listeElevesNiveau.inc.php', {
						'niveau': niveau
					},
					function(resultat) {
						$("#blocElevesAdd").html(resultat);
					}
				);
			else {
				$("#blocElevesAdd").html('');
			}
		})

		$("#moveEleves").click(function() {
			var nbEleves = $("#listeElevesDel option:selected").length + $("#listeElevesAdd option:selected").length;
			if (nbEleves == 0) {
				alert("Veuillez sélectionner au moins un élève à déplacer");
				return false;
			} else {
				var del = $("#listeElevesDel option:selected").length;
				var add = $("#listeElevesAdd option:selected").length;
				var texte = "Veuillez confirmer \n";
				if (del > 0)
					texte = texte + "La suppression de " + del + " élève(s) de ce cours\n";
				if (add > 0)
					texte = texte + "L\'ajout de " + add + " élève(s) à ce cours";
				return confirm(texte);
			}
		})

		$("#blocGauche").on("change", "#listeElevesDel", function() {
			var nbEleves = $("#listeElevesDel option:selected").length;
			$("#nbDel").text("Sélection: " + nbEleves + " élève(s)").fadeIn();
		})

		$("#blocDroit").on("change", "#listeElevesAdd", function() {
			var nbEleves = $("#listeElevesAdd option:selected").length;
			$("#nbAdd").text("Sélection: " + nbEleves + " élève(s)").fadeIn();
		})

		$("#blocDroit").on("click", "#nbAdd", function() {
			$("#listeElevesAdd option").removeAttr('selected');
			$(this).fadeOut();
		})

		$("#blocGauche").on("click", "#nbDel", function() {
			$("#listeElevesDel option").removeAttr('selected');
			$(this).fadeOut();
		})
	})
<?php echo '</script'; ?>
>
<?php }
}
