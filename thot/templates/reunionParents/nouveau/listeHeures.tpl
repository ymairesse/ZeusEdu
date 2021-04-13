<table class="table table-condensed">
    <tr>
        <th>&nbsp;</th>
        <th>Heure</th>
        <th style="text-align:center">
            Publié<br>
            <input id="attribHeures" type="checkbox" title="Attribuer tout">
        </th>
    </tr>

{foreach from=$listeHeuresRP item=uneHeure name=boucle}
    <tr>
        <td>{$smarty.foreach.boucle.iteration}</td>
        <td>
            <input id="stuk_{$smarty.foreach.boucle.iteration}" class="rv form-control" type="text" value="{$uneHeure}" name="heure_{$smarty.foreach.boucle.iteration}" required="required" time="time" size="3">
        </td>
        <td style="text-align:center">
            <input class="cbHeure" type="checkbox" value="1" name="publie_{$smarty.foreach.boucle.iteration}">
        </td>
    </tr>
{/foreach}

</table>
