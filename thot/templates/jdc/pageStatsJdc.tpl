{if isset($listeCoursProfs)}
<div style="height:45em; overflow:auto">

    <table class="table table-condensed">

    {foreach from=$listeCoursProfs key=acronyme item=data}
        <tr>
            <th colspan="3">{$acronyme} <span class="h4">{$data.nom}</span></th>
        </tr>
        {assign var=lesCours value=$data.cours}
        {foreach from=$lesCours key=coursGrp item=dataCours}
        <tr {if $dataCours.virtuel != 0}class="virtuel" title="Ce cours est virtuel"{/if}>
            <td>
                {$coursGrp}
            </td>
            <td>
                {$dataCours.libelle} {$dataCours.nbheures}h {$dataCours.statut}
            </td>
            <td>
                <strong>{$listeStats.$acronyme.$coursGrp|default:0} JDC(s)</strong>
            </td>
        </tr>
        {/foreach}

    {/foreach}

    </table>

</div>

{else}
    <div class="avertissement">
        Veuillez sélectionner des enseignants et des types d'items dans la colonne de gauche
    </div>
{/if}
