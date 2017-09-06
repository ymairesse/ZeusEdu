<?php /* Smarty version Smarty-3.1.13, created on 2017-05-15 10:42:45
         compiled from "./templates/selecteurs/selectNomProf.tpl" */ ?>
<?php /*%%SmartyHeaderCode:87241634559196a0578cec8-19113384%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '93dcfa04869ca6431f1fa7b358387a0a237edfba' => 
    array (
      0 => './templates/selecteurs/selectNomProf.tpl',
      1 => 1494837758,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '87241634559196a0578cec8-19113384',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'listeProfs' => 0,
    'abreviation' => 0,
    'acronyme' => 0,
    'prof' => 0,
    'mode' => 0,
    'etape' => 0,
    'action' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59196a05798bc4_64411859',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59196a05798bc4_64411859')) {function content_59196a05798bc4_64411859($_smarty_tpl) {?><div id="selecteur" class="noprint">
	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline" role="form">
	<select name="acronyme" id="selectUser">
		<option value="">Sélectionner un utilisateur</option>
		<?php  $_smarty_tpl->tpl_vars['prof'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['prof']->_loop = false;
 $_smarty_tpl->tpl_vars['abreviation'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listeProfs']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['prof']->key => $_smarty_tpl->tpl_vars['prof']->value){
$_smarty_tpl->tpl_vars['prof']->_loop = true;
 $_smarty_tpl->tpl_vars['abreviation']->value = $_smarty_tpl->tpl_vars['prof']->key;
?>
			<option value="<?php echo $_smarty_tpl->tpl_vars['abreviation']->value;?>
"<?php if (isset($_smarty_tpl->tpl_vars['acronyme']->value)&&($_smarty_tpl->tpl_vars['acronyme']->value==$_smarty_tpl->tpl_vars['abreviation']->value)){?> selected="selected"<?php }?>>
				<?php echo $_smarty_tpl->tpl_vars['prof']->value['nom'];?>
 <?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
 [<?php echo $_smarty_tpl->tpl_vars['abreviation']->value;?>
]
			</option>
		<?php } ?>
	</select>
	<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
	<input type="hidden" name="etape" value="<?php echo $_smarty_tpl->tpl_vars['etape']->value;?>
">
	<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
	<button type="submit" class="btn btn-primary btn-sm" id="envoi">OK</button>
	</form>
</div>

<script type="text/javascript">

$(document).ready(function(){

	$("#selectUser").change(function(){
		if ($("#selectUser").val() != "")
			$("#formSelecteur").submit();
		})

	$("#formSelecteur").submit(function(){
		if ($("#selectUser").val() == "")
			return false;
			else $("#wait").show();
		})

})

</script>
<?php }} ?>