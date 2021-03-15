<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-14 20:12:57
  from '/home/yves/www/sio2/peda/bullISND/templates/selecteurs/listeCoursComp.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604e60391bf7a2_95439053',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'de491130f1fd6de766620e43c3bf4e9e0b07a671' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/selecteurs/listeCoursComp.tpl',
      1 => 1605808147,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604e60391bf7a2_95439053 (Smarty_Internal_Template $_smarty_tpl) {
?><label for="cours">Sélection d'un cours</label>
<select name="cours" id="cours" class="form-control">

	<option value="">Choisir un cours</option>
	<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCoursComp']->value, 'unCours', false, 'leCours');
$_smarty_tpl->tpl_vars['unCours']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['leCours']->value => $_smarty_tpl->tpl_vars['unCours']->value) {
$_smarty_tpl->tpl_vars['unCours']->do_else = false;
?>
	<option value="<?php echo $_smarty_tpl->tpl_vars['leCours']->value;?>
"<?php if ((isset($_smarty_tpl->tpl_vars['cours']->value)) && ($_smarty_tpl->tpl_vars['leCours']->value == $_smarty_tpl->tpl_vars['cours']->value)) {?> selected="selected"<?php }?>>
		<?php echo $_smarty_tpl->tpl_vars['unCours']->value['libelle'];?>
 <?php echo $_smarty_tpl->tpl_vars['unCours']->value['statut'];?>
 <?php echo $_smarty_tpl->tpl_vars['unCours']->value['nbheures'];?>
h [<?php echo $_smarty_tpl->tpl_vars['leCours']->value;?>
]</option>
	<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>

</select>

<?php echo '<script'; ?>
 type="text/javascript">

	$("#cours").change(function(){
		if ($(this).val() != '')
			$("#formSelecteur").submit();
		})

<?php echo '</script'; ?>
>
<?php }
}
