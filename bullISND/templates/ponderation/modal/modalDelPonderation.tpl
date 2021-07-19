<div class="modal fade" id="modalDelPonderation" tabindex="-1" role="dialog" aria-labelledby="titlePonderation" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4>Suppression de la pondération pour {$nomEleve}</h4>
      </div>
      <div class="modal-body">

          <table class="table table-condensed">
              <thead>
                  <tr>
                      <th style="width:2em">Pér.</th>
                      <th>Nom</th>
                      <th>Formatif</th>
                      <th>Certificatif</th>
                  </tr>
              </thead>

              <tbody>
              {foreach from=$listePeriodes item=periode}
                  <tr>
                      <td>{$periode}</td>
                      <td>{$NOMSPERIODES[$periode-1]|default:'NA'}</td>
                      <td>
                          <input type="text"
                              class="poids form-control"
                              value="{$listePonderations.$periode.form}"
                              readonly
                              name="formatif_{$periode}">
                      </td>
                      <td>
                          <input type="text"
                              class="poids form-control"
                              value="{$listePonderations.$periode.cert}"
                              readonly
                              name="certif_{$periode}">
                      </td>
                  </tr>
              {/foreach}
              </tbody>

          </table>


          <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
              <button type="button"
                    class="btn btn-primary"
                    data-matricule="{$matricule}"
                    data-coursgrp="{$coursGrp}"
                    id="btn-modalDelPonderation">
                Supprimer
                </button>
          </div>


      </div>

    </div>
  </div>
</div>
