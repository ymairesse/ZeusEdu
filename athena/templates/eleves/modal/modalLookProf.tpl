<div id="modalLook" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalLookLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalLookLabel">Demande de prise en charge</h4>
      </div>
      <div class="modal-body">
          <div class="row">
              <div class="col-xs-9">
                  <h3>{$demande.prenom} {$demande.nom} [{$demande.groupe}]</h3>
                  <p>Demande du <strong>{$demande.date}</strong> par <strong>{$demande.prenomProf} {$demande.nomProf}</strong></p>
                  <p>Date de la demande <strong>{$demande.date}</strong></p>
                  <p class="urgence{$demande.urgence}">Prise en charge <strong>{if $demande.urgence ==0}dès que possible{else}urgente{/if}</strong></p>
              </div>
              <div class="col-xs-3">
                   <img src="../photos/{$photo}.jpg" alt="{$demande.matricule}" style="float:right" class="photo img-responsive">
              </div>
          </div>
          <h4>Motif de la demande</h4>
          <div style="padding: 10px; border: 1px solid #999;">{$demande.motif}</div>

          {if $listeCoaches|@count > 0}
              <h4>{$demande.prenom} a déjà rencontré</h4>
              <ul>
                  {foreach from=$listeCoaches key=acronyme item=data}
                      <li>{$data.nomProf}</li>
                  {/foreach}
              </ul>
          {/if}

      </div>
      <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
      </div>
    </div>
  </div>
</div>
