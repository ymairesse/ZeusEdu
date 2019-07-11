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

<page backtop="15mm" backbottom="15mm" backleft="10mm" backright="10mm" footer="date">

    <page_header>
        <img src="{$BASEDIR}images/logoEcole.png" alt="LOGO" style="float:right; width:50px">
        <p>{$ECOLE}
            <br> {$ADRESSE} {$COMMUNE}
            <br>Téléphone: {$TELEPHONE}</p>
    </page_header>
    <page_footer>
        {$dataEleve.prenom} {$dataEleve.nom} {$dataEleve.classe}
    </page_footer>

    <h4>{$dataEleve.nom} {$dataEleve.prenom} {$dataEleve.classe}</h4>

    <p>Suite à {$datesRetards|@count} retards consécutifs, tu devras te présenter à <strong><u>7h50 précises</u></strong> à l'accueil de l'école aux dates suivantes:</p>

    <table style="width:100%; border: 2px solid #000">
        <tr>
            <th style="width:40%">Jour et date</th>
            <th style="width:60%">Cachet de l'accueil et paraphe</th>
        </tr>
        {foreach from=$datesSanction key=ref item=date}
            <tr>
                <td height=25 style="width:40%;">{$date}</td>
                <td height=25 style="width:60%;">&nbsp;</td>
            </tr>
        {/foreach}
        <tr>
            <td height=25 style="width:40%;">Signature des parents</td>
            <td height=25 style="width:60%;">&nbsp;</td>
        </tr>
    </table>

    <ul>
        <li>À la dernière présentation, l'accueil gardera ce billet pour le transmettre à ton éducateur</li>
        <li>Si tu es absent-e un de ces jours (avec motif), tu dois prendre contact avec ton éducateur de niveau <u>le jour de ton retour</u> pour fixer une nouvelle date</li>
    </ul>

</page>
