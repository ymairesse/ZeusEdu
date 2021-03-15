<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 20:03:34
  from '/home/yves/www/sio2/peda/bullISND/templates/programmeEleve.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e5e064e5a27_87785647',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'b1379ee8f9098dc89bef5f05a91d8bffd774268b' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/programmeEleve.tpl',
      1 => 1477679945,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e5e064e5a27_87785647 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_checkPlugins(array(0=>array('file'=>'/home/yves/www/sio2/peda/smarty/plugins/modifier.truncate.php','function'=>'smarty_modifier_truncate',),1=>array('file'=>'/home/yves/www/sio2/peda/smarty/plugins/modifier.replace.php','function'=>'smarty_modifier_replace',),));
?>
<div class="container">

	<h2>Ajout et suppression de cours à un élève</h2>

	<div class="row">

		<div class="col-md-6 col-sm-12">

			<form name="formSuppr" action="index.php" method="POST" id="formSuppr" class="form-vertical">

			<h3 title="matricule <?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
">Programme actuel de cours de <?php echo $_smarty_tpl->tpl_vars['eleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['eleve']->value['prenom'];?>
 : <?php echo $_smarty_tpl->tpl_vars['eleve']->value['classe'];?>
</h3>
				<?php $_smarty_tpl->_assignInScope('size', count($_smarty_tpl->tpl_vars['listeCoursGrp']->value));?>
				<?php if ($_smarty_tpl->tpl_vars['size']->value > 0) {?>
				<p>Nombre de cours: <strong><?php echo $_smarty_tpl->tpl_vars['size']->value;?>
</strong> à la période <strong><?php echo $_smarty_tpl->tpl_vars['bulletin']->value;?>
</strong></p>
				<select name="listeCoursGrp[]" multiple="multiple" id="listeCoursGrp" size="<?php echo $_smarty_tpl->tpl_vars['size']->value;?>
" class="form-control">
					<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCoursGrp']->value, 'details', false, 'coursGrp');
$_smarty_tpl->tpl_vars['details']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['details']->value) {
$_smarty_tpl->tpl_vars['details']->do_else = false;
?>
						<option value="<?php echo $_smarty_tpl->tpl_vars['details']->value['coursGrp'];?>
" title="<?php echo $_smarty_tpl->tpl_vars['details']->value['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['details']->value['nom'];?>
 [<?php echo (($tmp = @$_smarty_tpl->tpl_vars['details']->value['acronyme'])===null||$tmp==='' ? 'non affecté' : $tmp);?>
]">
							[<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
] <?php echo $_smarty_tpl->tpl_vars['details']->value['statut'];?>
 <?php echo $_smarty_tpl->tpl_vars['details']->value['libelle'];?>
 <?php echo $_smarty_tpl->tpl_vars['details']->value['nbheures'];?>
h
						</option>
					<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
				</select>
				<br>
				<button type="submit" name="Supprimer" id="supprimer" class="btn btn-primary btn-block">Supprimer le(s) cours sélectionné(s) >>></button>

				<?php } else { ?>
				<p>Pas de cours affecté(s) à cet(te) élève.</p>
				<?php }?>

				<input type="hidden" name="matricule" value="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
">
				<input type="hidden" name="classe" value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
">
				<input type="hidden" name="action" value="admin">
				<input type="hidden" name="mode" value="programmeEleve">
				<input type="hidden" name="etape" value="supprimer">
				<input type="hidden" name="bulletinDel" id="bulletinDel" value="<?php echo $_smarty_tpl->tpl_vars['bulletin']->value;?>
">

				<?php if (!empty($_smarty_tpl->tpl_vars['historiqueCours']->value)) {?>
				<h3>Historique</h3>
				<table class="tableauBull">
					<tr>
						<th>Cours</th>
						<th>Bulletin</th>
						<th>Mouvement</th>
						</tr>
					<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['historiqueCours']->value[$_smarty_tpl->tpl_vars['matricule']->value], 'mouvements', false, 'coursGrp');
$_smarty_tpl->tpl_vars['mouvements']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['mouvements']->value) {
$_smarty_tpl->tpl_vars['mouvements']->do_else = false;
?>
						<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['mouvements']->value, 'details', false, 'wtf');
$_smarty_tpl->tpl_vars['details']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['wtf']->value => $_smarty_tpl->tpl_vars['details']->value) {
$_smarty_tpl->tpl_vars['details']->do_else = false;
?>
							<tr>
							<td><?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
</td>
							<td><?php echo $_smarty_tpl->tpl_vars['details']->value['bulletin'];?>
</td>
							<td><?php echo $_smarty_tpl->tpl_vars['details']->value['mouvement'];?>
</td>
							</tr>
						<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
					<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
				</table>
				<?php }?>

			</form>

		</div>  <!-- col-md... -->

		<div class="col-md-6 col-sm-12">

			<form name="formAjout" action="index.php" method="POST" id="formAjout" class="form-vertical">

			<h3>Depuis le bulletin...</h3>
				<div id="divBulletin">
				<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode', false, 'wtf');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['wtf']->value => $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
				<label class="radio-inline">
			      <input type="radio" name="bulletin" value="<?php echo $_smarty_tpl->tpl_vars['periode']->value;?>
"<?php if ((isset($_smarty_tpl->tpl_vars['bulletin']->value)) && ($_smarty_tpl->tpl_vars['periode']->value == $_smarty_tpl->tpl_vars['bulletin']->value)) {?> checked="checked"<?php }?>> < <?php echo $_smarty_tpl->tpl_vars['periode']->value;?>

			    </label>
				<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
				</div>

			<h3>Cours à ajouter</h3>
			<!-- liste des cours existants dans l'école -->

			<select id="listeCours" name="listeCours" size="10" style="float:left" class="form-control">
				<option value="">Sélectionnez une branche</option>
				<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeTousCours']->value, 'details', false, 'cours');
$_smarty_tpl->tpl_vars['details']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['cours']->value => $_smarty_tpl->tpl_vars['details']->value) {
$_smarty_tpl->tpl_vars['details']->do_else = false;
?>
					<?php $_smarty_tpl->_assignInScope('unCours', $_smarty_tpl->tpl_vars['listeTousCours']->value[$_smarty_tpl->tpl_vars['cours']->value]);?>
					<option value="<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
 <?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['listeTousCours']->value[$_smarty_tpl->tpl_vars['cours']->value][0]['libelle'],30);?>
 <?php echo $_smarty_tpl->tpl_vars['listeTousCours']->value[$_smarty_tpl->tpl_vars['cours']->value][0]['nbheures'];?>
h <?php echo $_smarty_tpl->tpl_vars['listeTousCours']->value[$_smarty_tpl->tpl_vars['cours']->value][0]['statut'];?>
</option>
				<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
			</select>
			<hr>
			<!-- liste des différents coursGrp existants pour cette matière -->
			<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeTousCours']->value, 'details', false, 'cours');
$_smarty_tpl->tpl_vars['details']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['cours']->value => $_smarty_tpl->tpl_vars['details']->value) {
$_smarty_tpl->tpl_vars['details']->do_else = false;
?>
				<?php $_smarty_tpl->_assignInScope('cours', smarty_modifier_replace(smarty_modifier_replace($_smarty_tpl->tpl_vars['cours']->value,":","_")," ","-"));?>
				<?php $_smarty_tpl->_assignInScope('size', count($_smarty_tpl->tpl_vars['details']->value));?>
				<select id="cg<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
" name="choixCoursGrp" size="<?php echo $_smarty_tpl->tpl_vars['size']->value+1;?>
" class="choixCoursGrp form-control">
					<option value="">Sélectionnez un cours</option>
					<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['details']->value, 'unCoursGrp', false, 'wtf');
$_smarty_tpl->tpl_vars['unCoursGrp']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['wtf']->value => $_smarty_tpl->tpl_vars['unCoursGrp']->value) {
$_smarty_tpl->tpl_vars['unCoursGrp']->do_else = false;
?>
					<option value="<?php echo $_smarty_tpl->tpl_vars['unCoursGrp']->value['coursGrp'];?>
"><?php echo $_smarty_tpl->tpl_vars['unCoursGrp']->value['coursGrp'];?>
 > <?php echo $_smarty_tpl->tpl_vars['unCoursGrp']->value['acronyme'];?>
</option>
					<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
			   </select>
			<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
			<button type="submit" name="ajouter" id="ajouter" class="btn btn-primary btn-block"><<< Ajouter le cours sélectionné</button>

			<input type="hidden" name="matricule" value="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
">
			<input type="hidden" name="classe" value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
">
			<input type="hidden" name="action" value="admin">
			<input type="hidden" name="mode" value="programmeEleve">
			<input type="hidden" name="etape" value="ajouter">
			<input type="hidden" name="coursGrp" value="" id="coursGrp">
			</form>

			<div class="clearfix"></div>

		</div>  <!-- col-md.... -->

	</div>  <!-- row -->

</div>  <!-- container -->


<?php echo '<script'; ?>
 type="text/javascript">

	$(".choixCoursGrp").hide();
	$("#ajouter").hide();

	$("#formSuppr").submit(function(){
		var bulletin = $("#bulletinDel").val();
		var suppr = $("#listeCoursGrp").val();
		if (suppr == null) {
			alert("Veuillez sélectionner au moins un cours");
			return false;
			}
		suppr = suppr.toString()
		while (suppr != (suppr = suppr.replace(',','\n> ')));
		if (confirm("Veuille confirmer la suppression des cours suivants:\n> "+suppr+"\nà partir de la période "+bulletin)) {
			$.blockUI();
			$("#wait").show();
			}
		else return false;
		})

	$("#formAjout").submit(function() {
		if ($("#coursGrp") != '') {
			var bulletin = $("#divBulletin input:radio:checked").val();
			var coursGrp = $("#coursGrp").val();
			var texte = "Veuillez confirmer l'ajout du cours "+coursGrp+"\nà partir de la période "+bulletin
			if (confirm(texte)) {
				$.blockUI();
				$("#wait").show();
				}
			else return false;
			}
			else return false;
		})

	$("#listeCours").click(function(){
		$("#ajouter").hide();
		($("#coursGrp").val(''))
		$(".choixCoursGrp").hide().children("option").attr("selected", false);
		var cours = $(this).val();
		cours = cours.replace(":","_").replace(" ","-");

		$("#cg"+cours).show();
		})

	$(".choixCoursGrp").click(function(){
		$("#coursGrp").val($(this).val());
		$("#ajouter").show();
		})

	$("#ajouter").click(function(){
		if ($("#coursGrp").val() == '') {
			alert("Veuillez sélectionner un cours");
			return false;
			}
		})


<?php echo '</script'; ?>
>
<?php }
}
