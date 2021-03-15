<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-12 13:28:21
  from '/home/yves/www/sio2/peda/bullISND/templates/redirect.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604b5e655e3dc3_88932226',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '5ad925ecbea482b978fdb704e3821f03094f2d49' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/redirect.tpl',
      1 => 1390661827,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604b5e655e3dc3_88932226 (Smarty_Internal_Template $_smarty_tpl) {
echo '<script'; ?>
 type="text/javascript">
	setTimeout("location.href = '<?php echo $_smarty_tpl->tpl_vars['redirection']->value;?>
'",<?php echo $_smarty_tpl->tpl_vars['time']->value;?>
);
<?php echo '</script'; ?>
>
<?php }
}
