<div id="modalPerimees" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalPerimeesLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalPerimeesLabel">Annonces périmées</h4>
      </div>
      <div class="modal-body" style="max-height:25em; overflow: auto;">
          <table class="table table-condensed">
              <tr>
                  <th>DateFin</th>
                  <th>Type</th>
                  <th>Destinataire</th>
                  <th>Texte</th>
              </tr>
              <tbody>
              {foreach from=$annoncesPerimees key=notifId item=data}
                <tr data-notifid="{$data.id}">
                    <td>{$data.dateFin}</td>
                    <td>{$data.HRtype}</td>
                    <td>{$data.trueDestinataire}</td>
                    <td>{$data.texte|truncate:40:'...'}</td>
                </tr>
              {/foreach}
               </tbody>
          </table>

      </div>
      <div class="modal-footer">
          Cliquer pour sélectionner les annonces périmées
        <button type="button" class="btn btn-primary" id="btn-selectNotif">Sélectionner</button>
      </div>
    </div>
  </div>
</div>
