<div id="modalAddCategorie" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAddCategorieLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalAddCategorieLabel">Catégories dans le forum</h4>
      </div>
      <div class="modal-body">

          <form id="formAddCategorie">
              <p>Ajouter une nouvelle catégorie
              {if $idParent == 0}
              principale
              {else}
              fille de la catégorie "<strong>{$libelle}</strong>"
              {/if}
              <div class="form-group">
                  <label for="modalCategorie">Nouvelle catégorie</label>
                  <input type="text" name="modalLibelle" value="" id="modalLibelle" class="form-control" maxlength="40">
                  <span class="help-block">Nom de cette nouvelle catégorie</span>
              </div>

              {if $userStatus == 'racine'}
                  <div class="radio-inline">
                      <label><input type="radio" name="modalUsers" value="eleves">Accessible aux élèves</label>
                  </div>
                  <div class="radio-inline">
                      <label><input type="radio" name="modalUsers" value="profs" checked>Profs et éducs seulement</label>
                  </div>
              {else}
                    <p>Destinataires:
                    {if $userStatus == 'profs'}
                        <strong>Profs/Éducs/Direction</strong>
                        {else}
                        <strong>Élèves</strong>
                    {/if}
                    </p>
                    <input type="hidden" name="modalUsers" value="{$userStatus}">
                {/if}

              <input type="hidden" name="idParent" value="{$idParent|default:0}">

              <button type="button" class="btn btn-primary btn-block" id="btnModalSaveCategorie">Enregistrer</button>
          </form>

      </div>

    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        // activer le champ #modalSubject à l'ouverture du modal
        $('#modalAddCategorie').on('shown.bs.modal', function(){
            $('#modalLibelle').focus();
        })

        $('#formAddCategorie').validate({
            rules: {
                libelle: {
                    required: true,
                }
            }
        })
    })

</script>
