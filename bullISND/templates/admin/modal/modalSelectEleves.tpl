<div id="modalSelectEleves" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalSelectElevesLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalSelectElevesLabel">{$coursGrp} {$detailsCoursGrp.statut} {$detailsCoursGrp.libelle} {$detailsCoursGrp.nbheures}h</h4>
      </div>
      <div class="modal-body">
          <div class="col-xs-5" id="listeElevesCours">

              {include file="admin/modal/listeElevesCoursGrp.tpl"}

          </div>

          <div class="col-xs-2">
              <div class="btn-group-vertical  btn-block">
                  <button type="button" class="btn btn-primary" style="margin: 3em 0" id="ajoutEleves" data-coursgrp="{$coursGrp}"><<<</button>
                  <button type="button" class="btn btn-primary" style="margin: 3em 0" id="supprEleves" data-coursgrp="{$coursGrp}">>>></button>
              </div>
          </div>

          <div class="col-xs-5">
              <div class="form-group">
                  <label for="listeNiveaux">Niveau d'étude</label>
                  <select class="form-control" name="listeNiveaux" id="listeNiveaux">
                      {foreach from=$listeNiveaux item=niveau}
                      <option value="{$niveau}"{if $niveau == $guessNiveau} selected{/if}>{$niveau}e année</option>
                      {/foreach}
                  </select>
              </div>

              <div class="form-group" id="listeClasses">
                  {include file="admin/modal/listeClasses.inc.tpl"}
              </div>

              <div class="form-group" id="listeElevesClasse">

                  {include file="admin/modal/listeElevesClasse.inc.tpl"}

              </div>

          </div>

      </div>
      <div class="modal-footer">
        <button type="button" name="button" data-dismiss="modal" >Terminer</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#listeNiveaux').change(function(){
            var niveau = $(this).val();
            $.post('inc/admin/getListeClassesNiveau.inc.php', {
                niveau: niveau
            }, function(resultat){
                $('#listeClasses').html(resultat);
            })
        })

        $('#listeClasses').change(function(){
            var classe = $('#listeClasses option:selected').val();
            $.post('inc/admin/getListeElevesClasse.inc.php', {
                classe: classe
            }, function(resultat){
                $('#listeElevesClasse').html(resultat);
            })
        })
    })

</script>
