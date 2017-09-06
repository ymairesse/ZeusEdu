<?php /* Smarty version Smarty-3.1.13, created on 2017-05-15 10:44:11
         compiled from "../templates/listeEleves.tpl" */ ?>
<?php /*%%SmartyHeaderCode:194578370059196a5b035c47-17667812%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '65d50949d54ece1313f54cfbcc793ae81cdd6db2' => 
    array (
      0 => '../templates/listeEleves.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '194578370059196a5b035c47-17667812',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'listeEleves' => 0,
    'matricule' => 0,
    'eleve' => 0,
    'unEleve' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59196a5b041540_68546201',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59196a5b041540_68546201')) {function content_59196a5b041540_68546201($_smarty_tpl) {?><select name="matricule" id="selectEleve" class="form-control">
	<option value="">Choisir un élève</option>
	<?php  $_smarty_tpl->tpl_vars['unEleve'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['unEleve']->_loop = false;
 $_smarty_tpl->tpl_vars['matricule'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listeEleves']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['unEleve']->key => $_smarty_tpl->tpl_vars['unEleve']->value){
$_smarty_tpl->tpl_vars['unEleve']->_loop = true;
 $_smarty_tpl->tpl_vars['matricule']->value = $_smarty_tpl->tpl_vars['unEleve']->key;
?>
	<option value="<?php echo $_smarty_tpl->tpl_vars['matricule']->value;?>
" <?php if (isset($_smarty_tpl->tpl_vars['eleve']->value)&&($_smarty_tpl->tpl_vars['matricule']->value==$_smarty_tpl->tpl_vars['eleve']->value)){?> selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['unEleve']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['unEleve']->value['prenom'];?>
</option>
	<?php } ?>
</select>
<?php }} ?>