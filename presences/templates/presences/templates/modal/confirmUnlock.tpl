
<!-- boîte modale pour confirmation de déverrouillage -->

<div class="modal fade" id="confirmeVerrou" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">

	<div class="modal-dialog">

		<div class="modal-content">

			<div class="modal-header">
				<h4 class="modal-title" id="labelModal">ATTENTION!!!</h4>
			</div>  <!-- modal-header -->

			<div class="modal-body">
				<p>Souhaitez-vous vraiment déverrouiller cette période? <span id="verrou" style="display:none"></span></p>
				<p>Notez que l'absence de cet-te élève est déjà connue. Il n'est pas souhaitable de la re-signaler.</p>
				<p>Cette possibilité ne devrait être utilisée que pour noter une présence inattendue: malgré l'absence signalée, l'élève se trouve quand même devant vous.</p>
			</div>  <!-- modal-body -->

			<div class="modal-footer">
				 <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                <button type="button" id="unlock" class="btn btn-primary">Déverrouiler malgré tout</button>
			</div>  <!-- modal-footer -->

		</div>  <!-- modal-content -->

	</div>  <!-- modal-dialog -->

</div>  <!-- modal -->
