<?php
/* Smarty version 3.1.34-dev-7, created on 2021-03-15 11:23:41
  from '/home/yves/www/sio2/peda/bullISND/templates/initPonderations.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_604f35ad4853c9_31118085',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    'c77e821d590b3cb766ce320fadfc58f3412e787b' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/initPonderations.tpl',
      1 => 1431173717,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_604f35ad4853c9_31118085 (Smarty_Internal_Template $_smarty_tpl) {
?><div class="container">
	
<h3>Initialisation des pondérations</h3>

<form autocomplete="off" name="initPonderations" id="initPonderations" method="POST" action="index.php" class="form-vertical" role="form">
	
	<div class="row">
		
		<div class="col-md-8 col-sm-12">
			<h4>Cours concernés</h4>
			<select multiple="multiple" size="20" name="listeCoursGrp[]" id="listeCoursGrp" class="form-control">
				<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeCoursGrp']->value, 'data', false, 'coursGrp');
$_smarty_tpl->tpl_vars['data']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['coursGrp']->value => $_smarty_tpl->tpl_vars['data']->value) {
$_smarty_tpl->tpl_vars['data']->do_else = false;
?>
				<option value="<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
">[<?php echo $_smarty_tpl->tpl_vars['coursGrp']->value;?>
] <?php echo $_smarty_tpl->tpl_vars['data']->value['statut'];?>
 <?php echo $_smarty_tpl->tpl_vars['data']->value['nbheures'];?>
h <?php echo $_smarty_tpl->tpl_vars['data']->value['libelle'];?>
</option>
				<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
			</select>

		</div>  <!-- col-md-... -->
		
		<div class="col-md-4 col-sm-12">
	
			<h4>Pondérations</h4>
			<table class="table">
				<thead>
					<tr>
						<td>Période</td>
						<td>TJ</td>
						<td>Certificatif</td>
					</tr>
				</thead>
				<?php
$__section_periodes_0_loop = (is_array(@$_loop=$_smarty_tpl->tpl_vars['nbPeriodes']->value+1) ? count($_loop) : max(0, (int) $_loop));
$__section_periodes_0_start = min(1, $__section_periodes_0_loop);
$__section_periodes_0_total = min(($__section_periodes_0_loop - $__section_periodes_0_start), $__section_periodes_0_loop);
$_smarty_tpl->tpl_vars['__smarty_section_periodes'] = new Smarty_Variable(array());
if ($__section_periodes_0_total !== 0) {
for ($__section_periodes_0_iteration = 1, $_smarty_tpl->tpl_vars['__smarty_section_periodes']->value['index'] = $__section_periodes_0_start; $__section_periodes_0_iteration <= $__section_periodes_0_total; $__section_periodes_0_iteration++, $_smarty_tpl->tpl_vars['__smarty_section_periodes']->value['index']++){
?>
				<?php $_smarty_tpl->_assignInScope('noPeriode', (isset($_smarty_tpl->tpl_vars['__smarty_section_periodes']->value['index']) ? $_smarty_tpl->tpl_vars['__smarty_section_periodes']->value['index'] : null));?>
				<?php $_smarty_tpl->_assignInScope('per', $_smarty_tpl->tpl_vars['noPeriode']->value-1);?>
				<tr>
					<td><strong><?php echo $_smarty_tpl->tpl_vars['noPeriode']->value;?>
</strong></td>
					<td><input type="text" value="" name="formatif_<?php echo $_smarty_tpl->tpl_vars['noPeriode']->value;?>
" maxlength="3" class="form-control"></td>
					<td><input type="text" value="" name="certif_<?php echo $_smarty_tpl->tpl_vars['noPeriode']->value;?>
" maxlength="3" class="form-control"></td>
				</tr>
				<?php
}
}
?>
			</table>
			
			<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
			<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
			<input type="hidden" name="etape" value="enregistrer">
			<div class="btn-group pull-right">
				<button type="reset" class="btn btn-default" >Annuler</button>
				<button type="submit" class="btn btn-primary" id="submit">Enregistrer</button>
			</div>
			
		</div>  <!-- col-md-... -->
	
	</div>  <!-- row -->
</form>

</div>  <!-- container -->

<?php echo '<script'; ?>
 type="text/javascript">

	$(document).ready(function(){
		$("#initPonderations").submit(function(){
			$("#wait").show();
			})
		})

<?php echo '</script'; ?>
><?php }
}
