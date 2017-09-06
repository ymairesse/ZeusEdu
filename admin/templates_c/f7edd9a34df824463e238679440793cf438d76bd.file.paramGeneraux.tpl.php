<?php /* Smarty version Smarty-3.1.13, created on 2017-05-20 19:22:22
         compiled from "./templates/paramGeneraux.tpl" */ ?>
<?php /*%%SmartyHeaderCode:187253662659207b4e121025-45150456%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'f7edd9a34df824463e238679440793cf438d76bd' => 
    array (
      0 => './templates/paramGeneraux.tpl',
      1 => 1482007938,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '187253662659207b4e121025-45150456',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'parametres' => 0,
    'n' => 0,
    'moitie' => 0,
    'parametre' => 0,
    'data' => 0,
    'action' => 0,
    'mode' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59207b4e137686_46881477',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59207b4e137686_46881477')) {function content_59207b4e137686_46881477($_smarty_tpl) {?><div class="container">

	<h3>Paramètres généraux</h3>

	<form name="formParametres" id="formParametres" method="POST" action="index.php" role="form" class="form-vertical">
		
		<?php $_smarty_tpl->tpl_vars['moitie'] = new Smarty_variable(count($_smarty_tpl->tpl_vars['parametres']->value)/2, null, 0);?>
		<?php $_smarty_tpl->tpl_vars['n'] = new Smarty_variable(0, null, 0);?>
		<div class="row">
			<div class="col-md-6 col-sm-12">
		<?php  $_smarty_tpl->tpl_vars['data'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['data']->_loop = false;
 $_smarty_tpl->tpl_vars['parametre'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['parametres']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['data']->key => $_smarty_tpl->tpl_vars['data']->value){
$_smarty_tpl->tpl_vars['data']->_loop = true;
 $_smarty_tpl->tpl_vars['parametre']->value = $_smarty_tpl->tpl_vars['data']->key;
?>
		<?php if ($_smarty_tpl->tpl_vars['n']->value>=$_smarty_tpl->tpl_vars['moitie']->value){?>
			</div>

			<div class="col-md-6 col-sm-12">
			<?php $_smarty_tpl->tpl_vars['n'] = new Smarty_variable(-10000, null, 0);?>
		<?php }?>
		<div class="form-group">
			<label for="<?php echo $_smarty_tpl->tpl_vars['parametre']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['data']->value['label'];?>
 [<?php echo $_smarty_tpl->tpl_vars['parametre']->value;?>
]</label>
			<input type="text" maxlength="<?php echo $_smarty_tpl->tpl_vars['data']->value['size'];?>
" name="<?php echo $_smarty_tpl->tpl_vars['parametre']->value;?>
" id="<?php echo $_smarty_tpl->tpl_vars['parametre']->value;?>
" value="<?php echo htmlspecialchars($_smarty_tpl->tpl_vars['data']->value['valeur'], ENT_QUOTES, 'UTF-8', true);?>
" class="form-control">
			<div class="help-block"><?php echo $_smarty_tpl->tpl_vars['data']->value['signification'];?>
</div>
		</div>
		<?php $_smarty_tpl->tpl_vars['n'] = new Smarty_variable($_smarty_tpl->tpl_vars['n']->value+1, null, 0);?>
		<?php } ?>
			</div>  <!-- col-md-... -->

		</div>  <!-- row -->

		<div class="btn-group pull-right">
			<button type="reset" class="btn btn-default">Annuler</button>
			<button type="submit" class="btn btn-primary">Enregistrer</button>
		</div>
		<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
		<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
		<input type="hidden" name="etape" value="save">
	</form>

</div>
<?php }} ?>