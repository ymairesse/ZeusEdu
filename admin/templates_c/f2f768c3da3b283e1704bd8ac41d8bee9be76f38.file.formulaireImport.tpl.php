<?php /* Smarty version Smarty-3.1.13, created on 2017-06-30 15:20:46
         compiled from "./templates/formulaireImport.tpl" */ ?>
<?php /*%%SmartyHeaderCode:19769176325956502e1c7593-90541986%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'f2f768c3da3b283e1704bd8ac41d8bee9be76f38' => 
    array (
      0 => './templates/formulaireImport.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '19769176325956502e1c7593-90541986',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'table' => 0,
    'CSVfile' => 0,
    'action' => 0,
    'mode' => 0,
    'champs' => 0,
    'unChamp' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_5956502e1d6f93_21496413',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5956502e1d6f93_21496413')) {function content_5956502e1d6f93_21496413($_smarty_tpl) {?><div class="container">
	
<fieldset style="clear:both">
	<legend>Importation des données de la table <strong><?php echo $_smarty_tpl->tpl_vars['table']->value;?>
</strong></legend>
	
	<div class="row">
		
		<div class="col-md-4 col-sm-12">
		
			<form method="POST" action="index.php" id="formImport" name="formImport" enctype="multipart/form-data" class="form-vertical">
				<div class="btn-group-vertical">
					<span class="btn btn-default btn-file">
						<span>Sélectionner un fichier</span><input name="<?php echo $_smarty_tpl->tpl_vars['CSVfile']->value;?>
" type="file" id="nomFichierCSV">
					</span>
					<button class="btn btn-primary" type="submit">Envoyer</button>
				</div>
				<input name="table" value="<?php echo $_smarty_tpl->tpl_vars['table']->value;?>
" type="hidden">
				<input name="action" value="<?php echo $_smarty_tpl->tpl_vars['action']->value;?>
" type="hidden">
				<input name="mode" value="<?php echo $_smarty_tpl->tpl_vars['mode']->value;?>
" type="hidden">
			</form>
				
		</div>  <!-- col-md-... -->	
		
		<div class="col-md-8 col-sm-12">
			<div class="notice">
				<p>Veuillez sélectionner le fichier .csv correspondant</p>
				<p>Champs attendus (dans l'ordre)</p>
					<ul>
						<?php  $_smarty_tpl->tpl_vars['unChamp'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['unChamp']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['champs']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['unChamp']->key => $_smarty_tpl->tpl_vars['unChamp']->value){
$_smarty_tpl->tpl_vars['unChamp']->_loop = true;
?>
							<li><span style="width:15em; float:left; display:block"><?php echo $_smarty_tpl->tpl_vars['unChamp']->value['Field'];?>
</span>
								<?php if ($_smarty_tpl->tpl_vars['unChamp']->value['Comment']){?> -> <span  style="color:blue" class="micro"><?php echo $_smarty_tpl->tpl_vars['unChamp']->value['Comment'];?>
</span><?php }?></li>
						<?php } ?>
					</ul>
				<p>Dans le fichier .CSV, les champs sont séparés par des virgules (,) et sont entourés par des guillemets doubles (").</p>
				<p>Le fichier .CSV doit être encodé en UTF-8.</p>
				<p>Il est important de vérifier la cohérence entre les données envoyées et les données attendues.</p>
			</div>
		</div>


	</div>  <!-- row -->

</fieldset>

</div>  <!-- container -->

<script type="text/javascript">
	
$(document).on('change', '.btn-file :file', function() {
    var input = $(this),
        numFiles = input.get(0).files ? input.get(0).files.length : 1,
        label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.trigger('fileselect', [numFiles, label]);
});	
	

$(document).ready(function(){
	
	$('.btn-file :file').on('fileselect', function(event, numFiles, label) {
        $(".btn-file span").text(label);
		});	
	
	
	$("#formImport").submit(function(){
		$("#wait").show();
		$.blockUI();
		})
	})

</script><?php }} ?>