<div class="modal fade" id="modalDelCompetence" tabindex="-1" role="dialog" aria-labelledby="titleModalDel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleModalDel">Suppression de cette évaluation</h4>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger">
                    <p><i class="fa fa-"></i>Attention! Cette compétence est déjà évaluée sur <strong id="nbEleves"></strong> copie(s) d'élève(s).</p>
                    <p>Veuillez confirmer la suppression définitive des informations.</p>
                </div>
            </div>
            <div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-danger" id="btn-confirmDel" data-idtravail="" data-idcompetence="">Confirmer l'effacement</button>
                </div>
            </div>
        </div>
    </div>
</div>
