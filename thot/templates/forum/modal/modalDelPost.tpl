<div id="modalDelPost" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalDelPostLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalDelPostLabel">Suppression de cette contribution</h4>
      </div>
      <div class="modal-body">
          <p class="text-danger"><strong><i class="fa fa-exclamation-triangle fa-2x"></i> Attention, vous allez supprimer cette contribution au sujet<br> "{$postAncien.sujet}"</strong></p>
          <div style="max-height:5em; overflow:auto; border: 1px solid #777; margin: 1em; padding:1em;">
              {$postAncien.post}
          </div>
        <p class="text-danger"><strong>Veuillez confirmer. Cette contribution deviendra inaccessible.</strong></p>
        <form id="formModalDelPost" class="hidden">
            <input type="hidden" name="postId" id="postId" value="{$postAncien.postId}">
            <input type="hidden" name="idSujet" id="idSujet" value="{$postAncien.idSujet}">
            <input type="hidden" name="idCategorie" id="idCategorie" value="{$postAncien.idCategorie}">
        </form>
      </div>
      <div class="modal-footer">
        <div class="btn-group">
            <button type="button" class="btn btn-default btn-naaaan">Non! Surtout pas.</button>
            <button type="button" class="btn btn-danger" id="btn-confirmDelPost" data-postid="{$postAncien.postId}">Je confirme</button>
        </div>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){
        $('.btn-naaaan').click(function(){
            $('button.close').trigger('click');
        })
    })

</script>
