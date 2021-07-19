<div class="modal fade" id="modalPonderation" tabindex="-1" role="dialog" aria-labelledby="titleMod" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <div id="titleMod">Modifier les pondérations</div>
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

                        {$nomEleve}
                </h4>

                <form name="formPonderations" id="formPonderations">
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

                        {foreach from=$listePeriodes item=periode}

                            <tr>
                                <td>{$periode}</td>
                                <td>{$NOMSPERIODES[$periode-1]|default:'NA'}</td>
                                <td>
                                    <input type="text"
                                        class="poids form-control"
                                        value="{$listePonderations.$periode.form}"
                                        {if ($bulletin > $periode)}
                                        readonly
                                        title="Cette période est passée et n'est plus modifiable"
                                        {/if}
                                        name="formatif_{$periode}" maxlength="3">
                                </td>
                                <td>
                                    <input type="text"
                                        class="poids form-control"
                                        value="{$listePonderations.$periode.cert}"
                                        {if ($bulletin > $periode)}
                                        readonly
                                        title="Cette période est passée et n'est plus modifiable"
                                        {/if}
                                        name="certif_{$periode}"
                                        maxlength="3">
                                </td>
                            </tr>

                        {/foreach}

                        </tbody>

                    </table>
                    <input type="hidden" name="coursGrp" value="{$coursGrp}">
                    <input type="hidden" name="matricule" id="matricule" value="{$matricule}">

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-primary" id="savePonderation">Enregistrer</button>
            </div>

        </div>
    </div>
</div>
