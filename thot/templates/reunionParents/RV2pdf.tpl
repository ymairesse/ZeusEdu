<page backtop="15mm" backbottom="7mm" backleft="10mm" backright="10mm">
    <page_header>
    <p>{$entete}</p>
    </page_header>

<h3>Planning de la réunion de parents de {$nomProf.prenom} {$nomProf.nom}</h3>

    <!-- Les RV fixées -->
    <h4>Liste des rendez-vous</h4>
    <table class="table table-condensed" border="0" cellpadding="5" cellspacing="5" style="width:90%" style="border-collapse: collapse;">

        <thead>
            <tr>
                <th style="width:10%;border: 1px solid black;">Heure</th>
                <th style="width:10%;border: 1px solid black;">Élève</th>
                <th style="width:60%;border: 1px solid black;">Parent</th>
                <th style="width:10%;border: 1px solid black;">&nbsp;</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$listeRV key=id item=data}
            <tr>
                <td style="border: 1px solid black;">{$data.heure}</td>
                <td style="border: 1px solid black;">{$data.groupe} {$data.nom} {$data.prenom}</td>
                <td style="border: 1px solid black;">{$data.formule} {$data.nomParent} {$data.prenomParent}</td>
                <td style="border: 1px solid black;">&nbsp;</td>
                </tr>
            {/foreach}
        </tbody>

    </table>

    <!-- La liste d'attente -->
    <h4>Liste d'attente</h4>
    <table class="table table-condensed" border="0" cellpadding="5" cellspacing="5" width="100%" style="border-collapse: collapse;">
        <thead>
            <tr>
                <th style="border: 1px solid black; width:20%">Période</th>
                <th style="border: 1px solid black; width:30%">Élève</th>
                <th style="border: 1px solid black; width:30%">Parent</th>
                <th style="border: 1px solid black; width:20%">Contact</th>
            </tr>
        </thead>
        <tbody>
        {foreach from=$listeAttente item=data}

            <tr>
                <td style="border: 1px solid black">{$data.heures}</td>
                <td style="border: 1px solid black">{$data.groupe} {$data.nom} {$data.prenom}</td>
                <td style="border: 1px solid black">{$data.formule} {$data.nomParent} {$data.prenomParent} </td>
                <td style="border: 1px solid black">{if $data.mail != ''}{$data.mail}{else}&nbsp;{/if}</td>
            </tr>

        {/foreach}
        </tbody>
    </table>

</page>
