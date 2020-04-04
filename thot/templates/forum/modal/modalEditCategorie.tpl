<div id="modalEditCategorie" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalEditCategorieLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalEditCategorieLabel">Catégories dans le forum</h4>
      </div>
      <div class="modal-body">

          <form id="formRenameCategorie">
              <p>Renommer la catégorie "<strong>{$libelle}</strong>"
              <div class="form-group">
                  <label for="modalCategorie">Nouvelle catégorie</label>
                  <input type="text" name="modalLibelle" value="{$libelle}" id="modalLibelle" class="form-control" maxlength="40">
                  <span class="help-block">Nom de cette catégorie</span>
              </div>

              <input type="hidden" name="idCategorie" value="{$idCategorie}">
              <input type="hidden" name="userStatus" value="{$userStatus}">

              <button type="button" class="btn btn-primary btn-block" id="btnModalRenameCategorie">Enregistrer</button>
          </form>

      </div>

    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        // activer le champ #modalSubject à l'ouverture du modal
        $('#modalEditCategorie').on('shown.bs.modal', function(){
            $('#modalLibelle').focus();
        })


        $('#formRenameCategorie').validate({
            rules: {
                modalLibelle: {
                    required: true,
                }
            }
        })
    })

</script>
