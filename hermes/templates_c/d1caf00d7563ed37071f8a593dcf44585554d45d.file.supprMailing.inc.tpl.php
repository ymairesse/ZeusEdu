<?php /* Smarty version Smarty-3.1.13, created on 2020-01-30 15:54:22
         compiled from "./templates/inc/supprMailing.inc.tpl" */ ?>
<?php /*%%SmartyHeaderCode:6114896695e32ee1e34bd10-47929380%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'd1caf00d7563ed37071f8a593dcf44585554d45d' => 
    array (
      0 => './templates/inc/supprMailing.inc.tpl',
      1 => 1580336329,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '6114896695e32ee1e34bd10-47929380',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'listesPerso' => 0,
    'onglet' => 0,
    'action' => 0,
    'id' => 0,
    'liste' => 0,
    'prof' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5e32ee1e355b68_35311315',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5e32ee1e355b68_35311315')) {function content_5e32ee1e355b68_35311315($_smarty_tpl) {?><?php if (!is_callable('smarty_modifier_truncate')) include '/home/yves/www/sio2/peda/smarty/plugins/modifier.truncate.php';
?><?php if (count($_smarty_tpl->tpl_vars['listesPerso']->value)>0){?>
	<div class="row">

		<div class="col-md-8 col-sm-12">

		<form name="deleteList" id="deleteList" action="index.php" method="POST" class="form-vertical" role="form">

			<h3>Listes existantes</h3>

			<input type="hidden" name="onglet" class="onglet" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['onglet']->value)===null||$tmp==='' ? 0 : $tmp);?>
">
			<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
			<input type="hidden" name="mode" value="delete">
			<div class="btn-group pull-right">
				<button type="reset" class="btn btn-default">Annuler</button>
				<button type="submit" class="btn btn-primary" id="resetDel">Supprimer</button>
			</div>

			<p>Destinataires sélectionnés <strong id="selectionDest">0</strong></p>

				<div class="panel-group" id="accordion">

					<?php  $_smarty_tpl->tpl_vars['liste'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['liste']->_loop = false;
 $_smarty_tpl->tpl_vars['id'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listesPerso']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['liste']->key => $_smarty_tpl->tpl_vars['liste']->value){
$_smarty_tpl->tpl_vars['liste']->_loop = true;
 $_smarty_tpl->tpl_vars['id']->value = $_smarty_tpl->tpl_vars['liste']->key;
?>

					<div class="panel panel-default">

						<div class="panel-heading">
							<h4 class="panel-title">
								<a data-toggle="collapse" data-parent="#accordion" href="#blocMails_<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
">
								<input type="checkbox" class="checkListe" name="liste-<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
" id="liste-<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
">
								<?php echo $_smarty_tpl->tpl_vars['liste']->value['nomListe'];?>
 -> <?php echo count($_smarty_tpl->tpl_vars['liste']->value['membres']);?>
 membres</a>
							</h4>
						</div>  <!-- panel-heading -->

						<div id="blocMails_<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
" class="panel-collapse collapse">

							<div class="panel-body">
								<?php if ($_smarty_tpl->tpl_vars['liste']->value['membres']!=null){?>
									<?php  $_smarty_tpl->tpl_vars['prof'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['prof']->_loop = false;
 $_smarty_tpl->tpl_vars['acronyme'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['liste']->value['membres']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['prof']->key => $_smarty_tpl->tpl_vars['prof']->value){
$_smarty_tpl->tpl_vars['prof']->_loop = true;
 $_smarty_tpl->tpl_vars['acronyme']->value = $_smarty_tpl->tpl_vars['prof']->key;
?>
										<div class="checkbox">
											<label>
												<input class="selecteur mails mailsSuppr" type="checkbox" name="mailing-<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
_acronyme-<?php echo $_smarty_tpl->tpl_vars['prof']->value['acronyme'];?>
" value="<?php echo $_smarty_tpl->tpl_vars['prof']->value['acronyme'];?>
">
												<span class="labelProf"><?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['prof']->value['nom'],15,'...');?>
 <?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
 <?php echo (($tmp = @$_smarty_tpl->tpl_vars['prof']->value['classe'])===null||$tmp==='' ? '' : $tmp);?>
</span>
											</label>
										</div>
									<?php } ?>
								<?php }?>
							</div>  <!-- panel-body -->

						</div>  <!-- blocMails_<?php echo $_smarty_tpl->tpl_vars['id']->value;?>
 -->

					</div>  <!-- panel-default -->

					<?php } ?>

				</div>  <!-- #accordion -->

		</form>

		</div>  <!-- col-md-... -->

		<div class="col-md-4 col-sm-12">

			<div class="notice">Pour supprimer une liste complète, cocher la case de tête de la liste.<br>Pour supprimer certains membres d'une liste, cliquer sur le titre et cocher les cases correspondantes.</div>

		</div>

	</div>  <!-- row -->

<?php }else{ ?>
<p>Aucune liste définie</p>
<?php }?>
<?php }} ?>