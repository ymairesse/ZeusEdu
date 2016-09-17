<div class="modal fade" id="modalMemo" tabindex="-1" role="dialog" aria-labelledby="titleMemo" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="titleMemo">Les documents que je partage</h4>
      </div>
      <div class="modal-body" style="height:30em; overflow: auto">
          <form id="shareInput" class="form-vertical hidden">
            <p><strong id="lblCommentaire"></strong></p>

                <div class="input-group">
                <input type="text" class="form-control" id="memoCommentaire">
                  <span class="input-group-addon">
                      <button type="button" class="btn btn-xs btn-primary" data-shareid="" id="btnSaveComment"><i class="fa fa-save"></i></button>
                  </span>
                </div>

          </form>

          <div id="memoShared">

          </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Terminer</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

$(document).ready(function(){

    $("#memoShared").on('click', '.memoSharedFile', function(){
        $('li').removeClass('active');
        $(this).parent().addClass('active');
        var shareId = $(this).parent().data('shareid');
        var fileId = $(this).closest('.memoFile').data('fileid');
        var fileName = $(this).closest('.memoFile').data('filename');
        var path = $(this).closest('.memoFile').data('path');
        $("#lblCommentaire").html($(this).text()+'<br>'+path+fileName);
        $("#shareInput").removeClass('hidden');
        $('#btnSaveComment').data('shareid', shareId);
        $.post('inc/files/getCommentaire.inc.php', {
            shareId: shareId
        },
        function(resultat) {
            $("#memoCommentaire").val(resultat);
        })

    })

    $("#memoShared").on('click', '.btnEndShare', function(){
        if (confirm('Veuillez confirmer la fin de ce partage')) {
        var shareId = $(this).data('shareid');
        $.post('inc/files/unShareFile.inc.php', {
            shareId: shareId
        },
        function(resultat){
            $('li[data-shareid="'+resultat+'"]').remove();
        })
        }
    })

    $("#btnSaveComment").click(function(){
        $(this).addClass('hidden');
        var shareId = $(this).data('shareid');
        var commentaire = $("#memoCommentaire").val();
        $.post('inc/files/saveCommentaire.inc.php', {
            shareId: shareId,
            commentaire: commentaire
        },
        function(resultat){
            $('li [data-shareid="'+shareId+'"]').attr('title', commentaire);
            $('#btnSaveComment').removeClass('hidden');
        })
    })

})

</script>
