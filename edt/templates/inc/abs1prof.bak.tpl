<th data-dateedt="{$dateEDT}" data-acronyme="{$acronyme}">
    <a href="#" class="badge badge-danger badge-xs pull-right btn-delFuture" title="Supprimer toutes les absences futures">
        <i class="fa fa-forward"></i>
    </a>

    {$nomProf}<br>{$acronyme}

</th>

{foreach from=$periodes key=periode item=data}
    {assign var=heure value=$data.debut}
    {if isset($dataProf.$heure)}
        <td class="hActive"
            data-toggle="popover"
            data-acronyme="{$acronyme}"
            data-starttime="{$dataProf.$heure.startTime}"
            data-dateFR="{$dataProf.$heure.dateFR}"
            data-heure="{$heure}"
            data-trigger="hover"
            data-container="body"
            data-placement="auto"
            data-html="true"
            data-original-title=""
            data-title="{$dataProf.$heure.dateFR} {$heure}"
            data-content="<div style='text-align:left'>{$acronyme} : {$nomProf}<br>
                {$dataProf.$heure.matiere}<br>
                Profs: {$dataProf.$heure.profs}<br>
                Classes: {$dataProf.$heure.classes}<br>
                Parties: {$dataProf.$heure.parties}</div>">
            <a href="#" class="badge badge-danger badge-xs pull-right btn-delAbs"><i class="fa fa-times"></i></a>
            <span class="event"
                data-starttime="{$heure}"
                data-acronyme="{$acronyme}"
                data-starttime="{$dataProf.$heure.startTime}"
                draggable="true">
                <div style="cursor:pointer;height:100%"
                    class="change-statut">
                    <span class="hidden-sm hidden-xs">{$dataProf.$heure.brancheFR}<br></span>{$dataProf.$heure.classe}<br>
                    {$dataProf.$heure.local}
                </div>
            </span>
        </td>
        {else}
        <td class="drop" data-starttime="{$dateSQL} {$data.debut}:00">
            &nbsp;
        </td>
        {/if}
    </td>
{/foreach}
