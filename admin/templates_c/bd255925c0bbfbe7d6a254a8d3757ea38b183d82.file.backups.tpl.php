<?php /* Smarty version Smarty-3.1.13, created on 2017-05-18 16:07:01
         compiled from "./templates/backups.tpl" */ ?>
<?php /*%%SmartyHeaderCode:255401780591daa854a6d49-78643888%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'bd255925c0bbfbe7d6a254a8d3757ea38b183d82' => 
    array (
      0 => './templates/backups.tpl',
      1 => 1478537040,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '255401780591daa854a6d49-78643888',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'listeFichiers' => 0,
    'unFichier' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_591daa854b7bb9_85337220',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_591daa854b7bb9_85337220')) {function content_591daa854b7bb9_85337220($_smarty_tpl) {?><?php if (!is_callable('smarty_modifier_date_format')) include '/home/yves/www/sio2/peda/smarty/plugins/modifier.date_format.php';
if (!is_callable('smarty_function_math')) include '/home/yves/www/sio2/peda/smarty/plugins/function.math.php';
?><h4>Derniers backups</h4>

<div class="table-responsive">
	
	<table class="table table-striped table-hover table-condensed" style="margin:auto">
		<thead>
		<tr>
			<th style="width:20em">Nom du fichier</th>
			<th style="width:12em">Date</th>
			<th style="width:6em">Taille</th>
			<th>Effacer</th>
		</tr>
		</thead>
		<?php  $_smarty_tpl->tpl_vars['unFichier'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['unFichier']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['listeFichiers']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['unFichier']->key => $_smarty_tpl->tpl_vars['unFichier']->value){
$_smarty_tpl->tpl_vars['unFichier']->_loop = true;
?>
		<tr>
			<td><a href="./save/<?php echo $_smarty_tpl->tpl_vars['unFichier']->value['fileName'];?>
" target="_blank"><?php echo $_smarty_tpl->tpl_vars['unFichier']->value['fileName'];?>
</a></td>
			<td><?php echo smarty_modifier_date_format($_smarty_tpl->tpl_vars['unFichier']->value['fileDate'],"%x");?>
</td>
			<td>
				<?php if ($_smarty_tpl->tpl_vars['unFichier']->value['fileSize']>1000000){?>
				<?php ob_start();?><?php echo smarty_function_math(array('equation'=>"size / 1024 / 1024",'size'=>$_smarty_tpl->tpl_vars['unFichier']->value['fileSize']),$_smarty_tpl);?>
<?php echo sprintf("%.0f",ob_get_clean())?> Mio
				<?php }else{ ?>
				<?php ob_start();?><?php echo smarty_function_math(array('equation'=>"size / 1024",'size'=>$_smarty_tpl->tpl_vars['unFichier']->value['fileSize']),$_smarty_tpl);?>
<?php echo sprintf("%.0f",ob_get_clean())?> Kio
				<?php }?>
			</td>
			<td style="text-align:center">
				<button type="btn btn-default" class="btnDelete" data-filename="<?php echo $_smarty_tpl->tpl_vars['unFichier']->value['fileName'];?>
">
					<i class="fa fa-times" style="color:red" title="Effacer le fichier"></i>
				</button>
				<a href="index.php?action=backup&amp;mode=delete&amp;fileName=<?php echo $_smarty_tpl->tpl_vars['unFichier']->value['fileName'];?>
">
				
				</a>
			</td>
		</tr>
		<?php } ?>
	</table>

</div>


<div id="myModal" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true" aria-labeldby="modal-title">

	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="modal-title">Confirmation</h4>
			</div>

			<div class="modal-body text-warning">
				<p>Voulez-vous vraiment effacer le fichier <span id="nomFichier"></span> ?</p>
				<p>Attention, l'effacement est définitif.</p>
			</div>

			<div class="modal-footer">
				<form name="delBackup" id="delBackup" method="POST" action="index.php">
					<input type="hidden" name="fileName" id="fileName" value="">
					<input type="hidden" name="action" value="backup">
					<input type="hidden" name="mode" value="delete">
					<div class="btn-group pull-right">
						<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
						<button type="submit" class="btn btn-primary">Effacer</button>
					</div>
				</form>
			</div>

		</div>
	</div>

</div>




<script type="text/javascript">
	
	$(document).ready(function(){
		
		$(".btnDelete").click(function(){
			var fileName = $(this).data('filename');
			$("#nomFichier").text(fileName);
			$("#fileName").val(fileName);
			$("#myModal").modal('show');
			})
		
		})
	
</script><?php }} ?>