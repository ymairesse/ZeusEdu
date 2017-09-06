<?php /* Smarty version Smarty-3.1.13, created on 2017-05-18 16:07:01
         compiled from "./templates/connexions.tpl" */ ?>
<?php /*%%SmartyHeaderCode:844384368591daa854927b3-92475554%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'dfc47e3608067698fba3c1c0632e3bead8b3095a' => 
    array (
      0 => './templates/connexions.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '844384368591daa854927b3-92475554',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'derniersConnectes' => 0,
    'unNom' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_591daa8549fc71_11250387',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_591daa8549fc71_11250387')) {function content_591daa8549fc71_11250387($_smarty_tpl) {?><?php if (!is_callable('smarty_modifier_date_format')) include '/home/yves/www/sio2/peda/smarty/plugins/modifier.date_format.php';
?><div style="height:25em; overflow: scroll;" class="table-responsive">
<h4>Big Brother is watching you</h4>
<table class="table table-condensed table-hover">
	<tr>
		<th>User</td>
		<th>Date</td>
		<th>Heure</td>
		<th>Accès</th>
	</tr>
	<?php  $_smarty_tpl->tpl_vars['unNom'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['unNom']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['derniersConnectes']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['unNom']->key => $_smarty_tpl->tpl_vars['unNom']->value){
$_smarty_tpl->tpl_vars['unNom']->_loop = true;
?>
	<tr>
		<td><?php echo $_smarty_tpl->tpl_vars['unNom']->value['user'];?>
</td>
		<td><?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['unNom']->value['date'],"%d/%m/%Y");?>
</td>
		<td><?php echo $_smarty_tpl->tpl_vars['unNom']->value['heure'];?>
</td>
		<td title="<?php echo $_smarty_tpl->tpl_vars['unNom']->value['ip'];?>
"><?php echo $_smarty_tpl->tpl_vars['unNom']->value['host'];?>
</td>
	</tr>
	<?php } ?>
</table>
</div><?php }} ?>