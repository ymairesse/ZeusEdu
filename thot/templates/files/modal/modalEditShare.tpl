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
                <p>Commentaire: <strong id="shareEditSharedWith"></strong></p>

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
