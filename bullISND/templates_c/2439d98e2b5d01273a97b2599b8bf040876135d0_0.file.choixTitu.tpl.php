<?php
/* Smarty version 3.1.34-dev-7, created on 2021-02-09 18:08:50
  from '/home/yves/www/sio2/peda/bullISND/templates/choixTitu.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_6022c1a2a665e9_14693967',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '2439d98e2b5d01273a97b2599b8bf040876135d0' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/choixTitu.tpl',
      1 => 1508329705,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_6022c1a2a665e9_14693967 (Smarty_Internal_Template $_smarty_tpl) {
$_smarty_tpl->_checkPlugins(array(0=>array('file'=>'/home/yves/www/sio2/peda/smarty/plugins/modifier.truncate.php','function'=>'smarty_modifier_truncate',),));
if ((isset($_smarty_tpl->tpl_vars['classe']->value))) {?>
<div class="container">

	<div class="row">

		<div class="col-md-3 col-sm-6">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h2>Titulariat <?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
</h2>
				</div>
  				<div class="panel-body">
					<?php if ((isset($_smarty_tpl->tpl_vars['listeTitusGroupe']->value))) {?>
						<form name="titus" id="titus" action="index.php" method="POST">
						<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeTitusGroupe']->value, 'nom', false, 'unAcronyme');
$_smarty_tpl->tpl_vars['nom']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unAcronyme']->value => $_smarty_tpl->tpl_vars['nom']->value) {
$_smarty_tpl->tpl_vars['nom']->do_else = false;
?>
							<div class="checkbox">
								<label>
									<input type="checkbox" name="listeAcronymes[]" value="<?php echo $_smarty_tpl->tpl_vars['unAcronyme']->value;?>
"> <?php echo $_smarty_tpl->tpl_vars['unAcronyme']->value;?>
: <?php echo $_smarty_tpl->tpl_vars['nom']->value;?>
<br>
								</label>
							</div>
						<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
						<button type="submit" class="btn btn-primary btn-block">Supprimer >>></button>
						<input type="hidden" name="classe" value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
">
						<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
						<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
						<input type="hidden" name="etape" value="supprimer">
						</form>
					<?php }?>
				</div>
				<div class="panel-footer">
					Titulaire(s) actuel(s)
				</div>
			</div>

		</div>  <!-- col-md... -->


		<div class="col-md-3 col-sm-6">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h2>Titulaires possibles</h2>
				</div>
				<div class="panel-body">
					<?php if ((isset($_smarty_tpl->tpl_vars['listeProfs']->value))) {?>
						<form name="titusPossibles" id="titusPossibles" action="index.php" method="POST">
						<select name="listeAcronymes[]" id="acronyme" multiple="multiple" size="14" class="form-control">
						<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeProfs']->value, 'prof', false, 'unAcronyme');
$_smarty_tpl->tpl_vars['prof']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['unAcronyme']->value => $_smarty_tpl->tpl_vars['prof']->value) {
$_smarty_tpl->tpl_vars['prof']->do_else = false;
?>
							<option value="<?php echo $_smarty_tpl->tpl_vars['unAcronyme']->value;?>
"><?php echo smarty_modifier_truncate($_smarty_tpl->tpl_vars['prof']->value['nom'],20,'...');?>
 <?php echo $_smarty_tpl->tpl_vars['prof']->value['prenom'];?>
 [<?php echo $_smarty_tpl->tpl_vars['unAcronyme']->value;?>
]</option>
						<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
						</select><br>
						<button type="submit" name="button" class="btn btn-primary btn-block"><<< Ajouter</button>
						<input type="hidden" name="classe" value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
">
						<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
						<input type="hidden" name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
">
						<input type="hidden" name="etape" value="ajouter">
						</form>
					<?php }?>
				</div>
				<div class="panel-footer">
					Sélectionnez un ou plusieurs professeurs
				</div>
			</div>

		</div>

		<div class="col-md-6 col-sm-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h2>Mémo</h2>
				</div>
  				<div class="panel-body">
					<select name="memo" class="form-control" size="20">
					<?php
$_from = $_smarty_tpl->smarty->ext->_foreach->init($_smarty_tpl, $_smarty_tpl->tpl_vars['listeTitus']->value, 'lesTitus', false, 'classe');
$_smarty_tpl->tpl_vars['lesTitus']->do_else = true;
if ($_from !== null) foreach ($_from as $_smarty_tpl->tpl_vars['classe']->value => $_smarty_tpl->tpl_vars['lesTitus']->value) {
$_smarty_tpl->tpl_vars['lesTitus']->do_else = false;
?>
						<option value=''><?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
:
						<?php echo implode($_smarty_tpl->tpl_vars['lesTitus']->value['acronyme'],', ');?>
 <?php echo implode($_smarty_tpl->tpl_vars['lesTitus']->value['nom'],', ');?>
</option>
					<?php
}
$_smarty_tpl->smarty->ext->_foreach->restore($_smarty_tpl, 1);?>
					</select>
				</div>
				<div class="panel-footer">
					Liste de tous les titulaires actuels
				</div>
			</div>

		</div>  <!-- col-md-... -->

	</div>   <!-- row -->

<?php }?>

</div>  <!-- container -->

<?php echo '<script'; ?>
 type="text/javascript">

	$(document).ready(function(){

		$("#titus").submit(function(){
			$("#wait").show();
			$.blockUI();
			})

		$("#titusPossibles").submit(function(){
			$("#wait").show();
			$.blockUI();
			})
	})



<?php echo '</script'; ?>
>
<?php }
}
