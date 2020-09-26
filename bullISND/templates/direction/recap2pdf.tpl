<style type="text/css">
    table .titre {
        border: 0;
        width: 100%
    }

    table.cours {
        border-collapse: collapse;
        width: 100%;
        text-align:center;
        margin:auto;
        width:100%;
        margin-top: 5px;
        margin-bottom: 15px;
    }

    table.cours td {
        font-size: 8pt;
        border: 1px solid #555;
    }

    table.eprExt {
        border-collapse: collapse;
        width: 100%;
        font-size: 12px;
        text-align:center;
        margin-top: 10px;
        margin-bottom: 5px;
    }

    table.eprExt th {
        font-size:12px;
        background-color: #ccc;
    }

    table.eprExt td {
        height: 24px;
    }

    h1 {
        font-size: 20pt;
        font-weight: normal;
        text-align: center;
        text-decoration: underline;
    }

    p.mentions {
        font-size: 30px;
        text-align: center;
        margin-top: 20px;
        border: 1px solid black;
    }

</style>

<page backtop="10mm" backbottom="10mm" backleft="10mm" backright="15mm">

    <table class="titre">
        <tr>
            <td><img src="../../../images/logoEcole.png" style="margin-right:40px"></td>
            <td style="text-align:center"><h1>Récapitulatif des résultats obtenus au premier degré par<br>
                <strong>{$dataEleve.nom} {$dataEleve.prenom}</strong></h1></td>
        </tr>
    </table>

{if isset($anneeScolairePrecedente)}
    <h1 style="">{$anneeEtudePrecedente}e année ({$anneeScolairePrecedente.anScol})</h1>
    <table class="cours">
        <tr>
            {foreach from=$infoAnneePrecedente key=coursGrp item=dataCours}
            <td style="width:{$tdWidthPrec}%;">{$dataCours.libelle}</td>
            {/foreach}
        </tr>
        <tr>
            {foreach from=$infoAnneePrecedente key=coursGrp item=dataCours}
            <td style="border: 1px solid black; font-size: 12pt"><strong>{$dataCours.sitDelibe} %</strong></td>
            {/foreach}
        </tr>
    </table>
{/if}

    <h1>{$anneeEtude}e année ({$anneeScolaire})</h1>
    <table class="cours">
        <tr>
            {foreach from=$infoAnneeScolaire key=coursGrp item=dataCours}
            <td style="width:{$tdWidthAct}%;">{$dataCours.libelle}</td>
            {/foreach}
        </tr>
        <tr>
            {foreach from=$infoAnneeScolaire key=coursGrp item=dataCours}
            <td style="border: 1px solid black; font-size: 12pt">{if ($dataCours.sitDelibe == Null)}Non Év.{else}<strong>{$dataCours.sitDelibe} %</strong>{/if}</td>
            {/foreach}
        </tr>

    </table>

{if isset($infoEprExterne)}
    <table class="eprExt">

        <tr>
            {foreach from=$infoEprExterne key=coursGrp item=dataCours}
            <th style="width:{$tdWidthCE1D}%;border: 1px solid black;"><strong>CE1D</strong><br>{$dataCours.libelle}</th>
            {/foreach}
        </tr>
        <tr>
            {foreach from=$infoEprExterne key=coursGrp item=dataCours}
            <td style="border: 1px solid black; font-size: 12pt"><strong>{if ($dataCours.coteExterne != '')}{$dataCours.coteExterne} %{else} - {/if}</strong></td>
            {/foreach}
        </tr>

    </table>
{/if}
    <p class="mentions" style="margin-top:40px;">Mention finale: <strong>{$infoMention}</strong></p>

    <p class="mentions">Obtention du CE1D: <strong>{$decision}</strong></p>

</page>
