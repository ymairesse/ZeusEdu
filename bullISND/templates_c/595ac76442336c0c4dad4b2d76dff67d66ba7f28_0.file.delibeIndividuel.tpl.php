<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 10:38:42
  from '/home/yves/www/sio2/peda/bullISND/templates/delibe/delibeIndividuel.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604dd9a2cc70f4_38044403',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '595ac76442336c0c4dad4b2d76dff67d66ba7f28' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/delibe/delibeIndividuel.tpl',
      1 => 1606637546,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604dd9a2cc70f4_38044403 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_checkPlugins(array(0=>array('file'=>'/home/yves/www/sio2/peda/smarty/plugins/modifier.truncate.php','function'=>'smarty_modifier_truncate',),));
?>
<div class="container-fluid">

	<h2><?php echo $_smarty_tpl->tpl_vars['eleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['eleve']->value['prenom'];?>
</h2>

	<div class="row">

		<div class="col-md-10 col-sm-12">

			<form name="form" method="POST" action="index.php" id="formulaire" role="form" class="form-inline">
				<input type="hidden" name="action" value="delibes">
				<input type="hidden" name="mode" value="individuel">
				<input type="hidden" name="etape" value="enregistrer">
				<input type="hidden" name="classe" value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
">
				<input type="hidden" name="matricule" value="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
">
				<input type="hidden" name="mailEleve" value="<?php echo $_smarty_tpl->tpl_vars['decision']->value['adresseMail'];?>
">
				<input type="hidden" name="bulletin" value="<?php echo $_smarty_tpl->tpl_vars['NBPERIODES']->value;?>
">

				<div class="table-responsive">

					<table class="table table-hover table-condensed" id="delibeIndividuel">
						<thead>
							<tr>
								<th>Cours</th>
								<th>&nbsp;</th>
								<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
								<th style="width:4em">Pér. <?php echo $_smarty_tpl->tpl_vars['periode']->value;?>
</th>
								<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
								<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
								<th style="width:30%">Remarques Période <?php echo $_smarty_tpl->tpl_vars['periode']->value;?>
</th>
								<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
								<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listesSyntheses']->value, 'dataSynthese', false, 'unePeriode');
$_smarty_tpl->tpl_vars['dataSynthese']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unePeriode']->value => $_smarty_tpl->tpl_vars['dataSynthese']->value) {
$_smarty_tpl->tpl_vars['dataSynthese']->do_else = false;
?>
								<th style="width:4em">
									Pér. <?php echo $_smarty_tpl->tpl_vars['unePeriode']->value;?>
 /100
								</th>
								<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
							</tr>
						</thead>

						<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCours']->value, 'unCours', false, 'coursGrp');
$_smarty_tpl->tpl_vars['unCours']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['unCours']->value) {
$_smarty_tpl->tpl_vars['unCours']->do_else = false;
?>
							<tr class="<?php echo $_smarty_tpl->tpl_vars['unCours']->value['statut'];?>
">
								<td style="width:30%" class="pop" data-container="body" data-original-title="<?php echo $_smarty_tpl->tpl_vars['unCours']->value['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['unCours']->value['nom'];?>
" data-content="<?php echo $_smarty_tpl->tpl_vars['unCours']->value['libelle'];?>
<br><span class='discret'><?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
</span>" data-html="true">
									<?php echo $_smarty_tpl->tpl_vars['unCours']->value['statut'];?>
: <?php echo $_smarty_tpl->tpl_vars['unCours']->value['libelle'];?>

								</td>

								<td><?php echo $_smarty_tpl->tpl_vars['unCours']->value['nbheures'];?>
h</td>
								<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
									<?php if ((isset($_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value]))) {?>
									<td class="cote <?php if (($_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value]['sitDelibe'] < 50) && (trim($_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value]['sitDelibe']) != '') && ($_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value]['attributDelibe'] != 'hook')) {?>echec<?php }?>"
																						<?php if ((isset($_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value]['pourcent']))) {?>
												title="Situation interne <?php echo $_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value]['pourcent'];?>
%"
												data-container="body"
											<?php }?>>
										<?php if ($_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value]['attributDelibe'] == 'hook') {?>[<?php echo (($tmp = @$_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value]['sitDelibe'])===null||$tmp==='' ? '&nbsp;' : $tmp);?>
] <?php } else { ?> <?php echo (($tmp = @$_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value]['sitDelibe'])===null||$tmp==='' ? '&nbsp;' : $tmp);
echo $_smarty_tpl->tpl_vars['listeSituations']->value[$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value]['symbole'];?>
 <?php }?>
									</td>
								<?php } else { ?>
									<td>&nbsp;</td>
								<?php }?>
								<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

								<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
									<td class="remarqueDelibe pop" data-container="body" data-original-title="<?php echo $_smarty_tpl->tpl_vars['unCours']->value['prenom'];?>
 <?php echo $_smarty_tpl->tpl_vars['unCours']->value['nom'];?>
" data-content="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['listeRemarques']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value])===null||$tmp==='' ? '' : $tmp);?>
" data-placement="top" data-html="true">
										<?php echo smarty_modifier_truncate((($tmp = @$_smarty_tpl->tpl_vars['listeRemarques']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['coursGrp']->value][$_smarty_tpl->tpl_vars['periode']->value])===null||$tmp==='' ? '&nbsp;' : $tmp),80);?>

									</td>
								<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

								<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listesSyntheses']->value, 'dataSynthese', false, 'unePeriode');
$_smarty_tpl->tpl_vars['dataSynthese']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unePeriode']->value => $_smarty_tpl->tpl_vars['dataSynthese']->value) {
$_smarty_tpl->tpl_vars['dataSynthese']->do_else = false;
?>
									<?php $_smarty_tpl->_assignInScope('cours', substr($_smarty_tpl->tpl_vars['coursGrp']->value,0,strpos($_smarty_tpl->tpl_vars['coursGrp']->value,'-')));?>
									<?php $_smarty_tpl->_assignInScope('points100', (($tmp = @$_smarty_tpl->tpl_vars['listesSyntheses']->value[$_smarty_tpl->tpl_vars['unePeriode']->value][$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['cours']->value]['sit100'])===null||$tmp==='' ? '-' : $tmp));?>
									<td class="synthese<?php if (is_numeric($_smarty_tpl->tpl_vars['points100']->value) && $_smarty_tpl->tpl_vars['points100']->value < 50) {?> echec<?php }?>">
										<?php echo $_smarty_tpl->tpl_vars['points100']->value;?>

									</td>
								<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

							</tr>
						<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

						<tr class="conclusionDelibe">
							<td>Moyennes</td>
							<td>&nbsp;</td>
							<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
								<td class="cote <?php ob_start();
echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['periode']->value]['moyenne'];
$_prefixVariable1 = ob_get_clean();
ob_start();
echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['periode']->value]['moyenne'];
$_prefixVariable2 = ob_get_clean();
if ($_prefixVariable1 && $_prefixVariable2 < 50) {?>echec<?php }?>">
									<strong><?php echo (($tmp = @$_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['periode']->value]['moyenne'])===null||$tmp==='' ? '&nbsp;' : $tmp);?>
</strong>
								</td>
							<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
							<td colspan="2">&nbsp;</td>
						</tr>

						<tr class="conclusionDelibe">
							<td>Nb Echecs</td>
							<td>&nbsp;</td>
							<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
							<td class="cote">
								<?php if ($_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['periode']->value]['nbEchecs'] > 0) {?>
									<strong><?php echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['periode']->value]['nbEchecs'];?>
</strong>
								<?php } else { ?>
									&nbsp;
								<?php }?>
							</td>
							<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
							<td colspan="2">&nbsp;</td>
						</tr>

						<tr class="conclusionDelibe">
							<td>Nb Heures Echec</td>
							<td>&nbsp;</td>
							<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
								<td class="cote">
									<?php if ($_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['periode']->value]['nbHeuresEchec'] > 0) {?>
									<strong><?php echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['periode']->value]['nbHeuresEchec'];?>
h</strong>
									<?php } else { ?> &nbsp; <?php }?>
								</td>
							<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
							<td colspan="2">&nbsp;</td>
						</tr>

						<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
						<tr class="conclusionDelibe">
							<td>Cours en échec (pér. <?php echo $_smarty_tpl->tpl_vars['periode']->value;?>
)</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td colspan="2" style="font-size:0.8em"><?php if ($_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['periode']->value]['nbHeuresEchec'] > 0) {
echo $_smarty_tpl->tpl_vars['delibe']->value[$_smarty_tpl->tpl_vars['periode']->value]['cours'];
} else { ?>&nbsp;<?php }?></td>
						</tr>
						<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

						<tr class="conclusionDelibe">
							<td>Mention Initiale</td>
							<td>&nbsp;</td>
							<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
								<td class="cote">
									<strong><?php echo (($tmp = @$_smarty_tpl->tpl_vars['mentions']->value[$_smarty_tpl->tpl_vars['periode']->value])===null||$tmp==='' ? '&nbsp;' : $tmp);?>
</strong>
								</td>
							<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
							<td colspan="2">&nbsp;</td>
						</tr>

						<tr class="decisionDelibe">
							<td>Mention Finale</td>
							<td>&nbsp;</td>

							<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listePeriodes']->value, 'periode');
$_smarty_tpl->tpl_vars['periode']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['periode']->value) {
$_smarty_tpl->tpl_vars['periode']->do_else = false;
?>
							<td class="cote <?php if ((isset($_smarty_tpl->tpl_vars['mentionsAttribuees']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['ANNEESCOLAIRE']->value][$_smarty_tpl->tpl_vars['annee']->value][$_smarty_tpl->tpl_vars['periode']->value])) && $_smarty_tpl->tpl_vars['mentionsAttribuees']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['ANNEESCOLAIRE']->value][$_smarty_tpl->tpl_vars['annee']->value][$_smarty_tpl->tpl_vars['periode']->value] == 'I') {?> echec<?php }?>">
								<?php if ($_smarty_tpl->tpl_vars['estTitulaire']->value) {?>
								<input type="text" name="mentions_<?php echo $_smarty_tpl->tpl_vars['periode']->value;?>
" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['mentionsAttribuees']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['ANNEESCOLAIRE']->value][$_smarty_tpl->tpl_vars['annee']->value][$_smarty_tpl->tpl_vars['periode']->value])===null||$tmp==='' ? '' : $tmp);?>
" class="inputMention form-control" maxlength="6" size="3" <?php if (!($_smarty_tpl->tpl_vars['estTitulaire']->value)) {?> disabled<?php }?>> <?php } else { ?>
								<strong><?php echo (($tmp = @$_smarty_tpl->tpl_vars['mentionsAttribuees']->value[$_smarty_tpl->tpl_vars['matricule']->value][$_smarty_tpl->tpl_vars['ANNEESCOLAIRE']->value][$_smarty_tpl->tpl_vars['annee']->value][$_smarty_tpl->tpl_vars['periode']->value])===null||$tmp==='' ? '&nbsp;' : $tmp);?>
</strong>
								<?php }?>
							</td>
							<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

							<td colspan="2">
								<?php if ($_smarty_tpl->tpl_vars['estTitulaire']->value) {?>
								<button type="button" class="btn btn-primary pop" data-container="body" data-content="Dé/verrouiller" data-placement="top"  id="lock">&nbsp;<i class="fa fa-lock"></i>&nbsp;</button>
																<div class='btn-group' id='submitGroup'>
									<button type='reset' class='btn btn-default' id='annuler'>Annuler</button>
									<button type='submit' class='btn btn-primary' id='submit'>Enregistrer</button>
								</div>
								<?php } else { ?> &nbsp; <?php }?>
							</td>
						</tr>

												<?php if ($_smarty_tpl->tpl_vars['bulletin']->value == $_smarty_tpl->tpl_vars['NBPERIODES']->value) {?>
						<tr class="decisionDelibe">
							<td colspan="2">
								<div class="form-group pull-right">
									<label for="decision" class="sr-only">Décision</label>
									<select name="decision" id="decision" class="form-control" <?php if (!($_smarty_tpl->tpl_vars['estTitulaire']->value)) {?> disabled<?php }?>>
										<option value="">Choisir une décision</option>
										<option value="Réussite" <?php if ((isset($_smarty_tpl->tpl_vars['decision']->value['decision'])) && $_smarty_tpl->tpl_vars['decision']->value['decision'] == 'Réussite') {?> selected<?php }?>>Réussite</option>
										<option value="Échec" <?php if ((isset($_smarty_tpl->tpl_vars['decision']->value['decision'])) && $_smarty_tpl->tpl_vars['decision']->value['decision'] == 'Échec') {?> selected<?php }?>>Échec</option>
										<option value="Ajournement" <?php if ((isset($_smarty_tpl->tpl_vars['decision']->value['decision'])) && $_smarty_tpl->tpl_vars['decision']->value['decision'] == 'Ajournement') {?> selected<?php }?>>Ajournement</option>
										<option value="Restriction" <?php if ((isset($_smarty_tpl->tpl_vars['decision']->value['decision'])) && $_smarty_tpl->tpl_vars['decision']->value['decision'] == 'Restriction') {?> selected<?php }?>>Restriction avec accès en</option>
									</select>
								</div>
							</td>
							<td colspan="4">
								<div class="form-group">
									<label for="restriction" class="sr-only">Accès en</label>
									<input type="text" name="restriction" maxlength="40" <?php if (!($_smarty_tpl->tpl_vars['estTitulaire']->value)) {?> disabled<?php }?> id="restriction" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['decision']->value['restriction'])===null||$tmp==='' ? '' : $tmp);?>
" class="form-control" placeholder="Accès en">
								</div>

							</td>
						</tr>
						<?php }?> 					</table>

				</div>
				<!-- table-responsive -->

				<?php if ($_smarty_tpl->tpl_vars['estTitulaire']->value) {?>
				<!-- Pour le dernière période de l'année scolaire -->
				<?php if ($_smarty_tpl->tpl_vars['bulletin']->value == $_smarty_tpl->tpl_vars['NBPERIODES']->value) {?>
				<div class="form-group">
					<label for="envoiMail">Envoi du mail</label>
					<input type="checkbox"
							value="true"
							name="mail"
							id="envoiMail"
							<?php if ((!((isset($_smarty_tpl->tpl_vars['decision']->value['mail']))) || ((isset($_smarty_tpl->tpl_vars['decision']->value['mail'])) && ($_smarty_tpl->tpl_vars['decision']->value['mail'] == 1)))) {?>checked<?php }?>
							<?php if (!($_smarty_tpl->tpl_vars['estTitulaire']->value)) {?> disabled<?php }?>
							class="form-control">
				</div>

				<div class="form-group">
					<label class="sr-only" for="adresseMail">Email</label>
					<input type="text"
						<?php if ((isset($_smarty_tpl->tpl_vars['decision']->value['adresseMail'])) && ($_smarty_tpl->tpl_vars['decision']->value['adresseMail'] != '')) {?>
							value='<?php echo $_smarty_tpl->tpl_vars['decision']->value['adresseMail'];?>
'
						<?php } else { ?>
							value='<?php echo $_smarty_tpl->tpl_vars['decision']->value['user'];?>
@<?php echo $_smarty_tpl->tpl_vars['decision']->value['mailDomain'];?>
'
						<?php }?>
						name="adresseMail"
						id="adresseMail"
						maxlength="30"
						<?php if (!($_smarty_tpl->tpl_vars['estTitulaire']->value)) {?> disabled<?php }?>
						placeholder="Adresse mail"
						class="form-control">
				</div>

				<div class="form-group">
					<label> Notification THOT</label>
					<input type='checkbox'
							value='true'
							name='notification'
							id='notification'
							<?php if (!($_smarty_tpl->tpl_vars['estTitulaire']->value)) {?> disabled<?php }?>
							<?php if (!((isset($_smarty_tpl->tpl_vars['decision']->value['notification']))) || ((isset($_smarty_tpl->tpl_vars['decision']->value['notification'])) && ($_smarty_tpl->tpl_vars['decision']->value['notification'] == 1))) {?>checked<?php }?>
							class='form-control'>
				</div>

				<?php }?>  
				<div class='clearfix'></div>

				<?php }?>  
				</form>

				<p>Symbolique:</p>
				<ul class='symbolique fdelibe'>
				<li>² => réussite degré</li>
				<li><i class='fa fa-star'></i> => cote étoilée</li>
				<li><i class='fa fa-magic'></i> => baguette magique</li>
				<li><i class='fa fa-graduation-cap'></i> => épreuve externe</li>
				<li>[xx] => non significatif</li>
				</ul>

		</div>  <!-- col-md-... -->

		<div class='col-md-2 col-sm-12'>

			<p id='photoEleve'><img src='../photos/<?php echo $_smarty_tpl->tpl_vars['eleve']->value['photo'];?>
.jpg' alt='<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
' title='<?php echo $_smarty_tpl->tpl_vars['eleve']->value['nom'];
echo $_smarty_tpl->tpl_vars['matricule']->value;?>
' class='photo img-responsive'></p>

		</div>

	</div>  <!-- row -->

</div>  <!-- container -->

<?php echo '<script'; ?>
 type="text/javascript">

var confirmationBeforeUnload ="Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";

$(document).ready(function(){

	var modifie = false;
	var locked = true;

	function modification () {
	if (!(modifie)) {
		modifie = true;
		window.onbeforeunload = function(){
			return confirmationBeforeUnload;
			}
		}
	}

	$('.decisionDelibe input, .decisionDelibe select').attr('disabled','disabled');
	$('#submitGroup button').attr('didabled','disabled').hide();

	$('.inputMention').keyup(function(e){
		var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
		if ((key > 31) || (key == 8)) {
			// modification();
			$(this).val($(this).val().toUpperCase());
			}
		})

		$("#lock2").click(function(){
			if (locked) {
				$('#submitGroup button').attr('disabled',false).fadeIn();
				$('.decisionDelibe input, .decisionDelibe select').attr('disabled',false);
				}
				else {
				$('#submitGroup button').attr('disabled',false).fadeOut();
				$('.decisionDelibe input, .decisionDelibe select').attr('disabled',true);
				};
			locked = !(locked);
			})

	$("#lock").click(function(){
		if (locked) {
			$('#submitGroup button').attr('disabled',false).fadeIn();
			$('.decisionDelibe input, .decisionDelibe select').attr('disabled',false);
			}
			else {
			$('#submitGroup button').attr('disabled',false).fadeOut();
			$('.decisionDelibe input, .decisionDelibe select').attr('disabled',true);
			};
		locked = !(locked);
		})

	$("#decision").change(function(){
		if ($(this).val() != 'Restriction') {
			$("#restriction").val('');
			}
			else $("#restriction").focus();
		});

	$("#restriction").focus(function(){
		if ($("#decision").val() != 'Restriction')
			$("#decision").val('Restriction');
		})

	$("#formulaire").submit(function(){
		if (($('#decision').val() == 'restriction') && $('#restriction').val().trim() == '' ) {
			alert("Vous n'avez pas indiqué les restrictions");
			$('#restriction').focus();
			return false;
			}
		});

	$("#annuler").click(function(){
		if (confirm(confirmationReset)) {
			$("#formulaire")[0].reset();
			modifie = false;
			window.onbeforeunload = function(){};
			return false
			}
		})

})

<?php echo '</script'; ?>
>
<?php }
}
