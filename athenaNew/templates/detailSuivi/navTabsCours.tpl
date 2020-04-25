<ul class="nav nav-tabs">
    {foreach from=$listeCotesCours key=periode item=dataCotes name=boucleCotes}
    <li {if $smarty.foreach.boucleCotes.first}class="active"{/if}>
        <a data-toggle="tab" href="#cours{$nCours}_cotes{$smarty.foreach.boucleCotes.iteration}">Période {$periode}</a>
    </li>
    {/foreach}
</ul>

<div class="tab-content" style="height: 25em; overflow: auto;">

    {foreach from=$listeCotesCours key=periode item=dataCotes name=boucleCotes}
    <div id="cours{$nCours}_cotes{$smarty.foreach.boucleCotes.iteration}" class="table-responsive tab-pane fade{if $smarty.foreach.boucleCotes.first} in active{/if}">

        <table class="table table-condensed">
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
            {foreach from=$listeCotesCours.$periode item=uneCote name=nCote}
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

</div>

<div>
    Légende des couleurs <span class="form">Formatif</span> <span class="cert">Certificatif</span>
</div>
