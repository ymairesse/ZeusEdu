<div class="box">

    <div class="row">
        <div class="col-sm-3">
            <button
                type="button"
                class="btn btn-success btn-block"
                id="carnetCotes"
                data-idtravail="{$infoTravail.idTravail}">
                Carnet de cotes <i class="fa fa-arrow-left"></i>
            </button>
        </div>

        <div class="col-sm-9">
            <select class="form-control" id="selectEleve">
                <option value="">Sélectionnez un élève</option>
                {foreach from=$listeTravauxRemis key=leMatricule item=dataTravail}
                <option
                    class="{if $dataTravail.remis == 1}remis{else}nonRemis{/if}"
                    value="{$leMatricule}"
                    data-idtravail="{$dataTravail.idTravail}"
                    {if isset($matricule) && ($matricule == $leMatricule)}selected{/if}>
                    {$dataTravail.groupe} - {$dataTravail.nom} {$dataTravail.prenom}
                    {if isset($listeEvaluations.$leMatricule)}[{$listeEvaluations.$leMatricule.total.cote} / {$listeEvaluations.$leMatricule.total.max}]{/if}
                </option>
                {/foreach}
            </select>
        </div>

    </div>

    <div id="detailsEvaluation">
        {if ($matricule != '') && ($idTravail != Null)}
            {if in_array($matricule, array_keys($listeTravauxRemis))}
                {include file='casier/detailsEvaluation.tpl'}
            {/if}
            {else}
            <p class='avertissement'>Veuillez sélectionner un travail dans la colonne de gauche</p>
        {/if}
    </div>

</div>
