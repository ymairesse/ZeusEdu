<?php /* Smarty version Smarty-3.1.13, created on 2020-01-30 15:54:22
         compiled from "./templates/inc/abonnements.inc.tpl" */ ?>
<?php /*%%SmartyHeaderCode:17093801565e32ee1e357f47-00842923%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '0ef8fd9abca48d09cc3aa5143603ff6c7a98b2b2' => 
    array (
      0 => './templates/inc/abonnements.inc.tpl',
      1 => 1580389762,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '17093801565e32ee1e357f47-00842923',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'listesPerso' => 0,
    'liste' => 0,
    'acronyme' => 0,
    'idListe' => 0,
    'action' => 0,
    'onglet' => 0,
    'abonnesDe' => 0,
    'data' => 0,
    'unAbonne' => 0,
    'listeAbonne' => 0,
    'id' => 0,
    'membresDeAbonne' => 0,
    'acro' => 0,
    'listeProfs' => 0,
    'prenomProf' => 0,
    'nomProf' => 0,
    'listePublie' => 0,
    'membresDePublie' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5e32ee1e374f59_80242045',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5e32ee1e374f59_80242045')) {function content_5e32ee1e374f59_80242045($_smarty_tpl) {?><div class="container-fluid">

	<div class="row">

		<div class="col-md-4 col-sm-12">

			<form name="formStatut" method="POST" action="index.php" id="formStatut" class="form-vertical" role="form">
				<h4>Statut de vos listes personnelles</h4>
				<table class="table table-condensed">
					<tr>
						<th>Nom de la liste</td>
						<th>Privée</td>
						<th>Publiée</td>
					</tr>
					<?php  $_smarty_tpl->tpl_vars['liste'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['liste']->_loop = false;
 $_smarty_tpl->tpl_vars['idListe'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listesPerso']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['liste']->key => $_smarty_tpl->tpl_vars['liste']->value){
$_smarty_tpl->tpl_vars['liste']->_loop = true;
 $_smarty_tpl->tpl_vars['idListe']->value = $_smarty_tpl->tpl_vars['liste']->key;
?>
					<tr>
						<td data-container="body" title="<?php echo (($tmp = @count($_smarty_tpl->tpl_vars['liste']->value['membres']))===null||$tmp==='' ? 0 : $tmp);?>
 membres|<?php  $_smarty_tpl->tpl_vars['wtf'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['wtf']->_loop = false;
 $_smarty_tpl->tpl_vars['acronyme'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['liste']->value['membres']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['wtf']->key => $_smarty_tpl->tpl_vars['wtf']->value){
$_smarty_tpl->tpl_vars['wtf']->_loop = true;
 $_smarty_tpl->tpl_vars['acronyme']->value = $_smarty_tpl->tpl_vars['wtf']->key;
?><?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
 <?php } ?>">
							<input type="text" name="nomListe_<?php echo $_smarty_tpl->tpl_vars['idListe']->value;?>
" maxlength="32" value="<?php echo $_smarty_tpl->tpl_vars['liste']->value['nomListe'];?>
" class="form-control">
						</td>
						<td style="text-align:center">
							<input type="radio" name="statut_<?php echo $_smarty_tpl->tpl_vars['idListe']->value;?>
" <?php if ($_smarty_tpl->tpl_vars['liste']->value['statut']=='prive'){?>checked="checked"<?php }?> value="prive">
						</td>
						<td style="text-align:center">
							<input type="radio" name="statut_<?php echo $_smarty_tpl->tpl_vars['idListe']->value;?>
" <?php if ($_smarty_tpl->tpl_vars['liste']->value['statut']=='publie'){?>checked="checked"<?php }?> value="publie">
						</td>
					</tr>
					<?php } ?>
				</table>
				<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
				<input type="hidden" name="mode" value="statutListe">
				<input type="hidden" name="onglet" class="onglet" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['onglet']->value)===null||$tmp==='' ? 0 : $tmp);?>
">
				<div class="btn-group pull-right">
					<button type="reset" name="reset" class="btn btn-default">Annuler</button>
					<button type="submit" name="submit" class="btn btn-primary">Enregistrer</button>
				</div>
				<?php if ($_smarty_tpl->tpl_vars['abonnesDe']->value!=null){?>
					<h5>Vos abonnés</h5>
					<table class="table table-condensed table-striped">
					<?php  $_smarty_tpl->tpl_vars['data'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['data']->_loop = false;
 $_smarty_tpl->tpl_vars['id'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['abonnesDe']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['data']->key => $_smarty_tpl->tpl_vars['data']->value){
$_smarty_tpl->tpl_vars['data']->_loop = true;
 $_smarty_tpl->tpl_vars['id']->value = $_smarty_tpl->tpl_vars['data']->key;
?>
						<tr>
							<th data-container="body" title="<?php echo count($_smarty_tpl->tpl_vars['data']->value['abonnes']);?>
 abonne(s)"><?php echo $_smarty_tpl->tpl_vars['data']->value['nomListe'];?>
</th>
						</tr>
						<tr>
							<td>
							<?php  $_smarty_tpl->tpl_vars['unAbonne'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['unAbonne']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['data']->value['abonnes']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['unAbonne']->key => $_smarty_tpl->tpl_vars['unAbonne']->value){
$_smarty_tpl->tpl_vars['unAbonne']->_loop = true;
?>
								<?php echo $_smarty_tpl->tpl_vars['unAbonne']->value;?>
&nbsp;
							<?php } ?>
							</td>
						</tr>
					<?php } ?>
					</table>
					<?php }?>
			</form>
		</div>


		<div class="col-md-8 col-sm-12">
				<form name="formAbonnement" id="formAbonnement" method="POST" action="index.php">
				<h3>Abonnement / désabonnement aux listes</h3>

					<?php if (count($_smarty_tpl->tpl_vars['listeAbonne']->value)!=0){?>
						<h5>Vos abonnements</h5>
						<table class="table table-condensed table-striped">
							<tr>
								<th>Nom de la liste</th>
								<th>Propriétaire</th>
								<th>Désabonnement</th>
								<th>Appropriation</th>
							</tr>
							<?php  $_smarty_tpl->tpl_vars['data'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['data']->_loop = false;
 $_smarty_tpl->tpl_vars['id'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listeAbonne']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['data']->key => $_smarty_tpl->tpl_vars['data']->value){
$_smarty_tpl->tpl_vars['data']->_loop = true;
 $_smarty_tpl->tpl_vars['id']->value = $_smarty_tpl->tpl_vars['data']->key;
?>

							<tr>
								<td data-container="body" title="<?php echo (($tmp = @count($_smarty_tpl->tpl_vars['membresDeAbonne']->value[$_smarty_tpl->tpl_vars['id']->value]))===null||$tmp==='' ? 0 : $tmp);?>
 membres|<?php  $_smarty_tpl->tpl_vars['wtf'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['wtf']->_loop = false;
 $_smarty_tpl->tpl_vars['acronyme'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['membresDeAbonne']->value[$_smarty_tpl->tpl_vars['id']->value]; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['wtf']->key => $_smarty_tpl->tpl_vars['wtf']->value){
$_smarty_tpl->tpl_vars['wtf']->_loop = true;
 $_smarty_tpl->tpl_vars['acronyme']->value = $_smarty_tpl->tpl_vars['wtf']->key;
?><?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
 <?php } ?>"><?php echo $_smarty_tpl->tpl_vars['data']->value['nomListe'];?>
</td>
								<td>
									<?php $_smarty_tpl->tpl_vars['acro'] = new Smarty_variable($_smarty_tpl->tpl_vars['data']->value['proprio'], null, 0);?>
									<?php $_smarty_tpl->tpl_vars['nomProf'] = new Smarty_variable((($tmp = @$_smarty_tpl->tpl_vars['listeProfs']->value['membres'][$_smarty_tpl->tpl_vars['acro']->value]['nom'])===null||$tmp==='' ? $_smarty_tpl->tpl_vars['acro']->value : $tmp), null, 0);?>
									<?php $_smarty_tpl->tpl_vars['prenomProf'] = new Smarty_variable((($tmp = @$_smarty_tpl->tpl_vars['listeProfs']->value['membres'][$_smarty_tpl->tpl_vars['acro']->value]['prenom'])===null||$tmp==='' ? '' : $tmp), null, 0);?>
									<?php echo (($_smarty_tpl->tpl_vars['prenomProf']->value).(' ')).($_smarty_tpl->tpl_vars['nomProf']->value);?>

								</td>
								<td>
									<div class="checkbox">
										<label>
											<input type="checkbox" name="desabonner[]" value="<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
">
											Se désabonner
										</label>
									</div>
								</td>
								<td>
									<div class="checkbox">
										<label>
											<input type="checkbox" name="approprier[]" value="<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
">
											S'approprier
										</label>
									</div>
								</td>
							</tr>
						<?php } ?>
						</table>
					<?php }else{ ?>
						<p style="text-align:center">Aucun abonnement</p>
					<?php }?>
					<h3>Listes disponibles</h3>
					<?php if (count($_smarty_tpl->tpl_vars['listePublie']->value)>0){?>
						<table class="table tabl-condensed table-striped">
							<tr>
								<th>Nom de la liste</th>
								<th>Propriétaire</th>
								<th>Abonnement</th>
								<th>Appropriation</th>
							</tr>
							<?php  $_smarty_tpl->tpl_vars['data'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['data']->_loop = false;
 $_smarty_tpl->tpl_vars['id'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listePublie']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['data']->key => $_smarty_tpl->tpl_vars['data']->value){
$_smarty_tpl->tpl_vars['data']->_loop = true;
 $_smarty_tpl->tpl_vars['id']->value = $_smarty_tpl->tpl_vars['data']->key;
?>
								<tr>
									<td data-container="body" title="<?php echo (($tmp = @count($_smarty_tpl->tpl_vars['membresDePublie']->value[$_smarty_tpl->tpl_vars['id']->value]))===null||$tmp==='' ? 0 : $tmp);?>
 membres|<?php  $_smarty_tpl->tpl_vars['wtf'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['wtf']->_loop = false;
 $_smarty_tpl->tpl_vars['acronyme'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['membresDePublie']->value[$_smarty_tpl->tpl_vars['id']->value]; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['wtf']->key => $_smarty_tpl->tpl_vars['wtf']->value){
$_smarty_tpl->tpl_vars['wtf']->_loop = true;
 $_smarty_tpl->tpl_vars['acronyme']->value = $_smarty_tpl->tpl_vars['wtf']->key;
?><?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
 <?php } ?>"><?php echo $_smarty_tpl->tpl_vars['data']->value['nomListe'];?>
</td>
									<td>
										<?php $_smarty_tpl->tpl_vars['acro'] = new Smarty_variable($_smarty_tpl->tpl_vars['data']->value['proprio'], null, 0);?>
										<?php $_smarty_tpl->tpl_vars['nomProf'] = new Smarty_variable((($tmp = @$_smarty_tpl->tpl_vars['listeProfs']->value['membres'][$_smarty_tpl->tpl_vars['acro']->value]['nom'])===null||$tmp==='' ? $_smarty_tpl->tpl_vars['acro']->value : $tmp), null, 0);?>
										<?php $_smarty_tpl->tpl_vars['prenomProf'] = new Smarty_variable((($tmp = @$_smarty_tpl->tpl_vars['listeProfs']->value['membres'][$_smarty_tpl->tpl_vars['acro']->value]['prenom'])===null||$tmp==='' ? '' : $tmp), null, 0);?>
										<?php echo (($_smarty_tpl->tpl_vars['prenomProf']->value).(' ')).($_smarty_tpl->tpl_vars['nomProf']->value);?>

									</td>
									<td>
										<div class="checkbox">
										<label>
											<input type="checkbox" name="abonner[]" value="<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
">
											<span>S'abonner</span>
										</label>
										</div>
									</td>
									<td>
										<div class="checkbox">
										<label>
											<input type="checkbox" name="approprier[]" value="<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
">
											<span>S'approprier </span>
										</label>
										</div>
									</td>
								</tr>
							<?php } ?>
						</table>
					<?php }else{ ?>
						<p style="text-align:center">Aucune liste disponible</p>
					<?php }?>
				<?php  $_smarty_tpl->tpl_vars['data'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['data']->_loop = false;
 $_smarty_tpl->tpl_vars['id'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listeAbonne']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['data']->key => $_smarty_tpl->tpl_vars['data']->value){
$_smarty_tpl->tpl_vars['data']->_loop = true;
 $_smarty_tpl->tpl_vars['id']->value = $_smarty_tpl->tpl_vars['data']->key;
?>
				<input type="hidden" name="liste_<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['data']->value['nomListe'];?>
">
				<input type="hidden" name="proprio_<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['data']->value['proprio'];?>
">
				<?php } ?>
				<?php  $_smarty_tpl->tpl_vars['data'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['data']->_loop = false;
 $_smarty_tpl->tpl_vars['id'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listePublie']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['data']->key => $_smarty_tpl->tpl_vars['data']->value){
$_smarty_tpl->tpl_vars['data']->_loop = true;
 $_smarty_tpl->tpl_vars['id']->value = $_smarty_tpl->tpl_vars['data']->key;
?>
				<input type="hidden" name="liste_<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['data']->value['nomListe'];?>
">
				<input type="hidden" name="proprio_<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['data']->value['proprio'];?>
">
				<?php } ?>
				<input type="hidden" name="onglet" class="onglet" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['onglet']->value)===null||$tmp==='' ? 0 : $tmp);?>
">
				<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
				<input type="hidden" name="mode" value="abonnement">
				<div class="btn-group pull-right">
					<button type="reset" class="btn btn-default">Annuler</button>
					<button type="submit" class="btn btn-primary">Enregistrer</button>
				</div>
				</form>
				<p style="clear:both"></p>

			</div>  <!-- col-md-... -->

	</div>  <!-- row -->

</div>  <!-- container  -->
<?php }} ?>