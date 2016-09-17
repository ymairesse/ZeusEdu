<!-- ......................   Boîte modale pour la suppression d'une news ..................... -->

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
