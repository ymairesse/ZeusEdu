<div class="modal fade" id="modalShareEdit" tabindex="-1" role="dialog" aria-labelledby="shareEditTitle" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="shareEditTitle">Modifier le commentaire d'un document</h4>
            </div>
            <div class="modal-body">
                <p>Nom du fichier: <strong id="shareEditFileName">{$fileInfos.fileName}</strong></p>
                <p>Répertoire: <strong id="shareEditPath">{$fileInfos.path}</strong></p>
                <div class="form-groupe">
                    <label for="shareEditCommentaire">Votre commentaire pour ce partage</label>
                    <input type="text" name="commentaire" value="{$fileInfos.commentaire}" class="form-control" id="shareEditCommentaire">
                </div>

            </div>

            <div class="modal-footer">
                <input type="hidden" name="shareId" id="shareEditId" value="{$fileInfos.shareId}">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" id="saveComment">Enregistrer</button>
                </div>
            </div>

        </div>
    </div>
</div>
