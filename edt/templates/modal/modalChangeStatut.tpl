<div id="modalChangeStatut" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalChangeStatutLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalChangeStatutLabel">Modification du statut le {$date} à {$heure} [{$absence.acronyme}]</h4>
      </div>
      <div class="modal-body row">

          <form id="formStatut">

              <div class="col-xs-12">

                <label class="checkbox-inline"><input type="checkbox" name="listeStatuts[]" {if in_array('repris', $listeStatuts.normal)}checked{/if} value="repris" tabindex="0">Repris</label>
                <label class="checkbox-inline"><input type="checkbox" name="listeStatuts[]" {if in_array('licencie', $listeStatuts.normal)}checked{/if} value="licencie" tabindex="1">Licencié</label>
                <label class="checkbox-inline"><input type="checkbox" name="listeStatuts[]" {if in_array('travaux', $listeStatuts.normal)}checked{/if} value="travaux" tabindex="2">Travaux</label>
                <label class="checkbox-inline"><input type="checkbox" name="listeStatuts[]" {if in_array('educ', $listeStatuts.normal)}checked{/if} value="educ" tabindex="3">Charge Éducateur</label>
                <label class="checkbox-inline"><input type="checkbox" name="listeStatuts[]" {if in_array('autre', $listeStatuts.normal)}checked{/if} value="autre" tabindex="4">Autre</label>
                <hr>
              </div>

              <div class="form-group col-xs-12">
                  <label for="remarque" class="sr-only">Remarque</label>
                  <input type="text" name="remarque" id="remarque" value="{$absence.remarque}" size="80" class="form-control" placeholder="Information supplémentaire (80 car)" tabindex="5">
              </div>

                <div class="col-xs-3">
                    <input type="text"
                        class="form-control"
                        name="eduprof"
                        id="acronyme"
                        value="{$absence.eduProf}"
                        placeholder="Abrev."
                        style="text-transform:uppercase"
                        tabindex="6">
                </div>
                <div class="col-xs-9">
                    <div class="form-group">
                        <label for="prof" class="sr-only">Responsable</label>
                        <select class="form-control" id="modalListeProfs" tabindex="7">
                            <option value="">Sélectionner un professeur/éducateur</option>
                            {foreach from=$listeProfs key=abreviation item=data}
                            <option value="{$abreviation}"{if $absence.eduProf == $abreviation} selected{/if}>{$data.nom} {$data.prenom}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="col-xs-12">
                    Statut de l'absence
                    <label class="radio-inline"><input type="radio" name="statutAbs" value="ABS" {if $statutAbs == 'ABS'}checked{/if} class="statutAbs">Absence</label>
                    <label class="radio-inline"><input type="radio" name="statutAbs" value="indisponible" {if $statutAbs == 'indisponible'}checked{/if} class="statutAbs">Indisponibilité</label>
                </div>

                <input type="hidden" name="acronyme" value="{$acronyme}">
                <input type="hidden" name="date" value="{$date}">
                <input type="hidden" name="heure" value="{$heure}">
                <input type="hidden" name="startTime" value="{$startTime}">
                {if in_array('movedFrom', $listeStatuts.move)}<input type="hidden" name="listeStatuts[]" value="movedFrom">{/if}
                {if in_array('movedTo', $listeStatuts.move)}<input type="hidden" name="listeStatuts[]" value="movedTo">{/if}

                <div class="clearfix"></div>
        </form>

      </div>

      <div class="modal-footer">
        <button type="button" id="btn-saveStatut" class="btn btn-primary">Enregistrer</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){
        $('#modalChangeStatut').on('shown.bs.modal', function () {
            $('#remarque').focus();
        })
    })

</script>
