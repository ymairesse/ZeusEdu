<?php /* Smarty version Smarty-3.1.13, created on 2020-05-27 15:48:20
         compiled from "./templates/confirmMail.tpl" */ ?>
<?php /*%%SmartyHeaderCode:11339301715ece6fa4ebeb05-30381733%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'e0ac308bf6d655da68cc02f749378535396745f4' => 
    array (
      0 => './templates/confirmMail.tpl',
      1 => 1563779226,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '11339301715ece6fa4ebeb05-30381733',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'detailsMail' => 0,
    'nbMails' => 0,
    'destinatairesString' => 0,
    'data' => 0,
    'acronyme' => 0,
    'n' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5ece6fa4ecf832_23550422',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5ece6fa4ecf832_23550422')) {function content_5ece6fa4ecf832_23550422($_smarty_tpl) {?><div class="container-fluid">
	
	<h2>Votre envoi</h2>

	<div id="cadre">
	<p><strong class="enteteMail">Expéditeur:</strong> <span class="champ" title="<?php echo $_smarty_tpl->tpl_vars['detailsMail']->value['post']['mailExpediteur'];?>
"><?php echo $_smarty_tpl->tpl_vars['detailsMail']->value['post']['nomExpediteur'];?>
 (<?php echo $_smarty_tpl->tpl_vars['detailsMail']->value['post']['mailExpediteur'];?>
)</span> </p>
	<p><strong class="enteteMail">Objet:</strong> <span class="champ"><?php echo $_smarty_tpl->tpl_vars['detailsMail']->value['post']['objet'];?>
</span></p>
	<?php $_smarty_tpl->tpl_vars['nbMails'] = new Smarty_variable(count($_smarty_tpl->tpl_vars['detailsMail']->value['post']['mails']), null, 0);?>
	<p><strong class="enteteMail">Destinataire(s):</strong>
		<?php if ($_smarty_tpl->tpl_vars['nbMails']->value>4){?>
		<span class="champ"><?php echo $_smarty_tpl->tpl_vars['nbMails']->value;?>
 destinataires</span>
		<?php }else{ ?>
		<span class="champ"><?php echo $_smarty_tpl->tpl_vars['destinatairesString']->value;?>
</span>
		<?php }?>
	</p>
	<strong>Texte</strong><br>
	<div class="champ"><?php echo $_smarty_tpl->tpl_vars['detailsMail']->value['post']['texte'];?>
</div>
	<br>
	
	<strong>Fichiers joints:</strong><br>
	<?php $_smarty_tpl->tpl_vars['n'] = new Smarty_variable(0, null, 0);?>
	<?php  $_smarty_tpl->tpl_vars['data'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['data']->_loop = false;
 $_smarty_tpl->tpl_vars['wtf'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['detailsMail']->value['files']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['data']->key => $_smarty_tpl->tpl_vars['data']->value){
$_smarty_tpl->tpl_vars['data']->_loop = true;
 $_smarty_tpl->tpl_vars['wtf']->value = $_smarty_tpl->tpl_vars['data']->key;
?>
		<?php if ($_smarty_tpl->tpl_vars['data']->value['error']!=4){?>
			<?php $_smarty_tpl->tpl_vars['n'] = new Smarty_variable('n'+1, null, 0);?>
			<a href="upload/<?php echo $_smarty_tpl->tpl_vars['acronyme']->value;?>
/<?php echo $_smarty_tpl->tpl_vars['data']->value['name'];?>
" target="_blank"><?php echo $_smarty_tpl->tpl_vars['data']->value['name'];?>
</a>&nbsp;&nbsp;
		<?php }?>
	<?php } ?>
	<?php if ($_smarty_tpl->tpl_vars['n']->value==0){?>
		aucun
	<?php }?>
	</div>

</div>  <!-- container -->
<?php }} ?>