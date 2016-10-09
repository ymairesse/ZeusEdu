<div class="modal fade" id="modalDelDir" tabindex="-1" role="dialog" aria-labelledby="titleModalDelDir" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleModalDelDir">Effacement d'un dossier</h4>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger">
                    <i class="fa fa-warning fa-2x pull-right text-danger"></i>
                    <p>Veuillez confirmer la suppression définititve du dossier
                        <br><strong id="delRep"></strong>
                        <br> qui fait partie du dossier
                        <br>
                        <strong id="rootRep"></strong></p>
                </div>
                <div id="attention" class="hidden">
                    <div class="alert alert-warning">
                        <p>Attention, ce dossier contient les fichiers suivants:</p>
                        <div id="listFiles"></div>
                    </div>
                </div>

            </div>
            <div class="modal-footer">
                <div class="btn-group pull-right">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="button" class="btn btn-primary" id="btnConfirmDelDir">Effacer ce dossier</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $("#btnConfirmDelDir").click(function() {
            var activeDir = $("#activeDir").text();
            var nextActive = activeDir.substring(0, activeDir.length - 1).substring(0, activeDir.substring(0, activeDir.length - 1).lastIndexOf('/') + 1);

            $.post('inc/files/delDir.inc.php', {
                    activeDir: activeDir
                },
                function(resultat) {
                    if (parseInt(resultat) > 0) {
                        $('[data-dir="' + activeDir + '"]').closest('.folder').remove();
                        $("#activeDir").text(nextActive);
                        $(".dirLink[data-dir='" + nextActive + "']").addClass('activeDir');

                        // recalcul du nombre de fichiers dans le "nextActive"
                        var nbFiles = parseInt($(".dirLink[data-dir='" + nextActive + "']").data('nbfiles'));
                        $(".dirLink[data-dir='" + nextActive + "']").data('nbfiles', nbFiles - 1);

                        // remise en ordre des infos de la zone dirInfo
                        $("#diDir").text(nextActive);
                        var nbFiles = $(".dirLink[data-dir='" + nextActive + "']").data('nbfiles');
                        $("#diNb").text(nbFiles);

                        if (nextActive != '/')
                            $("#btnDeldir").removeClass('disabled');
                        else $("#btnDeldir").addClass('disabled');
                    } else alert('Houston, We\'ve Got a Problem. Ce dossier ne peut être supprimé');
                })
            $("#modalDelDir").modal('hide');
        })

    })
</script>
