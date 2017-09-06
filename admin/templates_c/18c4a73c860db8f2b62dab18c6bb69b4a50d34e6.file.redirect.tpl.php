<?php /* Smarty version Smarty-3.1.13, created on 2017-05-20 15:40:14
         compiled from "./templates/redirect.tpl" */ ?>
<?php /*%%SmartyHeaderCode:17709425925920473e2cacd2-57541856%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '18c4a73c860db8f2b62dab18c6bb69b4a50d34e6' => 
    array (
      0 => './templates/redirect.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '17709425925920473e2cacd2-57541856',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'redirection' => 0,
    'time' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5920473e2d0897_91577317',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5920473e2d0897_91577317')) {function content_5920473e2d0897_91577317($_smarty_tpl) {?><script type="text/javascript">
	setTimeout("location.href = '<?php echo $_smarty_tpl->tpl_vars['redirection']->value;?>
'",<?php echo $_smarty_tpl->tpl_vars['time']->value;?>
);
</script>
<?php }} ?>