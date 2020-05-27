<?php /* Smarty version Smarty-3.1.13, created on 2020-01-30 16:17:58
         compiled from "./templates/inc/addMailing.inc.tpl" */ ?>
<?php /*%%SmartyHeaderCode:3026345595e32ee1e33bff2-63186936%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '5fc66ec047e9bd104e73a480e251f700db219067' => 
    array (
      0 => './templates/inc/addMailing.inc.tpl',
      1 => 1580397430,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '3026345595e32ee1e33bff2-63186936',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5e32ee1e3490c4_16433029',
  'variables' => 
  array (
    'onglet' => 0,
    'action' => 0,
    'listesPerso' => 0,
    'liste' => 0,
    'acronyme' => 0,
    'idListe' => 0,
    'listeProfs' => 0,
    'membresProfs' => 0,
    'prof' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5e32ee1e3490c4_16433029')) {function content_5e32ee1e3490c4_16433029($_smarty_tpl) {?><?php if (!is_callable('smarty_modifier_truncate')) include '/home/yves/www/sio2/peda/smarty/plugins/modifier.truncate.php';
?><div class="container">

	<div class="row">

		<div class="col-md-3 col-sm-12">

			<h3>Création d'une liste</h3>

			<form role="form" name="creation" id="creation" method="POST" action="index.php" class="form-vertical" role="form">

				<input type="text" placeholder="Nom de la liste à créer" maxlenght="32" id="nomListe" name="nomListe" class="form-control">
				<div class="btn-group pull-right">
					<button type="reset" class="btn btn-default">Annuler</button>
					<button type="submit" class="btn btn-primary">Créer la liste</button>
				</div>
				<input type="hidden" name="onglet" class="onglet" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['onglet']->value)===null||$tmp==='' ? 0 : $tmp);?>
">
				<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
				<input type="hidden" name="mode" value="creationListe">
				<?php if (count($_smarty_tpl->tpl_vars['listesPerso']->value)>0){?>
					<h4>Listes existantes</h4>
					<table class="table table-condensed table-striped">
					<tr>
						<thead>
						<th>Listes</th>
						<th>Membres</th>
						</thead>
					</tr>
					<?php  $_smarty_tpl->tpl_vars['liste'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['liste']->_loop = false;
 $_smarty_tpl->tpl_vars['idListe'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listesPerso']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['liste']->key => $_smarty_tpl->tpl_vars['liste']->value){
$_smarty_tpl->tpl_vars['liste']->_loop = true;
 $_smarty_tpl->tpl_vars['idListe']->value = $_smarty_tpl->tpl_vars['liste']->key;
?>
					<tr>
						<td class="pop"
							data-container="body"
							data-original-title="<?php echo $_smarty_tpl->tpl_vars['liste']->value['nomListe'];?>
: <?php echo (($tmp = @count($_smarty_tpl->tpl_vars['liste']->value['membres']))===null||$tmp==='' ? 0 : $tmp);?>
 membres"
							data-content="<?php  $_smarty_tpl->tpl_vars['wtf'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['wtf']->_loop = false;
 $_smarty_tpl->tpl_vars['acronyme'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['liste']->value['membres']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['wtf']->key => $_smarty_tpl->tpl_vars['wtf']->value){
$_smarty_tpl->tpl_vars['wtf']->_loop = true;
 $_smarty_tpl->tpl_vars['acronyme']->value = $_smarty_tpl->tpl_vars['wtf']->key;
?><?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
 <?php } ?>"
							data-placement="top">
							<?php echo $_smarty_tpl->tpl_vars['liste']->value['nomListe'];?>

						</td>
						<td><?php echo count($_smarty_tpl->tpl_vars['liste']->value['membres']);?>
</td>
					</tr>
					<?php } ?>
					</table>
				<?php }?>

			</form>

		</div>  <!-- col-md-... -->

		<div class="col-md-9 col-sm-12">
			<h3>Ajout de membres à une liste</h3>
			<?php if (count($_smarty_tpl->tpl_vars['listesPerso']->value)>0){?>

				<div class="row">

					<form name="ajoutMembres" id="ajoutMembres" method="POST" action="index.php" class="form-vertical" role="form">

					<div class="col-md-5 col-sm-5">

						<h4>Listes existantes</h4>

							<select name="idListe" id="selectListe" size="5" class="form-control">
								<option value=''>Veuillez choisir une liste</option>
								<?php  $_smarty_tpl->tpl_vars['liste'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['liste']->_loop = false;
 $_smarty_tpl->tpl_vars['idListe'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listesPerso']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['liste']->key => $_smarty_tpl->tpl_vars['liste']->value){
$_smarty_tpl->tpl_vars['liste']->_loop = true;
 $_smarty_tpl->tpl_vars['idListe']->value = $_smarty_tpl->tpl_vars['liste']->key;
?>
									<option value="<?php echo $_smarty_tpl->tpl_vars['idListe']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['liste']->value['nomListe'];?>
 -> <?php echo count($_smarty_tpl->tpl_vars['liste']->value['membres']);?>
 membres</li>
								<?php } ?>
							</select>

							<div id="listeExistants" style="max-height:20em; overflow: auto">

						</div>

					</div>  <!-- col-md-... -->

					<div class="col-md-5 col-sm-5">

						<h4>Destinataires à ajouter</h4>

						<div class="selectMail" style="max-height: 20em">
							<!--	tous les utilisateurs -->
							<ul class="listeMails">
							<?php $_smarty_tpl->tpl_vars['membresProfs'] = new Smarty_variable($_smarty_tpl->tpl_vars['listeProfs']->value['membres'], null, 0);?>
							<?php  $_smarty_tpl->tpl_vars['prof'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['prof']->_loop = false;
 $_smarty_tpl->tpl_vars['acronyme'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['membresProfs']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['prof']->key => $_smarty_tpl->tpl_vars['prof']->value){
$_smarty_tpl->tpl_vars['prof']->_loop = true;
 $_smarty_tpl->tpl_vars['acronyme']->value = $_smarty_tpl->tpl_vars['prof']->key;
?>
								<li>
									<div class="checkbox">
										<label><input class="selecteur mails mailsAjout" type="checkbox" name="mails[]" value="<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
">
											<span class="labelProf"><?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['prof']->value['nom'],15,'...');?>
 <?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
</span>
										</label>
									</div>
								</li>
							<?php } ?>
							</ul>
						</div>

					<p style="clear:both">Sélections: <strong id="selectionAdd">0</strong> destinataire(s)</p>

					</div>  <!-- col-md-... -->

					<div class="col-md-2 col-sm-2">

						<div class="btn-group-vertical">
							<button type="reset" class="btn btn-default" id="resetAdd">Annuler</button>
							<button type="submit" class="btn btn-primary">Ajouter</button>
						</div>
						<input type="hidden" class="onglet" name="onglet" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['onglet']->value)===null||$tmp==='' ? 0 : $tmp);?>
">
						<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
						<input type="hidden" name="mode" value="ajoutMembres"><br>

					</div>

					<div class="clearfix"></div>
					</form>

				</div>  <!-- row -->

			<?php }else{ ?>
				<p>Aucune liste définie</p>
			<?php }?>
			</div>

			<div class="clearfix"></div>

	</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){

		$('#creation').validate();

	})

</script>
<?php }} ?>