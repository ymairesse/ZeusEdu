<div id="modalLongTerme" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalLongTermeLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalLongTermeLabel">Emprunt à long terme</h4>
      </div>
      <div class="modal-body">
          <form id="formLongTerme">

              <div class="row">

                  <div class="col-xs-12 col-md-6">
                      <div class="form-group">
                          <label for="type">Type de ressource</label>
                          <input type="text" id="type" class="form-control" name="type" value="{$ressource.type}" readonly>
                      </div>
                  </div>

                  <div class="col-xs-12 col-md-6">
                     <div class="form-group">
                         <label for="description">Nom de cette ressource</label>
                         <input type="text" id="description" class="form-control" name="description" value="{$ressource.description}" readonly>
                         <div class="help-block">Local C22, tablette, PC portable,...</div>
                     </div>
                  </div>

                  <div class="col-xs-12 col-md-6">
                      <div class="form-group">
                          <label for="Référence">Référence</label>
                          <input type="text" id="reference" value="{$ressource.reference}" name="reference" class="form-control" readonly>
                          <div class="help-block">
                              Référence unique (étiquette, n° de série,...)
                          </div>
                      </div>
                  </div>

                  <div class="col-xs-12 col-md-6">
                      <div class="form-group">
                          <label for="localisation">Localisation</label>
                          <input type="text" id="localisation" value="{$ressource.localisation}" name="localisation" class="form-control" readonly>
                          <div class="help-block">Lieu de stockage, bâtiment,...</div>
                      </div>
                  </div>

                  <div class="col-xs-2 col-md-2">
                      <div class="checkbox">
                          <label><input type="checkbox" name="hasCaution" id="hasCaution" value="1" {if $ressource.hasCaution==1}checked{/if}>Caution?</label>
                      </div>
                  </div>

                  <div class="col-xs-4 col-md-4">
                      <div class="form-group">
                          <label for="montant">Montant</label>
                          <input type="text" name="caution" id="caution" value="{$ressource.caution}" class="form-control" {if $ressource.hasCaution == 0}disabled{/if}>
                          <div class="help-block">Montant de la caution</div>
                      </div>
                  </div>

                  <div class="col-xs-12 col-md-6">
                      <div class="checkbox">
                          <label><input type="checkbox" name="indisponible" id="indisponible" value="1" {if $ressource.indisponible==1}checked{/if}>
                              Temporairement indisponible
                          </label>
                      </div>
                  </div>

                  <div class="col-xs-12 col-md-6">
                      <div class="form-group">
                          <input type="text"
                              name="longTermeBy"
                              id="longTermeBy"
                              value="{$ressource.longTermeBy|default:''}"
                              class="form-control"
                              placeholder="Matricule ou acronyme"
                              {if $ressource.indisponible==1} readonly{/if}>
                          <div class="help-block">Emprunt à long terme <span id="emprunteur" style="color: red">
                              {$emprunteur}
                              </span>
                          </div>
                      </div>

                  </div>

                  <div class="col-xs-12">
                      <div class="form-group">
                          <label for="etat">État</label>
                          <textarea name="etat" id="etat" rows="3" class="form-control" placeholder="État de cette ressource">{$ressource.etat}</textarea>
                          <div class="help-block">Description des avaries éventuelles</div>
                      </div>
                  </div>

              </div>

              <input type="hidden" name="idRessource" id="idRessource" value="{$ressource.idRessource}">
              <input type="hidden" name="idType" id="idType" value="{$ressource.idType}">

          </form>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="saveModalLongTerme">Enregistrer</button>
      </div>
    </div>
  </div>
</div>


<script type="text/javascript">

    $(document).ready(function(){

        $('#indisponible').change(function(){
            var checked = $(this).is(':checked');
            $('#longTermeBy').val('').attr('readonly', checked);
            if (checked) {
                $('#longTermeBy').text('');
            }
        })

        $('#longTermeBy').blur(function(){
            var qui = $(this).val();
            if (qui == '') {
                $('#indisponible').prop('checked', false);
                $('#longTermeBy').attr('disabled', true);
                $('#emprunteur').text('');
                validator.resetForm();
            }
            else {
                $.post('inc/ressources/search4qui.inc.php', {
                    qui: qui
                }, function(resultat){
                    $('#emprunteur').text(resultat);
                })
            }
        })

    })

</script>
