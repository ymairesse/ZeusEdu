<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>

<div id="modalModify" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalModifyLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalModifyLabel">Modification de ma contribution</h4>
      </div>
      <div class="modal-body">
          <form id="formModalModify">
              {if ($acronyme == $postAncien.acronyme) && ($acronyme != $postAncien.auteur)}
              <label for="myPost"><i class="fa fa-exclamation-triangle"></i> Modification en tant que propriétaire du sujet "{$postAncien.sujet}"</label>
              {else}
              <label for="myPost">Ma contribution au sujet {$postAncien.sujet}</label>
              {/if}
              <textarea name="myPost" id="myPost" rows="5" class="form-control">{$postAncien.post}</textarea>
              <input type="hidden" name="postId" id="postId" value="{$postAncien.postId}">
              <input type="hidden" name="idSujet" id="idSujet" value="{$postAncien.idSujet}">
              <input type="hidden" name="idCategorie" id="idCategorie" value="{$postAncien.idCategorie}">
              <input type="hidden" name="proprio" value="{$postAncien.acronyme}">

              <button type="reset" name="reset" id="reset" value="" style="display:none"></button>

          </form>
      </div>
      <div class="modal-footer">
          <div class="btn-group pull-right">
              <button type="button" class="btn btn-default" id="resetNewPost">Annuler</button>
              <button type="button" class="btn btn-primary" id="saveEditedPost">Enregistrer</button>
          </div>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $('#resetNewPost').click(function() {
            $('#reset').trigger('click');
        })

        $('#formModalModify').validate({
            rules: {
                myPost: {
                    required: true,
                    minlength: 20
                }
            }
        })
    })
</script>
