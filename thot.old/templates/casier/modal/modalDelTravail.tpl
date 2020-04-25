<div class="modal fade" id="modalDelTravail" tabindex="-1" role="dialog" aria-labelledby="titleModalDelTravail" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleModalDelTravail">Effacement définitif d'un travail</h4>
            </div>
            <div class="modal-body">
                <div class=" alert alert-danger">
                    <p>Veillez confirmer la suppression définitive du travail suivant:</p>
                    <p><strong>Titre: </strong><span id="modalTitreDel"></span></p>
                    <p>Date de début: <strong id="modalDateDebut"></strong><br> Date de fin: <strong id="modalDateFin"></strong>
                    </p>
                    <p>Nombre de travaux remis par les élèves et qui seront effacés: <strong id="modalNbRemis"></strong></p>
                </div>
            </div>
            <div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-danger" id="btnConfirmDelTravail" data-idtravail="">Confirmer</button>
                </div>

            </div>
        </div>
    </div>
</div>
