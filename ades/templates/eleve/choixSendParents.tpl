<table class="table table-condensed">
    <tr>
        <th>&nbsp;</th>
        <th>Titre</th>
        <th>Nom</th>
        <th>Mail</th>
    </tr>

    {foreach $listeParents item=data}
    <tr>
        <td><input type="checkbox" class="sendTo" name="sendTo[]" value="{$data.mail}" {if ($data.mail == '')}disabled{/if}></td>
        <td>{$data.titre}</td>
        <td><strong>{$data.nom}</strong></td>
        <td><a href="mailto:{$data.mail}">{$data.mail}</a></td>
    </tr>
    {/foreach}
</table>
