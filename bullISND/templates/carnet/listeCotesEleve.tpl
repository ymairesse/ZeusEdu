{if $listeCotes != Null}
<ul class="nav nav-tabs">
    {foreach from=$listeCotes key=laPeriode item=dataCotes name=boucle}
    <li{if ($periode == $laPeriode) } class="active"{/if}>
        <a data-toggle="tab"
            class="oneTab"
            data-periode="{$laPeriode}"
            href="#periode_{$laPeriode}">
            Période {$laPeriode}
        </a>
    </li>
    {/foreach}
</ul>


<div class="tab-content">
{foreach from=$listeCotes key=laPeriode item=dataCotes name=boucle}

<div id="periode_{$laPeriode}"
    data-periode="{$laPeriode}"
    class="tab-pane fade{if $smarty.foreach.boucle.index == 0} in active{/if}">
    <table class="table table-condensed table-responsive">
        <thead>
            <tr>
                <th style="width:2em;">n°</th>
                <th>Date</th>
                <th>Titre</th>
                <th>Compétence</th>
                <th style="width:3em;">Cote</th>
                <th style="width:1em;">&nbsp;</th>
                <th style="width:3em;">Max</th>
            </tr>
        </thead>
        {foreach from=$listeCotes.$laPeriode item=uneCote name=nCote}
        <tr class="{$uneCote.formCert}">
            <td>{$smarty.foreach.nCote.iteration}</td>
            <td>{$uneCote.date}</td>
            <td>{$uneCote.libelle}</td>
            <td>{$uneCote.competence}</td>
            <td {if $uneCote['echec']}class="echec"{/if}>{$uneCote.cote}</td>
            <td>/</td>
            <td {if $uneCote['echec']}class="echec"{/if}>{$uneCote.max}</td>
        </tr>
        {/foreach}
    </table>

</div>

{/foreach}

<div>
    Légende des couleurs <span class="form">Formatif</span> <span class="cert">Certificatif</span>
</div>

{else}
    <p class="avertissement">Aucune évaluation dans ce répertoire</p>
{/if}
