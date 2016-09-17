<div class="modal fade" id="modalShareEdit" tabindex="-1" role="dialog" aria-labelledby="shareEditTitle" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="shareEditTitle">Modifier le commentaire d'un document</h4>
            </div>
            <div class="modal-body">

                <p>Nom du fichier: <strong id="shareEditFileName"></strong></p>
                <p>Répertoire: <strong id="shareEditPath"></strong></p>
                <p>Partagé avec: <strong id="shareEditSharedWith"></strong></p>

                <input type="text" name="commentaire" value="" class="form-control" id="shareEditCommentaire">
                <input type="hidden" name="shareId" id="shareEditId" value="">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" id="saveComment">Enregistrer</button>
                </div>
                <div class="clearfix"></div>
            </div>

        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {
        $("#saveComment").click(function() {
            var shareId = $("#shareEditId").val();
            var commentaire = $("#shareEditCommentaire").val();
            $.post('inc/files/saveCommentaire.inc.php', {
                    shareId: shareId,
                    commentaire: commentaire
                },
                function(resultat) {
                    $(".shareEdit[data-shareid='" + shareId + "']").data('commentaire', commentaire);
                    $(".shareEdit[data-shareid='" + shareId + "']").closest('div').attr('title', commentaire);
                    $("#modalShareEdit").modal('hide');
                })
        })
    })
</script>
