<div id="modalConfDel" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalConfDelLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalConfDelLabel">Confirmation de l'effacement</h4>
      </div>
      <div class="modal-body">
          <p>Veuillez confirmer l'effacement définitif des informations suivantes:</p>
          <div  style="font-size: 14pt; font-weight: bold">
          <p>{$visite.groupe} {$visite.nom} {$visite.prenom}</p>
          <p>Visite du {$visite.date} à {$visite.heure}</p>
          <p>Motif: {$visite.motif}</p>
        </div>
      </div>
      <div class="modal-footer">
        <div class="button-group">
            <button type="button" class="btn btn-default" data-dismiss="modal" id="btn-close">Annuler</button>
            <button type="button" class="btn btn-danger" id="btn-modalDelVisite" data-consultid="{$visite.consultID}">Je confirme</button>
        </div>
      </div>
    </div>
  </div>
</div>
