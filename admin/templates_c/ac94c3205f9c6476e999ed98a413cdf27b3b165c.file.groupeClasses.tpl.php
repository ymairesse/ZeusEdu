<?php /* Smarty version Smarty-3.1.13, created on 2017-05-20 19:02:15
         compiled from "./templates/groupeClasses.tpl" */ ?>
<?php /*%%SmartyHeaderCode:106271489359207697b7d942-39967587%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'ac94c3205f9c6476e999ed98a413cdf27b3b165c' => 
    array (
      0 => './templates/groupeClasses.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '106271489359207697b7d942-39967587',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'listeGroupes' => 0,
    'nomGroupe' => 0,
    'lesClasses' => 0,
    'action' => 0,
    'listeClasses' => 0,
    'selectedClasses' => 0,
    'classe' => 0,
    'groupe' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_59207697b94564_12901486',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_59207697b94564_12901486')) {function content_59207697b94564_12901486($_smarty_tpl) {?><div class="container">

	<div class="row">
		
		<div class="col-md-6 col-sm-12">
			
			<fieldset>
				<legend>Grouper des classes</legend>
				<?php if (count($_smarty_tpl->tpl_vars['listeGroupes']->value)>0){?>
					<form name="formGroupe" id="formGroupe" action="index.php" method="POST">
					<h3>Groupes existants</h3>
					<table class="table table-condensed table-striped">
						<thead>
							<tr>
								<th>Nom du groupe</th>
								<th>Formé des classes</th>
								<th>Séparer</th>
							</tr>
						</thead>
					<?php  $_smarty_tpl->tpl_vars['lesClasses'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['lesClasses']->_loop = false;
 $_smarty_tpl->tpl_vars['nomGroupe'] = new Smarty_Variable;
 $_from = $_smarty_tpl->tpl_vars['listeGroupes']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['lesClasses']->key => $_smarty_tpl->tpl_vars['lesClasses']->value){
$_smarty_tpl->tpl_vars['lesClasses']->_loop = true;
 $_smarty_tpl->tpl_vars['nomGroupe']->value = $_smarty_tpl->tpl_vars['lesClasses']->key;
?>
						<tr>
							<td><strong><?php echo $_smarty_tpl->tpl_vars['nomGroupe']->value;?>
</strong></td>
							<td><strong><?php echo implode(", ",$_smarty_tpl->tpl_vars['lesClasses']->value);?>
</strong></td>
							<td><input type="checkbox" name="checkbox_<?php echo $_smarty_tpl->tpl_vars['nomGroupe']->value;?>
" value="<?php echo $_smarty_tpl->tpl_vars['nomGroupe']->value;?>
"></td>
					<?php } ?>
						</tr>
					</table>
					<div class="btn-group pull-right">
						<button class="btn btn-default" type="reset" name="reset" id="reset">Annuler</button>
						<button class="btn btn-primary" type="submit" name="submit" id="submit">Dégrouper</button>
					</div>
					<input type="hidden" name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
">
					<input type="hidden" name="mode" value="unGroup">
					</form>
				<?php }?> 
			</fieldset>

		</div>  <!-- col-md... -->
		
		<div class="col-md-6 col-sm-12">
			<fieldset>
				<legend>DEgrouper des classes</legend>
				<form name="form" action="index.php" method="POST" role="form" class="form-vertical">
					
					<h3>Formation de nouveaux groupes de classes</h3>
					<div class="input-group">
						<label for="classes">Choisir une ou plusieurs classes</label>
						<select name="classes[]" size="10" multiple="multiple" id="classes" class="form-control">
							<?php  $_smarty_tpl->tpl_vars['classe'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['classe']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['listeClasses']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['classe']->key => $_smarty_tpl->tpl_vars['classe']->value){
$_smarty_tpl->tpl_vars['classe']->_loop = true;
?>
								<?php if (isset($_smarty_tpl->tpl_vars['selectedClasses']->value)){?>
								<option value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
"<?php if (in_array($_smarty_tpl->tpl_vars['classe']->value,$_smarty_tpl->tpl_vars['selectedClasses']->value)){?> selected<?php }?>><?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
</option>
								<?php }else{ ?>
								<option value="<?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
"><?php echo $_smarty_tpl->tpl_vars['classe']->value;?>
</option>
								<?php }?>
							<?php } ?>
						</select>
						<div class="help-block">Maintenir une touche Ctrl enfoncée pour une sélection multiple</div>
					</div>
					
					<div class="input-group">
						<label for="groupe">Nom du groupe à former</label>
						<input type="text" name="groupe" id="groupe" value="<?php echo (($tmp = @$_smarty_tpl->tpl_vars['groupe']->value)===null||$tmp==='' ? null : $tmp);?>
" maxlength="5" class="form-control">
					</div>
					<input type="hidden" name="action" value="gestEleves">
					<input type="hidden" name="mode" value="groupEleve">
					<div class="btn-group pull-right">
						<button class="btn btn-default" type="reset" name="reset" id="reset">Annuler</button>
						<button class="btn btn-primary" type="submit" name="OK">Grouper</button>						
					</div>

				</form>
			</fieldset>

		</div> <!-- col-md... -->

	</div>  <!-- row -->

</div>  <!-- container --><?php }} ?>