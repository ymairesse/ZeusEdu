<div id="modalDel" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalDelLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalDelLabel">Annulation d'un RV</h4>
      </div>
      <div class="modal-body">
          <p>Veuillez confirmer la suppression du RV de <strong>{$eleve.prenom} {$eleve.nom}</strong></p>
          <p>En date du <strong>{$rv.date}</strong> à <strong>{$rv.heure}</strong></p>
      </div>
      <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
          <button type="button" class="btn btn-danger" id="btnConfirmDelRV" data-id="{$rv.id}">Confirmer</button>
      </div>
    </div>
  </div>
</div>
