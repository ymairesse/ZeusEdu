<table class="table table-condensed table-bordered">
    <thead>
        <tr>
            <th style="width:2em;">&nbsp;</th>
            <th>&nbsp;</th>
            {foreach from=$listePeriodes key=nb item=noPeriode}
                <th colspan="2" style="text-align:center">
                    Pér. {$noPeriode}<br>
                    {$NOMSPERIODES.$nb}
                </th>
            {/foreach}
            <th style="width:2em">&nbsp;</th>
        </tr>
    </thead>
    <tr>
        <th>&nbsp;</th>
        <th>Élève(s)</th>
        {section name=lesPeriodes start=1 loop=$nbPeriodes+1}
        <th style="width:4em">TJ</th>
        <th style="width:4em">Cert.</th>
        {/section}
        <th>&nbsp;</th>
    </tr>
<pre>
<!--
 {$ponderations|print_r}
-->

</pre>
    {foreach from=$ponderations key=matricule item=periodes}

    <tr>

        {if $matricule == 'all'}
            <td>
                <button type="button" class="btn btn-success btn-sm btn-block btnPlus hide" title="Modifier la pondération pour cet élève uniquement" data-coursgrp="{$coursGrp}" data-bulletin="{$bulletin}">
                    <i class="fa fa-plus"></i>
                </button>
            </td>
            <td>
                <select name="matricule" class="listeEleves form-control" data-coursgrp="{$coursGrp}">
                    <option value="">Tous les élèves</option>
                    {foreach from=$listeEleves key=leMatricule item=eleve}
                    <option value="{$leMatricule}">{$eleve.nom} {$eleve.prenom} ({$eleve.classe})</option>
                    {/foreach}
                </select>
            </td>
        {else}
            <td>
                <button type="button" class="btn btn-danger btn-sm btnMoins btn-block" title="Supprimer cette pondération particulière" data-coursgrp="{$coursGrp}" data-bulletin="{$bulletin}" data-matricule="{$matricule}">
                    <i class="fa fa-minus"></i>
                </button>
            </td>
            <td>
                {$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom} ({$listeEleves.$matricule.classe})
            </td>
        {/if}

        {foreach from=$listePeriodes key=wtf item=noPeriode}
        <td style="text-align:center; padding-right:1em">
            {$ponderations.$matricule.$noPeriode.form}

        </td>
        <td style="text-align:center; padding-right:1em">
            {$ponderations.$matricule.$noPeriode.cert}

        </td>
        {/foreach}

        <td class="cote">
            <button type="button"
            class="btn btn-sm btn-primary btn-block editPonderation"
            title="Modifier pour {if $matricule == 'all'}tous les élèves{else}cet élève{/if}" data-matricule="{$matricule}"
            data-coursgrp="{$coursGrp}"
            data-bulletin="{$bulletin}">
                <i class="fa fa-pencil"></i>
            </button>
        </td>
    </tr>

    {/foreach}
</table>
