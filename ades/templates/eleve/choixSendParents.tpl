<table class="table table-condensed">
    <tr>
        <th>&nbsp;</th>
        <th>Titre</th>
        <th>Nom</th>
        <th>Mail</th>
        <th>&nbsp;</th>
    </tr>

    {foreach $listeParents item=data}
    <tr>
        <td><input type="checkbox" class="sendTo" name="sendTo[]" value="{$data.mail}" {if ($data.mail == '')}disabled{/if}></td>
        <td>{$data.titre}</td>
        <td><strong>{$data.nom}</strong></td>
        <td><a href="mailto:{$data.mail}">{$data.mail}</a></td>
    </tr>
    {/foreach}
    {foreach $infoParentsThot key=userName item=dataThot}
        <tr>
            <td><input type="checkbox" class="sendTo" name="sendTo[]" value="{$dataThot.mail}"></td>
            <td>{$dataThot.lien}</td>
            <td><strong>{$dataThot.formule} {$dataThot.nom} {$dataThot.prenom}</strong></td>
            <td><a href="mailto:{$dataThot.mail}">{$dataThot.mail}</a></td>
            <td>{if $dataThot.confirme == 1}
                <img src="images/thotIco.png" title="Adresse confirmée">
                {else}
                <img src="images/nothotIco.png" title="Adresse NON confirmée">
                {/if}
            </td>
        </tr>
    {/foreach}
</table>
