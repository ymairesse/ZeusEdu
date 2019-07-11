<div id="modalShowEditValve" class="modal fade draggable" tabindex="-1" role="dialog" aria-labelledby="modalShowMessageTitle" aria-hidden="true">

  <div class="modal-dialog modal-lg">

    <div class="modal-content">

      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalShowMessageTitle">{$notification.objet}</h4>
      </div>

      <div class="modal-body">
          <div class="form-group col-md-6 col-sm-12 hermesEntete">
              <label class="col-sm-2">De</label>
              <input class="col-sm-10" readonly value="{$notification.prenom} {$notification.nom}">
          </div>

          <div class="form-group col-md-6 col-sm-12 hermesEntete">
              <label class="col-sm-2">Le</label>
              <input class="col-sm-10" readonly value="{$notification.date|truncate:5:''} {$notification.heure|truncate:5:''}">
          </div>

          <div class="col-sm-12">
              <ul class="listePJ">
                  {foreach from=$notification.pj item=unePJ}
                  <li><i class="fa fa-paperclip"></i> <a href="download.php?type=idFile&amp;notif={$notification.id}&amp;n={$unePJ.n}&amp;file={$unePJ.PJ}">{$unePJ.PJ}</a></li>
                  {/foreach}
              </ul>
          </div>

          <div class="col-md-12 col-sm-12 hermesMessage">
              {$notification.texte}
          </div>

      </div>

      <div class="modal-footer" >
        <button type="button" class="btn btn-default" data-dismiss="modal" style="margin-top: 1em;">Fermer</button>
      </div>
    </div>
  </div>
</div>
