<div id="modalConfirmDelRes" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalConfirmDelResLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalConfirmDelResLabel">Suppression de la ressource "{$infoRessource.description}"</h4>
      </div>
      <div class="modal-body">
          <p>Vous allez supprimer la ressource "<strong>{$infoRessource.description} [{$infoRessource.reference}]"</strong> de type "<strong>{$infoRessource.type}</strong>"</p>
          <p>Vous allez supprimer l'historique des <strong>{$listesReservations.count.avant}</strong> réservation(s) avant aujourd'hui.</p>
          <p>Vous allez supprimer <strong>{$listesReservations.count.apres}</strong> réservation(s) prévue(s).</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" id="btn-modalDelRessource" data-idressource="{$infoRessource.idRessource}">Je confirme cette suppression</button>
      </div>
    </div>
  </div>
</div>
