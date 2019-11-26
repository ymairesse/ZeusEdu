<page backtop="30mm" backbottom="20mm" backleft="10mm" backright="10mm">
    <page_header>
        <h3>Synthèse des retards et traitements</h3>
         <p style="text-align:center;">Du {$debut} au {$fin} </p>
         {$groupe}
    </page_header>
    <page_footer>
        {$acronyme} le {$smarty.now|date_format:"%A %d %B %Y "}
    </page_footer>


    <table style="border-collapse: collapse; width:100%">
        <thead>
            <tr style="border:1px solid black">
                <th style="width:30%; border:1px solid #555; text-align:center;">Nom</th>
                <th style="width:30%; border:1px solid #555; text-align:center;">Dates sanction</th>
                <th style="width:20%; border:1px solid #555; text-align:center;">Date retour</th>
                <th style="width:20%; border:1px solid #555; text-align:center;">Retards</th>
            </tr>
        </thead>

        <tbody>
            {foreach from=$listeRetards key=matricule item=data}
                {foreach from=$data key=idTraitement item=unTraitement}
                <tr style="padding-bottom:1em;">
                    <td style="border:1px solid #555">{$unTraitement.npc}</td>
                    <td style="border:1px solid #555; text-align:center;">{$unTraitement.datesSanction|implode:'<br>'}</td>
                    <td style="border:1px solid #555; text-align:center;">{$unTraitement.dateRetour|truncate:5:''|default:"-"}</td>
                    <td style="border:1px solid #555; text-align:center;">{$allRetards.$matricule|@count}</td>
                </tr>
                {/foreach}
            {/foreach}
        </tbody>

    </table>

</page>
