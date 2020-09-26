<div id="modalSelectProf" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalSelectProfLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalSelectProfLabel">
            {$coursGrp} {$detailsCoursGrp.statut} {$detailsCoursGrp.libelle} {$detailsCoursGrp.nbheures}h
        </h4>
      </div>
      <div class="modal-body row">

          <div class="col-xs-5" id="listeProfsCours">

              {include file="admin/modal/listeProfsCoursGrp.tpl"}

          </div>

          <div class="col-xs-2">
              <div class="btn-group-vertical  btn-block">
                  <button type="button" class="btn btn-primary" style="margin: 3em 0" id="ajoutProfs" data-coursgrp="{$coursGrp}"><<<</button>
                  <button type="button" class="btn btn-primary" style="margin: 3em 0" id="supprProfs" data-coursgrp="{$coursGrp}">>>></button>
              </div>
          </div>

          <div class="col-xs-5">
              <form id="formProfs">
              <div class="form-group">
                  <label for="listeProfsCoursGrp">Titulaire(s) possibles</label>
                  <select class="form-control" name="listeProfs[]" id="listeProfs" size="10" multiple>
                      {foreach from=$listeProfs key=acronyme item=dataProf}
                      <option value="{$acronyme}">{$dataProf.nom} {$dataProf.prenom} [{$acronyme}]</option>
                      {/foreach}
                  </select>
                  <div class="help-block">Ctrl / Maj pour sélection multiple</div>
              </div>
              </form>
          </div>

      </div>
      <div class="modal-footer">
        <button type="button" name="button" data-dismiss="modal" >Terminer</button>
      </div>
    </div>
  </div>
</div>
