<?php /* Smarty version Smarty-3.1.13, created on 2020-05-06 09:01:03
         compiled from "./templates/destinataires.tpl" */ ?>
<?php /*%%SmartyHeaderCode:2838130895e32f36363c068-92951891%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '771cd600291d6aa0d822b2cf9398feb44dd5550e' => 
    array (
      0 => './templates/destinataires.tpl',
      1 => 1587143714,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '2838130895e32f36363c068-92951891',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5e32f363655ab2_20875327',
  'variables' => 
  array (
    'listeProfs' => 0,
    'noListe' => 0,
    'membresProfs' => 0,
    'prof' => 0,
    'listeTitus' => 0,
    'listesAutres' => 0,
    'listePerso' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5e32f363655ab2_20875327')) {function content_5e32f363655ab2_20875327($_smarty_tpl) {?><?php if (!is_callable('smarty_modifier_truncate')) include '/home/yves/www/sio2/peda/smarty/plugins/modifier.truncate.php';
?><div class="panel panel-default">

	<div class="panel-header">
		<h3>Destinataires</h3>
	</div>

	<div class="panel-body">

	<?php $_smarty_tpl->tpl_vars['noListe'] = new Smarty_variable(1, null, 0);?>
	<!--	tous les utilisateurs -->
	<?php if (isset($_smarty_tpl->tpl_vars['listeProfs']->value)){?>
		<div style="width:100%">
			<input type="checkbox" class="checkListe" name="liste_<?php echo $_smarty_tpl->tpl_vars['noListe']->value;?>
" style="float: left; margin-right:0.5em">
			<h4 class="teteListe" title="Cliquer pour ouvrir"><?php echo $_smarty_tpl->tpl_vars['listeProfs']->value['nomListe'];?>
</h4>
		</div>

		<ul class="listeMails" style="display:none">
		<?php $_smarty_tpl->tpl_vars['membresProfs'] = new Smarty_variable($_smarty_tpl->tpl_vars['listeProfs']->value['membres'], null, 0);?>
		<?php  $_smarty_tpl->tpl_vars['prof'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['prof']->_loop = false;
 $_smarty_tpl->tpl_vars['acro'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['membresProfs']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['prof']->key => $_smarty_tpl->tpl_vars['prof']->value){
$_smarty_tpl->tpl_vars['prof']->_loop = true;
 $_smarty_tpl->tpl_vars['acro']->value = $_smarty_tpl->tpl_vars['prof']->key;
?>
			<li><input class="selecteur mails" type="checkbox" name="mails[]" value="<?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
 <?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['prof']->value['nom'],15,'...');?>
#<?php echo $_smarty_tpl->tpl_vars['prof']->value['mail'];?>
">
				<span class="labelProf"><?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['prof']->value['nom'],15,'...');?>
 <?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
</span>
			</li>
		<?php } ?>
		</ul>
	<?php }?>
	<?php if (isset($_smarty_tpl->tpl_vars['listeTitus']->value)){?>
		<?php $_smarty_tpl->tpl_vars['noListe'] = new Smarty_variable($_smarty_tpl->tpl_vars['noListe']->value+1, null, 0);?>
		<!--	tous les titulaires (profs principaux) -->
		<div style="width:100%">
			<input type="checkbox" class="checkListe" name="liste_<?php echo $_smarty_tpl->tpl_vars['noListe']->value;?>
" style="float: left; margin-right:0.5em">
			<h4 class="teteListe" title="Cliquer pour ouvrir"><?php echo $_smarty_tpl->tpl_vars['listeTitus']->value['nomListe'];?>
</h4>
		</div>
		<ul class="listeMails" style="display:none">
		<?php $_smarty_tpl->tpl_vars['membresProfs'] = new Smarty_variable($_smarty_tpl->tpl_vars['listeTitus']->value['membres'], null, 0);?>
		<?php  $_smarty_tpl->tpl_vars['prof'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['prof']->_loop = false;
 $_smarty_tpl->tpl_vars['acro'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['membresProfs']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['prof']->key => $_smarty_tpl->tpl_vars['prof']->value){
$_smarty_tpl->tpl_vars['prof']->_loop = true;
 $_smarty_tpl->tpl_vars['acro']->value = $_smarty_tpl->tpl_vars['prof']->key;
?>
			<li><input class="selecteur mails" type="checkbox" name="mails[]" value="<?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
 <?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['prof']->value['nom'],15,'...');?>
#<?php echo $_smarty_tpl->tpl_vars['prof']->value['mail'];?>
">
				<span class="labelProf"><?php echo $_smarty_tpl->tpl_vars['prof']->value['classe'];?>
 <?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['prof']->value['nom'],15,'...');?>
 <?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
</span>
			</li>
		<?php } ?>
		</ul>
	<?php }?>

	<!-- 	toutes les autres listes personnelles ou publiées -->
	<?php  $_smarty_tpl->tpl_vars['listePerso'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['listePerso']->_loop = false;
 $_smarty_tpl->tpl_vars['idListe'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listesAutres']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['listePerso']->key => $_smarty_tpl->tpl_vars['listePerso']->value){
$_smarty_tpl->tpl_vars['listePerso']->_loop = true;
 $_smarty_tpl->tpl_vars['idListe']->value = $_smarty_tpl->tpl_vars['listePerso']->key;
?>
	<?php $_smarty_tpl->tpl_vars['noListe'] = new Smarty_variable($_smarty_tpl->tpl_vars['noListe']->value+1, null, 0);?>
	<?php $_smarty_tpl->tpl_vars['membresProfs'] = new Smarty_variable($_smarty_tpl->tpl_vars['listePerso']->value['membres'], null, 0);?>

	<div style="width:100%">
		<input type="checkbox" class="checkListe" name="liste_<?php echo $_smarty_tpl->tpl_vars['noListe']->value;?>
" style="float: left; margin-right:0.5em">
		<h4 class="teteListe" title="<?php if ($_smarty_tpl->tpl_vars['membresProfs']->value==null){?>Liste vide<?php }else{ ?>Cliquer pour ouvrir<?php }?> :
			<?php if ($_smarty_tpl->tpl_vars['listePerso']->value['statut']=='publie'){?>Publié<?php }elseif($_smarty_tpl->tpl_vars['listePerso']->value['statut']=='abonne'){?>Abonné<?php }else{ ?>Personnel<?php }?>"><?php echo $_smarty_tpl->tpl_vars['listePerso']->value['nomListe'];?>

			<?php if ($_smarty_tpl->tpl_vars['listePerso']->value['statut']=='publie'){?><img src="../images/shared.png" alt="part"><?php }?>
			<?php if ($_smarty_tpl->tpl_vars['listePerso']->value['statut']=='prive'){?><img src="../images/personal.png" alt="pers"><?php }?>
			<?php if ($_smarty_tpl->tpl_vars['listePerso']->value['statut']=='abonne'){?><img src="../images/abonne.png" alt="abo"><?php }?>
		</h4>
	</div>

	<?php if ($_smarty_tpl->tpl_vars['membresProfs']->value!=null){?>
	<ul class="listeMails" style="display:none">
			<?php  $_smarty_tpl->tpl_vars['prof'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['prof']->_loop = false;
 $_smarty_tpl->tpl_vars['acro'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['membresProfs']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['prof']->key => $_smarty_tpl->tpl_vars['prof']->value){
$_smarty_tpl->tpl_vars['prof']->_loop = true;
 $_smarty_tpl->tpl_vars['acro']->value = $_smarty_tpl->tpl_vars['prof']->key;
?>
		<li>
			<input class="selecteur mails" type="checkbox" name="mails[]" value="<?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
 <?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['prof']->value['nom'],15,'...');?>
#<?php echo $_smarty_tpl->tpl_vars['prof']->value['mail'];?>
">
			<span class="labelProf"><?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['prof']->value['nom'],15,'...');?>
 <?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
 <?php echo (($tmp = @$_smarty_tpl->tpl_vars['prof']->value['classe'])===null||$tmp==='' ? '' : $tmp);?>
</span>
		</li>
		<?php } ?>
	</ul>
	<?php }?>
	<?php } ?>

</div>  <!-- panel-body -->

</div>  <!-- panel -->
<?php }} ?>