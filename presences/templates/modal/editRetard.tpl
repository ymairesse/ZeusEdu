<div id="modalEdit" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalEditLabel">Modification du retard</h4>
      </div>
      <div class="modal-body">
          <div class="col-xs-7">
              <form id="modalFormRetards">

                  <div class="form-group">
                      <label for="matricule">Matricule</label>
                      <div class="input-group">
                          <input type="text" class="form-control" name="matricule" id="modal_matricule" value="" readonly tabindex="1">
                          <span class="input-group-addon" tabindex="2" id="barcode"> <i class="fa fa-barcode"></i> </span>
                      </div>
                      <span class="help-block">Matricule de l'élève (scanné)</span>
                  </div>

                  <div class="form-group">
                      <label for="periodes">Heure normale d'arrivée</label>
                      <select class="form-control" name="periode" id="modal_periode">
                          {foreach from=$listePeriodesCours key=i item=unePeriode}
                          <option value="{$i}" {if $i==$periodeActuelle} selected{/if}>{$unePeriode.debut} - {$unePeriode.fin}</option> 
                          {/foreach}
                       </select>
                   </div>
                   <div class="form-group">
                       <label for="heure">Heure du scan</label>
                       <input type="time" name="heure" id="modal_heure" value="{$heure|default:''}" class="form-control input-lg">
                    <span class="help-block">Heure au moment du scan</span>
                  </div>

                  <div class="form-group">
                      <label for="date">Date du retard</label>
                      <input type="text" name="date" id="modal_date" class="datepicker form-control" value="{$date|default:''}">
                  </div>

              </form>
          </div>
          <div class="col-xs-5">
              <img src="" id="modal_photo" class="img-responsive">
              <strong id="modal_nomEleve"></strong>
          </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary btn-block" name="button" id="btn-changeModalRetard">OK</button>
      </div>
    </div>
  </div>
</div>
