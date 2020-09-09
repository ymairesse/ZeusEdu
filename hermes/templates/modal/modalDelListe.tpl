<div id="modalDelListe" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalDelListeLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalDelListeLabel">Veuillez confirmer la suppression de cette liste</h4>
      </div>
      <div class="modal-body">
        <p>Nom de la liste: <strong>{$detailslListe.nomListe}</strong></p>
          <p>Cette liste comporte <strong>{$membres|@count}</strong> membre(s)</p>
          <p>Cette liste compte <strong>{$abonnes|@count}</strong> abonné(s)</p>

      </div>
      <div class="modal-footer">
          <button type="button" class="btn btn-danger" id="btn-modalDelListe" data-idliste="{$detailslListe.id}">Supprimer cette liste</button>
      </div>
    </div>
  </div>
</div>
