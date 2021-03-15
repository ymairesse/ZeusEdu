<?php
/* Smarty version 3.1.34-dev-7, created on 2021-02-09 18:08:39
  from '/home/yves/www/sio2/peda/bullISND/templates/news/modalDelNews.tpl' */

/* @var Smarty_Internal_Template $_smarty_tpl */
if ($_smarty_tpl->_decodeProperties($_smarty_tpl, array (
  'version' => '3.1.34-dev-7',
  'unifunc' => 'content_6022c197b4bd72_84394118',
  'has_nocache_code' => false,
  'file_dependency' => 
  array (
    '2549c774297ebe4f941d5fcfe5bd8a331f06252c' => 
    array (
      0 => '/home/yves/www/sio2/peda/bullISND/templates/news/modalDelNews.tpl',
      1 => 1465733284,
      2 => 'file',
    ),
  ),
  'includes' => 
  array (
  ),
),false)) {
function content_6022c197b4bd72_84394118 (Smarty_Internal_Template $_smarty_tpl) {
?><!-- ......................   Boîte modale pour la suppression d'une news ..................... -->

<div class="modal fade" id="modalDel" tabindex="-1" role="dialog" aria-labelledby="titreSuppression" aria-hidden="true">

	<div class="modal-dialog">

		<div class="modal-content">

			<div class="modal-header">

				<h4 class="modal-title" id="titreSuppression">Suppression de la nouvelle</h4>

			</div>

			<div class="modal-body">

                <p><span class="glyphicon glyphicon-warning-sign" style="font-size:2em; color: red"></span> Voulez-vous vraiment supprimer la nouvelle intitulée</p>
				<p><strong id="newsTitle"></strong>?</p>

			</div>

			<div class="modal-footer">

				<form name="formSuppr" action="index.php" method="POST" class="form-vertical" role="form">
					<button type="submit" class="btn btn-primary pull-rigth">Supprimer</button>
					<button class="btn btn-default pull-right" data-dismiss="modal" type="reset">Annuler</button>
					<input type="hidden" name="id" id="newsId" value="">
					<input type="hidden" name="action" value="news">
					<input type="hidden" name="mode" value="del">
				</form>

			</div>

		</div>

	</div>

</div>
<?php }
}
