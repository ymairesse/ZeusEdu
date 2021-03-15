<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 10:59:37
  from '/home/yves/www/sio2/peda/bullISND/templates/delibe/feuilleDelibes.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604dde89810b25_82034476',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'b8a38f507f697408b92c8030c2b0011ec5f03ada' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/delibe/feuilleDelibes.tpl',
      1 => 1587142516,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604dde89810b25_82034476 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_checkPlugins(array(0=>array('file'=>'/home/yves/www/sio2/peda/smarty/plugins/modifier.truncate.php','function'=>'smarty_modifier_truncate',),));
?>
<div class="container-fluid">

<h2>Classe: | <?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
 | <?php echo implode($_smarty_tpl->tpl_vars['titusClasse']->value,',');?>
 -> Période: <?php echo $_smarty_tpl->tpl_vars['bulletin']->value;?>
</h2>

<div class="table-responsive">

	<table class="table table-condensed table-hover fdelibe">
		<thead>

		<tr>
			<th style="vertical-align: bottom;">
				<p>Nom de l'élève</p>
			</th>

			<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCours']->value, 'detailsCours', false, 'cours');
$_smarty_tpl->tpl_vars['detailsCours']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['cours']->value => $_smarty_tpl->tpl_vars['detailsCours']->value) {
$_smarty_tpl->tpl_vars['detailsCours']->do_else = false;
?>
			<th>
				<span class="pop"
					  style="cursor:pointer"
					  data-content="<?php echo $_smarty_tpl->tpl_vars['detailsCours']->value['cours']['libelle'];?>
<br><?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
"
					  data-html="true"
					  data-container="body"
					  data-placement="left">
				<img src="imagesCours/<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
.png" alt="<?php echo $_smarty_tpl->tpl_vars['cours']->value;?>
"><br>
				<?php echo $_smarty_tpl->tpl_vars['detailsCours']->value['cours']['statut'];?>
<br><?php echo $_smarty_tpl->tpl_vars['detailsCours']->value['cours']['nbheures'];?>
h
				 </span>
			</th>
			<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
			<th><img src="images/moyenne.png" alt="moyenne"></th>
			<th><img src="images/nbEchecs.png" alt="nombre d'échecs"></th>
			<th><img src="images/heuresEchecs.png" alt="nombre d'heures d'échec"></th>
			<th><img src="images/mentionInit.png" alt="mention Initiale"></th>
			<th><img src="images/mentionFinale.png" alt="mention Finale"></th>
			<th><img src="images/decision.png" alt="Décision"></th>
		</tr>

		</thead>

		<!-- fin de l'entête ----------------------------------------------------------------- -->

		<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeEleves']->value, 'unEleve', false, 'matricule');
$_smarty_tpl->tpl_vars['unEleve']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['matricule']->value => $_smarty_tpl->tpl_vars['unEleve']->value) {
$_smarty_tpl->tpl_vars['unEleve']->do_else = false;
?>
		<tr>
			<?php $_smarty_tpl->_assignInScope('nomPrenom', (($_smarty_tpl->tpl_vars['unEleve']->value['nom']).(' ')).($_smarty_tpl->tpl_vars['unEleve']->value['prenom']));?>
			<td class="pop"
				data-content="<img src='../photos/<?php echo $_smarty_tpl->tpl_vars['unEleve']->value['photo'];?>
.jpg' alt='<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
' style='width:100px'><br><?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['nomPrenom']->value,15,'...');?>
<br> <?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
"
				data-html="true"
				data-placement="top"
				data-container="body"
				data-original-title="<?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['nomPrenom']->value,20);?>
">
				<?php if ((isset($_smarty_tpl->tpl_vars['listeEBS']->value[$_smarty_tpl->tpl_vars['matricule']->value]))) {?>
				<a href="../trombiEleves/index.php?action=parEleve&matricule=<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
" target="_blank">
					<i class="fa fa-user-circle-o EBSi"></i>
				</a>
				<?php }?>
				<?php echo $_smarty_tpl->tpl_vars['unEleve']->value['classe'];?>
 <?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['nomPrenom']->value,25,'...');?>

			</td>

			<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCours']->value, 'detailsCours', false, 'cours');
$_smarty_tpl->tpl_vars['detailsCours']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['cours']->value => $_smarty_tpl->tpl_vars['detailsCours']->value) {
$_smarty_tpl->tpl_vars['detailsCours']->do_else = false;
?>
				<?php if (!((isset($_smarty_tpl->tpl_vars['listeCoursListeEleves']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value])))) {?>
					<td class="pasCours">&nbsp;</td>
				<?php } else { ?>
					<?php $_smarty_tpl->_assignInScope('coursGrp', (($tmp = @$_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]['coursGrp'])===null||$tmp==='' ? Null : $tmp));?>
					<?php if ($_smarty_tpl->tpl_vars['coursGrp']->value != Null) {?>
					<?php $_smarty_tpl->_assignInScope('attributDelibe', $_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]['attributDelibe']);?>
					<td class="pop cote <?php echo $_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]['statut'];?>
 <?php echo $_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]['echec'];?>
"
						data-container="body"
						data-original-title="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
"
						data-content="<?php if ($_smarty_tpl->tpl_vars['attributDelibe']->value == 'externe') {?>Épreuve externe<br><?php }?>
									<?php echo implode($_smarty_tpl->tpl_vars['listeCours']->value[$_smarty_tpl->tpl_vars['cours']->value][$_smarty_tpl->tpl_vars['coursGrp']->value]['profs'],'<br>');?>

									<?php if ((isset($_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]['choixProf']))) {?>
										<br>Sit. interne <?php echo $_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]['situationPourcent'];?>
%
									<?php }?>"
						data-placement="top"
						data-html="true">
						<?php if ($_smarty_tpl->tpl_vars['attributDelibe']->value == 'hook') {?>
							[<?php echo (($tmp = @$_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]['sitDelibe'])===null||$tmp==='' ? '&nbsp;' : $tmp);?>
]
						<?php } else { ?>
							<?php echo (($tmp = @$_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]['sitDelibe'])===null||$tmp==='' ? '&nbsp;' : $tmp);?>

							<?php echo $_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]['symbole'];?>

						<?php }?>
					</td>
					<?php } else { ?>
					<td class="cote">-</td>
					<?php }?>
				<?php }?>
			<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

			<td class="delibe"><?php echo (($tmp = @$_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['moyenne'])===null||$tmp==='' ? '&nbsp;' : $tmp);?>
</td>
			<td class="pop delibe"
				<?php if (($_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['nbEchecs'] > 0)) {?>
					data-original-title="<?php echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['nbEchecs'];?>
 échec(s)"
					data-content="<?php echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['nbHeuresEchec'];?>
h|<?php echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['coursEchec'];?>
"
					data-html="true"
					data-placement="top"
					data-container="body"
				<?php }?>>
				<?php if (($_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['nbEchecs'] > 0)) {
echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['nbEchecs'];
} else { ?>&nbsp;<?php }?>
			</td>
			<td class="pop delibe"
				<?php if ($_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['nbEchecs'] > 0) {?>
					data-original-title="<?php echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['nbEchecs'];?>
 échec(s) <?php echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['nbHeuresEchec'];?>
h de cours "
					data-content="<?php echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['coursEchec'];?>
"
					data-html="true"
					data-placement="top"
					data-container="body"
				<?php }?>>
				<?php if ($_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['nbEchecs'] > 0) {
echo (($tmp = @$_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['nbHeuresEchec'])===null||$tmp==='' ? '-' : $tmp);?>
h<?php } else { ?>&nbsp;<?php }?>
			</td>
			<td class="cote delibe"><?php echo (($tmp = @$_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['matricule']->value]['mention'])===null||$tmp==='' ? '&nbsp;' : $tmp);?>
</td>
			<td class="delibe"><?php echo (($tmp = @$_smarty_tpl->tpl_vars['listeMentions']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['ANNEESCOLAIRE']->value][$_smarty_tpl->tpl_vars['annee']->value][$_smarty_tpl->tpl_vars['bulletin']->value])===null||$tmp==='' ? '&nbsp;' : $tmp);?>
</td>
			<td class="cote<?php if ($_smarty_tpl->tpl_vars['listeDecisions']->value[$_smarty_tpl->tpl_vars['matricule']->value]['decision'] == 'Échec') {?> echec<?php }?>">
				<?php if ($_smarty_tpl->tpl_vars['listeDecisions']->value[$_smarty_tpl->tpl_vars['matricule']->value]['decision'] == 'Échec') {?>
						<strong title="Échec">X</strong>
					<?php } elseif ($_smarty_tpl->tpl_vars['listeDecisions']->value[$_smarty_tpl->tpl_vars['matricule']->value]['decision'] == 'Restriction') {?>
						<strong title="Accès à <?php echo $_smarty_tpl->tpl_vars['listeDecisions']->value[$_smarty_tpl->tpl_vars['matricule']->value]['restriction'];?>
" style="cursor:pointer">R</strong>
					<?php } else { ?>
					-
				<?php }?>
			</td>
		</tr>
		<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
	</table>

</div>  <!-- table-responsive -->

<?php echo count($_smarty_tpl->tpl_vars['listeEleves']->value);?>
 élèves

<p class="notice">Ce document est basé sur les cotes de délibération fournies dans le bulletin. Il ne devient définitif que la veille de la délibération à 17h00</p>

<p>Symbolique:</p>
<ul class="symbolique">
<li>² => réussite degré</li>
<li>* => cote étoilée</li>
<li>↗ => baguette magique</li>
<li>~ => reussite 50%</li>
<li>$ => épreuve externe</li>
<li>[xx] => non significatif</li>
</ul>

</div>
<?php }
}
