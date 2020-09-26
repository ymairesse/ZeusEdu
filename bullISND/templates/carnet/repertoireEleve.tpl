<div id="repertoire">

    <div class="tab-content">
        {foreach from=$listeCoursGrp key=coursGrp item=dataCoursGrp name=boucleCoursGrp}
        {assign var=nCours value=$smarty.foreach.boucleCoursGrp.iteration}
        <div id="cours{$smarty.foreach.boucleCoursGrp.iteration}" class="tab-pane fade{if $smarty.foreach.boucleCoursGrp.first} in active{/if}">
            <h3>{$dataCoursGrp.libelle} {$dataCoursGrp.nbheures}h [{$dataCoursGrp.nom}]</h3>
            {if isset($listeCotes.$coursGrp)}
                {assign var=listeCotesCours value=$listeCotes.$coursGrp}
                {assign var=nCours value=$smarty.foreach.boucleCoursGrp.iteration}

                {include file="detailSuivi/navTabsCours.tpl"}
            {else}
                <p class="avertissement">Répertoire vide</p>
            {/if}

        </div>
        {/foreach}
    </div>

</div>
