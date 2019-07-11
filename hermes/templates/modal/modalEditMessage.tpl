<div id="myModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
          <div class="row">
              <div class="col-md-4 col-sm-12">
                  <div class="form-group">
                      <label for="expediteur">Expéditeur</label>
                      {if $userStatus == 'direction' || $userStatus == 'admin'}
                          <select name="mailExpediteur" id="expediteur" class="form-control">
                              <option value="{$NOREPLY}">{$NOMNOREPLY}</option>
                              {foreach from=$listeDirection key=acro item=someone}
                                  <option value="{$someone.mail}"{if $acronyme == $acro} selected="selected"{/if}>{$someone.nom}</option>
                              {/foreach}
                          </select>
                      {else}
                          <input type="hidden" name="mailExpediteur" value="{$identite.mail}">
                          <p class="form-control-static" style="font-weight:bold">{$identite.prenom} {$identite.nom}</p>
                      {/if}
                  </div>  <!-- form-group -->
              </div>

              <div class="col-md-2 col-sm-3 checkbox">
                  <label><input type="checkbox" name="publier" id="publier" value="1"> Publier aux valves</label>
              </div>

              <div class="col-md-3 col-sm-3 form-group">
                  <label for="fin">Effacé après le</label>
                  <input type="text" name="fin" id="fin" class="datepicker form-control" value="" placeholder="Date de fin" disabled required>
              </div>

              <div class="col-md-3 col-sm-6">
                  <button type="button" class="btn btn-info btn-block" id="btn-addPJ"><i class="fa fa-plus"></i> <i class="fa fa-file-o"></i> Ajouter PJ</button>

                  <ul id="PjFiles" class="list-unstyled" style="max-height:5em; overflow:auto;">
                  </ul>
              </div>

          </div>

          <div class="form-group">
              <span id="grouper" title="créer un groupe" style="display:none"><img src="images/groupe.png" alt="grouper"></span>
              <label>Destinataire(s):</label>
              <span class="form-control-static" id="destinataires"></span>
              <label for="mails[]" class="error" style="display:none">Veuillez sélectionner au moins un destinataire</label>
          </div>

          <div class="form-group" id="nomGroupe" style="display:none">
              <label for="groupe">Nom du groupe</label>
              <input type="text" id="groupe" name="groupe" placeholder="Nom du groupe" class="form-control">
              <div class="help-block">Choisissez un nom pour ce nouveau groupe de mailing</div>
          </div>

          <div class="row">
              <div class="form-group col-xs-9">
                  <label for="objet" class="sr-only">Objet</label>
                  <input type="text" name="objet" id="objet" placeholder="Objet de votre mail" class="form-control">
              </div>
              <div class="col-xs-3">
                  <button class="btn btn-primary btn-block" type="button" id="btn-envoi">Envoyer</button>
              </div>
          </div>
          <div class="form-group">
              <label for="texte">Votre message</label>
              <textarea id="texte" name="texte" rows="15" class="ckeditor form-control" placeholder="Frappez votre texte ici" autofocus="true"></textarea>
          </div>

              <label class="pull-right">Ajout de disclaimer
                  <input type="checkbox" name="disclaimer" id='disclaimer' value="1" checked>
              </label>
          <div class="clearfix"></div>
      </div>
      <div class="modal-footer">
        ...
      </div>
    </div>
  </div>
</div>
