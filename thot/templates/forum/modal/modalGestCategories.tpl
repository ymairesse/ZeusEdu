
<div id="modalGestCategories" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalGestCategoriesLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalGestCategoriesLabel">Gestion des catégories</h4>
      </div>
      <div class="modal-body">
          <div class="row">

          <div class="col-xs-6">
              <div class="panel panel-info">
                  <div class="panel-heading">
                      Catégories
                  </div>
                  <div class="panel-body" style="height:20em; overflow: auto;" id="modalListeCategories">
                      {include file="forum/treeviewCategories.tpl"}
                  </div>

              </div>
          </div>

          <div class="col-xs-6">

              <div class="form-group">
                  <label for="categorie">Catégorie sélectionnée</label>
                  <input type="text" name="categorie" id="categorie" class="form-control" value="" readonly>
                  <span class="help-block" id="helpCategorie">Type de forum</span>
              </div>

              <div class="btn-group btn-group-justified">
                  <a href="javascript:void(0)" type="button" class="btn btn-success btn-xs btn-edit" disabled id="btn-renameCategorie" title="Modifier cette catégorie" data-container="body"><i class="fa fa-edit"></i> Modifier</a>
                  <a href="javascript:void(0)" type="button" class="btn btn-danger btn-xs btn-edit" disabled id="btn-delCategorie" title="Supprimer cette catégorie" data-container="body"><i class="fa fa-times"></i> Supprimer</a>
              </div>

              <div class="form-group">
                  <label for="sousCategorie">Sous-catégorie à créer</label>
                  <input type="text" name="sousCategorie" id="sousCategorie" class="form-control" value="" readonly>
                  <span class="help-block">Sous-catégorie</span>
              </div>

              <input type="hidden" name="idCategorie" id="idCategorie" value="">
              <input type="hidden" name="userStatus" id="userStatus" value="">
              <button type="button" class="btn btn-primary btn-block" id="btnNewCategorie">Créer la nouvelle catégorie</button>

              <p style="border: 1px solid grey; padding: 0.5em;">Sélectionnez une catégorie dans la colonne de gauche.<br>
              Ajoutez, supprimez des sous-catégories, modifiez le nom de ces catégories. Seules les catégories sans sujets et sans catégories "filles" peuvent être effacées.</p>
          </div>

        </div>

      </div>

    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#modalListeCategories').on('click', '.treeview a', function(){
            var idCategorie = $(this).data('idcategorie');
            var categorie = $(this).text().trim();
            var userStatus = $(this).data('userstatus');
            $('#categorie').val(categorie).removeClass('profs eleves').addClass(userStatus);
            if (userStatus == 'profs')
                $('#helpCategorie').text('Uniquement les enseignants');
                else $('#helpCategorie').text('Élèves (et enseignants)');
            $('#idCategorie').val(idCategorie);
            $('#userStatus').val(userStatus);
            $('#sousCategorie').prop('readonly', false);
            $('.btn-edit').attr('disabled', false);
        })

    })

</script>
