<div id="modalEditGrappe" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditGrappeLabel" aria-hidden="true">

  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalEditGrappeLabel">{if isset($idGrappe)}Édition{else}Crétation{/if} d'une grappe</h4>
      </div>
      <div class="modal-body">
        
        <div class="row">
          <div class="col-xs-6">

            <form id="form4grappe">

            <div class="input-group">
              
              <input type="text" name="grappe" id="modalGrappe" class="form-control" value="{$detailsGrappe['grappe']|default:''}">
              <div class="input-group-btn">
                <button class="btn btn-primary" type="button" title="Modifier le libellé" id="modalSaveLibelle">
                <i class="fa fa-save"></i>
              </button>
              </div>
            </div>

            <input type="hidden" name="idGrappe" id="idGrappe" value="{$idGrappe|default:''}">

            <div class="form-group">
              <label for="modalNiveau">Niveau d'étude</label>
              <select class="form-control" name="niveau" id="modalNiveau">
                <option value="">Niveau d'étude</option>
                {foreach from=$listeNiveaux key=wtf item=niveau}
                <option value="{$niveau}">{$niveau}e année</option>
                {/foreach}
              </select>
            </div>

            <div class="form-group" id="selectCours">
              <label for="modalCours">Cours</label>
              <select class="form-control" name="cours" id="modalCours">
                <option value="">Sélectionner un niveau d'étude</option>
              </select>
            </div>

            <button type="button" class="btn btn-success btn-block" id="sendToGrappe" disabled>
              Envoyer dans la grappe >>>
            </button>

            </form>

          </div>

          <div class="col-xs-6">

            <div id="coursGrappe">
              {include file="uaa/selectCoursGrappe.tpl"}
            </div>
            <button class="btn btn-danger btn-block" id="btn-delCoursGrappe" disabled><<< Supprimer de la grappe</button>
          
          </div>

        </div>

      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-primary pull-right" data-dismiss="modal" class="close">Terminer</button>

      </div>
    </div>
  </div>

</div>
