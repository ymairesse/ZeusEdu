<div id="modalDel" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h3 class="modal-title">Suppression d'une réunion de parents</h3>
      </div>
      <div class="modal-body">
        <h4>Date de la réunion: <span id="delDate">{$infoRP.date}</span></h4>

            <p>Veuillez confirmer la suppression définitive de cette réuntion de parents.</p>
            <p>Cette action n'est à faire qu'après la fin de la réunion de parents et la liquidation des listes d'attente.</p>
            <p class="text-danger">Attention, tous les rendez-vous seront également effacés définitivement.</p>

      </div>
      <div class="modal-footer">

          <div class="btn-group">
              <button type="button" id="btn-modalDel" class="btn btn-danger pull-right" data-idrp="{$idRP}">Supprimer</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
          </div>
      </div>
    </div>

  </div>
</div>
