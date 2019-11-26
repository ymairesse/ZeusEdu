<style>
    td,
    th {
        border: solid 1px #ccc; border-collapse: collapse;
        padding: 5px;
        font-size: 8pt;
    }
    p, li {
        font-size: 8pt;
    }

</style>

<page backtop="15mm" backbottom="10mm" backleft="10mm" backright="10mm" footer="date">

    <page_header>
        <img src="{$BASEDIR}images/logoEcoleBlanc.png" alt="LOGO" style="float:right; width:40px;">
        <p>{$ECOLE}
        <br> {$ADRESSE} {$COMMUNE}</p>
    </page_header>

    <table style="width:100%; border:0 solid white;">
        <tr style="border:0;">
            <td style="width:80%">
                <h4>{$dataEleve.nom} {$dataEleve.prenom} {$dataEleve.classe}</h4>
            </td>
            <td style="width:20%;">
                {$dataTraitement.dateTraitement|ucfirst}<br>
                <barcode dimension="1D" type="EAN13" value="{$idTraitement}" label="label" style="width:40mm; height:10mm; color: #000000; font-size: 3mm"></barcode>
            </td>
        </tr>
    </table>

    <p>Suite à {$datesRetards|@count} retard{if $datesRetards|@count > 1}s consécutifs{/if}, tu devras te présenter à <strong><u>7h50 précises</u></strong> à l'accueil de l'école aux dates suivantes:</p>

    <table style="width:100%; border: 2px solid #000">
        <tr>
            <th style="width:40%">Jour et date</th>
            <th style="width:60%">Cachet de l'accueil et paraphe</th>
        </tr>
        {foreach from=$datesSanction key=ref item=date}
            <tr>
                <td height=15 style="width:40%;">{$date}</td>
                <td height=15 style="width:60%;">&nbsp;</td>
            </tr>
        {/foreach}
        <tr>
            <td height=15 style="width:40%;">Signature des parents</td>
            <td height=15 style="width:60%;">&nbsp;</td>
        </tr>
    </table>

    <ul>
        <li>À la dernière présentation, l'accueil gardera ce billet pour le transmettre à ton éducateur</li>
        <li>Si tu es absent-e un de ces jours (avec motif), tu dois prendre contact avec ton éducateur de niveau <u>le jour de ton retour</u> pour fixer une nouvelle date</li>
    </ul>

</page>
