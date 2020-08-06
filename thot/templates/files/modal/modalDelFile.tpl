<div class="modal fade" id="modalDelFile" tabindex="-1" role="dialog" aria-labelledby="titleDelFile" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleDelFile">Effacement d'un fichier</h4>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger">
                    <i class="fa fa-warning fa-2x pull-right text-danger"></i>
                    <p>Veuillez confirmer l'effacement définitif du fichier <strong id="delFileName">{$fileName}</strong>
                        <br> dans le dossier <strong id="delPath">{$arborescence}</strong></p>
                </div>

                <p>
                    <strong><i class="fa fa-warning fa-2x text-danger"></i> Attention!
                        <ul>
                            <li>tous les partages du document et </li>
                            <li>tous les suivis de téléchargement seront supprimés.</li>
                        </ul>
                    </strong>
                </p>

                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-danger" id="confirmDelFile">Confirmer</button>
                </div>
            </div>
            <div class="modal-footer">
                <p class="help-block">Ctrl + clic sur le bouton d'effacement pour éviter cette demande de confirmation</p>
            </div>
        </div>
    </div>
</div>
