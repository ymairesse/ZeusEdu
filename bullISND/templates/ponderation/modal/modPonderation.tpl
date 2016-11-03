<div class="modal fade" id="modPonderation" tabindex="-1" role="dialog" aria-labelledby="titleMod" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h3 class="modal-title" id="titleMod">Modifier les pondérations</h3>
            </div>
            <div class="modal-body">
                Bulletin en cours: {$bulletin} <strong class="pull-right">
                    {$intituleCours.annee} : {$intituleCours.statut}
                  {if $intituleCours.nomCours}  {$intituleCours.nomCours}
                  {else} {$intituleCours.libelle}
                  {/if}
                  {$intituleCours.nbheures}h ({$listeClasses})
              </strong>
                <h4 id="destinataire">

                        <!-- emplacement à compléter en Ajax -->
                </h4>

                <form name="formPonderations" method="POST" action="index.php" id="formPonderations" class="form-vertical" role="form">
                    <table class="table table-condensed">
                        <thead>

                            <tr>
                                <th style="width:2em">Pér.</th>
                                <th>Nom</th>
                                <th>Formatif</th>
                                <th>Certificatif</th>
                            </tr>

                        </thead>

                        <tbody>

                            <!--  emplacement à compléter en Ajax -->
                            <!-- ponderation/formPonderation.tpl  -->

                        </tbody>

                    </table>
                    <input type="hidden" name="coursGrp" value="{$coursGrp}">
                    <input type="hidden" name="matricule" id="matricule" value="{$matricule}">
                    <input type="hidden" name="action" value="{$action}">
                    <input type="hidden" name="mode" value="modifBareme">
                    <div class="btn-group pull-right">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-primary">Enregistrer</button>
                    </div>
                    <div class="clearfix"></div>
                </form>

            </div>

        </div>
    </div>
</div>
