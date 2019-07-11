<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div id="modalShowEditValve" class="modal fade draggable" tabindex="-1" role="dialog" aria-labelledby="modalShowMessageTitle" aria-hidden="true">

  <div class="modal-dialog modal-lg">

    <div class="modal-content">

      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalShowMessageTitle">Modification de l'annonce</h4>
      </div>

      <div class="modal-body">
          <div class="row">

              <div class="col-sm-9 form-group">
                  <label for="objet">Objet</label>
                  <input type="text" name="objet" value="{$notification.objet}" class="form-control">
              </div>

              <div class="col-md-3 col-sm-3 form-group">
                  <label for="fin">Effacé après le</label>
                  <input type="text" name="fin" id="fin" class="datepicker form-control" value="{$notification.dateFin}" placeholder="Date de fin" required>
              </div>

              <div class="col-sm-12">
                  <ul class="listePJ">
                      {foreach from=$notification.pj item=unePJ}
                      <li><i class="fa fa-paperclip"></i> <a href="download.php?type=idFile&amp;notif={$notification.id}&amp;n={$unePJ.n}&amp;file={$unePJ.PJ}">{$unePJ.PJ}</a></li>
                      {/foreach}
                  </ul>
              </div>

          </div>

              <div class="col-md-12 col-sm-12 hermesMessage">
                  <div class="form-group">
                      <label for="texte">Votre message</label>
                      <textarea id="texte" name="texte" rows="15" class="ckeditor form-control" placeholder="Frappez votre texte ici" autofocus="true">{$notification.texte}</textarea>
                  </div>
              </div>

      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-delValve btn-danger pull-left">Supprimer cette annonce</button>

        <div class="btn-group">
            <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
            <button type="button" class="btn btn-primary" id="btn-saveValve">Enregistrer</button>
        </div>

      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $('document').ready(function(){

        CKEDITOR.replace('texte');

        $('.datepicker').datepicker({
            format: "dd/mm/yyyy",
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
            });

    })

</script>
