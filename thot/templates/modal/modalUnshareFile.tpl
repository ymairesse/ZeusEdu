<div class="modal fade" id="modalUnShareFile" tabindex="-1" role="dialog" aria-labelledby="modalUnShareFTitle" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalUnShareFTitle">Arrêter le partage d'un fichier</h4>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning">
                    <p>
                        <i class="fa fa-share fa-4x text-danger pull-right"></i> Veuillez confirmer l'arrêt du partage du fichier
                        <br>
                        <strong id="modalUnShareFileName"></strong>
                        <br> Actuellement partagé avec
                        <br>
                        <strong id="modalUnShareWith"></strong>
                    </p>
                </div>
                <div class="alert alert-info">
                    <p>
                        <i class="fa fa-info-circle fa-lg"></i> Le fichier est conservé. Seul le partage est interrompu.
                    </p>
                </div>
            </div>
            <div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" data-shareid="" id="btnUnShareFile" class="btn btn-primary">Confirmer</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $("#btnUnShareFile").click(function() {
            var shareId = $(this).data('shareid');
            $.post('inc/files/unShareFile.inc.php', {
                shareId: shareId
            }, function(resultat) {
                if (resultat.length != 0)
                    alert(resultat);
                else {
                    $(".unShare[data-shareid='" + shareId + "']").closest('.shared').remove();
                }
            })
            $("#modalUnShareFile").modal('hide');
        })

    })
</script>
