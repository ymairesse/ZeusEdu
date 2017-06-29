<style>
    td,
    th {
        border: solid 1px #ccc; border-collapse: collapse;
        padding: 5px;
        font-size: 9pt;
    }
</style>

<page backtop="25mm" backbottom="7mm" backleft="7mm" backright="10mm" footer="date">
    <page_header>
        <img src="../../images/logoEcole.png" alt="LOGO" style="float:right">
        <p>{$ECOLE}
            <br> {$ADRESSE} {$COMMUNE}
            <br>Téléphone: {$TELEPHONE}</p>
    </page_header>
    <page_footer>
        {$debut} à {$fin}
    </page_footer>

    <h4>Année scolaire {$ANNEESCOLAIRE} - en date du {$DATE}</h4>

    <p>Période: du {$debut} au {$fin}</p>
    <p>{$groupe}</p>

    <table style="width:100%">
        <thead>
            <tr style="width:100%">
                <th style="width: 20%">Nombre de faits</th>
                <th style="width: 80%">Type de fait</th>
            </tr>
        </thead>
        {foreach from=$statistiques item=typeFait}
        <tr style="background-color: {$typeFait.couleurFond}; color: {$typeFait.couleurTexte}">
            <td>{$typeFait.nbFaits}</td>
            <td>{$typeFait.titreFait}</td>
        </tr>
        {/foreach}
    </table>

</page>
