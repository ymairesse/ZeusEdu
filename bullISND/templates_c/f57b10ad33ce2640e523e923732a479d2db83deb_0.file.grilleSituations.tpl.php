<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-15 10:47:06
  from '/home/yves/www/sio2/peda/bullISND/templates/grilleSituations.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604f2d1a31d175_19848427',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'f57b10ad33ce2640e523e923732a479d2db83deb' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/grilleSituations.tpl',
      1 => 1442758940,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604f2d1a31d175_19848427 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_checkPlugins(array(0=>array('file'=>'/home/yves/www/sio2/peda/smarty/plugins/modifier.replace.php','function'=>'smarty_modifier_replace',),));
?>
<div class="container">

<div class="row">
	<div class="col-md-9 col-sm-9">
		<h2>Situations | classe: <?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
 | Période: <?php echo $_smarty_tpl->tpl_vars['bulletin']->value;?>
</h2>
	</div>
	<div class="col-md-3 col-sm-3">
		<button type="button" class="btn btn-primary btn-lg pull-right" id="readOnlyMax">Figer les maxima</button>
	</div>
</div>  <!-- row -->

<form name="formSituations" id="formSituations" method="POST" action="index.php" role="form" class="form-vertical">
<table class="tableauAdmin table-hover table">

	<tr>
		<th>Nom de l'élève</th>

		<!-- titres des colonnes = noms des cours -->
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCoursClasse']->value, 'detailsCours', false, 'cours');
$_smarty_tpl->tpl_vars['detailsCours']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['cours']->value => $_smarty_tpl->tpl_vars['detailsCours']->value) {
$_smarty_tpl->tpl_vars['detailsCours']->do_else = false;
?>
			<?php $_smarty_tpl->_assignInScope('profs', '');?>
			<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['detailsCours']->value['profs'], 'data', false, 'coursGrp');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
				<?php $_smarty_tpl->_assignInScope('profs', ((((($_smarty_tpl->tpl_vars['data']->value['nom']).("(")).($_smarty_tpl->tpl_vars['data']->value['acronyme'])).(") => ")).($_smarty_tpl->tpl_vars['coursGrp']->value)).("<br>"));?>
			<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
		<th class="pop"
				style="cursor: pointer"
				data-html="true"
				data-placement="right"
				data-container="body"
				data-original-title="<?php echo $_smarty_tpl->tpl_vars['detailsCours']->value['dataCours']['libelle'];?>
"
				data-content = "<?php echo $_smarty_tpl->tpl_vars['profs']->value;?>
">
				<img src="imagesCours/<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
.png" alt="<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
"><br>
				<?php echo $_smarty_tpl->tpl_vars['detailsCours']->value['dataCours']['nbheures'];?>
h <?php echo $_smarty_tpl->tpl_vars['detailsCours']->value['dataCours']['statut'];?>

		</th>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
	</tr>

	<?php $_smarty_tpl->_assignInScope('tabIndex', 1);?>
	<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeEleves']->value, 'detailsEleve', false, 'matricule');
$_smarty_tpl->tpl_vars['detailsEleve']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['matricule']->value => $_smarty_tpl->tpl_vars['detailsEleve']->value) {
$_smarty_tpl->tpl_vars['detailsEleve']->do_else = false;
?>
	<tr class="eleve">
		<td class="pop"
			data-content="<img src='../photos/<?php echo $_smarty_tpl->tpl_vars['detailsEleve']->value['photo'];?>
.jpg' alt='<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
' style='width:100px'><br><span class='micro'><?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
</span>"
			data-container="body"
			data-html="true"
			data-placement="right">
			<?php echo $_smarty_tpl->tpl_vars['detailsEleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['detailsEleve']->value['prenom'];?>

		</td>

		<!-- pour chaque cours existant dans la classe, on recherche le coursGrp de l'élève et la cote de situation -->
		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCoursClasse']->value, 'detailsCours', false, 'cours');
$_smarty_tpl->tpl_vars['detailsCours']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['cours']->value => $_smarty_tpl->tpl_vars['detailsCours']->value) {
$_smarty_tpl->tpl_vars['detailsCours']->do_else = false;
?>

		<td class="inputSituations">
				<?php if ((isset($_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]))) {?>
					<?php $_smarty_tpl->_assignInScope('dataCote', $_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]);?>
					<?php } else { ?>
					<?php $_smarty_tpl->_assignInScope('dataCote', Null);?>
				<?php }?>
				<!-- si l'élève suit ce cours -->
				<?php if ((isset($_smarty_tpl->tpl_vars['listeCoursEleves']->value[$_smarty_tpl->tpl_vars['cours']->value][$_smarty_tpl->tpl_vars['matricule']->value]))) {?>
										<?php $_smarty_tpl->_assignInScope('coursGrp', $_smarty_tpl->tpl_vars['listeCoursEleves']->value[$_smarty_tpl->tpl_vars['cours']->value][$_smarty_tpl->tpl_vars['matricule']->value]['coursGrp']);?>
					<?php $_smarty_tpl->_assignInScope('coursGrpProtect', smarty_modifier_replace($_smarty_tpl->tpl_vars['coursGrp']->value,' ','!'));?>
					<input type="text" size="2" name="sit#eleve_<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
#coursGrp_<?php echo $_smarty_tpl->tpl_vars['coursGrpProtect']->value;?>
"
					value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['dataCote']->value['sit'])===null||$tmp==='' ? '' : $tmp);?>
" tabIndex="<?php echo $_smarty_tpl->tpl_vars['tabIndex']->value;?>
" title="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
: <?php echo $_smarty_tpl->tpl_vars['listeCoursClasse']->value[$_smarty_tpl->tpl_vars['cours']->value]['profs'][$_smarty_tpl->tpl_vars['coursGrp']->value]['acronyme'];?>
">/
					<input type="text" size="2" name="max#eleve_<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
#coursGrp_<?php echo $_smarty_tpl->tpl_vars['coursGrpProtect']->value;?>
"
					value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['dataCote']->value['max'])===null||$tmp==='' ? '' : $tmp);?>
" tabIndex="<?php echo $_smarty_tpl->tpl_vars['tabIndex']->value+1;?>
" class="max">
					<?php $_smarty_tpl->_assignInScope('tabIndex', $_smarty_tpl->tpl_vars['tabIndex']->value+2);?>
				<?php } else { ?>&nbsp;
				<?php }?>

		</td>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
	</tr>
	<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
</table>
<input type="hidden" name="bulletin" value="<?php echo $_smarty_tpl->tpl_vars['bulletin']->value;?>
">
<input type="hidden" name="classe" value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
">
<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
<input type="hidden" name="etape" value="<?php echo $_smarty_tpl->tpl_vars['etape']->value;?>
">
<div class="btn-group">
	<button type="reset" class="btn btn-default">Annuler</button>
	<button type="submit" class="btn btn-primary">Enregistrer</button>
</div>

</form>

</div>

<?php echo '<script'; ?>
 type="text/javascript">

	$(document).ready(function(){

		$("#readOnlyMax").click(function(){
			$(".max").each(function(){
				$(this).prop('disabled', true);
			})
		})

		$("#formSituations").submit(function(){
			// éventuellement, réactiver les maxima
			$(".max").each(function(){
				$(this).prop('disabled', false);
			})
			$.blockUI();
			$("#wait").show();
			})
		})

		$(".pop").popover('hover');
		$(".pop").not(this).popover('hide');

<?php echo '</script'; ?>
>
<?php }
}
