<div class="modal fade" id="modalDel" tabindex="-1" role="dialog" aria-labelledby="titreSuppression" aria-hidden="true">

	<div class="modal-dialog">

		<div class="modal-content">

			<div class="modal-header">

				<h4 class="modal-title" id="titreSuppression">Suppression de l'annonce</h4>

			</div>

			<div class="modal-body">

                <p><i class="fa fa-warning fa-2x text-danger"></i> Voulez-vous vraiment supprimer l'annonce intitulée</p>
				<p style="text-align:center"><strong>{$title}</strong></p>

			</div>

			<div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" name="button" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-danger" id="btn-modalDelNews" data-id="{$id|default:''}" name="button">Supprimer cette annonce</button>
                </div>
			</div>

		</div>

	</div>

</div>
