<table class="table table-bordered">
    
    <tr>
        <th>&nbsp;</th>
        <th>&nbsp;</th>
        {foreach from=$listePeriodes item=periode}
            {assign var=laPeriode value=$periode-1}
            <th colspan=2 style="text-align:center">{$periode}<br>{$NOMSPERIODES.$laPeriode}</th>
        {/foreach}
    </tr>
    <tr>
        <th>Cours</th>
        <th>Libelle</th>
        {foreach from=$listePeriodes item=periode}
            <th style="text-align:center">Form</th>
            <th style="text-align:center">Cert</th>
        {/foreach}
    </tr>

    {foreach from=$listeCours key=cours item=dataCours}
        <tr>
            <td><strong>{$cours}</strong></td>
            <td>{$dataCours.libelle}</td>
            {foreach from=$listePeriodes item=periode}
            {if isset($ponderations.$cours)}
                <td>{$ponderations.$cours.ponderations.$periode.form}</td>
                <td>{$ponderations.$cours.ponderations.$periode.cert}</td>
            {else}
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            {/if}
            {/foreach}
        </tr>
    {/foreach}

</table>
