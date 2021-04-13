<div id="modalAttente" class="modal fade" role="dialog">

    <div class="modal-dialog">

        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                Liste d'attente
            </div>
            <div class="modal-body">
                <h4>Choix d'une liste d'attente pour la réunion de parents</h4>

                <form action="index.php" method="POST" role="form" class="form-vertical" id="formListeAttente" name="formListeAttente">

                    <p>Veuillez choisir une liste d'attente pour l'élève.</p>
                    <table class="table table-condensed">
                        <tr class="attente">
                            <td>
                                <button type="button" class="btn btn-sm btn-default periode btn-block attente1" id="periode1" data-periode="1" name="button">
                                    Période 1  {$listePeriodes[1].min} - {$listePeriodes[1].max}
                                </button>
                            </td>
                        </tr>
                        <tr class="attente">
                            <td>
                                <button type="button" class="btn btn-sm btn-default periode btn-block attente2" id="periode2" data-periode="2" name="button">
                                    Période 2 {$listePeriodes[2].min} - {$listePeriodes[2].max}
                                </button>
                            </td>
                        </tr>
                        <tr class="attente">
                            <td>
                                <button type="button" class="btn btn-sm btn-default periode btn-block attente3" id="periode3" data-periode="3" name="button">
                                    Période 3 {$listePeriodes[3].min} - {$listePeriodes[3].max}
                                </button>
                            </td>
                        </tr>
                    </table>
                    <div class="clearfix"></div>

                    <input type="hidden" name="matricule" id="attenteMatricule" value="{$matricule}">
                    <input type="hidden" name="acronyme" id="attenteAcronyme" value="{$acronyme}">
                    <input type="hidden" name="idRP" value="{$idRP}">

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
            </div>
        </div>

    </div>
</div>
