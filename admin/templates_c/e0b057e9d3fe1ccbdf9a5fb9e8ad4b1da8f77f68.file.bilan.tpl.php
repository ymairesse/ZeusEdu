<?php /* Smarty version Smarty-3.1.13, created on 2017-05-18 16:07:01
         compiled from "./templates/bilan.tpl" */ ?>
<?php /*%%SmartyHeaderCode:1189782158591daa85461099-95864683%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'e0b057e9d3fe1ccbdf9a5fb9e8ad4b1da8f77f68' => 
    array (
      0 => './templates/bilan.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '1189782158591daa85461099-95864683',
  'function' => 
  array (
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_591daa8548d0e4_32904101',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_591daa8548d0e4_32904101')) {function content_591daa8548d0e4_32904101($_smarty_tpl) {?><div class="container">
	
	<div class="row">

		<div class="col-md-6 col-sm-12">
			<?php echo $_smarty_tpl->getSubTemplate ("connexions.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>

		</div>
		
		<div class="col-md-6 col-sm-12">
			<?php echo $_smarty_tpl->getSubTemplate ("commandes.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>

		</div>
	
		<div class="col-md-6 col-sm-12">
			<?php echo $_smarty_tpl->getSubTemplate ("backups.tpl", $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, null, null, array(), 0);?>

		</div>

	</div>  <!-- row -->
	
</div>  <!-- container --><?php }} ?>