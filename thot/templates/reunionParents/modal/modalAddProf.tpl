<div id="modalAddProf" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAddProfLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalAddProfLabel">Ajout d'un professeur</h4>
      </div>
      <div class="modal-body">
          <div class="row">
              <div class="col-xs-6">

                  <div class="form-group">
                      <label for="listeProfs">Professeurs</label>
                      <select class="form-control" name="modalListeProfs" id="modalListeProfs" size="5">
                          {foreach from=$listeProfs key=acronyme item=data}
                          <option value="{$acronyme}">{$data.nom} {$data.prenom}</option>
                          {/foreach}
                      </select>
                  </div>

              </div>

              <div class="col-xs-6">
                  <label for="statut">Statut</label>
                  <div class="radio">
                      <label><input type="radio" name="statut[]" value="prof" checked class="modalStatut">Professeur</label>
                    </div>
                    <div class="radio">
                      <label><input type="radio" name="statut[]" value="dir" class="modalStatut">Direction</label>
                    </div>
              </div>
              <div>
                  <p>Appliquer le statut "Direction" pour une personne qui ne donne pas de cours.</p>
              </div>
          </div>
      </div>
      <div class="modal-footer">
          <button type="button" class="btn btn-primary" id="btn-modalAddProf">Ajouter</button>
      </div>
    </div>
  </div>
</div>
