<page backtop="15mm" backbottom="7mm" backleft="20mm" backright="10mm">
    <page_header>
    <p>{$entete}</p>
    </page_header>

<h3>Planning de la réunion de parents de {$nomProf.prenom} {$nomProf.nom}</h3>

    <!-- Les RV fixées -->
    <h4>Liste des rendez-vous</h4>
    <table class="table table-condensed" border="0" cellpadding="5" cellspacing="5">

        <thead>
            <tr>
                <th>Heure</th>
                <th>Élève</th>
                <th>Parent</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$listeRV key=id item=data}
            <tr class="{if $data.heure >= $listePeriodes[3].min} attente3
                    {elseif $data.heure >= $listePeriodes[2].min} attente2
                    {else} attente1
                    {/if}
                    {if $data.dispo==0} indisponible{/if}">
                <td>{$data.heure}</td>
                <td>{$data.groupe} {$data.nom} {$data.prenom}</td>
                <td>{$data.formule} {$data.nomParent} {$data.prenomParent}</td>
                <td>&nbsp;</td>
                </tr>
            {/foreach}
        </tbody>

    </table>

    <!-- La liste d'attente -->
    <h4>Liste d'attente</h4>
    <table class="table table-condensed" border="0" cellpadding="5" cellspacing="5" width="100%">
        <thead>
            <tr>
                <th>Période</th>
                <th>Élève</th>
                <th>Parent</th>
                <th>Contact</th>
            </tr>
        </thead>
        <tbody>
        {foreach from=$listeAttente item=data}

            <tr>
                <td>{$data.heures}</td>
                <td>{$data.groupe} {$data.nom} {$data.prenom}</td>
                <td>{$data.formule} {$data.nomParent} {$data.prenomParent} </td>
                <td>{if $data.mail != ''}{$data.mail}{else}&nbsp;{/if}</td>
            </tr>

        {/foreach}
        </tbody>
    </table>

</page>
