<div class="btn-group">
    <button type="button" class="btn btn-default" id="btn-resetMove">Annuler</button>
    <button type="button" class="btn btn-primary" id="btn-saveMove" disabled>Enregistrer les mouvements</button>
    <a class="btn btn-success" type="button" href="inc/print2pdf.php?date={$laDate}"><i class="fa fa-file-pdf-o"></i> Imprimer</a>
</div>

<div id="ajaxLoader" class="hidden">
    <img src="../images/ajax-loader.gif" alt="loading" class="center-block">
</div>

<table class="table table-condensed" id="tableInfos">
    <tr>
        <th style="width:67%;" colspan="2">Infos du jour <button type="button" class="btn btn-success btn-xs" id="btn-addInfo" data-type="info"><i class="fa fa-plus"></i></button></th>
        <th>Retards du jour <button type="button" class="btn btn-danger btn-xs" id="btn-addRetard" data-type="retard"><i class="fa fa-plus"></i></button></th>
    </tr>

    <tr id="listeInfos">

        {include file="listeInfos.tpl"}

    </tr>

</table>

<table class="table table-condensed table-absences">

    <tr>
        <th>
            <button type="button" class="btn btn-info btn-block" id="btn-chargeEduc">Éducateurs <i class="fa fa-arrow-right"></i> </button>
        </th>
        {foreach from=$periodes key=periode item=data}
            <th style="width:{$periodeWidth}%; text-align:center;">
                <span class="micro">{$periode}</span><br>{$data.debut}
                <button type="button" class="btn btn-xs pull-right btn-info btn-educ"
                    data-periode="{$periode}"
                    title="{if isset($listeEducs.$periode.acronyme)}{$listeEducs.$periode.prenom|default:''} {$listeEducs.$periode.nom|default:''}{/if}">
                    {$listeEducs.$periode.acronyme|default:'XXXXX'}
                </button>
            </th>
        {/foreach}
    </tr>

    {foreach from=$absences4day key=acronyme item=dataProf}
        <tr data-acronyme="{$acronyme}" class="{$dataProf.statutAbs}">

            {assign var=nomProf value=$listeNomsProfs.$acronyme}

            <th data-date="{$laDate}"
                data-acronyme="{$acronyme}"
                data-content="{$nomProf}"
                data-original-title=""
                data-toggle="popover"
                data-trigger="hover"
                data-container="body">
                <a href="#" class="badge badge-danger badge-xs pull-right btn-delFuture" title="Supprimer toutes les absences futures">
                    <i class="fa fa-forward"></i>
                </a>

                <div style="text-align:center">{$acronyme}</div><br>

                <a href="#" class="badge badge-success badge-xs pull-right btn-addFuture" title="Ajouter des absences supplémentaires" style="margin-top:2em;">
                    <i class="fa fa-forward"></i>
                </a>
                <button type="button" class="btn btn-primary btn-xs btn-viewProf"><i class="fa fa-eye"></i></button>

            </th>

            {foreach from=$periodes key=periode item=data}
                {assign var=heure value=$data.debut}
                {if isset($dataProf.$heure)}

                    <td class="{$listeStatuts.$acronyme.$heure.move|default:''}"
                        data-acronyme="{$acronyme}"
                        data-date="{$laDate}"
                        data-heure="{$data.debut}"
                        data-starttime="{$dataProf.$heure.startTime}">
                        <a href="#" class="badge badge-danger badge-xs pull-right btn-delAbs opacity0"><i class="fa fa-times"></i></a>

                        <div class="draggable hActive"
                            data-acronyme="{$acronyme}"
                            data-date="{$laDate}"
                            data-heure="{$heure}"
                            data-starttime="{$dataProf.$heure.startTime}"
                            draggable="true"
                            data-container="body"
                            data-placement="auto"
                            data-html="true"
                            data-original-title=""
                            data-title="{$dataProf.$heure.dateFR} {$heure}"
                            data-toggle="popover"
                            data-trigger="hover"
                            data-content="<div style='text-align:left'>{$acronyme} : {$nomProf}<br>
                                {$dataProf.$heure.matiere}<br>
                                Profs: {$dataProf.$heure.profs}<br>
                                Classes: {$dataProf.$heure.classes}<br>
                                Parties: {$dataProf.$heure.parties}<hr>
                                <div class='bottom'>{$dataProf.$heure.eduProf} | {$dataProf.$heure.remarque}</div>
                            </div>">

                            <div style="height:100%"
                                class="change-statut {' '|implode:$listeStatuts.$acronyme.$heure.normal|default:''}">
                                <span class="hidden-sm hidden-xs">{$dataProf.$heure.brancheFR|escape:html}<br></span>{$dataProf.$heure.classe|escape:html}<br>
                                {$dataProf.$heure.local|escape:html}
                            </div>
                        </div>

                        <a href="#" class="badge badge-success badge-xs pull-left opacity0 btn-edit"><i class="fa fa-edit"></i></a>
                        <div style="font-size: 1rem; text-align:right">
                        {if $dataProf.$heure.eduProf != ''}<i class="fa fa-graduation-cap fa-xs" title="{$dataProf.$heure.eduProf}"></i> {/if}
                        {if $dataProf.$heure.remarque != ''}<i class="fa fa-pencil fa-xs" title="{$dataProf.$heure.remarque}"></i> {/if}
                        </div>

                    </td>

                    {else}
                    <td class="drop" data-date="{$laDate}" data-heure="{$data.debut}" data-acronyme="{$acronyme}">
                        &nbsp;
                    </td>
                    {/if}

            {/foreach}

        </tr>
    {/foreach}

</table>

<script type="text/javascript">

    $('[data-toggle="popover"]').popover();

    $('.movedFrom > div').attr('draggable', false);
    $('.movedTo > div').attr('draggable', false);

</script>
