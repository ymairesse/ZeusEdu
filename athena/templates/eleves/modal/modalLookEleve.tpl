<div id="modalLook" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalLookLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalLookLabel">Demande d'aide</h4>
      </div>
      <div class="modal-body">
          <div class="row">
              <div class="col-xs-9">
                  <h3>{$demande.prenom} {$demande.nom} [{$demande.groupe}]</h3>
                  <p>Date de la demande: <strong>{$demande.laDate}</strong> à <strong>{$demande.heure}</strong></p>
                  <h3>Mon commentaire</h3>
                  <texterea readonly>{$demande.commentaire}</textarea>
                <hr>
                <h3>J'ai choisi le contact par</h3>
                    <ul>
                        {if in_array('mailprive', $listeMedias)}
                          <li>Mon adresse mail privée: <a href="mailto:{$demande.mail}">{$demande.mail}</a></li>
                        {/if}
                        {if in_array('mailscolaire', $listeMedias)}
                        <li>Mon adresse mail scolaire: <a href="mailto:{$mailScolaire}">{$mailScolaire}</a></li>
                        {/if}
                        {if in_array('gsm', $listeMedias)}
                        <li>Mon GSM: {$demande.GSM}</li>
                        {/if}
                    </ul>

                <h3>Mes demandes concernent</h3>
                    <ul>
                        {if in_array('Motivation', $listeObjets)}
                        <li>La motivation</li>
                        {/if}
                        {if in_array('Bienetre', $listeObjets)}
                        <li>Le bien-être</li>
                        {/if}
                        {if in_array('Organisation', $listeObjets)}
                        <li>L'organisation</li>
                        {/if}
                        {if in_array('Soutien', $listeObjets)}
                        <li>Le soutien</li>
                        {/if}
                        {if in_array('Autre', $listeObjets)}
                        <li>Autre chose</li>
                        {/if}
                    </ul>

                {if $listeCoaches|@count > 0}
                    <h3>{$demande.prenom} a déjà rencontré</h3>
                    <ul>
                        {foreach from=$listeCoaches key=acronyme item=data}
                            <li>{$data.nomProf}</li>
                        {/foreach}
                    </ul>
                {/if}
              </div>
              <div class="col-xs-3">
                 <img src="../photos/{$photo}.jpg" alt="{$demande.matricule}" style="float:right" class="photo img-responsive">
              </div>

          </div>

      </div>
      <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
      </div>
    </div>
  </div>
</div>
