<h4>Listes existantes</h4>
<table class="table table-condensed table-striped">
<tr>
    <thead>
    <th>Listes</th>
    <th>Membres</th>
    </thead>
</tr>
<tbody>
{foreach from=$listesPerso key=idListe item=liste}
<tr>
    <td class="pop"
        data-container="body"
        data-original-title="{$liste.nomListe}: {$liste.membres|count|default:0} membres"
        data-content="{foreach from=$liste.membres key=acronyme item=wtf}{$acronyme} {/foreach}"
        data-placement="top">
        {$liste.nomListe}
    </td>
    <td>{$liste.membres|count}</td>
</tr>
{/foreach}
</tbody>
</table>
