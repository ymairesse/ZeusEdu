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
                <div id="listFiles">
                    {include file="files/listFiles.tpl"}
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
            var arborescence = $('#rootRep').data('arborescence');
            var directory = $('#delRep').data('filename');

            $.post('inc/files/delDir.inc.php', {
                    arborescence: arborescence,
                    directory: directory
                },
                function(resultat) {
                    var resultatJS = JSON.parse(resultat);
                    var nbDir = parseInt(resultatJS.nbDir);
                    var nbFiles = parseInt(resultatJS.nbFiles);
                    if (nbDir > 0) {
                        bootbox.alert({
                                title: "Effacement d'un dossier",
                                message: '<strong>1</strong> dossier contenant <strong>' + resultatJS.nbFiles + '</strong> fichier(s) supprimé(s)'
                            });
                    } else alert('Houston, We\'ve Got a Problem. Ce dossier ne peut être supprimé');
                });
            // supprimer la ligne du tableau des fichiers
            $('#listeFichiers tr.active').remove();
            $("#modalDelDir").modal('hide');
        })

    })
</script>
