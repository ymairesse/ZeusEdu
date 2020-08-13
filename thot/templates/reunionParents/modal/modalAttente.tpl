<div id="modalAttente" class="modal fade" role="dialog">
    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h3 class="modal-title">Liste d'attente</h3>
            </div>
            <div class="modal-body">
                <h4>Choix d'une liste d'attente pour la réunion de parents</h4>

                <form action="index.php" method="POST" role="form" class="form-vertical" id="formListeAttente" name="formListeAttente">

                    <p>Veuillez choisir une liste d'attente pour l'élève.</p>
                    <table class="table table-condensed">
                        <tr class="attente1">
                            <td>Période 1: {$listePeriodes[1].min} - {$listePeriodes[1].max} </td>
                            <td>
                                <button type="button" class="btn btn-sm pull-right btn-success periode" id="periode1" data-periode="1" name="button">Période 1</button>
                            </td>
                        </tr>
                        <tr class="attente2">
                            <td>Période 2: {$listePeriodes[2].min} - {$listePeriodes[2].max} </td>
                            <td>
                                <button type="button" class="btn btn-sm pull-right btn-success periode" id="periode2" data-periode="2" name="button">Période 2</button>
                            </td>
                        </tr>
                        <tr class="attente3">
                            <td>Période 3: {$listePeriodes[3].min} - {$listePeriodes[3].max}</td>
                            <td>
                                <button type="button" class="btn btn-sm pull-right btn-success periode" id="periode3" data-periode="3" name="button">Période 3</button>
                            </td>
                        </tr>
                    </table>
                    <div class="clearfix"></div>

                    <input type="hidden" name="matricule" id="attenteMatricule" value="">
                    <input type="hidden" name="acronyme" id="attenteAcronyme" value="">

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
            </div>
        </div>

    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        $(".periode").click(function() {
            var periode = $(this).data('periode');
            var matricule = $("#attenteMatricule").val();
            var acronyme = $("#attenteAcronyme").val();
            var idRP = $("#idRP").val();
            // introduire en liste d'attente
            $.post('inc/reunionParents/setListeAttente.inc.php', {
                idRP: idRP,
                acronyme: acronyme,
                matricule: matricule,
                periode: periode
            }, function(resultat) {
                // pas de résultat à traiter
            });
            // recomposer la liste des RV du prof "acronyme"
            $.post('inc/reunionParents/listeRvAdmin.inc.php', {
                acronyme: acronyme,
                idRP: idRP
                },
                function(resultat){
                    $("#listeRV").html(resultat);
                })
            // retrouver les éléments de la liste d'attente
            $.post('inc/reunionParents/listeAttenteAdmin.inc.php', {
                idRP: idRP,
                acronyme: acronyme,
                matricule: matricule,
                periode: periode
            }, function(resultat) {
                $("#listeAttenteProf").html(resultat);
            });
        $("#modalAttente").modal('hide');
        })

    })
</script>
