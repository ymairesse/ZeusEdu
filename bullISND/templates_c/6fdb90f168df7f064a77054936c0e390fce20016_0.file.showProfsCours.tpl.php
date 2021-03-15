<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 19:49:43
  from '/home/yves/www/sio2/peda/bullISND/templates/showProfsCours.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5ac7e99536_42124233',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '6fdb90f168df7f064a77054936c0e390fce20016' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/showProfsCours.tpl',
      1 => 1477743667,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e5ac7e99536_42124233 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container">

	<?php if ((isset($_smarty_tpl->tpl_vars['coursGrp']->value))) {?>
	<h2>Attribution des cours aux enseignants</h2>
	<div class="row">
		<div class="col-md-6 col-sm-12">
			<form name="supprProfCours" id="supprProfCours" method="POST" action="index.php" class="form-vertical">

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Titulaire(s) du cours <?php if (((isset($_smarty_tpl->tpl_vars['coursGrp']->value)))) {
echo $_smarty_tpl->tpl_vars['coursGrp']->value;
}?></h3>
					</div>
					<div class="panel-body">
						<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeProfsTitulaires']->value, 'prof', false, 'acronyme');
$_smarty_tpl->tpl_vars['prof']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['acronyme']->value => $_smarty_tpl->tpl_vars['prof']->value) {
$_smarty_tpl->tpl_vars['prof']->do_else = false;
?>
						<div class="checkbox">
						  <label>
							  <input type="checkbox" name="supprProf[]" value="<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
" title="Cochez pour supprimer"> <?php echo $_smarty_tpl->tpl_vars['prof']->value;?>

						  </label>
						</div>
						<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

						<input type="hidden" name="coursGrp" value="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
">
						<input type="hidden" name="action" value="admin">
						<input type="hidden" name="mode" value="attributionsProfs">
						<input type="hidden" name="etape" value="supprProfs">
						<button class="btn btn-primary btn-block" type="submit" name="Envoyer">Supprimer les enseignants sélectionnés <span class="glyphicon glyphicon-arrow-right"></span></button>
						<input type="hidden" name="niveau" value="<?php echo $_smarty_tpl->tpl_vars['niveau']->value;?>
">

						<h4>Élèves inscrits (pour information)</h4>
						<select size="15" name="eleves" id="eleves" class="form-control" readonly>
							<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeEleves']->value, 'eleve', false, 'matricule');
$_smarty_tpl->tpl_vars['eleve']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['matricule']->value => $_smarty_tpl->tpl_vars['eleve']->value) {
$_smarty_tpl->tpl_vars['eleve']->do_else = false;
?>
							<option value="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['eleve']->value['classe'];?>
 - <?php echo $_smarty_tpl->tpl_vars['eleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['eleve']->value['prenom'];?>
</option>
							<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
						</select>
					</div>
					<div class="panel-footer">
						Liste des élèves "pour mémoire"
					</div>

				</div>

			</form>
		</div>
		<!-- col-md... -->

		<div class="col-md-6 col-sm-12">

			<form name="addProfCours" id="addProfCours" method="POST" action="index.php" class="form-vertical">

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Professeurs à affecter au cours</h3>
					</div>
					<div class="panel-body">
						<select multiple="multiple" size="15" name="addProf[]" value="" class="form-control">
							<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeTousProfs']->value, 'prof', false, 'acronyme');
$_smarty_tpl->tpl_vars['prof']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['acronyme']->value => $_smarty_tpl->tpl_vars['prof']->value) {
$_smarty_tpl->tpl_vars['prof']->do_else = false;
?>
							<option value="<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['prof']->value['acronyme'];?>
: <?php echo $_smarty_tpl->tpl_vars['prof']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
</option>
							<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
						</select>

						<input type="hidden" name="coursGrp" value="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
">
						<input type="hidden" name="action" value="admin">
						<input type="hidden" name="mode" value="attributionsProfs">
						<input type="hidden" name="etape" value="addProfs">
						<button button class="btn btn-primary btn-block" name="Envoyer" type="submit"><span class="glyphicon glyphicon-arrow-left"></span> Ajouter les enseignants sélectionnés</button>
						<input type="hidden" name="niveau" value="<?php echo $_smarty_tpl->tpl_vars['niveau']->value;?>
">
					</div>

				</div>
				<div class="panel-footer">
					Vous pouvez sélectionner plusieurs profs (touche Ctrl enfoncée)
				</div>

			</form>

		</div>
		<!-- col-md-... -->

	</div>
	<!-- row -->
	<?php }?>

</div>

<?php echo '<script'; ?>
 type="text/javascript">
	$(document).ready(function() {
		$("#supprProfCours").submit(function() {
			$.blockUI();
			$("#wait").show();
		})

		$("#addProfCours").submit(function() {
			$.blockUI();
			$("#wait").show();
		})


	})
<?php echo '</script'; ?>
>
<?php }
}
