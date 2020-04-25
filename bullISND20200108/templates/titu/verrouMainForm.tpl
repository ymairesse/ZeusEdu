<form name="form" id="formVerrous">

    <div class="table-responsive">
        <table class="table table-condensed">
        <tr>
            <th colspan="2">
                <h2 style="text-align:center">Classe: {$classe}</h2>

                <button type="button" class="btn btn-primary changeLocks" data-type="classe" data-item="{$classe}" title="(Dé)-verrouiller tout"><i class="fa fa-lock fa-4x"></i></button>
                <p>Charte des couleurs</p>
                <ul class="list-unstyled">
                    <li class="unlocked"><i class="fa fa-lock fa-xs"></i> Non verrouillé</li>
                    <li class="lockCotes"><i class="fa fa-lock fa-xs"></i> Cotes verrouillées</li>
                    <li class="lockCotesComs"><i class="fa fa-lock fa-xs"></i> Cotes et Commentaires verrouillés</li>
                </ul>

            </th>
            {foreach from=$listeCoursGrpClasse key=coursGrp item=unCours}
                <th>
                    <img src="imagesCours/{$unCours.cours}.png" title="{$unCours.libelle} ({$coursGrp}) {$unCours.nbheures}h" alt="{$unCours.libelle}"><br>
                    <button type="button" class="btn btn-primary btn-xs changeLocks" data-type="coursGrp" data-item="{$coursGrp}" data-classe="{$classe}" title="(Dé)-verrouiller ce cours"><i class="fa fa-lock fa-fw"></i></button>
                </th>
            {/foreach}
        </tr>
        {foreach from=$listeEleves key=matricule item=unEleve}
        <tr>
            <td data-container="body" title="matr. {$matricule}">{$unEleve.nom} {$unEleve.prenom}</td>

            <td>
                <button type="button" class="btn btn-primary btn-xs changeLocks" data-type="eleve" data-item="{$matricule}" title="(Dé)-verrouiller cet élève"><i class="fa fa-lock fa-fw"></i></button>
            </td>
            {* on prend un à un la liste de tous les cours de cette classe *}
            {foreach from=$listeCoursGrpClasse key=coursGrp item=unCours}
                <td class="cellVerrou">
                    {* L'élève a-t-il ce cours? *}
                    {if isset($listeCoursGrpEleves.$matricule.$coursGrp) && $listeCoursGrpEleves.$matricule.$coursGrp != Null}
                        <button type="button" class="btn btn-xs changeLocks
                        {if $listeVerrous.$matricule.$coursGrp == 1} lockCotes
                            {elseif $listeVerrous.$matricule.$coursGrp == 2} lockCotesComs
                            {else} unlocked{/if}"
                        data-type="eleveCours"
                        data-item="{$matricule}##{$coursGrp}"
                        title="{$coursGrp}">
                            <i class="fa fa-lock"></i>
                        </button>

                    {else}
                        &nbsp;
                    {/if}
                </td>
            {/foreach}
        </tr>
        {/foreach}
        </table>
    </div>  <!-- table-responsive -->
</form>
