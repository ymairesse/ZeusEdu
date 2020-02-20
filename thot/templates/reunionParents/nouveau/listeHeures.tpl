<table class="table table-condensed">
    <tr>
        <th>&nbsp;</th>
        <th>Heure</th>
        <th>
            Publié<br>
            <input id="attribHeures" type="checkbox" title="" data-original-title="Attribuer tout" autocomplete="off"{if $readonly == 1} disabled{/if}>
        </th>
    </tr>

    {assign var=n value=1}
{foreach from=$listeHeuresRP item=uneHeure}
    <tr>
        <td>{$n}</td>
        <td>
            <input id="stuk_{$n}" class="rv form-control" type="text" value="{$uneHeure}" name="heure_{$n}" required="required" time="time" size="3"{if $readonly == 1} disabled{/if}>
        </td>
        <td>
            <input class="form-control cbHeure" type="checkbox" value="1" name="publie_{$n}"{if $readonly == 1} disabled{/if}>
        </td>
    </tr>

    {assign var=n value=$n+1}
{/foreach}

</table>
