<div id="modalAddSubject" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalAddSubjectLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalAddSubjectLabel">{if isset($idSujet)}Modifier un sujet de{else}Ajouter un sujet à{/if} la catégorie <strong>{$categorie.libelle}</strong></h4>
      </div>
      <div class="modal-body">

          <form id="formAddSubject">

              <div class="form-group">
                  <label for="modalSubject">
                    {if isset($idSujet)}
                        Modification du sujet "{$sujet}" dans la catégorie "{$categorie.libelle}"
                    {else}
                        Nouveau sujet: {$categorie.libelle}
                    {/if}</label>
                  <textarea name="modalSubject" id="modalSubject" rows="2" cols="80" class="form-control" maxlength="80">{$sujet|default:''}</textarea>
                  <span class="help-block">Thème de ce nouveau sujet (80 caractères max)</span>
              </div>

              <div id="selecteurCible">
                {if $categorie.userStatus == 'eleves'}
                    {include file="forums/modal/selectProfsEleves.tpl"}
                {else}
                    {include file="forums/modal/selectProfs.tpl"}
                {/if}
              </div>

              <input type="hidden" name="modalIdCategorie" value="{$categorie.idCategorie}">
              <input type="hidden" name="modalIdSujet" value="{$idSujet|default:''}">

              <button type="button" class="btn btn-primary btn-block" id="btnModalSaveSubject">Enregistrer</button>
          </form>

      </div>

    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        // activer le champ #modalSubject à l'ouverture du modal
        $('#modalAddSubject').on('shown.bs.modal', function(){
            $('#modalSubject').focus();
        })

        $('#formAddSubject').validate({
            rules: {
                modalSubject: {
                    required: true,
                },
                choixCibleEleve: {
                    required: true,
                }
            }
        })
    })

</script>
