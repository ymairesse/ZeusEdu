<div class="modal fade" id="modalUnShareFile" tabindex="-1" role="dialog" aria-labelledby="modalUnShareFTitle" aria-hidden="true">

    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalUnShareFTitle">Arrêter le partage d'un fichier</h4>
            </div>

            <div class="modal-body">
                <div class="alert alert-danger">
                    <i class="fa fa-share-alt-square fa-2x"></i> Veuillez confirmer l'arrêt du partage du
                    {if $fileInfos.fileType == 'dir'} dossier{else}fichier{/if} <strong id="modalUnShareFileName">{$fileInfos.fileName}</strong>
                    <br> Actuellement partagé avec <strong>{$libelle}</strong>
                    <p><i class="fa fa-user-secret fa-2x"></i> S'ils existent, les suivis de téléchargement seront également supprimés.</p>
                </div>
                <div class="notice">
                    Le fichier est conservé. Seul le partage est interrompu.<br>
                    Les partages éventuels avec d'autres personnes ou groupes sont conservés.
                </div>

            </div>

            <div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" data-shareid="{$shareId}" id="btnUnShareFile" class="btn btn-primary">Confirmer</button>
                </div>
            </div>
        </div>
    </div>

</div>
