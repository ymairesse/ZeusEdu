<div class="modal fade" id="modalAdd" tabindex="-1" role="dialog" aria-labelledby="hModalAdd" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form class="form-vertical" action="index.php" method="POST" role="form" methode="POST">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="hModalAdd">Ajouter un rendez-vous</h4>
                </div>
                <div class="modal-body">

                    <div class="row">

                        <div class="col-xs-4">
                            <select class="form-control" name="classe" id="#modalClasse">
                                <option value="">Classe</option>
                                {foreach from=$listeClasses item=uneClasse}
                                <option value="{$uneClasse}"{if isset($classe) && ($classe == $uneClasse)} selected{/if}>{$uneClasse}</option>
                                {foreach}
                            </select>
                        </div>
                        <div class="col-xs-8">
                            <select class="form-control" name="eleve" id="#modalEleve">
                                {if isset($listeEleves)}
                                <option value="">Sélectionner un élève</option>
                                {foreach from=$listeEleves key=leMatricule item=unEleve}
                                <option value="{$leMatricule}"{if isset($matricule) && ($matricule = $leMatricule)} selected{/if}>
                                    {$unEleve.nom} {$unEleve.prenom}
                                </option>
                                {/foreach}
                                {/if}
                            </select>
                        </div>  <!-- col-xs-... -->

                    </div>  <!-- row -->

                    <div class="row">

                        <input type="text" name="date" id="modalDate" value="{$date}">
                    </div>







                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary"></button>
                </div>
            </form>
        </div>

    </div>
</div>
