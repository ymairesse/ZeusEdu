<div id="modalAddPartage" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAddPartageLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalAddPartageLabel">Ajout de partages</h4>
      </div>
      <div class="modal-body">
          <form id="formAddShare">
              <div class="row">
                  <div class="col-md-6 col-sm-12">
                      <div class="panel panel-info">
                          <div class="panel-heading">
                              Liste des professeurs
                          </div>
                          <div class="panel-body" style="height: 25em; overflow:auto">
                              <button type="button" class="btn btn-primary btn-xs btn-block" id="selectAllProfs">Sélectionner tous</button>
                              <select class="form-control" name="profs[]" id="profs" style="height:100%" multiple>
                                  {foreach from=$listeProfs key=acronyme item=data}
                                  <option value="{$acronyme}"{if isset($guest) && $guest == $acronyme} selected{/if}{if isset($guest) && $guest != $acronyme} disabled{/if}>
                                      {$data.nom} {$data.prenom} [{$acronyme}]
                                  </option>
                                  {/foreach}
                              </select>

                          </div>
                          <div class="panel-footer micro">
                              Ctrl enfoncé pour une sélection multiple
                          </div>
                      </div>
                  </div>

                  <div class="col-md-6 col-sm-12">
                      <div class="panel panel-success">
                          <div class="panel-heading">
                              Liste des élèves
                          </div>
                          <div class="panel-body" style="height:20em; overflow:auto">
                              <select class="form-control" name="eleves[]" id="eleves" style="height: 100%" multiple>
                                  {foreach from=$listeEleves key=matricule item=data}
                                    <option value="{$matricule}" selected>{$data.nom} {$data.prenom} [{$data.groupe}]</option>
                                  {/foreach}
                              </select>

                          </div>
                          <div class="panel-footer micro">
                              Ctrl enfoncé pour une sélection multiple
                          </div>
                      </div>

                    <h4>Mode de partage</h4>
          			<div class="radio">
          				<label>
          					<input type="radio" name="moderw" value="r" {if ($mode == 'r')} checked{/if}> Lecture seule
          				</label>
          			</div>

          			<div class="radio">
          				<label>
          					<input type="radio" name="moderw" value="rw"{if $mode == 'rw'} checked{/if}> Lecture/écriture
          				</label>
          			</div>

          			<div class="radio">
          				<label>
          					<input type="radio" name="moderw" value=""{if $mode == ''} checked{/if}> Fin du partage
          				</label>
          			</div>

                  </div>
              </div>

              <button type="button" class="btn btn-primary pull-right" id="modalConfirmAddShare">Confirmer</button>
              <div class="clearfix"></div>
          </form>

      </div>

    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#selectAllProfs').click(function(){

            $('#profs option').prop('selected', true);

        })
    })

</script>
