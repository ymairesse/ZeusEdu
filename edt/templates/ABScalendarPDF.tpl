<style media="print">

table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
  font-size: 8pt;
}

.void {
    height: 30px;
    border: 1px solid #999;
}

{include file='../edt.css'}

</style>

<page backtop="7mm" backbottom="7mm" backleft="10mm" backright="10mm">

    <page_header>
        Absences du {$laDate}
    </page_header>
    <page_footer>
        [[page_cu]]/[[page_nb]]
    </page_footer>

<table class="table" style="width:100%">
    <tr>
        <th style="width:67%;" colspan="2">Infos du jour</th>
        <th style="width:33%;">Retards du jour</th>
    </tr>

    <tr>

        {include file="listeInfos.tpl"}

    </tr>

</table>

<table class="table table-condensed" style="width:100%">
    <tr>
        <th style="width:{$periodeWidth}%">&nbsp;</th>
        {foreach from=$periodes key=periode item=data}
            <th style="text-align:center;width:{$periodeWidth}%;">{$periode}<br>{$data.debut}</th>
        {/foreach}
    </tr>

    {foreach from=$absences4day key=acronyme item=dataProf}
        <tr>

            {assign var=nomProf value=$listeNomsProfs.$acronyme}

            <th style="text-align:center;">
                {$acronyme}
            </th>

            {foreach from=$periodes key=periode item=data}
                {assign var=heure value=$data.debut}
                {if isset($dataProf.$heure)}

                    <td class="change-statut {' '|implode:$listeStatuts.$acronyme.$heure.normal|default:''}">

                            {$dataProf.$heure.brancheFR|escape:html}<br>
                            <span style="font-size:6pt">{$dataProf.$heure.classe|escape:html}</span><br>
                            {$dataProf.$heure.local|escape:html}

                        <p style="font-size:8pt">{$dataProf.$heure.eduProf}
                        {if $dataProf.$heure.remarque != ''} -> {$dataProf.$heure.remarque|truncate:10:'...'}{/if}</p>

                    </td>

                    {else}
                    <td>
                        &nbsp;
                    </td>
                    {/if}

            {/foreach}

        </tr>
    {/foreach}

    {foreach from=array(1,2) item=wtf}

        <tr>
            <th class="void">&nbsp;</th>
            {foreach from=$periodes key=periode item=wtf}
            <td>&nbsp;</td>
            {/foreach}
        </tr>
    {/foreach}

</table>


</page>
